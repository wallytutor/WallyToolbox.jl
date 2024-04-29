# XXX: WORKING ON THESE!


################################################################################
# FUNCTIONALITIES
################################################################################

# TODO maybe typing is a problem here!
# function meanmolecularmass(
#     Y::Union{Vector{Float64},SubArray},
#     W::Vector{Float64}
#     )::Float64
#     return 1.0 / sum(@. Y / W)
# end

function meanmolecularmass(Y, W)
    """ Mixture mean molecular mass [kg/mol]. """
    return 1.0 / sum(@. Y / W)
end

function massfraction2molefraction(Y, W::Vector{Float64})
    """ Convert mass fractions to mole fractions. """
    return meanmolecularmass(Y, W) * @. Y / W
end

function molefraction2massfraction(X, W::Vector{Float64})
    """ Convert mole fractions to mass fractions. """
    return (@. X * W) / sum(@. X * W)
end

################################################################################
# GAS PHASE MODELS
################################################################################

""" Named access to transport models. """
const TRANSPORT_MODELS = Dict("gas" => :LennardJonesTransport)

struct LennardJonesTransport <: AbstractTransportModel
    """ Lennard-Jones ideal gas transport model. """

    geometry::String
    welldepth::Float64
    diameter::Float64
    polarizability::Float64
    rotationalrelaxation::Float64

    function LennardJonesTransport(transport)
        return new(
            transport["geometry"],
            get(transport, "well-depth", 0.0),
            get(transport, "diameter", 0.0),
            get(transport, "polarizability", 0.0),
            get(transport, "rotational-relaxation", 0.0)
        )
    end
end

struct IdealGasThermo <: AbstractGasThermo
    """ Ideal gas phase thermodynamics model. """

    model::String
    temperature_ranges::Vector{Float64}
    data::Vector{Vector{Float64}}
    specificheat::Function
    enthalpy::Function

    function IdealGasThermo(thermo; verbose = true)
        model = lowercase(thermo["model"])
        rngs = thermo["temperature-ranges"]
        data = thermo["data"]
        func = getthermo(model, data, rngs..., verbose)
        return new(model, rngs, data, func[1], func[2])
    end
end

struct IdealGasSpecies
    """ Ideal gas phase species model. """

    name::String
    composition::Dict{String, Int64}
    transport::AbstractTransportModel
    thermo::IdealGasThermo
    molecularmass::Float64

    function IdealGasSpecies(species; verbose = true)
        composition = species["composition"]
        transport = species["transport"]["model"]
        model = getfield(DryTooling, TRANSPORT_MODELS[transport])

        new(species["name"],
            composition,
            model(species["transport"]),
            IdealGasThermo(species["thermo"], verbose = verbose),
            sum(n * elementmass(s) for (s, n) in composition))
    end
end

struct IdealGasMixture
    """ Ideal gas phase mixture model. """

    species::Vector{IdealGasSpecies}
    molecularmasses::Vector{Float64}
    nspecies::Int32

    function IdealGasMixture(
            data::Dict{Any, Any},
            selected::Vector{String}
        )
        nspecies = length(selected)
        species = Vector{IdealGasSpecies}(undef, nspecies)
        molecularmasses = zeros(nspecies)

        for (i, name) in enumerate(selected)
            thisone = getnameditem(data["species"], name)
            species[i] = IdealGasSpecies(thisone)
            molecularmasses[i] = mass(species[i])
        end

        return new(species, molecularmasses, nspecies)
    end
end

struct GasMixtureComponent <: AbstractMixtureSubstance
    """ Simplified component for use with mixtures in chemical reactors. """

    "Mean molecular mass [g/mol]"
    W::Float64

    "Viscosity polynomial [Pa.s]"
    μ::Polynomial{Float64, :T}

    "Thermal conductivity polynomial [W/(m.K)]"
    k::Polynomial{Float64, :T}

    "Specific heat polynomial [J/(kg.K)]"
    c::Polynomial{Float64, :T}

    function GasMixtureComponent(;
            W::Float64,
            μ::Vector{Float64},
            k::Vector{Float64},
            c::Vector{Float64}
        )
        return new(
            W,
            Polynomial(μ, :T),
            Polynomial(k, :T),
            Polynomial(c, :T)
        )
    end
end

struct GasMixturePhase <: AbstractMixturePhase
    """ Simplified gas phase for use with mixtures in chemical reactors. """

    "Number of components in system."
    K::Int64

    "Storage of gas component objects."
    s::Vector{GasMixtureComponent}

    function GasMixturePhase(; components::Vector{GasMixtureComponent})
        return new(length(components), components)
    end
