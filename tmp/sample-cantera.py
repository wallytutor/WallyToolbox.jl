# # Minimal Cantera samples
#
# For more, please check [the docs](https://cantera.org/)
#
# ## Tools
#
# Just import Cantera using the alias `ct` as follows:

import cantera as ct

# ## Creating a solution
#
# Below we illustrate how to create a solution object; in the context of rotary kilns it might be useful to import [Gri-MECH 3.0](http://combustion.berkeley.edu/gri-mech/) as it is the standard combustion mechanism for benchmarking natural gas:

gas = ct.Solution("gri30.yaml")

# The following set the temperature (in kelvin), pressure (in pascal), and composition (mole fractions if using `X`, mass fractions with `Y`):

# +
X_nat = "CH4:0.95, CO2: 0.03, N2: 0.02"

gas.TPX = 298.15, 101325.0, X_nat
# -

# We can get a report for the state of a solution to confirm everything went fine with:

print(gas.report())

# ## Basics of combustion
#
# Now suppose you want to burn this fuel with air; so lets create the composition of the oxidizer:

X_air = "N2: 0.78, O2: 0.21, Ar: 0.01"

# With method `set_equivalence_ratio` we can set its composition for a given equivalence ratio; you can write `?gas.set_equivalence_ratio` to a new cell to see the documentation of this function.

gas.set_equivalence_ratio(1.0, fuel=X_nat, oxidizer=X_air, basis="mole")

# For instance, for computing equilibrium we can use `gas.equilibrate` as documented below:

# ?gas.equilibrate

# Computing equilibrium at constant room temperature and pressure provides the complete combustion products:

gas.equilibrate("TP")
print(gas.report())

# Once an equilibrium as been computed, the state of the solution changed; to perform anothe calculation we need to reset its state; starting at 500 K, *e.g.* we can compute adiabatic flame temperature with constant enthalpy equilibrium:

# +
gas.TP = 500.0, 101325.0
gas.set_equivalence_ratio(1.0, fuel=X_nat, oxidizer=X_air, basis="mole")

gas.equilibrate("HP")
print(gas.report(threshold=1.0e-05))
# -

# ## Computing mixtures
#
# A more flexible approach for industrial solutions is to use `ct.Quantity` that allows arbitrary mixtures to be set-up; below we mix up some natural gas and air before evaluating the equivalent adiabatic flame condition.

# +
# mech = "gri30.yaml"
mech = "data/2S_CH4_BFER.yaml"

gas = ct.Solution(mech)
air1 = ct.Solution(mech)
air2 = ct.Solution(mech)

gas.TPX = 298.15, ct.one_atm, X_nat
air1.TPX = 573.15, ct.one_atm, X_air
air2.TPX = 923.15, ct.one_atm, X_air

mdot_gas = 300.0
mdot_air1 = 2000.0
mdot_air2 = 3000.0

q_gas = ct.Quantity(gas, mass=mdot_gas)
q_air1 = ct.Quantity(air1, mass=mdot_air1)
q_air2 = ct.Quantity(air2, mass=mdot_air2)

q_mix = q_gas + q_air1 + q_air2
q_mix.equilibrate("HP")

print(q_mix.report(threshold=1.0e-05))
# -
# Another more complex example:

# +
mech = "data/NAT_PFO_LUMP.yaml"

mdot_pri = 486.6
mdot_sec = 6706.1
mdot_nat = 168.25
mdot_pfo = 199.0

T_pri = 25.0
T_sec = 950.0
T_nat = 25.0
T_pfo = 135.0

T_REF = 273.15

methods = ["CHECK", "ADIABATIC"]
method = methods[0]

X_air = "N2: 0.79, O2: 0.205, H2O: 0.005"
X_nat = "NAT: 0.9573, CO2: 0.0075, N2: 0.0352"
X_pfo = "PFO: 1.0"

fluid_pfo = ct.Solution(mech)
fluid_nat = ct.Solution(mech)
fluid_pri = ct.Solution(mech)
fluid_sec = ct.Solution(mech)

fluid_pri.TPX = T_REF + T_pri, ct.one_atm, X_air
fluid_sec.TPX = T_REF + T_sec, ct.one_atm, X_air
fluid_nat.TPX = T_REF + T_nat, ct.one_atm, X_nat
fluid_pfo.TPX = T_REF + T_pfo, ct.one_atm, X_pfo

qty_pri = ct.Quantity(fluid_pri, mass=mdot_pri)
qty_sec = ct.Quantity(fluid_sec, mass=mdot_sec)
qty_pfo = ct.Quantity(fluid_pfo, mass=mdot_pfo)
qty_nat = ct.Quantity(fluid_nat, mass=mdot_nat)

qty_fuel = qty_nat + qty_pfo
qty_air  = qty_pri + qty_sec

qty = qty_fuel + qty_air

match method:
    case "CHECK":
        qty.TP = T_REF, None
        qty.equilibrate("TP")
    case "ADIABATIC":
        qty.equilibrate("HP")
    
print(qty.report(threshold=1e-10))
print(f"Total mass flow rate = {qty.mass/3600:.3f} kg/s")
