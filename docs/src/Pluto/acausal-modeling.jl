### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ 9c925920-a59d-11ef-260d-1f53b08ff458
begin
    @info("Initializing toolbox...")
    using Pkg
    
    open("pluto_init.log", "w") do logs
        Pkg.activate(ENV["WALLYROOT"]; io=logs)
        Pkg.instantiate(; io=logs)
    end

    # If you need to install something else:
    # Pkg.add("")

    push!(LOAD_PATH, @__DIR__)

    using PlutoLinks
    using PlutoUI: TableOfContents
        
    TableOfContents()
end

# ╔═╡ a5749da6-9201-47cc-ab00-78474b1aceb3
begin
    @info("External toolbox...")
	using CairoMakie
	using DifferentialEquations
	using DynamicQuantities
    using ModelingToolkit
	using Symbolics: scalarize
end

# ╔═╡ 66c5df79-aa9e-4e3b-aa22-94b85c1328a7
begin
    @info("Local toolbox...")
    @revise using WallyToolbox
end

# ╔═╡ ccbf51e6-7b46-432a-b8b8-9878c3625dac
md"""
# Acausal modeling
"""

# ╔═╡ 37399b27-e621-409f-993f-34c5c3ef98f4
md"""
## Toolset
"""

# ╔═╡ a4d95b96-ad6a-4505-a452-8ad80e21b328
begin
	@info("Constants...")
	
	NONNEGATIVE = (0.0, Inf)
	FRACTION    = (0.0, 1.0)
end;

# ╔═╡ 1473cb4b-d1a3-4724-a0de-3feb86d6238d
function debug_validation(eqs)
	if ModelingToolkit.validate(eqs)
		@info("PASSED!")
		@info(eqs)
	else
		@warn("FAILED!")
		@warn(eqs)
	end
end

# ╔═╡ 396c4e5f-416d-4c30-a092-eb621f32910e
md"""
## Independent variables
"""

# ╔═╡ 5eee63d6-61ed-4645-8d22-6197ab1bf4dd
@independent_variables(begin
	t, [unit = u"s"]
	z, [unit = u"m"]
end)

# ╔═╡ 105e9864-afd6-4b87-81c3-6266caea09e5
Dt = Differential(t)

# ╔═╡ 04d5aeab-3e0b-4483-83b6-d69338ae9a8a
Dz = Differential(z)

# ╔═╡ c6611b51-f83e-4c77-972d-2ff99808673b
@constants(begin
	R = GAS_CONSTANT,  [unit = u"J/(mol*K)"]
end)

# ╔═╡ 6d22dc37-a583-4c80-83e3-eb3c10fa411e
md"""
## Lessons learned

- Simple [model composition](https://docs.sciml.ai/ModelingToolkit/stable/basics/Composition/#Simple-Model-Composition-Example) is achieved by cascading functions from one model to another. This might not be the best way for complex flow models, where connectors are better suited.

- Dynamic quantities with units do not support literals as discussed [here](https://docs.sciml.ai/ModelingToolkit/stable/basics/Validation/#DynamicQuantities-Literals). To overcome this limitation one must create additional parameters or constants to accomodate fixed values.

- Numerical array parameters are tunable by default; if they are intended to be treated as constant, then the annotation `tunable = false` must be added to their metadata.

- When using `scalarize` to compose a system with other equations, unpack the resulting scalarized system (...). Although the list of equations would look the same withouht unpacking, the system will fail to assembly otherwise.

- If having trouble with kinetics integration (or anything else that might be stiff), consider checking [`solve`](https://docs.sciml.ai/DiffEqDocs/stable/basics/common_solver_opts/#CommonSolve.solve-Tuple%7BSciMLBase.AbstractDEProblem,%20Vararg%7BAny%7D%7D) arguments. Closing tolerances might be required in very stiff problems.

- Using macro `@extend` only works in global context. That implies that a model extending another must be declared in a different cell, so in this study notebook I had to take care of variable naming while trying to get as general as possible.

- Getting the sign convention for flow variables when using connectors might be tricky. If it is not working, try drawing a diagram of the intended system. In the mixer chain example below we set the flow leaving the `Source` object to be negative. The *Acausal modeling...* link below might also be useful.

Relevant topics on Discouse:

- [Acausal modeling of a chemical mixing process with heating using ModelingToolkit.jl](https://discourse.julialang.org/t/123475)

- [ModelingToolkit model with structural_simplify error: How to initialize variables correctly?](https://discourse.julialang.org/t/108110)

- [Component-based model for N reactors connected to a tank](https://discourse.julialang.org/t/119536)
"""

# ╔═╡ 5e252a2a-d44e-4678-83e7-83f9ebfe0ffb
md"""
## Simple(st) PSR reactor
"""

# ╔═╡ c2b9ab8c-7b8d-49f8-afba-b2176ee5862b
function simple_psr(; name, ns)
	@parameters(begin
		Wₖ[1:ns],      [bounds = NONNEGATIVE, unit = u"kg/mol"]
		V = 1.0,       [bounds = NONNEGATIVE, unit = u"m^3"]
	end)

	@variables(begin
		ṁ(t),          [bounds = NONNEGATIVE, unit = u"kg/s"]
		ρ(t),          [bounds = NONNEGATIVE, unit = u"kg/m^3"]
		p(t),          [bounds = NONNEGATIVE, unit = u"Pa"]
		T(t),          [bounds = NONNEGATIVE, unit = u"K"]
		Yₛ(t)[1:ns],   [bounds = FRACTION,    unit = u"kg/kg"]
		Yₖ(t)[1:ns],   [bounds = FRACTION,    unit = u"kg/kg"]
		Xₛ(t)[1:ns],   [bounds = FRACTION,    unit = u"mol/mol"]
		Xₖ(t)[1:ns],   [bounds = FRACTION,    unit = u"mol/mol"]
		ω̇ₖ(t)[1:ns],   [bounds = FRACTION,    unit = u"mol/(m^3*s)"]
	end)

	eqs = [
		scalarize(Xₛ ~ mass2molefraction(Yₛ, Wₖ))...
		scalarize(Xₖ ~ mass2molefraction(Yₖ, Wₖ))...
		scalarize(@. ρ * Dt(Yₖ) ~ (ṁ / V) * (Yₛ - Yₖ) + ω̇ₖ * Wₖ)...
		Dt(ṁ) ~ 0
		Dt(p) ~ 0
		Dt(T) ~ 0
	]

	# XXX: for development only:
	# debug_validation(eqs)

	return ODESystem(eqs, t; name)
