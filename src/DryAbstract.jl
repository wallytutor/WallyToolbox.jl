# -*- coding: utf-8 -*-
module DryAbstract

"Base type for any material substance."
abstract type AbstractMaterial end

"Base type for liquid materials."
abstract type AbstractLiquidMaterial <: AbstractMaterial end

"Base type for solid materials."
abstract type AbstractSolidMaterial <: AbstractMaterial end

"Base type for gas materials."
abstract type AbstractGasMaterial <: AbstractMaterial end

"Base type for any mineral material."
abstract type AbstractSolidMineralPhase <: AbstractSolidMaterial end

"Base type for linear algebra problems."
abstract type AbstractMatrixProblem end

"Base type for physical models."
abstract type AbstractPhysicalModel end

"Base type for transport models."
abstract type AbstractTransportModel end

"Base type for thermodynamic models."
abstract type AbstractGasThermo end

"Base type for thermodynamic models."
abstract type AbstractSolidThermo end

"Base type for transport models."
abstract type AbstractSolidTransport end

"Base type for simplified mixture substances."
abstract type AbstractMixtureSubstance end

"Base type for simplified mixture phases."
abstract type AbstractMixturePhase end

"Base type for coded kinetics mechanisms."
abstract type AbstractKineticsMechanism end

"Base type of one-dimensional grids."
abstract type AbstractGrid1D end

"Base type for diffusion (heat, species, ...) models."
abstract type AbstractDiffusionModel1D <: AbstractPhysicalModel end

"Base type for (nonlinear) iterative solvers."
abstract type AbstractIterativeSolver end

"Base type for storing simulation solution."
abstract type AbstractSolutionStorage end

end # module DryAbstract