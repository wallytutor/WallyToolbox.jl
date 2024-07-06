# -*- coding: utf-8 -*-
module DryUtilities

using DryConstants: C_REF

##############################################################################
# Haskell-like array slicing
##############################################################################

export head, tail, body

"""
    head(z)

Access view of array head. See also [`tail`](@ref) and [`body`](@ref).
"""
head(z) = @view z[1:end-1]

"""
    tail(z)

Access view of array tail. See also [`head`](@ref) and [`body`](@ref).
"""
tail(z) = @view z[2:end-0]

"""
    body(z)

Access view of array body. See also  [`head`](@ref) and [`tail`](@ref).
"""
body(z) = @view z[2:end-1]

##############################################################################
# Rounding and axes
##############################################################################

"""
    closestpowerofx(
        v::Number;
        x::Number = 10,
        roundf::Function = ceil
    )::Int64

Compute the integer power of `x` closest to `v` using `roundf` as
rouding method. This might be useful for automatic setting more
reasonable limits to plot axis or similar applications. Changing
the rouding method through `roundf` is also possible.
"""
function closestpowerofx(
        v::Number;
        x::Number = 10,
        roundf::Function = ceil
    )::Int64
    rounder = x^floor(log(x, v))
    return convert(Int64, rounder * roundf(v / rounder))
end

"""
    axesunitscaler(x::Number)::Tuple{String, Int64}

Find scaling factor for multiples of 1000 units. Together with
`closestpowerofx` this can be used to produce better automatic
plot axes limits. The returned values provide the string for
modifying the axis label and the associated scaling factor.
"""
function axesunitscaler(x::Number)::Tuple{String, Int64}
    # Find the floor of log10 of number.
    m = convert(Int64, x |> log10 |> floor)

    # Get the order of magnitude number.
    n = div(m, 3)

    # Find scaling factor.
    p = 1000^(n)

    return (n == 0) ? ("", 1) : ("[×$(1000^n)]", p)
end

##############################################################################
# Discontinuous functions
##############################################################################

"""
    heaviside(t)

Provides a Heaviside function compatible with automatic differentiation.
This is a requirement for conceiving, *e.g.*, model predictive controls
with discontinuous functions under `ModelingToolkit`.
"""
heaviside(t) = @. 0.5 * (sign(t) + 1.0)

"""
    interval(x; a=-Inf, b=Inf)

Returns 1 if ``x ∈ (a, b)``, 1/2 for `` x = a || x = b``, or 0.
"""
interval(x; a=-Inf, b=Inf) = @. heaviside(x - a) - heaviside(x - b)

"""
    makestepwise1d(lo, hi, xc)

Creates an univariate function that is composed of two parts, the first
evaluated before a critical domain point `xc`, and the second above that
value. This is often required, for instance, for the evaluation of NASA
polynomials for thermodynamic properties. If `differentiable`, then the
returned function is compatible with symbolic argument as required when
using package `ModelingToolkit`, etc.
"""
function makestepwise1d(lo, hi, xc; differentiable = true)
    if differentiable
        f = @. x -> lo(x) * interval(x, b=xc) + hi(x) * interval(x, a=xc)
    else
        f = @. x -> (x < xc) ? lo(x) : hi(x)
    end
    return f
end

##############################################################################
# Residuals
##############################################################################

"Maximum relative change in a solution array."
function maxrelativechange(x::Vector{Float64}, Δx::Vector{Float64})::Float64
    return maximum(abs.(Δx ./ x))
end

"Maximum absolute change in a solution array."
function maxabsolutechange(x::Vector{Float64}, Δx::Vector{Float64})::Float64
    return maximum(abs.(Δx))
end

##############################################################################
# Unit conversion
##############################################################################

"Convert [Nm³/h] to [kg/h]."
nm3_h_to_kg_h(q, mw) = C_REF * mw  * q

"Convert [kg/h] to [Nm³/h]."
kg_h_to_nm3_h(ṁ, mw) = ṁ / (C_REF * mw)

##############################################################################
# Others
##############################################################################

"Syntax sugar for handling a possibly *nothing* value."
defaultvalue(p, q) = isnothing(p) ? q : p

"Helper function to redirect outputs to the right files."
function redirect_to_files(dofunc, outfile; errfile = nothing)
    errfile = defaultvalue(errfile, outfile)

    open(outfile, "w") do out
        open(errfile, "w") do err
            redirect_stdout(out) do
                redirect_stderr(err) do
                    dofunc()
                end
            end
        end
    end
end

"Run all assertions before throwing an error."
function test_exhaustive(tests)
    messages = []

    for (evaluation, message) in tests
        !evaluation && push!(messages, message)
    end
    
    if !isempty(messages)
        @error join(messages, "\n")
        throw(ArgumentError("Check previous warnings"))
    end
end

end # (module DryUtilities)