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
	
	# R = * 1u"J/(mol*K)"
end

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
		(Yₛ(t))[1:ns], [bounds = FRACTION,    unit = u"kg/kg"]
		(Yₖ(t))[1:ns], [bounds = FRACTION,    unit = u"kg/kg"]
		(ω̇ₖ(t))[1:ns], [bounds = FRACTION,    unit = u"mol/(m^3*s)"]
	end)

	eqs = [
		scalarize(@. ρ * Dt(Yₖ) ~ (ṁ / V) * (Yₛ - Yₖ) + ω̇ₖ * Wₖ)...,
		Dt(ṁ) ~ 0,
		Dt(p) ~ 0,
		Dt(T) ~ 0,
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
begin
	@info("Create individual reactors...")
	
	ns = 2

	# XXX: literals are not accepted!
	@parameters p = 101325   [unit = u"Pa"]
	@parameters T = 300.00   [unit = u"K"]
	@parameters Ẏₛ[1:ns]     [unit = u"1/s", tunable = false]
	
	@named r1 = simple_psr(; ns)
	@named r2 = simple_psr(; ns)
end

# ╔═╡ 8661ff7c-9162-4faf-84c8-fd8a63dac86f
let
	@info("Solve reactor 1 alone...")
	
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

	t = sol[:t]
	ρ = sol[r1.ρ]
	Yk1 = sol[r1.Yₖ[1]]
	Yk2 = sol[r1.Yₖ[2]]
	Ys1 = sol[r1.Yₛ[1]]
	Ys2 = sol[r1.Yₛ[2]]
	
	with_theme(WALLYMAKIETHEME) do
		f = Figure(size = (650, 250))
		
		ax = Axis(f[1, 1])
		lines!(ax, t, Yk1; label = "1")
		lines!(ax, t, Yk2; label = "2")
		axislegend(ax)
		xlims!(ax, 0, 10)
		ylims!(ax, 0, 1)

		ax.xlabel = "Time"
		ax.ylabel = "Mass fraction"
		
		ax = Axis(f[1, 2])
		lines!(ax, t, ρ; label = "ρ")
		axislegend(ax)
		xlims!(ax, 0, 10)
		ylims!(ax, 0.9, 1.3)

		ax.xlabel = "Time"
		ax.ylabel = "Density"
		
		f
	end
end

# ╔═╡ f268e793-e3db-444d-9814-c711b3097f45
let
	@info("Solve chain of reactors...")
	
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

	t = sol[:t]
	
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
		lines!(ax, t, Yk1_r1; label = "1 (R1)")
		lines!(ax, t, Yk2_r1; label = "2 (R1)")
		lines!(ax, t, Yk1_r2; label = "1 (R2)")
		lines!(ax, t, Yk2_r2; label = "2 (R2)")
		axislegend(ax)
		xlims!(ax, 0, 10)
		ylims!(ax, 0, 1)

		ax.xlabel = "Time"
		ax.ylabel = "Mass fraction"

		ax = Axis(f[1, 2])
		lines!(ax, t, Ys1_r1; label = "1 (R1)")
		lines!(ax, t, Ys2_r1; label = "2 (R1)")
		lines!(ax, t, Ys1_r2; label = "1 (R2)")
		lines!(ax, t, Ys2_r2; label = "2 (R2)")
		axislegend(ax)
		xlims!(ax, 0, 10)
		ylims!(ax, 0, 1)

		ax.xlabel = "Time"
		ax.ylabel = "Mass fraction"
		
		ax = Axis(f[2, 1:2])
		lines!(ax, t, ρ1; label = "ρ (R1)")
		lines!(ax, t, ρ2; label = "ρ (R2)")
		axislegend(ax)
		xlims!(ax, 0, 10)
		ylims!(ax, 0.8, 1.3)

		ax.xlabel = "Time"
		ax.ylabel = "Density"
		
		f
	end
end

# ╔═╡ 61fb90ca-4746-4ea9-9ad6-7831270ce610


# ╔═╡ 4565cbef-ec91-4864-8664-2c87d420e4a1


# ╔═╡ 78542421-ff40-4c7c-b04f-e175bcf8a171
let
	ns = 2

	NONNEGATIVE = (0.0, Inf)
	FRACTION    = (0.0, 1.0)
	
	@variables(begin
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
		0 ~ p * V - n * R * T,

		# Mean molecular mass definition:
		0 ~ W - sum([x * m for (x, m) in zip(X, M)]),

		# Molar fraction definition:
		0 ~ 1 - sum([x for x in X]),

		# Mass fraction definition:
		scalarize(Y .~ X .* M / W)...,
	]

	ModelingToolkit.validate(eqs)

	# @mtkbuild sys = NonlinearSystem(eqs)
	#, [p, V, n, T, X], [M, R])
    # sol = solve(NonlinearProblem(ns, [], []))
	
	eqs
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
# ╟─c2b9ab8c-7b8d-49f8-afba-b2176ee5862b
# ╟─703ff20d-f699-4720-a47c-061d3a425300
# ╟─c4ad6410-a73f-4301-b08b-4d4fb2ef5653
# ╟─c12d091e-4ff3-48be-8e20-f9bd4c0e3c19
# ╟─e81273c7-2aa5-40c4-a47f-1da71adc9c99
# ╟─8661ff7c-9162-4faf-84c8-fd8a63dac86f
# ╟─f268e793-e3db-444d-9814-c711b3097f45
# ╠═61fb90ca-4746-4ea9-9ad6-7831270ce610
# ╠═4565cbef-ec91-4864-8664-2c87d420e4a1
# ╠═78542421-ff40-4c7c-b04f-e175bcf8a171
