# -*- coding: utf-8 -*-
module WallyToolbox

using Reexport

# const WALLYTOOLBOXPATH = @__DIR__
const WALLYTOOLBOXPATH = joinpath(@__DIR__, "modules")
const WALLYTOOLBOXDATA = joinpath(@__DIR__, "data")

function __init__()
    # Make other modules available, that's all!
    verbose = parse(Int64, get(ENV, "WALLYTOOLBOX_VERBOSITY", "0"))
    verbose > 0 && @info("Activating WallyToolbox at $(@__DIR__)")

    # XXX: is it really worth it? Use case: from other modules!
    if WALLYTOOLBOXPATH in LOAD_PATH
        verbose > 0 && @info("WallyToolbox already setup...")
        return
    end

    push!(LOAD_PATH, WALLYTOOLBOXPATH)
end

# General internals.
include("internals/abstract.jl")
include("internals/Documents.jl")
include("internals/Notebook.jl")

# Primary direct includes.
include("constants.jl")
include("utilities.jl")

# Dependent direct includes.
include("thermochemistry.jl")
include("transport.jl")

@reexport using WallyToolbox.Notebook

end # (module WallyToolbox)