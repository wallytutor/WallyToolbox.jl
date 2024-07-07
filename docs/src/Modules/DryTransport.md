# DryTransport

```@meta
CurrentModule = DryTransport
DocTestSetup  = quote
    using DryTransport
end
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/DryTransport/index.md"
```

## Dimensionless groups

### Groups by definition


```@docs
DryTransport.nusselt
DryTransport.prandtl
DryTransport.reynolds
```

### Groups by application

```@docs
DryTransport.ConstantPrandtl
```

```@docs
DryTransport.ReynoldsPipeFlow
DryTransport.NusseltGnielinski
DryTransport.NusseltDittusBoelter
```

## Heat transfer coefficients

```@docs
DryTransport.HtcPipeFlow
DryTransport.htc
```
