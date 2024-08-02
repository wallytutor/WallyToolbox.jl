# -*- coding: utf-8 -*-

# Import Python built-in modules.
from typing import Any
from typing import Callable
from typing import Optional

# Import external modules.
from scipy.interpolate import interp1d
import numpy as np

# Own imports.
from ..bases import BaseThermoBed
from ..materials import ThermoSi1O2
from ..types import NumberOrVector
from ..types import Vector


class SilicaBasedBed(BaseThermoBed):
    """ Implementation of rotary bed material.
    
    Parameters
    ----------
    m0: float
        Inlet total mass flow rate [kg/h].
    t0: Optional[float] = 300.0
        Inlet temperature [K].
    rho: Optional[float] = 150.0
        Material apparent specific weight [kg/m³].
    aor: Optional[float] = 45.0
        Material angle of repose (AOR) in degrees [°].
    kb: Optional[Callable[[float], float]] = lambda T: 0.2
        Material apparent thermal conductivity [W/(m.K)].
    """
    def __init__(self,
            m0: float,
            t0: Optional[float] = 300.0,
            rho: Optional[float] = 150.0,
            aor: Optional[float] = 45.0,
            kb: Optional[Callable[[float], float]] = lambda T: 0.2
        ) -> None:
        super().__init__()
        self._specific_mass = rho
        self._repose_angle = np.radians(aor)
        self._kb = kb
        self._si1o2 = ThermoSi1O2()
        self._initial_value = np.array([m0 / 3600.0, t0])
        self._n_vars = self._initial_value.shape[0]
        self._rhs = np.zeros((self._n_vars,))

    def __call__(self,
            z: float,
            state: Vector,
            fn_qdot: Callable[[float], float],
            sdotk: Vector = None
        ) -> Vector:
        """ Evaluate model ODE system right-hand side."""
        # mdot, T, Y = state[0], state[1], state[2:]
        mdot, T = state[0], state[1]
        sdotk = [0] if sdotk is None else sdotk

        # Compute contributions.
        qdot = fn_qdot(z)
        Ab, Pb = self._get_section(z)
        cp = self.specific_heat_mass(T)

        sdot = sum(sdotk)
        Tdot = qdot / (mdot * cp)

        # Set original array for return.
        self._rhs[0] = sdot
        self._rhs[1] = Tdot
        # self._rhs[2:] = Ydot

        return self._rhs

    def register_section_getter(self, kiln: Any) -> None:
        """ Creates a function to retrieve section properties. """
        super().register_section_getter(kiln)

        # XXX: kiln coordinates start from discharge end. For bed
        # computations these must be reversed. Notice that we do not
        # need to inverse the areas/perimeter arrays when doing so.
        z = kiln.length - kiln.coordinates
        opts = dict(fill_value="extrapolate")
        area = interp1d(z, kiln.bed_cross_area, **opts)
        perc = interp1d(z, kiln.bed_cord_length, **opts)
        self._get_section = lambda z: (area(z), perc(z))

    def specific_heat_mass(self, T: NumberOrVector) -> NumberOrVector:
        """ Add water specific heat and latent heat of vaporization. """
        # TODO add this to model interface.
        y_h2o = 0.02
        
        cp_bed = self._si1o2.specific_heat_mass
        cp_h2o = 4186.0
        dh_h2o = 2260000.0

        def f1(T):
            return y_h2o * cp_h2o + (1 - y_h2o) * cp_bed(T)

        def f2(T, m=1.0/20.0):
            y = y_h2o * (1.0 - m * (T - 353.15))
            # dcp = m * y_h2o * dh_h2o ... or should it be this?
            dcp = m * dh_h2o
            return y * (cp_h2o + dcp) + (1 - y) * cp_bed(T)

        condlist = [T <= 353.15, T <= 373.15, T >  373.15]
        funclist = [f1         , f2         , cp_bed     ]

        cp = np.piecewise(T, condlist, funclist)
        return cp
    
    def thermal_conductivity(self, T: NumberOrVector) -> NumberOrVector:
        """ Access to bed thermal conductivity [W/(m.K)]. """
        return self._kb(T)

    def thermal_diffusivity(self, T: NumberOrVector) -> NumberOrVector:
        """ Access to bed thermal_diffusivity [m²/s]. """
        cp = self.specific_heat_mass(T)
        alpha = self._kb(T) / (self._specific_mass * cp)
        return alpha
    
    @property
    def specific_mass(self) -> float:
        """ Access to bed specific weight [kg/m³]. """
        return self._specific_mass

    @property
    def repose_angle(self) -> float:
        """ Access to bed repose angle [rad]. """
        return self._repose_angle
