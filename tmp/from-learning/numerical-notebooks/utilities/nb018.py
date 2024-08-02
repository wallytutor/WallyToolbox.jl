# -*- coding: utf-8 -*-
from cantera import gas_constant
from cantera import stefan_boltzmann
from casadi import exp
from casadi import heaviside
from casadi import sqrt
from casadi import sum1
from casadi import vertcat
from casadi import nlpsol
from casadi import Function
from casadi import MX
from casadi import SX
from majordome.utilities import Capturing
from scipy.special import polygamma
import cantera as ct
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


NASA7_CH4_1S = {
    "CH4": (
        16.043,
        [+5.14987613e+00, -1.36709788e-02, +4.91800599e-05, -4.84743026e-08,
         +1.66693956e-11, -1.02466476e+04, -4.64130376e+00],
        [+7.48514950e-02, +1.33909467e-02, -5.73285809e-06, +1.22292535e-09,
         -1.01815230e-13, -9.46834459e+03, +1.84373180e+01],
    ),
    "O2": (
        31.998,
        [+3.78245636e+00, -2.99673416e-03, +9.84730201e-06, -9.68129509e-09,
         +3.24372837e-12, -1.06394356e+03, +3.65767573e+00],
        [+3.28253784e+00, +1.48308754e-03, -7.57966669e-07, +2.09470555e-10,
         -2.16717794e-14, -1.08845772e+03, +5.45323129e+00],
    ),
    "CO2": (
        44.009,
        [+2.35677352e+00, +8.98459677e-03, -7.12356269e-06, +2.45919022e-09,
         -1.43699548e-13, -4.83719697e+04, +9.90105222e+00],
        [+3.85746029e+00, +4.41437026e-03, -2.21481404e-06, 5.23490188e-10,
         -4.72084164e-14, -4.87591660e+04, +2.27163806e+00],
    ),
    "H2O": (
        18.015,
        [+4.19864056e+00, -2.03643410e-03, +6.52040211e-06, -5.48797062e-09,
         +1.77197817e-12, -3.02937267e+04, -8.49032208e-01],
        [+3.03399249e+00, +2.17691804e-03, -1.64072518e-07, -9.70419870e-11,
         +1.68200992e-14, -3.00042971e+04, +4.96677010e+00],
    ),
    "N2": (
        28.014,
        [+3.29867700e+00, +1.40824040e-03, -3.96322200e-06, +5.64151500e-09,
         -2.44485400e-12, -1.02089990e+03, +3.95037200e+00],
        [+2.92664000e+00, +1.48797680e-03, -5.68476000e-07, +1.00970380e-10,
         -6.75335100e-15, -9.22797700e+02, +5.98052800e+00],
    ),
    "AR": (
        39.950,
        [+2.50000000e+00, +0.00000000e+00, +0.00000000e+00, +0.00000000e+00,
         +0.00000000e+00, -7.45375000e+02, +4.36600000e+00],
        [+2.50000000e+00, +0.00000000e+00, +0.00000000e+00, +0.00000000e+00,
         +0.00000000e+00, -7.45375000e+02, +4.36600000e+00],
    )
}

# Base bounds of variables values per cell.
LBW_BASE = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0e+02]
UBW_BASE = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 5.0e+03]

KG_COEFS = [-7.494e-03, +1.709e-04, -2.377e-07,
            +2.202e-10, -9.463e-14, +1.581e-17]


