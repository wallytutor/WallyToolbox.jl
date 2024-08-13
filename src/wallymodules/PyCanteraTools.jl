module PyCanteraTools

##############################################################################
# INITIALIZE
##############################################################################

using PythonCall
using CairoMakie
using Printf

const ct = Ref{Py}()

function __init__()
    ct[] = pyimport("cantera")
end

##############################################################################
# EXPORTS
##############################################################################

export cantera_string_to_dict
export cantera_dict_to_string

export chons_get_fractions
export chons_fuel_formula
export chons_fuel_equation

export pure_species_heating_value
export mixture_heating_value

##############################################################################
# UTILITIES
##############################################################################

function cantera_string_to_dict(X)
    function innersplit(X)
        species, amounts = split(X, ":")
        s = strip(species, ' ')
        x = strip(amounts, ' ')
        return (String(s), parse(Float64, x))
    end

    return Dict(map(innersplit, split(X, ", ")))
end

function cantera_dict_to_string(X; fmt = x->@sprintf("%.12f", x))
    species(x) = x[1] * ": " * fmt(x[2])
    return join(map(species, zip(keys(X), values(X))), ", ")
end

##############################################################################
# CHONS
##############################################################################

function chons_get_fractions(gas; basis = :mole)
    fracs = if (basis == :mole)
        gas.elemental_mole_fraction 
    else
        gas.elemental_mass_fraction
    end

    get_element(n) = (n in gas.element_names) ? fracs(n) : 0

    return map(x->pyconvert(Float64, x), [
        get_element("C"),
        get_element("H"),
        get_element("O"),
        get_element("N"),
        get_element("S")
    ])
end

function chons_fuel_formula(x, y, z, n, s)
    formula = "\\mathrm{C}_{$(@sprintf("%.6f", x))}\
               \\mathrm{H}_{$(@sprintf("%.6f", y))}\
               \\mathrm{O}_{$(@sprintf("%.6f", z))}\
               \\mathrm{N}_{$(@sprintf("%.6f", n))}\
               \\mathrm{S}_{$(@sprintf("%.6f", s))}"
    return L"%$(formula)"
end

function chons_fuel_equation(x, y, z, n, s)
    a =  (1/2)*(2x + 2s + n + y/2 - z)
    o2   = "$(@sprintf("%.6f", a))   \\:\\mathrm{O}_{2}"
	co2  = "$(@sprintf("%.6f", x))   \\:\\mathrm{CO}_2"
	h2o  = "$(@sprintf("%.6f", y/2)) \\:\\mathrm{H}_2\\mathrm{O}"
	so2  = "$(@sprintf("%.6f", s))   \\:\\mathrm{SO}_2"
	no1  = "$(@sprintf("%.6f", n))   \\:\\mathrm{NO}"
    return L"\mathrm{HFO} + %$(o2) → %$(co2) + %$(h2o) + %$(so2) + %$(no1)"
end

##############################################################################
# COMBUSTION
##############################################################################

function water_vaporization_enthalpy()
    water = ct[].Water()

    # Set liquid state with zero vapor fraction.
    water.TQ = 298.15, 0.0
    h_liq = water.h

    # Set gaseous state with unit vapor fraction.
    water.TQ = 298.15, 1.0
    h_gas = water.h

    return h_liq - h_gas
end

function complete_combustion_products(gas)
    # Get amounts of all of CHONS:
    x, y, z, n, s = chons_get_fractions(gas; basis = :mole)

    # Assume some NO can be formed.
    nox = 0.0
    
    X_products = pydict([])

    #################################################################
    # Default products
    #################################################################
    
    if ("CO2" in gas.species_names)
        X_products["CO2"] = x
    end
    
    if ("H2O" in gas.species_names)
        X_products["H2O"] = y / 2
    end

    #################################################################
    # Common in liquid fuels
    #################################################################
    
    if ("SO2" in gas.species_names)
        X_products["SO2"] = s
    end

    if ("NO" in gas.species_names)
        nox = max(0.0, z - 2x - y/2 - 2s)
        X_products["NO"] = nox
    end

    #################################################################
    # Balance
    #################################################################
    
    if ("N2" in gas.species_names)
        X_products["N2"] = (n - nox) / 2
    end

    #################################################################
    # Inert
    #################################################################

    if ("AR" in gas.species_names)
        X_products["AR"] = gas.elemental_mole_fraction("Ar")
    end

    #################################################################
    # TODO: handle others here!
    #################################################################

    return X_products
end

function pure_species_heating_value(mech, fuel, oxid)
    # Read gas and set condition.
    gas = ct[].Solution(mech)
    gas.TP = 298.15, ct[].one_atm
    gas.set_equivalence_ratio(1.0, fuel, oxid)
    
    # Retrieve enthalpy and mass fraction of fuel.
    h1 = gas.enthalpy_mass
    Y_fuel = gas[fuel].Y[0]

    # Compute complete combustion products and set state.
    X_products = complete_combustion_products(gas)
    gas.TPX = nothing, nothing, X_products

    # Retrieve enthalpy and mass fraction of water.
    h2 = gas.enthalpy_mass
    Y_h2o = gas["H2O"].Y[0]

    # Get enthalpy consumed by water vaporisation.
    HV_water = Y_h2o * water_vaporization_enthalpy()
    
    LHV = -1.0e-06 * (h2 - h1) / Y_fuel
    HHV = LHV - 1.0e-06 * HV_water / Y_fuel

    return pyconvert(Float64, LHV), pyconvert(Float64, HHV)
end

function mixture_heating_value(mech, X_fuel, oxid)
    gas = ct[].Solution(mech)
    gas.TPX = nothing, nothing, X_fuel

    Y_fuel = pyconvert(Dict{String, Float64}, gas.mass_fraction_dict())

    hhv_mix, lhv_mix = 0.0, 0.0
    
    for (fuel, Y) in Y_fuel
        lhv, hhv = pure_species_heating_value(mech, fuel, oxid)
        lhv_mix += Y * lhv
        hhv_mix += Y * hhv
    end

    return lhv_mix, hhv_mix
end

##############################################################################
# EOF
##############################################################################

end