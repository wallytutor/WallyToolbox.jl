# -*- coding: utf-8 -*-
export Cylinder1DTemperatureModel
export Sphere1DTemperatureModel
export initialize!
export solve

abstract type LocalAbstractTemperature1DModel <: AbstractDiffusionModel1D end

# struct SymmetricPlate1DTemperatureModel <: LocalAbstractTemperature1DModel

struct Cylinder1DTemperatureModel <: LocalAbstractTemperature1DModel
    "Thermal diffusion in a cylinder represented in temperature space."

    "Grid over which problem will be solved."
    grid::AbstractGrid1D

    "Memory for model linear algebra problem."
    problem::TridiagonalProblem

    "Constant part of model coefficient α."
    α′::Vector{Float64}

    "Constant part of model coefficient β."
    β′::Vector{Float64}

    "Thermal conductivity in terms of temperature."
    κ::Function

    "Global heat transfer coefficient ``U=hR``."
    U::Function

    "Surface environment temperature."
    B::Function

    "Time-step used in integration."
    τ::Base.RefValue{Float64}

    "Memory storage for solution retrieval."
    mem::Base.RefValue{Temperature1DModelStorage}

    "Residuals tracking during solution."
    res::Base.RefValue{TimeSteppingSimulationResiduals}

    "Surface area scaling factor."
    scale::Float64

    function Cylinder1DTemperatureModel(;
            grid::AbstractGrid1D,
            h::Union{Function,Float64},
            B::Union{Function,Float64},
            κ::Union{Function,Float64},
            ρ::Float64,
            c::Float64
        )
        hu = (typeof(h) <: Function) ? h : (t) -> h
        Bu = (typeof(B) <: Function) ? B : (t) -> B
        κu = (typeof(κ) <: Function) ? κ : (T) -> κ

        problem = TridiagonalProblem(grid.N)

        rₙ = tail(grid.w)
        rₛ = head(grid.w)
        α′ = @. ρ * c * (rₙ^2 - rₛ^2) / 2.0

        rₙ = tail(grid.r)
        rₛ = head(grid.r)
        wⱼ = body(grid.w)
        β′ = @. wⱼ / (rₙ - rₛ)

        R = last(grid.r)
        U = (t) -> hu(t) * R
        τ = Ref(-Inf)

        mem = Ref(Temperature1DModelStorage(0, 0))
        res = Ref(TimeSteppingSimulationResiduals(1, 0, 0))

        return new(grid, problem, α′, β′, κu, U, Bu, τ, mem, res, 2π)
    end
end

struct Sphere1DTemperatureModel <: LocalAbstractTemperature1DModel
    "Thermal diffusion in a sphere represented in temperature space."

    "Grid over which problem will be solved."
    grid::AbstractGrid1D

    "Memory for model linear algebra problem."
    problem::TridiagonalProblem

    "Constant part of model coefficient α."
    α′::Vector{Float64}

    "Constant part of model coefficient β."
    β′::Vector{Float64}

    "Thermal conductivity in terms of temperature."
    κ::Function

    "Global heat transfer coefficient ``U=hR``."
    U::Function

    "Surface environment temperature."
    B::Function

    "Time-step used in integration."
    τ::Base.RefValue{Float64}

    "Memory storage for solution retrieval."
    mem::Base.RefValue{Temperature1DModelStorage}

    "Residuals tracking during solution."
    res::Base.RefValue{TimeSteppingSimulationResiduals}

    "Surface area scaling factor."
    scale::Float64

    function Sphere1DTemperatureModel(;
            grid::AbstractGrid1D,
            h::Union{Function,Float64},
            B::Union{Function,Float64},
            κ::Union{Function,Float64},
            ρ::Float64,
            c::Float64
        )
        hu = (typeof(h) <: Function) ? h : (t) -> h
        Bu = (typeof(B) <: Function) ? B : (t) -> B
        κu = (typeof(κ) <: Function) ? κ : (T) -> κ

        problem = TridiagonalProblem(grid.N)

        rₙ = tail(grid.w)
        rₛ = head(grid.w)
        α′ = @. ρ * c * (rₙ^3 - rₛ^3) / 3.0

        rₙ = tail(grid.r)
        rₛ = head(grid.r)
        wⱼ = body(grid.w)
        β′ = @. wⱼ^2 / (rₙ - rₛ)

        R = last(grid.r)^2
        U = (t) -> hu(t) * R
        τ = Ref(-Inf)

        mem = Ref(Temperature1DModelStorage(0, 0))
        res = Ref(TimeSteppingSimulationResiduals(1, 0, 0))

        return new(grid, problem, α′, β′, κu, U, Bu, τ, mem, res, 4π)
    end
end

function initialize!(
        m::LocalAbstractTemperature1DModel,
        t::Float64,
        τ::Float64;
        T::Union{Float64,Nothing} = nothing,
        M::Int64 = 50
    )::Nothing
    "Set initial condition of thermal diffusion model."
    nsteps = convert(Int64, round(t / τ))
    m.τ[] = Base.step(range(0.0, t, nsteps))
    m.res[] = TimeSteppingSimulationResiduals(1, M, nsteps)
    m.mem[] = Temperature1DModelStorage(m.grid.N, nsteps)

    # Do not reinitialize a problem.
    if !isnothing(T)
        m.problem.x[:] .= T
    end

    return nothing
end

function CommonSolve.solve(
        m::LocalAbstractTemperature1DModel;
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

function DryTooling.Simulation.fouter!(
        m::LocalAbstractTemperature1DModel, t::Float64, n::Int64
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

    @. m.problem.b[1:end] = (m.α′ / m.τ[]) * m.problem.x
    m.problem.b[end] += U * B
    return nothing
end

function DryTooling.Simulation.finner!(
        m::LocalAbstractTemperature1DModel, t::Float64, n::Int64
    )::Nothing
    "Non-linear iteration updater for model."
    κ = interfaceconductivity1D(m.κ.(m.problem.x))
    β = κ .* m.β′
    α = m.α′./ m.τ[]

    # XXX: for now evaluating B.C. at mid-step, fix when going full
    # semi-implicit generalization!
    U = m.U(t + m.τ[]/2)

    m.problem.A.dl[1:end] = -β
    m.problem.A.du[1:end] = -β
    m.problem.A.d[1:end]  = α

    m.problem.A.d[2:end-1] += tail(β) + head(β)
    m.problem.A.d[1]       += first(β)
    m.problem.A.d[end]     += last(β) + U
    return nothing
end

function DryTooling.Simulation.fsolve!(
        m::LocalAbstractTemperature1DModel, t::Float64, n::Int64, α::Float64
    )::Float64
    "Solve problem for one non-linear step."
    ε = relaxationstep!(m.problem, α, maxabsolutechange)
    addresidual!(m.res[], [ε])
    return ε
end
