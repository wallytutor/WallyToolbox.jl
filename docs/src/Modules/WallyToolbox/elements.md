# Elements

```@meta
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/Modules/WallyToolbox/elements.md"
CurrentModule = WallyToolbox
DocTestSetup = quote
    using WallyToolbox
end
```

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
