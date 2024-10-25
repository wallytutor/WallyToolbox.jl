# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField

# % Density model within the incompressible flow solver.
# % Options are CONSTANT (default), BOUSSINESQ, or VARIABLE. If VARIABLE,
# % an appropriate fluid model must be selected.
# INC_DENSITY_MODEL= CONSTANT

# % Solve the energy equation in the incompressible flow solver
# INC_ENERGY_EQUATION = NO

# % Initial density for incompressible flows
# % (1.2886 kg/m^3 by default (air), 998.2 Kg/m^3 (water))
# INC_DENSITY_INIT= 1.2886

# % Initial velocity for incompressible flows (1.0,0,0 m/s by default)
# INC_VELOCITY_INIT= ( 1.0, 0.0, 0.0 )

# % Initial temperature for incompressible flows that include the
# % energy equation (288.15 K by default). Value is ignored if
# % INC_ENERGY_EQUATION is false.
# INC_TEMPERATURE_INIT= 288.15

# % Non-dimensionalization scheme for incompressible flows. Options are
# % INITIAL_VALUES (default), REFERENCE_VALUES, or DIMENSIONAL.
# % INC_*_REF values are ignored unless REFERENCE_VALUES is chosen.
# INC_NONDIM= INITIAL_VALUES

# % Reference density for incompressible flows (1.0 kg/m^3 by default)
# INC_DENSITY_REF= 1.0

# % Reference velocity for incompressible flows (1.0 m/s by default)
# INC_VELOCITY_REF= 1.0

# % Reference temperature for incompressible flows that include the
# % energy equation (1.0 K by default)
# INC_TEMPERATURE_REF = 1.0

# % List of inlet types for incompressible flows. List length must
# % match number of inlet markers. Options: VELOCITY_INLET, PRESSURE_INLET.
# INC_INLET_TYPE= VELOCITY_INLET

# % Damping coefficient for iterative updates at pressure inlets. (0.1 by default)
# INC_INLET_DAMPING= 0.1

# % List of outlet types for incompressible flows. List length must
# % match number of outlet markers. Options: PRESSURE_OUTLET, MASS_FLOW_OUTLET
# INC_OUTLET_TYPE= PRESSURE_OUTLET

# % Damping coefficient for iterative updates at mass flow outlets. (0.1 by default)
# INC_OUTLET_DAMPING= 0.1

# % Epsilon^2 multipier in Beta calculation for incompressible preconditioner.
# BETA_FACTOR= 4.1
