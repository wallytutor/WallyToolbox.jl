# -*- coding: utf-8 -*-
module DryTooling

begin # module DryTooling (core)
    using CairoMakie
    using CommonSolve
    using DocStringExtensions: TYPEDFIELDS
    using LinearAlgebra
    using Polynomials
    using Roots
    using YAML
end # module DryTooling (core)

# XXX
include("tmp.jl")


module FiniteVolumes
    using CairoMakie
    using CommonSolve
    using CommonSolve: solve
    using DocStringExtensions: TYPEDFIELDS
    using Trapz: trapz
    using DryTooling
    using DryTooling.Simulation
    # TODO this will migrate!
    using DryTooling: Temperature1DModelStorage
    using DryTooling: interfaceconductivity1D

    include("FiniteVolumes/grid-generation.jl")
    include("FiniteVolumes/heat-conduction.jl")
    include("FiniteVolumes/diffusion-in-solids.jl")
end # module FiniteVolumes

using DryTooling.Simulation
using DryTooling.FiniteVolumes
using DryTooling.Thermodynamics
using DryTooling.FluidModels
using DryTooling.Granular
using DryTooling.Kinetics
using DryTooling.PlugFlow

end # module DryTooling
