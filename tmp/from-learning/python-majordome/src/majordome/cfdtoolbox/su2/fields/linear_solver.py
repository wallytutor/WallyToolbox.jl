# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField

LINEAR_SOLVER = SU2ConfigField(
    "LINEAR_SOLVER", "FGMRES", 
    "Linear solver or smoother for implicit formulations.",
    options=("BCGSTAB", "FGMRES", "RESTARTED_FGMRES", "SMOOTHER",
             "CONJUGATE_GRADIENT (self-adjoint problems only)"))

# % Same for discrete adjoint (smoothers not supported), replaces LINEAR_SOLVER in SU2_*_AD codes.
# DISCADJ_LIN_SOLVER= FGMRES

LINEAR_SOLVER_PREC = SU2ConfigField(
    "LINEAR_SOLVER_PREC", "ILU", 
    "Preconditioner of the Krylov linear solver or type of smoother.",
    options=("ILU", "LU_SGS", "LINELET", "JACOBI"))
    
# % Same for discrete adjoint (JACOBI or ILU), replaces LINEAR_SOLVER_PREC in SU2_*_AD codes.
# DISCADJ_LIN_PREC= ILU
# %
# % Linear solver ILU preconditioner fill-in level (0 by default)
# LINEAR_SOLVER_ILU_FILL_IN= 0

LINEAR_SOLVER_ERROR = SU2ConfigField(
    "LINEAR_SOLVER_ERROR", 1.0e-06, 
    "Minimum error of the linear solver for implicit formulations.")

LINEAR_SOLVER_ITER = SU2ConfigField(
    "LINEAR_SOLVER_ITER", 5, 
    "Max number of iterations of the linear solver for the implicit formulation.")

# % Restart frequency for RESTARTED_FGMRES
# LINEAR_SOLVER_RESTART_FREQUENCY= 10
# %
# % Relaxation factor for smoother-type solvers (LINEAR_SOLVER= SMOOTHER)
# LINEAR_SOLVER_SMOOTHER_RELAXATION= 1.0
