# -*- coding: utf-8 -*-
module OpenFOAM

###############################################################################
# Tools
###############################################################################

using Base: string
using DelimitedFiles
using DocStringExtensions
using LightXML
using NaturalSort
using Printf
using Statistics
using SumTypes

###############################################################################
# Exports
###############################################################################

export UniformParcelSize

export Velocity
export TabulatedDensity
export ConstantFlowRateProfile
export TableFlowRateProfile
export InjectionModel
export PatchInjection

export asint
export spherevolume
export spheremass
export parcels_per_second
export tabulate

###############################################################################
# Constant
###############################################################################

"Banner for all OpenFOAM files with right version."
const OPENFOAMBANNER = raw"""
/*--------------------------------*- C++ -*----------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     | Website:  https://openfoam.org
    \\  /    A nd           | Version:  11
     \\/     M anipulation  |
\*---------------------------------------------------------------------------*/
"""

###############################################################################
# Abstract
###############################################################################

"Abstract type for particle size distributions."
abstract type AbstractSizeDistribution end

"Abstract type for flow rate profile distributions."
abstract type AbstractFlowRateProfile end

"Abstract type for injection models."
abstract type AbstractInjectionModel end

###############################################################################
# Enumerations
###############################################################################

"Types of uniform parcel sizes."
@sum_type UniformParcelSize begin
    nParticle
    surfaceArea
    volume
end

###############################################################################
# Structures
###############################################################################

"Simple wraper velocity vector."
struct Velocity
    vx::Number
    vy::Number
    vz::Number
end

# TODO fixedValue, normal, RosinRammler
"Tabulated density size distribution."
struct TabulatedDensity <: AbstractSizeDistribution
    "TODO: clarify in OpenFOAM."
    Q::Number

    "Measurable."
    x::Vector{Number}

    "Probability density."
    y::Vector{Number}

    function TabulatedDensity(x, y; Q = 0)
        return new(Q, x, y)
    end
end

"Constant flow rate profile."
struct ConstantFlowRateProfile <: AbstractFlowRateProfile
    value::Number
end

"Table flow rate profile."
struct TableFlowRateProfile <: AbstractFlowRateProfile
    TableFlowRateProfile() = error("unimplemented")
end

"""
Represents a generic particle injection model.

Constraints imposed by OpenFOAM:

- `nParticle` makes `massFlowRate` and `massTotal` to be ignored.

- `massTotal` cannot be used in steady state simulations.

- if `flowRateProfile` is not found a constant `massFlowRate` profile
  is computed from the ratio of `massTotal` and `duration`.

To-do:

- Check if `parcelBasisType` from is applicable to derived types.

$(TYPEDFIELDS)
"""
struct InjectionModel
    "Particles mass flow rate if `nParticle` is not provided."
    massFlowRate::Number

    "Total mass to be injected if `nParticle` is not provided."
    massTotal::Number

    "Start of injection in seconds (base)."
    SOI::Number

    "Duration of injection in seconds (base)."
    duration::Number

    "Number of particles per parcel."
    nParticle::Number

    "Quantity that is constant in parcels (base)."
    uniformParcelSize::UniformParcelSize

    "Type of flow rate profile to apply."
    flowRateProfile::AbstractFlowRateProfile

    function InjectionModel(;
            massFlowRate = 0,
            massTotal = 0,
            SOI = 0,
            duration = 0,
            nParticle = 1,
            uniformParcelSize = UniformParcelSize'.volume,
            flowRateProfile = ConstantFlowRateProfile(1)
        )
        return new(massFlowRate, massTotal, SOI, duration, nParticle,
                   uniformParcelSize, flowRateProfile)
    end
end

