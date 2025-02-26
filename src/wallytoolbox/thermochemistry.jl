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
# STRUCTURE
##############################################################################

include("thermochemistry/chemistry.jl")
include("thermochemistry/mixture.jl")
include("thermochemistry/kinetics.jl")
include("thermochemistry/combustion.jl")
include("thermochemistry/acausal.jl")

##############################################################################
# EOF
##############################################################################