end

# ╔═╡ 703ff20d-f699-4720-a47c-061d3a425300
psr_density(r)= meanmolecularmass(r.Yₖ, r.Wₖ) * r.p / (R * r.T)

# ╔═╡ c4ad6410-a73f-4301-b08b-4d4fb2ef5653
psr_species_concentration(r) = r.ρ * scalarize(@. r.Yₖ / r.Wₖ)

# ╔═╡ c12d091e-4ff3-48be-8e20-f9bd4c0e3c19
function psr_kinetics(r)
	@constants k = 0.5 [unit = u"1/s"]
	Cₖ = psr_species_concentration(r)
	rr = k * Cₖ[1]
	return [-1rr, +2rr]
end

# ╔═╡ e81273c7-2aa5-40c4-a47f-1da71adc9c99
let
	@info("Illustrate equations with a single reactor...")
	@named r1 = simple_psr(; ns = 2)
end

# ╔═╡ 9b8954f0-b49c-41a2-bbe5-97b23bada857
md"""
### Single reactor solution
"""

# ╔═╡ 8661ff7c-9162-4faf-84c8-fd8a63dac86f
let
	ns = 2

	# XXX: literals are not accepted!
	@parameters Ẏₛ[1:ns] [unit = u"1/s", tunable = false]
	@named r1 = simple_psr(; ns)
	
	eqs = [
		# Fix inlet composition:
		scalarize(Dt(r1.Yₛ) ~ Ẏₛ)...
		
		# Apply equation of state:
		r1.ρ ~ psr_density(r1)

		# Apply rate equations:
		scalarize(r1.ω̇ₖ ~ psr_kinetics(r1))...
	]
	
	cr1 = compose(ODESystem(eqs, t; name = :cr1), r1)
	sys = structural_simplify(cr1)
	@info(equations(sys))

	W = [0.030, 0.015]
	
	x0 = [
		r1.ṁ => 1.0
		r1.p => 101325
		r1.T => 298.15
		r1.Yₖ => [1, 0]
		r1.Yₛ => [1, 0]
	]
	
	ps = [r1.Wₖ => W, Ẏₛ => [0.0, 0.0]]
	
	prob = ODEProblem(sys, x0, (0.0, 10.0), ps)
	sol = solve(prob)

	time = sol[:t]
	ρ = sol[r1.ρ]
	Yk1 = sol[r1.Yₖ[1]]
	Yk2 = sol[r1.Yₖ[2]]
	Ys1 = sol[r1.Yₛ[1]]
	Ys2 = sol[r1.Yₛ[2]]
	
	with_theme(WALLYMAKIETHEME) do
		f = Figure(size = (650, 250))
		
		ax = Axis(f[1, 1])
		lines!(ax, time, Yk1; label = "1")
		lines!(ax, time, Yk2; label = "2")
		axislegend(ax)
		xlims!(ax, 0, 10)
		ylims!(ax, 0, 1)

		ax.xlabel = "Time"
		ax.ylabel = "Mass fraction"
		
		ax = Axis(f[1, 2])
		lines!(ax, time, ρ; label = "ρ")
		axislegend(ax)
		xlims!(ax, 0, 10)
		ylims!(ax, 0.9, 1.3)

		ax.xlabel = "Time"
		ax.ylabel = "Density"
		
		f
	end
end

# ╔═╡ eafe7043-b732-441b-b226-bd45b7da4ffd
md"""
### Chain of reactors
"""

