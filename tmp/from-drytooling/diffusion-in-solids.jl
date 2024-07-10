# -*- coding: utf-8 -*-
export AusteniteCarburizing1DModel
export initialize!
export solve
export plotcarburizedprofile

export interstitialmassintake
export carburize

struct AusteniteCarburizing1DModel <: AbstractDiffusionModel1D
    "Carbon diffusion in a plate represented in temperature space."

    "Grid over which problem will be solved."
    grid::AbstractGrid1D
    
    "Memory for model linear algebra problem."
    problem::TridiagonalProblem
    
    "Constant part of model coefficient α."
    α′::Vector{Float64}
    
    "Constant part of model coefficient β."
    β′::Vector{Float64}
    
    "Diffusivity terms of composition."
    D::Function
    
    "Global mass transfer coefficient."
    h::Function
    
    "Environment equivalent concentration."
    C::Function
    
    "Time-step used in integration."
    τ::Base.RefValue{Float64}
    
    "Memory storage for solution retrieval."
    mem::Base.RefValue{Temperature1DModelStorage}

    "Residuals tracking during solution."
    res::Base.RefValue{TimeSteppingSimulationResiduals}

    function AusteniteCarburizing1DModel(;
            grid::AbstractGrid1D,
            h::Union{Function,Float64},
            C::Union{Function,Float64},
            T::Float64
        )
        A(xc) = 4.84e-05exp(-38.0xc) / (1.0 - 5.0xc)
        E(xc) = 155_000.0 - 570_000.0xc
        D(xc) = A(xc) * exp(-E(xc) / (GAS_CONSTANT * T))

        hu = (typeof(h) <: Function) ? h : (t) -> h
        Cu = (typeof(C) <: Function) ? C : (t) -> C

        problem = TridiagonalProblem(grid.N)
        
        α′ = tail(grid.w) - head(grid.w)
        β′ = 1 ./ (tail(grid.r) - head(grid.r))

        τ = Ref(-Inf)
        mem = Ref(Temperature1DModelStorage(0, 0))
        res = Ref(TimeSteppingSimulationResiduals(1, 0, 0))

        return new(grid, problem, α′, β′, D, hu, Cu, τ, mem, res)
    end
end

function initialize!(
        m::AusteniteCarburizing1DModel,
        t::Float64,
        τ::Float64;
        x::Union{Float64,Nothing} = nothing,
        M::Int64 = 50
    )::Nothing
    "Set initial condition of thermal diffusion model."
    nsteps = convert(Int64, round(t / τ))
    m.τ[] = Base.step(range(0.0, t, nsteps))
    m.res[] = TimeSteppingSimulationResiduals(1, M, nsteps)
    m.mem[] = Temperature1DModelStorage(m.grid.N, nsteps)

    # Do not reinitialize a problem.
    if !isnothing(x)
        m.problem.x[:] .= x
    end

    return nothing
end

function DryTooling.Simulation.fouter!(
        m::AusteniteCarburizing1DModel, t::Float64, n::Int64
    )::Nothing
    "Time-step dependent updater for model."
    # XXX: for now evaluating B.C. at mid-step, fix when going full
    # semi-implicit generalization!
    h = m.h(t + m.τ[]/2)
    C = m.C(t + m.τ[]/2)

    # Follow surface mass flux and store partial solutions.
    m.mem[].t[n] = t
    m.mem[].Q[n] = h * (C - last(m.problem.x))
    m.mem[].T[n, 1:end] = m.problem.x

    @. m.problem.b[1:end] = (m.α′ / m.τ[]) * m.problem.x
    m.problem.b[end] += h * C
    return nothing
end

function DryTooling.Simulation.finner!(
        m::AusteniteCarburizing1DModel, t::Float64, n::Int64
    )::Nothing
    "Non-linear iteration updater for model."
    D = interfaceconductivity1D(m.D.(m.problem.x))
    β = D .* m.β′
    α = m.α′./ m.τ[]

    # XXX: for now evaluating B.C. at mid-step, fix when going full
    # semi-implicit generalization!
    h = m.h(t + m.τ[]/2)

    m.problem.A.dl[1:end] = -β
    m.problem.A.du[1:end] = -β
    m.problem.A.d[1:end]  = α

    m.problem.A.d[2:end-1] += tail(β) + head(β)
    m.problem.A.d[1]       += first(β)
    m.problem.A.d[end]     += last(β) + h
    return nothing
end

function DryTooling.Simulation.fsolve!(
        m::AusteniteCarburizing1DModel, t::Float64, n::Int64, α::Float64
    )::Float64
    "Solve problem for one non-linear step."
    ε = relaxationstep!(m.problem, α, maxabsolutechange)
    addresidual!(m.res[], [ε])
    return ε
end

function CommonSolve.solve(
        m::AusteniteCarburizing1DModel;
        t::Float64,
        τ::Float64,
        x::Union{Float64,Nothing} = nothing,
        M::Int64 = 50,
        α::Float64 = 0.1,
        ε::Float64 = 1.0e-10,
        t0::Float64 = 0.0
    )::Nothing
    "Interface for solving a `Cylinder1DTemperatureModel` instance."
    initialize!(m, t, τ; x, M)
    advance!(m; α, ε, M, t0)
    m.res[] = TimeSteppingSimulationResiduals(m.res[])
    return nothing
end

"""
	plotcarburizedprofile(
		model::AusteniteCarburizing1DModel,
		yc0::Float64;
		showstairs = true,
		xticks = nothing,
		yticks = nothing,
        label = nothing
	)

Display carburized profile and mass intake in a standardized way.
"""
function plotcarburizedprofile(
		model::AusteniteCarburizing1DModel,
		yc0::Float64;
		showstairs = true,
		xticks = nothing,
		yticks = nothing,
        label = nothing
	)
	z = model.grid.r
	yc = carburizemoletomassfraction.(model.problem.x)
	mc = interstitialmassintake(model.grid.r, yc0, yc)
	
	fig = Figure(resolution = (720, 500))
	ax = Axis(fig[1, 1], yscale = identity)
	lines!(ax, 1000z, 100reverse(yc), label = label)

	if showstairs
		stairs!(ax, 1000z, 100reverse(yc), color = :black, step = :center)
	end
	
	ax.title  = "Mass intake $(round(mc, digits = 2)) g/m²"
	ax.xlabel = "Coordinate [mm]"
	ax.ylabel = "Mass percentage [%]"

	if !isnothing(xticks)
		ax.xticks = xticks
		xlims!(ax, extrema(ax.xticks.val))
	end

	if !isnothing(yticks)
		ax.yticks = yticks
		ylims!(ax, extrema(ax.yticks.val))
	end

	return fig, ax
end

# TODO generalize these interfaces!

function carburizemasstomolefraction(w)
    return w * (w / 0.012 + (1 - w) / 0.055)^(-1) / 0.012
end

function carburizemoletomassfraction(x)
    return 0.012 * x / (0.012*x + (1 - x) * 0.055)
end

function interstitialmassintake(z, y0, yf; ρ = 7890.0)
    σ₀ = y0 * last(z) / (1.0 - y0)
    σ₁ = trapz(z, @. yf / (1.0 - yf))
    return 1000ρ  * (σ₁ - σ₀)
end

function carburize(grid, t, τ, T, h, y0, ys, ; M = 50)
    x = carburizemasstomolefraction(y0)
    C = carburizemasstomolefraction(ys)
    model = AusteniteCarburizing1DModel(; grid, h, C, T)
    @time solve(model; t, τ, x, M = M, α = 0.05)
    return model
end

