# -*- coding: utf-8 -*-

# Import Python built-in modules.
from io import StringIO
from textwrap import dedent

# Import external modules.
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# Own imports.
from ..materials import ThermoSi1O2


def validate_shomate_sio2(show: bool = True) -> None:
    """ Check implementation of Shomate's equation for SiO2. """
    data = StringIO(dedent("""\
        T,cp,s,dg,dh
        298.0,44.57,41.44,41.47,-0.01
        300.0,44.77,41.74,41.47,0.08
        400.0,53.43,55.87,43.34,5.01
        500.0,59.64,68.50,47.13,10.68
        600.0,64.42,79.81,51.65,16.89
        700.0,68.77,90.06,56.42,23.55
        800.0,73.70,99.56,61.22,30.67
        847.0,67.42,104.7,63.47,34.93
        900.0,67.95,108.8,66.02,38.51
        1000.0,68.95,116.0,70.66,45.36
        1100.0,69.96,122.6,75.09,52.30
        1200.0,70.96,128.8,79.31,59.35
        1300.0,71.96,134.5,83.34,66.50
        1400.0,72.97,139.9,87.18,73.74
        1500.0,73.97,144.9,90.87,81.09
        1600.0,74.98,149.7,94.40,88.54
        1700.0,75.98,154.3,97.79,96.08
        1800.0,76.99,158.7,101.0,103.7
        1900.0,77.99,162.9,104.2,111.5
    """))

    df = pd.read_csv(data, sep=",")
    s = ThermoSi1O2()

    T = df["T"].to_numpy()

    cp_cal = s.specific_heat_mole(T)
    dh_cal = s.enthalpy_mole(T)
    so_cal = s.entropy_mole(T)

    cp_ok = np.allclose(cp_cal, df["cp"], atol=0.01)
    dh_ok = np.allclose(dh_cal, df["dh"], atol=0.05)
    so_ok = np.allclose(so_cal, df["s"], atol=0.06)

    print(f"Validate: {cp_ok and dh_ok and so_ok}")

    if not show:
        return

    cp_cal = s.specific_heat_mass(T)
    dh_cal = s.enthalpy_mass(T)
    so_cal = s.entropy_mass(T)

    plt.close("all")
    plt.style.use("seaborn-white")
    fig, ax = plt.subplots(1, 3, figsize=(12, 4), sharex=True)

    ax[0].plot(T, cp_cal)
    ax[1].plot(T, dh_cal)
    ax[2].plot(T, so_cal)

    ax[0].grid(linestyle=":")
    ax[1].grid(linestyle=":")
    ax[2].grid(linestyle=":")

    ax[0].set_xlabel("Temperature [K]")
    ax[1].set_xlabel("Temperature [K]")
    ax[2].set_xlabel("Temperature [K]")

    ax[0].set_ylabel("$c_{P}$ [$J\cdotp{}kg^{-1}K^{-1}$]")
    ax[1].set_ylabel("$H$ [$J\cdotp{}kg^{-1}$]")
    ax[2].set_ylabel("$S$ [$J\cdotp{}kg^{-1}K^{-1}$]")

    fig.tight_layout()
    plt.show()
