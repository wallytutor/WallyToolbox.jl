# DryCombustion

```@meta
CurrentModule = DryCombustion
DocTestSetup  = quote
    using DryCombustion
end
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/Modules/DryCombustion.md"
```

## Empirical fuels

In industrial practice of CFD one is often confronted with simulating *empirical* fuels. This is how one generally calls a fuel provided in elemental mass fractions of elements and is the most common reporting format for heavy-fuel oil. Using [`EmpiricalFuel`](@ref) one can quickly perform conversions and find out the required air flow rate for setting up a process simulation or furnace operation.

```@docs
DryCombustion.EmpiricalFuel
```

A simple empirical fuel complete combustion can be represented by the following chemical equation:

$$
1\:\mathrm{C}_x\mathrm{H}_y\mathrm{O}_z + a\:\mathrm{O}_2 + b\:\mathrm{N}_2 \rightarrow 
x\:\mathrm{CO}_2 + \dfrac{y}{2}\:\mathrm{H}_2\mathrm{O} + b\:\mathrm{N}_2
$$

Because for HFO representation will generally provide sulfur and nitrogen, the oxidation of these elements may be included in the balance and the previous reaction can be modified to:

$$
1\:\mathrm{C}_x\mathrm{H}_y\mathrm{O}_z\mathrm{N}_n\mathrm{S}_s 
+ a\:\mathrm{O}_2 
+ b\:\mathrm{N}_2
%
\rightarrow
%
x\:\mathrm{CO}_2 
+ s\:\mathrm{SO}_2
+ n\:\mathrm{NO}
+ \dfrac{y}{2}\:\mathrm{H}_2\mathrm{O}
+ b\:\mathrm{N}_2
$$

Each element in carbon, hydrogen, sulfur, and nitrogen is present in a single oxide (here we assume $\mathrm{N}_2$ does not participate in oxidation, what would require equilibrium calculations with an enthalpy of formation of the empirical fuel that is generally unavailable - otherwise we would use the actual molecular representation of the substance), and balancing the right-hand side of the equation is trivial; one can derive the value of $a$ that remains compatible with oxygen content in fuel as:

$$
a = \dfrac{1}{2}\left(2x+2s+n+\dfrac{y}{2}-z\right)
$$

With this value it is trivial to find out the required mass flow rate of oxidizer. This is implemented in [`oxidizer_mass_flow_rate`](@ref) as documented below. Notice that this function will fail if one of the required elements in the above equation is missing. The presence of nitrogen oxides and sulfur is fuel is neglected in this calculations and one must assess whether they should be considered in a certain analysis prior to using this function.

```@docs
DryCombustion.oxidizer_mass_flow_rate
```

## Heavy fuel-oils

Combustion of heavy-fuel oils (HFO) is discussed in detail by ([[@Lawn1987]]). Some relations that might be useful for the industrial combustion specialist are under implementation here to be integrated in larger models *e.g.* using [`DryFlowsheet`](DryFlowsheet.md), or simple calculations.

```@docs
DryCombustion.hfo_empirical_formula
DryCombustion.hfo_specific_heat
DryCombustion.hfo_enthalpy_net_bs2869
```

## Discrete phase model

```@docs
DryCombustion.fit_rosinrammler
DryCombustion.plot_rosinrammler
```
