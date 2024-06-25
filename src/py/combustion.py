# -*- coding: utf-8 -*-
from typing import Optional
from matplotlib.figure import Figure
import cantera as ct
import matplotlib.pyplot as plt
import numpy as np

from unit_conversion import FlowUnits


class HydrocarbonHeatingValue:
    """ Computes heating value of gas """
    def __init__(self, gas: ct.Solution) -> None:
        water = ct.Water()
        h_liq = self._water_enthalpy(water, 0.0)
        h_gas = self._water_enthalpy(water, 1.0)

        self._gas = gas
        self._hv = h_liq - h_gas

    def _water_enthalpy(self, water, Q):
        """ Compute enthalpy of water at given vapor quantity. """
        water.TQ = 298.15, Q
        return water.h

    def _heating_values(self,
            fuel: dict[str, float],
            oxid: dict[str, float],
            basis: Optional[str] = "mole"
        ) -> tuple[float, float]:
        """ Returns the LHV and HHV for the specified fuel.
        
        Implements a generalized version of Cantera's example:
        - cantera.org/examples/jupyter/thermo/heating_value.ipynb.html

        Note: there are some caveats in using this routine and the
        processing of values. In the reference example case, fuels
        are evaluated as pure substances. For real applications
        where this method is intended to be used, some species
        might be present in both fuel and oxidizer, *e.g.* carbon
        dioxide, water, and nitrogen. Thus, it has been chosen to
        compute `Y_fuel` based on the mass fraction of hydrocarbons
        in fuel only. This means that when using the heating values
        to compute required mass flow rates, one must take into
        account the contribution of those species in fuel and then
        scale according the full fuel composition.
        """
        # Set initial state with unit equivalence ratio.
        self._gas.TP = 298.15, ct.one_atm
        self._gas.set_equivalence_ratio(1.0, fuel, oxid, basis=basis)

        # Retrieve composition and enthalpy.
        Y_fuel = self.hydrocarbon_mass_fraction(self._gas, fuel)
        h1 = self._gas.enthalpy_mass

        # Set composition to complete combustion.
        X_products = self.complete_combustion_products(self._gas)
        self._gas.TPX = None, None, X_products
        
        # Retrieve composition and enthalpy.
        Y_H2O = self._gas["H2O"].Y[0]
        h2 = self._gas.enthalpy_mass

        # Apply definitions to compute heating values.
        lhv = -(h2 - h1) / (Y_fuel * 1000)
        hhv = lhv - (self._hv / 1000) * Y_H2O / Y_fuel

        return lhv, hhv

    @staticmethod
    def complete_combustion_products(
            gas: ct.Solution
        ) -> dict[str, float]:
        """ Compute expected complete combustion composition. """
        X_products = {
            "CO2": gas.elemental_mole_fraction("C"),
            "H2O": 0.5 * gas.elemental_mole_fraction("H"),
            "N2":  0.5 * gas.elemental_mole_fraction("N"),
        }
    
        # Notice the case convention for SPECIES / Element.
        if "AR" in gas.species_names:
            X_products["AR"] = gas.elemental_mole_fraction("Ar")

        # TODO add oxygen balance check here, there might be cases
        # where equivalence ratio has not been set to unit ?!?

        return X_products

    @staticmethod
    def select_hydrocarbons(
            gas: ct.Solution,
            fuel: dict[str, float] | str,
        ) -> list[str]:
        """ Select hydrocarbons present in fuel dictionary. """
        keep = []

        # Use fuel dict because if fuel is provided as a string the
        # check in loop below leads to unexpected behavior.
        X_orig = gas.X
        gas.TPX = None, None, fuel
        fuel_dict = gas.mole_fraction_dict()

        for species in gas.species():
            if species.name not in fuel_dict:
                continue

            atoms = sorted(species.composition.keys())
            if atoms == ["C", "H"] or atoms == ["H"]:
                keep.append(species.name)

        gas.TPX = None, None, X_orig

        return keep

    @staticmethod
    def hydrocarbon_mass_fraction(
            gas: ct.Solution,
            fuel: dict[str, float]
        ) -> float:
        """ Fraction of hydrocarbons in mixture. """
        hc_species = HydrocarbonHeatingValue.select_hydrocarbons(gas, fuel)
        Y_fuel = sum(gas[hc_species].Y)
        return Y_fuel

    def heating_values(self,
            fuel: dict[str, float],
            oxid: dict[str, float],
            basis: Optional[str] = "mole"
        ) -> float:
        """ Compute corrected fuel heating value with provided method. """
        lhv, hhv = self._heating_values(fuel, oxid, basis=basis)

        self._gas.TPX = None, None, fuel
        corr = self.hydrocarbon_mass_fraction(self._gas, fuel)

        return corr * lhv, corr * hhv

    def hydrocarbon_heating_values(self,
            fuel: dict[str, float],
            oxid: dict[str, float],
            basis: Optional[str] = "mole"
        ) -> float:
        """ Heating value before correction of impurities. """
        return self._heating_values(fuel, oxid, basis=basis)


