# -*- coding: utf-8 -*-
module DryCombustion

export hfo_specific_heat
export hfo_enthalpy_net_bs2869

"""
    hfo_specific_heat(T::Float64, S::Float64)::Float64

Heavy fuel-oil specific heat estimation in terms of relative density
``S`` as provided by Cragoe (1929). Temperature in kelvin.
"""
function hfo_specific_heat(T::Float64, S::Float64)::Float64
    return 1000.0 * (1.683 + 0.00339T) / S
end

"""
    hfo_enthalpy_net_bs2869(;
        ρ::Float64,
        x::Float64,
        y::Float64,
        s::Float64
    )::Float64

Heavy fuel-oil net energy capacity accordinto to BS2869:1983. Value
is computed in [MJ/kg]. Parameters are given as:

- `ρ`: HFO density at 15 °C, [kg/m³].
- `water`: Mass percentage of water, [%].
- `ash`: Mass percentage of ashes, [%].
- `sulphur`: Mass percentage of sulphur, [%].
"""
function hfo_enthalpy_net_bs2869(;
        ρ::Float64,
        water::Float64,
        ash::Float64,
        sulphur::Float64
    )::Float64
    # In the reference ρ is given as kg/L.
    ρ = ρ / 1000.0

    # These are mass fractions.
    x = 0.01water
    y = 0.01ash
    s = 0.01sulphur

    # Base enthalpy estimation from empirical data.
    H = 46.423 - ρ * (8.792ρ - 3.170)

    # Correction factor and additional components.
    ϕ = 1.0 - x - y - s
    c = 9.420s - 2.449x

    return H * ϕ + c
end

end # (DryCombustion)
