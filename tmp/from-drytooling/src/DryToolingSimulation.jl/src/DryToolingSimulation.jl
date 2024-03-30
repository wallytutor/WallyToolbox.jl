module DryToolingSimulation

using CairoMakie
using DocStringExtensions: TYPEDFIELDS
using LinearAlgebra
using DryToolingCore

export TridiagonalProblem
export solve!
export change
export residual

export step!
export advance!
export fouter!
export finner!
export fsolve!
export timepoints
export relaxationstep!

export TimeSteppingSimulationResiduals
export addresidual!
export plotsimulationresiduals

""" Memory for a tridiagonal problem of rank `N`.

All tensors are filled with zeros upon creation. This is simply
a utility for memory allocation, no other operations are made.

$(TYPEDFIELDS)
"""
struct TridiagonalProblem <: AbstractMatrixProblem

    "Main problem matrix."
    A::Tridiagonal{Float64, Vector{Float64}}

    "Right-hand side vector."
    b::Vector{Float64}

    "Solution variable vector."
    x::Vector{Float64}

    "Auxiliary vector, *e.g.* for iterative problems."
    a::Vector{Float64}

    function TridiagonalProblem(N)
        A = Tridiagonal(zeros(N-1), zeros(N), zeros(N-1))
        return new(A, zeros(N), zeros(N), zeros(N))
    end
end

"""
    solve!(p::TridiagonalProblem)::Nothing

Solve problem ``x=A^{-1}b`` updating internal memory.
"""
function solve!(p::TridiagonalProblem)::Nothing
    p.x[:] = p.A \ p.b
    return nothing
end

"""
    change(p::TridiagonalProblem)::Vector{Float64}

Change in solution ``A^{-1}b-x`` of problem without update ``x``.
"""
function change(p::TridiagonalProblem)::Vector{Float64}
    return p.A \ p.b - p.x
end

"""
    residual(p::TridiagonalProblem)::Vector{Float64}

Solution residual ``b-Ax`` of problem without update of ``x``.
"""
function residual(p::TridiagonalProblem)::Vector{Float64}
    return p.b - p.A * p.x
end

function Base.length(p::AbstractMatrixProblem)
    return length(p.x)
end

"""
    step!(
        m::AbstractPhysicalModel,
        t::Float64,
        n::Int64;
        fouter!::Function,
        finner!::Function,
        fsolve!::Function,
        α::Float64 = 0.1,
        iters::Int64 = 20,
        tol::Float64 = 1.0e-10
    )

Manage the integration of a model `m` from time `t` corresponding to
step call `n` using model internal time step. All the updates of
coefficients and solution are performed through user-supplied functions.
"""
function step!(
        m::AbstractPhysicalModel,
        t::Float64,
        n::Int64;
        α::Float64 = 0.1,
        ε::Float64 = 1.0e-10,
        M::Int64 = 20
    )::Nothing
    fouter!(m, t, n)
    finner!(m, t, n)

    if α <= 0.0
        solve!(m.problem)
        m.res[].innersteps[n] = 1
        return nothing
    end

    for niter in 1:M
        if fsolve!(m, t, n, α) <= ε
            m.res[].innersteps[n] = niter
            return nothing
        end
        finner!(m, t, n)
    end

    @warn "Did not converge after $(M) steps"
    m.res[].innersteps[n] = M
    return nothing
end

"""
    advance!(
        m::AbstractPhysicalModel;
        α::Float64 = 0.1,
        ε::Float64 = 1.0e-10,
        M::Int64 = 20,
        t0::Float64 = 0.0
    )

Manage execution of `step!` over the integration time interval.
"""
function advance!(
        m::AbstractPhysicalModel;
        α::Float64 = 0.1,
        ε::Float64 = 1.0e-10,
        M::Int64 = 20,
        t0::Float64 = 0.0
    )
    if α >= 1.0 || α < 0.0
        @error """\
        Relaxation factor out-of-range (α = $(α)), this is not \
        supported / does not make physical sense in most cases!
        """
    end

    times = timepoints(m)

    # XXX: `times` contain all solution points from initial condition.
    # For time-advance use only the `head` of this to avoid performing
    # and extra step. Uncomment the `@info` for checking if in doubt!
    for (n, t) in enumerate(head(times))
        tn = t + t0
        # @info "Advancing from $(tn) to $(tn+m.τ[]) s"
        step!(m, tn, n; α, ε, M)
    end

    # @info "Reached time $(last(times))"
    fouter!(m, last(times) + t0, length(times))
end

"""
    fouter!(::AbstractPhysicalModel, ::Float64, ::Int64)

Outer loop update for [`step!`](@ref).
"""
function fouter!(::AbstractPhysicalModel, ::Float64, ::Int64)
    @error "An specialization of this method is expexted!"
end

"""
    finner!(::AbstractPhysicalModel, ::Float64, ::Int64)

Inner loop update for [`step!`](@ref).
"""
function finner!(::AbstractPhysicalModel, ::Float64, ::Int64)
    @error "An specialization of this method is expexted!"
end

"""
    fsolve!(::AbstractPhysicalModel, ::Float64, ::Int64, ::Float64)

Solution update for [`step!`](@ref).
"""
function fsolve!(::AbstractPhysicalModel, ::Float64, ::Int64, ::Float64)
    @error "An specialization of this method is expexted!"
