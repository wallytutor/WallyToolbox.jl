# -*- coding: utf-8 -*-
module DryTransport

using DocStringExtensions: TYPEDFIELDS
using Polynomials

using WallyToolbox: AbstractPrandtlNumber
using WallyToolbox: AbstractReynoldsPipeFlow
using WallyToolbox: AbstractNusseltPipeFlow
using WallyToolbox: AbstractHtcPipeFlow
using WallyToolbox: AbstractMaxwellEffHeatCond
using WallyToolbox: AbstractHeatCondTemperatureDep
using WallyToolbox

include("jl/transport/dimensionless.jl")
include("jl/transport/heat-transfer-coefficient.jl")
include("jl/transport/property-models.jl")

end # (DryTransport)
