# -*- coding: utf-8 -*-
"""
Dimensionless
=============

When dealing with reactor models, it is always useful to be able to quickly
compute approximate dimensionless numbers for the studied case. In what follows
we provide a brief description of these quantities as implemented in this
package. Definitions might vary according to the author or field of application
and here we follow solely [Ref.2]_.

Reynolds Number
---------------

*This dimensionless group is named for Osborne Reynolds (1842-1912),
professor of engineering at the University of Manchester. He studied the
laminar-turbulent transition, turbulent heat transfer, and theory of
lubrication* [Ref.2]_. In general we denote Reynolds number by
:math:`\\mathrm{Re}` and it is used to delineate flow regimes. For circular
tubes it is defined as:

.. math::

    \\mathrm{Re} = \\frac{\\rho \\langle v_{z} \\rangle D}{\\mu}

where :math:`\\langle v_{z} \\rangle` is the average flow velocity in axial
direction and :math:`D` is the tube diameter. For values up 2100 the flow
is assumed laminar if steady state is established and density is constant.
For more, see [Ref.2]_, Chapter 2.

Prandtl and Schmidt Numbers
---------------------------

*Ludwig Prandtl (1875-1953) (pronounced "Prahn-t'), who taught in Hannover and
Gottingen and later served as the Director of the Kaiser Wilhelm Institute for
Fluid Dynamics, was one of the people who shaped the future of his field at the
beginning of the twentieth century; he made contributions to turbulent flow and
heat transfer, but his development of the boundary-layer equations was his
crowning achievement* [Ref.2]_. The dimensionless quantity appear under two
forms of interest for the analysis of reactors: its thermal and its chemical
versions. In thermal version, this number compares the kinematic viscosity
:math:`nu` to the thermal diffusivity :math:`\alpha`, which is replaced by
species diffusivity in its chemical version, which is more often referred to as
Schmidt number. *Ernst Heinrich Wilhelm Schmidt (1892-1975), who taught at
the universities in Gdansk, Braunschweig, and Munich (where he was the
successor to Nusselt)* [Ref.2]_. The ratio :math:`\frac{\nu}{\alpha}` indicates
the relative ease of momentum and energy or species transport in flow systems.
This dimensionless ratio in thermal form is given by

.. math::

    \\mathrm{Pr} = \\frac{\\nu}{\\alpha} = \\frac{C_{p} \\mu}{k}

If transport properties for a gas are not available, thermal Prandtl number can
be estimated at low pressure and non-polar molecules mixtures with help of
Eucken formula as

.. math::

    \\mathrm{Pr} = \\frac{C_{p}}{C_{p} + \\frac{5}{4}R}

Schmidt number range can be much broader than its thermal relative, Prandtl
number. This is given by the effects of cross-section and molar weight
determining mass diffusivity of gas species. Since this number is always
defined for a pair of species, here we will try to make it more general by
using the mixture averaged diffusion coefficients as provided by Cantera's
`Transport` method `mix_diff_coeffs`.

.. math::

    \\mathrm{Sc}_{min,max} = \\frac{\\nu}{D_{min,max}}

For more, see [Ref.2]_, Chapter 9.

Péclet Number
-------------

*Jean-Claude-Eugene Peclet (pronounced "Pay-clay" with the second syllable
accented) (1793-1857) authored several books including one on heat conduction*
[Ref.2]_. This number is nothing more than the multiplication of Reynolds and
Prandtl or Schmidt numbers. By simplifying factors one easily determines that
it represents the ratio of convective by diffusive transport (thermal or
species). High :math:`\\mathrm{Pe}` limit represents the plug-flow behavior.

.. math::

    \\mathrm{Pe}_{th} = \\mathrm{Re} \\mathrm{Pr}\\qquad
    \\mathrm{Pe}_{ch} = \\mathrm{Re} \\mathrm{Sc}

Grashof Number
--------------

*Franz Grashof (1826-1893) (pronounced "Grahss-hoff). He was professor of
applied mechanics in Karlsruhe and one of the founders of the Verein Deutscher
Ingenieure in 1856* [Ref.2]_. The Grashof number is the characteristic group
occurring in analyses of free convection. It approximates the ratio of the
buoyancy to viscous force acting on a fluid.

**TODO: implement diffusional Gr. The diffusional Grashof number arises because
of the buoyant force caused by the concentration inhomogeneities.**

.. math::

    \\mathrm{Gr} = \frac{g\beta l^{3} \\Delta T}{\nu^{2}}


Rayleigh Number
---------------

Rayleigh number is the multiplication of Grashof and Prandtl numbers.
See Rayleigh_.

.. _Rayleigh: https://en.wikipedia.org/wiki/Rayleigh_number
"""
import cantera as ct


DEBUG = False


def _get_mu(gas, mu):
    """ Helper to retrieve viscosity. """
    if mu is None:
        try:
            return gas.viscosity
        except ct.CanteraError as err:
            if DEBUG:
                print(f"While retrieving viscosity: {err}")
            raise NotImplementedError("Missing viscosity")
    return mu