# ╔═╡ f268e793-e3db-444d-9814-c711b3097f45
let
	ns = 2

	# XXX: literals are not accepted!
	@parameters Ẏₛ[1:ns] [unit = u"1/s", tunable = false]
	@named r1 = simple_psr(; ns)
	@named r2 = simple_psr(; ns)
	
	eqs = [
		# Fixed conditions.
		scalarize(Dt(r1.Yₛ) ~ Ẏₛ)...
		
		# Equation of state.
		r1.ρ ~ psr_density(r1)
		r2.ρ ~ psr_density(r2)

		# Cascade inlet composition.
		scalarize(r2.Yₛ ~ r1.Yₖ)
		
		# Cascade mass conservation.
		# r2.ṁ ~ r1.ṁ FIXME

		# Plug-in kinetics.
		scalarize(r1.ω̇ₖ ~ psr_kinetics(r1))...
		scalarize(r2.ω̇ₖ ~ psr_kinetics(r2))...
	]

	# debug_validation(eqs)
	connected = compose(ODESystem(eqs, t; name = :connected), r1, r2)
	sys = structural_simplify(connected)
	@info(equations(sys))

	W = [0.030, 0.015]
	
	x0 = [
		r1.ṁ => 1.0
		r1.p => 101325
		r1.T => 298.15

		# FIXME these are not working in chain!
		r2.ṁ => 1.0
		r2.p => 101325
		r2.T => 298.15
		
		r1.Yₖ => [1, 0]
		r1.Yₛ => [1, 0]
		
		r2.Yₖ => [1, 0]
	]
	
	ps = [r1.Wₖ => W, r2.Wₖ => W, Ẏₛ => [0.0, 0.0]]
	
	prob = ODEProblem(sys, x0, (0.0, 10.0), ps)
	sol = solve(prob)

	time = sol[:t]
	
	ρ1 = sol[r1.ρ]
	ρ2 = sol[r2.ρ]
	
	Yk1_r1 = sol[r1.Yₖ[1]]
	Yk2_r1 = sol[r1.Yₖ[2]]
	Yk1_r2 = sol[r2.Yₖ[1]]
	Yk2_r2 = sol[r2.Yₖ[2]]

	Ys1_r1 = sol[r1.Yₛ[1]]
	Ys2_r1 = sol[r1.Yₛ[2]]
	Ys1_r2 = sol[r2.Yₛ[1]]
	Ys2_r2 = sol[r2.Yₛ[2]]
	
	with_theme(WALLYMAKIETHEME) do
		f = Figure(size = (650, 450))
		
		ax = Axis(f[1, 1])
		lines!(ax, time, Yk1_r1; label = "1 (R1)")
		lines!(ax, time, Yk2_r1; label = "2 (R1)")
		lines!(ax, time, Yk1_r2; label = "1 (R2)")
		lines!(ax, time, Yk2_r2; label = "2 (R2)")
		axislegend(ax)
		xlims!(ax, 0, 10)
		ylims!(ax, 0, 1)

		ax.xlabel = "Time"
		ax.ylabel = "Mass fraction"

		ax = Axis(f[1, 2])
		lines!(ax, time, Ys1_r1; label = "1 (R1)")
		lines!(ax, time, Ys2_r1; label = "2 (R1)")
		lines!(ax, time, Ys1_r2; label = "1 (R2)")
		lines!(ax, time, Ys2_r2; label = "2 (R2)")
		axislegend(ax)
		xlims!(ax, 0, 10)
		ylims!(ax, 0, 1)

		ax.xlabel = "Time"
		ax.ylabel = "Mass fraction"
		
		ax = Axis(f[2, 1:2])
		lines!(ax, time, ρ1; label = "ρ (R1)")
		lines!(ax, time, ρ2; label = "ρ (R2)")
		axislegend(ax)
		xlims!(ax, 0, 10)
		ylims!(ax, 0.8, 1.3)

		ax.xlabel = "Time"
		ax.ylabel = "Density"
		
		f
	end
end

# ╔═╡ 1ba323c3-ad6e-4083-9c75-97c4f19ba657
md"""
### Arbitrary kinetics API
"""

# ╔═╡ 0e52135e-f9ad-4dbb-a5ab-a747fdc6cd66
# Initially fill reactors with N2 for Graf model.
function graf_y0(kin; x0 = 1.0e-06)
	X = zeros(length(kin.names))
	X[1:end-1] .= x0
	X[end] = 1 - sum(X[1:end-1])
	return mole2massfraction(X, kin.molecular_masses)
end

# ╔═╡ 595832e1-5647-42d4-b1fe-3cb69db0fe0d
# Mole fraction of acetylene (1) in system.
function graf_ys(kin; x1 = 0.36, f1 = 0.998)
	# Add acetylene impurities to initialization.
	# NOTE: in reference thesis it was assumed 98% purity and acetone
	# content of 1.8%, but that species is not available in Graf (2007).
	X = zeros(size(kin.molecular_masses))
	X[1] = (f1 - 0) * x1
	X[4] = (1 - f1) * x1
	X[end] = 1 - sum(X[1:end-1])

	# Convert to mass fractions for the model.
	return mole2massfraction(X, kin.molecular_masses)
end

# ╔═╡ 67aece96-edc2-4c70-941f-cc551c9968df
function graf_ṁ(kin, Ys, Q)
	M = meanmolecularmass(Ys, kin.molecular_masses)
	ρ = P_REF * M / (GAS_CONSTANT * 273.15) * 1u"kg/m^3"
	return ustrip((ρ * Q) |> us"kg/s")
end

# ╔═╡ f9482270-952f-4f5d-9ca0-89c4b7cd50ad
# Case 6 of my PhD thesis
graf_ops() = (
	p = 5000u"Pa",
	T = 1173.15u"K",
	Q = 222u"cm^3/min",
	R = 1.4u"cm",
	L = 35u"cm",
)

# ╔═╡ c2a6d64c-9af3-49ab-bbb6-8bbb2eb87386
function post_graf(r, sol)
	species_names = WallyToolbox.Graf2007.NAMES
	
	time = sol[:t]
	ρ = 100sol[r.ρ]
	Xk1 = 100sol[r.Xₖ[1]]
	Xk2 = 100sol[r.Xₖ[2]]
	Xk3 = 100sol[r.Xₖ[3]]
	Xk4 = 100sol[r.Xₖ[4]]
	Xk5 = 100sol[r.Xₖ[5]]
	Xk6 = 100sol[r.Xₖ[6]]
	Xk7 = 100sol[r.Xₖ[7]]

	with_theme(WALLYMAKIETHEME) do
		f = Figure(size = (650, 450))
		
		ax = Axis(f[1, 1])
		lines!(ax, time, Xk1; label = species_names[1])
				lines!(ax, time, Xk7; label = species_names[7])
		axislegend(ax; position = :rb)
		xlims!(ax, 0, 10)
		ylims!(ax, 0, 35)
		ax.xticks = 0:2:10
		ax.yticks = 0:5:35
		ax.xlabel = "Time"
		ax.ylabel = "Mole percent"
		
		ax = Axis(f[1, 2])
		lines!(ax, time, ρ; label = "ρ")
		axislegend(ax)
		xlims!(ax, 0, 10)
		ylims!(ax, 1.35, 1.45)
		ax.xticks = 0:2:10
		ax.yticks = 1.35:0.02:1.45
		ax.xlabel = "Time"
		ax.ylabel = "Density x 100"

		ax = Axis(f[2, 1])
		lines!(ax, time, Xk3; label = species_names[3])
		lines!(ax, time, Xk4; label = species_names[4])
		axislegend(ax; position = :rb)
		xlims!(ax, 0, 10)
		ylims!(ax, 0, 0.3)
		ax.xticks = 0:2:10
		ax.yticks = 0:0.05:0.3
		ax.xlabel = "Time"
		ax.ylabel = "Mole percent"
		
		ax = Axis(f[2, 2])
		lines!(ax, time, Xk2; label = species_names[2])
		lines!(ax, time, Xk5; label = species_names[5])
		lines!(ax, time, Xk6; label = species_names[6])

		axislegend(ax; position = :rt)
		xlims!(ax, 0, 10)
		ylims!(ax, 0, 1.8)
		ax.xticks = 0:2:10
		ax.yticks = 0:0.3:1.8
		ax.xlabel = "Time"
		ax.ylabel = "Mole percent"
		
		f
	end
