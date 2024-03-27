# -*- coding: utf-8 -*-
module DryConstants

"Ideal gas constant [J/(mol.K)]."
const GAS_CONSTANT::Float64 = 8.314_462_618_153_24
export GAS_CONSTANT

"Stefan-Boltzmann constant [W/(m².K⁴)]."
const STEFAN_BOLTZMANN::Float64 = 5.670_374_419e-08
export STEFAN_BOLTZMANN

"Reference atmospheric pressure [Pa]."
const P_REF::Float64 = 101325.0
export P_REF

"Normal atmospheric temperature [K]."
const T_REF::Float64 = 273.15
export T_REF

"Normal state concentration [mol/m³]. "
const C_REF::Float64 = P_REF / (GAS_CONSTANT * T_REF)
export C_REF

"Air mean molecular mass [kg/mol]."
const M_AIR::Float64 = 0.0289647
export M_AIR

end # (module DryConstants)