class Species:
    """ Chemical species with NASA7 thermophysical properties.
    
    TODO
    ----
    - Implement kinetic theory transport properties.

    Parameters
    ----------
    mw : float
        Species molecular weight [g/mol].
    lo : list[float]
        Low temperature NASA7 polynomial coefficients.
    hi : list[float]
        High temperature NASA7 polynomial coefficients.
    Tc : float
        Temperature of change between `lo` and `hi` ranges.
    """
    def __init__(self, mw, lo, hi, Tc=1000.0):
        self._mw = mw
        self._Tc = Tc

        T = SX.sym("T")
        self._c = self._poly_nasa7_c(T, lo, hi)
        self._h = self._poly_nasa7_h(T, lo, hi)

    def _poly_nasa7_c(self, T, a, b):
        """ Compose NASA7 specific heat polynomials. """
        def poly(c):
            p = c[0] + c[1] * T + c[2] * T**2 + c[3] * T**3 + c[4] * T**4
            return p

        p_lo, p_hi = poly(a), poly(b)
        f = p_lo + heaviside(T - self._Tc) * (p_hi - p_lo)
        F = Function("cp", [T], [gas_constant * f])

        return F

    def _poly_nasa7_h(self, T, a, b):
        """ Compose NASA7 specific enthalpy polynomials. """
        def poly(c):
            d = [ck / k for k, ck in enumerate(c[:5], 1)]
            p = d[0] + d[1] * T + d[2] * T**2 + d[3] * T**3 + d[4] * T**4
            return p + c[5] / T

        p_lo, p_hi = poly(a), poly(b)
        f = p_lo + heaviside(T - self._Tc) * (p_hi - p_lo)
        F = Function("h", [T], [gas_constant * T * f])

        return F

    def cp_mole(self, T):
        """ Species specific heat [J/(mol.K)]. """
        v = self._c(T)
        return v if isinstance(T, SX) else v.full().ravel()
    
    def enthalpy_mole(self, T):
        """ Species specific enthalpy [J/mol]. """
        v = self._h(T)
        return v if isinstance(T, SX) else v.full().ravel()

    def cp_mass(self, T):
        """ Species specific heat [J/(g.K)]. """
        return self.cp_mole(T) / self._mw

    def enthalpy_mass(self, T):
        """ Species specific enthalpy [J/g]. """
        return self.enthalpy_mole(T) / self._mw

    @property
    def molecular_weight(self):
        """ Species molecular weight [g/mol]. """
        return self._mw


class Mixture:
    """ Mixture with weighted average properties computation.
    
    TODO
    ----
    - Implement mixture averaged transport properties.

    Parameters
    ----------
    db : dict[str, tuple[float, list[float], list[float]]]
        Database dictionary with keyes as species names and values
        of molecular weight, low, and high temperature NASA7 data.
    """
    def __init__(self, db):
        sol = {name: Species(*data) 
               for name, data in db.items()}

        mw = [s.molecular_weight for s in sol.values()]
        
        self._sol = sol
        self._mw = np.array(mw)

        self._species_names = list(self._sol.keys())
        self._n_species = len(self._species_names)

    def mean_molecular_mass(self, V, inputs="mass"):
        """ Mixture mean molecular mass in [g/mol]. """
        match inputs:
            case "mass":
                return 1.0 / sum1(V / self._mw)
            case "mole":
                return sum1(V * self._mw)
            case _:
                raise ValueError(f"Unknown case `{inputs}`")
    
    def mass_to_mole_fraction(self, Y):
        """ Convert mass fractions to mole fractions. """
        return Y * self.mean_molecular_mass(Y) / self._mw

    def specific_weight(self, T, Y, P=ct.one_atm):
        """  Mixture specific weight at state [kg/m³]. """
        mw = self.mean_molecular_mass(Y, inputs="mass")
        return P * mw / (gas_constant * T)

    def specific_heat(self, T, Y):
        """ Mass weighted average of mixture specific heat. """
        return sum([s.cp_mass(T) * Y[k]
                    for k, s in enumerate(self._sol.values())])

    def enthalpies(self, T):
        """ Array of enthalpies of mixture species. """
        return np.array([s.enthalpy_mass(T) for s in self._sol.values()])

    @property
    def species_names(self):
        """ Returns list of species in mixture. """
        return self._species_names

    @property
    def n_species(self):
        """ Number of species in mixture. """
        return self._n_species


