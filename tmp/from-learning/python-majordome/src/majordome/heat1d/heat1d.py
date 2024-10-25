# -*- coding: utf-8 -*-
import time
import numpy as np
from .linspace import Linspace
from .solve import tdma_solve


class Heat1D:
    def __init__(self, layers, T, h, Tinf, cell=1.0e-06):
        self._h = h
        self._Tinf = Tinf

        self._space = Linspace(layers, cell, min_cells=5)

        self._dx1 = self._space.delta
        self._dx2 = pow(self._dx1, 2)
        self._materials = self._space.materials

        # Solution and auxiliary vectors.
        if isinstance(T, (int, float)):
            self._U = T * np.ones(self._space.no_cells, dtype=float)
            self._S = T * np.ones(self._space.no_cells, dtype=float)
        else:
            self._U = np.array(T, dtype=np.float64)
            self._S = np.array(T, dtype=np.float64)

        # Problem coefficients.
        self._Ki = np.zeros(self._space.no_cells-1, dtype=float)
        self._Alpha = np.zeros(self._space.no_cells, dtype=float)

        # Problem matrix diagonals.
        # TODO allocate all the same size.
        self._LoA = np.zeros(self._space.no_cells-1, dtype=float)
        self._DiB = np.zeros(self._space.no_cells-0, dtype=float)
        self._UpC = np.zeros(self._space.no_cells-1, dtype=float)
    
        # Problem RHS vector.
        self._RHSxU = np.zeros(self._space.no_cells, dtype=float)

        # Ensure properties for time-step initialization.
        self._update(self._U)

        self._time = 0.0
        self._epsilon = 1.0e-06
        self._maxsteps = 30
        self._tau_min = 1.0e-09
        self._tau = None

    def _adaptive_time_step(self, tend):
        """ Compute time-step with current system state. """
        K = self._space.thermal_conductivity
        tau = self._dx2 * self._space.heat_density / K
        self._tau = 10 * max(tau.min(), self._tau_min)
        _ = self._update_step(tend)

        if self._tau <= 0.0:
            raise ValueError(f"Unphysical time step {self._tau} s")

    def _update(self, u):
        # Compute global coefficients.
        self._space.update_properties(u)
        K = self._space.thermal_conductivity

        # Interpolate N - 1 conductivities.
        Km, Kp = K[:-1], K[1:]
        self._Ki[:] = 2.0 / (1.0 / Km + 1.0 / Kp)

    def _side(self, u, sign):
        # Update thermophysical properties.
        self._update(u)

        # Compute diffusivity over limits.
        ratio = self._tau / (2.0 * self._dx2)
        self._Alpha[:] = ratio / self._space.heat_density

        for i in range(1,self._space.no_cells-1):
            # Product of alpha and conductivities present on diagonals.
            alpha_k_m = self._Alpha[i] * self._Ki[i-1] # TODO outside loop
            alpha_k_p = self._Alpha[i] * self._Ki[i+0]

            # Main diagonals, w/o boundaries (both).
            self._DiB[i+0] = 1.0 - sign * (alpha_k_p + alpha_k_m)
            self._UpC[i+0] = sign * alpha_k_p
            self._LoA[i-1] = sign * alpha_k_m

        # Top (Neumann) zero flux B.C.
        self._UpC[0] = sign * 2 * self._Alpha[0] * self._Ki[0]
        self._DiB[0] = 1.0 - self._UpC[0]

        # Prepare ghost node (use actual last node property).
        km = self._space.thermal_conductivity[-1]  # Last node k.
        gamma = 2.0 * self._dx1 * self._hval / km  # Factor B.C.

        # Compute conductivity outsize domain and interpolate.
        TN = u[-2] - gamma * (u[-1] - self._uval)

        ## TODO was it zero or -1?
        kN = self._materials[0].thermal_conductivity(TN)
        knextN = 2.0 / (1.0 / km + 1.0 / kN)

        # Bottom (Fourier) flux B.C.
        sigma_m = knextN + self._Ki[-2]
        eff_k = sigma_m + knextN * gamma
        self._LoA[-1] = sign * self._Alpha[-1] * sigma_m
        self._DiB[-1] = 1.0 - sign * self._Alpha[-1] * eff_k

        # Compute flux.
        return sign * self._Alpha[-1] * knextN * gamma * self._uval

    def _update_rhs(self):
        # +1.0 is the sign of secondary diagonals.
        phi = self._side(self._U, +1.0)

        # Compute first and last rows of `R.u`.
        self._RHSxU[0] = (self._DiB[0] * self._U[0] +
                          self._UpC[0] * self._U[1])
        self._RHSxU[-1] = (self._LoA[-1] * self._U[-2] +
                           self._DiB[-1] * self._U[-1])

        # Perform sparse matrix multiplication.
        for i in range(1, self._space.no_cells-1):
            self._RHSxU[i] = (self._LoA[i-1] * self._U[i-1] +
                              self._DiB[i]   * self._U[i]   +
                              self._UpC[i]   * self._U[i+1])

        # Apply RHS boundary condition from RHS.
        self._RHSxU[-1] += phi

        # Store copy for replacement over iterations.
        self._RuLast = self._RHSxU[-1]

    def _update_lhs(self):
        # -1.0 is the sign of secondary diagonals.
        phi = self._side(self._S, -1.0)

        # Apply RHS boundary condition from LHS
        self._RHSxU[-1] += phi

    def _update_step(self, tend):
        # Compute remaining time.
        delta = tend - self._time

        # Modify time-step accordingly.
        self._tau = min(delta, self._tau)

        return delta

    def step(self, tend):
        self._adaptive_time_step(tend)

        # Iteration counter.
        steps = 0

        # Ensure temporary and current solution are initially the same.
        self._S[:] = self._U.copy()

        # Update time-dependant BC.
        self._hval = self._h(self._time)
        self._uval = self._Tinf(self._time)

        # Compute RHS array (R.u + phi_u^m).
        self._update_rhs()

        while (True):
            # Increment counter.
            steps += 1

            # Compute LHS array (L, Ru+phi_s).
            self._update_lhs()

            # Solve and store in S.
            tdma_solve(self._LoA, self._DiB, self._UpC, self._RHSxU, self._S)
            # TODO replace by scipy.linalg.solve_banded

            # Compute relative variation of norm L1 between states.
            num = np.sum(np.abs(self._U[:]) - np.abs(self._S[:]))
            den = np.sum(np.abs(self._S[:]))
            dL1 = num / den

            if (dL1 < self._epsilon):
                # Set U with new iterative solution S.
                self._U[:] = self._S.copy()

                # Update solution with current time step.
                self._time += self._tau

                # Return number of steps given.
                return steps

            # Prepare next iteration from actual solution vector.
            self._U[:] = self._S.copy()

            # Restore backup boundary condition.
            self._RHSxU[-1] = self._RuLast

            if steps > self._maxsteps:
                raise Exception(f"Unable to solve at {steps}")

    def solve(self, tend, eps, outfreq=100):
        # Global step counter.
        steps = 0

        # Internal counter.
        conv = 0

        # Average convergence steps.
        avg_conv = 0

        # Set convergence criteria.
        self._epsilon = eps

        # End time and break tolerance.
        tend = self._time + tend

        if (tend <= self._time + self._tau_min):
            raise ValueError("Final time is before first step!")

        # Nonlinear solver control.
        self._maxsteps = 30

        # Start time.
        t0 = time.time()

        # Internal counter.
        no_steps = 0

        while (True):
            steps += 1
            if not steps % outfreq:
                conv = int(np.ceil(avg_conv / (steps + 1)))
                print(f"\nAdvancing at {self._time:.6f} s @ {self._tau:.6f} s")
                print(f"\nAverage steps to convergence {conv}")

            # Advance one time step.
            no_steps = self.step(tend)
            avg_conv += no_steps

            # Correct next step size.
            delta = self._update_step(tend)

            # Finish integration if reached.
            if (abs(delta) <= self._tau_min or self._tau < 0):
                print(f"End time = {self._time:.6f} s")
                break

        print(f"\nAverage temperature {self._U.mean():.2f} K")
        print(f"\nCalculation took {time.time()-t0:.6f} s")

    @property
    def results_profile(self):
        """ Access to coordinates and associated temperatures. """
        return self._space.linspace, self._U
