# -*- coding: utf-8 -*-
from dataclasses import dataclass
from typing import Union
from casadi import heaviside
from casadi import log
from casadi import SX


@dataclass
class DataGHSER:
    """ Data for computing GHSER function. """
    T0: float = 0.0
    a: float = 0.0
    b: float = 0.0
    c: float = 0.0
    d: float = 0.0
    e: float = 0.0
    f: float = 0.0

    def eval(self, T: float) -> float:
        """ Gibbs energy minus reference state enthalpy. """
        return (self.a + self.b * T + self.c * T * log(T) +
                self.d * T ** 2 + self.e * T ** 3 + self.f / T)


class StepwiseGHSER:
    """ Assembly stepwise symbolic GHSER function. """
    def __init__(self, T: SX, plist: list[Union[DataGHSER, dict]]) -> None:
        self.p = 0.0

        # Make sure list is sorted by start temperature.
        plist = sorted(plist, key=lambda x: x["T0"])

        for k, p in enumerate(plist):
            if not isinstance(p, DataGHSER):
                p = DataGHSER(**p)

            if k == 0:
                self.p = p.eval(T)
            else:
                self.p += heaviside(T - p.T0) * (p.eval(T) - self.p)

    @property
    def value(self) -> SX:
        """ Retrieve symbolic stepwise GHSER function. """
        return self.p
