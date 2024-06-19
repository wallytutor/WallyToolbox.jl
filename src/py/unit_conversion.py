# -*- coding: utf-8 -*-
from typing import Optional
import numpy as np

try:
    import cantera as ct
except ModuleNotFoundError as err:
    print(f"FlowUnits will not be available: {err}")


class FlowUnits:
    """ Management of gas flow rate units for different applications.

    Conversion is performed assuming ideal gas law. Concentration at normal
    condition is multiplied by gas molar weight and this value is used as
    base conversion factor.

    Attributes
    ----------
    T_NORMAL : float
        Reference temperature for normal conditions, default is 288.15 K.
    T_STANDARD: float = 273.15
        Reference temperature for standard conditions, default is 273.15 K.
    P_STANDARD: float = ct.one_atm
        Reference pressure for standard conditions, default is 101325 Pa.
    """
    T_NORMAL: float = 273.15
    P_NORMAL: float = 100_000.0
    T_STANDARD: float = 273.15
    P_STANDARD: float = 101325.0

    @classmethod
    def normal_concentration(cls) -> float:
        """ Ideal gas concentration at normal conditions [kmol/m³]. """
        return cls.P_NORMAL / (ct.gas_constant * cls.T_NORMAL)

    @classmethod
    def normal_flow_to_mass_flow(
            cls,
            q: float,
            mw: float
        ) -> float:
        """ Convert flow given in Nm³/h to kg/s for a solution.

        Parameters
        ----------
        q: float
            Flow rate to be converted in Nm³/h.
        mw: float
            Solution mean molecular weight in kg/kmol.

        Returns
        -------
        float
            Flow rate converted to kg/s.
        """
        return cls.normal_concentration() * mw * q / 3600

    @classmethod
    def standard_flow_to_gas_speed(
            cls,
            q: float,
            T_work: Optional[float] = 298.15,
            P_work: Optional[float] = 101325.0,
            A_cross: Optional[float] = 1.0
        ) -> float:
        """ Convert laboratory gas flow in Scm³/min to mean speed in m/s.

        Parameters
        ----------
        q: float
            Flow rate to be converted in Scm³/min (sccm).
        T_work: Optional[float] = 298.15
            Reactor working temperature in kelvin [K].
        P_work: Optional[float] = ct.one_atm
            Reactor working pressure in pascal [Pa]
        A_cross: Optional[float] = 1.0
            Reactor cross sectional area in squared meters [m²].

        Returns
        -------
        float
            Equivalent gas speed in meters per second [m/s].
        """
        min_per_sec = 1 / 60
        m3_per_cm3 = 1 / 10**6

        scaler = cls.P_STANDARD / cls.T_STANDARD
        Q = q * min_per_sec * m3_per_cm3 * (T_work / P_work)
        u = scaler * Q / A_cross

        return u


class TimeUnits:
    """ Unit conversions for time. """
    @staticmethod
    @np.vectorize
    def hour_to_second(h):
        """ Convert hours to seconds. """
        return 3600.0 * h


class TemperatureUnits:
    """ Unit conversions for temperature. """
    FARENHEIT_PER_KELVIN = 5 / 9

    @classmethod
    @np.vectorize
    def farenheit_to_kelvin(cls, F):
        """ Convert temperature in Farenheit to Kelvin. """
        return cls.FARENHEIT_PER_KELVIN * (F - 32) + 273.15


class MassUnits:
    """ Unit conversions for mass. """
    @staticmethod
    @np.vectorize
    def pound_to_kilogram(lbs):
        """ Convert mass in pound to kilogram. """
        return 0.453592 * lbs


class LengthUnits:
    """ Unit conversions for length. """
    @staticmethod
    @np.vectorize
    def inch_to_meter(inch):
        """ Convert length in inches to meters. """
        return 0.0254 * inch

    @staticmethod
    @np.vectorize
    def foot_to_inch(ft):
        """ Convert length in feet to inches. """
        return 12.0 * ft

    @classmethod
    @np.vectorize
    def foot_to_meter(cls, ft):
        """ Convert length in feet to meters. """
        return cls.inch_to_meter(cls.foot_to_inch(ft))


class EnergyUnits:
    """ Unit conversions for energy. """
    @staticmethod
    @np.vectorize
    def btu_to_joule(btu):
        """ Convert energy in BTU to joule. """
        return 1055.06 * btu


class ThermalPropertiesUnits:
    """ Unit conversions for thermal properties. """
    bu_to_si_thermal_conducitivity_f = None
    bu_to_si_specific_heat_f = None

    @classmethod
    @np.vectorize
    def bu_to_si_thermal_conducitivity(cls, k):
        """ Convert thermal conductivity from British to SI units. """
        if cls.bu_to_si_thermal_conducitivity_f is None:
            in1 = LengthUnits.inch_to_meter(1)
            ft2 = LengthUnits.foot_to_meter(1)**2
            hr1 = TimeUnits.hour_to_second(1)
            factor = EnergyUnits.btu_to_joule(1) * in1
            factor /= (hr1 * ft2 * TemperatureUnits.FARENHEIT_PER_KELVIN)
            cls.bu_to_si_thermal_conducitivity_f = factor
        return cls.bu_to_si_thermal_conducitivity_f * k

    @classmethod
    @np.vectorize
    def bu_to_si_specific_heat(cls, cp):
        """ Convert specific heat from British to SI units. """
        if cls.bu_to_si_specific_heat_f is None:
            factor = EnergyUnits.btu_to_joule(1)
            factor /= (MassUnits.pound_to_kilogram(1) *
                       TemperatureUnits.FARENHEIT_PER_KELVIN)
            cls.bu_to_si_specific_heat_f = factor
        return cls.bu_to_si_specific_heat_f * cp


def normal_flow_to_mass_flow(q: float, sol: "ct.Solution"):
    """ Wrapper around Cantera Solution object for `FlowUnits`. """
    return FlowUnits.normal_flow_to_mass_flow(q, sol.mean_molecular_weight)
