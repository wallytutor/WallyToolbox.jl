# -*- coding: utf-8 -*-
""" decomposicao_metanol_equilibrio.py """
import cantera as ct

T = 900 + 273.15   # [K]
P = ct.one_atm     # [Pa]
X = {'CH3OH': 1}   # [-]

gas = ct.Solution('gri30.cti')
gas.TPX = T, P, X

gas.equilibrate('TP')
print(gas.report())
