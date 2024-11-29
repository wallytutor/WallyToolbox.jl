# -*- coding: utf-8 -*-
module WallyToolbox

using Reexport

"Path to supporting modules annex to WallyToolbox."
const WALLYTOOLBOXPATH = abspath(joinpath(@__DIR__, "wallymodules"))

"Path to data files used by WallyToolbox."
const WALLYTOOLBOXDATA = abspath(joinpath(@__DIR__, "..", "data"))

"Path to Python modules from legacy Majordome package."
const MAJORDOMEPATH = abspath(joinpath(@__DIR__, "py"))

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
    return nothing
end

# If I do this, Jupyter stops working.
# using PythonCall
# function source_python()
#     sys = pyimport("sys")
#     sys.path.insert(0, MAJORDOMEPATH)
# end

# General internals.
include("wallytoolbox/internals/abstract.jl")
include("wallytoolbox/internals/Documents.jl")
include("wallytoolbox/internals/Notebook.jl")

# Primary direct includes.
include("wallytoolbox/constants.jl")
include("wallytoolbox/utilities.jl")
include("wallytoolbox/unstable.jl")

# Dependent direct includes.
include("wallytoolbox/datascience.jl")
include("wallytoolbox/thermochemistry.jl")
include("wallytoolbox/transport.jl")
include("wallytoolbox/flowsheet.jl")

@reexport using WallyToolbox.Notebook

end # (module WallyToolbox)