end

# ╔═╡ e8ba3f51-d103-41ca-987f-8e6a0b37c7b2
let
	kinetics = WallyToolbox.Graf2007
	
	kin = kinetics.Model()
	ns = length(kin.names)
	
	@named r = simple_psr(; ns)
	@parameters Ẏₛ[1:ns] [unit = u"1/s", tunable = false]

	# C = psr_species_concentration(r)
	# ω = kinetics.progress_rate(r.T, r.p, C)
	ω = kinetics.progress_rate(r.T, r.ρ, r.Yₖ, r.Wₖ)
	
	eqs = [
		# Fix inlet composition:
		scalarize(Dt(r.Yₛ) ~ Ẏₛ)...
		
		# Apply equation of state:
		r.ρ ~ psr_density(r)

		# Apply rate equations:
		scalarize(r.ω̇ₖ ~ ω)...
	]

	# debug_validation(eqs)
	sys = compose(ODESystem(eqs, t; name = :graf), r)
	sys = structural_simplify(sys)
	@info(equations(sys))
	# @info(unknowns(sys)) => Notice derivatives are listed!

	# Case 6 of my PhD thesis
	Y0 = graf_y0(kin)
	Ys = graf_ys(kin; x1 = 0.36)	
	ops = graf_ops()

	x0 = [
		r.ṁ  => graf_ṁ(kin, Ys, ops.Q)
		r.p  => ustrip(ops.p)
		r.T  => ustrip(ops.T)
		r.Yₖ => Y0
		r.Yₛ => Ys
	]

	ps = [
		r.V  => ustrip(pi * ops.R^2 * ops.L)
		r.Wₖ => kin.molecular_masses
		Ẏₛ   => zeros(ns)
	]

	prob = ODEProblem(sys, x0, (0.0, 10.0), ps)
	
	sol = solve(prob;
		alg_hints = :stiff,
		dtmax     = 0.01,
		abstol    = 1.0e-09
	)

	post_graf(r, sol)
end

# ╔═╡ 61fb90ca-4746-4ea9-9ad6-7831270ce610
md"""
## Working with connectors
"""

# ╔═╡ 84262231-3269-45b4-9dca-0ab510567187
md"""
Let's now try to transpose this to a more `ModelingToolkit` way with help of the [base tutorial](https://docs.sciml.ai/ModelingToolkit/stable/tutorials/acausal_components/).
"""

# ╔═╡ 71a42560-2dd7-468f-a484-57a51ba01615
md"""
### Constant density mixer chain
"""

# ╔═╡ 0060a8cc-2239-4b9e-9409-3a97f6be59ea
"Represents fluid flow intensity and composition."
@connector Solution begin
	ṁ(t), [connect = Flow, unit = u"kg/s"]
	Y(t), [unit = u"kg/kg"]
end

# ╔═╡ 4799a05e-b52d-412f-8b91-49caec3313d1
"Constant mass flow rate and composition source."
@mtkmodel SolutionSource begin
	@components begin
		n = Solution()
	end
	@parameters begin
		ṁ, [unit = u"kg/s"]
		Y, [unit = u"kg/kg"]
	end
	@equations begin
		n.ṁ ~ -ṁ
		n.Y ~ Y
	end
end

# ╔═╡ 76866712-fa1e-4beb-8739-76a02dbe89e7
"Mass flow sink for system closure."
@mtkmodel SolutionSink begin
	@components begin
		p = Solution()
	end
	@variables begin
		ṁ(t), [unit = u"kg/s"]
		Y(t), [unit = u"kg/kg"]
	end
	@equations begin
		p.ṁ ~ ṁ
		p.Y ~ Y
	end
end

# ╔═╡ 1222ff23-a81d-4318-8ed7-550b3d1f4df3
"Constant volume chamber with inlet/outlet flows."
@mtkmodel SolutionChamber begin
	@components begin
		p = Solution()
		n = Solution()
	end
	@variables begin
		ṁ(t), [unit = u"kg/s"]
		Y(t), [unit = u"kg/kg"]
	end
	@equations begin
		0 ~ p.ṁ + n.ṁ
	end
end

# ╔═╡ efd7da54-0f03-4845-a06b-488c2356a103
"Constant volume perfect-stirred reactor."
@mtkmodel SolutionReactor begin
	@extend SolutionChamber()
	@parameters begin
		ρ, [unit = u"kg/m^3"]
		V, [unit = u"m^3"]
	end
	@equations begin
		ṁ ~ p.ṁ
		Y ~ n.Y
		ρ * Dt(Y) ~ (ṁ / V) * (p.Y - Y)
	end
end

