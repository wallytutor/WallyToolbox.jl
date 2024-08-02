# -*- coding: utf-8 -*-
from IPython import embed
from presim.heat1d.material import Steel
from presim.heat1d.material import PP304
from presim.heat1d import Heat1D
import numpy as np
import matplotlib.pyplot as plt
from utils import htc
from utils import tinf
from utils import initial_profile


def simulate_case_immersion(steel_thick: float, pp304_thick: float,
                            cell: float, tend: float, T: list[float]
                            ) -> tuple[list[float], list[float]]:
    """ Compute profile during a single immersion. """
   # Create materials for stacking.
    steel = Steel()
    pp304 = PP304()

    # Set materials to twice target thick (mirror).
    steel_layer = (steel_thick * 2, steel)
    pp304_layer = (pp304_thick * 2, pp304)

    # Stack materials from symmetry to surface.
    layers = [pp304_layer, steel_layer]

    # Assembly problem and solve.
    heat = Heat1D(layers, T, htc, tinf, cell=cell)
    heat.solve(tend=tend, eps=1.0e-06)

    return heat.results_profile


def mesh_convergence(steel_thick: float, pp304_thick: float, T_sol: float,
                     T_liq: float, cells, tend: float) -> None:
    """ Mesh convergence study for validation of cell length. """
    plt.close("all")
    plt.style.use("seaborn-white")

    for k, cell in enumerate(cells):
        print(f"\nRunning case {k}")
        T = initial_profile(steel_thick, pp304_thick, cell, T_sol, T_liq)
        x, T = simulate_case_immersion(steel_thick, pp304_thick, cell, tend, T)
        plt.plot(100 * x, T[::-1] - 273.15, label=f"{cell:.6f}")

    plt.xlabel("Position [cm]")
    plt.ylabel("Temperature [°C]")
    plt.legend(loc=2)
    plt.grid(linestyle=":")
    plt.axvline(100 * steel_thick, color="r")
    plt.tight_layout()
    plt.show()


def simulate_steady(steel_thick: float, pp304_thick: float, T_sol: float,
                    T_liq: float, cell: float, omega: float, timm: float
                    ) -> None:
    """ Main application routine for simulation of roll steady temperature. """
    T = initial_profile(steel_thick, pp304_thick, cell, T_sol, T_liq)

    # x, T = simulate_case_immersion(steel_thick, pp304_thick, cell, timm, T)

    # # Display results graphically.
    # plt.close("all")
    # plt.style.use("seaborn-white")
    # plt.plot(100 * x, T[::-1] - 273.15)
    # plt.xlabel("Position [cm]")
    # plt.ylabel("Temperature [°C]")
    # plt.grid(linestyle=":")
    # plt.axvline(100 * steel_thick, color="r")
    # plt.tight_layout()
    # plt.show()


if __name__ == "__main__":
    # Roll radius, semi-gap, and bed semi-width.
    R = 0.325 / 2
    g = 0.004 / 2
    w = 0.050 / 2

    # Roll angular velocity [rad/s].
    omega = 4 * 2 * np.pi / 60

    # Submerged arc angle w.r.t. roll center.
    theta = np.arccos((R + g - w) / R)

    # Immersion time.
    timm = theta / omega

    # Declare temperature of phases.
    T_liq = 273.15 + 1450.0
    T_sol = 273.15 + 30.0

    # Declare dimensions of systems.
    steel_thick = 0.0135
    pp304_thick = 0.0100

    # Declare cell length.
    cell = 1.0e-05

    # cells = [1.0e-05, 1.0e-04, 1.0e-03]
    # cells = [1.0e-04, 5.0e-04, 1.0e-03]
    # mesh_convergence(steel_thick, pp304_thick, T_sol, T_liq, cells, timm)

    # simulate_steady(steel_thick, pp304_thick, T_sol, T_liq, cell, omega, timm)
    # embed(colors="Linux")
