# DryMaterials

```@meta
CurrentModule = DryMaterials
DocTestSetup  = quote
    using DryMaterials
end
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/DryMaterials/index.md"
```

## Solid Thermodynamics

!!! danger

    The following sub-sections document structures and functions that are undergoing active development to harmonize all interfaces. Changes are expected to happen all the time before a common ground is found.

### Laurent Polynomial Models

```@docs
SolidPolynomialProperties
```

### Shomate Model

Solid materials properties are often reported according to the formalism of ([[@Shomate1954]]). To be able to handle data under this format, the following structure is provided.

```@docs
DryMaterials.SolidShomateProperties
```

Using data from [NIST Webbook of Chemistry](https://webbook.nist.gov/cgi/cbook.cgi?ID=C14808607&Type=JANAFS&Table=on) we have the test:

```jldoctest
julia> T = [298.0, 300.0, 400.0, 847.0, 900.0, 1900.0];
    
julia> c = [44.57, 44.77, 53.43, 67.42, 67.95, 77.99];

julia> silica = DryMaterials.getshomatesilica();

julia> sum(abs2, silica.cₚ.(T) - c) < 0.0001
true
```

The inner workings of `DryMaterials.SolidShomateProperties` are provided by the following functions. Notice that these do not automatically manage the ranges, so generating functions with the main structure is the recommended way of implementing programs.

```@docs
DryMaterials.shomatespecificheat
DryMaterials.shomateenthalpy
DryMaterials.shomateentropy
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

## Temporary (moving to database)

```@docs
DryMaterials.getshomatesilica
DryMaterials.getamorphoussilica
DryMaterials.getkaolinite
DryMaterials.getmetakaolin
DryMaterials.getspinel
```
