# -*- coding: utf-8 -*-

import Base: +
import Base: *

export Stoichiometry
export ChemicalCompound
export element, atomicmass
export molecularmass

#############################################################################
# Type signatures
#############################################################################

"Represents a chemical element."
const ElementData = Tuple{String, String, Float64}

"Represents a pair of element symbol and associated amount."
const ElementalQuantity = Pair{Symbol, <:Number}

#############################################################################
# Compose elemental stoichiometries
#############################################################################

"""
Compound stoichiometry for ease of data manipulation.

This type provide a simple interface for declaring chemical compounds from
stable [`ELEMENTS`](@ref) and computing molecular masses. Its main use is
intended for compound creation during parsing of thermodynamic databases.
Below we illustrate the creation of compounds and the *algebra* of creation
of derived compounds.

```jldoctest
julia> al2o3 = Stoichiometry(Al=2, O=3)
Stoichiometry(Pair{Symbol, <:Number}[:Al => 2, :O => 3])

julia> molecularmass(al2o3)
0.1019600768

julia> ca1o1 = Stoichiometry(Ca=1, O=1)
Stoichiometry(Pair{Symbol, <:Number}[:Ca => 1, :O => 1])

julia> c1a2 = ca1o1 + 2 * al2o3
Stoichiometry(Pair{Symbol, <:Number}[:Al => 4, :Ca => 1, :O => 7])

julia> molecularmass(c1a2)
0.25999715360000003
```

Please notice that [`ChemicalCompound`](@ref) creation should be done
as early as possible as Stoichiometry has no state other than the number
of atoms. Its recurrent use may lead to high computational cost for the
evaluation of molecular masses.
"""
struct Stoichiometry
    amounts::Vector{ElementalQuantity}

    function Stoichiometry(qty)
        # catchduplicates(qty) =>
        (qty .|> first |> unique |> length) == length(qty) || begin
            # XXX: the performance of the following is low, it
            # needs to be generalized to use a faster counter.
            names = first.(qty)
            mults = map(k->k=>count(==(k), names), unique(names))
            mults = sort(filter(a->a[2]>1, mults), rev=true, by=x->x[2])
            throw("Quantity keys must unique: $(first(mults))")
        end

        # assertnonnegative(qty) =>
        all(qty .|> last .>= 0) || begin
            negs = first(filter(a->a[2]<0, qty))
            throw("Coefficients must non-negative: $(negs)")
        end

        return new(qty)
    end
end

Stoichiometry(; kw...) = Stoichiometry([k => v for (k, v) in kw])

function Base.:*(c::Number, s::Stoichiometry)::Stoichiometry
    return Stoichiometry(map(x->x[1]=>c*x[2], s.amounts))
end

function Base.:*(s::Stoichiometry, c::Number)::Stoichiometry
    return c * s
end

function Base.:+(a::Stoichiometry, b::Stoichiometry)::Stoichiometry
    da, db = Dict(a.amounts), Dict(b.amounts)
    allkeys = [union(keys(da), keys(db))...]
    return Stoichiometry(map(k->k=>get(da, k, 0)+get(db, k, 0), allkeys))
end

#############################################################################
# Create processed compounds from stoichiometries
#############################################################################

"""
A chemical compound with internal values pre-computed for recurrent use.

```jldoctest
julia> al2o3 = Stoichiometry(Al=2, O=3);

julia> ca1o1 = Stoichiometry(Ca=1, O=1);

julia> CA = ChemicalCompound(ca1o1 + al2o3);

julia> molecularmass(CA)
0.1580370768
```
"""
struct ChemicalCompound
    compound::Stoichiometry
    elements::Vector{Symbol}
    X::Vector{Float64}
    Y::Vector{Float64}
    M::Float64

    function ChemicalCompound(st::Stoichiometry)
        M = 0.0
        A = 0

        n = length(st.amounts)
        elements = Vector{Symbol}(undef, n)
        X, Y = zeros(n), zeros(n)

        for (k, c) in enumerate(st.amounts)
            # Store element for index search.
            e = elements[k] = first(c)

            # Count number of atoms `k`.
            x = X[k] = last(c)

            # Total mass of atoms `k`.
            y = Y[k] = x * atomicmass(e)

            # Cummulative atoms/molecular mass.
            A += x
            M += y
        end

        return new(st, elements, X ./ A, Y ./ M, M)
    end
end

#############################################################################
# Other functionalities
#############################################################################

""" Retrieve an element by name. """
element(s::String) = getfield(ELEMENTS, Symbol(s))

#############################################################################
# atomicmass()
#############################################################################

atomicmass(s::Union{String,Symbol}) = element(String(s)) |> atomicmass

atomicmass(e::ElementData) = 0.001e[3]

@doc """ Atomic mass of element [kg/mol]. """ atomicmass

#############################################################################
# molecularmass()
#############################################################################

# Also support elements by aliasing.
molecularmass(s::Union{String,Symbol}) = atomicmass(s)

molecularmass(e::ElementData) = atomicmass(e)

# Using Union{NamedTuple, Base.Pairs}:
molecularmass(nt) = sum(c*atomicmass(s) for (s, c) in pairs(nt))

# For use as molecularmass(; C=2, H=2), etc:
molecularmass(; kw...) = molecularmass(kw)

# Recomended way using Stoichiometry:
molecularmass(s::Stoichiometry) = molecularmass(; s.amounts...)

# Recomended way using ChemicalCompound:
molecularmass(c::ChemicalCompound) = c.M

@doc """ Molecular mass of compound [kg/mol]. """ molecularmass