class MethaneCombustion1S(Mixture):
    """ Mixture for methane combustion in one step. """
    LATEX_NAMES = [
        r"$\mathrm{CH_4}$",
        r"$\mathrm{O_2}$",
        r"$\mathrm{CO_2}$",
        r"$\mathrm{H_2O}$",
        r"$\mathrm{N_2}$",
        r"$\mathrm{Ar}$"
    ]

    def __init__(self):
        super().__init__(NASA7_CH4_1S)

        # Stoichiometryc coefficients of species.
        self._coefs = np.array([-1.0, -2.0, 1.0, 2.0, 0.0, 0.0])

    def _rate_ebu(self, rho, yf, yo, ke, cr=4.0, b=4.375):
        """ Eddy break-up reaction rate model [kg/(m³.s)]. """
        return cr * rho * ke * min_differentiable(yf, yo / b)

    def _rate_arr(self, rho, yf, yo, Tz, B=1.6e+10, E=108100.0):
        """ Arrhenius reaction rate model [kg/(m³.s)]. """
        R = gas_constant / 1000.0
        return B * rho**2 * yf * yo * exp(-E / (R * Tz))

    def rate_eff(self, Yz, Tz, ke):
        """ Effective reaction rate model [kg/(m³.s)]. """
        (yf, yo) = Yz[0], Yz[1]
        rho = self.specific_weight(Tz, Yz)

        # Evaluate both possible reaction rates.
        R_ebu = self._rate_ebu(rho, yf, yo, ke)
        R_arr = self._rate_arr(rho, yf, yo, Tz)

        # Mass rate of CH4 consumption.
        rt = min_differentiable(R_ebu, R_arr)

        # M ass rate of all species from `rt`.
        return (rt / self._mw[0]) * self._coefs * self._mw


class HtcTscheng1979:
    """ Heat transfer coefficient by Tscheng (1979). """
    def __init__(self, beta, D) -> None:
        # TODO in the future generalize this using Kramers
        # model for variable height! This is wrong!
        self._D_e = self._hydraulic_diameter(beta, D)
        self._v_re_d = None
        self._v_re_w = None

    def _hydraulic_diameter(self, beta, D):
        """ Hydraulic diameter considering bed. """
        num = 2 * np.pi - beta / 1 + np.sin(beta / 1)
        den = 1 * np.pi - beta / 2 + np.sin(beta / 2)
        return 0.5 * D * num / den

    def _re_d(self, rho_g, u_g, mu_g):
        """ Axial Reynolds number. """
        return rho_g * u_g * self._D_e**1 / mu_g

    def _re_w(self, rho_g, w_r, mu_g):
        """ Angular Reynolds number. """
        return rho_g * w_r * self._D_e**2 / mu_g

    def update(self, rho_g, u_g, mu_g, w_r):
        """ Update internals for Reynolds numbers. """
        self._v_re_d = self._re_d(rho_g, u_g, mu_g)
        self._v_re_w = self._re_w(rho_g, w_r, mu_g)

    def h_gs(self, k_g, eta):
        """ Gas-solid bed heat transfer coefficient. """
        htc = 0.46 * (k_g / self._D_e) * pow(eta, -0.341)
        red = pow(self._v_re_d, 0.535)
        rew = pow(self._v_re_w, 0.104)
        return htc * red * rew 

    def h_gw(self, k_g):
        """ Gas-solid bed heat transfer coefficient. """
        htc = 1.54 * (k_g / self._D_e)
        red = pow(self._v_re_d, 0.575)
        rew = pow(self._v_re_w, -0.292)
        return htc * red * rew 


