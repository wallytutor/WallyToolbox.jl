# DryCombustion

```@meta
CurrentModule = DryCombustion
DocTestSetup  = quote
    using DryCombustion
end
```

## Heavy fuel-oils

```@docs
DryCombustion.hfo_specific_heat
DryCombustion.hfo_enthalpy_net_bs2869
```

```jldoctest
julia> hfo_enthalpy_net_bs2869(; ρ = 1020.0, water = 0.1, ash = 0.05, sulphur = 1.0)
40.13509836320001
```