def Re(gas, Uz, D, mu=None):
    """ Returns Reynolds number.

    Parameters
    ----------
    gas : cantera.Solution
        Gas phase with transport properties. If transport manager does not
        implement dynamic viscosity, this shall be provided through `mu`.
    U : float
        Fluid velocity in meters per second.
    D : float
        Problem characteristic diameter in meters.
    mu : float, optional
        Dynamic viscosity in pascal times second. Default is None.

    Raises
    ------
    AssertionError
        If gas has no transport manager and `mu` was not supplied.

    Returns
    -------
    float
        Reynolds number.
    """
    return gas.density * Uz * D / _get_mu(gas, mu)


def Pr(gas, mu=None, k=None):
    """ Returns Prandtl number.

    Parameters
    ----------
    gas : cantera.Solution
        Gas phase with transport properties. If transport manager does not
        implement dynamic viscosity, this shall be provided through `mu`.
    mu : float, optional
        Dynamic viscosity in pascal times second. Default is `None`.
    k : float, optional
        Conductivity in watts per meter times kelvin. Default is `None`.

    Raises
    ------
    ValueError
        Missing thermal conductivity and gas has not transport manager.
    NotImplementedError
        If gas has no transport manager and `mu` was not supplied.

    Returns
    -------
    float
        Prandtl number.
    """
    cp = gas.cp_mass

    def eucken():
        if k is None:
            raise ValueError("Missing thermal conductivity")

        try:
            return cp * _get_mu(gas, mu) / k
        except ct.CanteraError as err:
            raise NotImplementedError(f"Approximation not implemented: {err}")
            # FIXME this is wrong!
            # print(f'Using Eucken approximation : {err}')
            # return cp / (cp + 0.00125 * cantera.gas_constant)

    try:
        return cp * _get_mu(gas, mu) / gas.thermal_conductivity
    except ct.CanteraError:
        return eucken()


def Sc(gas, mu=None, Dab=None):
    """ Returns Schmidt number.

    Parameters
    ----------
    gas : cantera.Solution
        Gas phase with transport properties. If transport manager does not
        implement dynamic viscosity, this shall be provided through `mu`.
    mu : float, optional
        Dynamic viscosity in pascal times second. Default is `None`.
    Dab : float, optional
        Species diffusivity in square meters per second. Default is `None`.

    Raises
    ------
    AssertionError
        If gas has no transport manager and `mu` or `Dab` were not supplied.

    Returns
    -------
    tuple
        Minimum and maximum Schmidt number.
    """
    try:
        kappa_min = min(gas.mix_diff_coeffs)
        kappa_max = max(gas.mix_diff_coeffs)
    except ct.CanteraError:
        if Dab is None:
            raise ValueError("Missing diffusivity")
        kappa_min = kappa_max = Dab

    nu = _get_mu(gas, mu) / gas.density
    return nu / kappa_max, nu / kappa_min


def Pe(gas, Uz, D, mu=None, Dab=None, k=None):
    """ Returns Peclet numbers.

    Parameters
    ----------
    gas : cantera.Solution
        Gas phase with transport properties. If transport manager does not
        implement dynamic viscosity, this shall be provided through `mu`.
    U : float
        Fluid velocity in meters per second.
    D : float
        Problem characteristic diameter in meters.
    mu : float, optional
        Dynamic viscosity in pascal times second. Default is `None`.
    Dab : float, optional
        Species diffusivity in square meters per second. Default is `None`.
    k : float, optional
        Conductivity in watts per meter times kelvin. Default is `None`.

    Returns
    -------
    tuple
        A tuple containing the thermal Peclet number and another tuple with
        the minimum and maximum chemical Peclet numbers.
    """
    Re_ev = Re(gas, Uz, D, mu=mu)
    Sc_ev = Sc(gas, mu=mu, Dab=Dab)
    Pe_th = Re_ev * Pr(gas, mu=mu, k=k)
    Pe_ch = (Re_ev * Sc_ev[0], Re_ev * Sc_ev[1])
    return Pe_th, Pe_ch


def Gr(gas, D, Tw, mu=None, g=9.81):
    """ Returns Grashof number.

    Parameters
    ----------
    D : float
        Problem characteristic diameter in meters.
    Tw : float
        Pipe wall temperature in kelvin.
    mu : float, optional
        Dynamic viscosity in pascal times second. Default is `None`.
    g : float, optional
        Gravity acceleration in meters per square second. Default is `9.81`.

    Raises
    ------
    AssertionError
        If gas has no transport manager and `mu` was not supplied.

    Returns
    -------
    float
        Grashof number.
    """
    beta = gas.thermal_expansion_coeff
    nu = _get_mu(gas, mu) / gas.density
    return beta * g * (Tw - gas.T) * D ** 3 / nu ** 2


def Ra(gas, D, Tw, mu=None, k=None, g=9.81):
    """ Returns Rayleigh number.

    Parameters
    ----------
    D : float
        Problem characteristic diameter in meters.
    Tw : float
        Pipe wall temperature in kelvin.
    mu : float, optional
        Dynamic viscosity in pascal times second. Default is `None`.
    k : float, optional
        Conductivity in watts per meter times kelvin. Default is `None`.
    g : float, optional
        Gravity acceleration in meters per square second. Default is `9.81`.

    Returns
    -------
    float
        Rayleigh number.
    """
    return Gr(gas, D, Tw, mu=mu, g=g) * Pr(gas, mu=mu, k=k)
