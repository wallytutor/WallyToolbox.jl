# -*- coding: utf-8 -*-
module DryMaterials

using DocStringExtensions: FIELDS
using Polynomials: AbstractPolynomial
using Polynomials: Polynomial, LaurentPolynomial, integrate
using SteamTables: SpecificV

using DryAbstract: AbstractMaterial
using DryAbstract: AbstractSolidMaterial
using DryAbstract: AbstractLiquidMaterial
using DryAbstract: AbstractGasMaterial
using DryAbstract: AbstractSolidMineralPhase
using DryConstants: M_AIR
using DryUtilities: defaultvalue
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

#############################################################################
# Shomate models
#############################################################################

"""
Thermodynamic properties of solids with Shomate functions.

**IMPORTANT:** the implementation of `makestepwise1d` used for step-wise
function evaluation takes the mean of both ranges at the `T_ch`, while the
actual Shomate uses the high range for doing so. The function enforces the
right behavior by multiplying `T_ch` the value by `1-eps()`.

$(FIELDS)
"""
struct SolidShomateProperties

    """ Molar specific heat [J/(mol.K)]. """
    cₚ::Function

    """ Molar enthalpy [J/mol]. """
    h::Function

    """ Molar entropy [J/K]. """
    s::Function

    """ Low temperature range Shomate coefficients. """
    a_lo::Vector{Float64}

    """ High temperature range Shomate coefficients. """
    a_hi::Vector{Float64}

    """ Temperature of range change for evaluation. """
    T_ch::Float64

    function SolidShomateProperties(;
            a_lo::Vector{Float64},
            a_hi::Vector{Float64},
            T_ch::Float64
        )
        T_ch = (1.0 - eps()) * T_ch

        c = makestepwise1d(
            (T) -> shomatespecificheat(T/1000.0, a_lo),
            (T) -> shomatespecificheat(T/1000.0, a_hi),
            T_ch; differentiable = true
        )
        h = makestepwise1d(
            (T) -> shomateenthalpy(T/1000.0, a_lo),
            (T) -> shomateenthalpy(T/1000.0, a_hi),
            T_ch; differentiable = true
        )
        s = makestepwise1d(
            (T) -> shomateentropy(T/1000.0, a_lo),
            (T) -> shomateentropy(T/1000.0, a_hi),
            T_ch; differentiable = true
        )

        return new(c, h, s, a_lo, a_hi, T_ch)
    end
end

"""
    shomatespecificheat(T::Float64, c::Vector{Float64})::Float64

Molar specific heat with Shomate equation [J/(mol.K)].
"""
function shomatespecificheat(T::Float64, c::Vector{Float64})::Float64
    p0 = c[3] + T * c[4]
    p1 = c[2] + T * p0
    return T * p1 + c[5] / T^2 + c[1]
end

"""
    shomateenthalpy(T::Float64, c::Vector{Float64})::Float64

Molar enthalpy with Shomate equation [J/mol].
"""
function shomateenthalpy(T::Float64, c::Vector{Float64})::Float64
    p0 = (c[3]/3) + T * (c[4]/4)
    p1 = (c[2]/2) + T * p0
    p2 = (c[1]/1) + T * p1
    return T * p2 - (c[5]/T) + c[6] - c[8]
end

"""
    shomateentropy(T::Float64, c::Vector{Float64})::Float64

Entropy with Shomate equation [J/K].
"""
function shomateentropy(T::Float64, c::Vector{Float64})::Float64
    p0 = (c[3]/2) + T * (c[4]/3)
    p1 = (c[2]/1) + T * p0
    return c[1] * log(T) + T * p1 + c[5]/(2T^2) + c[7]
end

#############################################################################
# TODO: move the data to an YAML file and conceive loaders.
#############################################################################

"""
Representation of Kaolinite ``Al_2Si_2O_5(OH)_4``.

TODO recover missing defaults in Schieltz (1964).
"""
function getkaolinite(; cₚ = nothing, h₀ = nothing, ρ = nothing)
    coef = [-2 => -1.27676e7, 0 => 1034.30, 1 => 0.165941]
    cₚ = defaultvalue(cₚ, coef)
    h₀ = defaultvalue(h₀, 0.0)
    ρ  = defaultvalue(ρ,  0.0)
    return SolidMineralPhase("Kaolinite", cₚ, h₀, ρ, 0.2579)
end

"""
Representation of metakaolin ``Al_2Si_2O_7``.

TODO recover missing defaults in Schieltz (1964).
"""
function getmetakaolin(; cₚ = nothing, h₀ = nothing, ρ = nothing)
    coef = [-2 => -6.56221e6, 0 => 1034.30, 1 => 0.165941]
    cₚ = defaultvalue(cₚ, coef)
    h₀ = defaultvalue(h₀, 0.0)
    ρ  = defaultvalue(ρ,  0.0)
    return SolidMineralPhase("Metakaolin", cₚ, h₀, ρ, 0.2219)
end

"""
Representation of amorphous silica ``SiO_2(a)``.

TODO recover missing defaults in Schieltz (1964).
"""
function getamorphoussilica(; cₚ = nothing, h₀ = nothing, ρ = nothing)
    coef = [-2 => -2.40038e7, 0 => 930.899, 1 => 0.256032]
    cₚ = defaultvalue(cₚ, coef)
    h₀ = defaultvalue(h₀, 0.0)
    ρ  = defaultvalue(ρ,  0.0)
    return SolidMineralPhase("Amorphous Silica", cₚ, h₀, ρ, 0.06008)
end

"""
Representation of spinel ``Al_4Si_3O_{12}``.

TODO recover missing defaults (somewhere else, not in Schieltz (1964)).
"""
function getspinel(; cₚ = nothing, h₀ = nothing, ρ = nothing)
    coef = [0 => 930.0]
    cₚ = defaultvalue(cₚ, coef)
    h₀ = defaultvalue(h₀, 0.0)
    ρ  = defaultvalue(ρ,  0.0)
    return SolidMineralPhase("Spinel", cₚ, h₀, ρ, 0.38372)
end

"""
Representation of crystaline silica ``SiO_2`` (quartz).

TODO this contains only the thermodynamics, not a `SolidMineralPhase`!
"""
function getshomatesilica()
    return SolidShomateProperties(
        a_lo = [-6.076591, 251.6755, -324.7964, 168.5604,
                0.002548, -917.6893, -27.96962, -910.8568],
        a_hi = [58.7534, 10.27925, -0.131384, 0.02521,
                0.025601, -929.3292, 105.8092, -910.8568],
        T_ch = 847.0
    )
end

end # (module DryMaterials)
