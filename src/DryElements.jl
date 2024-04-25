# -*- coding: utf-8 -*-
module DryElements

using DocStringExtensions: FIELDS

export element, atomicmass

""" Represents a chemical element.

Attributes
----------
$(FIELDS)

Note
----
`atomicmass` is provided in g/mol in constructor.
"""
struct ElementData
    "Atomic symbol."
    symbol::String

    "Element name."
    name::String

    "Atomic mass [kg/mol]."
    atomicmass::Float64

    "Reference state enthalpy [J/kg]."
    standardenthalpy::Float64

    "Reference state entropy [J/K]."
    standardentropy::Float64

    function ElementData(symbol::String, name::String, atomicmass::Float64;
                         h0::Float64 = 0.0, s0::Float64 = 0.0)
        return new(symbol, name, 0.001atomicmass, h0, s0)
    end
end

"Table-like structure with data for all supported elements."
Base.@kwdef struct StableElementsTable
    """ Periodic table of stable chemical elements. """
    H  = ElementData("H",  "hydrogen",        1.008)
    He = ElementData("He", "helium",          4.002602)
    Li = ElementData("Li", "lithium",         6.94)
    Be = ElementData("Be", "beryllium",       9.0121831)
    B  = ElementData("B",  "boron",          10.81)
    C  = ElementData("C",  "carbon",         12.011)
    N  = ElementData("N",  "nitrogen",       14.007)
    O  = ElementData("O",  "oxygen",         15.999)
    F  = ElementData("F",  "fluorine",       18.998403163)
    Ne = ElementData("Ne", "neon",           20.1797)
    Na = ElementData("Na", "sodium",         22.98976928)
    Mg = ElementData("Mg", "magnesium",      24.305)
    Al = ElementData("Al", "aluminum",       26.9815384)
    Si = ElementData("Si", "silicon",        28.085)
    P  = ElementData("P",  "phosphorus",     30.973761998)
    S  = ElementData("S",  "sulfur",         32.06)
    Cl = ElementData("Cl", "chlorine",       35.45)
    Ar = ElementData("Ar", "argon",          39.95)
    K  = ElementData("K",  "potassium",      39.0983)
    Ca = ElementData("Ca", "calcium",        40.078)
    Sc = ElementData("Sc", "scandium",       44.955908)
    Ti = ElementData("Ti", "titanium",       47.867)
    V  = ElementData("V",  "vanadium",       50.9415)
    Cr = ElementData("Cr", "chromium",       51.9961)
    Mn = ElementData("Mn", "manganese",      54.938043)
    Fe = ElementData("Fe", "iron",           55.845)
    Co = ElementData("Co", "cobalt",         58.933194)
    Ni = ElementData("Ni", "nickel",         58.6934)
    Cu = ElementData("Cu", "copper",         63.546)
    Zn = ElementData("Zn", "zinc",           65.38)
    Ga = ElementData("Ga", "gallium",        69.723)
    Ge = ElementData("Ge", "germanium",      72.630)
    As = ElementData("As", "arsenic",        74.921595)
    Se = ElementData("Se", "selenium",       78.971)
    Br = ElementData("Br", "bromine",        79.904)
    Kr = ElementData("Kr", "krypton",        83.798)
    Rb = ElementData("Rb", "rubidium",       85.4678)
    Sr = ElementData("Sr", "strontium",      87.62)
    Y  = ElementData("Y",  "yttrium",        88.90584)
    Zr = ElementData("Zr", "zirconium",      91.224)
    Nb = ElementData("Nb", "nobelium",       92.90637)
    Mo = ElementData("Mo", "molybdenum",     95.95)
    Ru = ElementData("Ru", "ruthenium",     101.07)
    Rh = ElementData("Rh", "rhodium",       102.90549)
    Pd = ElementData("Pd", "palladium",     106.42)
    Ag = ElementData("Ag", "silver",        107.8682)
    Cd = ElementData("Cd", "cadmium",       112.414)
    In = ElementData("In", "indium",        114.818)
    Sn = ElementData("Sn", "tin",           118.710)
    Sb = ElementData("Sb", "antimony",      121.760)
    Te = ElementData("Te", "tellurium",     127.60 )
    I  = ElementData("I",  "iodine",        126.90447)
    Xe = ElementData("Xe", "xenon",         131.293)
    Cs = ElementData("Cs", "cesium",        132.90545196)
    Ba = ElementData("Ba", "barium",        137.327)
    La = ElementData("La", "lanthanum",     138.90547)
    Ce = ElementData("Ce", "cerium",        140.116)
    Pr = ElementData("Pr", "praseodymium",  140.90766)
    Nd = ElementData("Nd", "neodymium",     144.242)
    Sm = ElementData("Sm", "samarium",      150.36)
    Eu = ElementData("Eu", "europium",      151.964)
    Gd = ElementData("Gd", "gadolinium",    157.25)
    Tb = ElementData("Tb", "terbium",       158.925354)
    Dy = ElementData("Dy", "dysprosium",    162.500)
    Ho = ElementData("Ho", "holmium",       164.930328)
    Er = ElementData("Er", "erbium",        167.259)
    Tm = ElementData("Tm", "thulium",       168.934218)
    Yb = ElementData("Yb", "ytterbium",     173.045)
    Lu = ElementData("Lu", "lutetium",      174.9668)
    Hf = ElementData("Hf", "hafnium",       178.49)
    Ta = ElementData("Ta", "tantalum",      180.94788)
    W  = ElementData("W",  "tungsten",      183.84)
    Re = ElementData("Re", "rhenium",       186.207)
    Os = ElementData("Os", "osmium",        190.23 )
    Ir = ElementData("Ir", "iridium",       192.217)
    Pt = ElementData("Pt", "platinum",      195.084)
    Au = ElementData("Au", "gold",          196.966570)
    Hg = ElementData("Hg", "mercury",       200.592)
    Tl = ElementData("Tl", "thallium",      204.38)
    Pb = ElementData("Pb", "lead",          207.2 )
    Bi = ElementData("Bi", "bismuth",       208.98040)
    Th = ElementData("Th", "thorium",       232.0377)
    Pa = ElementData("Pa", "protactinium",  231.03588)
    U  = ElementData("U",  "uranium",       238.02891)
end

#############################################################################
# Other functionalities
#############################################################################

""" Retrieve an element by name. """
element(s::String) = getfield(STABLE_ELEMENTS_TABLE, Symbol(s))

#############################################################################
# atomicmass()
#############################################################################

atomicmass(s::String) = mass(element(s))

atomicmass(e::ElementData) = e.atomicmass

@doc """ Atomic mass of element [kg/mol]. """ atomicmass

end # (DryElements)
