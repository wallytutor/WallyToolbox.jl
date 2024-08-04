# Unstable

```@meta
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/WallyToolbox/unstable.md"
CurrentModule = WallyToolbox
DocTestSetup = quote
    using WallyToolbox
end
```

## DryUtilities

!!! danger
    
    This module is deprecated and is progressivelly migrating to the root.

```@meta
CurrentModule = DryUtilities
DocTestSetup  = quote
    using DryUtilities
    using DryUtilities: heaviside, interval, makestepwise1d
    using DryUtilities: closestpowerofx, axesunitscaler
    using DryUtilities: maxrelativechange, maxabsolutechange
end
```

### Handling of discontinuous functions

Discontinuous functions are all over in real world applications. Whether they handle discrete signals sent to controllers or represent a material property change in the solution domain of a heat transfer simulation, they are often represented by a single or a composition of [Heaviside step](https://en.wikipedia.org/wiki/Heaviside_step_function) functions. Again, because its implementation is pretty simple and optimization routines require a differentiable form of this function, `DryUtilities` implements [`heaviside`](@ref) and [`interval`](@ref) as proposed in this [StackOverflow answer](https://stackoverflow.com/a/27677532/11987084).

```jldoctest
julia> heaviside(-1) == 0
true

julia> heaviside(-1.0) == 0.0
true

julia> heaviside(0.0) == 0.5
true

julia> heaviside(1.0) == 1.0
true

julia> interval(10; a = 0, b = 10) == 0.5
true
```

We see below that [`heaviside`](@ref) also works on ranges

```jldoctest
julia> heaviside(-2:2)
5-element Vector{Float64}:
 0.0
 0.0
 0.5
 1.0
 1.0
```    

```@docs
DryUtilities.heaviside
```
By implementation inheritance that is also the case for [`interval`](@ref):

```jldoctest
julia> interval(0:6; a = 2, b = 5)
7-element Vector{Float64}:
 0.0
 0.0
 0.5
 1.0
 1.0
 0.5
 0.0
```

```@docs
DryUtilities.interval
```

As it is the case for representation of specific heats using NASA7/NASA9 or Shomate polynomials, functions defined by parts with an specific change point are also required in physical modeling. To this end, a stepwise function can be established with [`makestepwise1d`](@ref). If keyword `differentialble = true`, then the function makes use of the above [`interval`](@ref) and remains
compatible with `ModelingToolkit`, for instance.

```jldoctest
julia> f = makestepwise1d(x->x, x->x^2, 1.0; differentiable = true);

julia> f(0:0.2:2.0)
11-element Vector{Float64}:
 0.0
 0.2
 0.4
 0.6
 0.8
 1.0
 1.44
 1.9599999999999997
 2.5600000000000005
 3.24
 4.0

julia> using ModelingToolkit

julia> @variables x
1-element Vector{Num}:
 x

julia> f(x); # Output is too long, try by yourself.
```

```@docs
DryUtilities.makestepwise1d
```

### Rounding numbers and automatic axes

!!! danger

    This section documents functions that are used in a very unstable context.

Simple rounding is not enough. Getting values that are rounded close to a power of a given number and rounded to floor or ceil is often the case. This is standardized in `DryTooling` through [`closestpowerofx`](@ref):

```jldoctest
julia> closestpowerofx(10)
10

julia> closestpowerofx(11)
20

julia> closestpowerofx(11, roundf = floor)
10

julia> closestpowerofx(11, x = 5, roundf = floor)
10

julia> closestpowerofx(12.0; x = 10)
20

julia> closestpowerofx(12.0; x = 10, roundf = floor)
10

julia> closestpowerofx(12.0; x = 10, roundf = round)
10
```

```@docs
DryUtilities.closestpowerofx
```

Below we illustrate the usage of [`axesunitscaler`](@ref).

**NOTE:** this function is not yet stable. In the future it will instead return labels using symbols like `k`, `M`, `G`, etc., for the units through a flag provided by the user.

```jldoctest
julia> axesunitscaler(1)
("", 1)

julia> axesunitscaler(1000)
("[×1000]", 1000)

julia> axesunitscaler(1000000)
("[×1000000]", 1000000)
```

```@docs
DryUtilities.axesunitscaler
```

### Computation of changes and residuals

!!! danger

    This section documents functions that are used in a very unstable context.

```@docs
DryUtilities.maxabsolutechange
DryUtilities.maxrelativechange
```

### Unit conversion

```@docs
DryUtilities.nm3_h_to_kg_h
DryUtilities.kg_h_to_nm3_h
```