# ╔═╡ 5f3e3c6d-ac7c-4cd0-9be7-539c48f848fc
"User-defined chain of reactors."
@mtkmodel SolutionMixer begin
	@components begin
		source    = SolutionSource()
		reactor_1 = SolutionReactor()
		reactor_2 = SolutionReactor()
		reactor_3 = SolutionReactor()
		sink      = SolutionSink()
	end
	@equations begin
		connect(source.n, reactor_1.p)
		connect(reactor_1.n, reactor_2.p)
		connect(reactor_2.n, reactor_3.p)
		connect(reactor_3.n, sink.p)
	end
end

# ╔═╡ dd020c3e-f621-4175-9d63-867bb14ddf0e
@mtkbuild solution_mixer = SolutionMixer()

# ╔═╡ a9dc6cb2-fa1c-46b9-808f-c8706fc36e91
let
	model = solution_mixer
	
	u0 = [
		model.reactor_1.Y => 0.0
		model.reactor_2.Y => 0.2
	]

	ps = [
		# Inlet controls:
		model.source.ṁ => 1.0
		model.source.Y => 0.1

		# Reactors parameters:
		model.reactor_1.ρ => 1.0
		model.reactor_1.V => 2.5

		model.reactor_2.ρ => 1.0
		model.reactor_2.V => 1.0

		model.reactor_3.ρ => 1.0
		model.reactor_3.V => 1.0
	]
	
	prob = ODEProblem(model, u0, (0, 10.0), ps)
	sol = solve(prob; saveat=0:0.01:10)

	with_theme(WALLYMAKIETHEME) do
		f = Figure(size = (650, 450))
		ax = Axis(f[1, 1])
	
		lines!(ax, sol[:t], 100sol[model.reactor_1.Y]; label = "1")
		lines!(ax, sol[:t], 100sol[model.reactor_2.Y]; label = "2")
		lines!(ax, sol[:t], 100sol[model.reactor_3.Y]; label = "3")

		hlines!(ax, 100sol[model.source.n.Y]; linestyle = :dash)
		xlims!(ax, 0.0, 10.0)
		ylims!(ax, 0.0, 20.0)
	
		ax.xlabel = "Time [s]"
		ax.ylabel = "Mass percentage"
		ax.xticks = 0.0:2.0:10.0
		ax.yticks = 0.0:4.0:20.0
		
		axislegend(ax; position = :rb)
		
		f
	end
end

# ╔═╡ 503fe098-11b4-47fb-bac1-84b6dc7a60e9
md"""
### Arbitrary species and closures
"""

# ╔═╡ 1a18597b-4c0c-48f0-810d-269985dab7a1
@warn("DO NOT DELETE THESE DRAFTS!")
# "A multicomponent mass flow port."
# @connector MulticomponentFlowPort begin
# 	@structural_parameters begin
# 		Nc
# 	end
# 	@parameters begin
# 		Yc[1:Nc] = zeros(Nc)
# 	end
# 	@variables begin
# 		ṁ(t),
# 			[unit = u"kg/s"]#, connect = Flow]
# 		(Y(t))[1:Nc] = Yc,
# 			[unit = u"kg/kg"]
# 	end
# end
#
# @connector MixtureFlowPort begin
# 	@extend MulticomponentFlowPort()
# 	@variables begin
# 		T(t),
# 			[unit = u"K"]
# 		p(t),
# 			[unit = u"Pa"]
# 	end
# end
#
# "Mixture chamber with inlet/outlet flows."
# @mtkmodel MixtureFlowChamber begin
# 	@structural_parameters begin
# 		Nc
# 	end
# 	@components begin
# 		ustream = MixtureFlowPort(; Nc)
# 		dstream = MixtureFlowPort(; Nc)
# 	end
# 	@parameters begin
# 		W[1:Nc],
# 			[unit = u"kg/mol"]
# 	end
# 	@variables begin
# 		ṁ(t),
# 			[unit = u"kg/s"]
# 		ρ(t),
# 			[unit = u"kg/m^3"]
# 		T(t),
# 			[unit = u"K"]
# 		p(t),
# 			[unit = u"Pa"]
# 		Y(t)[1:Nc] = 0u"kg/kg",
# 			[unit = u"kg/kg"]
# 		X(t)[1:Nc] = 0u"mol/mol",
# 			[unit = u"mol/mol"]
# 	end
# 	@equations begin
# 		# Mass conservation:
# 		0 ~ ustream.ṁ + dstream.ṁ
#
# 		# Inherits from ustream:
# 		ṁ ~ ustream.ṁ
#
# 		# Propagates dstream:
# 		Y ~ dstream.Y
#
# 		# Observable for post-processing:
# 		scalarize(X ~ mass2molefraction(Y, W))...
# 	end
# end
#
# "Constant volume mixture perfect-stirred reactor."
# @mtkmodel MixtureFlowReactor begin
# 	@extend MixtureFlowChamber()
# 	@structural_parameters begin
# 		density
# 		kinetics
# 	end
# 	@parameters begin
# 		V,
# 			[unit = u"m^3"]
# 	end
# 	@variables begin
# 		ω̇(t)[1:Nc] = 0u"mol/(m^3*s)",
# 			[unit = u"mol/(m^3*s)"]
# 	end
# 	@equations begin
# 		# Reactor equations:
# 		scalarize(@. ρ * Dt(Y) ~ (ṁ / V) * (ustream.Y - Y) + ω̇ * W)...
#
# 		# System closure:
# 		ρ ~ density(T, p, Y, W)
# 		scalarize(ω̇ ~ kinetics(T, ρ, Y, W))...
#	
# 		# XXX: this should later be computed
# 		Dt(T) ~ 0
# 		Dt(p) ~ 0
# 	end
# end

