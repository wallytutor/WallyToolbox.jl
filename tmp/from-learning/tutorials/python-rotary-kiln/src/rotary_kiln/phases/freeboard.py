# -*- coding: utf-8 -*-

# Import Python built-in modules.
from pathlib import Path
from typing import Any
from typing import Callable
from typing import Optional

# Import external modules.
from scipy.interpolate import interp1d
from scipy.optimize import root
import cantera as ct
import numpy as np

# Own imports.
from ..bases import BaseThermoFreeboard
from ..models import arrhenius
from ..types import NumberOrVector
from ..types import Vector

# Make package kinetics data available.
ct.add_directory(Path(__file__).resolve().parents[1] / "data")


class FreeboardCantera(BaseThermoFreeboard):
    """ Cantera implementation of rotary kiln freeboard gas.
    
    This class implements the thermophysics of a rotary kiln
    freeboard gas on top of Cantera. The user must provide the
    fuel and oxidizer compositions in mole fractions and the
    required equivalence ratio, so that Cantera can evaluate
    initial state in a premixed solution.

    Parameters
    ----------
    mechanism: str
        Kinetics mechanism in Cantera format.
    m0: float
        Inlet total mass flow rate [kg/s].
    t0: float
        Inlet temperature [K].
    lambda0: float
        Inlet equivalence ratio [-].
    fuel: str | dict[str, float]
        Fuel composition in mole fractions [-].
    oxid: str | dict[str, float]
        Oxidizer composition in mole fractions [-].
    p0: Optional[float] = ct.one_atm
        Freeboard operating pressure [Pa].
    equilibrate: Optional[float] = False
        If `True`, gas is pre-equilibrated on initialization.
    """
    def __init__(self,
            mechanism: str,
            m0: float,
            t0: float,
            lambda0: float,
            fuel: str | dict[str, float],
            oxid: str | dict[str, float],
            p0: Optional[float] = ct.one_atm,
            equilibrate: Optional[float] = False
        ) -> None:
        super().__init__()

        # Initialize gas to given equivalece ratio.
        self._gas = ct.Solution(mechanism)
        self._gas.TP = t0, p0
        self._gas.set_equivalence_ratio(lambda0, fuel, oxid)

        if equilibrate:
            self._gas.equilibrate("HP")

        # Store/allocate internals.
        self._mw = self._gas.molecular_weights
        self._initial_value = np.hstack((m0, self._gas.T, self._gas.Y))
        self._n_vars = self._initial_value.shape[0]
        self._rhs = np.zeros((self._n_vars,))

    @property
    def _partial_enthalpies_mass(self) -> Vector:
        """ Species partial mass enthalpies [J/kg]. """
        return self._gas.partial_molar_enthalpies / self._mw

    def _heat_release_rate_volume(self, wdotk: Vector) -> float:
        """ Volumetric heat release rate [W/m³].
        
        XXX: for verification of properties, i.e. checking that
        the computation of `_partial_enthalpies_mass` is calling
        the good Cantera property, it was verified that this is
        precisely equivalent to `self._gas.heat_release_rate` if
        kinetics is `MAK` managed by Cantera.
        """
        return sum(wdotk * self._partial_enthalpies_mass)

    def _heat_release_rate_surface(self, sdotk: Vector) -> float:
        """ Surface heat release rate [W/m²]. """
        return sum(sdotk * self._partial_enthalpies_mass)

    def _wdot_mass(self, z: float, T: float, Y: Vector) -> Vector:
        """ Return reaction rate in mass units [kg/(m³.s)]. """
        return self._gas.net_production_rates * self._mw

    def __call__(self,
            z: float,
            state: Vector,
            fn_qdot: Callable[[float], float],
            sdotk: Vector = None,
        ) -> Vector:
        """ Evaluate model ODE system right-hand side.
        
        Care is taken with Cantera units (use of kmol):
        - net_production_rates     : [kmol/(m³.s)]
        - molecular_weights        : [kg/kmol]
        - partial_molar_enthalpies : [J/kmol]
        """
        mdot, T, Y = state[0], state[1], state[2:]
        sdotk = np.zeros_like(Y) if sdotk is None else sdotk

        # Set gas state to compute properties.
        self._gas.TPY = T, None, Y

        # Compute contributions.
        qdot = fn_qdot(z)
        Ac, Pc = self._get_section(z)
        wdotk = self._wdot_mass(z, T, Y)
        hdotv = -Ac * self._heat_release_rate_volume(wdotk)
        hdots = -Pc * self._heat_release_rate_surface(sdotk)
        cp = self._gas.cp_mass

        # Compute derivatives.
        sdot = Pc * sum(sdotk)
        Ydot = (Ac * wdotk + Pc * sdotk - Y * sdot) / mdot
        Tdot = (hdotv + hdots + qdot) / (mdot * cp)

        # Set original array for return.
        self._rhs[0] = sdot
        self._rhs[1] = Tdot
        self._rhs[2:] = Ydot

        return self._rhs

    def register_section_getter(self, kiln: Any) -> None:
        """ Creates a function to retrieve section properties. """
        super().register_section_getter(kiln)

        z = kiln.coordinates
        opts = dict(fill_value="extrapolate")
        area = interp1d(z, kiln.gas_cross_area, **opts)
        perc = interp1d(z, kiln.bed_cord_length, **opts)
        self._get_section = lambda z: (area(z), perc(z))

        # Allocate memory for use in `update_htc`.
        self._sarr = ct.SolutionArray(self._gas, shape=z.shape)


