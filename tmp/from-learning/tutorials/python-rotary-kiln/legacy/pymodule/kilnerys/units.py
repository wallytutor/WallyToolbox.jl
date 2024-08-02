# -*- coding: utf-8 -*-

PREF: float = 101325.0
""" Reference normal pressure [Pa]. """

TREF: float = 288.15
""" Reference normal temperature [K]. """

TKEL: float = 273.15
""" Kelvin to Celsius conversion [K]. """

RGAS: float = 8.31446261815324
""" Universal gas constant [J/(mol.K)]. """

NORMAL_CONC: float = PREF / (RGAS * TREF)
""" Normal state concentration [mol/m³]. """


def nm3h_to_kg_s(q, m):
    """ Convert [Nm³/h] to [kg/s]. """
    return NORMAL_CONC * q * m / 3.6e+06


def celsius_to_kelvin(T):
    """ Convert Celsius degrees to kelvin. """
    return T + TKEL


def kelvin_to_celsius(T):
    """ Convert kelvin to Celsius degrees. """
    return T - TKEL
