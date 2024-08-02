# -*- coding: utf-8 -*-
""" Implements phase equilibria and diffusion in steel nitriding.

To-do list
==========
- Implement phase equilibria also using opengen for performance.
- Replace coefficients of diffusion by those of nitrogen.
- Full refactoring and clean-up.
"""
from io import StringIO
from casadi import SX
from casadi import exp
from casadi import log as ln
from casadi import heaviside
from casadi import vertcat
from casadi import dot
from casadi import nlpsol
from casadi import Function
from casadi import linspace
from scipy import sparse
from scipy import integrate
from matplotlib import pyplot as plt
import sys
import numpy as np
import opengen as og

__author__ = "Walter Dal'Maz Silva"
__version__ = "0.1.0"

# ELEMENT VA   VACUUM                    0.0000E+00  0.0000E+00  0.0000E+00 !
# ELEMENT FE   BCC_A2                    5.5847E+01  4.4890E+03  2.7280E+01 !
# ELEMENT N    1/2_MOLE_N2(G)            1.4007E+01  4.3350E+03  9.5751E+01 !
    
# Ideal gas constant [J/(mol.K)].
R = 8.31446261815324

# Atomic masses.
mm_fe = 5.5847E+01
mm_nn = 1.4007E+01

# Symbol for system temperature.
T = SX.sym('T')
    
    
class Capturing(list):
    """ Helper to capture excessive solver output.

    In some cases, specially when running from a notebook, it might
    be desirable to capture solver (here Ipopt specifically) output
    to later check, thus avoiding a overly long notebook.  For this
    end this context manager is to be used and redirect to a list.
    """
    def __enter__(self):
        self._stdout = sys.stdout
        sys.stdout = self._stringio = StringIO()
        sys.stderr = sys.stdout
        return self

    def __exit__(self, *args):
        self.extend(self._stringio.getvalue().splitlines())
        del self._stringio
        sys.stdout = self._stdout
        

def gm_magnetic(y_nn, Tc, beta, p, afm):
    """ Magnetic contribution to Gibbs energy of phase. """
    # Transform negative values.
    Tc = Tc if Tc > 0 else Tc / afm
    beta = beta if beta > 0 else beta / afm

    # Composition dependency of magnetic term for FCC only.
    if afm <= -3:
        Tc *= (1 - y_nn)
        beta *= (1 - y_nn)

    # Structure parameter.
    A = (518 / 1125) + (11692 / 15975) * (1 / p - 1)

    def f_lo(t):
        """ Function below Curie temperature. """
        a = (79 / 140, 474 / 497, 1/6, 1/135, 1/600)
        b = a[2] * t**3 + a[3] * t**9 + a[4] * t**15 
        return 1 - (a[0] / (p * t) + a[1] * (1 / p - 1) * b) / A

    def f_hi(t):
        """ Function above Curie temperature. """
        a = (1 / 10, 1 / 315, 1 / 1500)
        b = a[0] + a[1] * pow(t, -10) + a[2] * pow(t, -20)
        return -1 * pow(t, -5) * b / A

    # Relative temperature.
    tau = T / Tc

    # Select temperature range with HEAVY-SIDE function.
    h = heaviside(tau - 1)
    f = (1 - h) * f_lo(tau) + h * f_hi(tau)

    # Assembly model.
    return R * T * ln(1 + beta) * f


def g_sublaticce(x_nn, g_fe_nn, g_fe_va, l_fe_nn_va, c, Tc, beta, p, afm):
    """ Sublattice model for BCC and FCC phases. """
    # Compute site fraction of nitrogen in interstitial sub-lattice.
    y_nn = (x_nn / (1 - x_nn)) * (1 / c)

    # Compute site fraction of vacancies with balance.
    y_va = 1 - y_nn

    # Ideal mixing contribution.
    gmix = y_nn * g_fe_nn + y_va * g_fe_va

    # Entropy terms contribution
    smix = c * R * T * (y_nn * ln(y_nn) + y_va * ln(y_va))

    # Excess term contribution.
    lmix = y_nn * y_va * l_fe_nn_va

    # Magnetic term contribution.
    gmag = gm_magnetic(y_nn, Tc, beta, p, afm)

    # Compose molar Gibbs energy.
    return gmix + smix + lmix + gmag


def gparams(a):
    """ Parameter representation with 6 coefficients. """
    b = a[1] + a[2] * ln(T) + a[3] * T + a[4] * T**2
    return a[0] + T * b + a[5] / T


def mass_to_mole_fraction(w):
    """ Convert mass fraction of nitrogen into mole fraction.  """
    return w / (mm_nn * (w / mm_nn + (1 - w) / mm_fe))


def mole_to_mass_fraction(x):
    """ Convert mole fraction of nitrogen into mass fraction.  """
    return x * mm_nn / (x * mm_nn + (1 - x) * mm_fe)


