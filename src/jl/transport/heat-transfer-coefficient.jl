##############################################################################
# HEATTRASNFERCOEFFICIENT
##############################################################################

export HtcPipeFlow
export htc

##############################################################################
# INTERNAL PIPE FLOW
##############################################################################

"Heat transfer coefficient for internal pipe flow."
struct HtcPipeFlow <: AbstractHtcPipeFlow
    re::AbstractReynoldsPipeFlow
    nu::AbstractNusseltPipeFlow
    pr::AbstractPrandtlNumber

    function HtcPipeFlow(re, nu, pr)
        return new(re, nu, pr)
    end
end

"""
Implements the interface for heat transfer coefficient evaluation.

Notice that although temperature is provided in this interface,
it is used only for Pr calculation. Other properties might have
arbitrarily complex dependencies and types, so it was chosen by
design to keep their evaluation to the user before calling this.

Also, to ensure internal consistency because of Nusselt number
dependency on Prandtl number, thermal conductivity is evaluated
from specific heat and viscosity. It is up to the user to make
sure the provided Prandtl number is compatible.
"""
function htc(obj::AbstractHtcPipeFlow, θ, u, D, ρ, μ, cₚ; kw...)
    return obj(θ, u, D, ρ, μ, cₚ; kw...)
end

function (obj::HtcPipeFlow)(θ, u, D, ρ, μ, cₚ; kw...)
    Pr = prandtl(obj.pr, θ)
    Re = reynolds(obj.re, u, D, μ/ρ)
    Nu = nusselt(obj.nu, Re, Pr; kw...)
    k = cₚ * μ / Pr
    h = Nu * k / D

    if get(kw, :verbose, false)
        @info("""\
        Prandtl .................... $(Pr)
        Reynolds ................... $(Re)
        Nusselt .................... $(Nu)
        k .......................... $(k) W/(m.K)
        h .......................... $(h) W/(m².K)\
        """)
    end

    return h
end

##############################################################################
# EOF
##############################################################################