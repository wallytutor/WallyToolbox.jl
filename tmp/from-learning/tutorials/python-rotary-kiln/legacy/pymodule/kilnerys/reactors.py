# -*- coding: utf-8 -*-
from numbers import Number
from rotary_kiln.units import TKEL
import cantera as ct
import numpy as np


def make_single_reactor(mech, T, V, X="N2:1.0"):
    """ Create a reactor for flame representation. """
    sol = ct.Solution(mech)
    sol.TPX = T, ct.one_atm, X

    reactor = ct.IdealGasReactor(sol)
    reactor.volume = V
    reactor.energy_enabled = True
    reactor.chemistry_enabled = True

    return reactor


def make_walled_reactor(mech, Tw, sol, V, A, U):
    """ Create a reactor with wall to environment. """
    gas_ext = ct.Solution(mech)
    gas_int = ct.Solution(mech)

    gas_ext.TP = Tw, ct.one_atm
    gas_int.TPX = sol.TPX

    e = ct.Reservoir(gas_ext)
    r = ct.IdealGasReactor(gas_int)
    
    r.volume = V
    r.energy_enabled = True
    r.chemistry_enabled = False
    
    ct.Wall(r, e, Q=lambda _: A * U * (r.thermo.T - Tw))
    
    return e, r


def make_network(mech, mdot, T_ext, sol, V, A, U):
    """ Create kiln slice reactor network. """
    envs, reac, conn = [], [], []
    source = ct.Reservoir(sol)

    for k, Tw in enumerate(T_ext):
        Vk = V if isinstance(V, Number) else V[k]
        Ak = A if isinstance(A, Number) else A[k]
        Uk = U if isinstance(U, Number) else U[k]

        e, r = make_walled_reactor(mech, Tw, sol, Vk, Ak, Uk)

        if k == 0:
            v = ct.MassFlowController(source, r, mdot=mdot)
        else:
            v = ct.Valve(reac[k-1], r, K=1.0)

        envs.append(e)
        reac.append(r)
        conn.append(v)

    v = ct.Valve(reac[-1], source, K=1.0)
    conn.append(v)
    
    return reac, envs, conn


def wall_constrained_kiln(mech, fumes, mdot, T_ext, V, A, U, tend, tstep):
    """ Internal temperature profile from external measurements. """
    reac, _, _ = make_network(mech, mdot, T_ext, fumes, V, A, U)
    sim = ct.ReactorNet(reac)
    results = []

    t_points = np.arange(0.0, tend + 0.5 * tstep, tstep)

    for k, tk in enumerate(t_points):
        sim.advance(tk)
        results.append([r.thermo.T for r in reac])

    table = np.array(results) - TKEL
    T_int = table[-1, :].copy()

    return T_int
