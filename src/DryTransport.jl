# -*- coding: utf-8 -*-
module DryTransport

using DryConstants
using DryUtilities: test_exhaustive

# TODO move these to DryAbstract at some point?
abstract type AbstractReynoldsNumber end
abstract type AbstractNusseltNumber end
abstract type AbstractPrandtlNumber end
abstract type AbstractHeatTransferCoefficient end

abstract type AbstractReynoldsPipeFlow <: AbstractReynoldsNumber end
abstract type AbstractNusseltPipeFlow <: AbstractNusseltNumber end
abstract type AbstractHtcPipeFlow <: AbstractHeatTransferCoefficient end

include("jl/transport/dimensionless.jl")
include("jl/transport/heat-transfer-coefficient.jl")

end # (DryTransport)
