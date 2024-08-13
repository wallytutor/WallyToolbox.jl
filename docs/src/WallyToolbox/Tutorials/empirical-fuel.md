# Empirical fuel manipulation

```@meta
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/WallyToolbox/Tutorials/empirical-fuel.md"
CurrentModule = WallyToolbox
DocTestSetup = quote
    using WallyToolbox
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