end

function GasMixtureComponent(d::Dict{Any, Any})
    return GasMixtureComponent(;
        W = d["W"],
        μ = d["mu"],
        k = d["kg"],
        c = d["cp"]
    )
end

function GasMixturePhase(d::Dict{Any, Any}; order::Any = nothing)
    order = isnothing(order) ? keys(d) : order
    components = map(k->GasMixtureComponent(d[k]), order)
    return GasMixturePhase(; components = components)
end

function specificheatmass(species::IdealGasSpecies, T)
    """ Species specific heat in mass units [J/(kg.K)]. """
    return species.thermo.specificheat(T) / mass(species)
end

function specificheatmole(species::IdealGasSpecies, T)
    """ Species specific heat in mole units [J/(mol.K)]. """
    return species.thermo.specificheat(T)
end

function enthalpymass(species::IdealGasSpecies, T)
    """ Species enthalpy in mass units [J/kg]. """
    return species.thermo.enthalpy(T) / mass(species)
end

function enthalpymole(species::IdealGasSpecies, T)
    """ Species enthalpy in mole units [J/mol]. """
    return species.thermo.enthalpy(T)
end

function meanmolecularmass(mix::IdealGasMixture, Y)
    """ Mixture mean molecular mass [kg/mol]. """
    return meanmolecularmass(Y, mix.molecularmasses)
end

function densitymass(mix::IdealGasMixture, T, P, Y)
    """ Mixture specific mass [kg/m³]. """
    return P * meanmolecularmass(mix, Y) / (GAS_CONSTANT * T)
end

function concentration(mix::IdealGasMixture, T, P, Y)
    """ Mixture concentration [mol/m³]. """
    return densitymass(mix, T, P, Y) * (@. Y / mix.molecularmasses)
end

function specificheatmass(mix::IdealGasMixture, T, Y)
    """ Mixture mass-averaged specific heat [J/(kg.K)]. """
    contrib(s, y) = specificheatmass(s, T) * y
    return sum(contrib(s, y) for (s, y) ∈ zip(mix.species, Y))
end

function molecularmasses(m::GasMixturePhase)::Vector{Float64}
    """ Get array of molecular masses from mixtures [g/mol]. """
    return map(x->x.W, m.s)
end

function idealgasdensity(T::Float64, P::Float64, W::Float64)::Float64
    """ Mixture specific mass [kg/m³]. """
    return P * W / (1000GAS_CONSTANT * T)
end

function idealgasdensity(
    T::Float64,
    P::Float64,
    Y::Union{Vector{Float64},SubArray};
    W::Vector{Float64}
    )::Float64
    """ Mixture specific mass [kg/m³]. """
    return idealgasdensity(T, P, meanmolecularmass(Y, W))
end

function thermophysicalproperties(
    s::GasMixtureComponent,
    T::Float64
    )::Matrix{Float64}
    """ Viscosity, thermal conductivity, and specific heat. """
    return [s.μ(T) s.k(T) s.c(T)]
end

function thermophysicalproperties(
    m::GasMixturePhase,
    T::Float64,
    Y::Union{Vector{Float64},SubArray}
    )::Matrix{Float64}
    """ Viscosity, thermal conductivity, and specific heat. """
    return sum(y*thermophysicalproperties(s, T) for (s, y) in zip(m.s, Y))
end

function mixtureproperties(
        T::Float64,
        P::Float64,
        Y::Union{Vector{Float64},SubArray};
        m::GasMixturePhase,
        W::Vector{Float64}
    )::Matrix{Float64}
    """ Density, viscosity, thermal conductivity, and specific heat. """
    ρ = idealgasdensity(T, P, Y; W=W)
    μ, k, c = thermophysicalproperties(m, T, Y)
    return [ρ μ k c]
end

function mixtureproperties(
        T::Vector{Float64},
        P::Vector{Float64},
        Y::Matrix{Float64};
        m::GasMixturePhase,
        W::Vector{Float64}
    )::Vector{Matrix{Float64}}
    """ Density, viscosity, thermal conductivity, and specific heat. """
    return mixtureproperties.(T, P, eachrow(Y); m = m, W = W)
end

function convertsccmtomassflow(q, M)
    """ Convert flow rate from SCCM to kg/s. """
    return idealgasdensity(ZERO_CELSIUS, ONE_ATM, M) * q / 6.0e+07
end

# % Mixture mass-averaged enthalpy [J/kg].
# function [h] = enthalpy_mass(self, T, Y)
# h = sum((Y .* self.enthalpies_mass(T))')';
# endfunction

