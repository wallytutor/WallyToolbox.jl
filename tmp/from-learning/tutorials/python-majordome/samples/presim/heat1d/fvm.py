# -*- coding: utf-8 -*-
from IPython import embed
from presim.heat1d.material import Dummy
from presim.heat1d.material import Steel
from presim.heat1d.material import PP304
from presim.heat1d.linspace import Linspace
from presim.heat1d.linspace import NumericalMethod
from presim.heat1d.fvm import BoundaryType
from presim.heat1d.fvm import Heat1DFVM
import numpy as np
import matplotlib.pyplot as plt
from utils import htc
from utils import tinf
from utils import initial_profile
from utils import get_attribute


def plot_results(linspace, results, loc):
    """ Display calculation results in a standardized fashion. """
    x = linspace.linspace
    t = get_attribute(results, "time")

    plt.close("all")
    plt.style.use("seaborn-white")
    plt.figure(figsize=(12, 8))

    ax = plt.subplot(2, 3, 1)
    plt.plot(x, results[0].temperature - 273.15, label="Initial")
    plt.plot(x, results[-1].temperature - 273.15, label="Final")
    plt.xlabel("Position [cm]")
    plt.ylabel("Temperature [°C]")
    plt.legend(loc=loc)
    plt.grid(linestyle=":")

    ax = plt.subplot(2, 3, 2)
    plt.plot(t, get_attribute(results, "nl_iter"))
    plt.xlabel("Time [s]")
    plt.ylabel("NL Iterations")
    plt.grid(linestyle=":")

    ax = plt.subplot(2, 3, 3, sharex=ax)
    plt.plot(t, get_attribute(results, "nl_tries"))
    plt.xlabel("Time [s]")
    plt.ylabel("NL Trials")
    plt.grid(linestyle=":")

    ax = plt.subplot(2, 3, 4, sharex=ax)
    plt.semilogy(t, get_attribute(results, "atol"), label="Absolute")
    plt.semilogy(t, get_attribute(results, "rtol"), label="Relative")
    plt.xlabel("Time [s]")
    plt.ylabel("Residual")
    plt.legend(loc=1)
    plt.grid(linestyle=":")

    ax = plt.subplot(2, 3, 5, sharex=ax)
    plt.plot(t, get_attribute(results, "step"))
    plt.xlabel("Time [s]")
    plt.ylabel("Time-step [s]")
    plt.grid(linestyle=":")

    ax = plt.subplot(2, 3, 6, sharex=ax)
    plt.plot(t, get_attribute(results, "enthalpy"))
    plt.xlabel("Time [s]")
    plt.ylabel("Enthalpy [J/m²]")
    plt.grid(linestyle=":")

    plt.tight_layout()
    plt.show()


def case_dummy(tend=1.0, thick=0.01, cell=1.0e-03, T=600.0):
    """  Simulate a dummy case for solver debugging. """
    dummy = Dummy()
    # dummy = Steel()
    
    temperature = initial_profile(thick, thick, cell, 2 * T, T)

    linspace = Linspace([(thick * 2 * 2, dummy)], cell,
                        method=NumericalMethod.FINITE_VOLUME,
                        T=temperature)

    # solver = Heat1DFVM(linspace,
    #                    upper_bound=BoundaryType.CONVECTION,
    #                    lower_bound=BoundaryType.SYMMETRY,
    #                    upper_bound_htc=lambda _: 1000.0,
    #                    upper_bound_tinf=lambda _: 300.0)
    solver = Heat1DFVM(linspace,
                       upper_bound=BoundaryType.SYMMETRY,
                       lower_bound=BoundaryType.SYMMETRY)

    solver.DEBUG = True

    results = solver.solve(tend, temperature, maxsteps=100,
                           atol=0.05, rtol=1.0e-06, tau_scale=0.001,
                           tau_scale_min=0.0001)

    plot_results(linspace, results, loc=2)

    embed(colors="Linux")


def simulate_fvm(steel_thick: float, pp304_thick: float, T_sol: float,
                 T_liq: float, cell: float, omega: float, timm: float):
   # Create materials for stacking.
    steel = Steel()
    pp304 = PP304()

    # Set materials to twice target thick (mirror).
    steel_layer = (steel_thick * 2, steel)
    pp304_layer = (pp304_thick * 2, pp304)

    # Compute initial temperature profile.
    temperature = initial_profile(steel_thick, pp304_thick, cell, T_sol, T_liq)

    order = "LR"

    if order == "LR":
        # Inverse temperature.
        temperature = temperature[::-1]

        # Legend location.
        loc = 2

        # Create linear space for solver.
        linspace = Linspace([steel_layer, pp304_layer], cell,
                            method=NumericalMethod.FINITE_VOLUME,
                            T=temperature)

        # Create simulation object.
        solver = Heat1DFVM(linspace,
                           upper_bound=BoundaryType.CONVECTION,
                           lower_bound=BoundaryType.SYMMETRY,
                           upper_bound_htc=htc, upper_bound_tinf=tinf)
    else:
        # Legend location.
        loc = 1

        # Create linear space for solver.
        linspace = Linspace([pp304_layer, steel_layer], cell,
                            method=NumericalMethod.FINITE_VOLUME,
                            T=temperature)

        # Create simulation object.
        solver = Heat1DFVM(linspace,
                           upper_bound=BoundaryType.SYMMETRY,
                           lower_bound=BoundaryType.CONVECTION,
                           lower_bound_htc=htc, lower_bound_tinf=tinf)

    # Run simulation over time.
    results = solver.solve(timm, temperature, maxsteps=100,
                           atol=0.1, rtol=1.0e-01, tau_scale=1)

    plot_results(linspace, results, loc)

    embed(colors="Linux")


if __name__ == "__main__":
    case_dummy(tend=1.0, thick=0.006, cell=1.0e-03, T=600.0)

    # # Roll radius, semi-gap, and bed semi-width.
    # R = 0.325 / 2
    # g = 0.004 / 2
    # w = 0.050 / 2

    # # Roll angular velocity [rad/s].
    # omega = 4 * 2 * np.pi / 60

    # # Submerged arc angle w.r.t. roll center.
    # theta = np.arccos((R + g - w) / R)

    # # Immersion time.
    # timm = theta / omega

    # # Declare temperature of phases.
    # T_liq = 273.15 + 1450.0
    # T_sol = 273.15 + 30.0

    # # Declare dimensions of systems.
    # steel_thick = 0.0135
    # pp304_thick = 0.0100

    # # Declare cell length.
    # cell = 1.0e-03

    # # Simulate with FVM solver.
    # simulate_fvm(steel_thick, pp304_thick, T_sol, T_liq, cell, omega, timm)