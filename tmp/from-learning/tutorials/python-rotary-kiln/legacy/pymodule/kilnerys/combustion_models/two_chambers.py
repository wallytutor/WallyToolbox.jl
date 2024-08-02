# -*- coding: utf-8 -*-
from pathlib import Path
from rotary_kiln.kiln import discretize_length
from rotary_kiln.kiln import resistance_kiln_wall_direct
from rotary_kiln.kiln import resistance_kiln_wall_inverse
from rotary_kiln.reactors import make_single_reactor
from rotary_kiln.reactors import wall_constrained_kiln
from rotary_kiln.results import Results
from rotary_kiln.units import nm3h_to_kg_s
from rotary_kiln.units import celsius_to_kelvin
import cantera as ct
import numpy as np
import yaml


def make_combustion_solution(config):
    """ Build interface for creating burner outlet solution.
    
    Parameters
    ----------
    config: dict[str, Any]
        Must provide the following keywords:
        - oxidizer_flow_rate_primary
            Flow rate in [Nm³/h] of primary oxidizer source.
        - oxidizer_flow_rate_secondary
            Flow rate in [Nm³/h] of secondary oxidizer source.
        - fuel_flow_rate
            Flow rate in [Nm³/h] of fuel source.
        - oxidizer_composition_primary
            Composition (Cantera-compatible) of primary oxidizer.
        - oxidizer_composition_secondary
            Composition (Cantera-compatible) of secondary oxidizer.
        - fuel_composition
            Composition (Cantera-compatible) of fuel.
        - secondary_oxidizer_first_chamber
            Percentage of secondary oxidizer feeding first chamber.
        - volume_chamber_first
            Volume in [m³] of first reactor in series.
        - volume_chamber_second
            Volume in [m³] of second reactor in series.
        - ignition_temperature
            Inlet temperature in [°C] of all gases to start combustion.
    """
    root = Path(__file__).resolve().parents[1]
    mech = str(root / "data/kinetics" / config["mechanism"])

    discr_type = config["reactor_discretization_type"]
    inverse_mode = config["reactor_solver_mode"]

    # TODO dump config in logging directory.
    # print(config)

    fumes, mdot = _make_inlet_fumes(mech, config)
    simulator = _get_kiln_simulator(discr_type, inverse_mode, config)
    res = simulator(mech, fumes, mdot)

    return res.get_dataframe()


def _make_inlet_fumes(mech, config):
    """ Compute output of burner using mixing model. """
    mdot_oxid_1 = config["oxidizer_flow_rate_primary"]
    mdot_oxid_2 = config["oxidizer_flow_rate_secondary"]
    mdot_fuel_0 = config["fuel_flow_rate"]

    x_oxid_1 = config["oxidizer_composition_primary"]
    x_oxid_2 = config["oxidizer_composition_secondary"]
    x_fuel_0 = config["fuel_composition"]

    frac = config["secondary_oxidizer_first_chamber"] / 100.0
    v1 = config["volume_chamber_first"]
    v2 = config["volume_chamber_second"]
    T0 = celsius_to_kelvin(config["ignition_temperature"])

    oxid_1 = ct.Solution(mech)
    oxid_2 = ct.Solution(mech)
    fuel_0 = ct.Solution(mech)

    oxid_1.TPX = T0, ct.one_atm, x_oxid_1
    oxid_2.TPX = T0, ct.one_atm, x_oxid_2
    fuel_0.TPX = T0, ct.one_atm, x_fuel_0

    mdot_oxid_1 = nm3h_to_kg_s(mdot_oxid_1, m=oxid_1.mean_molecular_weight)
    mdot_oxid_2 = nm3h_to_kg_s(mdot_oxid_2, m=oxid_2.mean_molecular_weight)
    mdot_fuel_0 = nm3h_to_kg_s(mdot_fuel_0, m=fuel_0.mean_molecular_weight)

    mdot = mdot_oxid_1 + mdot_oxid_2 + mdot_fuel_0

    reactor_1 = make_single_reactor(mech, T=T0, V=v1)
    reactor_2 = make_single_reactor(mech, T=T0, V=v2)

    res_vent_0 = ct.Reservoir(oxid_1)
    res_oxid_1 = ct.Reservoir(oxid_1)
    res_oxid_2 = ct.Reservoir(oxid_2)
    res_fuel_0 = ct.Reservoir(fuel_0)

    mdot_1 = mdot_oxid_1 + frac * mdot_oxid_2
    mdot_2 = (1.0 - frac) * mdot_oxid_2

    ct.MassFlowController(res_fuel_0, reactor_1, mdot=mdot_fuel_0)
    ct.MassFlowController(res_oxid_1, reactor_1, mdot=mdot_1)
    ct.MassFlowController(res_oxid_2, reactor_2, mdot=mdot_2)

    ct.Valve(reactor_1, reactor_2, K=1.0)
    ct.Valve(reactor_2, res_vent_0, K=1.0)

    sim = ct.ReactorNet([reactor_1, reactor_2])
    sim.advance_to_steady_state()

    return reactor_2.thermo, mdot


