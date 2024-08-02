# -*- coding: utf-8 -*-
from IPython import embed
import cantera as ct
import numpy as np
import matplotlib.pyplot as plt


def get_pure_substance(species, name):
    """ Get solution with a single species. """
    return ct.Solution(thermo="IdealGas", species=[species[name]])


def plot_species_properties(T, species, name):
    """ Plot species specific heat for module validation. """
    gas = get_pure_substance(species, name)
    sol = ct.SolutionArray(gas, shape=T.shape)
    sol.TP = T, ct.one_atm

    cp = sol.cp_mole / 1000
    h = sol.enthalpy_mole / 1000e3

    print(f"Specific heat of {name} at 500 K is {cp[0]} J/(mol.K)")
    print(f"Enthalpy of {name} at 500 K is {h[0]} kJ/mol")

    plt.close("all")
    plt.style.use("seaborn-white")
    plt.figure(figsize=(12, 5))

    plt.subplot(121)
    plt.plot(T, cp)
    plt.grid(linestyle=":")
    plt.xlabel("Temperature [K]")
    plt.ylabel("Specific heat [$J/(mol.K)$]")

    plt.subplot(122)
    plt.plot(T, h)
    plt.grid(linestyle=":")
    plt.xlabel("Temperature [K]")
    plt.ylabel("Specific enthalpy [$kJ/mol$]")

    plt.tight_layout()
    plt.savefig(f"plots/properties_{name}_cantera", dpi=200)


def balance_combustion(species):
    """ Compute enthalpy change at reference. """
    h = 0.0

    gas = get_pure_substance(species, "CH4")
    gas.TP = 298.15, ct.one_atm
    h -= 1 * gas.enthalpy_mole

    gas = get_pure_substance(species, "O2")
    gas.TP = 298.15, ct.one_atm
    h -= 2 * gas.enthalpy_mole

    gas = get_pure_substance(species, "H2O")
    gas.TP = 298.15, ct.one_atm
    h += 2 * gas.enthalpy_mole

    gas = get_pure_substance(species, "CO2")
    gas.TP = 298.15, ct.one_atm
    h += 1 * gas.enthalpy_mole

    print(h / 1e6)


species = {s.name: s for s in ct.Species.listFromFile("gri30.yaml")}

T = np.linspace(500, 3000, 1000)
plot_species_properties(T, species, "H")
plot_species_properties(T, species, "C")
plot_species_properties(T, species, "N")
plot_species_properties(T, species, "O")
plot_species_properties(T, species, "AR")
plot_species_properties(T, species, "H2")
plot_species_properties(T, species, "N2")
plot_species_properties(T, species, "O2")
plot_species_properties(T, species, "CO")
plot_species_properties(T, species, "CO2")
plot_species_properties(T, species, "CH4")
plot_species_properties(T, species, "H2O")

balance_combustion(species)

embed(colors="Linux")
