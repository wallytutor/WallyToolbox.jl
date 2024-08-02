# -*- coding: utf-8 -*-
import numpy as np


def discretize_length(method=None, Lx=None, nx=None, xw=None):
    """ Geometric discretization of space of given length. """
    # These are the end-points of cells (one extra node!).
    if xw is None and method == "Geometric":
        xw = np.geomspace(1.0, Lx + 1.0, num=nx + 1) - 1.0
    elif xw is None and method == "Linear":
        xw = np.linspace(0.0, Lx, num=nx + 1)

    # These are the center-points of cells.
    xp = 0.5 * (xw[:-1] + xw[1:])

    # These are the lenghts of cells.
    dx = xw[1:] - xw[:-1]

    return xp, dx


def resistance_kiln_wall_direct(r0, r1, r2, L, k0, k1, h1=10.0):
    """ Thermal resistance of a thick wall in cylindric coordinates. """
    b0 = np.log(r1 / r0) / k0
    b1 = np.log(r2 / r1) / k1
    b2 = 1.0 / (r2 * h1)
    return (b0 + b1 + b2) / (2 * np.pi * L)


def resistance_kiln_wall_inverse(r0, r1, r2, L, k0, k1):
    """ Thermal resistance of a thick wall in cylindric coordinates. """
    b0 = np.log(r1 / r0) / k0
    b1 = np.log(r2 / r1) / k1
    return (b0 + b1) / (2 * np.pi * L)
