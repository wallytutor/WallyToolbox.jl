# DryCombustion

```@meta
CurrentModule = DryCombustion
DocTestSetup  = quote
    using DryCombustion
end
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/DryCombustion/index.md"
```

## Heavy fuel-oils

Combustion of heavy-fuel oils (HFO) is discussed in detail by ([[@Lawn1987]]). Some relations that might be useful for the industrial combustion specialist are under implementation here to be integrated in larger models *e.g.* using [`DryFlowsheet`](DryFlowsheet.md), or simple calculations.

```@docs
DryCombustion.hfo_specific_heat
DryCombustion.hfo_enthalpy_net_bs2869
```

```jldoctest
julia> hfo_enthalpy_net_bs2869(; ρ = 1020.0, water = 0.1, ash = 0.05, sulphur = 1.0)
40.13509836320001
```