class ConsSectWalledPfr:
    """ Constant section PFR with wall heat transfer. """
    def __init__(self,
        R,
        Lz,
        Nz,
        dR,
        mdot,
        Te=300,
        kr=1.2,
        n=0.2,
        beta=45,
        eps_w=0.9,
        eps_s=0.8
    ):
        # Store base parameters.
        self._Lz = Lz
        self._Nz = Nz
        self._mdot = mdot
        self._Te = Te
        self._eps_w = eps_w
        self._eps_s = eps_s

        # TODO: rework Gorog's data.
        self._eps_g = 0.5
        self._abs_g = 0.5

        # TODO make external/refractory value a function!
        self._h_we = 5.0

        # Length of slice over flow direction [m].
        self._dz = Lz / Nz

        # Reactor internal cross-section area [m²].
        self._Ac = np.pi * R**2

        # Reactor internal/external perimeter [m].
        self._Pc = 2 * np.pi * R
        self._Pe = 2 * np.pi * (R + dR)

        # Gas-wall/bed convective heat transfer coefficient.
        self._htc = HtcTscheng1979(beta * np.pi / 180, 2 * R)

        # Thermal resistance of reactor wall.
        self._condr = (2 * np.pi * kr) / np.log(1 + dR / R)
        self._condr *= self._dz

        # Create mixture object for properties calculation.
        self._mix = MethaneCombustion1S()

        # Create ODE system RHS.
        self._rhs, x, Tw = self.__get_ode(n)

        # Build right-hand side of ODE system.
        self._get_integrator = self.__get_stepper(x, Tw)

    def __get_ode(self, w_r):
        """ Create symbolic ODE right-hand side of problem. """
        # Alias to keep equations similar.
        Te = self._Te

        # Declare free symbols.
        ke = SX.sym("ke", 1)

        # Declare unknowns.
        Y = SX.sym("Y", 6)
        Tg = SX.sym("Tg", 1)
        Tw = SX.sym("Tw", 2)

        # Freeboard properties.
        k_g = freeboard_thermal_conductivity(Tg)
        mu_g = freeboard_viscosity(Tg)
        rho_g = self._mix.specific_weight(Tg, Y, P=ct.one_atm)
        cp_g = self._mix.specific_heat(Tg, Y)
        hm_g = self._mix.enthalpies(Tg)

        # Mass production rate of all species.
        w = self._mix.rate_eff(Y, Tg, ke)

        # Gas mean cross-section speed.
        u_g = self._mdot / (rho_g * self._Ac)

        # Heat transfer coefficients.
        self._htc.update(rho_g, u_g, mu_g, w_r)
        hi = self._htc.h_gw(k_g)
        he = self._h_we

        # Areas for heat exchange
        A_gw = self._Pc * self._dz
        A_we = self._Pe * self._dz

        # Source terms in energy equation.
        hdot = sum1(hm_g * w)

        # Conductive shell term.
        condr = self._condr * (Tw[1] - Tw[0])

        # Convective terms.
        c_gw = hi * A_gw * (Tw[0] - Tg)
        c_we = he * A_we * (Te - Tw[1])

        # Radiative terms.
        r_gw = stefan_boltzmann * A_gw * (1 + self._eps_w) / 2
        r_gw *= (self._abs_g * Tw[0]**4 - self._eps_g * Tg**4)

        r_we = stefan_boltzmann * A_we * self._eps_s
        r_we *= (Te**4 - Tw[1]**4)

        # Sum of transfer modes.
        qdot_gw = c_gw + r_gw
        qdot_we = c_we + r_we

        # Compose constraints.
        g0 = qdot_gw - condr
        g1 = qdot_we - condr

        # Gas momentum transport.
        rho_u = rho_g * u_g

        # Prepare convection term for heat equation.
        qdot = qdot_gw / (self._dz * self._Ac)

        # Compose equations RHS.
        dYdz = w / rho_u
        dTdz = (qdot - hdot) / (rho_u * cp_g)

        # Pack parameters, variables, and equations.
        p = vertcat(ke)
        g = vertcat(g0, g1)
        x = vertcat(Y, Tg)
        dxdz = vertcat(dYdz, dTdz)

        # Create callable for use in integrator.
        f = Function("f", [ x,   Tw,   p],  [ dxdz,   g], 
                          ["x", "Tw", "p"], ["dxdz", "g"])

        return f, x, Tw

    def __get_stepper(self, x, Tw):
        """ Generate integrator at coordinate `z`. """
        f = self._rhs
        dz = self._dz

        def get_stepper_rk4(z):
            """ Retrieve stepping function for current coordinate. """
            # Intermediate parameters.
            p1 = (z + 0 * dz / 1) / self._Lz
            p2 = (z + 1 * dz / 2) / self._Lz

            # Evaluate intermediate steps.
            k0 = 0.0
            k1, _ = f(x + k0 * dz / 1, Tw, p1)
            k2, _ = f(x + k1 * dz / 2, Tw, p2)
            k3, _ = f(x + k2 * dz / 2, Tw, p2)
            k4, _ = f(x + k3 * dz / 1, Tw, p1)

            # Step towards new solution.
            xf = x + (k1 + 2 * k2 + 2 * k3 + k4) * dz / 6
            
            # XXX: Constraint is at the CURRENT cell and thus must
            # be evaluated with CURRENT state, so `Tw=Tw(z)`!
            _, gf = f(xf, Tw, z + dz)

            # Return step integrator.
            return Function("F", [ x,   Tw],  [ xf,   gf],
                                 ["x", "Tw"], ["xf", "gf"])

        return get_stepper_rk4

    def __get_solution_bounds(self, X0, Nz):
        """ Generate lower and upper bounds for solution.
        
        Since wall temperatures are not initial conditions, but
        unknowns from constraints, care is taken here to place
        the actual bounds of this variable using usual temperature
        limits (last elements of arrays) in the proper positions.
        """
        lx0 = [*X0, LBW_BASE[-1], LBW_BASE[-1]]
        ux0 = [*X0, UBW_BASE[-1], UBW_BASE[-1]]

        lbx = [*LBW_BASE, LBW_BASE[-1], LBW_BASE[-1]]
        ubx = [*UBW_BASE, UBW_BASE[-1], UBW_BASE[-1]]

        lbx = np.hstack((lx0, np.repeat([lbx], Nz, 0).ravel()))
        ubx = np.hstack((ux0, np.repeat([ubx], Nz, 0).ravel()))

        return lbx, ubx

    def __retrieve_solution(self, results):
        """ Unpack solution from non-linear solver. """
        eqns = [*self._mix.species_names, "Tg", "T1", "T2"]
        ns = len(eqns) - 3

        x = results["x"].full().ravel()
        n = len(eqns)

        solution = {}

        for k, name in enumerate(eqns):
            name = f"Y_{name}" if not name.startswith("T") else name        
            solution[name] = x[k::n]
            
        df = pd.DataFrame(solution)

        old_cols = df.columns[:ns]
        new_cols = [f"X_{name}" for name in eqns[:-3]]

        for k, row in df.iterrows():
            Yk = row[:ns].to_numpy()
            Xk = self._mix.mass_to_mole_fraction(Yk)
            df.loc[k, new_cols] = Xk.full().ravel()

        df["bal"] = df[new_cols].sum(axis=1)
        df.drop(columns=old_cols, inplace=True)
        
        # Shift T1, T2 cause they don't belong to first cell.
        df["T1"] = df["T1"].shift(1)
        df["T2"] = df["T2"].shift(1)

        return df

    def solve(self, y0, t0, verbosity=3):
        """ Perform multiple shooting solution of problem. """
        # Bounds of variables values per cell.
        lbx, ubx = self.__get_solution_bounds([*y0, t0], self._Nz)

        # Variables, constraints.
        x, g = [], []

        # Create and enforce initial state.
        xk = MX.sym("x0", 7)
        tk = MX.sym("t0", 2)
        x.append(xk)
        x.append(tk)

        for k in range(self._Nz):
            # Create integrator for current slice.
            F = self._get_integrator(k * self._dz)

            # Call integrator and lift the variable.
            xp, gk = F(xk, tk)

            # Create new symbolic state.
            xk = MX.sym(f"x{k+1}", 7)
            tk = MX.sym(f"t{k+1}", 2)
            x.append(xk)
            x.append(tk)

            # Constrain problem.
            g.extend([xp - xk, gk])

        x = vertcat(*x)
        g = vertcat(*g)
        results, out = _ipopt_solve(x, g, lbx, ubx, verbosity)

        df = self.__retrieve_solution(results)
        df["z"] = np.linspace(0.0, self._Lz, self._Nz+1)

        return df, out

    def plot_reactor_state(self, df, ylim1=None, ylim2=None):
        """ Display reactor state profile. """
        plt.style.use("seaborn-white")
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(9, 4))

        ax1.plot(df["z"], df["Tg"] - 273.15, label="Gas")
        ax1.plot(df["z"], df["T1"] - 273.15, label="Wall (internal)")
        ax1.plot(df["z"], df["T2"] - 273.15, label="Wall (external)")

        for k, label in enumerate(df.columns[3:-2]):
            legend = MethaneCombustion1S.LATEX_NAMES[k]
            ax2.plot(df["z"], df[label], label=legend)

        ax2.set_yscale("log")

        ax1.legend(loc=1, frameon=True, framealpha=0.5)
        ax2.legend(loc=1, frameon=True, framealpha=0.5)

        ax1.grid(linestyle=":")
        ax2.grid(linestyle=":")

        ax1.set_xlabel("Position [m]")
        ax2.set_xlabel("Position [m]")

        ax1.set_ylabel("Temperature [°C]")
        ax2.set_ylabel("Mole fraction [-]")

        ax1.set_xlim(0.0, df["z"].max())
        ax2.set_xlim(0.0, df["z"].max())

        ax1.set_ylim(ylim1)
        ax2.set_ylim(ylim2)

        fig.tight_layout()


