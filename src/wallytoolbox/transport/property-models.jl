##############################################################################
# PROPERTYMODELS
##############################################################################

# TODO: implement composite wall (plane/radial) thermal conductivity.

export TempPolynomialHeatConductivity
export TempPolynomialFluidViscosity
export TempFermiLikeMeltingViscosity

export GranularMediumHeatConductivity
export AirHeatConductivityMujumdar2006
export AirViscosityMujumdar2006

export constheatconductivity
export constfluidviscosity

export fermilike_viscosity
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
# ARBITRARY FUNCTIONS
##############################################################################

"""
    fermilike_viscosity(T, μ∞, δ, Θ, Δ)

Evaluation of Fermi-distribution-alike viscosity function.
"""
function fermilike_viscosity(T, μ∞, δ, Θ, Δ)
    return μ∞ + δ / (1 + exp((T - Θ) / Δ))
end

"""
Temperature-dependent viscosity with a Fermi-like distribution dependency.

## Fields

$(TYPEDFIELDS)

## Examples

The following example shows the evaluation of such a function below, in
the middle, and above melting range.

```jldoctest
julia> μ = TempFermiLikeMeltingViscosity(1300.0, 1700.0, 1000.0, 0.1, 10);

julia> μ(300.0)
999.9999999999065

julia> μ(1500.0)
500.05

julia> μ(2000.0)
0.10372626662025815
```
"""
struct TempFermiLikeMeltingViscosity <: AbstractViscosityTemperatureDep
    "Center temperature of melting range [K]."
    Θ::Float64

    "Spread factor over melting range  [K]."
    Δ::Float64

    "Viscosity change during melting [Pa.s]."
    δ::Float64

    "High temperature viscosity [Pa.s]."
    μ∞::Float64

    "Low temperature viscosity [Pa.s]."
    μ₀::Float64

    "Spread coefficient used to compute Δ."
    κ::Float64

    "Melting start temperature [K]."
    Ts::Float64
    
    "Melting end temperature [K]."
    Te::Float64

    function TempFermiLikeMeltingViscosity(Ts, Te, μ₀, μ∞, κ)
        Θ = (Te + Ts) / 2
        Δ = (Te - Ts) / κ
        δ = μ₀ - μ∞
        return new(Θ, Δ, δ, μ∞, μ₀, κ, Ts, Te)
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
# DOMAIN SPECIFIC - ROTARY KILN MUJUMDAR 2006
##############################################################################

# XXX: find a better way to avoid this global!
const KMUJUMDAR2006 = Polynomial([-7.494e-03,  1.709e-04, -2.377e-07,
                                   2.202e-10, -9.463e-14,  1.581e-17])

"""
Air heat conductivity for rotary kiln simulation - Mujumdar (2006).

```jldoctest
julia> k = AirHeatConductivityMujumdar2006();

julia> k(300)
0.027600315300000004
```
"""
struct AirHeatConductivityMujumdar2006 <: AbstractHeatCondTemperatureDep end

"""
Air viscosity for rotary kiln simulation - Mujumdar (2006).

```jldoctest
julia> μ = AirViscosityMujumdar2006();

julia> μ(300)
1.837988950255163e-5
```
"""
struct AirViscosityMujumdar2006 <: AbstractViscosityTemperatureDep end

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

(obj::TempFermiLikeMeltingViscosity)(T) = let 
    fermilike_viscosity(T, obj.μ∞, obj.δ, obj.Θ, obj.Δ)
end

(obj::GranularMediumHeatConductivity)(T) = let
    maxwell_eff_conductivity(obj.kg(T), obj.ks(T), obj.ϕ)
end

(obj::AirHeatConductivityMujumdar2006)(T) = KMUJUMDAR2006(T)

(obj::AirViscosityMujumdar2006)(T) = 0.1672e-05sqrt(T) - 1.058e-05

##############################################################################
# EOF
##############################################################################