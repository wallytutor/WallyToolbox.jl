# -*- coding: utf-8 -*-

##############################################################################
# MATERIALS
##############################################################################

abstract type AbstractMaterial end

abstract type AbstractLiquidMaterial <: AbstractMaterial end
abstract type AbstractSolidMaterial  <: AbstractMaterial end
abstract type AbstractGasMaterial    <: AbstractMaterial end

abstract type AbstractSolidMineralPhase <: AbstractSolidMaterial end

##############################################################################
# DIMENSIONLESS GROUPS
##############################################################################

abstract type AbstractDimensionlessGroup end

abstract type AbstractReynoldsNumber <: AbstractDimensionlessGroup end
abstract type AbstractNusseltNumber  <: AbstractDimensionlessGroup end
abstract type AbstractPrandtlNumber  <: AbstractDimensionlessGroup end

abstract type AbstractReynoldsPipeFlow <: AbstractReynoldsNumber end
abstract type AbstractNusseltPipeFlow  <: AbstractNusseltNumber end

##############################################################################
# TRANSPORT COEFFICIENTS
##############################################################################

abstract type AbstractTransportCoefficient end

abstract type AbstractHtc <: AbstractTransportCoefficient end

abstract type AbstractHtcPipeFlow <: AbstractHtc end

##############################################################################
# PROPERTY MODELS
##############################################################################

abstract type AbstractHeatConductivity end

abstract type AbstractMaxwellEffHeatCond     <: AbstractHeatConductivity end
abstract type AbstractHeatCondTemperatureDep <: AbstractHeatConductivity end

##############################################################################
# LEGACY (ENTERING)
##############################################################################

# "Base type for linear algebra problems."
# abstract type AbstractMatrixProblem end

# "Base type for physical models."
# abstract type AbstractPhysicalModel end

# "Base type for transport models."
# abstract type AbstractTransportModel end

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