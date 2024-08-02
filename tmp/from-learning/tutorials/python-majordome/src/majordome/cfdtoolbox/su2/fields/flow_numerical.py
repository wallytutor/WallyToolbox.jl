# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField

CONV_NUM_METHOD_FLOW = SU2ConfigField(
    "CONV_NUM_METHOD_FLOW", "ROE",
    "Convective numerical method.",
    options=(
        "JST",
        "JST_KE",
        "JST_MAT",
        "LAX-FRIEDRICH",
        "CUSP",
        "ROE",
        "AUSM",
        "AUSMPLUSUP",
        "AUSMPLUSUP2",
        "AUSMPWPLUS",
        "HLLC",
        "TURKEL_PREC",
        "SW",
        "MSW",
        "FDS",
        "SLAU",
        "SLAU2",
        "L2ROE",
        "LMROE",
    ))

# % Roe Low Dissipation function for Hybrid RANS/LES simulations (FD, NTS, NTS_DUCROS)
# ROE_LOW_DISSIPATION= FD
# %
# % Post-reconstruction correction for low Mach number flows (NO, YES)
# LOW_MACH_CORR= NO
# %
# % Roe-Turkel preconditioning for low Mach number flows (NO, YES)
# LOW_MACH_PREC= NO
# %
# % Use numerically computed Jacobians for AUSM+up(2) and SLAU(2)
# % Slower per iteration but potentialy more stable and capable of higher CFL
# USE_ACCURATE_FLUX_JACOBIANS= NO
# %
# % Use the vectorized version of the selected numerical method (available for JST family and Roe).
# % SU2 should be compiled for an AVX or AVX512 architecture for best performance.
# USE_VECTORIZATION= NO
# %
# % Entropy fix coefficient (0.0 implies no entropy fixing, 1.0 implies scalar
# %                          artificial dissipation)
# ENTROPY_FIX_COEFF= 0.0
# %
# % Higher values than 1 (3 to 4) make the global Jacobian of central schemes (compressible flow
# % only) more diagonal dominant (but mathematically incorrect) so that higher CFL can be used.
# CENTRAL_JACOBIAN_FIX_FACTOR= 4.0

TIME_DISCRE_FLOW = SU2ConfigField(
    "TIME_DISCRE_FLOW", "EULER_IMPLICIT", "Time discretization.",
    options=("RUNGE-KUTTA_EXPLICIT", "EULER_IMPLICIT", "EULER_EXPLICIT"))

# % Use a Newton-Krylov method on the flow equations, see TestCases/rans/oneram6/turb_ONERAM6_nk.cfg
# % For multizone discrete adjoint it will use FGMRES on inner iterations with restart frequency
# % equal to "QUASI_NEWTON_NUM_SAMPLES".
# NEWTON_KRYLOV= NO
