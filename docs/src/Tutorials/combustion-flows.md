# Empirical fuel manipulation

```@meta
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/WallyToolbox/Tutorials/empirical-fuel.md"
CurrentModule = WallyToolbox
DocTestSetup = quote
    using WallyToolbox
    using PythonCall
    
    pyimport("cantera")
    pyimport("numpy")
end
```

## Evaluating mean fluid properties

In this note we show how to use [Cantera](https://cantera.org/) to retrieve mixture properties for use in external simulations. This approach should be used only when composition dependency may be neglected or real-time evaluation becomes to expensive.

```@example mean-fluid-props
using WallyToolbox
using PyCanteraTools

using CairoMakie
using Polynomials
using PythonCall

const ct = pyimport("cantera")
const np = pyimport("numpy")
nothing; #hide
```

Since Cantera is not yet available from Julia (I am working on that!), we wrap the interfacing with Python code in function `fit_gas_properties` provided below. There is a slight possibility that this function or a more generic variant of it will at some point be integrated into `PyCanteraTools`.

```@example mean-fluid-props
function fit_gas_properties(sol; orders = Dict())
    T = pyconvert(Vector{Float64}, sol.T)

    mu = pyconvert(Vector{Float64}, sol.viscosity)
    kg = pyconvert(Vector{Float64}, sol.thermal_conductivity)
    cp = pyconvert(Vector{Float64}, sol.cp_mass)

    poly_mu = Polynomials.fit(T, mu, get(orders, :mu, 4))
    poly_kg = Polynomials.fit(T, kg, get(orders, :kg, 4))
    poly_cp = Polynomials.fit(T, cp, get(orders, :cp, 4))

    return (mu, kg, cp, poly_mu, poly_kg, poly_cp)
end
nothing; # hide
```

For display of results, we also provide a standardized plotting function `plot_gas_properties`.

```@example mean-fluid-props
function plot_gas_properties(
        T, mu, kg, cp, poly_mu, poly_kg, poly_cp;
        every = 10
    )
    Ts = T[begin:every:end]

    f = Figure(size = (700, 800))

    ax1 = Axis(f[1, 1]; xgridstyle=:dash, ygridstyle=:dash)
    ax2 = Axis(f[2, 1]; xgridstyle=:dash, ygridstyle=:dash)
    ax3 = Axis(f[3, 1]; xgridstyle=:dash, ygridstyle=:dash)

    lines!(ax1, T, mu; color = :red)
    lines!(ax2, T, kg; color = :red)
    lines!(ax3, T, cp; color = :red)

    scatter!(ax1, Ts, poly_mu.(Ts); color = :black)
    scatter!(ax2, Ts, poly_kg.(Ts); color = :black)
    scatter!(ax3, Ts, poly_cp.(Ts); color = :black)

    ax1.ylabel = "Viscosity [Pa.s]"
    ax2.ylabel = "Conductivity [W/(m.K)]"
    ax3.ylabel = "Specific heat [J/(kg.K)]"
    ax3.xlabel = "Temperature [K]"

    return f, (ax1, ax2, ax3)
end
nothing; # hide
```

For illustration purposes we make use of a typical composition of air over a broad range of temperatures. Evaluation of the *properties table* is performed with Cantera `SolutionArray` class.

```@example mean-fluid-props
T = LinRange(200, 3000, 200)
X = "N2: 0.768, O2: 0.21, H2O: 0.006, Ar: 0.012, CO2: 0.004"

gas = ct.Solution("gri30.yaml")
sol = ct.SolutionArray(gas, shape=length(T))
sol.TPX = pylist(T), ct.one_atm, X
nothing; # hide
```

Finally we visualize the results; verification is performed against values proposed in the literature by ([[@Mujumdar2006i]]). As one can inspect below, values diverge from those evaluated from Gri-MECH 3.0 database.

```@example mean-fluid-props
with_theme() do
    rets = fit_gas_properties(sol)

    μmuj = AirViscosityMujumdar2006()
    kmuj = AirHeatConductivityMujumdar2006()

    f, ax = plot_gas_properties(T, rets...)

    lines!(ax[1], T, μmuj.(T); color = :blue)
    lines!(ax[2], T, kmuj.(T); color = :blue)

    ax[1].yticks = 1.0e-05:3.0e-05:1.0e-04
    ax[2].yticks = 0.0:0.05:0.2
    ax[3].yticks = 900:100:1400

    xlims!(ax[1], 300, 3000)
    xlims!(ax[2], 300, 3000)
    xlims!(ax[3], 300, 3000)

    ylims!(ax[1], 1.0e-05, 10.0e-05)
    ylims!(ax[2], 0.0, 0.2)
    ylims!(ax[3], 900.0, 1400)

    f
end
```

Another application case is the fitting of flue gases properties. One often needs to simulate the post-combustion flow in a segregated manner, *i.e.* not as an integral part of the combusting system. To that end, fitting properties and simply ignoring species transport can be an alternative to speed up calculations if the physics allows to do so.

Below we evaluate acetylene equilibrium adiabatic combustion products and then inspect the fitted polynomals.

```@example mean-fluid-props
fuel = "C2H2: 1.0"
oxid = "O2: 1.0"
nums = 100

gas = ct.Solution("gri30.yaml")
gas.set_equivalence_ratio(1.0, fuel=fuel, oxidizer=oxid, basis="mole")
gas.equilibrate("HP")

sol = ct.SolutionArray(gas, shape=(nums,))
sol.TP = np.linspace(200, 3800, nums), ct.one_atm

rets = fit_gas_properties(sol)

for p in rets[end-2:end]
    println(repr(p))
end
```

As a final validation step, one can again inspect properties graphically.

```@example mean-fluid-props
with_theme() do
    T = pyconvert(Vector{Float64}, sol.T)

    f, ax = plot_gas_properties(T, rets...)
    f
end
```

## Computing an equivalent species

In this tutorial we discuss an approach to *unify* species in a chemical system for simplified representation in CFD simulations; a typical use case would be simulating a system where energy aspects are more important than actual kinetics features and a major combusting species is present.

We start by importing the required tools:

```@example single-species-mech
using WallyToolbox
using PyCanteraTools
using PythonCall

const ct = pyimport("cantera")
nothing; # hide
```

In what follows let's assume that the molar composition of the reference fuel is given by the following composition string (in Cantera format). This is a typical natural gas composition where we find methane as major species, other minor hydrocarbons, and residual inert species.

```@example single-species-mech
X = "CH4: 0.9194, C2H6: 0.0302, C3H8: 0.0059, CO2: 0.0078, N2: 0.0367"
nothing; # hide
```

Assume we want to get a single *equivalent* hydrocarbon representing all those details in fuel composition; other species remain as they are. For this we can filter the selected species from the provided composition string with functionalities exported by `PyCanteraTools`.

```@example single-species-mech
hydrocarbons = ["CH4", "C2H6", "C3H8"]

ishydrocarbon(x) = x[1] in hydrocarbons

X_dict = filter(ishydrocarbon, cantera_string_to_dict(X))

X_hydr = cantera_dict_to_string(X_dict)
```

Next we load a solution with the reference mechanism and set the gas composition to the filtered (relative molar fractions) composition.

```@example single-species-mech
gas = ct.Solution("gri30.yaml")
gas.TPX = nothing, nothing, X_hydr
nothing; # hide
```

The elemental mass fractions of *CHONS* can be recoved from Cantera using the wrapper function `chons_get_fractions`.

```@example single-species-mech
Y = chons_get_fractions(gas; basis = :mass)
```

For preserving the flow characteristics of the simplified fuel, it is important to ensure the new *artificial* composition preserves the mean molecular mass. Doing so will keep constant inlet flow rate if using mass flow boundary conditions, as it is usual in combustion simulations.

```@example single-species-mech
mw = pyconvert(Float64, gas.mean_molecular_weight)
mw
```

Below we compute the stoichiometric coefficient of carbon in the target *artificial* species; it is simply a mass to mole fraction conversion, as one might promptly recognize.

```@example single-species-mech
scaler = :C => Y[1]*mw/1000atomicmass(:C)
```

Using the mass fractions and the scaler one can easily compute the new hypothetical species using `hfo_empirical_formula`. It must be emphasized that although this function was initially conceived for handling heavy-fuel oils (HFOs) it is can also be used for any species in the *CHONS* chemistry family.

```@example single-species-mech
empirical_fuel = hfo_empirical_formula(Y; scaler)

String(empirical_fuel)
```

To wrap-up we verify that the new species really matches the target molecular mass; because of round-off errors and possible differences in atomic masses between Cantera and our database [^1].

```@example single-species-mech
1000ChemicalCompound(Dict(zip("CHONS", empirical_fuel.X))).M ≈ mw
```

There are a few extra steps that one must be aware; with the newly created species we need to create (by some means not described here) a new mechanism containing the hypothetical species. Once that is done, one needs to compute the heating values related to that fuel, *e.g.* using `mixture_heating_value`, what will lead to unphysical values at first. The formation enthalpy of the referred species needs to be corrected in mechanism data (generally NASA7 polynomials, for which it is done in the fifth coefficient) to match the reference fuel energy release.

[^1]: There should not be any difference because the database used internally by WallyToolbox is an extraction of Cantera source code.