def nitrogen_activity(kn, dg, T):
    """ Nitrogen activity in material. """
    return kn * exp(-dg / (R * T))


def get_symbols():
    ###############################################################
    # SYSTEM
    ###############################################################
    
    # Symbol for total molar fraction of nitrogen.
    x0 = SX.sym('x0')

    # Symbols for unknowns: phases fractions and compositions.
    phi = SX.sym('phi', 2)
    x_nn = SX.sym('x_nn', 2)

    # Aliases for phases fractions.
    phi_alpha = phi[0]
    phi_gamma = phi[1]

    # Aliases for molar fraction in phases.
    x_nn_alpha = x_nn[0]
    x_nn_gamma = x_nn[1]

    ###############################################################
    # REFERENCES
    ###############################################################
    
    # SER : BCC_A2 : CHECKED
    a_ghser_fe = (1224.83, 124.134, -23.5143, -4.39752e-03, -5.89269e-08, 77358.5)
    ghser_fe = gparams(a_ghser_fe)

    # SER : 1/2 N2 : CHECKED
    a_ghser_nn = (-3750.675, -9.45425, -12.7819, -1.76686e-04, 2.681e-09, -32374)
    ghser_nn = gparams(a_ghser_nn) * (1/2)
    
    ###############################################################
    # ALPHA
    ###############################################################
    
    # G(BCC_A2,FE:VA;0) : CHECKED
    g_fe_va_alpha = ghser_fe

    # G(BCC_A2,FE:N;0) : CHECKED
    a_g_fe_nn_alpha = (93562, 165.07, 0, 0, 0, 0)
    g_fe_nn_alpha = gparams(a_g_fe_nn_alpha) + ghser_fe + 3 * ghser_nn

    # Magnetic model parameters : CHECKED.
    Tc_alpha, beta_alpha, p_alpha, afm_alpha = 1043, 2.22, 0.40, -1

    # BCC_A2 R-K parameter : CHECKED.
    l_fe_nn_va_alpha = 0.0

    # Stoichiometric parameter : CHECKED.
    c_alpha = 3
    
    ###############################################################
    # GAMMA
    ###############################################################
    
    # G(FCC_A1,FE:VA;0) : CHECKED.
    a_g_fe_va_gamma = (-1462.4, 8.282, -1.15, 6.4e-04, 0.0, 0.0)
    g_fe_va_gamma = gparams(a_g_fe_va_gamma) + ghser_fe

    # G(FCC_A1,FE:N;0) : CHECKED.
    a_g_fe_nn_gamma = (-37460, 375.42, -37.6, 0, 0, 0)
    g_fe_nn_gamma = gparams(a_g_fe_nn_gamma) + ghser_fe + ghser_nn

    # Magnetic model parameters: CHECKED.
    Tc_gamma, beta_gamma, p_gamma, afm_gamma = -201, -2.1, 0.28, -3

    # FCC_A1 R-K parameter : CHECKED.
    l_fe_nn_va_gamma = -26150.0

    # Stoichiometric parameter : CHECKED.
    c_gamma = 1
    
    ###############################################################
    # COMPUTE MOLAR GIBBS ENERGIES
    ###############################################################
    
    # BCC_A2 molar Gibbs energy.
    Gm_alpha = g_sublaticce(x_nn_alpha, g_fe_nn_alpha, g_fe_va_alpha,
                            l_fe_nn_va_alpha, c_alpha, Tc_alpha,
                            beta_alpha, p_alpha, afm_alpha)

    # FCC_A1 molar Gibbs energy.
    Gm_gamma = g_sublaticce(x_nn_gamma, g_fe_nn_gamma, g_fe_va_gamma,
                            l_fe_nn_va_gamma, c_gamma, Tc_gamma,
                            beta_gamma, p_gamma, afm_gamma)

    ###############################################################
    # ASSEMBLY OPTIMIZATION PROBLEM
    ###############################################################
    
    # Assembly symbolicy cost function.
    f = phi_alpha * Gm_alpha + phi_gamma * Gm_gamma

    # Create total nitrogen content constraint.
    g0 = phi_alpha * x_nn_alpha + phi_gamma * x_nn_gamma - x0

    # Constrain phase fractions.
    g1 = phi_alpha + phi_gamma - 1

    # Create symbolic vectors.
    x = vertcat(phi, x_nn)
    g = vertcat(g0, g1)
    p = vertcat(T, x0)

    return x, p, g, f

    
