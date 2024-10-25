# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField


NUM_METHOD_GRAD = SU2ConfigField(
    "NUM_METHOD_GRAD", "GREEN_GAUSS", 
    "Numerical method for spatial gradients.",
    options=("GREEN_GAUSS", "WEIGHTED_LEAST_SQUARES"))

# % Numerical method for spatial gradients to be used for MUSCL reconstruction
# % Options are (GREEN_GAUSS, WEIGHTED_LEAST_SQUARES, LEAST_SQUARES). Default value is
# % NONE and the method specified in NUM_METHOD_GRAD is used.
# NUM_METHOD_GRAD_RECON = LEAST_SQUARES

CFL_NUMBER = SU2ConfigField(
    "CFL_NUMBER", 15.0, 
    "CFL number (initial value for the adaptive CFL number).")

CFL_ADAPT = SU2ConfigField(
    "CFL_ADAPT", "NO", "Adaptive CFL number.",
    options=("NO", "YES"))

CFL_ADAPT_PARAM = SU2ConfigField(
    "CFL_ADAPT_PARAM", (0.1, 2.0, 10.0, 1e10, 0.00), 
    "Parameters of the adaptive CFL number.",
    detail=dedent("""\
    (factor-down, factor-up, CFL min value, CFL max value,
     acceptable linear solver convergence)

    Local CFL increases by factor-up until max if the solution rate of change is not
    limited, and acceptable linear convergence is achieved. It is reduced if rate is
    limited, or if there is not enough linear convergence, or if the nonlinear residuals
    are stagnant and oscillatory. It is reset back to min when linear solvers diverge,
    or if nonlinear residuals increase too much.
    """))

# % Maximum Delta Time in local time stepping simulations
# MAX_DELTA_TIME= 1E6

RK_ALPHA_COEFF = SU2ConfigField(
    "RK_ALPHA_COEFF", (0.66667, 0.66667, 1.000000), 
    "Runge-Kutta alpha coefficients")

# % Objective function in gradient evaluation   (DRAG, LIFT, SIDEFORCE, MOMENT_X,
# %                                             MOMENT_Y, MOMENT_Z, EFFICIENCY, BUFFET,
# %                                             EQUIVALENT_AREA, NEARFIELD_PRESSURE,
# %                                             FORCE_X, FORCE_Y, FORCE_Z, THRUST,
# %                                             TORQUE, TOTAL_HEATFLUX,
# %                                             MAXIMUM_HEATFLUX, INVERSE_DESIGN_PRESSURE,
# %                                             INVERSE_DESIGN_HEATFLUX, SURFACE_TOTAL_PRESSURE,
# %                                             SURFACE_MASSFLOW, SURFACE_STATIC_PRESSURE, SURFACE_MACH)
# % For a weighted sum of objectives: separate by commas, add OBJECTIVE_WEIGHT and MARKER_MONITORING in matching order.
# OBJECTIVE_FUNCTION= DRAG
# %
# % List of weighting values when using more than one OBJECTIVE_FUNCTION. Separate by commas and match with MARKER_MONITORING.
# OBJECTIVE_WEIGHT = 1.0
