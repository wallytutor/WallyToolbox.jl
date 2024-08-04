##############################################################################
# THERMOCHEMISTRY
##############################################################################

import Base: +
import Base: *
import Base: String

import DataFrames
import YAML

using CairoMakie
using Distributions: Weibull, cdf, scale, mean
using DocStringExtensions: TYPEDFIELDS
using Polynomials: AbstractPolynomial
using Printf
using Polynomials: Polynomial, LaurentPolynomial, integrate
using Roots
using SteamTables: SpecificV

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
include("thermochemistry/combustion.jl")
include("thermochemistry/thermodata.jl")

##############################################################################
# EOF
##############################################################################