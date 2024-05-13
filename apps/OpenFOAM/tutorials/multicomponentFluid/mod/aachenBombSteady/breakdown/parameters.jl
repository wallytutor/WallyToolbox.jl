# -*- coding: utf-8 -*-
""" Setup for total combustion of C7H16 as C7H16 + 11O2 = 7CO2 + 8H2O. """

##############################################################################
# USER DEFINED
##############################################################################

mdot_fuel = 0.01
P_air = 101325.0
T_air = 800.0

I = 0.05

##############################################################################
# CONSTANTS
##############################################################################

# Molecular masses of elements
const mH = 0.001
const mC = 0.012
const mO = 0.016

# Atomic composition of fuel C7H16
const nC = 7
const nH = 16

# Mass fraction of O2 in air
const YO2_air = 0.234

##############################################################################
# TURBULENCE
##############################################################################

# https://www.openfoam.com/documentation/guides/latest/doc/
# guide-turbulence-ras-k-epsilon.html

function prepare_kε(u_ref; L = 0.2, I = 0.05, Cμ = 0.09)
    k = (3/2) * (I * u_ref)^2
    ε = Cμ^(3/4) * k^(1/2) / L
    ν = Cμ * k^2 / ε
    return k, ε, ν
end

##############################################################################
# BALANCES
##############################################################################

# Molecular mass of fuel C7H16
mfuel = nC * mC + nH * mH
moxid = 2mO

# Mass of O2 per mole of C7H16
m_oxid_per_mole_fuel = 11moxid

# Mass of air per mole of C7H16 
m_air_per_mole_fuel = m_oxid_per_mole_fuel / YO2_air

# Mass flow rate [kg/s]
mdot_air = (mdot_fuel / mfuel) * m_air_per_mole_fuel

# Air reference density [kg/m³]
rho_air = (P_air * 0.02896) / (8.31446261815324 * T_air)

# Mean air inlet velocity [m/s]
U_air = mdot_air / (rho_air * 0.2^2)

# Turbulence initial conditions.
k, ε, ν = prepare_kε(U_air; I)

##############################################################################
# DUMP RESULTS
##############################################################################

open("parameters", "w") do fp
    write(fp, """\
    YN2_air       $(1.0 - YO2_air);\n
    YO2_air       $(YO2_air);\n
    mdot_fuel     $(mdot_fuel);\n
    mdot_air      $(mdot_air);\n
    rho_air       $(rho_air);\n
    U_jet         $(3U_air);\n
    U_air         $(U_air);\n
    T_air         $(T_air);\n
    P_air         $(P_air);\n
    I             $(I);\n
    k             $(k);\n
    epsilon       $(ε);\n
    nut           $(ν);
    """)
end