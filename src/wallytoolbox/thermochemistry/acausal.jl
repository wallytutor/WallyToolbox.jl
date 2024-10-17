##############################################################################
# ACAUSAL
##############################################################################

export AlgebraicModel
export structural_solve
export perfect_gas_constants
export perfect_gas_model

##############################################################################
# EXCEPTIONS
##############################################################################

struct UnsolvableAlgebraicModel <: Exception
    msg::String

    function UnsolvableAlgebraicModel(vars, pars)
        svars, spars = join(vars, ", "), join(pars, ", ")

        return new(
            "Unable to solve algebraic model containing [$(svars)] " *
            "by providing only [$(spars)]! Please, revise the " *
            "setup of the system!"
        )
    end
end

function Base.showerror(io::IO, err::UnsolvableAlgebraicModel)
   print(io, "UnsolvableAlgebraicModel: ")
   print(io, err.msg)
end

##############################################################################
# ALGEBRAIC MODEL
##############################################################################

struct AlgebraicModel
    vars::NamedTuple
    eqns::Vector{Equation}
    pars::Dict{Symbol, Float64}

    function AlgebraicModel(vars, eqns, pars)
        vars = Dict(map(v->(Symbol(v), v), vars))
        return new(tuplefy(vars), eqns, pars)
    end
end

function structural_solve(obj::AlgebraicModel)
    # Clean-up symbols that were provided by user.
    eqns = replacement_solve(obj)
    
    # Cannot solve if has parameters but DoF are not respected...
    if has_pars(obj) && has_dofs(obj, eqns)
        throw(UnsolvableAlgebraicModel(obj.vars, obj.pars))
    end
    
    # XXX: can we eliminate this, the system is already solved here...
    @mtkbuild ns = NonlinearSystem(eqns, [values(obj.vars)...], [])
    sol = solve(NonlinearProblem(ns, [], []))

    # Get names (LHS of equations) to retrieve solution.
    solved_for = map(e->e.lhs, observed(ns))
    
    # Full-specification is found through parameters and variables.
    pars = tuplefy(obj.pars)
    vars = NamedTuple(map(n->(Symbol(n), sol[n]), solved_for))
    return merge(pars, vars)
end

function replacement_solve(obj::AlgebraicModel)
    # Retrieve names provided in object `pars` (parameters).
    subs = map(v->(v, get(obj.pars, Symbol(v), v)), values(obj.vars))

    # Replace at once all identified symbols for solving.
    return substitute(obj.eqns, Dict(subs))
end

function has_pars(obj::AlgebraicModel)
    return length(obj.pars) > 0
end

function has_dofs(obj::AlgebraicModel, eqns)
    return length(obj.vars) - length(obj.pars) != length(eqns)
end

##############################################################################
# APPLICATIONS
##############################################################################

function perfect_gas_constants(; pars...)
    vars = @variables begin
        k,  [bounds = (1, Inf)]
        R,  [bounds = (0, Inf)]
        cp, [bounds = (0, Inf)]
        cv, [bounds = (0, Inf)]
    end
    
    eqns = [
        0 ~ cp - k * cv,
        0 ~ cv - R / (k - 1)
    ]
    
    return AlgebraicModel(vars, eqns, pars)
end

function perfect_gas_model(; pars...)
    model = perfect_gas_constants(;)

    vars = @variables begin
        p,  [bounds = (0, Inf)]
        ρ,  [bounds = (0, Inf)]
        T,  [bounds = (0, Inf)]
        h,  [bounds = (0, Inf)]
        s,  [bounds = (0, Inf)]
    end

    R = model.vars.R
    cp = model.vars.cp
    
    vars = [vars..., values(model.vars)...]
    eqns = [
        0 ~ p - ρ * R * T,
        0 ~ h - cp * T,
        0 ~ s - cp * log(T) + R * log(p),
        model.eqns...
    ]

    return AlgebraicModel(vars, eqns, pars)	
end

##############################################################################
# EOF
##############################################################################