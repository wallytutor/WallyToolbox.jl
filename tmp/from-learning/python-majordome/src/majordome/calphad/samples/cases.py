# -*- coding: utf-8 -*-
from abc import ABC
from abc import abstractmethod
from casadi import DM
from casadi import SX
from casadi import log
from casadi import vertcat
from casadi import nlpsol
from ...utilities import Capturing
from ..database import parse_database


class SampleCase(ABC):
    """ Abstract base class for sample cases. """
    def __init__(self) -> None:
        self._known = parse_database()
        self._T = self._known["T"]
        self._R = self._known["R"]

    def _make_solver(self, x, p, f, g):
        """ Create solver for current case. """
        opts = {"ipopt": {"print_level": 0}}
        nlpt = {"x": x, "p": p, "f": f, "g": g}
        self._solver = nlpsol("solver", "ipopt", nlpt, opts)

    @abstractmethod
    def compute_equilibrium(
        self,
        p: list[float],
        guess: list[float],
        tol: float = 1.0e-15
    ) -> tuple[dict[str, DM], Capturing]:
        """ Evaluate phase equilibrium at given temperature. """
        with Capturing() as output:
            solution = self._solver(x0=guess, p=p,
                                    lbx=0.0, ubx=1.0,
                                    lbg=-tol, ubg=tol)
        return solution, output


class PureAL2O3(SampleCase):
    """ Compute equilibrium in pure AL2O3 system. """
    def __init__(self) -> None:
        super().__init__()

        G_AL2O3_ALPHA = self._known["G(ALPHA_AL2O3,AL2O3)"]
        G_AL2O3_LIQUID = self._known["G(LIQUID,AL2O3)"]
        phi = SX.sym("phi", 2)

        self._make_solver(
            x=phi,
            p=self._T,
            f=phi[0] * G_AL2O3_ALPHA + phi[1] * G_AL2O3_LIQUID,
            g=phi[0] + phi[1] - 1
        )

    def compute_equilibrium(
        self,
        T: float,
        guess: list[float] = [1.0, 1.0],
        tol: float = 1.0e-15
    ) -> tuple[dict[str, DM], Capturing]:
        """ Evaluate phase equilibrium at given temperature. """
        return super().compute_equilibrium([T], guess=guess, tol=tol)


class PureCAO(SampleCase):
    """ Compute equilibrium in pure CAO system. """
    def __init__(self) -> None:
        super().__init__()

        G_CAO_SOLID = self._known["G(CA1O1,CA1O1)"]
        G_CAO_LIQUID = self._known["G(LIQUID,CA1O1)"]
        phi = SX.sym("phi", 2)

        self._make_solver(
            x=phi,
            p=self._T,
            f=phi[0] * G_CAO_SOLID + phi[1] * G_CAO_LIQUID,
            g=phi[0] + phi[1] - 1
        )

    def compute_equilibrium(
        self,
        T: float,
        guess: list[float] = [1.0, 1.0],
        tol: float = 1.0e-15
    ) -> tuple[dict[str, DM], Capturing]:
        """ Evaluate phase equilibrium at given temperature. """
        return super().compute_equilibrium([T], guess=guess, tol=tol)


class PureSIO2(SampleCase):
    """ Compute equilibrium in pure SIO2 system. """
    def __init__(self) -> None:
        super().__init__()

        G = vertcat(
            self._known["G(QUARTZ,SI1O2)"],
            self._known["G(TRIDYMITE,SI1O2)"],
            self._known["G(CRISTOBALITE,SI1O2)"],
            self._known["G(LIQUID,SI1O2)"]
        )

        phi = SX.sym("phi", 4)

        self._make_solver(
            x=phi,
            p=self._T,
            f=phi.T @ G,
            g=phi[0] + phi[1] + phi[2] + phi[3] - 1
        )

    def compute_equilibrium(
        self,
        T: float,
        guess: list[float] = [1.0, 1.0, 1.0, 1.0],
        tol: float = 1.0e-15
    ) -> tuple[dict[str, DM], Capturing]:
        """ Evaluate phase equilibrium at given temperature. """
        return super().compute_equilibrium([T], guess=guess, tol=tol)


