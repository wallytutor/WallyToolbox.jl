# -*- coding: utf-8 -*-
from typing import Optional
from matplotlib.figure import Figure
import matplotlib.pyplot as plt
import pandas as pd
from ...definitions import FigSize
from .base_system import BaseSystem


def scan_binary(
    sim: BaseSystem,
    T: list[float],
    x: list[float],
    xname: str,
    ncols: Optional[int] = 4,
    figsize: Optional[FigSize] = (20, 12),
    xlim: Optional[FigSize] = None,
    post: Optional[bool] = False
) -> tuple[dict[int, pd.DataFrame], Figure]:
    """ Scan binary system and plot phase fration diagrams. """
    frames = {}
    guess = sim.guess
    nrows = len(x) // ncols

    plt.close("all")
    plt.style.use("seaborn-white")
    fig, axs = plt.subplots(nrows, ncols, figsize=figsize,
                            sharex=True, sharey=True)

    for i, xi in enumerate(x):
        column = []
        ax = axs[i // ncols, i % ncols]

        for Tj in T:
            row, guess, _ = ce_at_point(sim, Tj, xi, guess)
            column.append(row)

        frames[i] = pd.DataFrame(column)

        if post:
            # Convert moles to phase fraction.
            phase_slice = slice(1, 1 + sim.no_phases)
            block = frames[i].iloc[:, phase_slice]
            moles = block.sum(axis=1)
            frames[i].iloc[:, phase_slice] = block.div(moles, axis=0)

        frames[i].iloc[:, :sim.no_phases + 1].plot(x="T", ax=ax)
        ax.set_title(f"N({xname}) = {xi:.3f}")
        ax.set_xlabel("Temperature [K]")

        if xlim is not None:
            ax.set_xlim(*xlim)

        ax.grid(linestyle=":")

        if not i % ncols and post:
            ax.set_ylabel("Phase fraction")
        elif not i % ncols:
            ax.set_ylabel("Moles")

    fig.tight_layout()

    return frames, fig


def ce_at_point(sim, T, x, guess, tol=1.0e-12):
    """ Wrapper to compute equilibrim and generate table row. """
    solution, output = sim.compute_equilibrium(T, x, guess=guess, tol=tol)

    new_guess = solution["x"].full().ravel()

    row = {"T": T, **dict(zip(sim.variables, new_guess))}

    return row, new_guess, output