# ╔═╡ ec643577-ae2c-4319-b942-8555a02edcd3
begin
	"A multicomponent mass flow port with state variables."
	@connector MixtureFlowPort begin
		@structural_parameters begin
			Nc
		end
		@variables begin
			ṁ(t),
				[unit = u"kg/s", connect = Flow]
			T(t),
				[unit = u"K"]
			p(t),
				[unit = u"Pa"]
			Y(t)[1:Nc] = 0u"kg/kg",
				[unit = u"kg/kg"]
		end
	end

	"Specified state and mass flow rate source."
	@mtkmodel MixtureFlowSource begin
		@structural_parameters begin
			Nc
		end
		@components begin
			dstream = MixtureFlowPort(; Nc)
		end
		@parameters begin
			ṁ,
				[unit = u"kg/s"]
			T,
				[unit = u"K"]
			p,
				[unit = u"Pa"]
			Y[1:Nc],
				[unit = u"kg/kg", tunable = false]
		end
		@equations begin
			dstream.ṁ ~ -ṁ
			dstream.T ~ T
			dstream.p ~ p
			scalarize(dstream.Y ~ Y)...
		end
	end

	"Mixture flow sink for system closure."
	@mtkmodel MixtureFlowSink begin
		@structural_parameters begin
			Nc
		end
		@components begin
			ustream = MixtureFlowPort(; Nc)
		end
		@variables begin
			ṁ(t),
				[unit = u"kg/s"]
			T(t),
				[unit = u"K"]
			p(t),
				[unit = u"Pa"]
			Y(t)[1:Nc] = 0u"kg/kg",
				[unit = u"kg/kg"]
		end
		@equations begin
			ustream.ṁ ~ ṁ
			ustream.T ~ T
			ustream.p ~ p
			scalarize(ustream.Y ~ Y)...
		end
	end

	"Constant volume mixture perfect-stirred reactor."
	@mtkmodel MixtureFlowReactor begin
		@structural_parameters begin
			Nc
			density
			kinetics
		end
		@components begin
			ustream = MixtureFlowPort(; Nc)
			dstream = MixtureFlowPort(; Nc)
		end
		@parameters begin
			V,
				[unit = u"m^3"]
			W[1:Nc],
				[unit = u"kg/mol"]
		end
		@variables begin
			ṁ(t),
				[unit = u"kg/s"]
			ρ(t),
				[unit = u"kg/m^3"]
			T(t),
				[unit = u"K"]
			p(t),
				[unit = u"Pa"]
			Y(t)[1:Nc] = 0u"kg/kg",
				[unit = u"kg/kg"]
			X(t)[1:Nc] = 0u"mol/mol",
				[unit = u"mol/mol"]
			ω̇(t)[1:Nc] = 0u"mol/(m^3*s)",
				[unit = u"mol/(m^3*s)"]
		end
		@equations begin
			# Mass conservation:
			0 ~ ustream.ṁ + dstream.ṁ
	
			# Inherits from ustream:
			ṁ ~ ustream.ṁ
	
			# Propagates dstream:
			Y ~ dstream.Y
			
			# Observable for post-processing:
			scalarize(X ~ mass2molefraction(Y, W))...
			
			# Reactor equations:
			scalarize(@. ρ * Dt(Y) ~ (ṁ / V) * (ustream.Y - Y) + ω̇ * W)...
	
			# System closure:
			ρ ~ density(T, p, Y, W)
			scalarize(ω̇ ~ kinetics(T, ρ, Y, W))...
			
			# XXX: this should later be computed
			Dt(T) ~ 0
			Dt(p) ~ 0
		end
	end
end;

# ╔═╡ 6f7a0fc3-dee9-4063-91eb-57e94bad5c4f
"User-defined chain of ideal gas reactors."
@mtkmodel IdealGasMixtureFlowChain begin
	@structural_parameters begin
		Nc
		density
		kinetics
	end
	@components begin
		source    = MixtureFlowSource(; Nc)
		reactor_1 = MixtureFlowReactor(; Nc, density, kinetics)
		sink      = MixtureFlowSink(; Nc)
	end
	@equations begin
		connect(   source.dstream, reactor_1.ustream)
		connect(reactor_1.dstream,      sink.ustream)
	end
end
		# connect(reactor_1.dstream, reactor_2.ustream)
		# connect(reactor_2.dstream, reactor_3.ustream)
		# reactor_2 = MixtureFlowReactor(; Nc, density, kinetics)
		# reactor_3 = MixtureFlowReactor(; Nc, density, kinetics)

# ╔═╡ 07fc023e-6c24-4e83-8dac-4dc881499eef
"Ideal gas density state function."
function ideal_gas_density(T, p, Y, W)
	return p * meanmolecularmass(Y, W) / (R * T)
end

