# -*- coding: utf-8 -*-

# Import Python built-in modules.
from time import perf_counter
from typing import Any
from typing import Optional

# Import external modules.
from casadi import MX
from casadi import nlpsol
from casadi import vertcat
from majordome.utilities import Capturing
from matplotlib.figure import Figure
from scipy.integrate import cumtrapz
from scipy.integrate import simpson
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
from scipy.optimize import root
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# Own imports.
from ..bases import BaseODESystem
from ..bases import BaseThermoFreeboard
from ..bases import BaseThermoBed
from ..models import HtcTscheng1979
from ..models import solve_kramers_model
from ..models import conduction
from ..models import convection
from ..models import radiation
from ..models import effective_thermal_conductivity
from ..types import Matrix
from ..types import Vector


class RotaryKilnModel:
    """ Implementation of rotary kiln with Kramers model.
    
    Parameters
    ----------
    L: float
        Length of kiln provided in meters [m].
    R: float
        Internal radius of kiln provided in meters [m].
    alpha: float
        Slope of kiln provided in degrees [°].
    n: float
        Kiln rotation rate [rev/min]. It is important to note here
        that for compatibility with Kramers' equation for bed
        height prediction, this value is stored and provided
        through `rotation_rate` property with units of revolutions
        per second [rev/s].
    phim: float
        Kiln feed rate [kg/h].
    nz: int
        Number of cells to discretize kiln over length. Because
        it is aimed to be used with a finite volume formulation,
        cells are discretized over an equally spaced array with
        lenght `nz` and center of first/last cells are displaced
        to half-way the step size.
    hl: Optional[float] = 0.0
        Height of bed at product discharge end [m].
    radcal: Optional[Any] = None
        Radiation model for atmosphere properties.
    solver: Optional[str] = "scipy-root"
        Solver for constraints, "casadi-ipopt" or "scipy-root".
        The default is preferred for performance but in some cases
        using constrained optimization with CasADi interface to
        Ipopt may provide more consistence in solution.
    root_method: Optional[str] = "krylov"
        Method to use with solver "scipy-root". The default is
        recommended for the typical problem size found here but
        in some cases "df-sane" ensures avoids divergence due to
        problem numerical stiffness.
    nlptol: Optional[float] = 1.0e-06
        Constrain violation tolerance for solver "casadi-ipopt".
    """
    def __init__(self,
            L: float,
            R: float,
            alpha: float,
            n: float,
            phim: float,
            nz: int,
            hl: Optional[float] = 0.0,
            radcal: Optional[Any] = None,
            solver: Optional[str] = "scipy-root",
            root_method: Optional[str] = "krylov",
            nlptol: Optional[float] = 1.0e-06
        ) -> None:
        self._initialized = False
        self._length = L
        self._radius = R
        self._slope = np.radians(alpha)
        self._rotation_rate = n / 60.0
        self._feed_rate = phim / 3600.0
        self._discharge_height = hl
        self._radcal = radcal
        self._nlptol = nlptol
        self._solver = solver
        self._root_method = root_method
        self._Tmin = 200.0
        self._Tmax = 5000.0
        self.__discretization(nz)

    ###############################################################
    # Private properties (access shortcuts)
    ###############################################################

    @property
    def _reinitialize_per_iteration(self) -> bool:
        """ Whether to call initialization on every update. """
        return False

    @property
    def _gas_balance1d(self) -> interp1d:
        """ Heat flux balance in gas phase [W]. """
        q = -1 * self._bal_gas[::+1] / self._cell_length
        self._qg_last[:] = self.__relaxer(q, self._qg_last)
        return self.__extended_balance(self._qg_last[:])

    @property
    def _bed_balance1d(self) -> interp1d:
        """ Heat flux balance in gas phase [W]. """
        # NOTE: here the bed balance is returned in reversed order
        # because this property is intended to provide heat flux to
        # bed integration and the coordinate system of that model
        # is reversed with respect to the whole kiln.
        q = +1 * self._bal_bed[::-1] / self._cell_length
        self._qb_last[:] = self.__relaxer(q, self._qb_last)
        return self.__extended_balance(self._qb_last[:])

    @property
    def _mass_flow_rate_gas(self) -> Matrix:
        """ Access to gas mass flow rate [kg/s]. """
        return self._solution_gas[:, 0]

    @property
    def _mass_flow_rate_bed(self) -> Matrix:
        """ Access to bed mass flow rate [kg/s]. """
        # TODO check this when enabling gas-solid exchanges.
        return self._solution_bed[:, 0][::-1]

    @property
    def _mass_fractions_gas(self) -> Matrix:
        """ Access to gas composition in mass fractions [-]. """
        return self._solution_gas[:, 2:]

    @property
    def _mole_fractions_gas(self) -> Matrix:
        """ Access to gas composition in mole fractions [-]. """
        return self._tfm.get_mole_fractions(self._mass_fractions_gas)

    @property
    def _temperature_gas(self) -> Vector:
        """ Access to gas temperature in solution [K]. """
        return self._solution_gas[:, 1][::+1]

    @property
    def _temperature_bed(self) -> Vector:
        """ Access to bed temperature in solution [K]. """
        return self._solution_bed[:, 1][::-1]

    ###############################################################
    # Internal simple helper functions
    ###############################################################

    def __discretization(self, nz: int) -> None:
        """ Discretize 1D in equal length cells. """
        self._n_cells = nz
        self._cell_length = dz = self._length / self._n_cells
        self._cell_centers = np.linspace(dz/2, self._length-dz/2, nz)
        self._z = np.hstack((0.0, self._cell_centers, self._length))

    def __unpack_temperatures(self, T: Vector) -> tuple[4*[Vector]]:
        """ Unpack stacked temperature array. """
        return (T[0*self._n_cells:1*self._n_cells],
                T[1*self._n_cells:2*self._n_cells],
                T[2*self._n_cells:3*self._n_cells],
                T[3*self._n_cells:4*self._n_cells])

    def __extended_balance(self, q: Vector) -> interp1d:
        """ Build full balance interpolation with safe ends. """
        return interp1d(self._z, [q[0], *q, q[-1]],
                        fill_value="extrapolate")

    @staticmethod
    def __select_conversion(tunit: str):
        """ Select conversion function for temperature units. """
        match tunit[-1]:
            case "C":
                return lambda k: k - 273.15
            case "F":
                return lambda k: 9 * (k - 273.15) / 5 + 32
            case "K":
                return lambda k: k
            case _:
                raise ValueError(f"Unknown temperature unit {tunit}")

    def __relaxer(self, q: Vector, q_old: Vector) -> Vector:
        """ Apply relaxation factor to solution update array. """
        if self._relax > 0.0:
            return self._relax * q_old + (1.0 - self._relax) * q
        return q
    
    def __integrate(self,
            model: BaseODESystem,
            fn_qdot: interp1d,
            solution: Matrix,
            method: Optional[str] = "LSODA",
            max_step: Optional[float] = 0.1
        ):
        """ Call solution method with current state. """
        sol = solve_ivp(model, t_span=(0.0, self._length),
                        y0=model.initial_value, method=method,
                        args=(fn_qdot,), t_eval=self._z,
                        max_step=max_step)

        if not sol.success:
            name = model.__class__.__name__
            raise RuntimeError(f"Failed to integrate {name}.")

        solution[:, :] = sol.y.T

    def __integrate_gas(self):
        """ Integrate system of gas equations with proper arguments. """
        self.__integrate(self._tfm, self._gas_balance1d, self._solution_gas)
        
    def __integrate_bed(self):
        """ Integrate system of bed equations with proper arguments. """
        self.__integrate(self._tbm, self._bed_balance1d, self._solution_bed)
        
    def __solve_scipy_root(self, T_g, T_b, e_g, a_g):
        """ Solve constrained problem with `scipy.optimize.root`. """
        args = (T_g, T_b, e_g, a_g, self._eps_bed, self._eps_ref)
        sol = root(self.__steady_constraints, self._guess,
                   method=self._root_method, args=args)

        if not sol.success:
            raise ValueError("Rootfinding failed!")
        
        return sol.x

    def __solve_casadi_ipopt(self, T_g, T_b, e_g, a_g):
        """ Solve constrained problem with CasADi interface to ipopt. """
        g = self.__steady_constraints(self._T_sym, T_g, T_b, e_g, a_g, 
                                      self._eps_bed, self._eps_ref)

        nlp = {"x": self._T_sym, "f": 1, "g": g}
        solver = nlpsol("solver", "ipopt", nlp)

        with Capturing() as solver_output:
            result = solver(x0=self._guess,
                            lbx=self._Tmin,
                            ubx=self._Tmax,
                            lbg=0.0, ubg=0.0)

        constrain_violation = abs(result["g"].full()).max()
        if constrain_violation > self._nlptol:
            print(solver_output)
            raise ValueError("Rootfinding failed!")

        return result["x"].full().ravel()

    def __solve_constraints(self, T_g, T_b, e_g, a_g):
        """ Use selected solver to solve steady-state constraints. """
        match self._solver:
            case "casadi-ipopt":
                solver = self.__solve_casadi_ipopt
            case "scipy-root":
                solver = self.__solve_scipy_root

        self._guess[:] = solver(T_g, T_b, e_g, a_g)
        return self._guess

    ###############################################################
    # Simulation and post-processing auxiliaries
    ###############################################################

    def __test_convergence(self, atol: float) -> bool:
        """ Check if absolute temperature change converged. """
        Tg = self._temperature_gas
        Tb = self._temperature_bed

        self._errg = abs(self._Tg_last - Tg).max()
        self._errb = abs(self._Tb_last - Tb).max()
        
        self._Tg_last[:] = Tg
        self._Tb_last[:] = Tb

        self._history_gas.append(self._errg)
        self._history_bed.append(self._errb)

        if self._errg <= atol and self._errb <= atol:
            self._count += 1
        else:
            self._count = 0

        # TODO make an interface.
        min_convergence_steps = 5

        if self._count >= min_convergence_steps:
            return True
        
        return False

    def __tabulate_solution(self, tabs: dict[str, Vector]) -> None:
        """ Compile model results in a tabular format. """
        def wrap_cell_based_results(arr):
            return [float("nan"), *arr, float("nan")]

        X_g = self._mole_fractions_gas
        Y_g = self._mass_fractions_gas
        T_g = self._temperature_gas
        rho, mu, k_g = self._tfm.get_gas_properties(T_g, Y_g)
        u = self._mass_flow_rate_gas / (rho * self._gas_cross_area)

        # XXX: there is no need of managing the array direction
        # here, just after the overall computation.
        tau_bed = self._tbm.specific_mass * self._bed_cross_area
        tau_bed *= self._cell_length / self._mass_flow_rate_bed
        tau_bed = cumtrapz(tau_bed, initial=0) / 60.0

        df = pd.DataFrame()

        df["z"] = self._z
        df["t"] = tau_bed[::-1]
        df["h"] = self._bed_height
        df["load"] = self._local_loading
        df["area_bed"] = self._bed_cross_area 
        df["area_gas"] = self._gas_cross_area 

        df["temp_gas"] = self._temperature_gas
        df["temp_bed"] = self._temperature_bed

        df["mdot_gas"] = self._mass_flow_rate_gas
        df["mdot_bed"] = self._mass_flow_rate_bed

        df["gas_density"] = rho
        df["gas_viscosity"] = mu
        df["gas_conductivity"] = k_g
        df["gas_speed"] = u

        for key, val in tabs.items():
            df[key] = wrap_cell_based_results(val)

        df["P_xgw"] = self._P_xgw
        df["P_xgb"] = self._P_xgb
        df["P_cwb"] = self._P_cwb
        df["P_rwb"] = self._P_rwb
        
        df["A_cgw"] = self._A_cgw
        df["A_rgw"] = self._A_rgw
        df["A_cgb"] = self._A_cgb
        df["A_rgb"] = self._A_rgb
        df["A_cwb"] = self._A_cwb
        df["A_rwb"] = self._A_rwb

        df["h_cgb"] = self._h_cgb
        df["h_cgw"] = self._h_cgw
        df["h_cwb"] = self._h_cwb

        # NOTE: no array inversion here!
        df["q_gas"] = wrap_cell_based_results(-1 * self._bal_gas)
        df["q_bed"] = wrap_cell_based_results(+1 * self._bal_bed)
        df["q_env"] = wrap_cell_based_results(self._q_env)
        df["q_cgw"] = wrap_cell_based_results(self._q_cgw)
        df["q_rgw"] = wrap_cell_based_results(self._q_rgw)
        df["q_cgb"] = wrap_cell_based_results(self._q_cgb)
        df["q_rgb"] = wrap_cell_based_results(self._q_rgb)
        df["q_cwb"] = wrap_cell_based_results(self._q_cwb)
        df["q_rwb"] = wrap_cell_based_results(self._q_rwb)

        # Is it better to report densities?
        df["q_gas"] /= self._cell_length
        df["q_bed"] /= self._cell_length
        df["q_env"] /= self._cell_length
        df["q_cgw"] /= self._cell_length
        df["q_rgw"] /= self._cell_length
        df["q_cgb"] /= self._cell_length
        df["q_rgb"] /= self._cell_length
        df["q_cwb"] /= self._cell_length
        df["q_rwb"] /= self._cell_length

        df["x_o2"] =  X_g[:, self._tfm.species_index("O2")]
        df["x_h2o"] = X_g[:, self._tfm.species_index("H2O")]
        df["x_co2"] = X_g[:, self._tfm.species_index("CO2")]
        df["x_n2"] =  X_g[:, self._tfm.species_index("N2")]
        
        bg = df["q_cgw"] + df["q_rgw"] - df["q_rwb"] - df["q_cwb"]
        bs = df["q_env"]
        df["balance_residual"] = bs - bg

        self._table = df

        self._q_loss = simpson(df.q_env[1:-1], df.z[1:-1]) / 1000
        self._q_bed = simpson(df.q_bed[1:-1], df.z[1:-1]) / 1000

        print(f"Environment losses ... {self._q_loss:.2f} kW")
        print(f"Bed total heat flux .. {self._q_bed:.2f} kW")

    ###############################################################
    # Initialization methods
    ###############################################################

    def __init_bed_geometry(self, **kwargs):
        """ Evaluate internal areas and perimeters of kiln. """
        # Retrieve local functions.
        thick_coat = kwargs.get("thick_coat")
        thick_refr = kwargs.get("thick_refr")
        thick_shell = kwargs.get("thick_shell")

        # Compute radius for radial equations.
        self._R_zw = self._radius - thick_coat(self._z)
        self._R_wg = self._radius - thick_coat(self._cell_centers)
        self._R_cr = self._radius
        self._R_rs = self._R_cr + thick_refr(self._cell_centers)
        self._R_sh = self._R_rs + thick_shell(self._cell_centers)

        experimental = kwargs.get("kramers_exp", False)

        if experimental:
            radius = interp1d(self._z,
                              self._R_zw,
                              fill_value="extrapolate")
        else:
            radius = interp1d(self._z,
                              self._radius * np.ones_like(self._z),
                              fill_value="extrapolate")

        z, h = solve_kramers_model(
            radius,
            self._length,
            self._slope,
            self._rotation_rate,
            self._feed_rate,
            self._tbm.repose_angle,
            self._tbm.specific_mass,
            discharge_height=self._discharge_height,
            t_eval=self._z,
            method=kwargs.get("method_bed", "BDF"),
            experimental=experimental
        )

        R = radius(self._z)

        # Hanein (2016) suggests this expression instead, which I
        # verified and is equivalent to the one we use below.
        # phi = 2 * np.arcsin(lgb / (2 * R)) 
        phi = 2 * np.arccos(1 - h / R)

        # The next expression is right but it is simpler if we
        # invert Hanein's expression for phi.
        # lgb = 2 * np.sqrt(h * (2 * R - h))
        lgb = 2 * R * np.sin(phi / 2)

        Ab = (1/2)*(phi * R**2 - lgb * (R - h))
        Ag = np.pi * R**2 - Ab

        eta_loc = (phi - np.sin(phi)) / (2 * np.pi)
        eta_bar = simpson(eta_loc, z) / self._length

        self._central_angle = phi
        self._bed_height = h
        self._bed_cord_length = lgb
        self._bed_cross_area = Ab
        self._gas_cross_area = Ag
        self._local_loading = eta_loc
        self._mean_loading = eta_bar

        self._tfm.register_section_getter(self)
        self._tbm.register_section_getter(self)

    def __init_heat_geometry(self, **kwargs):
        """ Evaluate internal areas and perimeters of kiln. """
        # Local radius is inner kiln radius all over...
        R = self._radius

        # Areas for pair gas-wall: since the bed covers the central
        # angle, theta=2pi-phi and areas are computed as follows.
        self._P_xgw = (2 * np.pi - self._central_angle) * R
        self._A_cgw = self._P_xgw * self._cell_length
        self._A_rgw = self._A_cgw

        # Areas for pair gas-bed: this area is as trapezoidal
        # section because in fact bed is an inclined plane. Here,
        # to avoid useless complications it is computed as a
        # rectangle of exposed bed.
        self._P_xgb = self._bed_cord_length
        self._A_cgb = self._P_xgb * self._cell_length
        self._A_rgb = self._A_cgb

        # Areas for pair wall-bed: in this case there are two
        # different areas because radiation comes through the
        # exposed surface and conduction from contact with wall.
        # XXX: should'n the CWB be based on emitting surface?
        self._P_cwb = self._central_angle * R
        self._P_rwb = self._bed_cord_length
        self._A_cwb = self._P_cwb * self._cell_length
        self._A_rwb = self._P_rwb * self._cell_length

        # View factor for RWB is the ratio of receiving bed
        # surface to emitting walls (interface gas-wall).
        self._omega = self._P_rwb / self._P_xgw

        # External shell area.
        self._P_env = 2 * np.pi * self._R_sh
        self._A_env = self._P_env * self._cell_length 

        # Gorog's optical beam correlation used by Hanein (2016).
        D = 2 * self._R_wg
        h = self._bed_height[1:-1]
        self._beam_length = 0.95 * D * (1 - h / D)

    def __init_heat_fluxes(self, **kwargs):
        """ Prepare parameters related to heat fluxes computation. """
        k_coat  = kwargs.get("k_coat")
        k_refr  = kwargs.get("k_refr")
        k_shell = kwargs.get("k_shell")

        self._fn_k_coat  = lambda T: k_coat(self._cell_centers, T)
        self._fn_k_refr  = lambda T: k_refr(self._cell_centers, T)
        self._fn_k_shell = lambda T: k_shell(self._cell_centers, T)

        self._eps_bed = kwargs.get("eps_bed", 0.8)
        self._eps_ref = kwargs.get("eps_ref", 0.8)

        self._e_env = kwargs.get("eps_env", 0.8)
        self._h_env = kwargs.get("h_env", 8.0)
        self._T_env = kwargs.get("T_env", 313.15)

        self._h_cgw = np.zeros(self._n_cells+2)
        self._h_cgb = np.zeros(self._n_cells+2)
        self._h_cwb = np.zeros(self._n_cells+2)

        self._q_cgw = np.zeros(self._n_cells)
        self._q_rgw = np.zeros(self._n_cells)
        self._q_cgb = np.zeros(self._n_cells)
        self._q_rgb = np.zeros(self._n_cells)
        self._q_cwb = np.zeros(self._n_cells)
        self._q_rwb = np.zeros(self._n_cells)
        self._q_env = np.zeros(self._n_cells)

        self._bal_gas = np.zeros(self._n_cells)
        self._bal_bed = np.zeros(self._n_cells)

        self._htc = HtcTscheng1979(D=2*self._R_zw,
                                   beta=self._central_angle,
                                   eta=self._local_loading)

    def __init_solution(self, **kwargs):
        """ Initialize variables used in solution process. """
        self._errg = np.inf
        self._errb = np.inf

        self._Tg_last = np.zeros((self._n_cells+2,))
        self._Tb_last = np.zeros((self._n_cells+2,))

        self._solution_gas = np.zeros((self._n_cells+2, self._tfm.n_vars))
        self._solution_bed = np.zeros((self._n_cells+2, self._tbm.n_vars))

        self._solution_gas[:, :] = self._tfm.initial_value
        self._solution_bed[:, :] = self._tbm.initial_value

        self._history_gas = []
        self._history_bed = []

        if self._relax > 0.0:
            self._qg_last = np.zeros(self._z.shape[0]-2)
            self._qb_last = np.zeros(self._z.shape[0]-2)
        else:
            self._qg_last = None
            self._qb_last = None

        self._guess = self._Tmax * np.ones(4 * self._n_cells)
        
        self._T_sym = None
        if self._solver == "casadi-ipopt":
            self._T_sym = MX.sym("T_sym", 4 * self._n_cells)

    def __init_postprocess(self, **kwargs):
        """ Create postprocessing symbols. """
        self._table = None

    def __initialize(self,
            tfm: BaseThermoFreeboard,
            tbm: BaseThermoBed,
            **kwargs
        ) -> None:
        """ Evaluate model internals and solve bed profile. """
        self._tfm = tfm
        self._tbm = tbm
        self.__init_bed_geometry(**kwargs)
        self.__init_heat_geometry(**kwargs)
        self.__init_heat_fluxes(**kwargs)
        self.__init_solution(**kwargs)
        self.__init_postprocess(**kwargs)
        self._initialized = True

    ###############################################################
    # Partial heat flux expressions
    ###############################################################

    @staticmethod
    def __core_convection(h, A, Tu, Tv):
        """ Reduced system convection evaluation. """
        return convection(h[1:-1], A[1:-1], Tu, Tv)

    @staticmethod
    def __core_radiation(E, A, Tu, Tv, eu=1, au=1):
        """ Reduced system radiation evaluation. """
        return radiation(E, A[1:-1], Tu, Tv, eu=eu, au=au)

    def __fn_q_rgx(self, T_g, T_x, A, eg, ag, ex):
        """ Radiation from gas to X Eq. (20) X={W,B}. """
        E = (1.0 + ex) / 2.0
        return self.__core_radiation(E, A, T_g, T_x, eu=eg, au=ag)

    def __fn_q_cgw(self, T_g, T_w):
        """ Convection from gas to wall Eq. (18) X=W. """
        h = self._h_cgw
        A = self._A_cgw
        return self.__core_convection(h, A, T_g, T_w)

    def __fn_q_rgw(self, T_g, T_w, eg, ag, ew):
        """ Radiation from gas to wall Eq. (20) X=W. """
        A = self._A_rgw
        return self.__fn_q_rgx(T_g, T_w, A, eg, ag, ew)

    def __fn_q_cgb(self, T_g, T_b):
        """ Convection from gas to bed Eq. (18) X=B. """
        h = self._h_cgb
        A = self._A_cgb
        return self.__core_convection(h, A, T_g, T_b)

    def __fn_q_rgb(self, T_g, T_b, eg, ag, eb):
        """ Radiation from gas to bed Eq. (20) X=B. """
        A = self._A_rgb
        return self.__fn_q_rgx(T_g, T_b, A, eg, ag, eb)

    def __fn_q_cwb(self, T_w, T_b):
        """ Conduction(-like) from wall to bed Eq. (22). """
        h = self._h_cwb
        A = self._A_cwb
        return self.__core_convection(h, A, T_w, T_b)

    def __fn_q_rwb(self, T_w, T_b, eb, ew, use_hanein=True):
        """ Radiation from wall to bed Eq. (21). """
        # TODO: review this according to Hanein (2016).
        if use_hanein:
            E = 1.0
            A = 0.0
            
            # area = exposed wall, thus same as RGW.
            A += (1.0 - ew) / (ew * self._A_rgw)

            # area = exposed bed, thus RWB. F=1 in denominator.
            A += 1.0 / (1.0 * self._A_rwb)

            # area = exposed bed, thus RWB.
            A += (1.0 - eb) / (eb * self._A_rwb)

            # Invert value to match standard format.
            A = 1.0 / A
        else:
            E = eb * ew * self._omega[1:-1]
            A = self._A_rwb

        return self.__core_radiation(E, A, T_w, T_b)

    def __fn_q_env(self, T_s):
        """ Heat flux towards environment [W]. """
        con = convection(self._h_env, self._A_env, T_s, self._T_env)
        rad = radiation(self._e_env, self._A_env, T_s, self._T_env)
        return con + rad

    ###############################################################
    # Main physics methods
    ###############################################################

    def __h_cwb_hanein(self, k_g, k_b, a_b, w, beta):
        """ Wall-bed heat transfer coefficient used by Hanein (2016). """
        chi = 0.15
        d_p = 50.0e-06

        # NOTE: k*rho*cp = k**2 / alpha!
        term1 = chi * d_p / k_g
        term2 = 2 * (k_b**2 / a_b) * w / beta

        return term1 + 0.5 / np.sqrt(term2)
    
    def __steady_constraints(self, T, T_g, T_b, e_g, a_g, e_b, e_w):
        """ Steady-state nonlinear constraints function. """
        T_wi, T_cr, T_rs, T_sh = self.__unpack_temperatures(T)

        q_coat  = conduction(self._cell_length, self._fn_k_coat,
                             T_wi, T_cr, self._R_wg, self._R_cr)
        q_refr  = conduction(self._cell_length, self._fn_k_refr,
                             T_cr, T_rs, self._R_cr, self._R_rs)
        q_shell = conduction(self._cell_length, self._fn_k_shell,
                             T_rs, T_sh, self._R_rs, self._R_sh)
        q_env = self.__fn_q_env(T_sh)

        q_cgw = self.__fn_q_cgw(T_g, T_wi)
        q_rgw = self.__fn_q_rgw(T_g, T_wi, e_g, a_g, e_w)

        q_cwb = self.__fn_q_cwb(T_wi, T_b)
        q_rwb = self.__fn_q_rwb(T_wi, T_b, e_b, e_w)

        # Eqs. (12) to (15) from paper.
        eq12 = q_coat - (q_cgw + q_rgw - q_rwb - q_cwb)
        eq13 = q_refr - q_coat
        eq14 = q_shell - q_refr
        eq15 = q_env - q_shell

        if isinstance(T, MX):
            return vertcat(eq12, eq13, eq14, eq15)

        return np.hstack((eq12, eq13, eq14, eq15))

    def __update_htc(self):
        """ Wraps update of heat transfer coefficients. """
        Y_g = self._mass_fractions_gas
        T_g = self._temperature_gas
        T_b = self._temperature_bed

        k_b = self._tbm.thermal_conductivity(T_b)
        a_b = self._tbm.thermal_diffusivity(T_b)
        rho_g, mu, k_g = self._tfm.get_gas_properties(T_g, Y_g)
        
        # Effective bed thermal conductivity.
        k_b_eff = effective_thermal_conductivity(k_g, k_b, 0.5)

        # NOTE: apparently Tscheng uses rev/s to be consistent
        # in units with Kramers equation and other references.
        # Thus, instead of angular speed we use directly the
        # rotation rate in their equation Nu(n*R^2*beta/alpha).
        # For Re_w they actually use angular velocity w.
        # NOTE: on Mujumdar's thesis page 48 it is stated
        # otherwise, that the argument should use angular speed
        # instead. We keep here with what was understood from
        # Tscheng with possibility of later update.
        u = self._mass_flow_rate_gas / (rho_g * self._gas_cross_area)
        n = self._rotation_rate
        w = 2 * np.pi * n

        # Because of phase transformations there might be steep
        # changes in this variable (a_b is discontinuous), what
        # is reflected in h_cwb later.
        R = self._R_zw
        beta = self._central_angle
        
        self._htc.update(rho_g, mu, u, w)
        self._h_cgw[:] = self._htc.h_gw(k_g)
        self._h_cgb[:] = self._htc.h_gb(k_g)

        # XXX: Hanein (2016) does not recommend Tscheng (1979) here.
        # self._h_cwb[:] = self._htc.h_wb(k_b_eff, n, R, beta, a_b)
        self._h_cwb[:] = self.__h_cwb_hanein(k_g, k_b_eff, a_b, w, beta)

    def __update_fluxes(self, T_g, T_b, T_w, T_s, eg, ag, ew, eb):
        """ Compute all fluxes with latest solution. """
        self._q_cgw[:] = self.__fn_q_cgw(T_g, T_w)
        self._q_rgw[:] = self.__fn_q_rgw(T_g, T_w, eg, ag, ew)

        self._q_cgb[:] = self.__fn_q_cgb(T_g, T_b)
        self._q_rgb[:] = self.__fn_q_rgb(T_g, T_b, eg, ag, eb)

        self._q_cwb[:] = self.__fn_q_cwb(T_w, T_b)
        self._q_rwb[:] = self.__fn_q_rwb(T_w, T_b, eb, ew)

        self._q_env[:] = self.__fn_q_env(T_s)

        self._bal_gas[:] = self._q_cgw + self._q_cgb +\
                           self._q_rgw + self._q_rgb

        self._bal_bed[:] = self._q_cwb + self._q_cgb +\
                           self._q_rwb + self._q_rgb
    
    def __update_exchanges(self, radon=False, tabs=False):
        """ Use latest model states to compute exchanges. """
        self.__update_htc()

        # Cell-based values only here.
        X_g = self._mole_fractions_gas[1:-1]
        T_g = self._temperature_gas[1:-1]
        T_b = self._temperature_bed[1:-1]

        e_w = self._eps_ref
        e_b = self._eps_bed
        e_g = 0.0
        a_g = 0.0
    
        if self._radcal is not None and radon:
            L = self._beam_length
            X_h2o = X_g[:, self._tfm.species_index("H2O")]
            X_co2 = X_g[:, self._tfm.species_index("CO2")]
            e_g, a_g = self._radcal(T_b, T_g, X_h2o, X_co2, L)

        T_opt = self.__solve_constraints(T_g, T_b, e_g, a_g)
        T_w, T_cr, T_rs, T_s = self.__unpack_temperatures(T_opt)

        self.__update_fluxes(T_g, T_b, T_w, T_s, e_g, a_g, e_w, e_b)

        if tabs:
            return {"temp_inner": T_w, "temp_coat": T_cr,
                    "temp_refr":  T_rs, "temp_shell": T_s}

    ###############################################################
    # External API
    ###############################################################

    def simulate(self,
            model_tfm: BaseThermoFreeboard,
            model_tbm: BaseThermoBed, *,
            max_steps: Optional[int] = 100,
            atol: Optional[float] = 0.01,
            relax: Optional[float] = 0.0,
            minrad: Optional[int] = 10,
            **kwargs
        ) -> None:
        """ Iteratively solve kiln problem in 1D.
        
        This function deal with the fact that some bed height
        models might include sintering effects or more general 
        angle of repose computations, requiring profile updates.

        Parameters
        ----------
        model_tfm: BaseThermoFreeboard
            Instance of gas freeboard mass and energy balance model.
        model_tbm: BaseThermoBed
            Instance of solids bed mass and energy balance model.
        max_steps: Optional[int] = 100
            Maximum number of iteration steps for convergence.
        atol: Optional[float] = 0.0001
            Absolute temperature change tolerance for convergence.
        relax: Optional[float] = 0.0
            Fraction of last flux to use when updating heat transfer.
        minrad: Optional[int] = 10
            Iteration to activate radiation for lower stiffness.

        Keywords (mandatory)
        --------------------
        thick_coat: Callable[[Vector], Vector]
            Thickness of coating in heat geometry initialization.
        thick_refr: Callable[[Vector], Vector]
            Thickness of refractory used in heat geometry initialization.
        thick_shell: Callable[[Vector], Vector]
            Thickness of shell used in heat geometry initialization.
        k_coat: Callable[[Vector, Vector], Vector]
            Conductivity of used coating in heat fluxes initialization.
        k_refr: Callable[[Vector, Vector], Vector]
            Conductivity of used refractory in heat fluxes initialization.
        k_shell: Callable[[Vector, Vector], Vector]
            Conductivity of used shell in heat fluxes initialization.

        Keywords (optional)
        -------------------
        kramers_exp: Optional[bool] = True
            If True, consider coating in Kramer's equation solution.
        method_bed: Optional[str] = "BDF"
            Method to integrate bed height profile in bed initialization.
        eps_bed: Optional[float] = 0.8
            Constant emissivity of bed used in heat fluxes initialization.
        eps_ref: Optional[float] = 0.8
            Constant emissivity of coating used in heat fluxes initialization.
        eps_env: Optional[float] = 0.8
            Constant emissivity of shell used in heat fluxes initialization.
        h_env: Optional[float] = 8.0
            Convective heat transfer coefficient to environment [W/(m.K)].
        T_env: Optional[float] = 313.15
            External environment temperature [K].
        """
        self._relax = relax
        self._count = 0

        t0 = perf_counter()
        for step in range(max_steps):
            print("\n")

            if self._reinitialize_per_iteration or not self._initialized:
                print(f"Running initialization ({step})")
                self.__initialize(model_tfm, model_tbm, **kwargs)

            print(f"Integrating at step {step}")
            self.__integrate_gas()
            self.__integrate_bed()
                
            print(f"Solving nonlinear constraints ({step})")
            self.__update_exchanges(radon=step >= minrad)

            if self.__test_convergence(atol) and step > minrad:
                err = max(self._errg, self._errb)
                print(f"Leaving on step {step} with res = {err:.6f}\n")
                break

            print(f"Gas integration ({step}) res = {self._errg:.6f}")
            print(f"Bed integration ({step}) res = {self._errb:.6f}")

        print(f"Simulation took {perf_counter() - t0:.2f} s")
        cell_tabs = self.__update_exchanges(radon=True, tabs=True)
        self.__tabulate_solution(cell_tabs)

    def plot_solution(self,
            tunit: Optional[str] = "K",
            gridstyle: Optional[str] = ":",
            figsize: Optional[tuple[float, float]] = (14.0, 10.0),
            ylim_temps: Optional[tuple[float, float]] = None,
            ylim_shell: Optional[tuple[float, float]] = None,
            ylim_bed: Optional[tuple[float, float]] = None,
            bed_residence_time: Optional[bool] = True,
            reference: Optional[tuple[Vector, Vector]] = None
        ) -> Figure:
        """ Display simulation results from table. """
        z = self._table["z"].to_numpy()
        mean_loading = 100 * self._table["load"].mean()
        tfunc = self.__select_conversion(tunit)

        plt.close("all")
        plt.style.use("seaborn-white")

        fig = plt.figure(figsize=figsize)

        # COLUMN 1

        ax = plt.subplot(331, sharex=None)
        ax.plot(z, 100 * self._table["h"])
        ax.grid(linestyle=gridstyle)
        ax.set_xlabel("Coordinate [m]")
        ax.set_ylabel("Bed height [cm]")
        ax.set_xlim(0.0, self._length)

        ax = plt.subplot(334, sharex=ax)
        ax.plot(z, 100 * self._table["load"])
        ax.axhline(mean_loading, color="k", linestyle=":")
        ax.grid(linestyle=gridstyle)
        ax.set_xlabel("Coordinate [m]")
        ax.set_ylabel("Kiln loading [%]")
        ax.set_xlim(0.0, self._length)

        ax = plt.subplot(337, sharex=ax)
        ax.plot(z, self._table["area_bed"], label="Bed")
        ax.plot(z, self._table["area_gas"], label="Gas")
        ax.grid(linestyle=gridstyle)
        ax.set_ylabel("Coordinate [m]")
        ax.set_ylabel("Cross-section area [m²]")
        ax.legend(loc=1, frameon=True, framealpha=0.6)
        ax.set_xlim(0.0, self._length)

        # COLUMN 2

        ax = plt.subplot(332, sharex=ax)
        ax.plot(z, tfunc(self._table["temp_bed"]), label="Bed")
        ax.plot(z, tfunc(self._table["temp_gas"]), label="Gas")
        ax.plot(z, tfunc(self._table["temp_inner"]), label="Wall")
        ax.grid(linestyle=gridstyle)
        ax.set_xlabel("Coordinate [m]")
        ax.set_ylabel(f"Temperature [{tunit}]")
        ax.legend(loc=1, frameon=True, framealpha=0.6)
        ax.set_xlim(0.0, self._length)
        ax.set_ylim(ylim_temps)

        ax = plt.subplot(335, sharex=ax)
        ax.plot(z, tfunc(self._table["temp_shell"]), label="Shell")
        ax.grid(linestyle=gridstyle)
        ax.set_xlabel("Coordinate [m]")
        ax.set_ylabel(f"Temperature [{tunit}]")
        ax.legend(loc=1, frameon=True, framealpha=0.6)
        ax.set_xlim(0.0, self._length)
        ax.set_ylim(ylim_shell)

        ax = plt.subplot(338, sharex=ax)
        ax.plot(z, self._table["x_o2"], label=r"$\mathrm{O_2}$")
        ax.plot(z, self._table["x_h2o"], label=r"$\mathrm{H_2O}$")
        ax.plot(z, self._table["x_co2"], label=r"$\mathrm{CO_2}$")
        ax.grid(linestyle=gridstyle)
        ax.set_xlabel("Coordinate [m]")
        ax.set_ylabel(f"Mole fraction [-]")
        ax.legend(loc=1, frameon=True, framealpha=0.6)
        ax.set_xlim(0.0, self._length)

        # COLUMN 3

        ax = plt.subplot(333, sharex=ax)
        ax.plot(z, +self._table["q_cgw"]/1000, label="$Q_{CGW}$")
        ax.plot(z, +self._table["q_cgb"]/1000, label="$Q_{CGB}$")
        ax.plot(z, +self._table["q_cwb"]/1000, label="$Q_{CWB}$")
        ax.plot(z, +self._table["q_rgw"]/1000, label="$Q_{RGW}$")
        ax.plot(z, +self._table["q_rgb"]/1000, label="$Q_{RGB}$")
        ax.plot(z, +self._table["q_rwb"]/1000, label="$Q_{RWB}$")
        ax.plot(z, -self._table["q_gas"]/1000, label="$Q_{Gas}^\star$")
        ax.plot(z, +self._table["q_bed"]/1000, label="$Q_{Bed}$")
        ax.plot(z, +self._table["q_env"]/1000, label="$Q_{Env}$")
        ax.grid(linestyle=gridstyle)
        ax.set_xlabel("Coordinate [m]")
        ax.set_ylabel(r"Heat flux [$kW\cdotp{}m^{-1}$]")
        ax.legend(loc="best", frameon=True, framealpha=0.6, ncol=3)
        ax.set_xlim(0.0, self._length)

        if not bed_residence_time:
            ax = plt.subplot(336, sharex=ax)
            ax.plot(z, self._table["h_cgw"], label="$h_{CGW}$")
            ax.plot(z, self._table["h_cgb"], label="$h_{CGB}$")
            ax.plot(z, self._table["h_cwb"], label="$h_{CWB}$")
            ax.grid(linestyle=gridstyle)
            ax.set_xlabel("Coordinate [m]")
            ax.set_ylabel(r"Heat transfer coefficient [$W\cdotp{}m^{-2}K^{-1}$]")
            ax.legend(loc="best", frameon=True, framealpha=0.6)
            ax.set_xlim(0.0, self._length)
            ax.set_ylim(0.0, 50.0)
        else:
            tau = self._table["t"]
            tau_min = tau.iloc[0]

            ax = plt.subplot(336, sharex=None)
            ax.plot(tau, tfunc(self._table["temp_bed"]), label="Bed")

            if reference is not None:
                tau_ref, bed_ref = reference
                ax.plot(tau_ref, tfunc(bed_ref), label="Bed (reference)")
                tau_min = max(tau_ref[0], tau_min)

            ax.grid(linestyle=gridstyle)
            ax.set_xlabel("Residence time [min]")
            ax.set_ylabel(f"Temperature [{tunit}]")
            ax.legend(loc="best", frameon=True, framealpha=0.6)
            ax.set_xlim(tau_min, 0.0)
            ax.set_ylim(ylim_bed)

        ax = plt.subplot(339, sharex=None)
        ax.semilogy(self._history_gas, label="Gas")
        ax.semilogy(self._history_bed, label="Bed")
        ax.grid(linestyle=gridstyle)
        ax.set_xlabel("Iteration")
        ax.set_ylabel(r"Temperature change [$K$]")
        ax.legend(loc=1, frameon=True, framealpha=0.6)

        fig.tight_layout()

        return fig

    ###############################################################
    # Public properties
    ###############################################################
    
    @property
    def length(self) -> float:
        """ Access to kiln length [m]. """
        return self._length

    @property
    def coordinates(self) -> Vector:
        """ Access to kiln cell centers and ends [m]. """
        return self._z

    @property
    def bed_cord_length(self) -> Vector:
        """ Access to kiln bed cord length [m]. """
        return self._bed_cord_length

    @property
    def bed_cross_area(self) -> Vector:
        """ Access to kiln bed cross section [m²]. """
        return self._bed_cross_area

    @property
    def gas_cross_area(self) -> Vector:
        """ Access to kiln gas cross section [m²]. """
        return self._gas_cross_area

    @property
    def table(self) -> pd.DataFrame:
        """ Access to results table. """
        return self._table

    @property
    def shell_loss(self) -> float:
        """ Access to shell loss [kW]. """
        return self._q_loss

    @property
    def bed_heat_flux(self) -> float:
        """ Access to bed energy supply [kW]. """
        return self._q_bed
