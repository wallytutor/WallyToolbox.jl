# -*- coding: utf-8 -*-
module DryCombustion

import Base: String
using WallyToolbox
using DocStringExtensions: TYPEDFIELDS
using Printf
using Roots

export EmpiricalFuel
export oxidizer_mass_flow_rate
export hfo_specific_heat
export hfo_enthalpy_net_bs2869

##############################################################################
# Empirical fuel
##############################################################################

"""
Provides description of an empirical fuel based on elemental mass fractions.

$(TYPEDFIELDS)

Below we illustrate how to create a fuel with the approximate mass fractions
of carbon and hydrogen in naphtalene; next we check its string representation.

```jldoctest
julia> fuel = EmpiricalFuel([0.937, 0.063, 0.0]; scale=:C=>10.0);

julia> fuel.X
3-element Vector{Float64}:
 10.0
  8.011606189967983
  0.0

julia> String(fuel)
"C(10.0000)H(8.0116)O(0.0000)"
```
"""
struct EmpiricalFuel
    "Chemical elements reported in fuel."
    elements::Vector{Symbol}

    "Array of provided masses per kilogram of fuel."
    Y::Vector{Float64}
    
    "Array of computed moles per kilogram of fuel."
    X::Vector{Float64}

    function EmpiricalFuel(Y; elements = [:C, :H, :O], scale = nothing)
        if length(elements) != length(Y)
            throw(ErrorException("Length of Y must be the same as elements"))
        end

        if length(elements) != length(Set(elements))
            throw(ErrorException("Elements must be a set of unique values"))
        end
        
        Y = Y ./ sum(Y)
        X = Y ./ atomicmass.(elements)

        if !isnothing(scale)
            scale.first in elements || begin
                throw(ErrorException("Scaling element not in elements list"))
            end
            X = scale.second.* X ./ X[findall(==(scale.first), elements)]
        end

        return new(elements, Y, X)
    end
end

function Base.String(f::EmpiricalFuel)
    fmt(e, x) = @sprintf("%s(%.4f)", e, x)
    return join(map(args->fmt(args...), zip(f.elements, f.X)))
end

"""
    oxidizer_mass_flow_rate(f::EmpiricalFuel; y_o2 = 0.23)

Computes the required amount of oxidizer to perform complete combustion
of 1 kg provided empirical fuel. The value of `y_o2` represents the mass
fraction of oxygen in oxidizer; default value is typical for air.

```jldoctest
julia> fuel = EmpiricalFuel([0.937, 0.063, 0.0]; scale=:C=>10);

julia> oxidizer_mass_flow_rate(fuel)
13.02691759229764
```
"""
function oxidizer_mass_flow_rate(f::EmpiricalFuel; y_o2 = 0.23)
    m_o2 = molecularmass(Stoichiometry(; O = 2))

    fn = EmpiricalFuel(f.Y; f.elements, scale=nothing)

    x = fn.X[findall(==(:C), fn.elements) |> first]
    y = fn.X[findall(==(:H), fn.elements) |> first]
    z = fn.X[findall(==(:O), fn.elements) |> first]

    return (1//2)*(2*x + y/2 - z)* m_o2 / y_o2
end

##############################################################################
# Heavy fuel oil
##############################################################################

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

# """
#     fit_rosinrammler(d₀, P₀; m=3.5)

# Find parameter for particle size distribution with Weibull distribution
# often called after Rosin-Rammler in the field of particles, based on
# characteristic size and associated CDF value. Parameter `d₀` is the
# droplet size at which Weibull cummulative probability function 
# ``F(d)=1-\\exp(-(d/\\sigma)^m)`` evaluates to `P₀`.
# """
# function fit_rosinrammler(d₀, P₀; m=3.5)
#     f(d, σ, m) = 1.0 .- exp.(-(d / σ).^m)
#     σ = find_zero(σ -> f(d₀, σ, m) - P₀ / 100.0, d₀)

# 	n = round(log10(σ))
# 	xmax = round(2σ / 10^n) * 10^n
	
#     d = collect(0.0:1.0:xmax)
#     P = 100 .* f(d, σ, m)

#     fig = plot(d, P,
#         legend        = false,
#         linewidth     = 2,
#         xlabel        = "Droplet diameter [μm]",
#         ylabel        = "Probability [%]",
#         title         = "σ = $(@sprintf("%.2f", σ)) μm",
#         left_margin   = 7Plots.mm,
#         right_margin  = 7Plots.mm,
#         top_margin    = 10Plots.mm,
#         bottom_margin = 5Plots.mm,
# 		yticks        = 0.0:20.0:100.0,
# 		xlim          = (0.0, xmax),
# 		ylim          = (0.0, 100.0)
#     )
	
# 	scatter!(fig, [d₀], [P₀])

#     return fig;
# end

end # (DryCombustion)
