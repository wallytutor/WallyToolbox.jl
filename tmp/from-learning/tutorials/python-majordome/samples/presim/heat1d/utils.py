# -*- coding: utf-8 -*-
import numpy as np


def tinf(_: float) -> float:
    """ Environment temperature [K]. """
    return 298.15


def htc(_: float) -> float:
    """ Heat transfer coefficient [W/(m.K)]. """
    return 1920.0


def get_attribute(iterator, name):
    """ Retrieve named attribute from a list of objects. """
    return np.array(list(map(lambda x: getattr(x, name), iterator)))


def initial_profile(steel_thick: float, pp304_thick: float, cell: float,
                    T_sol: float, T_liq: float) -> list[float]:
    """ Compute number of cells to initialize temperature profile. """
    def ensure_even(n: int) -> int:
        """ Compute number of cells as Heat1D. """
        return n + 1 if n % 2 else n

    thick = steel_thick + pp304_thick
    no_cells = ensure_even(int(thick / cell))
    no_cells_pp304 = ensure_even(int(pp304_thick / cell))

    print("No. of cells (total)", no_cells)
    print("No. of cells (PP304)", no_cells_pp304)

    T = T_liq * np.ones(no_cells)
    T[no_cells_pp304:] = T_sol

    return T


