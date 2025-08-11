##############################################################################
# PROPERTYMODELS
##############################################################################

# TODO: implement composite wall (plane/radial) thermal conductivity.

export TempPolynomialHeatConductivity
export TempPolynomialFluidViscosity

export GranularMediumHeatConductivity

export constheatconductivity
export constfluidviscosity

export maxwell_eff_conductivity

##############################################################################
# POLYNOMIALS
##############################################################################

"""
Wrapper for a polynomial temperature-dependent heat conductivity.

## Fields

$(TYPEDFIELDS)

## Examples

The general use case of this is to create objects compatible with the function
object approach employed for properties evaluation across the module.

```jldoctest
julia> k = TempPolynomialHeatConductivity([1.5, -0.001])
TempPolynomialHeatConductivity(Polynomial(1.5 - 0.001*T))

julia> k(1000.0)
0.5
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

"""
Wrapper for a polynomial temperature-dependent fluid viscosity.

## Fields

$(TYPEDFIELDS)

Usage is analogous to [`TempPolynomialHeatConductivity`](@ref).
"""
struct TempPolynomialFluidViscosity <: AbstractViscosityTemperatureDep
    "Fluid viscosity polynomial."
    p::Polynomial

    function TempPolynomialFluidViscosity(coefs)
        return new(Polynomial(coefs, :T))
    end
end

##############################################################################
# GRANULAR THERMAL CONDUCTIVITY
##############################################################################

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

"""
Provides the heat conductivity of a solids granular medium embeded in gas.

## Fields

$(TYPEDFIELDS)

## Examples

This composite type relies on a gas and a solid; below we illustrate how to
evaluate a granular medium effective heat conductivity using this structure.

```jldoctest
julia> ks = constheatconductivity(5.0);

julia> kg = constheatconductivity(0.092);

julia> kb = GranularMediumHeatConductivity(ks, kg, 0.36);

julia> kb(300.0)
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

##############################################################################
# WRAPPERS
##############################################################################

"Constant heat conductivity wrapper compatible with temperature dependency."
constheatconductivity(k) = TempPolynomialHeatConductivity([k])

"Constant heat conductivity wrapper compatible with temperature dependency."
constfluidviscosity(μ) = TempPolynomialFluidViscosity([μ])

##############################################################################
# CALLERS
##############################################################################

(obj::TempPolynomialHeatConductivity)(T) = obj.p(T)

(obj::TempPolynomialFluidViscosity)(T) = obj.p(T)

(obj::GranularMediumHeatConductivity)(T) = let
    maxwell_eff_conductivity(obj.kg(T), obj.ks(T), obj.ϕ)
end

##############################################################################
# EOF
##############################################################################