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

pub static SPEC_HH: Species = Species {
    name: "H",
    composition: &[
        (&ELEM_HH, 1)
    ],
    thermo: ThermoModel {
        model: ThermoModelKind::NASA7,
        temperature_ranges: &[200.0, 1000.0, 3500.0],
        data: &[
            &[ 2.50000000e+00,  7.05332819e-13, -1.99591964e-15,
               2.30081632e-18, -9.27732332e-22,  2.54736599e+04,
              -0.446682853],
            &[ 2.50000001e+00, -2.30842973e-11,  1.61561948e-14,
              -4.73515235e-18,  4.98197357e-22,  2.54736599e+04,
              -0.446682914]
        ]
    },
    transport: Transport {
        model: TransportPhaseKind::GAS,
        geometry: TransportGeometryKind::ATOM,
        well_depth: 145.0,
        diameter: 2.05,
        polarizability: 0.0,
        rotational_relaxation: 0.0
    }
};

pub static SPEC_CC: Species = Species {
    name: "C",
    composition: &[
        (&ELEM_CC, 1)
    ],
    thermo: ThermoModel {
        model: ThermoModelKind::NASA7,
        temperature_ranges: &[200.0, 1000.0, 3500.0],
        data: &[
            &[ 2.55423955e+00, -3.21537724e-04,  7.33792245e-07,
              -7.32234889e-10,  2.66521446e-13,  8.54438832e+04,
               4.53130848],
            &[ 2.49266888e+00,  4.79889284e-05, -7.24335020e-08,
               3.74291029e-11, -4.87277893e-15,  8.54512953e+04,
               4.80150373]
        ]
    },
    transport: Transport {
        model: TransportPhaseKind::GAS,
        geometry: TransportGeometryKind::ATOM,
        well_depth: 71.4,
        diameter: 3.298,
        polarizability: 0.0,
        rotational_relaxation: 0.0
    }
};

pub static SPEC_NN: Species = Species {
    name: "N",
    composition: &[
        (&ELEM_NN, 1)
    ],
    thermo: ThermoModel {
        model: ThermoModelKind::NASA7,
        temperature_ranges: &[200.0, 1000.0, 6000.0],
        data: &[
            &[ 2.50000000e+00,  0.00000000e+00,  0.00000000e+00,
               0.00000000e+00,  0.00000000e+00,  5.61046370e+04,
               4.1939087],
            &[ 2.41594290e+00,  1.74890650e-04, -1.19023690e-07,
               3.02262450e-11, -2.03609820e-15,  5.61337730e+04,
               4.6496096]
        ]
    },
    transport: Transport {
        model: TransportPhaseKind::GAS,
        geometry: TransportGeometryKind::ATOM,
        well_depth: 71.4,
        diameter: 3.298,
        polarizability: 0.0,
        rotational_relaxation: 0.0
    }
};

pub static SPEC_OO: Species = Species {
    name: "O",
    composition: &[
        (&ELEM_OO, 1)
    ],
    thermo: ThermoModel {
        model: ThermoModelKind::NASA7,
        temperature_ranges: &[200.0, 1000.0, 3500.0],
        data: &[
            &[ 3.16826710e+00, -3.27931884e-03,  6.64306396e-06,
              -6.12806624e-09,  2.11265971e-12,  2.91222592e+04,
               2.05193346],
            &[ 2.56942078e+00, -8.59741137e-05,  4.19484589e-08,
              -1.00177799e-11,  1.22833691e-15,  2.92175791e+04,
               4.78433864]
        ]
    },
    transport: Transport {
        model: TransportPhaseKind::GAS,
        geometry: TransportGeometryKind::ATOM,
        well_depth: 80.0,
        diameter: 2.75,
        polarizability: 0.0,
        rotational_relaxation: 0.0
    }
};

pub static SPEC_AR: Species = Species {
    name: "AR",
    composition: &[
        (&ELEM_AR, 1)
    ],
    thermo: ThermoModel {
        model: ThermoModelKind::NASA7,
        temperature_ranges: &[200.0, 1000.0, 5000.0],
        data: &[
            &[ 2.50000000e+00,  0.00000000e+00,  0.00000000e+00,
               0.00000000e+00,  0.00000000e+00, -7.45375000e+02,
               4.36600000],
            &[ 2.50000000e+00,  0.00000000e+00,  0.00000000e+00,
               0.00000000e+00,  0.00000000e+00, -7.45375000e+02,
               4.36600000]
        ]
    },
    transport: Transport {
        model: TransportPhaseKind::GAS,
        geometry: TransportGeometryKind::ATOM,
        well_depth: 136.5,
        diameter: 3.33,
        polarizability: 0.0,
        rotational_relaxation: 0.0
    }
};
