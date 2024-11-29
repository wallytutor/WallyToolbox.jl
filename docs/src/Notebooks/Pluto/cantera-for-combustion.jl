### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ 4c272615-47ee-4889-bf30-2ad43e536cd9
begin
	@info("Loading toolbox...")

    using Pkg
    Pkg.activate(ENV["WALLYROOT"])
    Pkg.instantiate()

	using CairoMakie
	using PlutoLinks
    using PlutoUI: TableOfContents
	
	TableOfContents()
end

# ╔═╡ 3f2113e5-712d-405f-a866-8d9438fe97fa
begin
	@info("Importing local tools...")
	
    using WallyToolbox
	@revise using PyCanteraTools
end

# ╔═╡ 6056e79b-332e-4328-9461-7053c1660316
using PythonCall

# ╔═╡ 9d15ec6c-04a7-4f5c-908b-310a774ff044
md"""
# Cantera for combustion
"""

# ╔═╡ b31efe8b-182a-4228-9722-192d913fd8a8
md"""
This notebook aims at providing the minimal basis of practicing combustion and kinetics analysis with Cantera from Julia. It is intended to be self-contained, except for those elements provided by local module `PyCanteraTools`, which are part of `WallyToolbox`.

For more, please check [the docs](https://cantera.org/)
"""

# ╔═╡ 106bd29e-6cc5-430f-ad50-51f10aa1fca1
md"""
## Importing Cantera

Importing Cantera from Julia can be made through [PythonCall](https://juliapy.github.io/PythonCall.jl/stable/) module. Generally speaking the interaction between Julia and Python works smoothly but the user is expected to know how to convert values between the two languages (especially when retrieving results from Cantera to use in Julia).

Just import Cantera using the alias `ct` (as one would do from Python) as follows:
"""

# ╔═╡ 4e65f9e1-697d-4fc6-ad68-93391c89a13f
const ct = pyimport("cantera");

# ╔═╡ 50528438-c443-4248-94db-bf44ded1ab9e
md"""
## Creating a solution

Below we illustrate how to create a solution object; in the context of rotary kilns it might be useful to import [Gri-MECH 3.0](http://combustion.berkeley.edu/gri-mech/) as it is the standard combustion mechanism for benchmarking natural gas:
"""

# ╔═╡ 9a234b75-1439-4e79-b929-008c59c79e8a
gas = ct.Solution("gri30.yaml")

# ╔═╡ 99810c76-73e3-4ac7-8f42-6144cde07a83
md"""
The following set the temperature (in kelvin), pressure (in pascal), and composition (mole fractions if using `X`, mass fractions with `Y`):
"""

# ╔═╡ 4bd62763-8f0e-4f14-8563-5efbc0348b01
begin
	X_nat = "CH4:0.95, CO2: 0.03, N2: 0.02"

	gas.TPX = 298.15, 101325.0, X_nat	
end;

# ╔═╡ e5ad6bd1-f81a-4769-8d9f-1958457b8d4e
md"""
We can get a report for the state of a solution to confirm everything went fine with:
"""

# ╔═╡ 7da0e30d-fe7b-4ece-98e5-cd9a3d1331af
@info pyconvert(String, gas.report())

# ╔═╡ 2db14e8a-03cb-4426-a2f3-049c8d331e2f
md"""
Because this recipe is often used when loading data, a wrapper is provided:
"""

# ╔═╡ bc126da7-604b-4eb8-8760-b5ce2d066fed
let
	sol = load_solution_state("gri30.yaml", X_nat; T = 298.15)
	@info pyconvert(String, sol.report())
end

# ╔═╡ 33524851-4ce2-410d-b8be-b30a418dc8d4
md"""
## Basics of combustion

Now suppose you want to burn this fuel with air; so lets create the composition of the oxidizer:
"""

# ╔═╡ ac682cd0-8818-4a20-84a7-409d876955bb
X_air = "N2: 0.78, O2: 0.21, Ar: 0.01"

