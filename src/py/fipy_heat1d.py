# -*- coding: utf-8 -*-
from abc import ABC
from abc import abstractmethod
from abc import abstractproperty
from typing import Any
from typing import Optional
from matplotlib import pyplot as plt
from fipy import CellVariable
from fipy import Grid1D
from fipy import TransientTerm
from fipy import DiffusionTerm
from utilities import ProgressBar
import numpy as np
import pandas as pd


class Heat1DProblemSpecification(ABC):
    """ Base class for functional problem specification. """
    @abstractmethod
    def set_initial(self, xc, T):
        """ Set initial condition over domain. """
        pass

    @abstractmethod
    def transient_coef(self, mesh, T):
        """ Transient term coefficient in terms of temperature. """
        pass

    @abstractmethod
    def thermal_conductivity(self, mesh, T):
        """ Thermal conductivity in terms of temperature. """
        pass

    @abstractproperty
    def domain_length(self):
        """ Full length of simulated domain. """
        pass

    @abstractproperty
    def cell_length(self):
        """ Characteristic cell size over simulation domain. """
        pass

    @abstractproperty
    def dirichlet_bc(self):
        """ Dirichlet (fixed) boundary condition. """
        pass


class Heat1DModel:
    """ Simulate heat equation in nonlinear form in 1D. 
    
    The goal of the model is to (1) determine required time to reach
    a critical used-defined mean temperature, (2) provide temperature
    profile at a given user-defined intermediate time, and (3) provide
    the temperature profile across thickness at mean critical temperature.

    For this end one needs to solve heat equation in a medium with varying
    thermal conductivity and fixed boundary conditions on both sides. This
    way we get the most severe cooling conditions leading to the extrusion
    of material through the rollers (since in a flat plate there is no
    thermal reservoir above the extruded point). Providing user-defined
    conductivity allows also in a single model to handle transport in
    material alone but also through a casing layer.

    Parameters
    ----------
    problem: ProblemSpecification
        Object containing problem characteristics / properties.
    scale: Optional[float] = 1
        Multiplier to scale estimated time-step.
    """
    def __init__(
        self,
        problem: Heat1DProblemSpecification,
        scale: Optional[float] = 1
    ):
        # Keep a copy of problem specification.
        self.problem = problem
        self.scale = scale

        # Allocate memory for solution mesh.
        self.mesh = Grid1D(dx=problem.cell_length, 
                           Lx=problem.domain_length)

        # Create solution variable over mesh (hasOld for sweeping).
        self.T = CellVariable(name="T", mesh=self.mesh, hasOld=True)

        # Store cell and face centers for later usage.
        self.xc = self.mesh.cellCenters.value[0]
        self.xf = self.mesh.faceCenters.value[0]

        # Set initial and boundary conditions.
        problem.set_initial(self.xc, self.T)
        self.T.constrain(problem.dirichlet_bc, self.mesh.facesRight)
        self.T.constrain(problem.dirichlet_bc, self.mesh.facesLeft)

        # Create physically-based time-step estimator.
        self._update_equation()

    def _update_equation(self):
        """ Update equation and compatible time-step. """
        # Create updated version of problem equation.
        rho_cp = self.problem.transient_coef(self.mesh, self.T)
        k = self.problem.thermal_conductivity(self.mesh, self.T)
        eq = TransientTerm(coeff=rho_cp) == DiffusionTerm(coeff=k)

        # Create physically-based time-step estimator.
        alpha = k / rho_cp.faceValue
        self.time_step = pow(self.problem.cell_length, 2) / (2 * alpha)
        self.time_step *= self.scale

        return eq

    def _feed_update(self, t, res, count, max_dt, table, where):
        """ Feed results table and compute step / tracked temperature. """
        # Compute bounded time-step for current step.
        tau = min(np.min(self.time_step.numericValue), max_dt)

        # Compute mean temperature [°C] in tracking zone.
        temps = np.mean(self.T.numericValue[where])

        # Actually feed results table.
        table.append((t, temps, tau, res, count))

        # For main loop use `temps` in Celsius degrees.
        return tau, temps - 273.15

    def _sweep_step(self, tau, abs_tol, max_sweeps):
        """ Iterate a time-step until convergence or maximum sweeps. """
        count = 0

        eq = self._update_equation()

        while True:
            count += 1
            res = eq.sweep(var=self.T, dt=tau)
            if res <= abs_tol or count >= max_sweeps:
                break

        return res, count

    def _make_results_table(self, table):
        """ Assembly results table for simulation. """
        columns = ["Time [s]", "Temperature [°C]", 
                   "Step [s]", "Residual", "Sweeps"]
        
        df = pd.DataFrame(table, columns=columns)
        
        df["Temperature [°C]"] -= 273.15

        return df

    def integrate(
        self,
        target: float,
        tout: float,
        time_tol: Optional[float] = 1.0e-02,
        abs_tol: Optional[float] = 1.0e-07,
        max_sweeps: Optional[int] = 50,
        where: Optional[slice] = None
    ) -> tuple:
        """ Compute time-evolution of system with iterative steps.
        
        Parameters
        ----------
        target: float
            Mean temperature in degrees Celsius to end simulation.
        tout: float
            Characteristic time at which to store solution profile.
        time_tol: Optional[float] = 1.0e-02
            Time tolerance to seek for characteristic `tout` value.
        abs_tol: Optional[float] = 1.0e-07
            Absolute tolerance for sweeping solution residuals.
        max_sweeps: Optional[int] = 50
            Maximum number of sweeps per time step.
        where: Optional[slice] = None
            Location in width where to compute `target` temperature.
        """
        # Check if a slice representing region to extract properties has
        # been provided, otherwise assume it is the whone domain.
        where = slice(0, None) if where is None else where

        # Time-step will be limited to twice time tolerance so that the
        # tracking of `tout` actually is ensured.
        max_dt = 2 * time_tol

        # Prepare all results variables.
        table, sol_tout, sol_tend = [], None, None

        # Initialize time and feed of results/time-step.
        t = 0.0
        tau, temps = self._feed_update(t, 0.0, 0.0, max_dt, table, where)

        # Create a progress bar because, well, it's cool.
        pbar = ProgressBar()

        # Get initial temperature to compute progress fraction.
        T0 = np.mean(self.T.numericValue[where])

        # Loop until target temperature is reached, updating temperature,
        # following tracked time, and feeding results table.
        while True:
            self.T.updateOld()

            if abs(t - tout) < time_tol:
                sol_tout = t, np.array(self.T.numericValue)

            if temps <= target and t >= tout:
                break

            # TODO compute cooling rate at target.
            # TODO add managed time-step to ensure convergence.
            t += tau
            res, count = self._sweep_step(tau, abs_tol, max_sweeps)
            tau, temps = self._feed_update(t, res, count, max_dt, table, where)

            if temps > target:
                pbar.update(frac=(T0 - temps) / (T0 - target))

        sol_tend = t, np.array(self.T.numericValue)
        table = self._make_results_table(table)

        return table, sol_tout, sol_tend

    @property
    def cell_centers(self):
        """ Access coordinates of cell centers over domain. """
        return self.xc

    @property
    def face_centers(self):
        """ Access coordinates of face centers over domain. """
        return self.xf


