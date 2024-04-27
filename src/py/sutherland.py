# -*- coding: utf-8 -*-
from pathlib import Path
from typing import Optional
from scipy.optimize import curve_fit
import textwrap
import numpy as np
import cantera as ct
import matplotlib.pyplot as plt

from utilities import progress_bar


def fit_sutherland(
        mechanism: str, 
        space: Optional[tuple[float, float, float]] = (300, 3000, 100),
        phase: Optional[str] = "gas", 
        plot_all: Optional[bool] = True, 
        outdir: Optional[str] = "results",
        P: Optional[float] = ct.one_atm,
        scale: Optional[float] = 1.0e+06
    ) -> None:
    """ Fit Sutherland parameters for all species in mechanism.

    Reads ideal gas phase mechanism with `cantera.Solution`. The
    routine will fit the viscosity of each species in mechanism
    to Sutherland parameters with `sutherland`. As output, a 
    file `coefficients.txt` is provided for further processing
    by user for mechanism conversion to OpenFOAM format.

    Parameters
    ----------
    mechanism : str
        Path to Cantera mechanism file in standard format.
    space : Optional[tuple[float, float, float]] = (300, 3000, 100)
        Arguments of `numpy.linspace` with low and high temperatures
        followed by the number of sampling points for fitting.
    phase : Optional[str] = "gas"
        Name of phase in Cantera mechanism file.
    plot_all: Optional[bool] = True
        Flag to control plotting of all fittings for validation.
    outdir: Optional[str] = "results"
        Directory path where plots and coefficients are dumped.
    P: Optional[float] = ct.one_atm
        Pressure for computing viscosity (should be unnecessary).
    scale: Optional[float] = 1.0e+06
        Scaling factor for viscosity in plots (if `plot_all=True`).
    """
    temps = np.linspace(*space)
    gas = ct.Solution(mechanism, phase)
    sol = ct.SolutionArray(gas, shape=temps.shape)
    mu = {}

    # TODO disallow dumping in CWD or same folder as mechanism.
    results = Path(outdir)
    results.mkdir(exist_ok=True, parents=True)

    for species in progress_bar(gas.species_names):
        pars = _get_parameters(sol, temps, species, P)
        mu[species], viscosity = pars

        if plot_all:
            fig = _plot_viscosity(
                species, 
                temps, 
                scale * viscosity, 
                scale * sutherland(temps, *mu[species])
            )
            fig.savefig(results / species, dpi=300)

    _dump_coeffs(results / "coefficients.txt", mu)


def sutherland(T: list[float], As: float, Ts: float) -> list[float]:
    """ Sutherland transport parametric model as used in OpenFOAM.

    Function provided to be used in curve fitting to establish Sutherland
    coefficients from data computed by Cantera using Lennard-Jones model.
    Reference: https://cfd.direct/openfoam/user-guide/thermophysical.

    Parameters
    ----------
    T : List[float]
        Temperature array given in kelvin.
    As : float
        Sutherland coefficient.
    Ts : float
        Sutherland temperature.

    Returns
    -------
    List[float]
        The viscosity in terms of temperature.
    """
    return As * np.sqrt(T) / (1 + Ts / T)


def _get_parameters(sol, temperatures, species, P):
    """ Helper for fitting/computing viscosity. """
    sol.TPX = temperatures, P, {species: 1.0}
    
    # Make p0 a parameters for general use.
    popt, _ = curve_fit(
        f=sutherland,
        xdata=temperatures, 
        ydata=sol.viscosity,
        p0=(1.0e-06, 70)
    )

    return list(popt), sol.viscosity


def _plot_viscosity(species, T, mod_lj, mod_su):
    """ Helper for plotting viscosity for validation. """
    plt.close("all")
    plt.style.use("seaborn-white")
    fig = plt.figure()
    plt.title(species)
    plt.plot(T, mod_lj, "k-", label="Lennard-Jonnes")
    plt.plot(T, mod_su, "r:", label="Sutherland")
    plt.grid(linestyle=":")
    plt.xlabel("Temperature ($K$)")
    plt.ylabel("Viscosity ($\\mu{}Pa\\,s$)")
    plt.title(f"Species {species}")
    plt.legend()
    fig.tight_layout()
    return fig


def _dump_coeffs(saveas, mu):
    """ Helper for dumping coefficients dictionary. """
    fmt = textwrap.dedent("""
        "{}"
        {{
            transport
            {{
                As  {:.10e};
                Ts  {:.10e};
            }}
        }}
        """)

    with open(saveas, "w") as writer:
        for k, v in mu.items():
            writer.write(fmt.format(k, *v))