class RealGasRadNNET:
    """ Implements real gas radiative properties. """
    def __init__(self):
        self._c2 = 1.438776877e-02

    def _as(self, L, Tw, fv, n, k):
        """ Contribution of soot absortivity. """
        num = n * k
        den = (n**2 - k**2 + 2)**2 + 4 * num**2
        c = 36.0 * np.pi * fv * num / den
        
        b = 1.0 + (c * L * Tw) / self._c2
        a = 1.0 - (15.0 / np.pi**4) * polygamma(3, b)
        return a

    def _da(self):
        return 0

    def absorptivity(self, L, Tw, X_H2O, X_CO2, fv, n=1.6, k=0.5):
        a_s = self._as(L, Tw, fv, n, k)
        d_a = self._da()
        return d_a + a_s


def min_differentiable(a, b):
    """ Differentiable minimum function. """
    h = heaviside(b - a)
    return (1 - h) * b + h * a


def freeboard_thermal_conductivity(T, a=KG_COEFS):
    """ Thermal conductivity of reactor freeboard gas. """
    return sum(c * pow(T, n) for n, c in enumerate(a))


def freeboard_viscosity(T):
    """ Thermal conductivity of reactor freeboard gas. """
    return 1.0e-05 * (0.1672 * sqrt(T) - 1.058)


