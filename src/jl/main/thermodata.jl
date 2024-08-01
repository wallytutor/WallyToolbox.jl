##############################################################################
# THERMODATA
##############################################################################

import YAML

export ThermoDatabase

##############################################################################
# CONSTANT AND CONFIGURATION
##############################################################################

const DEFAULTTHERMODATA = joinpath(WALLYTOOLBOXDATA, "thermodata.yaml")

##############################################################################
# DATA STRUCTURES
##############################################################################

struct ThermoDatabase
    about::String
    compounds::Vector{ThermoCompound}
    references::Dict{String, String}

    function ThermoDatabase(;
            otherpath = nothing,
            validate = true,
            selected_compounds = "*"
        )
        datapath = isnothing(otherpath) ? DEFAULTTHERMODATA : otherpath

        !isfile(datapath) && begin
            throw(ErrorException("File not found: $(datapath)"))
        end

        data = YAML.load_file(datapath)

        if validate && !thermodata_validate(data) 
            throw(ErrorException("Unable to validate contents $(datapath)"))
        end

        compounds = thermo_get_selected_compounds(
            data["compounds"], selected_compounds)

        return new(data["about"], compounds, data["references"])
    end

end

##############################################################################
# READING AND VALIDATION
##############################################################################

function thermodata_validate(data)
    refs = thermodata_validate_hassection(data, "references")
    cmps = thermodata_validate_hassection(data, "compounds")

    valid_references = thermodata_validate_references(refs, cmps)

    return all([
        valid_references,
    ])
end

function thermodata_validate_references(refs, cmps)
    return all(c->thermodata_validate_datasource(c, refs), cmps)
end

function thermodata_validate_datasource(compound, refs)
    !haskey(compound, "datasource") && begin
        @warn("Missing data source for $(compound["displayname"])")
        return false
    end

    !haskey(refs, compound["datasource"]) && begin
        @warn("Missing reference entry for $(compound["source"])")
        return false
    end

    return true
end

function thermodata_validate_hassection(data, name)
    !haskey(data, name) && begin
        @warn("Missing $(name) section in thermodata!")
        return nothing
    end
    return data[name]
end

function thermo_get_selected_compounds(compounds, selected)
    selected == "*" && return map(thermo_get_compound, compounds)

    buffer = filter(c->c["compoundname"] in selected, compounds)

    return thermo_get_compound.(buffer)
end

function thermo_get_thermodynamics(thermo, chemical)
    thermotype = Symbol(thermo["type"])

    return if thermotype == :maier_kelley
        thermo_parse_thermomaierkelly(thermo["data"], chemical)
    elseif thermotype == :shomate
        thermo_parse_thermoshomate(thermo["data"], chemical)
    else
        throw(ErrorException("Unsupported thermotype $(thermotype)"))
    end
end

function thermo_get_compound(cmp)
    chemical = ChemicalCompound(cmp["stoichiometry"])
    thermo = thermo_get_thermodynamics(cmp["thermodynamics"], chemical)
    
    ThermoCompound(
        cmp["compoundname"],
        cmp["displayname"],
        cmp["aggregation"],
        cmp["datasource"],
        chemical,
        thermo
    )
end

function thermo_parse_thermomaierkelly(thermodata, compound)
    return MaierKelleyThermo(
        thermodata["h298"], thermodata["s298"], copy(thermodata["coefs"]);
        units = get(thermodata, "units", :mole),
        molar_mass = molecularmass(compound)
    )
end

function thermo_parse_thermoshomate(thermodata, compound)
    return ShomateThermo(
        thermodata["h298"], thermodata["s298"], copy(thermodata["coefs"]),
        (thermodata["range"]...,); units = get(thermodata, "units", :mole),
        molar_mass = molecularmass(compound)
    )
end

##############################################################################
# EOF
##############################################################################