# ╔═╡ 73425507-4f37-496b-96fa-25f47b873dd0
chain_mix, chain_x0, chain_ps = let
	@info("Creating model...")

	kin_module  = WallyToolbox.Graf2007
	kin_manager = kin_module.Model()

	# @named r = IdealGasMixtureFlowChain(;
	@mtkbuild sys = IdealGasMixtureFlowChain(;
		Nc       = length(kin_manager.names),
		density  = ideal_gas_density,
		kinetics = (T, ρ, Y, W) -> kin_module.progress_rate(T, ρ, Y, W)
	)
	
	Y0 = graf_y0(kin_manager)
	Ys = graf_ys(kin_manager)	
	ops = graf_ops()

	x0 = [
		sys.reactor_1.T => ustrip(ops.T)
		sys.reactor_1.p => ustrip(ops.p)
		sys.reactor_1.Y => Y0
		
		Dt(sys.reactor_1.Y)[1] => 0
		Dt(sys.reactor_1.Y)[2] => 0
		Dt(sys.reactor_1.Y)[3] => 0
		Dt(sys.reactor_1.Y)[4] => 0
		Dt(sys.reactor_1.Y)[5] => 0
		Dt(sys.reactor_1.Y)[6] => 0
		Dt(sys.reactor_1.Y)[7] => 0
		Dt(sys.reactor_1.Y)[8] => 0
		
		# sys.reactor_2.T => ustrip(ops.T)
		# sys.reactor_2.p => ustrip(ops.p)
		# sys.reactor_2.Y => Y0
		
		# sys.reactor_3.T => ustrip(ops.T)
		# sys.reactor_3.p => ustrip(ops.p)
		# sys.reactor_3.Y => Y0

		sys.sink.ṁ      => graf_ṁ(kin_manager, Ys, ops.Q)
		sys.sink.T      => ustrip(ops.T)
		sys.sink.p      => ustrip(ops.p)
		sys.sink.Y      => Y0

		# sys.source.dstream.Y => Ys
		# sys.reactor_1.ustream.Y => Ys
		# sys.reactor_1.dstream.Y => Ys
		# sys.sink.ustream.Y => Ys
	]

	# TODO W should be the chain who gives these!
	ps = [
		sys.source.ṁ => graf_ṁ(kin_manager, Ys, ops.Q)
		sys.source.Y => Ys
		sys.source.T => ustrip(ops.T)
		sys.source.p => ustrip(ops.p)
		
		sys.reactor_1.V => ustrip(pi * ops.R^2 * ops.L)
		sys.reactor_1.W => kin_manager.molecular_masses
		
		# sys.reactor_2.V => ustrip(pi * ops.R^2 * ops.L)
		# sys.reactor_2.W => kin_manager.molecular_masses
		
		# sys.reactor_3.V => ustrip(pi * ops.R^2 * ops.L)
		# sys.reactor_3.W => kin_manager.molecular_masses
	]

	# prob = ODEProblem(sys, x0, (0.0, 10.0), ps)
	
	# sol = solve(prob;
	# 	alg_hints = :stiff,
	# 	dtmax     = 0.01,
	# 	abstol    = 1.0e-09
	# )

	# post_graf(r, sol)

	sys, x0, ps
end;

# ╔═╡ 3bf24123-061c-4ff2-b22d-5dd1254f338b
# values(chain_mix.source)

# ╔═╡ eec2b4ea-99b1-4636-87b3-4057b40302f8
equations(chain_mix)

# ╔═╡ 7fbcae10-6108-47c0-afd1-54277841d083
parameters(chain_mix)

# ╔═╡ 15990f21-09f9-432a-9ba4-70dae309d43c
unknowns(chain_mix)

# ╔═╡ 3340edc8-b0f9-47d4-bce1-723ca61f24b0
chain_ps

# ╔═╡ a9d86985-c6ca-4712-ac33-06b25d8d45f2
chain_x0

# ╔═╡ 9545511c-d0d5-4d3a-85e2-67a785b4f760
# equations(chain_mix)

# ╔═╡ 64e7bdba-1714-4842-a630-f90a1a7007ac
# parameters(chain_mix.source), unknowns(chain_mix.source)

# ╔═╡ f925daa5-51e7-47be-8f3b-5640083b3771
# parameters(chain_mix.reactor_1), unknowns(chain_mix.reactor_1)

# ╔═╡ 98470e24-2593-42ea-9796-1e34cdd78454
# parameters(chain_mix.sink), unknowns(chain_mix.sink)

# ╔═╡ 510bbc43-af2e-4841-928b-bc35d02d44f1
# parameters(chain_mix), unknowns(chain_mix)

# ╔═╡ 230f050f-00bd-4b3b-9c2f-d7b0ae0037e7
# prob = ODEProblem(chain_mix, chain_x0, (0.0, 10.0), chain_ps)

# ╔═╡ 4565cbef-ec91-4864-8664-2c87d420e4a1
md"""
## Sandbox
"""

# ╔═╡ a0d9b9d2-5dbf-436e-8999-8a684e2b5534
function ideal_gas_law(; name, ns)
	@variables(begin
		ρ,       [bounds = NONNEGATIVE, unit = u"kg/m^3"]
		p,       [bounds = NONNEGATIVE, unit = u"Pa"]
		V,       [bounds = NONNEGATIVE, unit = u"m^3"]
		n,       [bounds = NONNEGATIVE, unit = u"mol"]
		T,       [bounds = NONNEGATIVE, unit = u"K"]
		W,       [bounds = NONNEGATIVE, unit = u"kg/mol"]
		Y[1:ns], [bounds = FRACTION,    unit = u"kg/kg"]
		X[1:ns], [bounds = FRACTION,    unit = u"mol/mol"]
	end) 
	
	@parameters(begin
		M[1:ns], [bounds = NONNEGATIVE, unit = u"kg/mol"]
	end)

	@constants R = GAS_CONSTANT [unit = u"J/(mol*K)"]
	
	eqs = [
		# Ideal gas law:
		0 ~ p * V - n * R * T
		0 ~ ρ - p * W / (R * T)
		
		# Mean molecular mass definition:
		0 ~ W - meanmolecularmass(Y, M)

		# Molar fraction definition:
		# 0 ~ 1 - sum(scalarize(X))

		# Mass fraction definition:
		scalarize(Y .~ X .* M / W)...
	]

	# XXX: for development only:
	# debug_validation(eqs)

	return NonlinearSystem(eqs; name)
end