def validate_database_properties(db, gas, Ts=(300, 3000, 100)):
    """ Compare all species properties against Cantera. """
    def validate_species_properties(name, mw, lo, hi, gas, T):
        """ Compare species properties against Cantera. """
        spe = Species(mw, lo, hi)

        c1 = spe.cp_mole(T)[0]
        c2 = gas.species(name).thermo.cp(T)
        is_c_ok = np.allclose(c1, c2, rtol=1.0e-06, atol=1.0e-03)

        h1 = spe.enthalpy_mole(T)[0]
        h2 = gas.species(name).thermo.h(T)
        is_h_ok = np.allclose(h1, h2, rtol=1.0e-06, atol=1.0e-03)

        return is_c_ok and is_h_ok

    for T in np.linspace(*Ts):
        for name, (mw, lo, hi) in db.items():
            is_ok = validate_species_properties(name, mw, lo, hi, gas, T)

            if not is_ok:
                print(f"Failed validating {name} at {T}K")
                return False

    return True


def check_equivalent_cantera(gas, mdot):
    """ Check output of a similar reactor in Cantera. """
    src = ct.Reservoir(gas)
    dst = ct.Reservoir(gas)
    rea = ct.IdealGasReactor(gas)

    mfc = ct.MassFlowController(src, rea, mdot=mdot)
    ___ = ct.PressureController(rea, dst, master=mfc, K=0.1)

    sim = ct.ReactorNet([rea])
    sim.advance_to_steady_state()

    print(rea.thermo.report())


def plot_reactor_state(df, ylim1=None, ylim2=None):
    """ Display reactor state profile. """
    plt.style.use("seaborn-white")
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(9, 4))

    ax1.plot(df["z"], df["T"] - 273.15)
    ax1.grid(linestyle=":")

    for label in df.columns[1:-2]:
        legend = label.split("_")[-1]
        ax2.plot(df["z"], df[label], label=legend)

    ax2.set_yscale("log")
    ax2.legend(loc="best")
    ax2.grid(linestyle=":")
    ax2.set_ylim(1e-9, 1)

    ax1.set_xlabel("Position [m]")
    ax2.set_xlabel("Position [m]")

    ax1.set_ylabel("Temperature [°C]")
    ax2.set_ylabel("Mole fraction [-]")

    ax1.set_xlim(0.0, df["z"].max())
    ax2.set_xlim(0.0, df["z"].max())

    ax1.set_ylim(ylim1)
    ax2.set_ylim(ylim2)

    fig.tight_layout()


