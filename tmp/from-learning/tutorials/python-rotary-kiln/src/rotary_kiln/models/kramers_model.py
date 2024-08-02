# -*- coding: utf-8 -*-

# Import Python built-in modules.
from typing import Callable
from typing import Optional

# Import external modules.
from scipy.integrate import solve_ivp
import numpy as np

# Own imports.
from ..types import Vector


class KramersModel:
    """ Kramers (1952) model for a rotary kiln bed height. 

    Parameters
    ----------
    radius: Callable[[float], [float]]
        Rotary kiln internal radius [m].
    slope: float
        Rotary kiln slope [rad].
    rotation_rate: float
        Rotary kiln rotation rate [rev/s].
    feed_rate: float
        Rotary kilnn keed rate [kg/s].
    repose_angle: float
        Bed material repose angle [rad].
    rho: float
        Bed material bulk density [kg/m³].
    """
    def __init__(self,
        radius: Callable[[float], float],
        slope: float,
        rotation_rate: float,
        feed_rate: float,
        repose_angle: float,
        rho: float,
    ) -> None:
        self._radius = radius
        self._n = rotation_rate
        self._vdot = feed_rate / rho
        self._terml = np.tan(slope) / np.sin(repose_angle)
        self._tan_b = np.tan(repose_angle)

    def __call__(self, z, h):
        """ Right-hand side of Kramer's equation for integration. """
        R = self._radius(z)
        ratio = h / R
        phi = (3/4) * self._vdot / (np.pi * R**3 * self._n)
        termr = phi * pow((2 - ratio) * ratio, -3/2)
        value = -self._tan_b * (self._terml - termr)
        return value


class KramersModelExperimental:
    """ Kramers (1952) model for a rotary kiln bed height. 

    Note: in the source papers greek letters alpha and beta
    are used respectively for slope and repose angle. Here
    we use the respective latin letters as subscripts for
    representing trigonometric functions of these angles.

    Parameters
    ----------
    radius: Callable[[float], float]
        Rotary kiln internal radius [m].
    slope: float
        Rotary kiln slope [rad].
    rotation_rate: float
        Rotary kiln rotation rate [rev/s].
    feed_rate: float
        Rotary kilnn keed rate [kg/s].
    repose_angle: float
        Bed material repose angle [rad].
    rho: float
        Bed material bulk density [kg/m³].
    """
    def __init__(self,
        radius: Callable[[float], float],
        slope: float,
        rotation_rate: float,
        feed_rate: float,
        repose_angle: float,
        rho: float
    ) -> None:
        self._radius = radius
        self._tan_a = np.tan(slope)
        self._n = rotation_rate
        self._vdot = feed_rate / rho

        # TODO add this to interface or autodiff.
        self._dz = 0.01

        # This will not change 
        self._sin_b = np.sin(repose_angle)
        self._tan_b = np.tan(repose_angle)

    def _local_slope(self, z, R):
        """ Compute slope of current cell. """
        m1 = self._tan_a
        m2 = self._radius(z + self._dz) - R
        m2 = m2 / self._dz
        return abs((m1 - m2) / (1 + m1 * m2))

    def __call__(self, z, h):
        """ Right-hand side of Kramer's equation for integration. """
        R = self._radius(z)
        tan_a = self._local_slope(z, R)
        self._phi = (3/4) * self._vdot / (np.pi * self._n * R**3)
        terml = tan_a / self._sin_b
        termr = self._phi * pow((2 - h / R) * h / R, -3/2)
        return -self._tan_b * (terml - termr)
    

def solve_kramers_model(
        radius: float,
        length: float,
        slope: float,
        rotation_rate: float,
        feed_rate: float,
        repose_angle: float,
        rho: float,
        discharge_height: Optional[float] = 0.0,
        t_eval: Optional[Vector] = None,
        method: Optional[str] = "BDF",
        frac: Optional[float] = 0.001,
        experimental: Optional[bool] = False
    ) -> tuple[Vector, Vector]:
    """ Solve Kramers (1952) model for a rotary kiln.

    Parameters
    ----------
    radius: float
        Rotary kiln internal radius [m].
    length: float
        Rotary kiln total length [m].
    slope: float
        Rotary kiln slope [rad].
    rotation_rate: float
        Rotary kiln rotation rate [rev/s].
    feed_rate: float
        Rotary kilnn keed rate [kg/s].
    repose_angle: float
        Bed material repose angle [rad].
    rho: float
        Bed material bulk density [kg/m³].
    discharge_height: Optional[float] = 0.0
        Discharge height, if constricted [m].
    t_eval: Optional[Vector] = None
        List of positions to output results [m]
    method: Optional[str] = "BDF"
        Integration method for `scipy.integrate.solve_ivp`.
    frac: Optional[float] = 0.001
        Minimum fraction of radius to use as outlet height.
    experimental: Optional[bool] = False
        If True, solve generalized cross section model.

    Returns
    -------
    tuple[Vector, Vector]:
        Evaluated positions [m] and associated bed heights [m].

    Raises
    ------
    RuntimeError
        Integration of model did not succeed.
    ValueError
        Evaluation points do not respect lenght of kiln.
    """
    if min(t_eval) < 0.0 or max(t_eval) > length:
        raise ValueError("Evaluation points outside kiln [0;L].")

    model_api = KramersModel if not experimental \
        else KramersModelExperimental

    model = model_api(radius, slope, rotation_rate,
                      feed_rate, repose_angle, rho)
    
    # Do not use zero as discharge height as initial value,
    # but a small fraction of radius (division by zero).
    y0 = max(discharge_height, frac * radius(0.0))

    sol = solve_ivp(model, y0=[y0], t_span=(0.0, length),
                    t_eval=t_eval, method=method)

    if not sol.success:
        raise RuntimeError("Failed to solve Kramers equation!")

    z = sol.t
    h = sol.y[0]

    return z, h
