# DryMaterials

```@meta
CurrentModule = DryMaterials
DocTestSetup  = quote
    using DryMaterials
end
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/Modules/DryMaterials.md"
```

## Solid Thermodynamics

!!! danger

    The following sub-sections document structures and functions that are undergoing active development to harmonize all interfaces. Changes are expected to happen all the time before a common ground is found.

### Laurent Polynomial Models

```@docs
SolidPolynomialProperties
```

## Ongoing documentation

```@docs
DryMaterials.SolidMineralPhase
DryMaterials.enthalpy
DryMaterials.specificheat
DryMaterials.density
DryMaterials.molecularmass
```

## Hard-coded materials

```@docs
DryMaterials.H_AIR
DryMaterials.PureAir
DryMaterials.PureMineral
DryMaterials.PureWater
```
