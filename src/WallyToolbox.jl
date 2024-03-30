# -*- coding: utf-8 -*-
module WallyToolbox

function __init__()
    # Make other modules available, that's all!
    @info "Activating WallyToolbox at $(@__DIR__)"
    push!(LOAD_PATH, @__DIR__)
end

using Reexport

include(joinpath(@__DIR__, "DryConstants.jl"))
@reexport using .DryConstants

include(joinpath(@__DIR__, "DryUtilities.jl"))
@reexport using .DryUtilities

end # (module WallyToolbox)