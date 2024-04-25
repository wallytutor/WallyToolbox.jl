# -*- coding: utf-8 -*-
module DryConstants

using DryElements: StableElementsTable

"Ideal gas constant [J/(mol.K)]."
const GAS_CONSTANT::Float64 = 8.314_462_618_153_24
export GAS_CONSTANT

"Stefan-Boltzmann constant [W/(m².K⁴)]."
const STEFAN_BOLTZMANN::Float64 = 5.670_374_419e-08
export STEFAN_BOLTZMANN

"Zero degrees Celsius in Kelvin [$(ZERO_CELSIUS) ``K``]."
const ZERO_CELSIUS::Float64 = 273.15
export ZERO_CELSIUS

"Atmospheric pressure at sea level [$(ONE_ATM) ``Pa``]."
const ONE_ATM::Float64 = 101325.0
export ONE_ATM

"Reference atmospheric pressure [Pa]."
const P_REF::Float64 = ONE_ATM
export P_REF

"Normal atmospheric temperature [K]."
const T_REF::Float64 = ZERO_CELSIUS
export T_REF

"Normal state concentration [mol/m³]. "
const C_REF::Float64 = P_REF / (GAS_CONSTANT * T_REF)
export C_REF

"Air mean molecular mass [kg/mol]."
const M_AIR::Float64 = 0.0289647
export M_AIR

"Instantiation of stable elements table."
const STABLE_ELEMENTS_TABLE = StableElementsTable()
export STABLE_ELEMENTS_TABLE

end # (module DryConstants)
