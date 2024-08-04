# Flowsheet

```@meta
CurrentModule = WallyToolbox
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/WallyToolbox/flowsheet.md"
DocTestSetup = quote
    using WallyToolbox
end
```

## Unit operations

```@docs
WallyToolbox.StreamPipeline
WallyToolbox.MaterialStream
WallyToolbox.EnergyStream
WallyToolbox.TransportPipeline
WallyToolbox.SolidsSeparator
WallyToolbox.CooledCrushingMill
```

```@docs
WallyToolbox.transport_pipe
WallyToolbox.cooled_crushing
```

## Computed quantities

```@docs
WallyToolbox.enthalpyflowrate
WallyToolbox.exchanged_heat
```