class BurnerFlowRatesCalculator:
    """ Compute nominal flow rates to match equivalence ratio.
    
    Parameters
    ----------
    mech : str
        Path to Cantera kinetics mechanism to be used.
    """
    def __init__(self, mech: str) -> None:
        self._mech = mech
        self._fuel = ct.Solution(self._mech)
        self._oxid = ct.Solution(self._mech)
        self._mixt = ct.Solution(self._mech)

        # Normal concentration in [kmol/Nm³] to [mol/Nm³]
        self._normal_conc = FlowUnits().normal_concentration()
        self._normal_conc *= 1000

    def _get_molar_amounts(self) -> list[float]:
        """ Compute mole fractions of fuel and oxidizer. """
        Af = np.array([*self._fuel.X, 1])
        Ao = np.array([*self._oxid.X, 1])
        Am = np.array([*self._mixt.X, 1])

        mwf = self._fuel.mean_molecular_weight
        mwo = self._oxid.mean_molecular_weight
        mwm = self._mixt.mean_molecular_weight

        M = np.vstack((Af, Ao)).reshape((2, -1)).T
        x, res1, _, _ = np.linalg.lstsq(M, Am, rcond=None)
        res2 = np.dot(x, [mwf, mwo])

        # Arbitrary convergence check.
        if not (res1 < 1.0e-10) or not np.isclose(res2, mwm):
            raise ValueError(
                f"Problem formulation is wrong: "
                f"Residual of LSQ = {res1} and "
                f"residual = {res2}"
            )

        return x.flatten()

    def _get_fuel_heating_value(self, method: str) -> float:
        """ Compute fuel heating value with provided method. """
        gas = ct.Solution(self._mech)
        hcv = HydrocarbonHeatingValue(gas)
        lhv, hhv = hcv.heating_values(
            self._fuel.mole_fraction_dict(), 
            self._oxid.mole_fraction_dict()
        )

        match method.upper():
            case "HHV":
                hv = hhv
            case "LHV":
                hv = lhv
            case _:
                raise ValueError(f"Unknown method: {method}")

        # Here rho is `kg/Nm³`! Use MIXTURE molar mass!
        rho = self._normal_conc * self._mixt.mean_molecular_weight / 1000

        # `cap` is expected in `kWh/Nm³`.
        cap = hv / (3600 * rho)
        print(f"Corrected {method} = {cap:.1f} kWh/Nm³")

        return cap

    def _ndot_fuel(self, hdot: float, cap: float) -> tuple[float, float]:
        """ Compute fuel molar flow rate to reach energy level. """
        ndot = (self._normal_conc * hdot / cap) / 3600.0
        return ndot

    def mole_to_mass_flow(self, fuel_ndot, oxid_ndot):
        """ Convert molar units to mass units flow rates. """
        fuel_mdot = fuel_ndot * self._fuel.mean_molecular_weight / 1000
        oxid_mdot = oxid_ndot * self._oxid.mean_molecular_weight / 1000
        return fuel_mdot, oxid_mdot

    def set_states(self,
            phi,
            fuel,
            oxid,
            T=300, 
            P=ct.one_atm,
            basis="mole"
        ):
        """ Set states of fuel, oxidizer, and target mixture.
        
        Parameters
        ----------
        phi: float
            Feed equivalence ratio used to set initial composition.
        fuel: dict[str, float]
            Dictionary of fuel composition compatible with Cantera.
        oxid: dict[str, float]
            Dictionary of oxidizer composition compatible with Cantera.
        T: Optional[float] = 300.0
            Feed gas temperature in kelvin.
        P: Optional[float] = ct.one_atm
            Feed gas pressure in pascal.
        basis: Optional[str] = "mole"
            Whether composition is in `mole` or `mass` fracitons.
        """
        self._fuel.TPX = T, P, fuel
        self._oxid.TPX = T, P, oxid

        self._mixt.TP = T, P
        self._mixt.set_equivalence_ratio(phi, fuel, oxid, basis=basis)

    def get_mole_flow_rates(self,
            hdot: float,
            method: Optional[str] = "HHV",
            cap: Optional[float] = None
        ) -> tuple[float, float]:
        """ Compute required molar flow rates for equivalence ratio. 
        
        Parameters
        ----------
        hdot: float
            Required energy output in [kW] in `cap` basis.
        method: Optional[str] = "HHV"
            Method to evaluate heating value, HHV or LHV.
        cap: Optional[float] = None
            Fuel energy release capacity in [kWh/Nm³]. This entry is
            ignored if a method is provided.

        Returns
        -------
        tuple[float, float]
            Fuel and oxidized flow rates in [mol/s].
        """
        if cap is None or method is not None:
            cap = self._get_fuel_heating_value(method)

        x = self._get_molar_amounts()
        fuel_ndot = self._ndot_fuel(hdot, cap)
        oxid_ndot = fuel_ndot * x[1] / x[0]
        return fuel_ndot, oxid_ndot

    def get_mole_flow_from_fuel_flow(self,
            fuel_vdot: float
        ) -> tuple[float, float]:
        """ Get flow with same stoichiometry and imposed volume flow.
        
        Parameters
        ----------
        fuel_vdot: float
            Required fuel flow rate in [Nm³/h].

        Returns
        -------
        tuple[float, float]
            Fuel and oxidized flow rates in [mol/s].
        """
        x = self._get_molar_amounts()
        fuel_ndot = self._normal_conc * fuel_vdot / 3600.0
        oxid_ndot = fuel_ndot * x[1] / x[0]
        return fuel_ndot, oxid_ndot


