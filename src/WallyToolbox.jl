# -*- coding: utf-8 -*-
module WallyToolbox

function __init__()
    # Make other modules available, that's all!
    verbose = parse(Int64, get(ENV, "WALLYTOOLBOX_VERBOSITY", "0"))
    verbose > 0 && @info("Activating WallyToolbox at $(@__DIR__)")
    push!(LOAD_PATH, @__DIR__)
end

using Reexport

# include(joinpath(@__DIR__, "DryConstants.jl"))
# @reexport using .DryConstants

end # (module WallyToolbox)