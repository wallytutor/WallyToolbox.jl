# -*- coding: utf-8 -*-
from abc import ABC
from abc import abstractmethod
from abc import abstractproperty
from typing import Optional
from casadi import DM
from casadi import SX
from casadi import nlpsol
from ...utilities import Capturing
from ..database import parse_database


class BaseSystem(ABC):
    """ Abstract base class for sample cases. """
    def __init__(self) -> None:
        self._known = parse_database()
        self._T = self._known["T"]
        self._R = self._known["R"]

    def _make_solver(self, x: SX, p: SX, f: SX, g: SX,
                     verbosity: Optional[int] = 0,
                     max_iter: Optional[int] = 10_000):
        """ Create solver for current case. """
        opts = {"ipopt": {
            "print_level": 0,
            "max_iter": 5000
        }}
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
        # TODO lbx and ubx should not be constant because for mineral
        # systems it is usually worth modeling in terms of phase contents
        # and not phase/compound fractions, generalize it!
        with Capturing() as output:
            solution = self._solver(x0=guess, p=p,
                                    lbx=0.0, ubx=1.0,
                                    lbg=0.0, ubg=tol)
        return solution, output

    @abstractproperty
    def phases(self):
        """ Initialize properly sized initial guess. """
        raise NotImplementedError("Implement in derived class.")

    @abstractproperty
    def variables(self):
        """ Initialize properly sized initial guess. """
        raise NotImplementedError("Implement in derived class.")

    @abstractproperty
    def guess(self):
        """ Initialize properly sized initial guess. """
        raise NotImplementedError("Implement in derived class.")
