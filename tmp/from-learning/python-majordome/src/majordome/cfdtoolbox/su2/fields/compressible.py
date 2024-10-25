# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField

MACH_NUMBER = SU2ConfigField(
    "MACH_NUMBER", 0.8, 
    "Mach number (non-dimensional, based on the free-stream values)")

AOA = SU2ConfigField(
    "AOA", 1.25, 
    "Angle of attack (degrees, only for compressible flows)")

SIDESLIP_ANGLE = SU2ConfigField(
    "SIDESLIP_ANGLE", 0.0, 
    "Side-slip angle (degrees, only for compressible flows)")

# % Init option to choose between Reynolds (default) or thermodynamics quantities
# % for initializing the solution (REYNOLDS, TD_CONDITIONS)
# INIT_OPTION= REYNOLDS

# % Free-stream option to choose between density and temperature (default) for
# % initializing the solution (TEMPERATURE_FS, DENSITY_FS)
# FREESTREAM_OPTION= TEMPERATURE_FS

FREESTREAM_PRESSURE = SU2ConfigField(
    "FREESTREAM_PRESSURE", 101325.0, 
    "Free-stream pressure (101325.0 N/m^2, 2116.216 psf by default)")

FREESTREAM_TEMPERATURE = SU2ConfigField(
    "FREESTREAM_TEMPERATURE", 288.15, 
    "Free-stream temperature (288.15 K, 518.67 R by default)")

# % Free-stream VIBRATIONAL temperature (288.15 K, 518.67 R by default)
# FREESTREAM_TEMPERATURE_VE= 288.15

# % Reynolds number (non-dimensional, based on the free-stream values)
# REYNOLDS_NUMBER= 6.5E6

# % Reynolds length (1 m, 1 inch by default)
# REYNOLDS_LENGTH= 1.0

# % Free-stream density (1.2886 Kg/m^3, 0.0025 slug/ft^3 by default)
# FREESTREAM_DENSITY= 1.2886

# % Free-stream velocity (1.0 m/s, 1.0 ft/s by default)
# FREESTREAM_VELOCITY= ( 1.0, 0.00, 0.00 )

# % Free-stream viscosity (1.853E-5 N s/m^2, 3.87E-7 lbf s/ft^2 by default)
# FREESTREAM_VISCOSITY= 1.853E-5

# % Free-stream turbulence intensity
# FREESTREAM_TURBULENCEINTENSITY= 0.05

# % Fix turbulence quantities to far-field values inside an upstream half-space
# TURB_FIXED_VALUES= NO

# % Shift of the half-space on which fixed values are applied. 
# % It consists of those coordinates whose dot product with the 
# % normalized far-field velocity is less than this parameter.
# TURB_FIXED_VALUES_DOMAIN= -1.0

# % Free-stream ratio between turbulent and laminar viscosity
# FREESTREAM_TURB2LAMVISCRATIO= 10.0

# % Compressible flow non-dimensionalization (DIMENSIONAL, FREESTREAM_PRESS_EQ_ONE,
# %                              FREESTREAM_VEL_EQ_MACH, FREESTREAM_VEL_EQ_ONE)
# REF_DIMENSIONALIZATION= DIMENSIONAL
