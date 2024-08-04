##############################################################################
# TRANSPORT
##############################################################################

using CairoMakie
using DifferentialEquations: ODEProblem, Tsit5
using DifferentialEquations: solve
using Distributions: truncated, Normal
using DocStringExtensions: TYPEDFIELDS
using Ipopt
using ModelingToolkit
using Polynomials
using Printf
using Random
using Statistics: mean
using Trapz: trapz
import JuMP

##############################################################################
# CONSTANT AND CONFIGURATION
##############################################################################

##############################################################################
# STRUCTURE
##############################################################################

include("transport/dimensionless.jl")
include("transport/heat-transfer-coefficient.jl")
include("transport/property-models.jl")
include("transport/granular.jl")

##############################################################################
# EOF
##############################################################################