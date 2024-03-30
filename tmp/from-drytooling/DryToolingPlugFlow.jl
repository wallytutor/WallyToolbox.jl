module DryToolingPlugFlow

using CommonSolve
using CommonSolve: solve
using DifferentialEquations: solve
using ModelingToolkit
using Symbolics
using Symbolics: scalarize
using DryToolingCore
using DryToolingKinetics

export RectangularReactorGeometry
export IsothermalSymbolicPlugFlowReactor
export solve

struct RectangularReactorGeometry
    """
        RectangularReactorGeometry

    Geometric description of rectangular reactor bounding volume.

    $(TYPEDFIELDS)
    """

    "Reactor total height/length [m]"
    H::Float64

    "Reactor cross-section depth [m]"
    D::Float64

    "Reactor cross-section width [m]"
    W::Float64

    "Reactor cross-section perimeter [m]"
    P::Float64

    "Reactor cross-section area [m²]"
    A::Float64

    "Reactor total volume [m³]"
    V::Float64

    function RectangularReactorGeometry(; H, D, W)
        P = 2 * (D + W)
        A = D * W
        V = A * H
        return new(H, D, W, P, A, V)
    end
end

struct IsothermalSymbolicPlugFlowReactor
    "Symbolic reactor mass flow rate"
    ṁ::Num

    "Symbolic reactor cross-section area"
    A::Num

    "Problem ordinary differential equation"
    sys::ODESystem

    "Kinetics mechanism being solved"
    kin::AbstractKineticsMechanism

    function IsothermalSymbolicPlugFlowReactor(
            kin::AbstractKineticsMechanism
        )
        @parameters ṁ A
        D = Differential(kin.t)

        # TODO: generalize to A(z).
        # dYdz = ωW / ρu, ρu = ṁ / A
        rhs = @. kin.ω *  kin.W / (ṁ / A)

        eqs = [scalarize(D.(kin.Y) .~ kin.RHS)...,
               scalarize(  kin.RHS .~ rhs)...]

        pars = [ṁ, A, params(kin)...]
        states = unknowns(kin)

        @named model = ODESystem(eqs, kin.t, states, pars)
        sys = structural_simplify(model)

        return new(ṁ, A, sys, kin)
    end
end

function CommonSolve.solve(
        r::IsothermalSymbolicPlugFlowReactor;
        z::Vector{Float64},
        Y::Vector{Float64},
        T::Float64,
        P::Float64,
        ṁ::Float64,
        A::Float64,
        L::Float64,
        kwargs...
    )
    p = [
        r.kin.T => T,
        r.kin.P => P,
        r.ṁ     => ṁ,
        r.A     => A
    ]

    prob = ODEProblem(r.sys, Y, (0.0, L), p)
    sol = solve(prob; saveat = z, kwargs...)

    return sol
end

end # module DryToolingPlugFlow