# ╔═╡ 9d3b9e70-4ee9-4a57-a675-aab65d01403d
md"""
With method `set_equivalence_ratio` we can set its composition for a given equivalence ratio; see below the documentation of this function and it in action.
"""

# ╔═╡ 34f12706-3628-476d-b145-60017df2fd09
@doc(gas.set_equivalence_ratio)

# ╔═╡ eb83c367-1008-47ea-a3b3-570eb92804a3
gas.set_equivalence_ratio(1.0, fuel=X_nat, oxidizer=X_air, basis="mole");

# ╔═╡ 08b0250d-3d1c-4f00-90ea-350c8bfd7b96
md"""
For instance, for computing equilibrium we can use `gas.equilibrate` as documented below:
"""

# ╔═╡ 590314c1-f15a-417e-ae56-7c8478ca0a77
@doc(gas.equilibrate)

# ╔═╡ 7c0f99d9-44a5-4e33-82d3-a21e49a8e331
md"""
Computing equilibrium at constant room temperature and pressure provides the complete combustion products; below we also illustrate the Julia wrapper provided for reporting solution state.
"""

# ╔═╡ 718457c9-c13e-452b-8c49-ac04cdf1055f
begin
	gas.equilibrate("TP")
	@info report(gas; threshold=0.001)
end

# ╔═╡ e59a579d-55c6-4b01-99b5-04eb7264c13f
md"""
Once an equilibrium as been computed, the state of the solution changed; to perform anothe calculation we need to reset its state; starting at 500 K, *e.g.* we can compute adiabatic flame temperature with constant enthalpy equilibrium:
"""

# ╔═╡ ae8818e6-4814-4540-95fc-c5f1c7ff5f68
begin
	gas.TP = 500.0, 101325.0
	gas.set_equivalence_ratio(1.0, fuel=X_nat, oxidizer=X_air, basis="mole")
	@info report(gas, threshold=1.0e-05)
end

# ╔═╡ 39eb0994-d697-4941-82d8-1b37df30982e
begin
	gas.equilibrate("HP")
	@info report(gas, threshold=1.0e-05)
end

# ╔═╡ 180d8567-3f03-45d5-a38e-b4c42d4f823b
md"""
A more complex [example](https://cantera.org/examples/python/multiphase/adiabatic.py.html) can also include soot formation.
"""

# ╔═╡ b0de1f21-923a-47dd-845c-2e5281d4234b
md"""
## Computing mixtures

A more flexible approach for industrial solutions is to use `ct.Quantity` that allows arbitrary mixtures to be set-up (using equivalence ratios is not always what you want or may require aditional computations if the data you have is already mass flow rates); below we mix up some natural gas and air before evaluating the equivalent adiabatic flame condition (try testing different mechanisms).
"""

# ╔═╡ e2862cfd-77ee-4be6-b735-011bd27e524a
let
	# mech = "gri30.yaml"
	mech = "2S_CH4_BFER.yaml"
	
	gas = ct.Solution(mech)
	air1 = ct.Solution(mech)
	air2 = ct.Solution(mech)
	
	gas.TPX = 298.15, ct.one_atm, X_nat
	air1.TPX = 573.15, ct.one_atm, X_air
	air2.TPX = 923.15, ct.one_atm, X_air
	
	mdot_gas = 300.0
	mdot_air1 = 2000.0
	mdot_air2 = 3000.0
	
	q_gas = ct.Quantity(gas, mass=mdot_gas)
	q_air1 = ct.Quantity(air1, mass=mdot_air1)
	q_air2 = ct.Quantity(air2, mass=mdot_air2)
	
	q_mix = q_gas + q_air1 + q_air2
	q_mix.equilibrate("HP")

	@info report(q_mix, threshold=1.0e-05)
end

# ╔═╡ 3d2632cb-9fa9-44c4-b217-51d6e348420c
md"""
Another more complex example: mixing two different fuels and evaluating equilibrium.
"""

