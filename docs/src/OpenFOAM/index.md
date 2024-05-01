# OpenFOAM

```@meta
CurrentModule = OpenFOAM
DocTestSetup  = quote
    using OpenFOAM
end
_EditURL = "/WallyToolbox.jl/docs/src/OpenFOAM/index.md"
```

```@autodocs
Modules = [ OpenFOAM ]
```

## Discrete phase models

We can verify the computation of number of parcels per second of sample case
[`injectionChannel`](https://github.com/OpenFOAM/OpenFOAM-11/tree/master/tutorials/incompressibleDenseParticleFluid/injectionChannel).
Notice that the value of `mdot` has been reversed engineered so that it matches the expected value.

```jldoctest
julia> parcels_per_second(; ṁ = 0.2, ρ = 1000.0, d = 650.0e-06, nParticle = 1)
1390885
```