# % Matrix of species enthalpies [J/kg].
# function [hs] = enthalpies_mass(self, T)
# hs = [];
# for k=1:self.n_species
#     hs = horzcat(hs, self.species{k}.enthalpy_mole(T) ./ self.mw(k));
# endfor
# endfunction

# % Heat release rate [W/m³].
# function hdot = heat_release_rate(self, h, mdotk)
# hdot = sum((mdotk .* h)')';
# endfunction

# mutable struct IdealGasSolution
#     mix::IdealGasMixture
#     T::Num
#     P::Num
#     Y::AbstractArray

#     function IdealGasSolution(mix::IdealGasMixture)
#         new(mix, 300.0, ONE_ATM, zeros(mix.nspecies))
#     end
# end

# """ Mixture composition in mole fractions. """
# function massfractions(gas::IdealGasSolution)
#     return gas.Y
# end

# """ Mixture composition in mole fractions. """
# function molefractions(gas::IdealGasSolution)
#     return massfraction2molefraction(gas.Y, gas.mix.molecularmasses, )
# end

#############################################################################
# Private
#############################################################################

function mass(s::IdealGasSpecies)
    """ Retrieve atomic mass of species [kg/mol]. """
    return s.molecularmass / 1000
end

function getnameditem(data, name)
    """ Query first item matching name in dictionary. """
    return first(filter(s -> s["name"] == name, data))
end

function nasa7specificheat(T, c)
    """ Molar specific heat from NASA7 polynomial [J/(mol.K)]. """
    p = c[1]+T*(c[2]+T*(c[3]+T*(c[4]+c[5]*T)))
    return GAS_CONSTANT * p
end

function nasa7enthapy(T, c)
    """ Molar enthalpy from NASA7 polynomial [J/mol]. """
    d = c[1:5] / collect(1:5)
    p = d[1]+T*(d[2]+T*(d[3]+T*(d[4]+d[5]*T)))+c[6]/T
    return GAS_CONSTANT * T * p
end

function getthermo(model, data, xl, xc, xh, verbose)
    """ Create specific heat and enthalpy functions for species. """
    cpname = string(model, "specificheat")
    hmname = string(model, "enthapy")

    cpfun = getfield(DryTooling, Symbol(cpname))
    hmfun = getfield(DryTooling, Symbol(hmname))

    cp = makestepwise1d(T -> cpfun(T, data[1]),
                        T -> cpfun(T, data[2]),
                        xc, differentiable = true)

    hm = makestepwise1d(T -> hmfun(T, data[1]),
                        T -> hmfun(T, data[2]),
                        xc, differentiable = true)

    function prewarning(T, f)
        if !(T isa Num) && (T < xl || T > xh)
            @warn "Temperature out of range = $(T)K"
        end
        return f(T)
    end

    specificheat = verbose ? (T -> prewarning(T, cp)) : cp
    enthalpy = verbose ? (T -> prewarning(T, hm)) : hm
    return specificheat, enthalpy
end

# function [wdot] = wdot_mak(self, z, T, Y, L)
#     % Mass action kinetics methane combustion rate [kg/(m³.s)].
#     k0 = 1.1e+07;
#     Ea = 83680.0;

#     X = self.mass_to_mole_fraction(Y);
#     C = (X * self.PRESSURE ./ (self.GAS_CONSTANT .* T));
#     k = k0 * exp(-Ea ./ (self.GAS_CONSTANT .* T));
#     rt = k .* C(:, 1) .* C(:, 2).^0.5;

#     wdot = rt * (self.mw .* self.SPECIES_COEFS);
# endfunction

# function [wdot] = wdot_ebu(self, z, T, Y, L)
#     % Eddy break-up kinetics methane combustion rate [kg/(m³.s)].
#     cr = 4.000e+00;
#     bo = 4.375e+00;
#     k0 = 1.600e+10;
#     Ea = 1.081e+05;

#     k = k0 * exp(-Ea ./ (self.GAS_CONSTANT .* T));
#     rho = self.density_mass(T, self.PRESSURE, Y);
#     yf = Y(:, 1);
#     yo = Y(:, 2);

#     % TODO implement this in ProjectData
#     ke = z ./ L;

#     R_ebu = (rho.^1) .* cr .* ke .* min(yf, yo ./ bo);
#     R_arr = (rho.^2) .* yf .* yo .* k;

#     rt = min(R_ebu, R_arr) / self.mw(1);

#     wdot = rt * (self.mw .* self.SPECIES_COEFS);
# endfunction

# function [mu] = viscosity(self, T, Y)
#     % Gas molecular viscosity [Pa.s].
#     mu = 1.0e-05 * (0.1672 * sqrt(T) - 1.058);
# endfunction