class FreeboardMethane1S(FreeboardCantera):
    """ Implementation of rotary kiln freeboard gas. 
    
    This class allows to override default Cantera-based mass action
    kinetics (MAK) rate through an eddy break-up (EBU) approach, as
    detailed by Mujumdar (2006). For validation purposes, the user
    can switch back to MAK kinetics. Notice that the model here is
    valid only for 1-step methane combustion under the form of
    `CH4 + 2 O2 -> CO2 + 2 H2O` and species in mechanism file must
    be ordered as in this equation followed by `Ar` and `N2`, with
    6 species in total.
    
    Parameters
    ----------
    m0: float
        Inlet total mass flow rate [kg/s].
    t0: float
        Inlet temperature [K].
    lambda0: float
        Inlet equivalence ratio [-].
    fuel: str | dict[str, float]
        Fuel composition in mole fractions [-].
    oxid: str | dict[str, float]
        Oxidizer composition in mole fractions [-].
    p0: Optional[float] = ct.one_atm
        Freeboard operating pressure [Pa].
    mechanism: Optional[str] = "1S_CH4_MP1.yaml"
        Kinetics mechanism in Cantera format.
    kinetics: Optional[str] = "EBU"
        Switch for EBU or MAK rate equations.
    ke: Optional[Callable[[NumberOrVector], NumberOrVector]] = None
        Eddy break-up (EBU) k-epsilon ratio.
    equilibrate: Optional[float] = False
        If `True`, gas is pre-equilibrated on initialization.
    """
    def __init__(self,
            m0: float,
            t0: float,
            lambda0: float,
            fuel: str | dict[str, float],
            oxid: str | dict[str, float],
            p0: Optional[float] = ct.one_atm,
            mechanism: Optional[str] = "1S_CH4_MP1.yaml",
            kinetics: Optional[str] = "EBU",
            ke: Optional[Callable[[NumberOrVector], NumberOrVector]] = None,
            equilibrate: Optional[float] = False
        ) -> None:
        super().__init__(mechanism, m0, t0, lambda0, fuel, oxid,
                         p0, equilibrate)
        self._coefs = np.array([-1.0, -2.0, 1.0, 2.0, 0.0, 0.0])
        self._idxf = self._gas.species_index("CH4")
        self._idxo = self._gas.species_index("O2")
        self._ke = ke

        match kinetics:
            case "EBU":
                self._wdot_mass = self._wdot_ebu
            case "MAK":
                self._wdot_mass = super()._wdot_mass

    def _wdot_ebu(self, z: float, T: float, Y: Vector) -> Vector:
        """ Return reaction rate in mass units [kg/(m³.s)]. """
        cr, bo = 4.000e+00, 4.375e+00
        k0, Ea = 1.600e+10, 1.081e+05

        # Retrieve rate parameters.
        rho = self._gas.density_mass
        yf, yo = Y[[self._idxf, self._idxo]]
        ke = self._ke(z)

        # Evaluate both possible reaction rates.
        R_ebu = rho**1 * cr * ke * min(yf, yo / bo)
        R_arr = rho**2 * yf * yo * arrhenius(k0, Ea, T)

        # Mole rate of CH4 consumption.
        rt = min(R_ebu, R_arr) / self._mw[self._idxf]

        # Mass rate of all species from `rt`.
        return rt * self._coefs * self._mw

    def register_section_getter(self, kiln: Any) -> None:
        """ Creates a function to retrieve section properties. """
        super().register_section_getter(kiln)

        if self._ke is None:
            # Approximate k/e ratio proposed by Mujumdar (2006).
            self._ke = lambda z: z / kiln.length