def solve_constrain_method(mix, Nz, Lz, y0, t0, mdot, Ac, Pc,
                           htc, Tw, verbosity=3):
    """ Formulate problem as finite differences constraints. """
    # Length of slice over flow direction [m].
    dz = Lz / Nz

    # The following is true across all sections:
    rho_u = mdot / Ac

    # Number of equations to solve per slice.
    Ns = 1 + mix.n_species

    # Number of equations with unknowns.
    Ne = Ns * Nz

    # All unknowns in a single array [*Y0, T0, *Y1, T1, ...].
    X = SX.sym("X", Ne + Ns)

    # Array of constraints with initial state.
    g = []

    # Bounds of variables values per cell.
    lbx, ubx = _get_solution_bounds([*y0, t0], Nz)

    # Create ODE model for slices derivatives.
    ode, _, _ = _formulate_ode_problem(mix)

    # Initialize cellz coordinate.
    z = 0

    for k in range(Ns, Ne + Ns, Ns):
        # Get slice/past slice indices over array.
        last = k + Ns - 1
        past = k - Ns

        # Retrieve slice state.
        Xk = X[k:last+1]

        # k-epsilon ratio proposed by Mujumdar.
        ke = z / Lz
        z += dz

        # Compute RHS of ODE system.
        dXdz = ode(Xk, [rho_u, ke, htc, Pc, Ac, Tw])

        # Add ODE constraints.
        g.extend([
            (Xk[0] - X[past+0]) / dz - dXdz[0],
            (Xk[1] - X[past+1]) / dz - dXdz[1],
            (Xk[2] - X[past+2]) / dz - dXdz[2],
            (Xk[3] - X[past+3]) / dz - dXdz[3],
            (Xk[4] - X[past+4]) / dz - dXdz[4],
            (Xk[5] - X[past+5]) / dz - dXdz[5],
            (Xk[6] - X[past+6]) / dz - dXdz[6]
        ])

    results, out = _ipopt_solve(X, vertcat(*g), lbx, ubx, verbosity)

    df = _retrieve_solution(results, mix)
    df["z"] = np.linspace(0.0, Lz, Nz+1)

    return df, out


def solve_multiple_shooting(mix, Nz, Lz, y0, t0, mdot, areac, perim,
                            htcfn, tempw, kefun, verbosity=3):
    """ Formulate problem through multiple shooting constraints. """
    # Length of slice over flow direction [m].
    dz = Lz / Nz

    # Integrator for generating stepping function.
    integ_rk4 = _make_get_stepper_rk4(
        mix, dz, mdot, areac, perim, kefun, tempw, htcfn)

    # List of variables
    w = []

    # Bounds of variables values per cell.
    lbw, ubw = _get_solution_bounds([*y0, t0], Nz)

    # Constraints
    g = []

    # Create and enforce initial state.
    Xk = MX.sym("X0", 7)
    w.append(Xk)

    for k in range(Nz):
        # Create and call integrator, and "lift" the variable.
        X_prev = integ_rk4(k * dz)(Xk)

        # Create new symbolic state
        Xk = MX.sym(f"X{k+1}", 7)
        w.append(Xk)

        # Constrain problem
        g.append(X_prev - Xk)

    results, out = _ipopt_solve(vertcat(*w), vertcat(*g),
                               lbw, ubw, verbosity)

    df = _retrieve_solution(results, mix)
    df["z"] = np.linspace(0.0, Lz, Nz+1)

    return df, out


def _get_solution_bounds(X0, Nz):
    """ Generate lower and upper bounds for solution. """
    lbx = np.hstack((X0, np.repeat([LBW_BASE], Nz, 0).ravel()))
    ubx = np.hstack((X0, np.repeat([UBW_BASE], Nz, 0).ravel()))
    return lbx, ubx


def _formulate_ode_problem(mix):
    """ Create symbolic ODE right-hand side of problem. """
    # Declare free symbols.
    rho_u = SX.sym("rho_u", 1)
    ke = SX.sym("ke", 1)
    h = SX.sym("h", 1)
    P = SX.sym("P", 1)
    A = SX.sym("A", 1)
    W = SX.sym("W", 1)

    # Declare unknowns.
    Y = SX.sym("Y", 6)
    T = SX.sym("T", 1)

    # Mass production rate of all species.
    w = mix.rate_eff(Y, T, ke)

    # Specific heat of mixture.
    cp = mix.specific_heat(T, Y)

    # Enthalpy of species.
    hm = mix.enthalpies(T)

    # Source terms in energy equation.
    hdot = sum1(hm * w)
    conv = h * (P / A) * (W - T)

    # Compose equations RHS.
    dYdz = w / rho_u
    dTdz = (conv - hdot) / (rho_u * cp)

    # Pack parameters, variables, and equations.
    p = vertcat(rho_u, ke, h, P, A, W)
    x = vertcat(Y, T)
    dxdz = vertcat(dYdz, dTdz)

    # Create callable for use in integrator.
    f = Function("f", [x, p], [dxdz], ["x", "p"], ["dxdz"])

    return f, x, p


