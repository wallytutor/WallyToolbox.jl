# -*- coding: utf-8 -*-

# Import external modules.
import numpy as np

# Own imports.
from ..types import Vector
from ..types import NumberOrVector


class ShomateEquation:
    """ Implements thermophysical data in Shomate's format.
    
    Parameters
    ----------
    lo: Vector
        List of low temperature range model coefficients.
    hi: Vector
        List of high temperature range model coefficients.
    t_crit: float
        Temperature separating low and high ranges [K].
    mw: float
        Molecular mass of species [kg/mol].

    Raises
    ------
    ValueError
        Coefficients list is not of right length (8-elements).
    """
    def __init__(self,
            lo: Vector,
            hi: Vector,
            t_crit: float,
            mw: float
        ) -> None:
        if len(lo) != 8 or len(hi) != 8:
            raise ValueError("Coefficients must be 8-elements long")

        self._mw = mw
        self._condlist = lambda T: [(T < t_crit), (T >= t_crit)]

        cp_lo, dh_lo, so_lo = _shomate_functions(*lo)
        cp_hi, dh_hi, so_hi = _shomate_functions(*hi)

        self._cplist = [cp_lo, cp_hi]
        self._dhlist = [dh_lo, dh_hi]
        self._solist = [so_lo, so_hi]

    def specific_heat_mole(self, T: NumberOrVector) -> NumberOrVector:
        """ Evaluate specific heat at given temperature [J/(mol.K)]. """
        return np.piecewise(T/1000, self._condlist(T), self._cplist)

    def enthalpy_mole(self, T: NumberOrVector) -> NumberOrVector:
        """ Evaluate enthalpy at given temperature [J/mol]. """
        return np.piecewise(T/1000, self._condlist(T), self._dhlist)

    def entropy_mole(self, T: NumberOrVector) -> NumberOrVector:
        """ Evaluate entropy at given temperature [J/(mol.K)]. """
        return np.piecewise(T/1000, self._condlist(T), self._solist)

    def specific_heat_mass(self, T: NumberOrVector) -> NumberOrVector:
        """ Evaluate specific heat at given temperature [J/(kg.K)]. """
        return self.specific_heat_mole(T) / self._mw

    def enthalpy_mass(self, T: NumberOrVector) -> NumberOrVector:
        """ Evaluate enthalpy at given temperature [J/(mol.K)]. """
        return self.enthalpy_mole(T) / self._mw

    def entropy_mass(self, T: NumberOrVector) -> NumberOrVector:
        """ Evaluate entropy at given temperature [J/(kg.K)]. """
        return self.entropy_mole(T) / self._mw


def _shomate_functions(a, b, c, d, e, f, g, h):
    """ Create reduced temperature functions from parameters. """
    cp = lambda t: a+b*t+c*t**2+d*t**3+e/t**2
    dh = lambda t: a*t+b/2*t**2+c/3*t**3+d/4*t**4-e/t+f-h
    so = lambda t: a*np.log(t)+b*t+c/2*t**2+d/3*t**3+e/(2*t**2)+g
    return cp, dh, so
