# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField

# % Time domain simulation
# TIME_DOMAIN= NO

# % Unsteady simulation (NO, TIME_STEPPING, DUAL_TIME_STEPPING-1ST_ORDER,
# %                      DUAL_TIME_STEPPING-2ND_ORDER, HARMONIC_BALANCE)
# TIME_MARCHING= NO

# % Time Step for dual time stepping simulations (s) -- Only used when UNST_CFL_NUMBER = 0.0
# % For the DG-FEM solver it is used as a synchronization time when UNST_CFL_NUMBER != 0.0
# TIME_STEP= 0.0

# % Total Physical Time for dual time stepping simulations (s)
# MAX_TIME= 50.0

# % Unsteady Courant-Friedrichs-Lewy number of the finest grid
# UNST_CFL_NUMBER= 0.0

# % Windowed output time averaging
# % Time iteration to start the windowed time average in a direct run
# WINDOW_START_ITER = 500

# % Window used for reverse sweep and direct run. Options (SQUARE, HANN, HANN_SQUARE, BUMP) Square is default.
# WINDOW_FUNCTION = SQUARE
