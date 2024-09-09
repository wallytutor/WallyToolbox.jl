##############################################################################
# COMBUSTION
##############################################################################

export EmpiricalFuel
export RosinRammlerDroplet

export oxidizer_mass_flow_rate
export hfo_empirical_formula
export hfo_specific_heat
export hfo_enthalpy_net_bs2869

export fit_rosinrammler
export plot_rosinrammler

##############################################################################
# Empirical fuel
##############################################################################

"""
Provides description of an empirical fuel based on elemental mass fractions.

## Fields

$(TYPEDFIELDS)

## Examples

Below we illustrate how to create a fuel with the approximate mass fractions
of carbon and hydrogen in naphtalene; next we check its string representation.

```jldoctest
julia> fuel = EmpiricalFuel([0.937, 0.063, 0.0]; scaler=:C=>10.0);

julia> fuel.X
3-element Vector{Float64}:
 10.0
  8.011606189967983
  0.0

julia> String(fuel)
"C(10.000000)H(8.011606)O(0.000000)"
```
"""
struct EmpiricalFuel
    "Chemical elements reported in fuel."
    elements::Vector{Symbol}

    "Array of provided masses per kilogram of fuel."
    Y::Vector{Float64}
    
    "Array of computed moles per kilogram of fuel."
    X::Vector{Float64}

    function EmpiricalFuel(Y; elements = [:C, :H, :O], scaler = nothing)
        if length(elements) != length(Y)
            throw(ErrorException("Length of Y must be the same as elements"))
        end

        if length(elements) != length(Set(elements))
            throw(ErrorException("Elements must be a set of unique values"))
        end
        
        Y = Y ./ sum(Y)
        X = Y ./ atomicmass.(elements)

        if !isnothing(scaler)
            scaler.first in elements || begin
                throw(ErrorException("Scaling element not in elements list"))
            end
            X = scaler.second.* X ./ X[findall(==(scaler.first), elements)]
        end

        return new(elements, Y, X)
    end
end

function Base.String(f::EmpiricalFuel)
    fmt(e, x) = @sprintf("%s(%.6f)", e, x)
    return join(map(args->fmt(args...), zip(f.elements, f.X)))
end

