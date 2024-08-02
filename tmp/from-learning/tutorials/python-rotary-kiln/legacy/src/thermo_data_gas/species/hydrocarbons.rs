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

pub static SPEC_C1H4: Species = Species {
    name: "CH4",
    composition: &[
        (&ELEM_CC, 1),
        (&ELEM_HH, 4),
    ],
    thermo: ThermoModel {
        model: ThermoModelKind::NASA7,
        temperature_ranges: &[200.0, 1000.0, 3500.0],
        data: &[
            &[ 5.14987613e+00, -1.36709788e-02,  4.91800599e-05,
              -4.84743026e-08,  1.66693956e-11, -1.02466476e+04,
              -4.64130376],
            &[ 7.48514950e-02,  1.33909467e-02, -5.73285809e-06,
               1.22292535e-09, -1.01815230e-13, -9.46834459e+03,
               18.4373180]
        ]
    },
    transport: Transport {
        model: TransportPhaseKind::GAS,
        geometry: TransportGeometryKind::LINEAR,
        well_depth: 141.4,
        diameter: 3.746,
        polarizability: 2.6,
        rotational_relaxation: 13.0
    }
};
