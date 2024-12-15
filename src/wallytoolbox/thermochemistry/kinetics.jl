##############################################################################
# KINETICS
##############################################################################

module TemplateKinetics

const ERROR = "Template kinetics is a sample for developers only!"

struct Model
    Model() = @error(ERROR)
    progress_rate(T, p, C) = @error(ERROR)
end

end # (module TemplateKinetics)

module Graf2007

import ..WallyToolbox: GAS_CONSTANT
import ..WallyToolbox: AbstractGasKinetics
import ..WallyToolbox: ChemicalCompound
import ..WallyToolbox: molecularmass

using DynamicQuantities
using ModelingToolkit

# XXX: there are units wrong (k3) in Graf's thesis!
@constants(begin
	R  = GAS_CONSTANT,  [unit = u"J/(mol*K)"]
    k1 = 4.4e+03,       [unit = u"1/s*(mol/m^3)^(-0.36)"]
    k2 = 3.8e+07,       [unit = u"1/s*(mol/m^3)^(+0.50)"]
    k3 = 1.4e+05,       [unit = u"1/s*(mol/m^3)^(+0.43)"]
    k4 = 8.6e+06,       [unit = u"1/s*(mol/m^3)^(+0.79)"]
    k5 = 5.5e+06,       [unit = u"1/s*(mol/m^3)^(-0.90)"]
    k6 = 1.2e+05,       [unit = u"1/s*(mol/m^3)^(-0.60)"]
    k7 = 1.0e+15,       [unit = u"1/s*(mol/m^3)^(+0.25)"]
    k8 = 1.8e+03,       [unit = u"1/s*(mol/m^3)^(-0.90)"]
    k9 = 1.0e+03,       [unit = u"1/s*(mol/m^3)^(+0.25)"]
    E1 = 1.0300e+05,    [unit = u"J/mol"]
    E2 = 2.0000e+05,    [unit = u"J/mol"]
    E3 = 1.5000e+05,    [unit = u"J/mol"]
    E4 = 1.9500e+05,    [unit = u"J/mol"]
    E5 = 1.6500e+05,    [unit = u"J/mol"]
    E6 = 1.2070e+05,    [unit = u"J/mol"]
    E7 = 3.3520e+05,    [unit = u"J/mol"]
    E8 = 6.4500e+04,    [unit = u"J/mol"]
    E9 = 7.5000e+04,    [unit = u"J/mol"]
    UNIT_CONC = 1.0,    [unit = u"mol/m^3"]
end)

"Matrix of stoichiometric coefficients"
const NU = [
    -1  1 -1  1 -1 -2  2 -1  0
    -1  1 -3  3  1  0  0  0  3
     1 -1  0  0  0  0  0  0  0
     0  0  2 -2  0  0  0  0  0
     0  0  0  0  0  1 -1 -1  0
     0  0  0  0  0  0  0  1 -1
     0  0  0  0  2  0  0  0  6
     0  0  0  0  0  0  0  0  0
]

"Name of species represented in mechanism"
const NAMES = [
    "C2H2",
    "H2",
    "C2H4",
    "CH4",
    "C4H4",
    "C6H6",
    "Cs",
    "N2"
]

"Species compounds represented in mechanism"
const COMPOUNDS = [
    ChemicalCompound(C=2, H=2),
    ChemicalCompound(H=2),
    ChemicalCompound(C=2, H=4),
    ChemicalCompound(C=1, H=4),
    ChemicalCompound(C=4, H=4),
    ChemicalCompound(C=6, H=6),
    ChemicalCompound(C=1),
    ChemicalCompound(N=2)
]

struct Model <: AbstractGasKinetics
    # TODO: replace by an actual species type
    # with built-in properties (thermo, transport...)
    "Array of chemical compounds of species"
    compounds::Vector{ChemicalCompound}

    "Array of species names"
    names::Vector{String}

    "Array of species molecular masses"
    molecular_masses::Vector{Float64}

    function Model()
        W = map(molecularmass, COMPOUNDS)
        return new(COMPOUNDS, NAMES, W)
    end
end

function progress_rate(T, p, C)
    # Rate constants.
    k = [
        k1 * exp(-E1 / (R * T))
        k2 * exp(-E2 / (R * T))
        k3 * exp(-E3 / (R * T))
        k4 * exp(-E4 / (R * T))
        k5 * exp(-E5 / (R * T))
        k6 * exp(-E6 / (R * T))
        k7 * exp(-E7 / (R * T))
        k8 * exp(-E8 / (R * T))
        k9 * exp(-E9 / (R * T))
    ]

    # Reaction rates in molar units.
    r = k .* [
        C[1] * C[2]^0.36
        C[3]^0.50
        C[1]^0.35 * C[2]^0.22
        C[4]^0.21
        C[1]^1.90 / (1.0 + 18.0C[2]/UNIT_CONC)
        C[1]^1.60
        C[5]^0.75
        C[1]^1.30 * C[5]^0.60
        C[6]^0.75 / (1.0 + 22.0C[2]/UNIT_CONC)
    ]

    # Species production rates in molar units.
    return NU * r
end

end # (module Graf2007)

##############################################################################
# EOF
##############################################################################