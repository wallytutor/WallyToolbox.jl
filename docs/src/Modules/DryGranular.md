# DryGranular

```@meta
CurrentModule = DryGranular
DocTestSetup  = quote
    using Statistics
    using DryGranular
end
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/DryGranular/index.md"
```

## General porous media

Modeling of geometrical characteristics of porous beds is required for including
both their thermal effect or role over chemistry in chemical reactors. A
classical approach used in several commercial and open source tools is that of
([[@Gunn1978]]). In what follows we develop the ideas that lead to an
analogous model which is implemented by this structure.

To build the model we will assume a reactor of constant rectangular
cross-section ``{A}_{r}={b}{w}`` and volume ``{V}_{R}={b}{w}{h}``. Its
cross-section perimeter is then ``{P}_{R}=2({b}+{w})``. Inside this reactor we
randomly pack cubic particles ``\beta`` of surface area
``{A}_{\beta}=6{l}_{\beta}^2`` and volume ``{V}_{\beta}={l}_{\beta}^3`` at a
porosity level ``{\phi}``. Thus the total volume of solids inside the reactor is
``{V}_{S}=(1-{\phi}){V}_{R}`` and the approximate number of particles
``{N}=\frac{{V}_{S}}{{V}_{\beta}}``. Following a similar reasoning the total
surface area of particles is ``{A}_{S}={N}{A}_{\beta}``. Performing all the
substitutions so far one finds the following expression

```math
{A}_{S}=\frac{6(1-{\phi}){b}{w}{h}}{{l}_{\beta}}
```

Since the differential ``d{A}={P}d{l}`` holds for the surface of a body over its
length ``{l}``, one can divide the above expression by the reactor length to get
the perimeter of particles in a cross-section. We can further divide by the
cross-section area itself and find the *perimeter density* which is a more
general result, and find the expression proposed by ([[@Gunn1978]]). This
result is summarized in the next equation where the subscript of particle size
was dropped for generality.

```math
{P} = \frac{6(1-{\phi})}{{l}}
```

An estimator of the number of channels per unit cross-section of reactor ``{N}``
can be related to the porosity through ``{N}\pi{R}^2={\phi}``. Because the above
perimeter is shared between the fluid volume and solids, it holds that
``{N}2\pi{R}=P``. Using these expressions one can solve for the porosity
channels characteristic *radius* ``{R}`` as given below, which is also a result
reported by ([[@Gunn1978]]).

```math
{R}=\frac{{\phi}{l}}{3(1-{\phi})}
```

This model is probided in [`PackedBedPorosityDescriptor`](@ref).

```@docs
DryGranular.PackedBedPorosityDescriptor
```

[`PackedBedPorosityDescriptor`](@ref) can be used to describe the geometry of
exchange section of a packed bed for a single set of arguments.

```jldoctest
julia> PackedBedPorosityDescriptor(; ϕ = 0.65, l = 0.10, area = 1.0)
PackedBedPorosityDescriptor(P = 21.000000 m, D = 0.123810 m)
```

It can also be used to describe randomly varying reactors, what is a more
realistic thing to do when using this structure to simulate real world systems.

```jldoctest
julia> PackedBedPorosityDescriptor(;
            ϕ  = 0.65, l  = 0.10,
            σϕ = 0.03, σl = 0.01,
            N = 2,
            ϕlims = (0.4, 0.8),
            llims = (0.0, 0.3),
            seed = 42,
            area = 1.0
        )
PackedBedPorosityDescriptor(
    P from  21.455749 m to  24.370742 m
    D from   0.125589 m to   0.102353 m
)
```

## Rotary kiln models

In a rotary kiln as proposed by ([[@Kramers1952]]). Its goal is to be used as a process support tool or to
integrate more complex models requiring integration of the bed profile. In its
classical statement, the bed height profile ``h(z)`` can be evaluated from
*volume* of flowing material conservation through the following equations.
Coordinate ``z=0`` represents the discharge position where initial condition
must be applied. This is given by the dam height, if any, or particle size.

```math
\begin{aligned}
\dfrac{dh}{dz} &= C₁ \left[\frac{h}{R}\left(2 - \frac{h}{R}\right)\right]^{-\frac{3}{2}} - C₂\\[6pt]
C₁             &= \frac{3}{4}\dfrac{Φ\tan{γ}}{π R^3 ω}\\[6pt]
C₂             &= \dfrac{\tan{β}}{\cos{γ}}
\end{aligned}
```

The structure [`SymbolicLinearKramersModel`](@ref) implements the Kramers'
ordinary differential equation for prediction of bed height profile in a rotary
kiln. This equation is implemented under the formalism of `ModelingToolkit`.

```@docs
DryGranular.SymbolicLinearKramersModel
```


For integration of this model we implement [`RotaryKilnBedSolution`](@ref). It
provides the solved description of a rotary kiln bed geometry computed from the
solution of bed height along the kiln length. The main goal of the quantities
computed here is their use with heat and mass transfer models for the simulation
of rotary kiln process. A simple post-processing utilitiy
[`plotlinearkramersmodel`](@ref) is also provided.

```@docs
DryGranular.RotaryKilnBedSolution
DryGranular.plotlinearkramersmodel
```

Data in next example is an SI conversion of an example from ([[@Kramers1952]]).

```jldoctest
julia> L = 13.715999999999998;  # Kiln length [m]

julia> D = 1.8897599999999999;  # Kiln diameter [m]

julia> β = 2.3859440303888126;  # Kiln slope [°]

julia> γ = 45.0;                # Repose angle [°]

julia> d = 1.0;                 # Particle/dam size [mm]

julia> Φ = 10.363965852671996;  # Feed rate [m³/h]

julia> ω = 3.0300000000000002;  # Rotation rate [rev/min]

julia> bed = RotaryKilnBedSolution(;
            model = SymbolicLinearKramersModel(),
            L     = L,
            R     = D / 2.0,
            Φ     = Φ / 3600.0,
            ω     = ω / 60.0,
            β     = deg2rad(β),
            γ     = deg2rad(γ),
            d     = d / 1000.0
        );

julia> bed
RotaryKilnBedSolution(τ = 13.169938 min, ηₘ = 5.913271 %)

julia> bed.τ
790.1963002204403
```

In the following dummy example we force a very thick *analytical* bed solution,
filling the radius of the rotary drum. 

```jldoctest dummy-1
julia> R = 1.0e+00;

julia> Φ = 1.0e-02;

julia> z = collect(0.0:0.1:10.0);

julia> h = R * ones(size(z));

julia> Aₐ = π * R^2 / 2;

julia> Vₐ = Aₐ * z[end];

julia> bed = RotaryKilnBedSolution(z, h, 0, R, Φ)
RotaryKilnBedSolution(τ = 26.179939 min, ηₘ = 50.000000 %)
```

Next we confirm the *internal* evaluations of the model match the expected *analytical* values.

```jldoctest dummy-1
julia> mean(bed.θ) ≈ π
true

julia> mean(bed.l) ≈ 2R
true

julia> mean(bed.A) ≈ Aₐ
true

julia> mean(bed.η) ≈ 0.5
true

julia> bed.ηₘ ≈ 50.0
true

julia> bed.V ≈ Vₐ
true

julia> bed.τ ≈ Vₐ / Φ
true
```

Validation of Kramers' model is provided [here](validation/DryGranular/kramers.md).

Finally a set of basic equations provided for process analysis.

```@docs
DryGranular.sullivansηₘ
DryGranular.dimlessNΦ
DryGranular.dimlessNₖ
DryGranular.perrayresidence
DryGranular.kramersnlapprox
```