def _ipopt_solve(x, g, lbx, ubx, verbosity=3):
    """ Solve reactor NLP and returns results and outputs. """
    nlp = {"x": x, "f": 1, "g": g}

    # https://coin-or.github.io/Ipopt/OPTIONS.html
    opts = {
        "ipopt.print_level": verbosity,
        "ipopt.linear_solver": "mumps",
        # "ipopt.output_file": "ipopt.txt"
    }

    solver = nlpsol("solver", "ipopt", nlp, opts)

    with Capturing() as out:
        results = solver(x0=ubx/2, lbx=lbx, ubx=ubx, lbg=0.0, ubg=0.0)

    return results, "\n".join(out)


def _make_get_stepper_rk4(mix, dz, mdot, areac, perim, kefun, tempw, htcfn):
    f, x, _ = _formulate_ode_problem(mix)

    def get_params(t):
        """ Compute parameters at current coordinate. """
        A = areac(t)
        P = perim(t)
        W = tempw(t)
        h = htcfn(t)
        ke = kefun(t)
        return [mdot / A, ke, h, P, A, W]

    def get_stepper_rk4(z):
        """ Retrieve stepping function for current coordinate. """
        # Intermediate parameters.
        p1 = get_params(t=z)
        p2 = get_params(t=z + dz / 2)

        # Evaluate intermediate steps.
        k0 = 0.0
        k1 = f(x + k0 * dz / 1, p1)
        k2 = f(x + k1 * dz / 2, p2)
        k3 = f(x + k2 * dz / 2, p2)
        k4 = f(x + k3 * dz / 1, p1)

        # # Step towards new solution.
        dx = (k1 + 2 * k2 + 2 * k3 + k4) * dz / 6

        # XXX: simple Euler debug.
        # dx = f(x, p1) * dz

        # Return step integrator.
        return Function("F", [x], [x + dx], ["x"], ["xf"])

    return get_stepper_rk4


def _retrieve_solution(results, mix):
    """ Unpack solution from non-linear solver. """
    eqns = [*mix.species_names, "T"]
    ns = len(eqns) - 1

    x = results["x"].full().ravel()
    n = len(eqns)

    solution = {}

    for k, name in enumerate(eqns):
        name = f"Y_{name}" if name != "T" else name        
        solution[name] = x[k::n]
        
    df = pd.DataFrame(solution)

    old_cols = df.columns[:ns]
    new_cols = [f"X_{name}" for name in eqns[:-1]]

    for k, row in df.iterrows():
        Yk = row[:ns].to_numpy()
        Xk = mix.mass_to_mole_fraction(Yk)
        df.loc[k, new_cols] = Xk.full().ravel()

    df["bal"] = df[new_cols].sum(axis=1)
    df.drop(columns=old_cols, inplace=True)
    
    return df


def kiln_bed_area(R, h):
    """ Compute bed cross-section in rotary kiln.
    
    Parameters
    ----------
    R : float
        Reactor radius [m].
    h : float
        Bed height [m].

    Return
    ------
    float
        Reactor cross section [m²].
    """
    # Gap between bed and center [m].
    d = R - h

    # Semi-surface length of bed [m].
    b = np.sqrt(R**2 - d**2)

    # Semi-angle of bed [rad].
    phi = 2 * np.arcsin(b / R)

    # Area unde semi-angle [m²].
    Aphi = (phi / 2) * R

    # Area of triangle over bed [m²].
    Atri = d * (2 * b) / 2

    # Area of reactor bed cross-section [m²]
    Abed = Aphi - Atri

    return Abed, 2 * b





# # Specific mass [kg/m³].
# rho = 150.0

# # Specific heat in mass units [J/(kg.K)].
# cpm = 700.0

# # Mass flow rate [kg/s].
# mdot = 0.096

# # Reactor length [m].
# L = 11.6

# # Length discretization [m].
# dx = 0.01

# # Initial temperature [K].
# T0 = 300.0

# # Global heat transfer coefficient [W/(m².K)].
# U = 50.0

# # Constant reactor cross-section [m²] and width [m].
# A, l = kiln_bed_area(R=0.6, h=0.18)

# # Center points of cells in FV.
# xc = np.arange(dx/2, L-0.49*dx, dx)