end

"""
    timepoints(::AbstractPhysicalModel)

Get array of model time-points for use in [`step!`](@ref).
"""
function timepoints(::AbstractPhysicalModel)
    @error "An specialization of this method is expexted!"
end

function relaxationstep!(
        p::AbstractMatrixProblem,
        α::Float64,
        f::Function
    )::Float64
    "Applies relaxation to solution and compute residual."
    # Compute relaxed increment based on solution change.
    Δx = (1.0 - α) * change(p)

    # Evaluate residual metric.
    ε = f(p.x, Δx)

    # Update solution with relaxation.
    p.x[:] += Δx

    # Return residual.
    return ε
end

"""
Manage time-stepping solvers residuals storage during a simulation.

The memory is initialized with a given number of inner and outer
iterations and resizing is not under the scope of this structure.

$(TYPEDFIELDS)

# Usage

For starting a simulation, use the outer constructor for starting
a simulation with pre-allocated memory with interface:

```julia
TimeSteppingSimulationResiduals(N::Int64, inner::Int64, outer::Int64)
```

Once the simulation is finished, the first instance can be processed
through creation of a new object using the next interface:

```julia
TimeSteppingSimulationResiduals(r::TimeSteppingSimulationResiduals)
```
"""
struct TimeSteppingSimulationResiduals

    "Number of variables being tracked in problem."
    N::Int64

    "Total iteration counter."
    counter::Base.RefValue{Int64}

    "Number of inner steps per outer loop in solution."
    innersteps::Vector{Int64}

    "Store residuals of each inner step, one variable per column."
    residuals::Matrix{Float64}
end

function TimeSteppingSimulationResiduals(N::Int64, inner::Int64, outer::Int64)
    innersteps = -ones(Int64, outer)
    residuals = -ones(Float64, (outer * inner, N))
    return TimeSteppingSimulationResiduals(N, Ref(0), innersteps, residuals)
end

function TimeSteppingSimulationResiduals(r::TimeSteppingSimulationResiduals)
    # XXX: the equal sign below is required! In some cases, *e.g.*
    # when you try to simulate a system that is already at constant
    # state or when using a closed boundary condition, the error
    # can be exactly zero because of the form of the equations!
    innersteps = r.innersteps[r.innersteps .>= 0.0]
    residuals = r.residuals[r.residuals .>= 0.0]

    N = last(size(r.residuals))
    residuals = reshape(residuals, r.counter[], N)

    return TimeSteppingSimulationResiduals(N, r.counter, innersteps, residuals)
end

"""
    addresidual!(
        r::TimeSteppingSimulationResiduals,
        ε::Vector{Float64}
    )::Nothing

Utility to increment iteration counter and store residuals.
"""
function addresidual!(
        r::TimeSteppingSimulationResiduals,
        ε::Vector{Float64}
    )::Nothing
    # TODO: add resizing test here!
    r.counter[] += 1
    r.residuals[r.counter[], :] = ε
    return nothing
end

"""
    finaliterationdata(
        r::TimeSteppingSimulationResiduals
    )::Tuple{Vector{Int64}, Matrix{Float64}}

Retrieve data at iterations closing an outer loop of solution.
"""
function finaliterationdata(
        r::TimeSteppingSimulationResiduals
    )::Tuple{Vector{Int64}, Matrix{Float64}}
    steps = cumsum(r.innersteps)
    residuals = r.residuals[steps, :]
    return steps, residuals
end

"""
    plotsimulationresiduals(
        r::TimeSteppingSimulationResiduals;
        ε::Union{Float64, Nothing} = nothing,
        showinner::Bool = false,
        resolution::Tuple{Int64, Int64} = (720, 500)
    )::Tuple{Figure, Axis, Vector}

Plot problem residuals over iterations or steps. It performs the basic
figure setup, configuration of axis and details beign left to the user.
"""
function plotsimulationresiduals(
        r::TimeSteppingSimulationResiduals;
        ε::Union{Float64, Nothing} = nothing,
        showinner::Bool = false,
        scaler::Function = log10,
        resolution::Tuple{Int64, Int64} = (720, 500)
    )::Tuple{Figure, Axis, Vector}
    xs, ys = finaliterationdata(r)
    ys = scaler.(ys)
    xs .-= 1

    units, unitp = axesunitscaler(last(xs))

    fig = Figure(resolution = resolution)
    ax = Axis(fig[1, 1], yscale = identity)
    ax.ylabel = "$(scaler)(Residual)"
    ax.xlabel = "Global iteration $(units)"

    p = []

    if showinner
        xg = collect(0:(r.counter[]-1))
        yg = scaler.(r.residuals)

        for col in 1:last(size(ys))
            lines!(ax, xg ./ unitp, yg[:, col], color = :black, linewidth = 0.5)
            push!(p, scatter!(ax, xs ./ unitp, ys[:, col]))
        end
    else
        for col in 1:last(size(ys))
            push!(p, lines!(ax, xs ./ unitp, ys[:, col]))
        end
    end

    if !isnothing(ε)
        hlines!(ax, scaler(ε), color = :blue, linewidth = 2)
    end

    return (fig, ax, p)
end

end # module DryToolingSimulation
