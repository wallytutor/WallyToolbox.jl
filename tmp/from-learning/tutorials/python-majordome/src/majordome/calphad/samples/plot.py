# -*- coding: utf-8 -*-
from casadi import Function
import matplotlib.pyplot as plt
import numpy as np
from ..database import parse_database
from ..plot import plot_molar_gibbs_energy


def plot_pure_al2o3_gibbs():
    """ Wrapper to eliminate global symbols. """
    known = parse_database()

    T = known["T"]
    G0 = Function("G0", [T], [known["G(ALPHA_AL2O3,AL2O3)"]])
    G1 = Function("G1", [T], [known["G(LIQUID,AL2O3)"]])

    T_num = np.linspace(300.0, 4000.0, 1000)
    plots = {"$\\alpha$": G0(T_num) / 1_000_000,
             "Liquid": G1(T_num) / 1_000_000}

    plot_molar_gibbs_energy(T_num, plots)


def plot_pure_cao_gibbs():
    """ Wrapper to eliminate global symbols. """
    known = parse_database()

    T = known["T"]
    G0 = Function("G0", [T], [known["G(CA1O1,CA1O1)"]])
    G1 = Function("G1", [T], [known["G(LIQUID,CA1O1)"]])

    T_num = np.linspace(300.0, 4000.0, 1000)
    plots = {"$CaO$": G0(T_num) / 1_000_000,
             "Liquid": G1(T_num) / 1_000_000}

    plot_molar_gibbs_energy(T_num, plots)


def plot_pure_sio2_gibbs():
    """ Wrapper to eliminate global symbols. """
    known = parse_database()

    T = known["T"]
    G0 = Function("G0", [T], [known["G(QUARTZ,SI1O2)"]])
    G1 = Function("G1", [T], [known["G(TRIDYMITE,SI1O2)"]])
    G2 = Function("G2", [T], [known["G(CRISTOBALITE,SI1O2)"]])
    G3 = Function("G3", [T], [known["G(LIQUID,SI1O2)"]])

    T_num = np.linspace(300.0, 4000.0, 1000)
    plots = {"Quartz": G0(T_num) / 1_000_000,
             "Tridymite": G1(T_num) / 1_000_000,
             "Cristobalite": G2(T_num) / 1_000_000,
             "Liquid": G3(T_num) / 1_000_000}

    plot_molar_gibbs_energy(T_num, plots)


def plot_liquid_and_residual(table, xlim):
    """ Standardize plots for sample codes. """
    x = table["T"].to_numpy()
    y = table["X(LIQ)"].to_numpy()
    z = np.log10(table["res"].to_numpy())

    plt.close("all")
    plt.style.use("seaborn-white")
    fig, ax = plt.subplots(1, 2, figsize=(12, 5), dpi=100)
    ax[0].plot(x, y)
    ax[1].plot(x, z)
    ax[0].grid(linestyle=":")
    ax[1].grid(linestyle=":")
    ax[0].set_xlabel("Temperature [K]")
    ax[1].set_xlabel("Temperature [K]")
    ax[0].set_ylabel("Liquid fraction")
    ax[1].set_ylabel("$\\log_{10}\\varepsilon$")
    ax[0].set_xlim(xlim)
    fig.tight_layout()