class FreeboardMethane1SLeak(FreeboardMethane1S):
    """ Implementation of rotary kiln freeboard gas with air leak. 
    
    For more details check parent class `FreeboardMethane1S`.

    Parameters
    ----------
    mf0: float
        Inlet total mass flow rate [kg/s].
    tf0: float
        Inlet temperature [K].
    lambda0: float
        Inlet equivalence ratio [-].
    fuel: str | dict[str, float]
        Fuel composition in mole fractions [-].
    oxid: str | dict[str, float]
        Oxidizer composition in mole fractions [-].
    x_o2: float
        Fumes outlet measured oxygen mole fraction [-]
    air: Optional[str | dict[str, float]] = "N2: 0.78, O2: 0.21, AR: 0.01"
        Air composition given in mole fractions.
    ta0: Optional[float] = 300.0
        Leakage air temperature [K].
    p0: Optional[float] = ct.one_atm
        Freeboard operating pressure [Pa].
    mechanism: Optional[str] = "1S_CH4_MP1.yaml"
        Kinetics mechanism in Cantera format.
    kinetics: Optional[str] = "EBU"
        Switch for EBU or MAK rate equations.
    ke: Optional[Callable[[NumberOrVector], NumberOrVector]] = None
        Eddy break-up (EBU) k-epsilon ratio.
    """
    def __init__(self,
        mf0: float,
        tf0: float,
        lambda0: float,
        fuel: str | dict[str, float],
        oxid: str | dict[str, float],
        x_o2: float,
        air: Optional[str | dict[str, float]] = "N2: 0.78, O2: 0.21, AR: 0.01",
        ta0: Optional[float] = 300.0,
        p0: Optional[float] = ct.one_atm,
        mechanism: Optional[str] = "1S_CH4_MP1.yaml",
        kinetics: Optional[str] = "EBU",
        ke: Optional[Callable[[NumberOrVector], NumberOrVector]] = None
    ) -> None:
        super().__init__(mf0, tf0, lambda0, fuel, oxid, p0, mechanism,
                            kinetics, ke, equilibrate=False)

        qm = find_air_leak(mechanism, mf0, tf0, lambda0,
                           fuel, oxid, ta0, air, x_o2)

        m0 = qm.mass
        self._gas.TPX = qm.T, qm.P, qm.X
        self._initial_value = np.hstack((m0, self._gas.T, self._gas.Y))


def find_air_leak(mechanism, mf0, tf0, lambda0, fuel, oxid, ta0, air, x_o2):
    """ Find air leak flow explaining measured oxygen content. """
    gas1 = ct.Solution(mechanism)
    gas1.TP = tf0, ct.one_atm
    gas1.set_equivalence_ratio(lambda0, fuel, oxid)

    gas2 = ct.Solution(mechanism)
    gas2.TPX = ta0, ct.one_atm, air

    q1 = ct.Quantity(gas1, mass=mf0)
    q1.equilibrate("HP")

    idx_o2 = q1.species_index("O2")

    def objective(f2):
        """ Minimize target of equilibrium composition. """
        qm = q1 + ct.Quantity(gas2, mass=f2)
        return x_o2 - qm.X[idx_o2]

    if not (sol := root(objective, [mf0])).success:
        raise ValueError("Could not find required flow!")

    q2 = ct.Quantity(gas2, mass=sol.x[0])
    qm = q1 + q2

    return qm
