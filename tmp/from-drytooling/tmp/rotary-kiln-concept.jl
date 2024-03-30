# -*- coding: utf-8 -*-
import CairoMakie as cm
import DryTooling as dry
using YAML

##############################################################################
# Barr - Case T4
##############################################################################

data = YAML.load_file("rotary-kiln-concept.yaml")

entry = data["material_shell"]["transport"]
transshell = dry.MaterialTransportProperties(entry)

entry = data["material_refractory"]["transport"]
transrefractory = dry.MaterialTransportProperties(entry)

entry = data["material_powder_bed"]
silica = dry.MaterialPowderBed(entry)

L   = 5.500              # Kiln length [m]
D   = 0.417              # Kiln diameter [m]
β   = deg2rad(0.800)     # Kiln slope [rad]
δR₁ = 0.093              # Refractory thickness [m]
δR₂ = 0.060              # Shell thickness [m]
d   = 33.5               # Dam height [mm]
Φ   = 60.0 / silica.ρ    # Feed rate [m³/h]
ω   = 1.5                # Rotation rate [rev/min]

kramers = dry.SymbolicLinearKramersModel()

bed = dry.solvelinearkramersmodel(;
    model = kramers,
    L     = L,
    R     = D / 2.0,
    Φ     = Φ / 3600.0,
    ω     = ω / 60.0,
    β     = β,
    γ     = silica.γ,
    d     = d / 1000.0
)

dry.plotlinearkramersmodel(bed; backend = :plots)
dry.plotlinearkramersmodel(bed; backend = :makie, normz = true)

# "gas_flow_rate": 0.072651,
# "gas_leak_rate": 0.00,
# "bed_feed_temperature": 300.0,
# "gas_feed_temperature": 1089.534527,
# "bed_feed_humidity": 0.0,
# "gas_feed_composition": [
#     3.28647679e-41,
#     1.38982682e-01,
#     3.15856983e-02,
#     6.89472273e-02,
#     9.62638471e-03,
#     7.50858007e-01
# ]
