##############################################################################
# PROPERTY MODELS
#
# Provides the description of medium properties through different models.
##############################################################################

# TODO: implement composite wall (plane/radial) thermal conductivity.

export TempPolynomialHeatConductivity
export GranularMediumHeatConductivity
export constheatconductivity
export maxwell_eff_conductivity
export compute

##############################################################################
# THERMAL CONDUCTIVITY
##############################################################################

"""
A simple wrapper for a temperature-dependenty polynomial heat conductivity.

$(TYPEDFIELDS)

The general use case of this is to create objects compatible with the compute
method employed for properties evaluation across the module.

```jldoctest
julia> k = TempPolynomialHeatConductivity([1.0, -0.1])
TempPolynomialHeatConductivity(Polynomial(1.5 - 0.001*T))

julia> compute(k, 300.0)
1.2
```

Although not the most efficienty way, a simple wrapper for providing constant
heat conductivity remaining compatible with other funcionalities is provided:

```jldoctest
julia> k = constheatconductivity(5.0)
TempPolynomialHeatConductivity(Polynomial(5.0))
```
"""
struct TempPolynomialHeatConductivity <: AbstractHeatCondTemperatureDep
    "Heat conductivity polynomial."
    p::Polynomial

    function TempPolynomialHeatConductivity(coefs)
        return new(Polynomial(coefs, :T))
    end
end

"Constant heat conductivity wrapper compatible with temperature dependency."
constheatconductivity(k) = TempPolynomialHeatConductivity([k])

"""
Provides the heat conductivity of a solids granular medium embeded in gas.

$(TYPEDFIELDS)

This composite type relies on a gas and a solid; below we illustrate how to
evaluate a granular medium effective heat conductivity using this structure.

```jldoctest
julia> ks = constheatconductivity(5.0);

julia> kg = constheatconductivity(0.092);

julia> kb = GranularBedHeatConductivity(ks, kg, 0.36);

julia> compute(kb, 300.0)
0.23471049304677621
```
"""
struct GranularMediumHeatConductivity <: AbstractMaxwellEffHeatCond
    "Heat conductivity model for solid phase."
    ks::AbstractHeatCondTemperatureDep
    
    "Heat conductivity model for gas phase."
    kg::AbstractHeatCondTemperatureDep

    "Solids packing fraction."
    ϕ::Float64
end

"""
    maxwell_eff_conductivity(kg, ks, ϕ)

Maxwell effective medium theory of thermal conductivity computed in terms of
gas thermal conductivity `kg`, solids thermal conductivity `ks`, and solids
packing fraction `ϕ`.
"""
function maxwell_eff_conductivity(kg, ks, ϕ)
    Σ, Δ = (2kg + ks), (ks - kg)
    return kg * (Σ+2ϕ*Δ) / (Σ-1ϕ*Δ)
end

function compute(k::AbstractHeatCondTemperatureDep, T)
    return k.p(T)
end

function compute(k::AbstractMaxwellEffHeatCond, T)
    ks, kg = compute(k.ks, T), compute(k.kg, T)
    return maxwell_eff_conductivity(kg, ks, k.ϕ)
end

##############################################################################
# EOF
##############################################################################