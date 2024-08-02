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

pub static SPEC_C1O1: Species = Species {
    name: "CO",
    composition: &[
        (&ELEM_CC, 1),
        (&ELEM_OO, 1),
    ],
    thermo: ThermoModel {
        model: ThermoModelKind::NASA7,
        temperature_ranges: &[200.0, 1000.0, 3500.0],
        data: &[
            &[ 3.57953347e+00, -6.10353680e-04,  1.01681433e-06,
               9.07005884e-10, -9.04424499e-13, -1.43440860e+04,
               3.50840928],
            &[ 2.71518561e+00,  2.06252743e-03, -9.98825771e-07,
               2.30053008e-10, -2.03647716e-14, -1.41518724e+04,
               7.81868772]
        ]
    },
    transport: Transport {
        model: TransportPhaseKind::GAS,
        geometry: TransportGeometryKind::LINEAR,
        well_depth: 98.1,
        diameter: 3.65,
        polarizability: 1.95,
        rotational_relaxation: 1.8
    }
};

pub static SPEC_C1O2: Species = Species {
    name: "CO2",
    composition: &[
        (&ELEM_CC, 1),
        (&ELEM_OO, 2),
    ],
    thermo: ThermoModel {
        model: ThermoModelKind::NASA7,
        temperature_ranges: &[200.0, 1000.0, 3500.0],
        data: &[
            &[ 2.35677352e+00,  8.98459677e-03, -7.12356269e-06,
               2.45919022e-09, -1.43699548e-13, -4.83719697e+04,
               9.90105222],
            &[ 3.85746029e+00,  4.41437026e-03, -2.21481404e-06,
               5.23490188e-10, -4.72084164e-14, -4.87591660e+04,
               2.27163806]
        ]
    },
    transport: Transport {
        model: TransportPhaseKind::GAS,
        geometry: TransportGeometryKind::LINEAR,
        well_depth: 244.0,
        diameter: 3.763,
        polarizability: 2.65,
        rotational_relaxation: 2.1
    }
};

pub static SPEC_H2O1: Species = Species {
    name: "H2O",
    composition: &[
        (&ELEM_HH, 2),
        (&ELEM_OO, 1),
    ],
    thermo: ThermoModel {
        model: ThermoModelKind::NASA7,
        temperature_ranges: &[200.0, 1000.0, 3500.0],
        data: &[
            &[ 4.19864056e+00, -2.03643410e-03,  6.52040211e-06,
              -5.48797062e-09,  1.77197817e-12, -3.02937267e+04,
              -0.849032208],
            &[ 3.03399249e+00,  2.17691804e-03, -1.64072518e-07,
              -9.70419870e-11,  1.68200992e-14, -3.00042971e+04,
               4.96677010]
        ]
    },
    transport: Transport {
        model: TransportPhaseKind::GAS,
        geometry: TransportGeometryKind::LINEAR,
        well_depth: 572.4,
        diameter: 2.605,
        polarizability: 1.844,
        rotational_relaxation: 4.0
    }
};
