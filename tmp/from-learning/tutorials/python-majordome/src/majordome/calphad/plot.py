# -*- coding: utf-8 -*-
from typing import Optional
from matplotlib.figure import Figure
import matplotlib.pyplot as plt
from ..definitions import FigSize


def plot_molar_gibbs_energy(T: list[float], plots: dict[str, list[float]],
                            figsize: Optional[FigSize] = (6, 5)) -> Figure:
    """ Plot molar Gibbs energy against temperature.

    Parameters
    ----------
    T: list[float]
        Temperature points in kelvin at which energy is evaluated.
    plots: dict[str, list[float]]
        Dictionary associating plot labels to plot data (must have same
        length as `T`). Values are expected in mega-joules per mole.
    figsize: Optional[FigSize] = (6, 5)
        Figure size to be provided to `matplotlib.

    Returns
    -------
    Figure
        A `matplotlib` figure for further manipulation/dumping.
    """
    plt.close("all")
    plt.style.use("seaborn-white")
    fig = plt.figure(figsize=figsize)

    for label, gm in plots.items():
        plt.plot(T, gm, label=label)

    plt.grid(linestyle=":")
    plt.xlabel("Temperature [K]")
    plt.ylabel("Molar Gibbs Energy [MJ/mol]")
    plt.legend(loc=1, frameon=True)
    plt.tight_layout()

    return fig
