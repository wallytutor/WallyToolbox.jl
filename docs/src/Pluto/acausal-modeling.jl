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

- When using `scalarize` to compose a system with other equations, unpack the resulting scalarized system (...). Although the list of equations would look the same withouht unpacking, the system will fail to assembly otherwise.

- If having trouble with kinetics integration (or anything else that might be stiff), consider checking [`solve`](https://docs.sciml.ai/DiffEqDocs/stable/basics/common_solver_opts/#CommonSolve.solve-Tuple%7BSciMLBase.AbstractDEProblem,%20Vararg%7BAny%7D%7D) arguments. Closing tolerances might be required in very stiff problems.


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
		(Yₛ(t))[1:ns], [bounds = FRACTION,    unit = u"kg/kg"]
		(Yₖ(t))[1:ns], [bounds = FRACTION,    unit = u"kg/kg"]
		(Xₛ(t))[1:ns], [bounds = FRACTION,    unit = u"mol/mol"]
		(Xₖ(t))[1:ns], [bounds = FRACTION,    unit = u"mol/mol"]
		(ω̇ₖ(t))[1:ns], [bounds = FRACTION,    unit = u"mol/(m^3*s)"]
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

	C = psr_species_concentration(r)
	ω = kinetics.progress_rate(r.T, r.p, C)
	
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

	# Initially filled with N2
	Y0 = let
		X = zeros(ns)
		X[1:end-1] .= 1.0e-06
		X[end] = 1 - sum(X[1:end-1])
		mole2massfraction(X, kin.molecular_masses)
	end
	
	# Source gas is 36% *C2H2*
	Ys = let 
	    # Mole fraction of acetylene (1) in system.
	    x1 = 0.36
	
	    # Add acetylene impurities to initialization.
	    # NOTE: in reference thesis it was assumed 98% purity and acetone
	    # content of 1.8%, but that species is not available in Graf (2007).
	    X = zeros(size(kin.molecular_masses))
	    X[1] = 0.998 * x1
	    X[4] = 0.002 * x1
	    X[end] = 1 - sum(X[1:end-1])
	
	    # Convert to mass fractions for the model.
	    mole2massfraction(X, kin.molecular_masses)
	end
	
	# Case 6 of my PhD thesis
	p = 5000u"Pa"
	T = 1173.15u"K"
	Q = 222u"cm^3/min"
	
	# Dimensions of reactor [m].
	R = 1.4u"cm"
	L = 35u"cm"
	
	# Reference mass flow rate
	M = meanmolecularmass(Ys, kin.molecular_masses)
	ρ = P_REF * M / (GAS_CONSTANT * 273.15) * 1u"kg/m^3"
	V = pi * R^2 * L
	ṁ = ustrip((ρ * Q) |> us"kg/s")
	
	x0 = [
		r.ṁ  => ṁ
		r.p  => ustrip(p)
		r.T  => ustrip(T)
		r.Yₖ => Y0
		r.Yₛ => Ys
	]

	ps = [
		r.V  => ustrip(V)
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

# ╔═╡ c063ffbb-11f3-43b0-9c2a-fb70d08d81a7
begin
	Ns = 2
	
	@connector StirredReactor begin
		ṁ(t),          [unit = u"kg/s"]
	end

	@mtkmodel OnePort begin
	    @components begin
	        p = StirredReactor()
	        n = StirredReactor()
	    end
	    @variables begin
	        ṁ(t),          [unit = u"kg/s"]
			ρ(t),          [unit = u"kg/m^3"]
			p(t),          [unit = u"Pa"]
			T(t),          [unit = u"K"]
			(Yₛ(t))[1:Ns], [unit = u"kg/kg"]
			(Yₖ(t))[1:Ns], [unit = u"kg/kg"]
			(Xₛ(t))[1:Ns], [unit = u"mol/mol"]
			(Xₖ(t))[1:Ns], [unit = u"mol/mol"]
			(ω̇ₖ(t))[1:Ns], [unit = u"mol/(m^3*s)"]
	    end
	    @equations begin
	        0 ~ p.ṁ + n.ṁ
	        ṁ ~ p.ṁ
			# scalarize(Xₛ ~ mass2molefraction(Yₛ, Wₖ))...
			# scalarize(Xₖ ~ mass2molefraction(Yₖ, Wₖ))...
	    end
	end

	@mtkmodel SourceReservoir begin
	    @components begin
	        n = StirredReactor()
	    end
		@parameters begin
			ṁ(t),          [unit = u"kg/s"]
			p(t),          [unit = u"Pa"]
			T(t),          [unit = u"K"]
			(Y(t))[1:Ns],  [unit = u"kg/kg"]
		end
	    @equations begin
	        n.ṁ ~ ṁ
			n.p ~ p
			n.T ~ T
			n.Yₛ ~ Y
	    end
	end
	
	@mtkmodel ReactorChamber begin
	    @extend OnePort()
	    @parameters begin
	        R = 1.0
	    end
	    @equations begin
	        # v ~ i * R
			# scalarize(@. ρ * Dt(Yₖ) ~ (ṁ / V) * (Yₛ - Yₖ) + ω̇ₖ * Wₖ)...
	    end
	end
end

# ╔═╡ 24081da4-a6a0-485f-97b1-3aef18b93629
# Dt(ṁ) ~ 0
# Dt(p) ~ 0
# Dt(T) ~ 0

# ╔═╡ 073efa3c-f1b8-4f9d-940e-7843b19e11db


# ╔═╡ ffb46225-f9f2-4b62-acce-2871709283e9


# ╔═╡ adb29a0e-461b-4be9-904f-1beb02a98ffa


# ╔═╡ 4e2f097b-2996-4b81-a8ee-883393f2f141


# ╔═╡ 76c0183c-8451-444d-a094-9cf11c9fbb1d


# ╔═╡ 3cff719b-d354-4e29-a053-9e09f936ccac


# ╔═╡ fade851e-164a-4616-ae12-bf4c5e26e0d9


# ╔═╡ 7f2e2c70-07a3-4c24-ace6-0e0041408169


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
# ╟─c2b9ab8c-7b8d-49f8-afba-b2176ee5862b
# ╟─703ff20d-f699-4720-a47c-061d3a425300
# ╟─c4ad6410-a73f-4301-b08b-4d4fb2ef5653
# ╟─c12d091e-4ff3-48be-8e20-f9bd4c0e3c19
# ╟─e81273c7-2aa5-40c4-a47f-1da71adc9c99
# ╟─9b8954f0-b49c-41a2-bbe5-97b23bada857
# ╟─8661ff7c-9162-4faf-84c8-fd8a63dac86f
# ╟─eafe7043-b732-441b-b226-bd45b7da4ffd
# ╟─f268e793-e3db-444d-9814-c711b3097f45
# ╟─1ba323c3-ad6e-4083-9c75-97c4f19ba657
# ╟─c2a6d64c-9af3-49ab-bbb6-8bbb2eb87386
# ╟─e8ba3f51-d103-41ca-987f-8e6a0b37c7b2
# ╟─61fb90ca-4746-4ea9-9ad6-7831270ce610
# ╟─84262231-3269-45b4-9dca-0ab510567187
# ╠═c063ffbb-11f3-43b0-9c2a-fb70d08d81a7
# ╠═24081da4-a6a0-485f-97b1-3aef18b93629
# ╠═073efa3c-f1b8-4f9d-940e-7843b19e11db
# ╠═ffb46225-f9f2-4b62-acce-2871709283e9
# ╠═adb29a0e-461b-4be9-904f-1beb02a98ffa
# ╠═4e2f097b-2996-4b81-a8ee-883393f2f141
# ╠═76c0183c-8451-444d-a094-9cf11c9fbb1d
# ╠═3cff719b-d354-4e29-a053-9e09f936ccac
# ╠═fade851e-164a-4616-ae12-bf4c5e26e0d9
# ╠═7f2e2c70-07a3-4c24-ace6-0e0041408169
# ╟─4565cbef-ec91-4864-8664-2c87d420e4a1
# ╟─a0d9b9d2-5dbf-436e-8999-8a684e2b5534
# ╟─78542421-ff40-4c7c-b04f-e175bcf8a171