# ╔═╡ 78542421-ff40-4c7c-b04f-e175bcf8a171
let
	@warn("Thinking on how to get an arbitrary state equation working...")
	@warn("It is getting better but I still need some work here...")
	
	ns = 2

	@named r = ideal_gas_law(; ns)

	@parameters p [unit = u"Pa"]
	@parameters T [unit = u"K"]
	@parameters n [unit = u"mol"]
	@parameters V [unit = u"m^3"]
	@parameters Y[1:ns] [unit = u"kg/kg", tunable = false]

	eqs = [
		r.p ~ p
		r.T ~ T
		r.V ~ V
		# r.Y[1] ~ Y[1]
		scalarize(r.Y ~ Y)...
	]

	# debug_validation(eqs)
	sys = compose(NonlinearSystem(eqs; name = :igl), r)
	sys = structural_simplify(sys)

	normalized(v) = v ./ sum(v)
	
	ps = [
		p   => 101325
		T   => 298.15
		V   => 50.0
		Y   => normalized([0.77, 0.23])
		# Y[1] => 0.6
		r.M => [0.028, 0.032]
	]

	guesses = [
		r.n => 1
		r.X => ones(ns)
		# r.X[2] => 1
		# r.Y[2] => 1
	]
	prob = NonlinearProblem(sys, guesses, ps)
	sol = solve(prob)

	@info equations(sys)
	@info unknowns(sys)
	@info parameters(sys)
	@info observed(sys)

	@info sol[r.ρ]
	@info sol[r.W]
	@info sol[r.Y] sum(sol[r.Y])
	@info sol[r.X] sum(sol[r.X])
	@info sol
end

# ╔═╡ Cell order:
# ╟─ccbf51e6-7b46-432a-b8b8-9878c3625dac
# ╟─37399b27-e621-409f-993f-34c5c3ef98f4
# ╟─9c925920-a59d-11ef-260d-1f53b08ff458
# ╟─a5749da6-9201-47cc-ab00-78474b1aceb3
# ╟─66c5df79-aa9e-4e3b-aa22-94b85c1328a7
# ╟─a4d95b96-ad6a-4505-a452-8ad80e21b328
# ╟─1473cb4b-d1a3-4724-a0de-3feb86d6238d
# ╟─396c4e5f-416d-4c30-a092-eb621f32910e
# ╟─5eee63d6-61ed-4645-8d22-6197ab1bf4dd
# ╟─105e9864-afd6-4b87-81c3-6266caea09e5
# ╟─04d5aeab-3e0b-4483-83b6-d69338ae9a8a
# ╟─c6611b51-f83e-4c77-972d-2ff99808673b
# ╟─6d22dc37-a583-4c80-83e3-eb3c10fa411e
# ╟─5e252a2a-d44e-4678-83e7-83f9ebfe0ffb
# ╠═c2b9ab8c-7b8d-49f8-afba-b2176ee5862b
# ╟─703ff20d-f699-4720-a47c-061d3a425300
# ╟─c4ad6410-a73f-4301-b08b-4d4fb2ef5653
# ╟─c12d091e-4ff3-48be-8e20-f9bd4c0e3c19
# ╟─e81273c7-2aa5-40c4-a47f-1da71adc9c99
# ╟─9b8954f0-b49c-41a2-bbe5-97b23bada857
# ╟─8661ff7c-9162-4faf-84c8-fd8a63dac86f
# ╟─eafe7043-b732-441b-b226-bd45b7da4ffd
# ╟─f268e793-e3db-444d-9814-c711b3097f45
# ╟─1ba323c3-ad6e-4083-9c75-97c4f19ba657
# ╟─0e52135e-f9ad-4dbb-a5ab-a747fdc6cd66
# ╟─595832e1-5647-42d4-b1fe-3cb69db0fe0d
# ╟─67aece96-edc2-4c70-941f-cc551c9968df
# ╟─f9482270-952f-4f5d-9ca0-89c4b7cd50ad
# ╟─c2a6d64c-9af3-49ab-bbb6-8bbb2eb87386
# ╟─e8ba3f51-d103-41ca-987f-8e6a0b37c7b2
# ╟─61fb90ca-4746-4ea9-9ad6-7831270ce610
# ╟─84262231-3269-45b4-9dca-0ab510567187
# ╟─71a42560-2dd7-468f-a484-57a51ba01615
# ╟─0060a8cc-2239-4b9e-9409-3a97f6be59ea
# ╟─4799a05e-b52d-412f-8b91-49caec3313d1
# ╟─76866712-fa1e-4beb-8739-76a02dbe89e7
# ╟─1222ff23-a81d-4318-8ed7-550b3d1f4df3
# ╟─efd7da54-0f03-4845-a06b-488c2356a103
# ╟─5f3e3c6d-ac7c-4cd0-9be7-539c48f848fc
# ╟─dd020c3e-f621-4175-9d63-867bb14ddf0e
# ╟─a9dc6cb2-fa1c-46b9-808f-c8706fc36e91
# ╟─503fe098-11b4-47fb-bac1-84b6dc7a60e9
# ╟─1a18597b-4c0c-48f0-810d-269985dab7a1
# ╠═ec643577-ae2c-4319-b942-8555a02edcd3
# ╠═6f7a0fc3-dee9-4063-91eb-57e94bad5c4f
# ╟─07fc023e-6c24-4e83-8dac-4dc881499eef
# ╠═73425507-4f37-496b-96fa-25f47b873dd0
# ╠═3bf24123-061c-4ff2-b22d-5dd1254f338b
# ╠═eec2b4ea-99b1-4636-87b3-4057b40302f8
# ╠═7fbcae10-6108-47c0-afd1-54277841d083
# ╠═15990f21-09f9-432a-9ba4-70dae309d43c
# ╠═3340edc8-b0f9-47d4-bce1-723ca61f24b0
# ╠═a9d86985-c6ca-4712-ac33-06b25d8d45f2
# ╠═9545511c-d0d5-4d3a-85e2-67a785b4f760
# ╠═64e7bdba-1714-4842-a630-f90a1a7007ac
# ╠═f925daa5-51e7-47be-8f3b-5640083b3771
# ╠═98470e24-2593-42ea-9796-1e34cdd78454
# ╠═510bbc43-af2e-4841-928b-bc35d02d44f1
# ╠═230f050f-00bd-4b3b-9c2f-d7b0ae0037e7
# ╟─4565cbef-ec91-4864-8664-2c87d420e4a1
# ╟─a0d9b9d2-5dbf-436e-8999-8a684e2b5534
# ╟─78542421-ff40-4c7c-b04f-e175bcf8a171
