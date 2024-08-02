// The MIT License (MIT)
// Copyright (c) 2022 Walter Dal'Maz Silva
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

use crate::thermo_model_gas::enums::*;
use crate::thermo_model_gas::species::*;
use crate::thermo_model_gas::transport::*;
use crate::thermo_model_gas::models::*;
use crate::thermo_data_gas::element::*;

pub static SPEC_H2: Species = Species {
    name: "H2",
    composition: &[
        (&ELEM_HH, 2)
    ],
    thermo: ThermoModel {
        model: ThermoModelKind::NASA7,
        temperature_ranges: &[200.0, 1000.0, 3500.0],
        data: &[
            &[ 2.34433112e+00,  7.98052075e-03, -1.94781510e-05,
               2.01572094e-08, -7.37611761e-12, -917.935173,
               0.683010238],
            &[ 3.33727920e+00, -4.94024731e-05,  4.99456778e-07,
              -1.79566394e-10,  2.00255376e-14, -950.158922,
              -3.20502331]
        ]
    },
    transport: Transport {
        model: TransportPhaseKind::GAS,
        geometry: TransportGeometryKind::LINEAR,
        well_depth: 38.0,
        diameter: 2.92,
        polarizability: 0.79,
        rotational_relaxation: 280.0
    }
};

pub static SPEC_N2: Species = Species {
    name: "N2",
    composition: &[
        (&ELEM_NN, 2)
    ],
    thermo: ThermoModel {
        model: ThermoModelKind::NASA7,
        temperature_ranges: &[300.0, 1000.0, 5000.0],
        data: &[
            &[ 3.29867700e+00,  1.40824040e-03, -3.96322200e-06,
               5.64151500e-09, -2.44485400e-12, -1.02089990e+03,
               3.95037200],
            &[ 2.92664000e+00,  1.48797680e-03, -5.68476000e-07,
               1.00970380e-10, -6.75335100e-15, -9.22797700e+02,
               5.98052800]
        ]
    },
    transport: Transport {
        model: TransportPhaseKind::GAS,
        geometry: TransportGeometryKind::LINEAR,
        well_depth: 97.53,
        diameter: 3.621,
        polarizability: 1.76,
        rotational_relaxation: 4.0
    }
};

pub static SPEC_O2: Species = Species {
    name: "O2",
    composition: &[
        (&ELEM_OO, 2)
    ],
    thermo: ThermoModel {
        model: ThermoModelKind::NASA7,
        temperature_ranges: &[200.0, 1000.0, 3500.0],
        data: &[
            &[ 3.78245636e+00, -2.99673416e-03,  9.84730201e-06,
              -9.68129509e-09,  3.24372837e-12, -1.06394356e+03,
               3.65767573],
            &[ 3.28253784e+00,  1.48308754e-03, -7.57966669e-07,
               2.09470555e-10, -2.16717794e-14, -1.08845772e+03,
               5.45323129]
        ]
    },
    transport: Transport {
        model: TransportPhaseKind::GAS,
        geometry: TransportGeometryKind::LINEAR,
        well_depth: 107.4,
        diameter: 3.458,
        polarizability: 1.6,
        rotational_relaxation: 3.8
    }
};
