# -*- coding: utf-8 -*-

"Ideal gas constant [$(GAS_CONSTANT) [J/(mol.K)]."
const GAS_CONSTANT::Float64 = 8.314_462_618_153_24
export GAS_CONSTANT

"Stefan-Boltzmann constant [$(STEFAN_BOLTZMANN) W/(m².K⁴)]."
const STEFAN_BOLTZMANN::Float64 = 5.670_374_419e-08
export STEFAN_BOLTZMANN

"Zero degrees Celsius in Kelvin [$(ZERO_CELSIUS) K]."
const ZERO_CELSIUS::Float64 = 273.15
export ZERO_CELSIUS

"Atmospheric pressure at sea level [$(ONE_ATM) Pa]."
const ONE_ATM::Float64 = 101325.0
export ONE_ATM

"Reference atmospheric pressure [$(P_REF) Pa]."
const P_REF::Float64 = ONE_ATM
export P_REF

"Normal atmospheric temperature [$(T_REF) K]."
const T_REF::Float64 = ZERO_CELSIUS
export T_REF

"Normal state concentration [$(C_REF) mol/m³]. "
const C_REF::Float64 = P_REF / (GAS_CONSTANT * T_REF)
export C_REF

"Conversion factor from calories to joules [$(JOULE_PER_CALORIE) J/cal]."
const JOULE_PER_CALORIE::Float64 = 4.184
export JOULE_PER_CALORIE

"Air mean molecular mass [$(M_AIR) kg/mol]."
const M_AIR::Float64 = 0.0289647
export M_AIR

""" Periodic table of stable chemical elements. """
const ELEMENTS = (
    H  = ("H",  "hydrogen",        1.008),
    He = ("He", "helium",          4.002602),
    Li = ("Li", "lithium",         6.94),
    Be = ("Be", "beryllium",       9.0121831),
    B  = ("B",  "boron",          10.81),
    C  = ("C",  "carbon",         12.011),
    N  = ("N",  "nitrogen",       14.007),
    O  = ("O",  "oxygen",         15.999),
    F  = ("F",  "fluorine",       18.998403163),
    Ne = ("Ne", "neon",           20.1797),
    Na = ("Na", "sodium",         22.98976928),
    Mg = ("Mg", "magnesium",      24.305),
    Al = ("Al", "aluminum",       26.9815384),
    Si = ("Si", "silicon",        28.085),
    P  = ("P",  "phosphorus",     30.973761998),
    S  = ("S",  "sulfur",         32.06),
    Cl = ("Cl", "chlorine",       35.45),
    Ar = ("Ar", "argon",          39.95),
    K  = ("K",  "potassium",      39.0983),
    Ca = ("Ca", "calcium",        40.078),
    Sc = ("Sc", "scandium",       44.955908),
    Ti = ("Ti", "titanium",       47.867),
    V  = ("V",  "vanadium",       50.9415),
    Cr = ("Cr", "chromium",       51.9961),
    Mn = ("Mn", "manganese",      54.938043),
    Fe = ("Fe", "iron",           55.845),
    Co = ("Co", "cobalt",         58.933194),
    Ni = ("Ni", "nickel",         58.6934),
    Cu = ("Cu", "copper",         63.546),
    Zn = ("Zn", "zinc",           65.38),
    Ga = ("Ga", "gallium",        69.723),
    Ge = ("Ge", "germanium",      72.630),
    As = ("As", "arsenic",        74.921595),
    Se = ("Se", "selenium",       78.971),
    Br = ("Br", "bromine",        79.904),
    Kr = ("Kr", "krypton",        83.798),
    Rb = ("Rb", "rubidium",       85.4678),
    Sr = ("Sr", "strontium",      87.62),
    Y  = ("Y",  "yttrium",        88.90584),
    Zr = ("Zr", "zirconium",      91.224),
    Nb = ("Nb", "nobelium",       92.90637),
    Mo = ("Mo", "molybdenum",     95.95),
    Ru = ("Ru", "ruthenium",     101.07),
    Rh = ("Rh", "rhodium",       102.90549),
    Pd = ("Pd", "palladium",     106.42),
    Ag = ("Ag", "silver",        107.8682),
    Cd = ("Cd", "cadmium",       112.414),
    In = ("In", "indium",        114.818),
    Sn = ("Sn", "tin",           118.710),
    Sb = ("Sb", "antimony",      121.760),
    Te = ("Te", "tellurium",     127.60 ),
    I  = ("I",  "iodine",        126.90447),
    Xe = ("Xe", "xenon",         131.293),
    Cs = ("Cs", "cesium",        132.90545196),
    Ba = ("Ba", "barium",        137.327),
    La = ("La", "lanthanum",     138.90547),
    Ce = ("Ce", "cerium",        140.116),
    Pr = ("Pr", "praseodymium",  140.90766),
    Nd = ("Nd", "neodymium",     144.242),
    Sm = ("Sm", "samarium",      150.36),
    Eu = ("Eu", "europium",      151.964),
    Gd = ("Gd", "gadolinium",    157.25),
    Tb = ("Tb", "terbium",       158.925354),
    Dy = ("Dy", "dysprosium",    162.500),
    Ho = ("Ho", "holmium",       164.930328),
    Er = ("Er", "erbium",        167.259),
    Tm = ("Tm", "thulium",       168.934218),
    Yb = ("Yb", "ytterbium",     173.045),
    Lu = ("Lu", "lutetium",      174.9668),
    Hf = ("Hf", "hafnium",       178.49),
    Ta = ("Ta", "tantalum",      180.94788),
    W  = ("W",  "tungsten",      183.84),
    Re = ("Re", "rhenium",       186.207),
    Os = ("Os", "osmium",        190.23 ),
    Ir = ("Ir", "iridium",       192.217),
    Pt = ("Pt", "platinum",      195.084),
    Au = ("Au", "gold",          196.966570),
    Hg = ("Hg", "mercury",       200.592),
    Tl = ("Tl", "thallium",      204.38),
    Pb = ("Pb", "lead",          207.2 ),
    Bi = ("Bi", "bismuth",       208.98040),
    Th = ("Th", "thorium",       232.0377),
    Pa = ("Pa", "protactinium",  231.03588),
    U  = ("U",  "uranium",       238.02891),
)
export ELEMENTS
