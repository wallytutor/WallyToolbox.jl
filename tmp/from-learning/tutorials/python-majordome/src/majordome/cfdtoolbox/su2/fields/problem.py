# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField

SOLVER = SU2ConfigField(
    "SOLVER", "EULER", "Solver type", 
    options=(
        "EULER",
        "NAVIER_STOKES",
        "RANS",
        "INC_EULER",
        "INC_NAVIER_STOKES",
        "INC_RANS",
        "NEMO_EULER",
        "NEMO_NAVIER_STOKES",
        "FEM_EULER",
        "FEM_NAVIER_STOKES",
        "FEM_RANS",
        "FEM_LES",
        "HEAT_EQUATION_FVM",
        "ELASTICITY"
    ))

# % Specify turbulence model (NONE, SA, SA_NEG, SST, SA_E, SA_COMP, SA_E_COMP, SST_SUST)
# KIND_TURB_MODEL= NONE

# % Transition model (NONE, BC)
# KIND_TRANS_MODEL= NONE

# % Specify subgrid scale model(NONE, IMPLICIT_LES, SMAGORINSKY, WALE, VREMAN)
# KIND_SGS_MODEL= NONE

# % Specify the verification solution(NO_VERIFICATION_SOLUTION, INVISCID_VORTEX,
# %                                   RINGLEB, NS_UNIT_QUAD, TAYLOR_GREEN_VORTEX,
# %                                   MMS_NS_UNIT_QUAD, MMS_NS_UNIT_QUAD_WALL_BC,
# %                                   MMS_NS_TWO_HALF_CIRCLES, MMS_NS_TWO_HALF_SPHERES,
# %                                   MMS_INC_EULER, MMS_INC_NS, INC_TAYLOR_GREEN_VORTEX,
# %                                   USER_DEFINED_SOLUTION)
# KIND_VERIFICATION_SOLUTION= NO_VERIFICATION_SOLUTION

# Defaults to DISCRETE_ADJOINT for the SU2_*_AD codes, and to DIRECT otherwise.
MATH_PROBLEM = SU2ConfigField(
    "MATH_PROBLEM", "DIRECT", "Mathematical problem",
    options=("DIRECT", "CONTINUOUS_ADJOINT", "DISCRETE_ADJOINT"))

# % Axisymmetric simulation, only compressible flows (NO, YES)
# AXISYMMETRIC= NO

RESTART_SOL = SU2ConfigField(
    "RESTART_SOL", "NO", "Restart solution",
    options=("NO", "YES"))

# % Discard the data storaged in the solution and geometry files
# % e.g. AOA, dCL/dAoA, dCD/dCL, iter, etc.
# % Note that AoA in the solution and geometry files is critical
# % to aero design using AoA as a variable. (NO, YES)
# DISCARD_INFILES= NO

# % System of measurements (SI, US)
# % International system of units (SI): ( meters, kilograms, Kelvins,
# %                                       Newtons = kg m/s^2, Pascals = N/m^2,
# %                                       Density = kg/m^3, Speed = m/s,
# %                                       Equiv. Area = m^2 )
# % United States customary units (US): ( inches, slug, Rankines, lbf = slug ft/s^2,
# %                                       psf = lbf/ft^2, Density = slug/ft^3,
# %                                       Speed = ft/s, Equiv. Area = ft^2 )
# SYSTEM_MEASUREMENTS= SI

# % List of config files for each zone in a multizone setup with SOLVER=MULTIPHYSICS
# % Order here has to match the order in the meshfile if just one is used.
# CONFIG_LIST= (configA.cfg, configB.cfg, ...)
