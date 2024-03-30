# -*- coding: utf-8 -*-
module DryAbstract

"Base type for linear algebra problems."
abstract type AbstractMatrixProblem end
export AbstractMatrixProblem

"Base type for physical models."
abstract type AbstractPhysicalModel end
export AbstractPhysicalModel

"Base type for transport models."
abstract type AbstractTransportModel end
export AbstractTransportModel

"Base type for thermodynamic models."
abstract type AbstractGasThermo end
export AbstractGasThermo

"Base type for thermodynamic models."
abstract type AbstractSolidThermo end
export AbstractSolidThermo

"Base type for transport models."
abstract type AbstractSolidTransport end
export AbstractSolidTransport

"Base type for solid materials."
abstract type AbstractSolidMaterial end
export AbstractSolidMaterial

"Base type for simplified mixture substances."
abstract type AbstractMixtureSubstance end
export AbstractMixtureSubstance

"Base type for simplified mixture phases."
abstract type AbstractMixturePhase end
export AbstractMixturePhase

"Base type for coded kinetics mechanisms."
abstract type AbstractKineticsMechanism end
export AbstractKineticsMechanism

"Base type of one-dimensional grids."
abstract type AbstractGrid1D end
export AbstractGrid1D

"Base type for diffusion (heat, species, ...) models."
abstract type AbstractDiffusionModel1D <: AbstractPhysicalModel end
export  AbstractDiffusionModel1D

"Base type for (nonlinear) iterative solvers."
abstract type AbstractIterativeSolver end
export AbstractIterativeSolver

"Base type for storing simulation solution."
abstract type AbstractSolutionStorage end
export AbstractSolutionStorage

end # module DryAbstract