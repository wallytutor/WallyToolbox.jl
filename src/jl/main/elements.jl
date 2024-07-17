# -*- coding: utf-8 -*-

import Base: +
import Base: *

export Stoichiometry
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

""" Compound stoichiometry for ease of data manipulation."""
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

# Using Union{NamedTuple, Base.Pairs}:
molecularmass(nt) = sum(c*atomicmass(s) for (s, c) in pairs(nt))

# For use as molecularmass(; C=2, H=2), etc:
molecularmass(; kw...) = molecularmass(kw)

# Recomended way using Stoichiometry:
molecularmass(s::Stoichiometry) = molecularmass(; s.amounts...)

@doc """ Molecular mass of compound [kg/mol]. """ molecularmass
