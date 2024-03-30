# -*- coding: utf-8 -*-
import Pkg
import Revise

if Base.current_project() != Base.active_project()
    Pkg.activate(Base.current_project())
    Pkg.resolve()
    Pkg.instantiate()
end

using CairoMakie
using CommonSolve
using CommonSolve: solve
using DocStringExtensions: TYPEDFIELDS
using ExtendableGrids: geomspace
using NLsolve
using Roots
using Trapz: trapz
using DryTooling
using DryTooling.FiniteVolumes
using DryTooling.Simulation
using DryTooling: Temperature1DModelStorage
using DryTooling: interfaceconductivity1D

struct Sphere1DEnthalpyModel <: AbstractDiffusionModel1D
    "Thermal diffusion in a cylinder represented in enthalpy space."

    "Grid over which problem will be solved."
    grid::AbstractGrid1D

    "Memory for model linear algebra problem."
    problem::TridiagonalProblem

    "Model coefficient α."
    α::Vector{Float64}

    "Constant part of model coefficient β."
    β::Vector{Float64}

    "Thermal conductivity in terms of temperature."
    κ::Function

    "Global heat transfer coefficient ``U=hR``."
    U::Function

    "Surface environment temperature."
    B::Function

    "Enthalpy function of temperature."
    H::Function
    
    "Root finding function for temperature."
    root::Function

    "Time-step used in integration."
    τ::Base.RefValue{Float64}

    "Memory storage for solution retrieval."
    mem::Base.RefValue{Temperature1DModelStorage}

    "Residuals tracking during solution."
    res::Base.RefValue{TimeSteppingSimulationResiduals}

    "Surface area scaling factor."
    scale::Float64

    function Sphere1DEnthalpyModel(;
            grid::AbstractGrid1D,
            h::Union{Function,Float64},
            B::Union{Function,Float64},
            κ::Union{Function,Float64},
            H::Function,
            ρ::Float64
        )
        hu = (typeof(h) <: Function) ? h : (t) -> h
        Bu = (typeof(B) <: Function) ? B : (t) -> B
        κu = (typeof(κ) <: Function) ? κ : (T) -> κ

        problem = TridiagonalProblem(grid.N)

        rₙ = tail(grid.w)
        rₛ = head(grid.w)
        α = @. ρ * (rₙ^3 - rₛ^3) / 3.0

        rₙ = tail(grid.r)
        rₛ = head(grid.r)
        wⱼ = body(grid.w)
        β = @. wⱼ^2 / (rₙ - rₛ)

        R = last(grid.r)^2
        U = (t) -> hu(t) * R
        τ = Ref(-Inf)

        root = (Tₖ, hₖ) -> find_zero(T -> H(T) - hₖ, Tₖ)

        mem = Ref(Temperature1DModelStorage(0, 0))
        res = Ref(TimeSteppingSimulationResiduals(1, 0, 0))

        return new(grid, problem, α, β, κu, U, Bu, H, root, τ, mem, res, 4π)
    end
end

function initialize!(
        m::Sphere1DEnthalpyModel,
        t::Float64,
        τ::Float64;
        T::Union{Float64,Nothing} = nothing,
        M::Int64 = 50
    )::Nothing
    "Set initial condition of thermal diffusion model."
    # XXX: this is the same as for LocalAbstractTemperature1DModel!
    # Try to instantiate that function instead of the next calls!
    # ---
    nsteps = convert(Int64, round(t / τ))
    m.τ[] = Base.step(range(0.0, t, nsteps))
    m.res[] = TimeSteppingSimulationResiduals(1, M, nsteps)
    m.mem[] = Temperature1DModelStorage(m.grid.N, nsteps)

    # Do not reinitialize a problem.
    if !isnothing(T)
        m.problem.x[:] .= T
    end
    # ---
    return nothing
end

function DryTooling.Simulation.fouter!(
        m::Sphere1DEnthalpyModel, t::Float64, n::Int64
    )::Nothing
    "Time-step dependent updater for model."
    # XXX: for now evaluating B.C. at mid-step, fix when going full
    # semi-implicit generalization!
    U = m.U(t + m.τ[]/2)
    B = m.B(t + m.τ[]/2)

    # Follow surface heat flux and store partial solutions.
    # XXX: note the factor 4π because U = r²h only and A = 4πr²!!!!
    # XXX: note the factor 2π because U = rh only and A = 2πrl!!!!
    m.mem[].t[n] = t
    m.mem[].Q[n] = m.scale * U * (B - last(m.problem.x))
    m.mem[].T[n, 1:end] = m.problem.x

    α = m.α ./ m.τ[]

    @. m.problem.b[1:end] = α * map(m.H, m.problem.x)
    m.problem.b[end] += U * B
    return nothing
end

function DryTooling.Simulation.finner!(
        m::Sphere1DEnthalpyModel, t::Float64, n::Int64
    )::Nothing
    "Non-linear iteration updater for model."
    return nothing