"""
    oxidizer_mass_flow_rate(f::EmpiricalFuel; y_o2 = 0.23)

Computes the required amount of oxidizer to perform complete combustion
of 1 kg provided empirical fuel. The value of `y_o2` represents the mass
fraction of oxygen in oxidizer; default value is typical for air.

```jldoctest
julia> fuel = EmpiricalFuel([0.937, 0.063, 0.0]; scaler=:C=>10);

julia> oxidizer_mass_flow_rate(fuel)
13.02691759229764
```
"""
function oxidizer_mass_flow_rate(f::EmpiricalFuel; y_o2 = 0.23)
    m_o2 = molecularmass(Stoichiometry(; O = 2))

    fn = EmpiricalFuel(f.Y; f.elements, scaler=nothing)

    x = fn.X[findall(==(:C), fn.elements) |> first]
    y = fn.X[findall(==(:H), fn.elements) |> first]

    rhs = 2x + y/2

    get_element(e) = fn.X[findall(==(e), fn.elements) |> first]
    rhs += -1*((:O in fn.elements) ? get_element(:O) : 0.0)
    rhs +=  1*((:N in fn.elements) ? get_element(:N) : 0.0)
    rhs +=  2*((:S in fn.elements) ? get_element(:S) : 0.0)

    return (1//2) * rhs * m_o2 / y_o2
end

function ChemicalCompound(f::EmpiricalFuel)
    return ChemicalCompound(Dict(zip(f.elements, f.X)))
end

##############################################################################
# Heavy fuel oil
##############################################################################

"""
    hfo_empirical_formula(Y; scaler = nothing)

Wrapper for `EmpiricalFuel` ensuring all HFO instances are created with all
typical elements, say C, H, O, N, and S, provided in this same order.
"""
function hfo_empirical_formula(Y; scaler = nothing)
    length(Y) == 5 || throw(ErrorException("All CHONS elements required!"))
    return EmpiricalFuel(Y; elements = [:C, :H, :O, :N, :S], scaler)
end

"""
    hfo_specific_heat(T::Float64, S::Float64)::Float64

Heavy fuel-oil specific heat estimation in terms of relative density
``S`` as provided by Cragoe (1929). Temperature in kelvin.
"""
function hfo_specific_heat(T::Float64, S::Float64)::Float64
    return 1000.0 * (1.683 + 0.00339T) / S
end

"""
    hfo_enthalpy_net_bs2869(;
        ρ::Float64,
        x::Float64,
        y::Float64,
        s::Float64
    )::Float64

Heavy fuel-oil net energy capacity accordinto to BS2869:1983. Value
is computed in [MJ/kg]. Parameters are given as:

- `ρ`: HFO density at 15 °C, [kg/m³].
- `water`: Mass percentage of water, [%].
- `ash`: Mass percentage of ashes, [%].
- `sulphur`: Mass percentage of sulphur, [%].

```jldoctest
julia> hfo_enthalpy_net_bs2869(; ρ = 1020.0, water = 0.1, ash = 0.05, sulphur = 1.0)
40.13509836320001
```
"""
function hfo_enthalpy_net_bs2869(;
        ρ::Float64,
        water::Float64,
        ash::Float64,
        sulphur::Float64
    )::Float64
    # In the reference ρ is given as kg/L.
    ρ = ρ / 1000.0

    # These are mass fractions.
    x = 0.01water
    y = 0.01ash
    s = 0.01sulphur

    # Base enthalpy estimation from empirical data.
    H = 46.423 - ρ * (8.792ρ - 3.170)

    # Correction factor and additional components.
    ϕ = 1.0 - x - y - s
    c = 9.420s - 2.449x

    return H * ϕ + c
end

##############################################################################
# Discrete particle model (DPM)
##############################################################################

""" Evaluate practical values for using Rosin-Rammler distribution in CFD.

## Fields

$(TYPEDFIELDS)

## Examples

Upcoming...
"""
struct RosinRammlerDroplet
    "Droplet average size [μm]."
    vavg::Float64

    "Droplet minimum size [μm]."
    vmin::Float64

    "Droplet maximum size [μm]."
    vmax::Float64

    "Distribution spread characteristic exponent."
    m::Float64
    
    "Distribution characteristic droplet size [μm]."
    θ::Float64

    function RosinRammlerDroplet(dist::Weibull{Float64};
            pmin = 0.0001, pmax = 0.9999)
        vavg = mean(dist)
        vmin = find_zero(d->cdf(dist, d) - pmin, vavg)
        vmax = find_zero(d->cdf(dist, d) - pmax, vavg)
        return new(vavg, vmin, vmax, params(dist)...)
    end
end

"""
    fit_rosinrammler(d₀, P₀; m=3.5)

Find parameter for particle size distribution with Weibull distribution, often
called after Rosin-Rammler in the field of particles - based on characteristic
size and associated cumulative density function (CDF) value. Parameter `d₀` is
the droplet size at which Weibull CDF evaluates to probability `P₀`. The value
of `m` is generally recommended for a certain technology; a common value is
provided by default.
"""
function fit_rosinrammler(d₀, P₀; m=3.5)
    θ = find_zero(θ->cdf(Weibull(m, θ), d₀) - 0.01P₀, d₀)
    return Weibull(m, θ)
end

"Display Rosin-Rammler distribution and optionally reference data."
function plot_rosinrammler(dist; xyref=nothing)
    θ = scale(dist)
    n = round(log10(θ))
    xmax = round(2θ / 10^n) * 10^n

    d = LinRange(0.0, xmax, 100)
    p = 100cdf(dist, d)
    
    dmean = @sprintf("%.2f μm", mean(dist))
    dchar = @sprintf("%.2f μm", θ)

    fig = with_theme() do
        f = Figure()
        ax = Axis(f[1, 1])
        
        ax.xlabel = "Droplet diameter [μm]"
        ax.ylabel = "Probability [%]"
        ax.title  = "μ = $(dmean), θ = $(dchar)"
        
		ax.yticks = 0.0:20.0:100.0
        xlims!(ax, 0.0, xmax)
		ylims!(ax, 0.0, 100.0)
        lines!(ax, d, p; color = :black)
        
        if !isnothing(xyref)
            scatter!(ax, xyref...; color = :red)
        end
        
        f
    end

    return fig
end

##############################################################################
# EOF
##############################################################################