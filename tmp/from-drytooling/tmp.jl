# XXX: WORKING ON THESE!

# -*- coding: utf-8 -*-
# using DryTooling
# using DryTooling.FluidModels

# @testset "Gas Phase Models" begin
#     # @test begin
#     #    selected = ["CH4", "O2", "CO2", "H2O", "N2"]
#     #    gas = dry.IdealGasMixture(data, selected)
#     #    M = gas.molecularmasses
#     #    species = gas.species[end]

#     #    Tnum = 1000.0
#     #    @parameters Tsym
#     #    @variables Tvar

#     #    Ynum = ones(gas.nspecies) / gas.nspecies
#     #    @parameters Ysym[1:gas.nspecies]

#     #    gas.Y[1:end] = Ynum

#     #    dry.specificheatmass(species, Tnum)
#     #    dry.specificheatmass(species, Tsym)
#     #    dry.specificheatmass(species, Tvar)

#     #    dry.enthalpymass(species, Tnum)
#     #    dry.enthalpymass(species, Tsym)
#     #    dry.enthalpymass(species, Tvar)

#     #    dry.specificheatmole(species, Tnum)
#     #    dry.specificheatmole(species, Tsym)
#     #    dry.specificheatmole(species, Tvar)

#     #    dry.enthalpymole(species, Tnum)
#     #    dry.enthalpymole(species, Tsym)
#     #    dry.enthalpymole(species, Tvar)

#     #    dry.meanmolecularmass(Ynum, M)
#     #    dry.meanmolecularmass(Ysym, M)

#     #    dry.massfraction2molefraction(Ynum, M)
#     #    dry.massfraction2molefraction(Ysym, M)

#     #    dry.molefraction2massfraction(Ynum, M)
#     #    dry.molefraction2massfraction(Ysym, M)

#     #    dry.meanmolecularmass(gas)
#     #    dry.densitymass(gas)
#     #    sum(dry.massfractions(gas)) ≈ 1.0
#     #    sum(dry.molefractions(gas)) ≈ 1.0
#     #    dry.specificheatmass(gas)
#     # end
# end

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
