# -*- coding: utf-8 -*-

# Import Python built-in modules.
import warnings

# Import external modules.
import numpy as np

# Own imports.
from ..bases import BaseHtcModel
from ..types import NumberOrVector
from ..types import Vector


class HtcTscheng1979(BaseHtcModel):
    """ Heat transfer coefficient by Tscheng (1979). """
    def __init__(self,
            D: NumberOrVector,
            beta: NumberOrVector,
            eta: NumberOrVector
        ) -> None:
        super().__init__()

        def fn(n, b):
            """ Helper function to compute fraction terms. """
            return (3 - n) * np.pi - b / n + np.sin(b / n)

        self._D_e = 0.5 * D * fn(1, beta) / fn(2, beta)
        self._eta = eta

        self._v_re_d = None
        self._v_re_w = None

    def _nusselt(self, a: Vector) -> NumberOrVector:
        """ Compute Nusselt number for given coefficients. """
        Nu = a[0] * pow(self._v_re_d, a[1]) *\
                    pow(self._v_re_w, a[2]) *\
                    pow(self._eta, a[3])
        return Nu

    def _model(self,k: NumberOrVector, a: Vector) -> NumberOrVector:
        """ Standard format heat transfer coefficient. """
        return (k / self._D_e) * self._nusselt(a)

    def update(self,
            rho: NumberOrVector,
            mu: NumberOrVector,
            u: NumberOrVector,
            w: float
        ) -> None:
        """ Update internals for Reynolds numbers. """
        re = lambda v: (rho * v * self._D_e / mu)
        self._v_re_d = re(u)
        self._v_re_w = re(w * self._D_e)

    def h_gb(self, kg: NumberOrVector) -> NumberOrVector:
        """ Gas-bed heat transfer coefficient. """
        return self._model(kg, [+0.46, +0.535, +0.104, -0.341])

    def h_gw(self, kg: NumberOrVector) -> NumberOrVector:
        """ Gas-wall heat transfer coefficient. """
        return self._model(kg, [+1.54, +0.575, -0.292, +0.000])

    def h_wb(self,
            kb: NumberOrVector,
            n: float,
            R: NumberOrVector,
            beta: NumberOrVector,
            a_b: NumberOrVector,
        ) -> NumberOrVector:
        """ Wall-bed heat transfer coefficient. 
        
        Important: according to Tscheng (1979) the value of Nusselt number
        argument must be limited to 10^4 according to their approach. Here
        we have chosen to add a warning at a higher value because common
        applications will just slightly disrespect the limit. This might
        change in future versions.
        """
        argnu = n * R**2 * beta / a_b
        Nu = 11.6 * pow(argnu, 0.3)

        # TODO check in paper if this is really required.
        # if any(argnu > 15_000.0):
        #     argnu_max = max(argnu)
        #     argnu = np.maximum(argnu, 15_000.0)
        #     warnings.warn(f"Argument outside bounds ({argnu_max:.1f})")

        h = kb * Nu / (R * beta)
        return h
