# Thermochemistry

```@meta
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/WallyToolbox/thermochemistry.md"
CurrentModule = WallyToolbox
DocTestSetup = quote
    using WallyToolbox
end
```

## Composition manipulation

The core functionality is provided through the `Stoichiometry` structure:

```@docs
WallyToolbox.Stoichiometry
```

Once the composition of a compound has been set with `Stoichiometry`, the preferred method of working is through the creation of a `ChemicalCompound`, as follows:

```@docs
WallyToolbox.ChemicalCompound
```

The following methods and types are available for operation over compositions and elements.

```@docs
WallyToolbox.element
WallyToolbox.atomicmass
WallyToolbox.molecularmass
WallyToolbox.ElementData
WallyToolbox.ElementalQuantity
```

```
WallyToolbox.density
WallyToolbox.specific_heat
WallyToolbox.enthalpy
```

## Hard-coded substances

```@docs
WallyToolbox.PureAir
WallyToolbox.PureMineral
WallyToolbox.PureWater
```

## Thermodynamic properties

Materials properties are often reported according to the formalism of ([[@MaierKelley1932]]) or ([[@Shomate1954]]). To be able to handle data under these formats, the following structures are provided.

```@docs
WallyToolbox.LaurentPolynomialProperties
WallyToolbox.MaierKelleyThermo
WallyToolbox.ShomateThermo
```

## Empirical fuels

In industrial practice of CFD one is often confronted with simulating *empirical* fuels. This is how one generally calls a fuel provided in elemental mass fractions of elements and is the most common reporting format for heavy-fuel oil. Using [`EmpiricalFuel`](@ref) one can quickly perform conversions and find out the required air flow rate for setting up a process simulation or furnace operation.

```@docs
WallyToolbox.EmpiricalFuel
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
WallyToolbox.oxidizer_mass_flow_rate
```

## Heavy fuel-oils

Combustion of heavy-fuel oils (HFO) is discussed in detail by ([[@Lawn1987]]). Some relations that might be useful for the industrial combustion specialist are under implementation here to be integrated in larger models *e.g.* using [`DryFlowsheet`](../Modules/DryFlowsheet.md), or simple calculations.

```@docs
WallyToolbox.hfo_empirical_formula
WallyToolbox.hfo_specific_heat
WallyToolbox.hfo_enthalpy_net_bs2869
```

## Discrete phase model

```@docs
WallyToolbox.fit_rosinrammler
WallyToolbox.plot_rosinrammler
```
