# -*- coding: utf-8 -*-
module WallyToolbox

const WALLYTOOLBOXPATH = @__DIR__

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

# Direct includes.
# include("jl/main/abstract.jl")
# include("jl/main/utilities.jl")

# Sub-modules.
include("jl/main/documents.jl")
include("jl/main/notebook.jl")

end # (module WallyToolbox)