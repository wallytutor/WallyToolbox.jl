# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField


DV_KIND = SU2ConfigField(
    "DV_KIND", "FFD_SETTING",
    "Kind of deformation.",
    options=(
        "NO_DEFORMATION",
        "SCALE_GRID",
        "TRANSLATE_GRID",
        "ROTATE_GRID",
        "FFD_SETTING",
        "FFD_NACELLE",
        "FFD_CONTROL_POINT",
        "FFD_CAMBER",
        "FFD_THICKNESS",
        "FFD_TWIST",
        "FFD_CONTROL_POINT_2D",
        "FFD_CAMBER_2D",
        "FFD_THICKNESS_2D",
        "FFD_TWIST_2D",
        "HICKS_HENNE",
        "SURFACE_BUMP",
        "SURFACE_FILE"
    ))

DV_MARKER = SU2ConfigField(
    "DV_MARKER", "NONE",
    "Marker of the surface in which we are going apply the shape deformation.")

DV_PARAM = SU2ConfigField(
    "DV_PARAM", (1, 0.5),
    "Parameters of the shape deformation.",
    detail=dedent("""
    Depending on the value of DV_KIND:
    - NO_DEFORMATION ( 1.0 )
    - TRANSLATE_GRID ( x_Disp, y_Disp, z_Disp ), as a unit vector
    - ROTATE_GRID ( x_Orig, y_Orig, z_Orig, x_End, y_End, z_End ) axis, DV_VALUE in deg.
    - SCALE_GRID ( 1.0 )
    - ANGLE_OF_ATTACK ( 1.0 )
    - FFD_SETTING ( 1.0 )
    - FFD_CONTROL_POINT ( FFD_BoxTag, i_Ind, j_Ind, k_Ind, x_Disp, y_Disp, z_Disp )
    - FFD_NACELLE ( FFD_BoxTag, rho_Ind, theta_Ind, phi_Ind, rho_Disp, phi_Disp )
    - FFD_GULL ( FFD_BoxTag, j_Ind )
    - FFD_ANGLE_OF_ATTACK ( FFD_BoxTag, 1.0 )
    - FFD_CAMBER ( FFD_BoxTag, i_Ind, j_Ind )
    - FFD_THICKNESS ( FFD_BoxTag, i_Ind, j_Ind )
    - FFD_TWIST ( FFD_BoxTag, j_Ind, x_Orig, y_Orig, z_Orig, x_End, y_End, z_End )
    - FFD_CONTROL_POINT_2D ( FFD_BoxTag, i_Ind, j_Ind, x_Disp, y_Disp )
    - FFD_CAMBER_2D ( FFD_BoxTag, i_Ind )
    - FFD_THICKNESS_2D ( FFD_BoxTag, i_Ind )
    - FFD_TWIST_2D ( FFD_BoxTag, x_Orig, y_Orig )
    - HICKS_HENNE ( Lower Surface (0)/Upper Surface (1)/Only one Surface (2), x_Loc )
    - SURFACE_BUMP ( x_Start, x_End, x_Loc )
    """))

DV_VALUE = SU2ConfigField(
    "DV_VALUE", 0.01,
    "Value of the shape deformation.")

# % For DV_KIND = SURFACE_FILE: With SU2_DEF, give filename for surface
# % deformation prescribed by an external parameterization. List moving markers
# % in DV_MARKER and provide an ASCII file with name specified with DV_FILENAME
# % and with format:
# % GlobalID_0, x_0, y_0, z_0
# % GlobalID_1, x_1, y_1, z_1
# %   ...
# % GlobalID_N, x_N, y_N, z_N
# % where N is the total number of vertices on all moving markers, and x/y/z are
# % the new position of each vertex. Points can be in any order. When SU2_DOT
# % is called in SURFACE_FILE mode, sensitivities on surfaces will be written
# % to an ASCII file with name given by DV_SENS_FILENAME and with format as
# % rows of x, y, z, dJ/dx, dJ/dy, dJ/dz for each surface vertex.
# DV_FILENAME= surface_positions.dat
# DV_SENS_FILENAME= surface_sensitivity.dat
# %
# % Format for volume sensitivity file read by SU2_DOT (SU2_NATIVE,
# % UNORDERED_ASCII). SU2_NATIVE is the native SU2 restart file (default),
# % while UNORDERED_ASCII provide a file of field sensitivities
# % as an ASCII file with name given by DV_SENS_FILENAMEand with format as
# % rows of x, y, z, dJ/dx, dJ/dy, dJ/dz for each grid point.
# DV_SENSITIVITY_FORMAT= SU2_NATIVE
# DV_UNORDERED_SENS_FILENAME= unordered_sensitivity.dat