def _load_kiln_file(config):
    """ Load file with user defined kiln discretization scheme. """
    data = config["kiln_file"].read()
    reactor = yaml.safe_load(data)["reactor_discretization"]

    xw = np.array(reactor["reactor_limits"])
    r0 = np.array(reactor["reactor_inner_radius"])
    r1 = np.array(reactor["reactor_inner_brick_thickness"]) + r0
    r2 = np.array(reactor["reactor_outer_brick_thickness"]) + r1
    k0 = np.array(reactor["reactor_inner_brick_conductivity"])
    k1 = np.array(reactor["reactor_outer_brick_conductivity"])
    Tw = np.array(reactor["outer_temperature"])

    return xw, r0, r1, r2, k0, k1, Tw


def _get_kiln_simulator(discr_type, inverse_mode, config):
    """ Compute position dependent wall resistance coefficient. """
    if discr_type == "User":
        xw, r0, r1, r2, k0, k1, Tw = _load_kiln_file(config)
        Lx = xw[-1]
        nx = len(xw)
    else:
        xw = None
        r0 = config["reactor_inner_diameter"] / 2.0
        r1 = config["brick_layer_thickness"] / 1000.0 + r0
        r2 = config["steel_layer_thickness"] / 1000.0 + r1
        k0 = config["brick_layer_thermal_conductivity"]
        k1 = config["steel_layer_thermal_conductivity"]
        Lx = config["reactor_length"]
        nx = config["reactor_slices"]
        Tw = _get_wall_temperature(config, nx)

    Tw = celsius_to_kelvin(Tw)
    xp, dx = discretize_length(discr_type, Lx=Lx, nx=nx, xw=xw)

    if inverse_mode:
        R = resistance_kiln_wall_inverse(r0, r1, r2, dx, k0, k1)
    else:
        h = config["environment_convective_htc"]
        R = resistance_kiln_wall_direct(r0, r1, r2, dx, k0, k1, h)

    # TODO implement effect of bed height here.
    scale = 1.0
    V = np.pi * pow(r0, 2.0) * dx
    A = 2.0 * np.pi * r0 * dx
    U = scale / R

    tend = 20
    tstep = 0.1

    def simulator(mech, fumes, mdot):
        """ Wrap simulation method with locals. """
        T_int = wall_constrained_kiln(mech, fumes, mdot, Tw, 
                                      V, A, U, tend, tstep)

        res = Results()
        res.x = xp
        res.R = R
        res.T_int = T_int
        res.T_ext = Tw

        return res

    return simulator


def _get_wall_temperature(config, nx):
    """ Produce wall temperature profile from extremes. """
    T0 = config["external_wall_temperature_entry"]
    T1 = config["external_wall_temperature_exit"]
    return np.linspace(T0, T1, nx)
