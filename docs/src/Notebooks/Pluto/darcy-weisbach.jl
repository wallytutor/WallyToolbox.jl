### A Pluto.jl notebook ###
# v0.19.45

using Markdown
using InteractiveUtils

# ╔═╡ dcfd03a0-8b23-11ef-202f-0557552ecc92
begin
    @info("Loading tools...")

    import Pkg
    Pkg.activate(Base.current_project())

	using WallyToolbox
	using ModelingToolkit
	using NonlinearSolve
	using PlutoUI: TableOfContents
	
	TableOfContents()
end

# ╔═╡ 3f9fdb0e-caab-40df-99f8-cf0e5ec8deff
md"""
# Darcy-Weisbash equation
"""

# ╔═╡ 56fcb1bb-ba82-4140-8d02-1095232c8202
"Air density at normal state for mass flow calculations."
const DENSITY = P_REF * M_AIR / (GAS_CONSTANT * T_REF)

# ╔═╡ 02b25aaa-0531-48ee-b8f5-8376fb8e6db5
md"""
## Properties
"""

# ╔═╡ 53881209-6da6-4bee-aaf2-8a52cfdf28cb
md"""
Parameters for Sutherland model are found in [Comsol's documentation](https://doc.comsol.com/5.5/doc/com.comsol.help.cfd/cfd_ug_fluidflow_high_mach.08.27.html).
"""

