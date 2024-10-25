# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField

MARKER_EULER = SU2ConfigField(
    "MARKER_EULER", "NONE", 
    "Euler wall boundary marker(s) (NONE = no marker)",
    detail="Implementation identical to MARKER_SYM.")

# % Navier-Stokes (no-slip), constant heat flux wall  marker(s) (NONE = no marker)
# % Format: ( marker name, constant heat flux (J/m^2), ... )
# MARKER_HEATFLUX= ( NONE )
# %
# % Navier-Stokes (no-slip), heat-transfer/convection wall marker(s) (NONE = no marker)
# % Available for compressible and incompressible flow.
# % Format: ( marker name, constant heat-transfer coefficient (J/(K*m^2)), constant reservoir Temperature (K) ... )
# MARKER_HEATTRANSFER= ( NONE )
# %
# % Navier-Stokes (no-slip), isothermal wall marker(s) (NONE = no marker)
# % Format: ( marker name, constant wall temperature (K), ... )
# MARKER_ISOTHERMAL= ( NONE )
# %
# % Far-field boundary marker(s) (NONE = no marker)
# MARKER_FAR= ( farfield )
# %
# % Symmetry boundary marker(s) (NONE = no marker)
# % Implementation identical to MARKER_EULER.
# MARKER_SYM= ( NONE )
# %
# % Internal boundary marker(s) e.g. no boundary condition (NONE = no marker)
# MARKER_INTERNAL= ( NONE )
# %
# % Near-Field boundary marker(s) (NONE = no marker)
# MARKER_NEARFIELD= ( NONE )

INLET_TYPE = SU2ConfigField(
    "INLET_TYPE", "TOTAL_CONDITIONS", "Inlet boundary type",
     options=("TOTAL_CONDITIONS", "MASS_FLOW"))

# % Read inlet profile from a file (YES, NO) default: NO
# SPECIFIED_INLET_PROFILE= NO
# %
# % File specifying inlet profile
# INLET_FILENAME= inlet.dat

MARKER_INLET = SU2ConfigField(
    "MARKER_INLET", "NONE",
    "Inlet boundary marker(s) with the following formats (NONE = no marker)",
    detail=dedent("""\
    Total Conditions:
        (inlet marker, total temp, total pressure, flow_direction_x,
         flow_direction_y, flow_direction_z, ... )
    Mass Flow:
        (inlet marker, density, velocity magnitude, flow_direction_x,
         flow_direction_y, flow_direction_z, ... )
    Inc. Velocity:
        (inlet marker, temperature, velocity magnitude, flow_direction_x,
         flow_direction_y, flow_direction_z, ... )
    Inc. Pressure:
        (inlet marker, temperature, total pressure, flow_direction_x,
         flow_direction_y, flow_direction_z, ... )
    In all cases `flow_direction` is a unit vector.
    """))

MARKER_OUTLET = SU2ConfigField(
    "MARKER_OUTLET", "NONE",
    "Outlet boundary marker(s) (NONE = no marker)",
    detail=dedent("""\
    Compressible:
        ( outlet marker, back pressure (static thermodynamic), ... )
    Inc. Pressure:
        ( outlet marker, back pressure (static gauge in Pa), ... )
    Inc. Mass Flow:
        ( outlet marker, mass flow target (kg/s), ... )
    """))

# % Actuator disk boundary type (VARIABLE_LOAD, VARIABLES_JUMP, BC_THRUST,
# %                              DRAG_MINUS_THRUST)
# ACTDISK_TYPE= VARIABLES_JUMP
# %
# % Actuator disk boundary marker(s) with the following formats (NONE = no marker)
# % Variable Load: (inlet face marker, outlet face marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
# % Variables Jump: ( inlet face marker, outlet face marker,
# %                   Takeoff pressure jump (psf), Takeoff temperature jump (R), Takeoff rev/min,
# %                   Cruise  pressure jump (psf), Cruise temperature jump (R), Cruise rev/min )
# % BC Thrust: ( inlet face marker, outlet face marker,
# %              Takeoff BC thrust (lbs), 0.0, Takeoff rev/min,
# %              Cruise BC thrust (lbs), 0.0, Cruise rev/min )
# % Drag-Thrust: ( inlet face marker, outlet face marker,
# %                Takeoff Drag-Thrust (lbs), 0.0, Takeoff rev/min,
# %                Cruise Drag-Thrust (lbs), 0.0, Cruise rev/min )
# MARKER_ACTDISK= ( NONE )
# %
# % Actuator disk data input file name
# ACTDISK_FILENAME= actuatordisk.dat

MARKER_SUPERSONIC_INLET = SU2ConfigField(
    "MARKER_SUPERSONIC_INLET", "NONE",
    "Supersonic inlet boundary marker(s) (NONE = no marker)",
    detail=dedent("""\

    Format:
        (inlet marker, temperature, static pressure,
         velocity_x, velocity_y, velocity_z, ... )
         i.e. primitive variables specified.
    """))

