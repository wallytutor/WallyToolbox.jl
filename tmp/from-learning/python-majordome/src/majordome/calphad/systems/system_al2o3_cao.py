# -*- coding: utf-8 -*-
from tkinter import Y
from typing import Optional
from casadi import DM
from casadi import SX
from casadi import log
from casadi import vertcat
import numpy as np
from ...utilities import Capturing
from .base_system import BaseSystem


class SystemAl2O3CaO(BaseSystem):
    """ Compute equilibrium in Al2O3-CaO system (Hallstedt, 1990). """
    def __init__(self, verbosity: Optional[int] = 0,
                 max_iter: Optional[int] = 5000) -> None:
        super().__init__()

        G_AL2O3_LIQUID = self._known["G(LIQUID,AL2O3)"]
        G_CAO_LIQUID = self._known["G(LIQUID,CA1O1)"]
        L0_LIQUID_AL3P_CA2P = self._known["L(LIQUID,AL(3+),CA(2+);0)"]
        L1_LIQUID_AL3P_CA2P = self._known["L(LIQUID,AL(3+),CA(2+);1)"]
        G_CAO_SOLID = self._known["G(CA1O1,CA1O1)"]
        G_AL2O3_ALPHA = self._known["G(ALPHA_AL2O3,AL2O3)"]
        G_C3A1 = self._known["G(C3A1,C3A1)"]
        G_C1A1 = self._known["G(C1A1,C1A1)"]
        G_C1A2 = self._known["G(C1A2,C1A2)"]
        G_C1A6 = self._known["G(C1A6,C1A6)"]

        x0 = SX.sym("x0")
        phi = SX.sym("phi", self.no_phases)
        y_liq = SX.sym("y_liq", 2)

        P = 2
        Q = 2 * y_liq[1] + 3 * y_liq[0]

        G_LIQUID = (
            y_liq[0] * G_AL2O3_LIQUID +
            y_liq[1] * G_CAO_LIQUID * 2.0 +
            P * self._R * self._T * (
                y_liq[0] * log(y_liq[0]) +
                y_liq[1] * log(y_liq[1])
            ) +
            y_liq[0] * y_liq[1] * (
                L0_LIQUID_AL3P_CA2P +
                L1_LIQUID_AL3P_CA2P * (y_liq[0] - y_liq[1])
            )
        )

        G = vertcat(G_LIQUID, G_CAO_SOLID, G_C3A1, G_C1A1,
                    G_C1A2, G_C1A6, G_AL2O3_ALPHA)

        n0_al = 2 * x0
        n0_ca = 1 * (1 - x0)
        n0_oo = 3 * x0 + 1 * (1 - x0)

        g0 = 1 - (y_liq[0] + y_liq[1])

        # "LIQUID", "CaO", "C3A1", "C1A1", "C1A2", "C1A6", "Al2O3"
        # g1 = 0 +\
        #     phi[0] * y_liq[0] + \
        #     phi[1] * 0/1 +\
        #     phi[2] * 1/4 +\
        #     phi[3] * 1/2 +\
        #     phi[4] * 2/3 +\
        #     phi[5] * 6/7 +\
        #     phi[6] * 1/1 -\
        #     x0

        g_al = 0 +\
            phi[0] * (P * y_liq[0]) +\
            phi[1] * 0 +\
            phi[2] * 2 +\
            phi[3] * 2 +\
            phi[4] * 4 +\
            phi[5] * 12 +\
            phi[6] * 2 - n0_al

        g_ca = 0 +\
            phi[0] * (P * y_liq[1]) +\
            phi[1] * 1 +\
            phi[2] * 3 +\
            phi[3] * 1 +\
            phi[4] * 1 +\
            phi[5] * 1 +\
            phi[6] * 0 - n0_ca

        g_oo = 0 +\
            phi[0] * (Q * 1) +\
            phi[1] * 1 +\
            phi[2] * 6 +\
            phi[3] * 4 +\
            phi[4] * 7 +\
            phi[5] * 19 +\
            phi[6] * 3 - n0_oo

        self._make_solver(
            x=vertcat(phi, y_liq),
            p=vertcat(self._T, x0),
            f=phi.T @ G,
            g=vertcat(g0, g_al, g_ca, g_oo),
            verbosity=verbosity,
            max_iter=max_iter
        )

    def compute_equilibrium(
        self,
        T: float,
        x0: float,
        guess: list[float] = None,
        tol: float = 1.0e-12
    ) -> tuple[dict[str, DM], Capturing]:
        """ Evaluate phase equilibrium at given temperature. """
        guess = guess if guess is not None else self.guess
        rets = super().compute_equilibrium([T, x0], guess=guess, tol=tol)
        solution, output = rets
        return solution, output

    @property
    def no_phases(self):
        """ Number of phases (liquid, pure substances, intermediates). """
        return len(self.phases)

    @property
    def phases(self):
        """ Names of phases in system. """
        return ["LIQUID", "CaO", "C3A1", "C1A1", "C1A2", "C1A6", "Al2O3"]

    @property
    def variables(self):
        return [*self.phases, "y(LIQUID,AL3+)", "y(LIQUID,CA2+)"]

    @property
    def guess(self):
        """ Initialize properly sized initial guess. """
        return np.ones(len(self.phases) + 2)