end

function DryTooling.Simulation.fsolve!(
        m::Sphere1DEnthalpyModel, t::Float64, n::Int64, α::Float64
    )::Float64
    "Solve problem for one non-linear step."
    p = m.problem

    # XXX: for now evaluating B.C. at mid-step, fix when going full
    # semi-implicit generalization!
    U = m.U(t + m.τ[]/2)

    p.a[:] = m.α ./ m.τ[]

    function f(x)
        κ = interfaceconductivity1D(m.κ.(x))
        β = κ .* m.β

        p.A.dl[1:end] = -β
        p.A.du[1:end] = -β

        p.A.d[2:end-1] = tail(β) + head(β)
        p.A.d[1]       = first(β)
        p.A.d[end]     = last(β) + U

        return m.H.(x) .- (p.b - p.A * p.x) ./ p.a
    end

    T₀ = m.problem.x
    T₁ = nlsolve(f, T₀, autodiff = :forward).zero

    # if α > 10eps(Float64)
    #     ΔT = (1-α) * (T₁-T₀)
    #     @. m.problem.x[:] += ΔT
    #     ε = maximum(abs.(ΔT))
    # else
    @. m.problem.x[:] = T₁
    ε = eps(Float64)
    # end

    # ## --- old finner
    # κ = interfaceconductivity1D(m.κ.(m.problem.x))
    # β = κ .* m.β

    # # XXX: for now evaluating B.C. at mid-step, fix when going full
    # # semi-implicit generalization!
    # U = m.U(t + m.τ[]/2)

    # p.A.dl[1:end] = -β
    # p.A.du[1:end] = -β

    # p.A.d[2:end-1] = tail(β) + head(β)
    # p.A.d[1]       = first(β)
    # p.A.d[end]     = last(β) + U
    # ## ---
    
    # # m.problem.a[:] = residual(m.problem) * m.τ[] ./ m.α
    # p.a[:] = (p.b - p.A * p.x) * m.τ[] ./ m.α

    # T₀ = m.problem.x
    # T₁ = map(m.root, T₀, m.problem.a)

    # @info "Solving at $(t) .... $(ε)"
    addresidual!(m.res[], [ε])
    return ε
end

function CommonSolve.solve(
        m::Sphere1DEnthalpyModel;
        t::Float64,
        τ::Float64,
        T::Union{Float64,Nothing} = nothing,
        α::Float64 = 0.1,
        ε::Float64 = 1.0e-10,
        M::Int64 = 50
    )::Nothing
    "Interface for solving a model instance."
    initialize!(m, t, τ; T, M)
    advance!(m; α, ε, M)
    m.res[] = TimeSteppingSimulationResiduals(m.res[])
    return nothing
end

#### TESTING

@info "Solving 1-D models!"

model_args = (
    h = 20.0,
    B = 1500.0,
    κ = 2.0,
    ρ = 3000.0,
    c = 900.0
)

model_devs = (
    h = model_args.h,
    B = model_args.B,
    κ = model_args.κ,
    H = (T) -> model_args.c * T,
    ρ = model_args.ρ
)

solve_pars = (
    t = 2400.0,
    τ = 0.1,
    T = 300.0,
    α = 0.1,
    ε = 1.0e-05,
    M = 100
)

grid = equidistantcellsgrid1D(0.05, 50)
# grid = UserDefinedGrid1D(geomspace(0, 0.05, 0.005, 0.0005))

mtst = Sphere1DEnthalpyModel(; grid, model_devs...)
@time solve(mtst; solve_pars...)

msph = Sphere1DTemperatureModel(; grid, model_args...)
@time solve(msph; solve_pars...)

fig = let
    fig = Figure(resolution = (720, 500))
    ax = Axis(fig[1, 1], yscale = identity)
    lines!(ax, 100msph.grid.r, msph.problem.x, label = "Temperature")
    lines!(ax, 100mtst.grid.r, mtst.problem.x, label = "Enthalpy")
    ax.title = "Solution at $(solve_pars.t) s"
    ax.xlabel = "Radial coordinate [cm]"
    ax.ylabel = "Temperature [K]"
    ax.xticks = 0.0:1.0:100last(msph.grid.r)
    axislegend(ax; position = :lt)
    fig
end

# fsph = plotsimulationresiduals(msph.res[]; ε = solve_pars.ε)[1]
ftst = plotsimulationresiduals(mtst.res[]; ε = solve_pars.ε)[1]

# m, t, n = model_tst, 0.0, 1
# initialize!(m, solve_pars.t, solve_pars.τ; T = solve_pars.T, M = solve_pars.M)
# fouter!(m, t, n)
# finner!(m, t, n)
# fsolve!(m, t, n, 0.995)
# step!(m, t, n; α = 0.9, solve_pars.ε, solve_pars.M); m.problem.x

# @time for k in 1:10
#     step!(m, t, n; α = 0.9, solve_pars.ε, solve_pars.M); m.problem.x
# end
