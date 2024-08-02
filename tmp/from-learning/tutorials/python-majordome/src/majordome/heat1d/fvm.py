# -*- coding: utf-8 -*-
from dataclasses import dataclass
from enum import Enum
from typing import Callable
from scipy.linalg import solve_banded
from scipy.optimize import fsolve
import numpy as np
from ..progress_bar import ProgressBar
from .linspace import Linspace


@dataclass
class ResultsType:
    """ Data format expected in simulation results. """
    time: float
    step: float
    temperature: list[float]
    enthalpy: float
    atol: float
    rtol: float
    nl_iter: int
    nl_tries: int
    exit_crit: str


class BoundaryType(Enum):
    """ Boundary condition types. """
    CONVECTION = 1
    SYMMETRY = 2


class MaxNlIterError(Exception):
    """ Raised if maximum nonlinear iterations are reached. """
    pass


class MinTimeStepError(Exception):
    """ Raised if minimum time-step is reached on dynamic stepping. """
    pass


class Heat1DFVM:
    """ Implements non-linear heat equation in one dimension. """
    XTOL = 1.0e-10
    DEBUG = False

    def __init__(self,
                 linspace: Linspace, 
                 upper_bound: BoundaryType,
                 lower_bound: BoundaryType,
                 upper_bound_htc: Callable[[float], float] = None,
                 lower_bound_htc: Callable[[float], float] = None,
                 upper_bound_tinf: Callable[[float], float] = None,
                 lower_bound_tinf: Callable[[float], float] = None
                 ) -> None:
        no_bc = upper_bound_htc is None or upper_bound_tinf is None
        if upper_bound == BoundaryType.CONVECTION and no_bc:
            raise AttributeError("Missing functions for upper boundary")
        
        no_bc = lower_bound_htc is None or lower_bound_tinf is None
        if lower_bound == BoundaryType.CONVECTION and no_bc:
            raise AttributeError("Missing functions for lower boundary")

        self._linspace = linspace

        self._upper_bound = upper_bound
        self._upper_bound_htc = upper_bound_htc
        self._upper_bound_tinf = upper_bound_tinf
        self._upper_bound_idx = 0

        self._lower_bound = lower_bound
        self._lower_bound_htc = lower_bound_htc
        self._lower_bound_tinf = lower_bound_tinf
        self._lower_bound_idx = -1

        self._dx1 = self._linspace.delta
        self._dx2 = pow(self._dx1, 2)

        self._k = np.zeros(self._linspace.no_cells + 1)
        self._beta = np.zeros(self._linspace.no_cells)
        self._phi = np.zeros(self._linspace.no_cells)
        self._M = np.zeros((3, self._linspace.no_cells))

    def _debug_conv_bc(self, htc, tinf, Tp, Tg, kg):
        """ Check if fluxes are on same order of magnitude. """
        q1 = htc * (tinf - Tp)
        q2 = -kg* (Tp - Tg) / self._dx1
        assert abs(q1 - q2) < 1.0e-06

    @staticmethod
    def _harmonic_mean(ki, kj):
        """ Interpolate properties at interfaces. """
        return 2 * ki * kj / (ki + kj)

    def _update_coefficients(self, temperature):
        """ Update main problem coefficients over medium. """
        self._linspace.update_properties(temperature)

        K = self._linspace.thermal_conductivity

        self._k[1:-1] = self._harmonic_mean(K[:-1], K[1:])

        self._beta[:] = 1 / (self._dx2 * self._linspace.heat_density)

    def _update_tau(self, t, tend, tau_scale, tau_min, tau_max=1.0):
        """ Compute approximate compatible time step before advancing. """
        K = self._linspace.thermal_conductivity

        # Compute physics based time-step order of magnitude.
        tau = self._dx2 * self._linspace.heat_density / K

        # Limit time scale to minimum established value.
        tau = np.clip(tau_scale * tau.min(), 0.99 * tau_min, tau_max)

        # Ensure time step will not trespass end time.
        tau = min(tend - t, tau)

        if tau <= 0.0 or tau <= tau_min:
            raise ValueError(f"Unphysical time step {tau} s")

        return tau

    def _update_phi(self, t, T, tau):
        """ Compute additional fluxes from convection boundary condition. """
        def set_phi(htc, tinf, pos):
            """ Compute extra flux `phi` for convective boundary. """
            kf = self._linspace.materials[pos].thermal_conductivity
            kp = self._linspace.thermal_conductivity[pos]
            gamma = htc * self._dx1 * (tinf - T[pos])

            def k(ghost):
                """ Evaluate coefficient gamma at upper boundary. """
                return self._harmonic_mean(kf(ghost), kp)

            def problem_g(ghost):
                """ Nonlinear problem formulation to find ghost cell. """
                return ghost - T[pos] - gamma / k(ghost)

            ghost = fsolve(problem_g, x0=T[pos], xtol=self.XTOL)[0]

            self._k[pos] = k(ghost)
            self._phi[pos] = tau * self._beta[pos] * self._k[pos] * ghost

            if self.DEBUG:
                self._debug_conv_bc(htc, tinf, T[pos], ghost, self._k[pos])

        if self._upper_bound == BoundaryType.CONVECTION:
            set_phi(self._upper_bound_htc(t),
                    self._upper_bound_tinf(t),
                    self._upper_bound_idx)

        if self._lower_bound == BoundaryType.CONVECTION:
            set_phi(self._lower_bound_htc(t),
                    self._lower_bound_tinf(t),
                    self._lower_bound_idx)

    def _update_mat(self, tau):
        """ Compute main problem matrix with boundary conditions.
        
        Note: for indexing of `_k`, notice that array has been extended to
        include boundary faces too. This means that k[0] is computed from
        estimated ghost cell temperatures TG and k[-1] from TH.
        """
        # U            = -beta                   * ke
        self._M[0, 1:] = - tau * self._beta[:-1] * self._k[1:-1]

        # D           = 1 + beta              * (kw           + ke         )
        self._M[1, :] = 1 + tau * self._beta * (self._k[:-1] + self._k[1:])

        # L             = - beta                 * kw
        self._M[2, :-1] = - tau * self._beta[1:] * self._k[1:-1]

        if self._upper_bound == BoundaryType.SYMMETRY:
            self._M[1, 0] = 1 + tau * self._beta[0] * self._k[1]
            self._phi[0] = 0

        if self._lower_bound == BoundaryType.SYMMETRY:
            self._M[1, -1] = 1 + tau * self._beta[-1] * self._k[-2]
            self._phi[-1] = 0

    def _step(self, t, tau, maxsteps, atol, rtol):
        """ Perform a single time step through nonlinear iteration. 
        
        Note: coefficients update is not required before nonlinear iteration
        because this was already done in main loop to compute time-step with
        initial guess temperature (previous solution).

        Note: calls to `solve_banded` for solving for the next estimation are
        always done with current solution `T`, not the last update.
        """
        k = 0
        criteria = "B"
        T = self._linspace.temperature
        
        self._update_phi(t, T, tau)
        self._update_mat(tau)
        U = solve_banded((1, 1), self._M, T + self._phi)

        while True:
            k += 1
            self._update_coefficients(U)

            self._update_phi(t, U, tau)
            self._update_mat(tau)
            V = solve_banded((1, 1), self._M, T + self._phi)

            ares = np.abs(U - V)
            rres = np.abs(np.sum(np.abs(U) - np.abs(V)) / np.sum(np.abs(U)))

            U = V

            if np.all(ares <= atol) and rres <= rtol:
                criteria = "O"
                break

            if np.abs(ares).mean() < atol and rres <= rtol:
                criteria = "S"
                break

            if k >= maxsteps and rres <= rtol:
                criteria = "N"
                break
            else:
                raise MaxNlIterError(f"steps {maxsteps} | tau {tau} s")

        outputs = ResultsType(
            time = t + tau,
            step = tau,
            temperature = U,
            enthalpy = self._linspace.enthalpy_total.sum(),
            atol = ares.max(),
            rtol = rres,
            nl_iter = k,
            nl_tries = 1,
            exit_crit = criteria
        )
        return outputs

    def solve(self, tend: float, temperature: list[float], maxsteps: int = 10,
              atol: float = 1.0e-03, rtol: float = 1.0e-03,
              time_tol: float = 1.0e-06, tau_scale: float = 1.0,
              tau_scale_min: float = 0.001, tau_scale_max: float = 10.0,
              tau_scale_grow: float = 2.0, tau_scale_red: float = 2.0
              ) -> list[ResultsType]:
        """ Advance transient problem until required exit time.
        
        Parameters
        ----------
        tend: float
            Total physical integration time in seconds.
        temperature: list[float]
            Array of temperature at nodes of linear space.
        maxsteps: int = 10
            Maximum number of nonlinear steps per time-step.
        atol: float = 1.0e-06
            Absolute tolerance for convergence of nonlinear steps.
        rtol: float = 1.0e-06
            Relative tolerance for convergence of nonlinear steps.
        time_tol: float = 1.0e-09
            Absolute tolerance for end-time approach.
        tau_scale: float = 10.0
            Multiplier used to scale CFL number to compute time-step.
        tau_scale_min: float = 0.0004
        tau_scale_max: float = 1000.0
        tau_scale_grow: float = 1.2
        tau_scale_red: float = 2.0

        Returns
        -------
        ResultsType
            List with time, temperature, and number of nonlinear steps.
        """
        t = 0.0
        outputs = ResultsType(
            time = t,
            step = None,
            temperature = temperature,
            enthalpy = self._linspace.enthalpy_total.sum(),
            atol = None,
            rtol = None,
            nl_iter = None,
            nl_tries = None,
            exit_crit = None
        )
        results = [outputs]

        pbar = ProgressBar()

        while True:
            nl_tries = 0

            # TODO integrate enthalpy and balance with B.C.

            while True:
                try:
                    nl_tries += 1

                    self._update_coefficients(outputs.temperature)
                    
                    tau = self._update_tau(t, tend, tau_scale, time_tol)

                    outputs = self._step(t, tau, maxsteps, atol, rtol)

                    tau_scale *= tau_scale_grow

                    tau_scale = min(tau_scale_max, tau_scale)

                    break
                except MaxNlIterError:
                    tau_scale /= tau_scale_red

                    if tau_scale < tau_scale_min:
                        raise MinTimeStepError(f"tau = {tau:.6e} s {tau_scale}")

            outputs.nl_tries = nl_tries

            results.append(outputs)

            t = outputs.time

            pbar.update(t / tend)

            if abs(t - tend) < time_tol:
                break

        return results
