# -*- coding: utf-8 -*-
module DryMaterials

using Polynomials: Polynomial
using SteamTables: SpecificV
using DryConstants: M_AIR

abstract type AbstractMaterial end
abstract type AbstractLiquidMaterial <: AbstractMaterial end
abstract type AbstractSolidMaterial <: AbstractMaterial end
abstract type AbstractGasMaterial <: AbstractMaterial end

issolid(m::AbstractMaterial)  = m isa AbstractSolidMaterial
isliquid(m::AbstractMaterial) = m isa AbstractLiquidMaterial
isgas(m::AbstractMaterial)    = m isa AbstractGasMaterial

"Coefficients for air enthalpy polynomial [J/kg]."
const H_AIR::Vector{Float64} = [
    -2.6257123774377e+05,
     9.8274248481342e+02,
     4.9125599795629e-02
]

"Simple solid mineral material for illustration purposes."
struct PureMineral <: AbstractSolidMaterial
    ρ::Float64
    h::Polynomial

    function PureMineral(; ρ = 900.0, h = [0, 850.0])
        return new(ρ, Polynomial(h, :T))
    end
end

"Simple implementation of liquid water for illustration purposes."
struct PureWater <: AbstractLiquidMaterial
end

"Simple implementation of pure air for illustration purposes."
struct PureAir <: AbstractGasMaterial
    M̄::Float64
    h::Polynomial

    function PureAir(; m = nothing, h = nothing)
        m = isnothing(m) ? M_AIR : m
        h = isnothing(h) ? H_AIR : h
        return new(m, Polynomial(h, :T))
    end
end

#############################################################################
# density()
#############################################################################

density(mat::AbstractMaterial, T, P) = error("Not implemented")

density(mat::PureMineral, T, P) = mat.ρ

density(mat::PureWater, T, P) = 1.0 / SpecificV(P, T)

density(mat::PureAir, T, P) = (P * mat.M̄) / (RGAS * T)

@doc "Evaluates the density of material [kg/m³]." density

#############################################################################
# enthalpy()
#############################################################################

enthalpy(mat::AbstractMaterial, pars...) = error("Not implemented")

enthalpy(mat::PureMineral, T, P) = mat.h(T)

# TODO use clamp or a fallback to use SteamTables value!
enthalpy(mat::PureWater, T, P) = 4182.0T

enthalpy(mat::PureAir, T, P) = mat.h(T)

@doc "Evaluates the enthalpy of material [J/kg]." enthalpy

end # (module DryMaterials)
