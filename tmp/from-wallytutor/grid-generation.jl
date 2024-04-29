# -*- coding: utf-8 -*-
export UserDefinedGrid1D
export equidistantcellsgrid1D
export geometriccellsgrid1D

"""
A minimal 1D grid with cells centers and walls.

Provides a very simple interface for the 1D grids used in standard finite volume
solvers provided in the package. Constructor accepts a vector of coordinates and
compute walls at mid-points between cells centers. First and last cells are over
the boundaries and the models must consider this in the implementation.

$(TYPEDFIELDS)
"""
struct UserDefinedGrid1D <: AbstractGrid1D
    "Number of cells in domain, size of solution memory per variable."
    N::Int64

    "Radial coordinates of cells centers."
    r::Vector{Float64}

    "Radial coordinates of cells walls."
    w::Vector{Float64}

    function UserDefinedGrid1D(r::Vector{Float64})
        w = vcat(first(r), 0.5*(tail(r) + head(r)), last(r))
        return new(length(r), r, w)
    end
end

"""
    equidistantcellsgrid(R::Float64, N::Int64)::UserDefinedGrid1D

Helper for creating a `UserDefinedGrid1D` with all nodes equidistant.
"""
function equidistantcellsgrid1D(R::Float64, N::Int64)::UserDefinedGrid1D
    return UserDefinedGrid1D(collect(0.0:R/N:R))
end

"""
    geometriccellsgrid(R::Float64, N::Int64)::UserDefinedGrid1D

Helper for creating a `UserDefinedGrid1D` with all nodes equidistant.
"""
function geometriccellsgrid1D(R::Float64, N::Int64)::UserDefinedGrid1D
    return UserDefinedGrid1D(@. ((R+1)^(1/N))^(0:N)-1.0)
end

# TODO: this is broken after solution because of the way processed innersteps
# are counted. A better solution (using mem.t ?!?!?) is to be found but since
# this has no impact for now (it works in advance! as expected) this will be
# done when solver reach a better maturity level.
function DryTooling.Simulation.timepoints(m::AbstractDiffusionModel1D)
    "Reconstruct time axis of integrated diffusion model."
    nsteps = length(m.res[].innersteps) - 1
    tend = nsteps * m.τ[]
    return 0.0:m.τ[]:tend
    # return m.mem[].t
end
