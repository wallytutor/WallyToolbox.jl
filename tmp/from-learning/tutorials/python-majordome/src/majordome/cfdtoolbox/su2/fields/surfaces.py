# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField

MARKER_PLOTTING = SU2ConfigField(
    "MARKER_PLOTTING", "NONE", 
    "Marker(s) of the surface in the surface flow solution file.")

MARKER_MONITORING = SU2ConfigField(
    "MARKER_MONITORING", "NONE", 
    "Marker(s) of the surface where the non-dimensional coefficients are evaluated.")

# % Viscous wall markers for which wall functions must be applied. (NONE = no marker)
# % Format: ( marker name, wall function type -NO_WALL_FUNCTION, STANDARD_WALL_FUNCTION,
# %           ADAPTIVE_WALL_FUNCTION, SCALABLE_WALL_FUNCTION, EQUILIBRIUM_WALL_MODEL,
# %           NONEQUILIBRIUM_WALL_MODEL-, ... )
# MARKER_WALL_FUNCTIONS= ( airfoil, NO_WALL_FUNCTION )
# %
# % Marker(s) of the surface where custom thermal BC's are defined.
# MARKER_PYTHON_CUSTOM = ( NONE )
# %
# % Marker(s) of the surface where obj. func. (design problem) will be evaluated
# MARKER_DESIGNING = ( airfoil )
# %
# % Marker(s) of the surface that is going to be analyzed in detail (massflow, average pressure, distortion, etc)
# MARKER_ANALYZE = ( airfoil )
# %
# % Method to compute the average value in MARKER_ANALYZE (AREA, MASSFLUX).
# MARKER_ANALYZE_AVERAGE = MASSFLUX