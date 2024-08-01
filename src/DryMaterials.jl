# -*- coding: utf-8 -*-
module DryMaterials

using DocStringExtensions: FIELDS
using Polynomials: AbstractPolynomial
using Polynomials: Polynomial, LaurentPolynomial, integrate
using SteamTables: SpecificV

using WallyToolbox: AbstractMaterial
using WallyToolbox: AbstractSolidMaterial
using WallyToolbox: AbstractLiquidMaterial
using WallyToolbox: AbstractGasMaterial
using WallyToolbox: AbstractSolidMineralPhase
using WallyToolbox: M_AIR
using WallyToolbox: defaultvalue
using DryUtilities: makestepwise1d

#############################################################################
# Thermodynamics classes
#############################################################################

"""
Arbitrary Laurent polynomial specific heat and enthalpy of materials.

$(FIELDS)
"""
struct SolidPolynomialProperties
    "Polynomial representation of specific heat [J/(kg.K)]."
    c::AbstractPolynomial

    "Polynomial representation of enthalpy [J/kg]."
    h::AbstractPolynomial
    
    "Reference state enthalpy [J/kg]."
    hₒ::Float64

    function SolidPolynomialProperties(; cₚ, h₀ = 0.0)
        c = sum(map(p->LaurentPolynomial(p.second, p.first, :T), cₚ))
        h = h₀ + integrate(c)
        return new(c, h, h₀)
    end
end

#############################################################################
# Dummy materials
#############################################################################

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
# Minerals
#############################################################################

"""
Represents a solid mineral phase for thermodynamic calculations.

$(FIELDS)
"""
struct SolidMineralPhase <: AbstractSolidMineralPhase
    "Name of phase."
    name::String
    
    "Specific mass of phase [kg/m³]."
    ρ::Float64
    
    "Molecular mass of phase [kg/mol]."
    M::Float64
    
    "Polynomial properties of phase."
    p::SolidPolynomialProperties
    
    function SolidMineralPhase(name, cₚ, h₀, ρ, M)
        return new(name, ρ, M, SolidPolynomialProperties(; cₚ, h₀))
    end
end

#############################################################################
# Types check
#############################################################################

issolid(m::AbstractMaterial)  = m isa AbstractSolidMaterial
isliquid(m::AbstractMaterial) = m isa AbstractLiquidMaterial
isgas(m::AbstractMaterial)    = m isa AbstractGasMaterial

#############################################################################
# molecularmass()
#############################################################################

molecularmass(mat::PureWater) = 0.018

molecularmass(m::AbstractSolidMineralPhase) = m.M

@doc "Retrieve molecular mass of materials [kg/mol]."  molecularmass

#############################################################################
# density()
#############################################################################

density(mat::AbstractMaterial, T, P) = error("Not implemented")

density(mat::PureMineral, T, P) = mat.ρ

density(mat::PureWater, T, P) = 1.0 / SpecificV(P, T)

density(mat::PureAir, T, P) = (P * mat.M̄) / (RGAS * T)

density(m::AbstractSolidMineralPhase, T, P) = m.ρ

@doc "Evaluates the density of material [kg/m³]." density

#############################################################################
# specificheat()
#############################################################################

specificheat(mat::PureWater, T, P) = 4182.0

specificheat(m::AbstractSolidMineralPhase, T, P) = m.p.c(T)

@doc "Evaluates the specific heat of materials [J/(kg.K)]." specificheat

#############################################################################
# enthalpy()
#############################################################################

enthalpy(mat::AbstractMaterial, pars...) = error("Not implemented")

enthalpy(mat::PureMineral, T, P) = mat.h(T)

# TODO use clamp or a fallback to use SteamTables value!
enthalpy(mat::PureWater, T, P) = 4182.0T

enthalpy(mat::PureAir, T, P) = mat.h(T)

enthalpy(m::AbstractSolidMineralPhase, T, P) = m.p.h(T)

@doc "Evaluates the enthalpy of material [J/kg]." enthalpy

end # (module DryMaterials)