def get_system_calculator():
    x, p, g, f = get_symbols()
    
    # Construct optimization problem.
    opts = {'ipopt': {'print_level': 5}}
    nlpt = {'x': x, 'f': f, 'g': g, 'p': p}
    solver = nlpsol('solver', 'ipopt', nlpt, opts)
    
    def ce(T0_num, w0_num, guess=None, kn=0.05, tol=1.0e-06):
        """ Compute equilibrium at given point. """
        x0_num = mass_to_mole_fraction(w0_num)

        # A good initial guess is expected for now.
        if guess is None:
            guess = [1, 1, x0_num, x0_num]

        with Capturing() as output:
            sol = solver(x0=guess, p=[T0_num, x0_num],
                         lbx=0, ubx=1, lbg=-tol, ubg=tol)

        sol['ac'] = nitrogen_activity(kn, sol['f'], T0_num)
        sol['x0'] = x0_num
        sol['w0'] = w0_num

        return sol, output
    
    return ce


CE = get_system_calculator()


def equilibrate(T, w, guess=None):
    return CE(T, w, guess=guess)[0]["x"].full().flatten()


class NitridingLayer:
    """ Nitriding simulation with phase transformation (local equilibria). """
    @staticmethod
    def _coef_steel(T, d0, ea, R=8.314472):
        """ Generic Arrhenius law for diffision coefficient. """
        return d0 * np.exp(-ea / (R * T))

    @staticmethod
    def _coef_gamma(T):
        """ Diffusion coefficient of nitrogen in austenite. """
        return NitridingLayer._coef_steel(T, d0=4.84e-05, ea=155000.0)

    @staticmethod
    def _coef_alpha(T):
        """ Diffusion coefficient of nitrogen in ferrite. """
        return NitridingLayer._coef_steel(T, d0=4.87e-07, ea=80640.0)

    @staticmethod
    def _coef_mixture(T, u, guess):
        """ Volume averaged diffusion coefficient in mixture. """
        guess = NitridingLayer.fraction_alpha(T, u, guess)
        v = guess[:, 0]

        # PARALLEL RESISTANCE MODEL
        inv_alpha = (0 + v) / NitridingLayer._coef_alpha(T)
        inv_gamma = (1 - v) / NitridingLayer._coef_gamma(T)
        return 1.0 / (inv_alpha + inv_gamma), guess

        # MIXTURE MODEL
        # dir_alpha = NitridingLayer._coef_alpha(T) * v
        # dir_gamma = NitridingLayer._coef_gamma(T) * (1 - v) 
        # return dir_alpha + dir_gamma

        # LABYRINTH MODEL
        # return NitridingLayer._coef_alpha(T) * (1 - v) ** 2

    @staticmethod
    def fraction_alpha(T, u, guess):
        """ Composition and temperature phase fraction dependency. """
        return np.array([equilibrate(T, uk, guess=guess[k])
                         for k, uk in enumerate(u)])

    def _beta(self, u, t, T=None):
        """ Return numerical scheme coefficient. """
        T = self._temperature(t) if T is None else T
        coef, self._guess = self._coef_mixture(T, u, self._guess)
        return coef / self._dx2

    def _face_coefficient(self, u, t):
        """ Model coefficients on cell interfaces. """
        beta = self._beta(u, t)
        return 2 * (beta[:-1] * beta[1:]) / (beta[:-1] + beta[1:])

    def _get_problem_matrix(self, u, t):
        """ Create sparse diffusion integration matrix. """
        # Compute coefficients on interfaces of cells.
        k = self._face_coefficient(u, t) * self._dt
    
        # Compute main diagonal of implicit problem.
        mm = 1 + (k[:-1] + k[1:])
    
        # Stack main diagonals with B.C.
        # mm = np.hstack((1.0, mm, 1.0 + k[-1]))
        mm = np.hstack((1.0, mm, 1.0))

        # Upper diagonal starting with Dirichlet B.C.
        ke = np.hstack((0.0, -1 * k[:-1]))

        # Lower diagonal ending with symmetry B.C.
        # kw = np.hstack((-1 * k[1:], -k[-1]))
        kw = np.hstack((-1 * k[1:], 0.0))

        # Compose tridiagonal problem matrix.
        M = sparse.diags(mm, offsets=0) +\
            sparse.diags(kw, offsets=-1) +\
            sparse.diags(ke, offsets=1)
    
        return M.tocsr()

    def __call__(self, t, u):
        """ Problem derivatives for mass fraction of nitrogen. """
        # Allocate memory and set first B.C./derivative to zero.
        udot = np.zeros_like(u)

        # Compute coefficients on interfaces of cells.
        k = self._face_coefficient(u, t)
        
        # Fluxes on "East" faces.
        de_x_ue = k[1:] * u[2:]

        # Fluxes on "West" faces.
        dw_x_uw = k[:-1] * u[:-2]

        # Compute inner domain derivatives.
        udot[1:-1] = de_x_ue - (k[:-1] + k[1:]) * u[1:-1] + dw_x_uw

        # Apply symmetry B.C. to problem.
        # udot[-1] = k[-1] * (u[-2] - u[-1])

        return udot

    def _build(self, t_end, x_end, u0, T, **kwargs):
        """ Prepare problem internals for simulation. """
        # Discretize time, retrieve steps.
        nt = kwargs.get('nt', int(t_end) + 1)
        t_eval, self._dt = np.linspace(0, t_end, nt, retstep=True)

        # Discretize space, retrieve steps, transform values.
        self._x, dx = np.linspace(0.0, x_end, len(u0), retstep=True)
        self._x *= 1_000_000
        self._dx2 = dx * dx

        # Store values for post-processing.
        self._temperature = T
        self._T_end = T(t_end)

        # Compute initial guess.
        self._guess = np.array([equilibrate(T(0), uk) for uk in u0])
        
        return t_eval

    def _plot_final_profile(self, u):
        """ Display integration results (profiles). """
        v = self.fraction_alpha(self._T_end, u, self._guess)[:, 0]
        beta = self._beta(u, None, T=self._T_end)

        plt.close('all')
        plt.style.use('seaborn-whitegrid')
        fig = plt.figure(figsize=(12, 9))

        ax = plt.subplot(311)
        plt.plot(self._x, 100 * u)
        plt.ylabel("Nitrogen content [%wt]")

        ax = plt.subplot(312, sharex=ax)
        plt.plot(self._x, 100 * v)
        plt.ylabel("Ferrite fraction [%]")

        ax = plt.subplot(313, sharex=ax)
        plt.plot(self._x, beta)
        plt.ylabel("Problem constant [1/s]")
        plt.xlabel("Position [µm]")

        plt.tight_layout()

        return fig

    def solve_explicit(self, t_end, x_end, u0, T, **kwargs):
        """ Simulate explicit problem with provided conditions. """
        t_eval = self._build(t_end, x_end, u0, T, **kwargs)
        opts = dict(method='RK23', t_eval=t_eval, vectorized=False,
                    max_step=kwargs.get('max_step', 1.0))
        self._sol = integrate.solve_ivp(self, [0, t_end], u0, **opts)

        if not self._sol.success:
            raise ValueError('Last simulation failed...')

        return self._plot_final_profile(self._sol.y.T[-1])

    def solve_implicit(self, t_end, x_end, u0, T, **kwargs):
        """ Simulate implicit problem with provided conditions. """
        t_eval = self._build(t_end, x_end, u0, T, **kwargs)
        u = u0.copy()

        for k, t in enumerate(t_eval):
            u[0] = u[-1] = u0[0]
            
            if not k % kwargs.get("ofreq", 10):
                print(f"Advancing at {t:.2f} s")

            M = self._get_problem_matrix(u, t)
            u = sparse.linalg.spsolve(M, u)

        self._u = u
        return self._plot_final_profile(u)

    @property
    def solution(self):
        """ Access to problem solution. """
        if not hasattr(self, '_sol'):
            raise ValueError('First call `solve_explicit`...')
        return self._sol
    
    
