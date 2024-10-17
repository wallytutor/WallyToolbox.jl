# -*- coding: utf-8 -*-

export head, tail, body
export defaultvalue
export tuplefy
export redirect_to_files
export test_exhaustive

##############################################################################
# Haskell-like array slicing
##############################################################################

"""
    head(z)

Access view of array head. See also [`tail`](@ref) and [`body`](@ref).

```jldoctest
julia> head(1:4)
1:3

julia> head([1, 2, 3, 4])
3-element view(::Vector{Int64}, 1:3) with eltype Int64:
 1
 2
 3
```
"""
head(z) = @view z[1:end-1]

"""
    tail(z)

Access view of array tail. See also [`head`](@ref) and [`body`](@ref).

```jldoctest
julia> tail([1, 2, 3, 4])
3-element view(::Vector{Int64}, 2:4) with eltype Int64:
 2
 3
 4
julia> tail(1:4)
2:4
```
"""
tail(z) = @view z[2:end-0]

"""
    body(z)

Access view of array body. See also  [`head`](@ref) and [`tail`](@ref).

```jldoctest
julia> body([1, 2, 3, 4])
2-element view(::Vector{Int64}, 2:3) with eltype Int64:
 2
 3
julia> body(1:4)
2:3
```
"""
body(z) = @view z[2:end-1]

##############################################################################
# Others
##############################################################################

"Syntax sugar for handling a possibly *nothing* value."
defaultvalue(p, q) = isnothing(p) ? q : p

"Syntax sugar for converting a dictionary into a named tuple."
tuplefy(d) = NamedTuple{Tuple(keys(d))}(values(d))

# TODO document these or deprecate?
in_range_cc(x, lims) = lims[1] <= x <= lims[2]
in_range_co(x, lims) = lims[1] <= x <  lims[2]
in_range_oo(x, lims) = lims[1] <  x <  lims[2]

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
        @error(join(messages, "\n"))
        throw(ArgumentError("Check previous warnings"))
    end
end
