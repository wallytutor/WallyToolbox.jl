module PyCanteraTools

##############################################################################
# INITIALIZE
##############################################################################

using PythonCall
using CairoMakie
using Printf
using Unitful

import DataFrames: DataFrame
import WallyToolbox: EmpiricalFuel
import WallyToolbox: T_REF, P_REF
import WallyToolbox

const ct = Ref{Py}()

function __init__()
    ct[] = pyimport("cantera")

    # WallyToolbox mechanisms are found here:
	path = joinpath(WallyToolbox.WALLYTOOLBOXDATA, "kinetics")

    # Add all sub-directories to Cantera import path:
	for entry in readdir(path)
		dpath = joinpath(path, entry)
		isdir(dpath) && ct[].add_directory(dpath)
	end
end

##############################################################################
# EXPORTS
##############################################################################

export cantera_string_to_dict
export cantera_dict_to_string
export cantera_elemental_composition
export load_solution_state
export report_state
export net_relative_progress

export chons_get_fractions
export chons_fuel_formula
export chons_fuel_equation

export pure_species_heating_value
export mixture_heating_value

# XXX: find a home for us in WallyToolbox, pls!
jlbool(x)  = pyconvert(Bool, x)
jlint(x)   = pyconvert(Int64, x)
jlfloat(x) = pyconvert(Float64, x)
jlstr(x)   = pyconvert(String, x)
jlvec(x; T=Float64) = pyconvert(Vector{T}, x)

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

function cantera_elemental_composition(f::EmpiricalFuel)
    return replace(String(f)[1:end-1], "("=>": ", ")"=>", ")
end

function load_solution_state(
        mech::String,
        comp::Union{String, Dict{String, Float64}};
        T::Float64 = T_REF,
        P::Float64 = P_REF,
        basis::Symbol = :mole
    )
    sol = ct[].Solution(mech)

    # Cantera does not support Julia dictionaries as it supports strings.
    C = (comp isa Dict) ? pydict(comp) : comp

    if basis == :mole
        sol.TPX = T, P, C
    elseif basis == :mass
        sol.TPY = T, P, C
    else
        error("Unknown composition basis $(basis)")
    end

    return sol
end

function report_state(sol; kw...)
	return pyconvert(String, sol.report(; kw...))
end

function net_relative_progress(sol)
	rf = sol.forward_rates_of_progress
	rr = sol.reverse_rates_of_progress

	n_reactions = jlint(sol.n_reactions)
	res = zeros(n_reactions)

	# XXX: it must be 0-based here for Python compat!
	for i in 0:n_reactions-1
		reversible = jlbool(sol.reaction(i).reversible)
		
		if reversible && (jlfloat(rf[i]) != 0.0)
            # XXX: but `res` has Julia indexing...
			res[i+1] = abs(jlfloat((rf[i] - rr[i]) / rf[i]))
		end
	end

	return res
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

function chons_fuel_equation(x, y, z, n, s; burn_nitrogen = false)
    a = 2x + 2s + y/2 - z
    a = (burn_nitrogen ? a + n : a) / 2

    o2   = "$(@sprintf("%.6f", a))   \\:\\mathrm{O}_{2}"
    co2  = "$(@sprintf("%.6f", x))   \\:\\mathrm{CO}_2"
    h2o  = "$(@sprintf("%.6f", y/2)) \\:\\mathrm{H}_2\\mathrm{O}"
    so2  = "$(@sprintf("%.6f", s))   \\:\\mathrm{SO}_2"

    nit = if burn_nitrogen
        "$(@sprintf("%.6f", n))   \\:\\mathrm{NO}"
    else
        "$(@sprintf("%.6f", n/2)) \\:\\mathrm{N}_2"
    end

    return L"\mathrm{HFO} + %$(o2) → %$(co2) + %$(h2o) + %$(so2) + %$(nit)"
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


hv_units(add_units) = (add_units ? u"MJ/kg" : 1.0)


function pure_species_heating_value(mech, fuel, oxid; add_units = false)
    # Read gas and set condition.
    gas = ct[].Solution(mech)
    gas.TP = 298.15, ct[].one_atm
    gas.set_equivalence_ratio(1.0, fuel, oxid, basis="mole")
    
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

    LHV = pyconvert(Float64, LHV) * hv_units(add_units)
    HHV = pyconvert(Float64, HHV) * hv_units(add_units)

    return LHV, HHV
end

function mixture_heating_value(mech, X_fuel, oxid;
        verbose = false,
        add_units = false
    )
    gas = ct[].Solution(mech)
    gas.TPX = nothing, nothing, X_fuel

    Y_fuel = pyconvert(Dict{String, Float64}, gas.mass_fraction_dict())

    hhv_mix = 0.0 * hv_units(add_units)
    lhv_mix = 0.0 * hv_units(add_units)
    
    table = []

    for (fuel, Y) in Y_fuel
        lhv, hhv = pure_species_heating_value(mech, fuel, oxid; add_units)
        
        if verbose
            push!(table, [fuel, 100Y, lhv, hhv])
        end

        lhv_mix += Y * lhv
        hhv_mix += Y * hhv
    end

    if verbose
        table = mapreduce(permutedims, vcat, table)
        @info(DataFrame(table, ["compound", "Weight %", "LHV", "HHV"]))
    end

    return lhv_mix, hhv_mix
end

##############################################################################
# EOF
##############################################################################

end