# ╔═╡ 77f494a0-9749-4989-8eab-ff64bd3b3648
function sutherland_viscosity(T, T0, μ0, Sμ)
	return μ0 * (T/T0)^(3//2) * (T0 + Sμ) / (T + Sμ)
end

# ╔═╡ dba151fc-0e84-498a-af43-2af17b3670ce
function air_viscosity(T)
	return sutherland_viscosity(T, 273.15, 1.716e-05, 111.0)
end

# ╔═╡ c3607947-d88e-4f10-921d-be654330ad9a
md"""
## Relationships
"""

# ╔═╡ 38ed939b-62e9-476f-aa75-9de9b19ba5b0
md"""
A vast discussion of relationships for the estimation of pressure drop coefficient are provided [here](https://fr.wikipedia.org/wiki/%C3%89quation_de_Darcy-Weisbach) and [here](https://en.wikipedia.org/wiki/Darcy%e2%80%93Weisbach_equation).
"""

# ╔═╡ 39b60b4e-4c94-4f45-8c6e-1ad9b65930aa
function fd_blasius(f, Re, ξ)
	return f - 0.3164 * Re^(-1//4)
end

# ╔═╡ 2144db16-84ed-40d0-8574-07d59cfba52b
function fd_colebrook(f, Re, ξ)
	rhs = -2log10(2.51/(Re * sqrt(f)) + ξ/3.7)
	return 1 / sqrt(f) - rhs
end

# ╔═╡ 3c2169a9-01f0-4cce-a2da-5c2eab787f90
function fd_haaland(f, Re, ξ)
	rhs = -1.8log10(6.9/Re + (ξ/3.7)^(1.11))
	return 1 / sqrt(f) - rhs
end

# ╔═╡ 42b0e51f-ec00-467c-a4b8-d9c9f4b4d9c2
function fd_swamee_jain(f, Re, ξ)
	den = log10(5.74/Re^(9//10) + ξ/3.7)
	return f - 0.25 / den^2
end

# ╔═╡ 1354c571-9c53-45e0-a9f6-eb135abc1e78
function fd_serghides(f, Re, ξ)
	r = ξ / 3.7
	A = -2log10(r + 12/Re)
	B = -2log10(r + 2.51A/Re)
	C = -2log10(r + 2.51B/Re)
	return f - (A - (B-A)^2/(C-2B+A))^(-2)
end

# ╔═╡ 360e9495-3384-477b-a211-ffa8bb3d1fac
@warn("TODO")
# function fd_goudar_sonnad(f, Re, ξ)
# function fd_churchill(f, Re, ξ)

# ╔═╡ 00812f04-a14c-434f-a0ac-bf0943976a0c
md"""
## Model
"""

# ╔═╡ 795203f6-f46b-4a47-8cd4-f50b2dc7ef38
md"""
For the selection of `nlsolve` consider checking the documentation of [NonlinearSolve](https://docs.sciml.ai/NonlinearSolve/stable/solvers/nonlinear_system_solvers/).
"""

# ╔═╡ 882d83ed-65e5-4b24-b4d2-305e5f63baf3
function darcy_weisbach(fd_eqn)
	vars = @variables begin
		f, [bounds = (0.0, 1.0)]
		U, [bounds = (0.0, 1000.0)]
	end

	pars = @parameters begin
		ρ,  [bounds = (1.0e-03, Inf)]
		μ,  [bounds = (1.0e-07, Inf)]
		ε,  [bounds = (0.0e+00, Inf)]
		D,  [bounds = (1.0e-06, Inf)]
		L,  [bounds = (1.0e-06, Inf)]
		Δp, [bounds = (1.0e-06, Inf)]
	end

	Re = ρ * U * D / μ
	Ke = (1//2) * ρ * U^2
	
	eqs = [
		0 ~ Δp - f * (L/D) * Ke,
		0 ~ fd_eqn(f, Re, ε/D)
	]

	@mtkbuild ns = NonlinearSystem(eqs, vars, pars)

	return ns
end

# ╔═╡ 60985445-5a27-41fd-9956-c88f47704274
function solve_channel(model, D, L, p; 
		nlsolve = TrustRegion(),
		ε = 0.05,
		f = 0.06,
		U = 500.0,
		T = 300
	)
	T += T_REF
	
	ps = [
		model.ρ  => DENSITY * (T_REF/T),
		model.μ  => air_viscosity(T),
		model.ε  => ε/1000,
		model.D  => D/1000,
		model.L  => L/1000,
		model.Δp => 100p,
	]

	guess = [model.f => f, model.U => U]
	prob = NonlinearProblem(model, guess, ps)
	sol = solve(prob, nlsolve)

	if sol.retcode != ReturnCode.Success
		@error("Solution failed with `$(sol.retcode)`!")
	end

	mdot = let
		pars = prob.ps
		
		ρ = pars[model.ρ]
		D = pars[model.D]
		
		A = π * (D/2)^2
		U = sol[model.U]
		
		ρ * U * A
	end

	@info(sol)
	
	return mdot
end

# ╔═╡ a02cd203-8122-444d-a0cc-af32ce1ffd5c
fd_use = fd_colebrook

# ╔═╡ bd79f2ef-db5e-442b-98eb-a209820cbefe
let
	model = darcy_weisbach(fd_use)
	@info unknowns(model), parameters(model)
	model
end

# ╔═╡ 1f115f6f-df6d-4134-8269-167736e3c238
let
	p1 = 101325 + 100 * 35.5
	p2 = 101325

	# f = 2.75
	f = 0.06
	L = 0.0120
	D = 0.0044

	T = 300.0
	R = GAS_CONSTANT
	
	C = f*L/D + 2log(p1/p2)
	G = sqrt((p1^2 - p2^2) / (R * T * C))
	A = π * (D/2)^2

	9 * G * A
end

# ╔═╡ 0aefabd3-44d7-4e00-9ce5-1973bc7b1705
mdot_cool = let
	N = 9
	model = darcy_weisbach(fd_use)
	N * solve_channel(model, 4.4, 12.0, 35.5)
end

# ╔═╡ 570dfee3-ee8e-47cb-87be-ab0f467f5f17
mdot_external = let
	N = 16
	model = darcy_weisbach(fd_use)
	N * solve_channel(model, 5.9, 15.0, 72.0)
end

# ╔═╡ 067d1351-7739-4d14-a5c7-203a4e86bb59
mdot_tangential = let
	N = 12
	
	D = let
		a, b = 5.4, 4.7
		A, P = a * b, 2 * (a + b)
		4A / P
	end

	L = 14.41 / sin(deg2rad(50))

	model = darcy_weisbach(fd_use)
	N * solve_channel(model, D, L, 108.0)	
end

# ╔═╡ 3357de42-e48c-4e4d-a7df-58d916a1c9b5
begin
	mdot_tot = mdot_cool + mdot_external + mdot_tangential
	
	mdot_ref = 382DENSITY
	mdot_sim = 3600mdot_tot
	mdot_sim, mdot_ref, round(mdot_sim/mdot_ref; digits=3)
end

# ╔═╡ 8fcaed37-d179-449c-8d43-8d0ad9a6c35e
mdot_external / mdot_tot, mdot_cool / mdot_tot, mdot_tangential / mdot_tot

# ╔═╡ 6a6ad275-90d9-47d0-8b5e-a3d20efa9b0a
md"""
## Experimental
"""

# ╔═╡ be031284-d872-4e1c-b43d-53038b21f8e4
let
	model = perfect_gas_constants(; R=208, k=1.67)
	solution = structural_solve(model)
end

# ╔═╡ 80dd3540-f5fb-4c2f-b6d5-b39ad599b8d5
let
	R = 208.0
	k = 1.67
	
	model1 = perfect_gas_model(; R, k, p=1.70e+06, ρ=18.0)
	model2 = perfect_gas_model(; R, k, p=2.48e+05, T=400.0)
	
	sol1 = structural_solve(model1)
	sol2 = structural_solve(model2)

	Δh = sol2.h - sol1.h
	Δs = sol2.s - sol1.s

	Δh, Δs
end

# ╔═╡ 3e85af5c-7160-4b60-9369-dfa9dad34f7e
let
	R = 287.0
	k = 1.4

	p1 = P_REF + 3550.0
	p2 = P_REF
	
	model1 = perfect_gas_model(; R, k, p=p1, T=300.0)
	model2 = perfect_gas_model(; R, k, p=p2, T=300.0)
	
	sol1 = structural_solve(model1)
	sol2 = structural_solve(model2)

	Δh = sol2.h - sol1.h
	Δs = sol2.s - sol1.s

	Δh, Δs
end

# ╔═╡ Cell order:
# ╟─3f9fdb0e-caab-40df-99f8-cf0e5ec8deff
# ╟─dcfd03a0-8b23-11ef-202f-0557552ecc92
# ╟─56fcb1bb-ba82-4140-8d02-1095232c8202
# ╟─02b25aaa-0531-48ee-b8f5-8376fb8e6db5
# ╟─53881209-6da6-4bee-aaf2-8a52cfdf28cb
# ╟─77f494a0-9749-4989-8eab-ff64bd3b3648
# ╟─dba151fc-0e84-498a-af43-2af17b3670ce
# ╟─c3607947-d88e-4f10-921d-be654330ad9a
# ╟─38ed939b-62e9-476f-aa75-9de9b19ba5b0
# ╟─39b60b4e-4c94-4f45-8c6e-1ad9b65930aa
# ╟─2144db16-84ed-40d0-8574-07d59cfba52b
# ╟─3c2169a9-01f0-4cce-a2da-5c2eab787f90
# ╟─42b0e51f-ec00-467c-a4b8-d9c9f4b4d9c2
# ╟─1354c571-9c53-45e0-a9f6-eb135abc1e78
# ╟─360e9495-3384-477b-a211-ffa8bb3d1fac
# ╟─00812f04-a14c-434f-a0ac-bf0943976a0c
# ╟─795203f6-f46b-4a47-8cd4-f50b2dc7ef38
# ╟─882d83ed-65e5-4b24-b4d2-305e5f63baf3
# ╟─60985445-5a27-41fd-9956-c88f47704274
# ╟─a02cd203-8122-444d-a0cc-af32ce1ffd5c
# ╟─bd79f2ef-db5e-442b-98eb-a209820cbefe
# ╠═1f115f6f-df6d-4134-8269-167736e3c238
# ╟─0aefabd3-44d7-4e00-9ce5-1973bc7b1705
# ╟─570dfee3-ee8e-47cb-87be-ab0f467f5f17
# ╟─067d1351-7739-4d14-a5c7-203a4e86bb59
# ╟─3357de42-e48c-4e4d-a7df-58d916a1c9b5
# ╟─8fcaed37-d179-449c-8d43-8d0ad9a6c35e
# ╟─6a6ad275-90d9-47d0-8b5e-a3d20efa9b0a
# ╠═be031284-d872-4e1c-b43d-53038b21f8e4
# ╠═80dd3540-f5fb-4c2f-b6d5-b39ad599b8d5
# ╠═3e85af5c-7160-4b60-9369-dfa9dad34f7e