def post_process(
    model: Heat1DModel, 
    results: pd.DataFrame,
    sol_tout: tuple,
    sol_tend: tuple,
    where: Optional[slice] = None,
    show: Optional[bool] = False
) -> None:
    """ Display simulation results (temperature, residuals...). """
    where = slice(0, None) if where is None else where
    t, T, dt, r, s = results.iloc[:, :5].to_numpy().T

    T2 = sol_tend[1] - 273.15
    mu2 = np.mean(sol_tend[1][where] - 273.15)

    plt.close("all")
    plt.style.use("seaborn-white")
    fig, ax = plt.subplots(2, 3, figsize=(12, 7))
    ax = ax.ravel()

    ax[0].plot(t, T)
    ax[0].grid(linestyle=":")
    ax[0].set_xlabel("Time [s]")
    ax[0].set_ylabel("Mean temperature [°C]")
    ax[0].set_title(f"Time to target of {t[-1]:.1f} s")

    if sol_tout is not None:
        T1 = sol_tout[1] - 273.15
        mu1 = np.mean(sol_tout[1][where] - 273.15)

        ax[1].plot(model.cell_centers * 1000, T1)
        ax[1].axhline(mu1, color="k")
        ax[1].grid(linestyle=":")
        ax[1].set_xlabel("Coordinate [mm]")
        ax[1].set_ylabel("Temperature [°C]")
        ax[1].set_title(f"Reached {mu1:.0f} °C at {sol_tout[0]:.3f} s")

    ax[2].plot(model.cell_centers * 1000, T2)
    ax[2].axhline(mu2, color="k")
    ax[2].grid(linestyle=":")
    ax[2].set_xlabel("Coordinate [mm]")
    ax[2].set_ylabel("Temperature [°C]")
    ax[2].set_title(f"Reached {mu2:.0f} °C at {sol_tend[0]:.3f} s")

    ax[3].plot(t, 1000 * dt)
    ax[3].grid(linestyle=":")
    ax[3].set_xlabel("Time [s]")
    ax[3].set_ylabel("Time step [x1000 s]")
    ax[3].set_title(f"Time step during integration")

    ax[4].plot(t, r)
    ax[4].grid(linestyle=":")
    ax[4].set_xlabel("Time [s]")
    ax[4].set_ylabel("Residual")
    ax[4].set_title(f"Residuals during integration")

    ax[5].plot(t, s)
    ax[5].grid(linestyle=":")
    ax[5].set_xlabel("Time [s]")
    ax[5].set_ylabel("Sweeps")
    ax[5].set_title(f"Sweeps to converge during integration")

    fig.tight_layout()

    if show:
        plt.show()