# ╔═╡ 509e4e39-4781-492d-8de4-08ac783accd5
let
	mech = "NAT_PFO_LUMP.yaml"

	X_air = "N2: 0.79, O2: 0.205, H2O: 0.005"
	X_nat = "NAT: 0.9573, CO2: 0.0075, N2: 0.0352"
	X_pfo = "PFO: 1.0"
	
	fluid_pfo = load_solution_state(mech, X_pfo; T = 473.15)
	fluid_nat = load_solution_state(mech, X_nat; T = 298.15)
	fluid_pri = load_solution_state(mech, X_air; T = 373.15)
	fluid_sec = load_solution_state(mech, X_air; T = 1273.15)

	qty_pri = ct.Quantity(fluid_pri, mass=485.0)
	qty_sec = ct.Quantity(fluid_sec, mass=6700.0)
	qty_pfo = ct.Quantity(fluid_pfo, mass=200.0)
	qty_nat = ct.Quantity(fluid_nat, mass=165.0)

	qty_fuel = qty_nat + qty_pfo
	qty_air  = qty_pri + qty_sec
	qty = qty_fuel + qty_air

	# Uncomment the following for complete combustion products:
	# qty.TP = T_REF, nothing
	# qty.equilibrate("TP")

	# ...or this for adiabatic flame temperature.
	qty.equilibrate("HP")

	@info("Total mass = $(qty.mass) kg")
	@info(report(qty; threshold=1e-10))
end

# ╔═╡ 69f921ac-eb3a-46db-a5cd-7c6b44f7835e


# ╔═╡ Cell order:
# ╟─9d15ec6c-04a7-4f5c-908b-310a774ff044
# ╟─b31efe8b-182a-4228-9722-192d913fd8a8
# ╟─4c272615-47ee-4889-bf30-2ad43e536cd9
# ╟─3f2113e5-712d-405f-a866-8d9438fe97fa
# ╟─106bd29e-6cc5-430f-ad50-51f10aa1fca1
# ╠═6056e79b-332e-4328-9461-7053c1660316
# ╠═4e65f9e1-697d-4fc6-ad68-93391c89a13f
# ╟─50528438-c443-4248-94db-bf44ded1ab9e
# ╠═9a234b75-1439-4e79-b929-008c59c79e8a
# ╟─99810c76-73e3-4ac7-8f42-6144cde07a83
# ╠═4bd62763-8f0e-4f14-8563-5efbc0348b01
# ╟─e5ad6bd1-f81a-4769-8d9f-1958457b8d4e
# ╠═7da0e30d-fe7b-4ece-98e5-cd9a3d1331af
# ╟─2db14e8a-03cb-4426-a2f3-049c8d331e2f
# ╠═bc126da7-604b-4eb8-8760-b5ce2d066fed
# ╟─33524851-4ce2-410d-b8be-b30a418dc8d4
# ╠═ac682cd0-8818-4a20-84a7-409d876955bb
# ╟─9d3b9e70-4ee9-4a57-a675-aab65d01403d
# ╟─34f12706-3628-476d-b145-60017df2fd09
# ╠═eb83c367-1008-47ea-a3b3-570eb92804a3
# ╟─08b0250d-3d1c-4f00-90ea-350c8bfd7b96
# ╟─590314c1-f15a-417e-ae56-7c8478ca0a77
# ╟─7c0f99d9-44a5-4e33-82d3-a21e49a8e331
# ╠═718457c9-c13e-452b-8c49-ac04cdf1055f
# ╟─e59a579d-55c6-4b01-99b5-04eb7264c13f
# ╠═ae8818e6-4814-4540-95fc-c5f1c7ff5f68
# ╠═39eb0994-d697-4941-82d8-1b37df30982e
# ╟─180d8567-3f03-45d5-a38e-b4c42d4f823b
# ╟─b0de1f21-923a-47dd-845c-2e5281d4234b
# ╠═e2862cfd-77ee-4be6-b735-011bd27e524a
# ╟─3d2632cb-9fa9-44c4-b217-51d6e348420c
# ╠═509e4e39-4781-492d-8de4-08ac783accd5
# ╠═69f921ac-eb3a-46db-a5cd-7c6b44f7835e
