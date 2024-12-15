##############################################################################
# THERMOCHEMISTRY
##############################################################################

import Base: +
import Base: *
import Base: String
import Base: showerror

import DataFrames
import YAML

using CairoMakie
using Distributions: Weibull
using Distributions: cdf, scale, mean, params
using DocStringExtensions: TYPEDFIELDS
using ModelingToolkit
using Polynomials: AbstractPolynomial
using Printf
using Polynomials: Polynomial, LaurentPolynomial, integrate
using Roots
using SteamTables: SpecificV
using Symbolics

##############################################################################
# CONSTANT AND CONFIGURATION
##############################################################################

const DEFAULTTHERMODATA = joinpath(WALLYTOOLBOXDATA, "thermodata.yaml")

THERMO_WARNINGS = true

function disable_thermo_warnings()
    global THERMO_WARNINGS = false
    return nothing
end

function enable_thermo_warnings()
    global THERMO_WARNINGS = true
    return nothing
end

##############################################################################
# STRUCTURE
##############################################################################

include("thermochemistry/chemistry.jl")
include("thermochemistry/mixture.jl")
include("thermochemistry/kinetics.jl")
include("thermochemistry/combustion.jl")
include("thermochemistry/thermodata.jl")
include("thermochemistry/acausal.jl")

##############################################################################
# EOF
##############################################################################