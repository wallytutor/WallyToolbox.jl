# -*- coding: utf-8 -*-

export ConstantPrandtl
export ReynoldsPipeFlow
export NusseltGnielinski
export NusseltDittusBoelter
export grashof
export nusselt
export prandtl
export reynolds

##############################################################################
# DEFINITIONS
##############################################################################

grashof(g, β, ΔT, L, ν) = g * β * ΔT * L^3 / ν^2

grashof(g, β, ΔT, L, μ, ρ) = grashof(g, β, ΔT, L, μ/ρ)

nusselt(h, L, k) = h * L / k   

prandtl(cₚ) = cₚ / (cₚ + (5//4) * GAS_CONSTANT)

prandtl(ν, α) = ν / α

prandtl(cₚ, μ, k) = cₚ * μ / k

reynolds(u, L, ν) = u * L / ν

reynolds(u, L, μ, ρ) = reynolds(u, L, μ/ρ)

##############################################################################
# APPLICATION INTERFACES
##############################################################################

function nusselt(obj::AbstractNusseltPipeFlow, Re, Pr; kw...)
    get(kw, :validate, false) && validate(obj, Re, Pr; kw...)
    return Re < get(kw, :Re_crit, 3000.0) ? 3.66 : obj(Re, Pr; kw...)
end

function prandtl(obj::AbstractPrandtlNumber, θ)
    return obj(θ)
end

function reynolds(obj::AbstractReynoldsPipeFlow, u, D, ν)
    return obj(u, D, ν)
end

##############################################################################
# DOCS
##############################################################################

@doc "Evaluate Grashof number relationship."  grashof
@doc "Evaluate Nusselt number relationship."  nusselt
@doc "Evaluate Prandtl number relationship."  prandtl
@doc "Evaluate Reynolds number relationship." reynolds

##############################################################################
# PRANDTL NUMBER
##############################################################################

# TODO implement values for air and water in terms of temperature.
# https://en.wikipedia.org/wiki/Prandtl_number

"Prandtl number set to a constant value."
struct ConstantPrandtl <: AbstractPrandtlNumber
    pr::Float64

    function ConstantPrandtl(pr)
        return new(pr)
    end
end

function (obj::ConstantPrandtl)(θ)
    return obj.pr
end

##############################################################################
# INTERNAL PIPE FLOW
##############################################################################

"Reynolds number applied to internal pipe flow."
struct ReynoldsPipeFlow <: AbstractReynoldsPipeFlow end

"Gnielinski's relationship for Nusselt number."
struct NusseltGnielinski <: AbstractNusseltPipeFlow end

"Dittus-Boelter's relationship for Nusselt number."
struct NusseltDittusBoelter <: AbstractNusseltPipeFlow end

function (obj::ReynoldsPipeFlow)(u, D, ν)
    return reynolds(u, D, ν)
end

function (obj::NusseltGnielinski)(Re, Pr; kw...)
    f = (0.79 * log(Re) - 1.64)^(-2)
    g = f / 8
    num = g * (Re - 1000) * Pr
    den = 1.0 + 12.7 * (Pr^(2 / 3) - 1) * g^(1 / 2)
    return num / den
end

function (obj::NusseltDittusBoelter)(Re, Pr; kw...)
    n = get(kw, :what, :heating) == :heating ? 0.4 : 0.3
    return 0.023 * Re^(4//5) * Pr^n
end

function validate(obj::NusseltGnielinski, Re, Pr; kw...)
    test_exhaustive([
        (3000.0 <= Re <= 5.0e+06, "* Re = $(Re) ∉ [3000, 5×10⁶]"),
        (0.5 <= Pr <= 2000.0,     "* Pr = $(Pr) ∉ [0.5, 2000]")
    ])
end

function validate(obj::NusseltDittusBoelter, Re, Pr; kw...)
    aspect_ratio = kw[:aspect_ratio]

    test_exhaustive([
        (Re >= 10000.0,       "* Re = $(Re) < 10000"),
        (0.6 <= Pr <= 160.0,  "* Pr = $(Pr) ∉ [0.6, 160]"),
        (aspect_ratio > 10.0, "* L/D = $(aspect_ratio) < 10.0")
    ])
end

##############################################################################
# EOF
##############################################################################