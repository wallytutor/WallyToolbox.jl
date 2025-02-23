##############################################################################
# GRANULAR
##############################################################################

export PackedBedPorosityDescriptor

##############################################################################
# PACKED BED
##############################################################################

"""
Provides description of porosity parameters with stochastic behavior.

## Fields

$(TYPEDFIELDS)

## Examples

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
"""
struct PackedBedPorosityDescriptor
    "Porosity volume fraction in medium [-]."
    ϕ::Union{Float64, Vector{Float64}}

    "Characteristic particle size in medium [m]."
    l::Union{Float64, Vector{Float64}}

    "Optional standard deviation of porosity volume fraction  [-]."
    σϕ::Union{Float64, Nothing}

    "Optional standard deviation of characteristic particle size [m]."
    σl::Union{Float64, Nothing}

    "Perimeter in reactor cross-section [m]."
    P::Union{Float64, Vector{Float64}}

    "Characteristic diameter of porosity channels [m]."
    D::Union{Float64, Vector{Float64}}

    "Reactor area used for scaling perimeter [m²]."
    A::Float64

    function PackedBedPorosityDescriptor(;
            ϕ::Float64,
            l::Float64,
            σϕ::Union{Float64, Nothing} = nothing,
            σl::Union{Float64, Nothing} = nothing,
            N::Union{Int64, Nothing} = nothing,
            ϕlims::Tuple{Float64, Float64} = (0.4, 0.8),
            llims::Tuple{Float64, Float64} = (0.0, 0.3),
            seed::Int64 = 42,
            area::Float64 = 1.0
        )
        if !any(isnothing, [σϕ, σl, N])
            Random.seed!(seed)
            ϕᵤ = rand(truncated(Normal(ϕ, σϕ), ϕlims...), N)
            lᵤ = rand(truncated(Normal(l, σl), llims...), N)
        else
            ϕᵤ = ϕ
            lᵤ = l
        end

        P = @. 6.0 * (1.0 - ϕᵤ) / lᵤ
        D = @. 4.0 * ϕᵤ / P

        return new(ϕᵤ, lᵤ, σϕ, σl, area * P, D, area)
    end
end

function Base.length(p::PackedBedPorosityDescriptor)
    return length(p.ϕ)
end

function Base.show(io::IO, obj::PackedBedPorosityDescriptor)
    if any(isnothing, [obj.σϕ, obj.σl])
        P = @sprintf("%.6f m", obj.P)
        D = @sprintf("%.6f m", obj.D)
        print(io, "PackedBedPorosityDescriptor(P = $(P), D = $(D))")
    else
        P = map(x->@sprintf("%10.6f m", x), obj.P)
        D = map(x->@sprintf("%10.6f m", x), obj.D)
        print(io, """\
        PackedBedPorosityDescriptor(
            P from $(P[1]) to $(P[2])
            D from $(D[1]) to $(D[2])
        )\
        """)
    end
end

##############################################################################
# EOF
##############################################################################