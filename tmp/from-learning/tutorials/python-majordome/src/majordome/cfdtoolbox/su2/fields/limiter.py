# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField

MUSCL_FLOW = SU2ConfigField(
    "MUSCL_FLOW", "YES", 
    "Monotonic Upwind Scheme for Conservation Laws (TVD) in the flow equations.",
    options=("YES", "NO"),
    detail="Required for 2nd order upwind schemes.")

SLOPE_LIMITER_FLOW = SU2ConfigField(
    "SLOPE_LIMITER_FLOW", "VENKATAKRISHNAN", 
    "Slope limiter.",
    options=(
        "NONE",
        "VENKATAKRISHNAN",
        "VENKATAKRISHNAN_WANG",
        "BARTH_JESPERSEN",
        "VAN_ALBADA_EDGE"
    ))

# % Monotonic Upwind Scheme for Conservation Laws (TVD) in the turbulence equations.
# %           Required for 2nd order upwind schemes (NO, YES)
# MUSCL_TURB= NO

# % Slope limiter (NONE, VENKATAKRISHNAN, VENKATAKRISHNAN_WANG,
# %                BARTH_JESPERSEN, VAN_ALBADA_EDGE)
# SLOPE_LIMITER_TURB= VENKATAKRISHNAN

# % Monotonic Upwind Scheme for Conservation Laws (TVD) in the adjoint flow equations.
# %           Required for 2nd order upwind schemes (NO, YES)
# MUSCL_ADJFLOW= YES

# % Slope limiter (NONE, VENKATAKRISHNAN, BARTH_JESPERSEN, VAN_ALBADA_EDGE,
# %                SHARP_EDGES, WALL_DISTANCE)
# SLOPE_LIMITER_ADJFLOW= VENKATAKRISHNAN

# % Monotonic Upwind Scheme for Conservation Laws (TVD) in the turbulence adjoint equations.
# %           Required for 2nd order upwind schemes (NO, YES)
# MUSCL_ADJTURB= NO

# % Slope limiter (NONE, VENKATAKRISHNAN, BARTH_JESPERSEN, VAN_ALBADA_EDGE)
# SLOPE_LIMITER_ADJTURB= VENKATAKRISHNAN

VENKAT_LIMITER_COEFF = SU2ConfigField(
    "VENKAT_LIMITER_COEFF", 0.05, 
    "Coefficient for the Venkat's limiter (upwind scheme).",
    detail=dedent("""\
    A larger values decrease the extent of limiting, values approaching
    zero cause lower-order approximation to the solution. 
    """))

# % Reference coefficient for detecting sharp edges (3.0 by default).
# REF_SHARP_EDGES = 3.0

# % Coefficient for the adjoint sharp edges limiter (3.0 by default).
# ADJ_SHARP_LIMITER_COEFF= 3.0

# % Remove sharp edges from the sensitivity evaluation (NO, YES)
# SENS_REMOVE_SHARP = NO

# % Freeze the value of the limiter after a number of iterations
# LIMITER_ITER= 999999

# % 1st order artificial dissipation coefficients for
# %     the Lax–Friedrichs method ( 0.15 by default )
# LAX_SENSOR_COEFF= 0.15

JST_SENSOR_COEFF = SU2ConfigField(
    "JST_SENSOR_COEFF", (0.5, 0.02), 
    "2nd and 4th order artificial dissipation coefficients for the JST method.")

# % 1st order artificial dissipation coefficients for
# %     the adjoint Lax–Friedrichs method ( 0.15 by default )
# ADJ_LAX_SENSOR_COEFF= 0.15

# % 2nd, and 4th order artificial dissipation coefficients for
# %     the adjoint JST method ( 0.5, 0.02 by default )
# ADJ_JST_SENSOR_COEFF= ( 0.5, 0.02 )