def make_optimizer():
    # https://alphaville.github.io/optimization-engine/docs/python-interface.html
    # https://alphaville.github.io/optimization-engine/docs/python-tcp-ip
    x, p, g, f = get_symbols()

    # from IPython import embed; embed(colors="Linux")
    
    set_c = og.constraints.Zero()
    
    rect = og.constraints.Rectangle(xmin=[0, 0, 0, 0], 
                                    xmax=[1, 1, 1, 1])
    
            # .with_penalty_constraints(g)  \
    # problem = og.builder.Problem(x, p, f)          \
    #     .with_aug_lagrangian_constraints(g, set_c) \
    #     .with_constraints(rect)
    problem = og.builder.Problem(x, p, f)
        # .with_constraints(rect)


    meta = og.config.OptimizerMeta()         \
        .with_version("0.1.0")               \
        .with_authors(["W. Dal'Maz Silva"])  \
        .with_licence("MIT")                 \
        .with_optimizer_name("ceqsier")

    # This is the default
    tcp_config = og.config.TcpServerConfiguration('127.0.0.1', 8333)
    
    build_config = og.config.BuildConfiguration()  \
        .with_build_directory("python_build")      \
        .with_build_mode("debug")                  \
        .with_tcp_interface_config(tcp_config)
        
    solver_config = og.config.SolverConfiguration()   \
                .with_lbfgs_memory(20)                \
                .with_tolerance(1.0e-06)              \
                .with_max_inner_iterations(10000)

    builder = og.builder.OpEnOptimizerBuilder(
        problem,
        metadata=meta,
        build_configuration=build_config,
        solver_configuration=solver_config)

    builder.build()


if __name__ == "__main__":
    make_optimizer()