class PureC1A1(SampleCase):
    """ Compute equilibrium in pure (CAO.AL2O3) system.

    Comments
    --------
    As it is provided by (Hallstedt, 1990), Gibbs energy parameter
    G(LIQUID,CA2+:O2-) is provided for half a mole of substance. That
    implies coefficient must be multiplied by 2 in phase description.

    Since we are dealing with stoichiometric substances, it is easier
    to implement equations and checking balances if one assumes that
    total amount of substances (here Al2O3 + CaO) equal to unity and
    that system composition is initialized by `x0` being given as a
    number of moles instead of a mole fraction. This practice implies
    that the phase quantities `phi` are also given in amounts of matter
    instead of fractions.

    For ensuring the balances, we can take `x0` to be the number of
    moles of Al2O3, meaning that the system contains `2*x0` moles of
    Al. Since total system is composed of one mole, the amount of Ca
    atoms is then `1 - x0`. Similarly we get the content of O by
    using the balances of both oxides, leading to `2*x0 + 1`. Using
    site fractions and liquid model (Al3+,Ca2+)P(O2-)Q one can derive
    conservation for system after equilibrium is performed.

    Notice here that although in the implementation we constrain all
    elements, only two are necessary (quasi-binary system modeled in
    terms of oxides), thus one of then is redundant.
    """
    def __init__(self) -> None:
        super().__init__()

        G_AL2O3_LIQUID = self._known["G(LIQUID,AL2O3)"]
        G_CAO_LIQUID = self._known["G(LIQUID,CA1O1)"]
        L0_LIQUID_AL3P_CA2P = self._known["L(LIQUID,AL(3+),CA(2+);0)"]
        L1_LIQUID_AL3P_CA2P = self._known["L(LIQUID,AL(3+),CA(2+);1)"]
        G_C1A1 = self._known["G(C1A1,C1A1)"]

        x0 = SX.sym("x0")
        phi = SX.sym("phi", 2)
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

        n_moles = 1
        n0_al = 2 * x0
        n0_ca = 1 * (n_moles - x0)
        n0_oo = 3 * x0 + 1 * (n_moles - x0)

        self._make_solver(
            x=vertcat(phi, y_liq),
            p=vertcat(self._T, x0),
            f=phi[0] * G_C1A1 + phi[1] * G_LIQUID,
            g=vertcat(
                1 - (y_liq[0] + y_liq[1]),
                phi[0] * 2 + phi[1] * (P * y_liq[0]) - n0_al,
                phi[0] * 1 + phi[1] * (P * y_liq[1]) - n0_ca,
                phi[0] * 4 + phi[1] * (Q * 1) - n0_oo
            )
        )

    def compute_equilibrium(
        self,
        T: float,
        guess: list[float] = [1.0, 1.0, 1.0, 1.0],
        tol: float = 1.0e-15
    ) -> tuple[dict[str, DM], Capturing]:
        """ Evaluate phase equilibrium at given temperature. """
        return super().compute_equilibrium([T, 0.5], guess=guess, tol=tol)


class PureC1A2(SampleCase):
    """ Compute equilibrium in pure (CAO.2AL2O3) system.

    Comments
    --------
    See comments for C1A1.
    """
    def __init__(self) -> None:
        super().__init__()

        G_AL2O3_LIQUID = self._known["G(LIQUID,AL2O3)"]
        G_CAO_LIQUID = self._known["G(LIQUID,CA1O1)"]
        L0_LIQUID_AL3P_CA2P = self._known["L(LIQUID,AL(3+),CA(2+);0)"]
        L1_LIQUID_AL3P_CA2P = self._known["L(LIQUID,AL(3+),CA(2+);1)"]
        G_C1A2 = self._known["G(C1A2,C1A2)"]

        x0 = SX.sym("x0")
        phi = SX.sym("phi", 2)
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

        n_moles = 1
        n0_al = 2 * x0
        n0_ca = 1 * (n_moles - x0)
        n0_oo = 3 * x0 + 1 * (n_moles - x0)

        self._make_solver(
            x=vertcat(phi, y_liq),
            p=vertcat(self._T, x0),
            f=phi[0] * G_C1A2 + phi[1] * G_LIQUID,
            g=vertcat(
                1 - (y_liq[0] + y_liq[1]),
                phi[0] * 4 + phi[1] * (P * y_liq[0]) - n0_al,
                phi[0] * 1 + phi[1] * (P * y_liq[1]) - n0_ca,
                phi[0] * 7 + phi[1] * (Q * 1) - n0_oo
            )
        )

    def compute_equilibrium(
        self,
        T: float,
        guess: list[float] = [1.0, 1.0, 1.0, 1.0],
        tol: float = 1.0e-15
    ) -> tuple[dict[str, DM], Capturing]:
        """ Evaluate phase equilibrium at given temperature. """
        return super().compute_equilibrium([T, 2 / 3], guess=guess, tol=tol)


class PureC12A7(SampleCase):
    """ Compute equilibrium in pure (12CAO.7AL2O3) system.

    Comments
    --------
    See comments for C1A1.
    """
    def __init__(self) -> None:
        super().__init__()

        G_AL2O3_LIQUID = self._known["G(LIQUID,AL2O3)"]
        G_CAO_LIQUID = self._known["G(LIQUID,CA1O1)"]
        L0_LIQUID_AL3P_CA2P = self._known["L(LIQUID,AL(3+),CA(2+);0)"]
        L1_LIQUID_AL3P_CA2P = self._known["L(LIQUID,AL(3+),CA(2+);1)"]
        G_C12A7 = self._known["G(C12A7,C12A7)"]

        x0 = SX.sym("x0")
        phi = SX.sym("phi", 2)
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

        n_moles = 1
        n0_al = 2 * x0
        n0_ca = 1 * (n_moles - x0)
        n0_oo = 3 * x0 + 1 * (n_moles - x0)

        self._make_solver(
            x=vertcat(phi, y_liq),
            p=vertcat(self._T, x0),
            f=phi[0] * G_C12A7 + phi[1] * G_LIQUID,
            g=vertcat(
                1 - (y_liq[0] + y_liq[1]),
                phi[0] * 14 + phi[1] * (P * y_liq[0]) - n0_al,
                phi[0] * 12 + phi[1] * (P * y_liq[1]) - n0_ca,
                phi[0] * 33 + phi[1] * (Q * 1) - n0_oo
            )
        )

    def compute_equilibrium(
        self,
        T: float,
        guess: list[float] = [1.0, 1.0, 1.0, 1.0],
        tol: float = 1.0e-15
    ) -> tuple[dict[str, DM], Capturing]:
        """ Evaluate phase equilibrium at given temperature. """
        return super().compute_equilibrium([T, 7 / 19], guess=guess, tol=tol)