# function [k] = thermal_conductivity(self, T, Y)
#     % Gas thermal conductivity [W/(m³.K)].
#     k = 1.581e-17;
#     k = T .* k - 9.463e-14;
#     k = T .* k + 2.202e-10;
#     k = T .* k - 2.377e-07;
#     k = T .* k + 1.709e-04;
#     k = T .* k - 7.494e-03;
# endfunction

################################################################################
# SOLID PHASE MODELS
################################################################################

struct MaterialTransportProperties <: AbstractSolidTransport
    """
        MaterialTransportPolynomial
    
    Transport properties for a solid material.
    
    $(TYPEDFIELDS)
    """

    """ Thermal conductivity [W/(m.K)]. """
    k::Function

    """ Emissivity [-]. """
    ε::Function

    function MaterialTransportProperties(;
            k::Function,
            ε::Function
        )
        return new(k, ε)
    end
end

struct MaterialPowderBed <: AbstractSolidMaterial
    """
        MaterialPowderBed
    
    Description of a powder bed material for a rotary kiln.
    
    $(TYPEDFIELDS)
    """

    """ Density [kg/m³]. """
    ρ::Float64

    """ Repose angle [rad]. """
    γ::Float64

    """ Solid packing fraction [-]. """
    ϕ::Float64

    """ Particle mean diameter [m]. """
    d::Float64

    """ Molar mass [kg/mol]. """
    M::Float64

    """ Thermal conductivity [W/(m.K)]. """
    k::Function

    """ Emissivity [-]. """
    ε::Function

    """ Molar specific heat [J/(mol.K)]. """
    cₚ::Function

    """ Molar enthalpy [J/mol]. """
    h::Function

    """ Molar entropy [J/K]. """
    s::Function

    """ Access to thermodynamic model. """
    thermo::AbstractSolidThermo

    """ Access to transport model. """
    transport::AbstractSolidTransport

    function MaterialPowderBed(;
            ρ::Float64,
            γ::Float64,
            ϕ::Float64,
            d::Float64,
            M::Float64,
            thermo::AbstractSolidThermo,
            transport::AbstractSolidTransport
        )
        return new(
            ρ, γ, ϕ, d, M,
            transport.k,
            transport.ε,
            thermo.cₚ,
            thermo.h,
            thermo.s,
            thermo, transport
        )
    end
end

# function MaterialShomate(data::Dict{Any, Any})
#     return MaterialShomate(; a_lo = data["coefs_low"],
#                              a_hi = data["coefs_high"],
#                              T_ch = data["change_temperature"])
# end

function MaterialTransportProperties(data::Dict{Any, Any})
    return MaterialTransportProperties(;
        k = eval(Meta.parse(data["thermal_conductivity"])),
        ε = eval(Meta.parse(data["emissivity"])))
end

function MaterialPowderBed(data::Dict{Any, Any})
    thermomodel = getfield(DryTooling, Symbol(data["thermo"]["type"]))
    transportmodel = getfield(DryTooling, Symbol(data["transport"]["type"]))

    return MaterialPowderBed(;
        ρ = data["density"],
        γ = deg2rad(data["repose_angle"]),
        ϕ = data["solid_filling"],
        d = data["particle_diam"],
        M = data["molar_mass"],
        thermo = thermomodel(data["thermo"]),
        transport = transportmodel(data["transport"])
    )
end

################################################################################
# DIFFUSION GENERAL
################################################################################

function diffusiontimescale(R::Float64, α::Float64)::Float64
    "Dimensional analysis time-scale of diffusion process."
    return 2 * R^2 / α
end

function diffusiontimescale(R::Float64, ρ::Float64,
                            c::Float64, κ::Float64)::Float64
    "Dimensional analysis time-scale of diffusion process."
    return diffusiontimescale(R, κ / (ρ * c))
end

function interfaceconductivity1D(κ::Vector{Float64})
    "Interface thermal conductivity assuming equidistant centers."
    κₛ, κₙ = head(κ), tail(κ)
    return @. 2 * κₛ * κₙ / (κₛ + κₙ)
end

struct Temperature1DModelStorage <: AbstractSolutionStorage
    "Data storage for 1D temperature solution models."

    "Tracker for time points."
    t::Vector{Float64}

    "Tracker for surface heat flux."
    Q::Vector{Float64}

    "Tracker for intermediate temperature solutions."
    T::Matrix{Float64}

    function Temperature1DModelStorage(N, M)
        return new(zeros(M), zeros(M), zeros(M, N))
    end
end