# % Supersonic outlet boundary marker(s) (NONE = no marker)
# MARKER_SUPERSONIC_OUTLET= ( NONE )
# %
# % Periodic boundary marker(s) (NONE = no marker)
# % Format: ( periodic marker, donor marker, rotation_center_x, rotation_center_y,
# % rotation_center_z, rotation_angle_x-axis, rotation_angle_y-axis,
# % rotation_angle_z-axis, translation_x, translation_y, translation_z, ... )
# MARKER_PERIODIC= ( NONE )
# %
# % Engine Inflow boundary type (FAN_FACE_MACH, FAN_FACE_PRESSURE, FAN_FACE_MDOT)
# ENGINE_INFLOW_TYPE= FAN_FACE_MACH
# %
# % Engine inflow boundary marker(s) (NONE = no marker)
# % Format: (engine inflow marker, fan face Mach, ... )
# MARKER_ENGINE_INFLOW= ( NONE )
# %
# % Engine exhaust boundary marker(s) with the following formats (NONE = no marker)
# % Format: (engine exhaust marker, total nozzle temp, total nozzle pressure, ... )
# MARKER_ENGINE_EXHAUST= ( NONE )
# %
# % Displacement boundary marker(s) (NONE = no marker)
# % Format: ( displacement marker, displacement value normal to the surface, ... )
# MARKER_NORMAL_DISPL= ( NONE )
# %
# % Pressure boundary marker(s) (NONE = no marker)
# % Format: ( pressure marker )
# MARKER_PRESSURE= ( NONE )
# %
# % Riemann boundary marker(s) (NONE = no marker)
# % Format: (marker, data kind flag, list of data)
# MARKER_RIEMANN= ( NONE )
# %
# % Shroud boundary marker(s) (NONE = no marker)
# % Format: (marker)
# % If the ROTATING_FRAME option is activated, this option force
# % the velocity on the boundaries specified to 0.0
# MARKER_SHROUD= (NONE)
# %
# % Interface (s) definition, identifies the surface shared by
# % two different zones. The interface is defined by listing pairs of
# % markers (one from each zone connected by the interface)
# % Example:
# %   Given an arbitrary number of zones (A, B, C, ...)
# %   A and B share a surface, interface 1
# %   A and C share a surface, interface 2
# % Format: ( marker_A_on_interface_1, marker_B_on_interface_1,
# %           marker_A_on_interface_2, marker_C_on_interface_2, ... )
# %
# MARKER_ZONE_INTERFACE= ( NONE )
# %
# % Specifies the interface (s)
# % The kind of interface is defined by listing pairs of markers (one from each
# % zone connected by the interface)
# % Example:
# %   Given an arbitrary number of zones (A, B, C, ...)
# %   A and B share a surface, interface 1
# %   A and C share a surface, interface 2
# % Format: ( marker_A_on_interface_1, marker_B_on_interface_1,
# %           marker_A_on_interface_2, marker_C_on_interface_2, ... )
# %
# MARKER_FLUID_INTERFACE= ( NONE )
# %
# % Kind of interface interpolation among different zones (NEAREST_NEIGHBOR,
# %                                                        ISOPARAMETRIC, SLIDING_MESH)
# KIND_INTERPOLATION= NEAREST_NEIGHBOR
# %
# % Inflow and Outflow markers must be specified, for each blade (zone), following
# % the natural groth of the machine (i.e, from the first blade to the last)
# MARKER_TURBOMACHINERY= ( NONE )
# %
# % Mixing-plane interface markers must be specified to activate the transfer of
# % information between zones
# MARKER_MIXINGPLANE_INTERFACE= ( NONE )
# %
# % Giles boundary condition for inflow, outfolw and mixing-plane
# % Format inlet:  ( marker, TOTAL_CONDITIONS_PT, Total Pressure , Total Temperature,
# % Flow dir-norm, Flow dir-tang, Flow dir-span, under-relax-avg, under-relax-fourier)
# % Format outlet: ( marker, STATIC_PRESSURE, Static Pressure value, -, -, -, -, under-relax-avg, under-relax-fourier)
# % Format mixing-plane in and out: ( marker, MIXING_IN or MIXING_OUT, -, -, -, -, -, -, under-relax-avg, under-relax-fourier)
# MARKER_GILES= ( NONE )
# %
# % This option insert an extra under relaxation factor for the Giles BC at the hub
# % and shroud (under relax factor applied, span percentage to under relax)
# GILES_EXTRA_RELAXFACTOR= ( 0.05, 0.05)
# %
# % YES Non reflectivity activated, NO the Giles BC behaves as a normal 1D characteristic-based BC
# SPATIAL_FOURIER= NO
# %
# % Catalytic wall marker(s) (NONE = no marker)
# % Format: ( marker name, ... )
# CATALYTIC_WALL= ( NONE )
