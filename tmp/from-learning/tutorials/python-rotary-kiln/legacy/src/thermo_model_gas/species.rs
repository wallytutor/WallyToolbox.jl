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

use std::fmt;
use super::element::*;
use super::models::*;
use super::transport::*;

pub type Composition = (&'static Element, usize);

pub struct Species {
    pub name: &'static str,
    pub composition: &'static [Composition],
    pub thermo: ThermoModel,
    pub transport: Transport
}

impl fmt::Debug for Species {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "\
            \nSpecies ................. {}\
            \n- thermo.model .......... {}\
            \n- transport.model ....... {}\
            \n- transport.geometry .... {}", 
            self.name,
            self.thermo.model,
            self.transport.model,
            self.transport.geometry
        )
    }
}

impl Species {
    pub fn specific_heat_mole(&self, temp: f64) -> f64 {
        match self.thermo.specific_heat_mole(temp) {
            Ok(val) => val,
            Err(()) => {
                panic!("Specific heat of {} error at {} K", self.name, temp)
            }
        }
    }
    pub fn enthalpy_mole(&self, temp: f64) -> f64 {
        match self.thermo.enthalpy_mole(temp) {
            Ok(val) => val,
            Err(()) => {
                panic!("Enthalpy of {} error at {} K", self.name, temp)
            }
        }
    }
}