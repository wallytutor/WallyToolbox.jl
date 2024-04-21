# OpenFOAM

```@meta
CurrentModule = OpenFOAM
DocTestSetup  = quote
    using OpenFOAM
end
```

```@autodocs
Modules = [ OpenFOAM ]
```

## Discrete phase models

We can verify the computation of number of parcels per second of sample case
[`injectionChannel`](https://github.com/OpenFOAM/OpenFOAM-11/tree/master/tutorials/incompressibleDenseParticleFluid/injectionChannel).
Notice that the value of `mdot` has been reversed engineered so that it matches the expected value.

```jldoctest
julia> OpenFOAM.parcels_per_second(;
    mdot = 0.2,
    rhop = 1000.0,
    diam = 650.0e-06,
    nParticle = 1
)
1390885
```
