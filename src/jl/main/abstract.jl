# -*- coding: utf-8 -*-

##############################################################################
# PURE ABSTRACT
##############################################################################

abstract type AbstractMatter end
abstract type AbstractTransportModel end

##############################################################################
# MATERIALS
##############################################################################

abstract type AbstractMaterial                <: AbstractMatter end
abstract type AbstractLiquidMaterial          <: AbstractMaterial end
abstract type AbstractSolidMaterial           <: AbstractMaterial end
abstract type AbstractGasMaterial             <: AbstractMaterial end
abstract type AbstractSolidMineralPhase       <: AbstractSolidMaterial end

##############################################################################
# DIMENSIONLESS GROUPS
##############################################################################

abstract type AbstractDimensionlessGroup      <: AbstractTransportModel end
abstract type AbstractReynoldsNumber          <: AbstractDimensionlessGroup end
abstract type AbstractNusseltNumber           <: AbstractDimensionlessGroup end
abstract type AbstractPrandtlNumber           <: AbstractDimensionlessGroup end
abstract type AbstractReynoldsPipeFlow        <: AbstractReynoldsNumber end
abstract type AbstractNusseltPipeFlow         <: AbstractNusseltNumber end

##############################################################################
# TRANSPORT COEFFICIENTS
##############################################################################

abstract type AbstractTransportCoefficient    <: AbstractTransportModel end
abstract type AbstractHtc                     <: AbstractTransportCoefficient end
abstract type AbstractHtcPipeFlow             <: AbstractHtc end

##############################################################################
# PROPERTY MODELS
##############################################################################

abstract type AbstractTransportProperty       <: AbstractTransportModel end
abstract type AbstractFluidViscosity          <: AbstractTransportProperty end
abstract type AbstractHeatConductivity        <: AbstractTransportProperty end
abstract type AbstractViscosityTemperatureDep <: AbstractFluidViscosity end
abstract type AbstractHeatCondTemperatureDep  <: AbstractHeatConductivity end
abstract type AbstractMaxwellEffHeatCond      <: AbstractHeatCondTemperatureDep end

##############################################################################
# LEGACY (ENTERING)
##############################################################################

# "Base type for linear algebra problems."
# abstract type AbstractMatrixProblem end
# "Base type for physical models."
# abstract type AbstractPhysicalModel end
# "Base type for thermodynamic models."
# abstract type AbstractGasThermo end
# "Base type for thermodynamic models."
# abstract type AbstractSolidThermo end
# "Base type for transport models."
# abstract type AbstractSolidTransport end
# "Base type for simplified mixture substances."
# abstract type AbstractMixtureSubstance end
# "Base type for simplified mixture phases."
# abstract type AbstractMixturePhase end
# "Base type for coded kinetics mechanisms."
# abstract type AbstractKineticsMechanism end
# "Base type of one-dimensional grids."
# abstract type AbstractGrid1D end
# "Base type for diffusion (heat, species, ...) models."
# abstract type AbstractDiffusionModel1D <: AbstractPhysicalModel end
# "Base type for (nonlinear) iterative solvers."
# abstract type AbstractIterativeSolver end
# "Base type for storing simulation solution."
# abstract type AbstractSolutionStorage end

##############################################################################
# EOF
##############################################################################