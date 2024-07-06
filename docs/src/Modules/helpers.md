# Helpers

The core packages of `WallyToolbox` ecosystem provide shared functionalities and
types that are used in several other more specialized packages. This allows for
standardization of interfaces, employed quantities, and avoid boilerplate code.
This page organizes everything to facilitate the understanding of the end-user.
Knowing the base helper packages `DryConstants` and `DryUtilities` is key for
proper usage of `WallyToolbox`.

## DryConstants

```@meta
CurrentModule = DryConstants
```

### Physical constants

```@docs
DryConstants.GAS_CONSTANT
DryConstants.STEFAN_BOLTZMANN
DryConstants.STABLE_ELEMENTS_TABLE
```

### Reference states

```@docs
DryConstants.T_REF
DryConstants.P_REF
DryConstants.C_REF
```

### Other constants

```@docs
DryConstants.ZERO_CELSIUS
DryConstants.ONE_ATM
DryConstants.M_AIR
```

## DryElements

```@meta
CurrentModule = DryElements
```

```@autodocs
Modules = [ DryElements ]
```

## DryUtilities

```@meta
CurrentModule = DryUtilities
DocTestSetup  = quote
    using DryUtilities
    using DryUtilities: heaviside, interval, makestepwise1d
    using DryUtilities: closestpowerofx, axesunitscaler
    using DryUtilities: maxrelativechange, maxabsolutechange
end
```

### Haskell-like array slicing

Those who know Haskell probably started learning it by manipulating lists with
`head` and `tail`. Those functionalities are not available in Julia *by default*
and array slicing - with an ugly syntax - is required. Since this is done often
in the fields of application of `DryTooling`, both [`head`](@ref) and
[`tail`](@ref) together with a [`body`](@ref) functions are available in its
core. They are simple wrapers over the `@view` macro and work with both iterable
types and arrays. The following snippet illustrates their usage.

```jldoctest
julia> v = collect(1:4);

julia> head(v) == [1; 2; 3]
true

julia> tail(v) == [2; 3; 4]
true

julia> body(v) == [2; 3]
true
```

More examples are provided in the following documentation ahead of each of the
functions.

```jldoctest
julia> head(1:4)
1:3

julia> head([1, 2, 3, 4])
3-element view(::Vector{Int64}, 1:3) with eltype Int64:
 1
 2
 3

```

```@docs
DryUtilities.head
```

```jldoctest
julia> tail([1, 2, 3, 4])
3-element view(::Vector{Int64}, 2:4) with eltype Int64:
 2
 3
 4
julia> tail(1:4)
2:4
```

```@docs
DryUtilities.tail
```

```jldoctest
julia> body([1, 2, 3, 4])
2-element view(::Vector{Int64}, 2:3) with eltype Int64:
 2
 3
julia> body(1:4)
2:3
```

```@docs
DryUtilities.body
```

### Handling of discontinuous functions

Discontinuous functions are all over in real world applications. Whether they
handle discrete signals sent to controllers or represent a material property
change in the solution domain of a heat transfer simulation, they are often
represented by a single or a composition of [Heaviside
step](https://en.wikipedia.org/wiki/Heaviside_step_function) functions. Again,
because its implementation is pretty simple and optimization routines require a
differentiable form of this function, `DryUtilities` implements
[`heaviside`](@ref) and [`interval`](@ref) as proposed in this [StackOverflow
answer](https://stackoverflow.com/a/27677532/11987084).

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

As it is the case for representation of specific heats using NASA7/NASA9 or
Shomate polynomials, functions defined by parts with an specific change point
are also required in physical modeling. To this end, a stepwise function can be
established with [`makestepwise1d`](@ref). If keyword `differentialble = true`,
then the function makes use of the above [`interval`](@ref) and remains
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

Simple rounding is not enough. Getting values that are rounded close to a power
of a given number and rounded to floor or ceil is often the case. This is
standardized in `DryTooling` through [`closestpowerofx`](@ref):

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

**NOTE:** this function is not yet stable. In the future it will instead return
labels using symbols like `k`, `M`, `G`, etc., for the units through a flag
provided by the user.

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

### Others

```@docs
DryUtilities.defaultvalue
DryUtilities.redirect_to_files
DryUtilities.test_exhaustive
```

## Abstract types

```@meta
CurrentModule = DryAbstract
```

### Fixed state materials

```@docs
DryAbstract.AbstractMaterial
DryAbstract.AbstractSolidMaterial
DryAbstract.AbstractLiquidMaterial
DryAbstract.AbstractGasMaterial
DryAbstract.AbstractSolidMineralPhase
```

### Problem solving and physical models

```@docs
DryAbstract.AbstractMatrixProblem
DryAbstract.AbstractIterativeSolver
DryAbstract.AbstractSolutionStorage
DryAbstract.AbstractPhysicalModel
```

### Transport, thermodynamics, and kinetics

```@docs
DryAbstract.AbstractTransportModel
DryAbstract.AbstractSolidTransport
DryAbstract.AbstractGasThermo
DryAbstract.AbstractSolidThermo
DryAbstract.AbstractMixtureSubstance
DryAbstract.AbstractMixturePhase
DryAbstract.AbstractKineticsMechanism
```

### Finite volume method and relatives

```@docs
DryAbstract.AbstractDiffusionModel1D
DryAbstract.AbstractGrid1D
```
