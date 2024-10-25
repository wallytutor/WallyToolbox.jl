# -*- coding: utf-8 -*-
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from .cases import PureAL2O3
from .cases import PureCAO
from .cases import PureSIO2
from .cases import PureC1A1
from .cases import PureC1A2
from .cases import PureC12A7
from .plot import plot_liquid_and_residual


def simulate_pure_al2o3():
    """ Wrapper to eliminate global symbols. """
    ce = PureAL2O3()
    guess = [1.0, 1.0]
    table = pd.DataFrame(columns=["T", "X(LIQ)", "res"])

    for k, temp in enumerate(np.linspace(2300.0, 2350.0, 100)):
        solution, _ = ce.compute_equilibrium(temp, guess=guess)
        guess = solution["x"].full().ravel()
        table.loc[k] = [temp, guess[1], sum(guess) - 1.0]

    plot_liquid_and_residual(table, (2300.0, 2350.0))


def simulate_pure_cao():
    """ Wrapper to eliminate global symbols. """
    ce = PureCAO()
    guess = [1.0, 1.0]
    table = pd.DataFrame(columns=["T", "X(LIQ)", "res"])

    for k, temp in enumerate(np.linspace(3150.0, 3200.0, 100)):
        solution, _ = ce.compute_equilibrium(temp, guess=guess)
        guess = solution["x"].full().ravel()
        table.loc[k] = [temp, guess[1], sum(guess) - 1.0]

    plot_liquid_and_residual(table, (3150.0, 3200.0))


def simulate_pure_sio2():
    """ Wrapper to eliminate global symbols. """
    ce = PureSIO2()
    guess = [1.0, 1.0, 1.0, 1.0]
    phases = ["QUARTZ", "TRIDYMITE", "CRISTOBALITE", "LIQUID"]
    table = pd.DataFrame(columns=["T", *phases, "res"])

    for k, temp in enumerate(np.linspace(1000.0, 2200.0, 1000)):
        solution, _ = ce.compute_equilibrium(temp, guess=guess)
        guess = solution["x"].full().ravel()
        table.loc[k] = [temp, *guess, sum(guess) - 1.0]

    x = table["T"].to_numpy()
    y0 = table[phases[0]].to_numpy()
    y1 = table[phases[1]].to_numpy()
    y2 = table[phases[2]].to_numpy()
    y3 = table[phases[3]].to_numpy()

    plt.close("all")
    plt.style.use("seaborn-white")
    fig, ax = plt.subplots(1, 2, figsize=(12, 5), dpi=100)
    ax[0].plot(x, y0, label=phases[0])
    ax[0].plot(x, y1, label=phases[1])
    ax[0].plot(x, y2, label=phases[2])
    ax[0].plot(x, y3, label=phases[3])
    ax[1].plot(x, np.log10(table["res"].to_numpy()))
    ax[0].grid(linestyle=":")
    ax[1].grid(linestyle=":")
    ax[0].set_xlabel("Temperature [K]")
    ax[1].set_xlabel("Temperature [K]")
    ax[0].set_ylabel("Phase fraction")
    ax[1].set_ylabel("$\\log_{10}\\varepsilon$")
    ax[0].set_xlim((1000.0, 2200.0))
    ax[0].legend(loc=4)
    fig.tight_layout()


def simulate_pure_c1a1():
    """ Wrapper to eliminate global symbols. """
    ce = PureC1A1()
    guess = [1.0, 1.0, 1.0, 1.0]
    table = pd.DataFrame(columns=["T", "N(C1A1)", "N(LIQ)", "res"])

    for k, temp in enumerate(np.linspace(1870.0, 1880.0, 100)):
        solution, _ = ce.compute_equilibrium(temp, guess=guess)
        guess = solution["x"].full().ravel()
        table.loc[k] = [temp, *guess[:2], sum(guess[2:]) - 1]

    # Since we are working with amounts of phase, in this case we
    # need to perform some post-processing.
    n_moles = table["N(C1A1)"] + table["N(LIQ)"]
    table["X(C1A1)"] = table["N(C1A1)"] / n_moles
    table["X(LIQ)"] = table["N(LIQ)"] / n_moles

    plot_liquid_and_residual(table, (1870.0, 1880.0))


def simulate_pure_c1a2():
    """ Wrapper to eliminate global symbols. """
    ce = PureC1A2()
    guess = [1.0, 1.0, 1.0, 1.0]
    table = pd.DataFrame(columns=["T", "N(C1A2)", "N(LIQ)", "res"])

    for k, temp in enumerate(np.linspace(2040.0, 2060.0, 200)):
        solution, _ = ce.compute_equilibrium(temp, guess=guess)
        guess = solution["x"].full().ravel()
        table.loc[k] = [temp, *guess[:2], sum(guess[2:]) - 1]

    # Since we are working with amounts of phase, in this case we
    # need to perform some post-processing.
    n_moles = table["N(C1A2)"] + table["N(LIQ)"]
    table["X(C1A2)"] = table["N(C1A2)"] / n_moles
    table["X(LIQ)"] = table["N(LIQ)"] / n_moles

    plot_liquid_and_residual(table, (2040.0, 2060.0))


def simulate_pure_c12a7():
    """ Wrapper to eliminate global symbols. """
    ce = PureC12A7()
    guess = [1.0, 1.0, 1.0, 1.0]
    table = pd.DataFrame(columns=["T", "N(C12A7)", "N(LIQ)", "res"])
    rng = (1715.0, 1735.0)

    for k, temp in enumerate(np.linspace(*rng, 100)):
        solution, _ = ce.compute_equilibrium(temp, guess=guess)
        guess = solution["x"].full().ravel()
        table.loc[k] = [temp, *guess[:2], sum(guess[2:]) - 1]

    # Since we are working with amounts of phase, in this case we
    # need to perform some post-processing.
    n_moles = table["N(C12A7)"] + table["N(LIQ)"]
    table["X(C12A7)"] = table["N(C12A7)"] / n_moles
    table["X(LIQ)"] = table["N(LIQ)"] / n_moles

    plot_liquid_and_residual(table, rng)
