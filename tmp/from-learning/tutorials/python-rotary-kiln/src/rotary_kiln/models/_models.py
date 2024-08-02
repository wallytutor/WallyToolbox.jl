# -*- coding: utf-8 -*-

# Import external modules.
import cantera as ct
import numpy as np


SIGMA = ct.stefan_boltzmann
""" Stefan-Boltzmann constant W/(m².K⁴). """


def conduction(l, k, Tu, Tv, Ru, Rv):
    """ Standard format steady radial conduction expression. """
    Tm = 0.5 * (Tu + Tv)
    km = k(Tm)
    return 2 * np.pi * l * km * (Tu - Tv) / np.log(Rv / Ru)


def convection(h, A, Tu, Tv):
    """ Standard format convection expression. """
    return h * A * (Tu - Tv)


def radiation(E, A, Tu, Tv, eu=1.0, au=1.0):
    """ Standard format radiation expression. """
    return SIGMA * E * A * (eu*Tu**4 - au*Tv**4)


def arrhenius(k0, Ea, T):
    """ Arrhenius kinetic rate at `k0` units. """
    return k0 * np.exp(-Ea / (ct.gas_constant * T / 1000.0))


def effective_thermal_conductivity(kg, ks, phi):
    """ Maxwell effective medium theory approximation. """
    fsum = 2 * kg + ks
    fdif = ks - kg

    num = fsum + 2 * phi * fdif
    den = fsum - 1 * phi * fdif

    return (num / den) * kg