class CombustorPSR:
    """ Single chamber perfect-stirred reactor combustor.
    
    This class is based on this Cantera example script:
    - cantera.org/examples/python/reactors/combustor.py.html

    It is a practical tool for comparing/evaluating different
    combustion mechanisms and their validity for an application.

    Parameters
    ----------
    mech : str
        Path to Cantera kinetics mechanism to be used.
    """
    def __init__(self, mech: str) -> None:
        self._gas = ct.Solution(mech)
        self._inlet = None
        self._combustor = None
        self._exhaust = None
        self._tau = None
        self._sim = None
        self._states = None

    def _equilibrate(self):
        """ Initialize reactor composition with equilibrium state. """
        self._gas.equilibrate("HP")
        self._combustor = ct.IdealGasReactor(self._gas, volume=1.0)
        self._exhaust = ct.Reservoir(self._gas)

    def _network(self, K, mdot=None):
        """ Create network connecting inlet/outlet to reactor. """
        if mdot is None:
            # Not very pythonic but ok in this case.
            mdot = lambda _: self._combustor.mass / self._tau

        pair = self._inlet, self._combustor
        inlet_mfc = ct.MassFlowController(*pair, mdot=mdot)

        pair = self._combustor, self._exhaust
        _ = ct.PressureController(*pair, master=inlet_mfc, K=K)

        self._sim = ct.ReactorNet([self._combustor])

    def set_states(self, 
            phi: float, 
            fuel: dict[str, float], 
            oxid: dict[str, float],
            T: Optional[float] = 300.0, 
            P: Optional[float] = ct.one_atm,
            basis: Optional[str] = "mole"
        ) -> None:
        """ Set source gas composition and create system.

        Parameters
        ----------
        phi: float
            Feed equivalence ratio used to set initial composition.
        fuel: dict[str, float]
            Dictionary of fuel composition compatible with Cantera.
        oxid: dict[str, float]
            Dictionary of oxidizer composition compatible with Cantera.
        T: Optional[float] = 300.0
            Feed gas temperature in kelvin.
        P: Optional[float] = ct.one_atm
            Feed gas pressure in pascal.
        basis: Optional[str] = "mole"
            Whether composition is in `mole` or `mass` fracitons.
        """
        self._gas.TP = T, P
        self._gas.set_equivalence_ratio(phi, fuel, oxid, basis=basis)
        self._inlet = ct.Reservoir(self._gas)
        self._equilibrate()

    def simulate_with_mass_flow(self,
            mdot: float,
            K: Optional[float] = 0.01
        ):
        """ Simulate combustor with imposed mass flow rate.
        
        Parameters
        ----------
        mdot : float
            Mass flow rate to pass throught the reactor [kg/s].
        K: Optional[float] = 0.01
            Valve constant used in pressure outlet.
        """
        self._states = ct.SolutionArray(self._gas, extra=["tau"])
        self._network(K, mdot)
        self._sim.set_initial_time(0.0)
        self._sim.advance_to_steady_state()
        self._states.append(self._combustor.thermo.state, tau=self._tau)

    def to_steady_state(self,
            tau_max: float,
            tau_min: Optional[float] = None,
            tau_dec: Optional[float] = 0.9,
            K: Optional[float] = 0.01
        ) -> None:
        """ Compute steady-state compositions for residence times.
        
        Parameters
        ----------
        tau_max: float
            Maximum residence time in seconds.
        tau_min: Optional[float] = None
            Minimum residence time in seconds. If not provided, it
            is set to one-thousandth of maximum value.
        tau_dec: Optional[float] = 0.9
            Decrease rate of residence time.
        K: Optional[float] = 0.01
            Valve constant used in pressure outlet.

        Raises
        ------
        AttributeError
            User did not call `set_states` method before computation.
        ValueError
            Invalid decrement rate for advancing residence time.
        """
        if self._combustor is None:
            raise AttributeError("Reactor has not been initialized.")

        if tau_dec >= 1.0:
            raise ValueError("Decrement rate must be below unity.")

        if tau_min is None:
            tau_min = 0.001 * tau_max

        self._tau = tau_max
        states = ct.SolutionArray(self._gas, extra=["tau"])

        self._network(K)

        while self._tau > tau_min:
            self._sim.set_initial_time(0.0)
            self._sim.advance_to_steady_state()
            states.append(self._combustor.thermo.state, tau=self._tau)
            self._tau *= tau_dec

        self._states = states

    def plot(self,
            tau_scale: float = 1000,
            species: list[str] = None,
            figsize: tuple[float, float] = (12, 5),
            xlim: tuple[float, float] = (None, None),
            ax1_ylim: tuple[float, float] = (None, None),
            ax2_ylim: tuple[float, float] = (None, None),
            ax3_ylim: tuple[float, float] = (None, None),
            loc: str | int = "best"
        ) -> Figure:
        """ Provides basic standard visualization of results.
        
        Parameters
        ----------
        tau_scale: float = 1000
            Scale to multiply residence time for better readability.
        species: list[str] = None
            List of species to plot. If none, it assumes partial 
            oxidation of methane is being studied.
        figsize: tuple[float, float] = (12, 5)
            Size of figure provided to matplotlib.
        xlim: tuple[float, float] = (None, None)
            Limits of x-axis (residence time) in both plots.
        ax1_ylim: tuple[float, float] = (None, None)
            Limits of y-axis in released energy in MW/m³.
        ax2_ylim: tuple[float, float] = (None, None)
            Limits of y-axis in combustion temperature.
        ax3_ylim: tuple[float, float] = (None, None)
            Limits of y-axis for species mole fractions.
        loc: str | int = "best"
            Placement of legend in species mole fractions plot.
        """
        names = self._states.species_names
        tau = tau_scale * self._states.tau
        qdot = self._states.heat_release_rate / 1e6
        T = self._states.T

        if species is None:
            species = ["CH4", "O2", "CO2", "H2O", "CO", "H2"]

        def plot_spec(spec, ax):
            """ Helper to plot species in axis. """
            if spec in names:
                idx = self._states.species_index(spec)
                X = self._states.X.T[idx]
                ax.loglog(tau, X, label=spec)

        plt.close("all")
        plt.style.use("seaborn-white")

        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=figsize)
        ax3 = ax1.twinx()
    
        ax1.loglog(tau, qdot, ".-", color="C0")
        ax3.plot(tau, T, ".-", color="C1")

        for spec in species:
            plot_spec(spec, ax2)
        
        ax1.set_title(f"Temperature range {T.min():.1f}K - {T.max():.1f}K")
        ax2.set_title("Composition evolution")

        ax1.set_xlabel(f"Residence time [x{tau_scale} s]")
        ax2.set_xlabel(f"Residence time [x{tau_scale} s]")

        ax1.set_ylabel("Heat release rate [$MW\cdotp{}m^{-3}$]", color="C0")
        ax2.set_ylabel("Mole fraction")
        ax3.set_ylabel("Temperature [$K$]", color="C1",
                       rotation=270, labelpad=20)

        ax1.grid(linestyle=":")
        ax2.grid(linestyle=":")

        ax1.set_xlim(xlim)
        ax2.set_xlim(xlim)

        ax1.set_ylim(ax1_ylim)
        ax2.set_ylim(ax2_ylim)
        ax3.set_ylim(ax3_ylim)

        ax2.legend(loc=loc, fancybox=True, frameon=True, framealpha=1)

        fig.tight_layout()
        return fig

    @property
    def states(self):
        """ Provides access to computed states for post-processing. """
        if self._states is None:
            raise AttributeError("First call `to_steady_state`.")

        return self._states