"""
Represents a patch injection model.

$(TYPEDFIELDS)
"""
struct PatchInjection <: AbstractInjectionModel
    "Name to use in injection models list."
    name::String

    "Patch where injection is applied."
    patchName::String

    "Object pointing to general injection model."
    injectionModel::InjectionModel

    "Particles injection velocity vector."
    U0::Velocity

    "Number of parcels injected per second."
    parcelsPerSecond::Number

    "Particle size distribution."
    sizeDistribution::AbstractSizeDistribution

    function PatchInjection(;
            name,
            patchName,
            sizeDistribution,
            massFlowRate = 0,
            massTotal = 0,
            SOI = 0,
            duration = 0,
            nParticle = 1,
            uniformParcelSize = UniformParcelSize'.volume,
            flowRateProfile = ConstantFlowRateProfile(1),
            U0 = Velocity(0, 0, 0),
            parcelsPerSecond = 0
        )
        injectionModel = InjectionModel(;
            massFlowRate, massTotal, SOI, duration, nParticle,
            uniformParcelSize, flowRateProfile)

        return new(name, patchName, injectionModel, U0, 
                   parcelsPerSecond, sizeDistribution)
    end
end

###############################################################################
# Methods
###############################################################################

function Base.string(m::UniformParcelSize)
    @cases m begin
       nParticle   => "nParticle"
       surfaceArea => "surfaceArea"
       volume      => "volume"
   end
end

function Base.string(U::Velocity)
    return "($(U.vx) $(U.vy) $(U.vz))"
end

function Base.string(m::TabulatedDensity)
    table = split(tabulate(m.x, m.y), "\n")
    table = join(map(x->"\t\t\t$(x)", table), "\n")

    fmt = """
    sizeDistribution
    {
        type                tabulatedDensity;
        Q                   $(m.Q);

        distribution
        (
$(table)
        );
    }
        """
    return fmt
end

function Base.string(m::ConstantFlowRateProfile)
    return "constant $(m.value)"
end

function Base.string(m::InjectionModel)
    fmt = """
    massFlowRate        $(m.massFlowRate);
    massTotal           $(m.massTotal);
    SOI                 $(m.SOI);
    duration            $(m.duration);
    nParticle           $(m.nParticle);
    uniformParcelSize   $(string(m.uniformParcelSize));
    flowRateProfile     $(string(m.flowRateProfile));
    """
    return fmt
end

function Base.string(m::PatchInjection)
    inj = m.injectionModel

    fmt = """
    $(m.name)
    {
        type                patchInjection;
        patchName           $(m.patchName);

        U0                  $(string(m.U0));

        uniformParcelSize   $(string(inj.uniformParcelSize));
        flowRateProfile     $(string(inj.flowRateProfile));

        nParticle           $(inj.nParticle);
        parcelsPerSecond    $(m.parcelsPerSecond);
        massFlowRate        $(inj.massFlowRate);
        massTotal           $(inj.massTotal);

        SOI                 $(inj.SOI);
        duration            $(inj.duration);

        $(string(m.sizeDistribution))
    }
    """
    return fmt
end

###############################################################################
# Functions
###############################################################################

"Round and convert number to an integer."
asint(n) = convert(Int64, round(n; digits = 0))

"The volume of a sphere of diameter `diam`."
spherevolume(diam) = (4/3) * pi * (diam/2)^3

"The mass of a sphere of density `rho` and diameter `diam`."
spheremass(rhop, diam) = rhop * spherevolume(diam)

"""
    parcelstoinject2d(;
        mdot::Float64,
        rhop::Float64,
        diam::Float64,
        nParticle::Int64 = 1
    )

Computes the flow rate of parcels for a given mean particle size and number of
particles per parcels. This is inteded as a helper to create a `patchInjection`
element in the `injectionModels` of `cloudProperties` file.
"""
function parcels_per_second(;
        mdot::Float64,
        rhop::Float64,
        diam::Float64,
        nParticle::Int64 = 1
    )
    # XXX: maybe generalize to supply particle mass through interface later so
    # that other morphologies can be used. OpenFOAM does not explicit support
    # arbitrary particle geometries though.

    # Total number of particles per second corresponding to `mdot`.
    np = mdot / spheremass(rhop, diam)

    # Group `nd` particles in parcels of size `nParticles`.
    return asint(np / nParticle)
end

"Compose table entries in typical OpenFOAM format."
function tabulate(x, y)
    row(a, b) = "($(@sprintf("%.12e", a))  $(@sprintf("%.12e", b)))"
    return join(map(a->row(a...), zip(x, y)), "\n")
end

end # module OpenFOAM
