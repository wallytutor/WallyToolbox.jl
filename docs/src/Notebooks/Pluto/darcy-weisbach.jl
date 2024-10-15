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
end

# ╔═╡ 56fcb1bb-ba82-4140-8d02-1095232c8202
"Air density at normal state for mass flow calculations."
const DENSITY = P_REF * M_AIR / (GAS_CONSTANT * T_REF)

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

# ╔═╡ 882d83ed-65e5-4b24-b4d2-305e5f63baf3
function darcy_weisbach(fd_eqn)
	vars = @variables begin
		f, [bounds = (0.0, 1.0)]
		U, [bounds = (0.0, Inf)]
	end

	params = @parameters begin
		ρ
		μ
		ε
		D
		L
		Δp
	end

	Re = ρ * U * D / μ
	Ke = (1//2) * ρ * U^2
	
	eqs = [
		0 ~ Δp - f * (L/D) * Ke,
		0 ~ fd_eqn(f, Re, ε/D)
	]

	@mtkbuild ns = NonlinearSystem(eqs)

	return ns
end

# ╔═╡ 795203f6-f46b-4a47-8cd4-f50b2dc7ef38
md"""
For the selection of `nlsolve` consider checking the documentation of [NonlinearSolve](https://docs.sciml.ai/NonlinearSolve/stable/solvers/nonlinear_system_solvers/).
"""

# ╔═╡ 77f494a0-9749-4989-8eab-ff64bd3b3648
function sutherland_viscosity(T, T0, μ0, Sμ)
	return μ0 * (T/T0)^(3//2) * (T0 + Sμ) / (T + Sμ)
end

# ╔═╡ dba151fc-0e84-498a-af43-2af17b3670ce
function air_viscosity(T)
	return sutherland_viscosity(T, 273.15, 1.716e-05, 111.0)
end

# ╔═╡ 60985445-5a27-41fd-9956-c88f47704274
function solve_channel(model, D, L, p; 
		nlsolve = TrustRegion(),
		ε = 0.1,
		f = 0.06,
		U = 500.0,
		T = 300
	)
	T = T_REF + T
	
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
		@error("Solution failed with $(sol.retcode)!")
	end

	ṁ = let
		pars = prob.ps
		
		ρ = pars[model.ρ]
		D = pars[model.D]
		
		A = π * (D/2)^2
		U = sol[model.U]
		
		ρ * U * A
	end

	@info sol
	
	return ṁ
end

# ╔═╡ bd79f2ef-db5e-442b-98eb-a209820cbefe
let
	model = darcy_weisbach(fd_colebrook)
	@info unknowns(model), parameters(model)
	model
end

# ╔═╡ a02cd203-8122-444d-a0cc-af32ce1ffd5c
fd_use = fd_haaland

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

# ╔═╡ Cell order:
# ╟─dcfd03a0-8b23-11ef-202f-0557552ecc92
# ╟─56fcb1bb-ba82-4140-8d02-1095232c8202
# ╟─38ed939b-62e9-476f-aa75-9de9b19ba5b0
# ╟─39b60b4e-4c94-4f45-8c6e-1ad9b65930aa
# ╟─2144db16-84ed-40d0-8574-07d59cfba52b
# ╟─3c2169a9-01f0-4cce-a2da-5c2eab787f90
# ╟─42b0e51f-ec00-467c-a4b8-d9c9f4b4d9c2
# ╟─1354c571-9c53-45e0-a9f6-eb135abc1e78
# ╟─360e9495-3384-477b-a211-ffa8bb3d1fac
# ╠═882d83ed-65e5-4b24-b4d2-305e5f63baf3
# ╟─795203f6-f46b-4a47-8cd4-f50b2dc7ef38
# ╠═77f494a0-9749-4989-8eab-ff64bd3b3648
# ╠═dba151fc-0e84-498a-af43-2af17b3670ce
# ╠═60985445-5a27-41fd-9956-c88f47704274
# ╟─bd79f2ef-db5e-442b-98eb-a209820cbefe
# ╠═a02cd203-8122-444d-a0cc-af32ce1ffd5c
# ╟─0aefabd3-44d7-4e00-9ce5-1973bc7b1705
# ╟─570dfee3-ee8e-47cb-87be-ab0f467f5f17
# ╟─067d1351-7739-4d14-a5c7-203a4e86bb59
# ╟─3357de42-e48c-4e4d-a7df-58d916a1c9b5
# ╠═8fcaed37-d179-449c-8d43-8d0ad9a6c35e
