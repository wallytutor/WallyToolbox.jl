# -*- coding: utf-8 -*-

# Import Python built-in modules.
from typing import Callable

# Import external modules.
from scipy.optimize import root
import cantera as ct

# Own imports.
from ..models import RadcalWrapper
from ..phases import FreeboardMethane1SLeak
from ..phases import SilicaBasedBed
from ..phases import find_air_leak
from ..types import NumberOrVector
from ..types import PathLike
from ..types import Vector
from .rotary_kiln_mix import RotaryKilnMixModel
from .rotary_kiln import RotaryKilnModel


def solve_custom_silica_kiln(
        model,
        *,
        fmodel: PathLike,
        fscale: PathLike,
        x_o2: float,
        mf0: float,
        tf0: float,
        lambda0: float,
        fuel: str | dict[str, float],
        oxid: str | dict[str, float],
        pf0: float,
        mechanism: str,
        kinetics: str,
        ke: Callable[[NumberOrVector], NumberOrVector],
        mb0: float,
        tb0: float,
        rho_bed: float,
        aor: float,
        kb: Callable[[float], float],
        L: float,
        R: float,
        alpha: float,
        n: float,
        nz: int,
        hl: float,
        solver: str,
        root_method: str,
        nlptol: float,
        max_steps: int,
        atol: float,
        relax: float,
        minrad: int,
        thick_coat: Callable[[Vector], Vector],
        thick_refr: Callable[[Vector], Vector],
        thick_shell: Callable[[Vector], Vector],
        k_coat: Callable[[Vector, Vector], Vector],
        k_refr: Callable[[Vector, Vector], Vector],
        k_shell: Callable[[Vector, Vector], Vector],
        kramers_exp: bool,
        method_bed: str,
        eps_bed: float,
        eps_ref: float,
        eps_env: float,
        h_env: float,
        T_env: float
    ) -> RotaryKilnModel:
    """ Simulate a natural gas kiln processing silicates.

    Parameters
    ----------
    model: str
        Type of model approach to use.
    fmodel: PathLike
        Path to Keras sequential model to be loaded. 
    fscale: PathLike
        Path to model scaler to be loaded.
    x_o2: float
        Measure oxygen mole fraction at fumes outlet.
    mf0: float
        Inlet total mass flow rate [kg/s].
    tf0: float
        Inlet temperature [K].
    lambda0: float
        Inlet equivalence ratio [-].
    fuel: str | dict[str, float]
        Fuel composition in mole fractions [-].
    oxid: str | dict[str, float]
        Oxidizer composition in mole fractions [-].
    pf0: float
        Freeboard operating pressure [Pa].
    mechanism: str
        Kinetics mechanism in Cantera format.
    kinetics: str
        Switch for EBU or MAK rate equations.
    ke: Callable[[NumberOrVector], NumberOrVector]
        Eddy break-up (EBU) k-epsilon ratio.
    mb0: float
        Inlet total mass flow rate [kg/h].
    tb0: float
        Inlet temperature [K].
    rho_bed: float
        Material apparent specific weight [kg/m³].
    aor: float
        Material angle of repose (AOR) in degrees [°].
    kb: Callable[[float], float]
        Material apparent thermal conductivity [W/(m.K)].
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
    nz: int
        Number of cells to discretize kiln over length. Because
        it is aimed to be used with a finite volume formulation,
        cells are discretized over an equally spaced array with
        lenght `nz` and center of first/last cells are displaced
        to half-way the step size.
    hl: float
        Height of bed at product discharge end [m].
    solver: str
        Solver for constraints, "casadi-ipopt" or "scipy-root".
        The default is preferred for performance but in some cases
        using constrained optimization with CasADi interface to
        Ipopt may provide more consistence in solution.
    root_method: str
        Method to use with solver "scipy-root". The default is
        recommended for the typical problem size found here but
        in some cases "df-sane" ensures avoids divergence due to
        problem numerical stiffness.
    nlptol: float
        Constrain violation tolerance for solver "casadi-ipopt".
    max_steps: int
        Maximum number of iteration steps for convergence.
    atol: float
        Absolute temperature change tolerance for convergence.
    relax: float
        Fraction of last flux to use when updating heat transfer.
    minrad: int
        Iteration to activate radiation for lower stiffness.
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
    kramers_exp: bool
        If True, consider coating in Kramer's equation solution.
    method_bed: str
        Method to integrate bed height profile in bed initialization.
    eps_bed: float
        Constant emissivity of bed used in heat fluxes initialization.
    eps_ref: float
        Constant emissivity of coating used in heat fluxes initialization.
    eps_env: float
        Constant emissivity of shell used in heat fluxes initialization.
    h_env: float
        Convective heat transfer coefficient to environment [W/(m.K)].
    T_env: float
        External environment temperature [K].

    Returns
    -------
    RotaryKilnModel
        Simulated kiln model for user custom post-processing.
    """
    air = "N2: 0.78, O2: 0.21, AR: 0.01"
    radcal = RadcalWrapper(fmodel, fscale)

    match model:
        case "builtin_mix":
            # NOTE: overwriting tf0 here.
            qm = find_air_leak(mechanism, mf0, tf0, lambda0,
                               fuel, oxid, 300.0, air, x_o2)
            mf0, tf0, lambda0 = qm.mass, qm.T, qm.equivalence_ratio()

            kiln =  RotaryKilnMixModel(
                L           = L,
                R           = R,
                alpha       = alpha,
                n           = n,
                phim        = mb0,
                nz          = nz,
                hl          = hl,
                radcal      = radcal,
                solver      = solver,
                root_method = root_method,
                nlptol      = nlptol
            )

            kiln.simulate(
                max_steps   = max_steps,
                atol        = atol,
                relax       = relax,
                minrad      = minrad,
                thick_coat  = thick_coat,
                thick_refr  = thick_refr,
                thick_shell = thick_shell,
                k_coat      = k_coat,
                k_refr      = k_refr,
                k_shell     = k_shell,
                mf0         = mf0,
                tf0         = tf0,
                lambda0     = lambda0,
                fuel        = fuel,
                oxid        = oxid,
                mb0         = mb0,
                tb0         = tb0,
                kramers_exp = kramers_exp,
                method_bed  = method_bed,
                eps_bed     = eps_bed,
                eps_ref     = eps_ref,
                eps_env     = eps_env,
                h_env       = h_env,
                T_env       = T_env,
                pf0         = pf0,
                mechanism   = mechanism,
                kinetics    = kinetics,
                ke          = ke,
                rho_bed     = rho_bed,
                aor         = aor,
                kb          = kb
            )
        case "external_mix":
            tfm = FreeboardMethane1SLeak(
                mf0         = mf0,
                tf0         = tf0,
                lambda0     = lambda0,
                fuel        = fuel,
                oxid        = oxid,
                x_o2        = x_o2,
                air         = air,
                ta0         = 300.0,
                p0          = pf0,
                mechanism   = mechanism,
                kinetics    = kinetics,
                ke          = ke
            )

            tbm = SilicaBasedBed(
                m0          = mb0,
                t0          = tb0,
                rho         = rho_bed,
                aor         = aor,
                kb          = kb
            )

            kiln =  RotaryKilnModel(
                L           = L,
                R           = R,
                alpha       = alpha,
                n           = n,
                phim        = mb0,
                nz          = nz,
                hl          = hl,
                radcal      = radcal,
                solver      = solver,
                root_method = root_method,
                nlptol      = nlptol
            )

            kiln.simulate(
                model_tfm   = tfm,
                model_tbm   = tbm,
                max_steps   = max_steps,
                atol        = atol,
                relax       = relax,
                minrad      = minrad,
                thick_coat  = thick_coat,
                thick_refr  = thick_refr,
                thick_shell = thick_shell,
                k_coat      = k_coat,
                k_refr      = k_refr,
                k_shell     = k_shell,
                kramers_exp = kramers_exp,
                method_bed  = method_bed,
                eps_bed     = eps_bed,
                eps_ref     = eps_ref,
                eps_env     = eps_env,
                h_env       = h_env,
                T_env       = T_env
            )
        case _:
            raise ValueError(f"Unknonw model {model}")

    return kiln
