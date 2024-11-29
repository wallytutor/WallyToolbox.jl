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

If you are starting with Cantera, please check the [tutorial](https://cantera.org/tutorials/python-tutorial.html), but keep in mind it is provided in plain Python (and our goal here is to use Cantera from Julia!). For more, please check [the docs](https://cantera.org/)
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
	@info report_state(gas; threshold=0.001)
end

# ╔═╡ f546936f-a6cd-4b33-b0b6-a48c33a5923b
md"""
The following functionality provides the inspection of relative net reaction rates for reversible equations; this is a means of checking convergence of equilibrium calculations.
"""

# ╔═╡ 6306a3e4-1da6-4aca-a62e-53b08d623198
maximum(net_relative_progress(gas)) < 1.0e-06

# ╔═╡ e59a579d-55c6-4b01-99b5-04eb7264c13f
md"""
Once an equilibrium as been computed, the state of the solution changed; to perform anothe calculation we need to reset its state; starting at 500 K, *e.g.* we can compute adiabatic flame temperature with constant enthalpy equilibrium:
"""

# ╔═╡ ae8818e6-4814-4540-95fc-c5f1c7ff5f68
begin
	gas.TP = 500.0, 101325.0
	gas.set_equivalence_ratio(1.0, fuel=X_nat, oxidizer=X_air, basis="mole")
	@info report_state(gas, threshold=1.0e-05)
end

# ╔═╡ 39eb0994-d697-4941-82d8-1b37df30982e
begin
	gas.equilibrate("HP")
	@info report_state(gas, threshold=1.0e-05)
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

	@info report_state(q_mix, threshold=1.0e-05)
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
	@info(report_state(qty; threshold=1e-10))
end

# ╔═╡ 69f921ac-eb3a-46db-a5cd-7c6b44f7835e
md"""
## Solution properties

Imagine a situation where one needs to compute global combustion (for energy purposes only) in a CFD simulation using a three-fluid mixture approach (fuel, oxidizer, exhaust): what are the thermophysical and transport properties to use for the exhaust (or even fuel and oxidizer if they are not pure species)? 

In this brief tutorial we will compute transport properties of multiple compositions of a gas using the [`SolutionArray`](https://cantera.org/documentation/docs-2.5/sphinx/html/cython/importing.html#representing-multiple-states) class of Cantera.

This will be done with the classical Berkley's [GRI-Mech 3.0](http://combustion.berkeley.edu/gri-mech/version30/text30.html) mechanims for combustion, which is provided with required parameters for computation of transport properties.

For producing smooth curves we use 100 states defined in what follows.
"""

# ╔═╡ 9f2522c6-8445-44b2-9907-27a12562c5c8
num_states = 100

# ╔═╡ cc37c9ec-28d8-4535-8427-fb6fa783478b
md"""
To create a `SolutionArray` we must first create the phase we want to perform computations with.

The default phase in `gri30.yaml` mechanism in Cantera >2.5 already contains transport properties for mixture-averaged computations (notice that Lennard-Jones data must be available in the mechanism properties database).

Utility class `SolutionArray` supports any shape, but here we stick to a 1-D array for ease of plotting.

You can inspect the default state of the loaded solution.
"""

# ╔═╡ 3765f384-18b5-44a8-b3da-3b8ee45f0046
sol = let
	gas = ct.Solution("gri30.yaml")
	sol = ct.SolutionArray(gas, shape=(num_states,))
end

# ╔═╡ e9e34790-d0f9-4104-8f2a-d5956bd9f273
md"""
Now assume for some reason we need to compute properties for a $\mathrm{N_2-CH_4}$ mixture.

For the computations that follow we need to set their quantities in array, so we get their indices.
"""

# ╔═╡ 8830ff90-8900-4ca7-8ce4-42dc0a5f140c
begin
	idx_n2 = PyCanteraTools.jlint(sol.species_index("N2"))
	idx_ch4 = PyCanteraTools.jlint(sol.species_index("CH4"))
end;

# ╔═╡ 33a1231f-964b-4329-b6f0-df4dab3d6617
md"""
To cover the full composition range we use `LinRange` to get `num_states` compositions for ``\mathrm{CH_4}``.
"""

# ╔═╡ d3f25a8d-51c0-4b9c-b142-72e05e5a7ca2
x_ch4 = LinRange(0.0, 1.0, num_states)

# ╔═╡ 9092776a-530e-4117-b6c0-73c534ed9311
md"""
Next we allocate the matrix of compositions for all the states and all the species.

This zeros matrix must have as many rows as states and as many columns as species in the mechanism.

Julias's useful array slicing can be used to set/compute composition for the species we retrieved the indices as follows.
"""

# ╔═╡ dc7ef9f5-f67c-4597-ba7d-54dfc0f55fea
begin
	X = zeros(num_states, PyCanteraTools.jlint(gas.n_species))

	# XXX: notice that Julia is 1-based and Cantera indexes are
	# 0-based as Python! Fix the index here!
	X[:, idx_ch4+1] = x_ch4
	X[:, idx_n2+1] = 1.0 .- X[:, idx_ch4+1]

	X
end

# ╔═╡ e5a4bf0d-cc0e-4d42-81cc-e499550de833
md"""
In `SolutionArray` you cannot set `X` alone; in this case we repeat the temperature and pressure, then append the tuple with the newly computed `X` matrix. All the defined solution properties are automatically evaluated based on new state.
"""

# ╔═╡ 3ecef36c-b981-4e8c-b710-99451b8f1f93
begin
	sol.TPX = sol.T, sol.P, X
	sol
end

# ╔═╡ 1c080861-4a76-4f09-901a-18b438f9c392
md"""
Below we display gas viscosity, heat capacity and thermal conductivity. We could also have computed thermal difusivity using the density, but that is left as an exercise for you. Since the composition is quite simple, can you check it against the literature?
"""

# ╔═╡ d07e4d17-554b-47c3-84cd-fefdbbcea2ba
with_theme() do
	μ = PyCanteraTools.jlvec(sol.viscosity) * 1e5
	c = PyCanteraTools.jlvec(sol.cp_mass)
	k = PyCanteraTools.jlvec(sol.thermal_conductivity) * 1000

	f = Figure(size = (650, 800))

	ax1 = Axis(f[1, 1])
	ax2 = Axis(f[2, 1])
	ax3 = Axis(f[3, 1])

	ax1.ylabel = L"Viscosity [$10^5\times\mathrm{Pa\cdotp{}s}$]"
	ax2.ylabel = L"Heat capacity [$\mathrm{J\cdotp{}kg^{-1}\cdotp{}K^{-1}}$]"
	ax3.ylabel = L"Thermal conductivity [$\mathrm{mW\cdotp{}m^{-1}\cdotp{}K^{-1}}$]"
	ax3.xlabel = L"$\mathrm{CH_4}$ mole percentage"
	
	lines!(ax1, 100x_ch4, μ; color = :black)
	lines!(ax2, 100x_ch4, c; color = :black)
	lines!(ax3, 100x_ch4, k; color = :black)

	ax1.xticks = 0:20:100
	ax2.xticks = 0:20:100
	ax3.xticks = 0:20:100

	ax1.yticks = 1:0.2:2
	ax2.yticks = 1000:300:2500
	ax3.yticks = 26:2:36
	
	ylims!(ax1, 1, 2)
	ylims!(ax2, 1000, 2500)
	ylims!(ax3, 26, 36)
	
	xlims!(ax1, 0, 100)
	xlims!(ax2, 0, 100)
	xlims!(ax3, 0, 100)
	
	f
end

# ╔═╡ e0baf847-406e-47bb-9fb2-b47a7bbbb31d
md"""
You can explore other concepts than thermophysical properties using `SolutionArray` objects, *e.g.* what is the adiabatic flame temperature of hydrogen combustion in pure oxygen with equivalence ratios from 0.5 to 2.0?
"""

# ╔═╡ be646930-c893-4fcb-9e3e-e1408c1da9ac
h2_sol = let
	η = LinRange(0.5, 2.5, num_states)
	
	gas = ct.Solution("gri30.yaml")
	
	sol = ct.SolutionArray(gas, shape=(num_states,))
	sol.set_equivalence_ratio(η, "H2", "O2")
	sol.equilibrate("HP")

	T = PyCanteraTools.jlvec(sol.T) .- T_REF

	(η = η, T = T)
end;

# ╔═╡ 65067cb0-7339-464e-b237-cb99a370b4c1
with_theme() do
	f = Figure(size = (650, 400))
	
	ax = Axis(f[1, 1])
	ax.title = L"Adiabatic flame temperature of $H_2-O_2$ mixtures"
	ax.xlabel = L"Equivalence ratio - $\eta$"
	ax.ylabel = L"Temperature [$^\circ{}$C]"

	lines!(ax, h2_sol.η, h2_sol.T; color = :red)

	ax.xticks = 0.5:0.25:2.5
	ax.yticks = 2300:100:2900
	
	xlims!(ax, extrema(ax.xticks.val))
	ylims!(ax, extrema(ax.yticks.val))
	
	f
end

# ╔═╡ fe078411-c131-4ef2-9b05-8f71fba0b0e4
md"""
There are many possibilities from here in terms of what you can compute.

I have personally used this to post-process OpenFOAM results read by [PyVista](https://docs.pyvista.org/) from VTK files.

You could also scan temperature and pressure ranges to evaluate the required properties.
"""

# ╔═╡ 4f9d5ca2-5ba3-49c9-acbd-82606a413d07
md"""
## Methane combustion

In what follows we adapt this [reference from Cantera](https://cantera.org/examples/jupyter/thermo/flame_temperature.ipynb.html) to compute flame temperature produced by mixing methane and air. This initial estimations are used to check the suitability from current models and kinetics mechanisms to applications to high temperature material processing. Overall combustion equation at unity fuel to oxidizer ratio is

```math
\mathrm{CH_4 + 2 O_2 + 7.52 N_2 \rightarrow 2 H_2O + CO_2 + 7.52 N_2 + \Delta{H}}
```

In what follows we numerically investigate the role of non-stoichiometric mixing.

For complete combustion a filtered version of the mechanism is used so that nominal released heat is found. A second solution object is created with the whole set of species to compute incomplete combustion.
"""

# ╔═╡ 9c7930f2-a18c-4d5e-b4a3-0eda53920aac
begin
	species_pair(s) = (PyCanteraTools.jlstr(s.name), s)
	
	species_keep = ("CH4", "O2", "CO2", "H2O", "N2", "AR")
	species_mech = ct.Species.list_from_file("gri30.yaml")
	
	species_full = Dict(map(species_pair, species_mech))
	species_calc = [species_full[s] for s in species_keep]

	gas1 = ct.Solution(thermo="IdealGas", species=species_calc)
	gas2 = ct.Solution(thermo="IdealGas", species=values(species_full))
	gas3 = ct.Solution("2S_CH4_BFER.yaml")
end;

# ╔═╡ af2fa456-07a3-496d-93d6-fa7f5f3480cf
md"""
Next we make use of manipulation of `SolutionArray` shown before to conceive a function for computing multiple equilibria and adiabatic flame temperatures, residual oxygen, and lower-heating values. This is implemented in `adiabatic_flame_states`.
"""

# ╔═╡ eb36681a-fb76-44e2-9b99-e1a3869886d5
function adiabatic_flame_states(gas, phi, fuel, oxid; basis = "mole")
	# Allocate memory for multiple states:
	sol = ct.SolutionArray(gas, shape=(length(phi),))

	# Set initial state of mixture at equivalence ratio:
	sol.TP = 298.15, ct.one_atm
	sol.set_equivalence_ratio(phi, fuel, oxid, basis=basis)

	# Get enthalpy and fuel content before combustion:
	h0 = PyCanteraTools.jlvec(sol.enthalpy_mass)
	y_fuel = PyCanteraTools.jlvec(sol(fuel).Y.ravel())

	# Equilibrate and retrieve flame temperature:
	sol.equilibrate("HP")
	T_equi = PyCanteraTools.jlvec(sol.T)
	
	# Reset temperature for enthalpy change calculation:
	sol.TP = 298.15, ct.one_atm

	# Retrieve oxygen and enthalpy after combustion:
	x_oxid = PyCanteraTools.jlvec(sol("O2").X.ravel())
	h1 = PyCanteraTools.jlvec(sol.enthalpy_mass)

	# Compute lower heating value:
	lhv = -(h1 .- h0) ./ (1e6y_fuel)
	
	return (T = T_equi .- T_REF, X = 100x_oxid, LHV = lhv)
end

# ╔═╡ 4b575958-5429-43bf-b11d-5f6c059a34ab
md"""
Equilibrium under constant enthalpy and pressure is evaluated for $\phi\in[0.6;1.8]$ with air as oxidizer. The [lower heating value (LHV)](https://en.wikipedia.org/wiki/Heat_of_combustion#Lower_heating_value) is also computed as described [here](https://cantera.org/examples/jupyter/thermo/heating_value.ipynb.html).

Below we make use of the developed function to perform these evaluations.
"""

# ╔═╡ c15061b4-bf4e-467c-bf36-eb7007f91b26
begin
	fuel = "CH4"
	oxid = "O2:0.21, N2:0.78, AR:0.01"
	phi = LinRange(0.6, 1.8, 100)
	
	sol1 = adiabatic_flame_states(gas1, phi, fuel, oxid)
	sol2 = adiabatic_flame_states(gas2, phi, fuel, oxid)
	sol3 = adiabatic_flame_states(gas3, phi, fuel, oxid)
end;

# ╔═╡ 8a7d9457-ceee-43e8-98e9-14bec9475c69
md"""
Plotting it all together one verify good agreement with the Gri-Mech 3.0, thus validating the model. It must be noticed that for any heat transfer simulation, the 1-step mechanism must be avoided above an equivalence ratio ~0.8.
"""

# ╔═╡ 1604a7a7-0252-4695-bde1-13f6fc6356ba
with_theme() do
	opts1 = (color = :black, label = "1S")
	opts3 = (color = :red,   label = "2S")
	opts2 = (color = :blue,  label = "Gri-Mech 3.0")
	grids = (xgridstyle = :dot, ygridstyle = :dot)
	
	f = Figure(size = (650, 800))

	ax1 = Axis(f[1, 1]; grids...)
	ax2 = Axis(f[2, 1]; grids...)
	ax3 = Axis(f[3, 1]; grids...)

	ax1.ylabel = L"Temperature [$^\circ$C]"
	ax2.ylabel = L"Excess $O_2$ [%]"
	ax3.ylabel = L"Lower heating value [$MJ\cdotp{}kg^{-1}$]"
	ax3.xlabel = L"Equivalence ratio$$"
	
	lines!(ax1, phi, sol1.T; opts1...)
	lines!(ax2, phi, sol1.X; opts1...)
	lines!(ax3, phi, sol1.LHV; opts1...)

	lines!(ax1, phi, sol3.T; opts3...)
	lines!(ax2, phi, sol3.X; opts3...)
	lines!(ax3, phi, sol3.LHV; opts3...)
	
	lines!(ax1, phi, sol2.T; opts2...)
	lines!(ax2, phi, sol2.X; opts2...)
	lines!(ax3, phi, sol2.LHV; opts2...)

	ax1.xticks = 0.6:0.2:1.8
	ax2.xticks = 0.6:0.2:1.8
	ax3.xticks = 0.6:0.2:1.8
	
	ax1.yticks = 1400:200:2200
	ax2.yticks = 0:2:8
	ax3.yticks = 20:10:60
	
	xlims!(ax1, extrema(ax1.xticks.val))
	xlims!(ax2, extrema(ax2.xticks.val))
	xlims!(ax3, extrema(ax3.xticks.val))
	
	ylims!(ax1, extrema(ax1.yticks.val))
	ylims!(ax2, extrema(ax2.yticks.val))
	ylims!(ax3, extrema(ax3.yticks.val))
	
	axislegend(ax1; position = :rt, labelsize=12)
	axislegend(ax2; position = :rt, labelsize=12)
	axislegend(ax3; position = :rt, labelsize=12)
	
	f
end

# ╔═╡ a3f45a13-62f6-4714-85b7-89bf371b4630
md"""
Once checked the energetic suitability of the mechanism, we proceed with combustion delay evaluation. This choice is the reasonable one for actual applications given the deviations from ideal behavior. Here as assume ignition delay is measured by the peak of a reference radical species.

Computation is performed in a closed constant pressure reactor starting at the same temperature as reference paper. Solution is advanced in time using internal time-step size over the interval expected to capture ignition.
"""

# ╔═╡ 04b30214-c098-4dc3-b24d-17175ec2d831
function one_reactor_sim(gas; max_time_step = 1e-3, atol = 1e-15, rtol = 1e-10)
    """ Create reactor for ignition time simulation. """
    reactor = ct.IdealGasConstPressureReactor(gas)
    reactor.volume = 1.0
    reactor.chemistry_enabled = true
    reactor.energy_enabled = true

    network = ct.ReactorNet([reactor])
    network.max_time_step = max_time_step
    network.atol = atol
    network.rtol = rtol

    return network, reactor
end

# ╔═╡ 526141a7-718b-4417-a879-9919c1fd58f4
md"""
Below we select ``OH`` as the default radical for detecting ignition delay.
"""

# ╔═╡ dd5968c6-9be6-41b4-aeb1-dd65794f14c6
ignition_delay(states; species = "OH") = states.t[states(species).Y.argmax()]

# ╔═╡ 522d990a-f7c9-4f27-ab17-88ab87af3768
time_history = let
	estimated_ignition_delay_time = 0.1
	phi = 1.0
	
	gas = ct.Solution("gri30.yaml")
	gas.TP = 1200.0, ct.one_atm
	gas.set_equivalence_ratio(phi, fuel, oxid, basis="mole")
	
	t = 0.0
	network, reactor = one_reactor_sim(gas)
	
	time_history = ct.SolutionArray(gas, extra=("t",))
	time_history.append(reactor.thermo.state, t=t)

	while t < estimated_ignition_delay_time
	    t = PyCanteraTools.jlfloat(network.step())
	    time_history.append(reactor.thermo.state, t=t)
	end

	time_history
end;

# ╔═╡ f354034e-7156-4491-b756-833bc079619c
md"""
We recover the ignition time as reported by [Zhao et al. (2011)](https://doi.org/10.1007/s11434-010-4345-3) for reference. The next plot illustrates good agreement even though simulation was not carried with same mechanism.
"""

# ╔═╡ e327da08-1fce-4044-a8ae-0a8f46fe76a2
with_theme() do
	t = 1000PyCanteraTools.jlvec(time_history.t)
	X = 1000PyCanteraTools.jlvec(time_history("OH").X.ravel())
	T = PyCanteraTools.jlvec(time_history.T) .- T_REF
	
	tau = PyCanteraTools.jlfloat(ignition_delay(time_history))
	tau = round(1000tau; digits=2)
	
	grids = (xgridstyle = :dot, ygridstyle = :dot)
	
	f = Figure(size = (650, 600))

	ax1 = Axis(f[1, 1]; grids...)
	ax2 = Axis(f[2, 1]; grids...)

	ax1.title  = "Computed ignition delay $(tau) ms"
	ax1.ylabel = L"Mole fraction $\mathrm{OH}$ [$\times{}1000$]"
	ax2.ylabel = L"Temperature [$^\circ$C]"
	ax2.xlabel = L"Time [$ms$]"
	
	lines!(ax1, t, X; color = :black)
	lines!(ax2, t, T; color = :black)
	vlines!(ax1, tau; color = :red, linestyle = :dash)
	vlines!(ax2, tau; color = :red, linestyle = :dash)
	
	ax1.xticks = 0:10:100
	ax2.xticks = 0:10:100
	
	ax1.yticks = 0.0:5.0:20
	ax2.yticks = 800:400:2400
	
	xlims!(ax1, extrema(ax1.xticks.val))
	xlims!(ax2, extrema(ax2.xticks.val))
	
	ylims!(ax1, -1, 20)
	ylims!(ax2, extrema(ax2.yticks.val))

	f
end

# ╔═╡ 215e07f8-faca-49f7-a0b5-b5f53b844b80
md"""
Another important element to show is the negative temperature coefficient (NTC) of the mechanism. This is shown by demonstrating a faster combustion with increased initial temperature.
"""

# ╔═╡ 953234a8-cc26-4606-bb97-ebc23e1c7322
md"""
```python
# TODO: finish translating from Python!

T = np.arange(2000, 999, -25)

estimated_ignition_delay_times = 0.1 * np.ones_like(T, dtype=float)

extra = {"tau": estimated_ignition_delay_times}
ignition_delays = ct.SolutionArray(gas, shape=T.shape, extra=extra)
ignition_delays.set_equivalence_ratio(phi, X_fuel, X_oxid, basis="mole")
ignition_delays.TP = T, ct.one_atm

# A scan is performed over all array elements to compute ignition delays.

for k, state in enumerate(ignition_delays):
    gas.TPX = state.TPX
    network, reactor = make_simulation(gas)
    reference_species_history = []
    time_history = []

    t = 0
    while t < estimated_ignition_delay_times[k]:
        t = network.step()
        time_history.append(t)
        reference_species_history.append(gas[reference_species].X[0])

    i_ign = np.array(reference_species_history).argmax()
    ignition_delays.tau[k] = time_history[i_ign] * 1e3

# The following plot displays the characteristic curve for NTC checks.

plt.close("all")
plt.style.use("seaborn-white")
fig, ax = plt.subplots(1, 1, figsize=(6, 4))
fig.suptitle(f"Negative Temperature Coefficient Check")
ax.semilogy(1000 / ignition_delays.T, ignition_delays.tau)
ax.grid(linestyle=":")
ax.set_ylabel("Ignition Delay [ms]")
ax.set_xlabel("$1000\\times{}T^{-1}\:[K^{-1}]$ ")
ax.set_xlim(0.5, 1.0)
ax.set_ylim(0.01, 1000.0)
fig.tight_layout()
```
"""

# ╔═╡ ff5573c6-2a94-455a-8d7f-f8ff2ab384e7
md"""
## Hydrogen combustion
"""

# ╔═╡ 37c27593-b099-417f-83c4-517eeb670aba


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
# ╟─f546936f-a6cd-4b33-b0b6-a48c33a5923b
# ╠═6306a3e4-1da6-4aca-a62e-53b08d623198
# ╟─e59a579d-55c6-4b01-99b5-04eb7264c13f
# ╠═ae8818e6-4814-4540-95fc-c5f1c7ff5f68
# ╠═39eb0994-d697-4941-82d8-1b37df30982e
# ╟─180d8567-3f03-45d5-a38e-b4c42d4f823b
# ╟─b0de1f21-923a-47dd-845c-2e5281d4234b
# ╠═e2862cfd-77ee-4be6-b735-011bd27e524a
# ╟─3d2632cb-9fa9-44c4-b217-51d6e348420c
# ╠═509e4e39-4781-492d-8de4-08ac783accd5
# ╟─69f921ac-eb3a-46db-a5cd-7c6b44f7835e
# ╟─9f2522c6-8445-44b2-9907-27a12562c5c8
# ╟─cc37c9ec-28d8-4535-8427-fb6fa783478b
# ╠═3765f384-18b5-44a8-b3da-3b8ee45f0046
# ╟─e9e34790-d0f9-4104-8f2a-d5956bd9f273
# ╠═8830ff90-8900-4ca7-8ce4-42dc0a5f140c
# ╟─33a1231f-964b-4329-b6f0-df4dab3d6617
# ╠═d3f25a8d-51c0-4b9c-b142-72e05e5a7ca2
# ╟─9092776a-530e-4117-b6c0-73c534ed9311
# ╠═dc7ef9f5-f67c-4597-ba7d-54dfc0f55fea
# ╟─e5a4bf0d-cc0e-4d42-81cc-e499550de833
# ╠═3ecef36c-b981-4e8c-b710-99451b8f1f93
# ╟─1c080861-4a76-4f09-901a-18b438f9c392
# ╟─d07e4d17-554b-47c3-84cd-fefdbbcea2ba
# ╟─e0baf847-406e-47bb-9fb2-b47a7bbbb31d
# ╠═be646930-c893-4fcb-9e3e-e1408c1da9ac
# ╟─65067cb0-7339-464e-b237-cb99a370b4c1
# ╟─fe078411-c131-4ef2-9b05-8f71fba0b0e4
# ╟─4f9d5ca2-5ba3-49c9-acbd-82606a413d07
# ╠═9c7930f2-a18c-4d5e-b4a3-0eda53920aac
# ╟─af2fa456-07a3-496d-93d6-fa7f5f3480cf
# ╠═eb36681a-fb76-44e2-9b99-e1a3869886d5
# ╟─4b575958-5429-43bf-b11d-5f6c059a34ab
# ╠═c15061b4-bf4e-467c-bf36-eb7007f91b26
# ╟─8a7d9457-ceee-43e8-98e9-14bec9475c69
# ╟─1604a7a7-0252-4695-bde1-13f6fc6356ba
# ╟─a3f45a13-62f6-4714-85b7-89bf371b4630
# ╠═04b30214-c098-4dc3-b24d-17175ec2d831
# ╟─526141a7-718b-4417-a879-9919c1fd58f4
# ╠═dd5968c6-9be6-41b4-aeb1-dd65794f14c6
# ╠═522d990a-f7c9-4f27-ab17-88ab87af3768
# ╟─f354034e-7156-4491-b756-833bc079619c
# ╟─e327da08-1fce-4044-a8ae-0a8f46fe76a2
# ╟─215e07f8-faca-49f7-a0b5-b5f53b844b80
# ╟─953234a8-cc26-4606-bb97-ebc23e1c7322
# ╟─ff5573c6-2a94-455a-8d7f-f8ff2ab384e7
# ╠═37c27593-b099-417f-83c4-517eeb670aba
