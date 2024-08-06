# Constants

```@meta
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/WallyToolbox/constants.md"
CurrentModule = WallyToolbox
DocTestSetup = quote
    using WallyToolbox
end
```

## Configuration

The following constants are not exported by the toolbox; their use is mostly intended for developers and some particular use cases. If extending module data, please consider using the reference path.

```@docs
WallyToolbox.WALLYTOOLBOXPATH
WallyToolbox.WALLYTOOLBOXDATA
WallyToolbox.MAJORDOMEPATH
```

## Physical constants

```@docs
WallyToolbox.GAS_CONSTANT
WallyToolbox.STEFAN_BOLTZMANN
```

## Reference states

```@docs
WallyToolbox.T_REF
WallyToolbox.P_REF
WallyToolbox.C_REF
```

## Unit conversion

```@docs
WallyToolbox.ZERO_CELSIUS
WallyToolbox.ONE_ATM
WallyToolbox.JOULE_PER_CALORIE
```

## Chemistry-related

```@docs
WallyToolbox.M_AIR
WallyToolbox.ELEMENTS
```
