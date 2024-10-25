# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField

ITER = SU2ConfigField(
    "ITER", 1, "Number of iterations for single-zone problems")

# % Maximum number of inner iterations
# INNER_ITER= 9999
# %
# % Maximum number of outer iterations (only for multizone problems)
# OUTER_ITER= 1
# %
# % Maximum number of time iterations
# TIME_ITER= 1

CONV_FIELD = SU2ConfigField(
    "CONV_FIELD", "DRAG", "Convergence field (to-do: document options).")

CONV_RESIDUAL_MINVAL = SU2ConfigField(
    "CONV_RESIDUAL_MINVAL", -8,
    "Min value of the residual (log10 of the residual).")

CONV_STARTITER = SU2ConfigField(
    "CONV_STARTITER", 10,
    "Start convergence criteria at iteration number.")

CONV_CAUCHY_ELEMS = SU2ConfigField(
    "CONV_CAUCHY_ELEMS", 100,
    "Number of elements to apply the criteria.")

CONV_CAUCHY_EPS = SU2ConfigField(
    "CONV_CAUCHY_EPS", 1.0E-10,
    "Epsilon to control the series convergence.")

# % Iteration number to begin unsteady restarts
# RESTART_ITER= 0

# % Time convergence monitoring
# WINDOW_CAUCHY_CRIT = YES

# % List of time convergence fields
# CONV_WINDOW_FIELD = (TAVG_DRAG, TAVG_LIFT)

# % Time Convergence Monitoring starts at Iteration WINDOW_START_ITER + CONV_WINDOW_STARTITER
# CONV_WINDOW_STARTITER = 0

# % Epsilon to control the series convergence
# CONV_WINDOW_CAUCHY_EPS = 1E-3

# % Number of elements to apply the criteria
# CONV_WINDOW_CAUCHY_ELEMS = 10
