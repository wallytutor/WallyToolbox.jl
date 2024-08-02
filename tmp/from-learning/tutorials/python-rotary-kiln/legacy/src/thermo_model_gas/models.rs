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

use crate::numerical::*;
use crate::physical_constants::*;
use super::enums::*;

pub struct ThermoModel {
    pub model: ThermoModelKind,
    pub temperature_ranges: &'static [f64],
    pub data: &'static [&'static [f64]]
}

impl ThermoModel {
    pub fn specific_heat_mole(&self, temp: f64) -> Result<f64, ()> {
        if let Some(a) = self.select_polynomial(temp) {
            match self.model {
                ThermoModelKind::NASA7 => {
                    let val: f64 = a[0] + 
                                   a[1] * temp +
                                   a[2] * pow(temp, 2) +
                                   a[3] * pow(temp, 3) +
                                   a[4] * pow(temp, 4);
                    Ok(GAS_CONSTANT * val)
                },
                ThermoModelKind::NASA9 => {
                    Ok(0.0)
                }
            }
        } else {
            Err(())
        }
    }

    pub fn enthalpy_mole(&self, temp: f64) -> Result<f64, ()> {
        if let Some(a) = self.select_polynomial(temp) {
            match self.model {
                ThermoModelKind::NASA7 => {
                    let val: f64 = (a[0] / 1.0) + 
                                   (a[1] / 2.0) * temp +
                                   (a[2] / 3.0) * pow(temp, 2) +
                                   (a[3] / 4.0) * pow(temp, 3) +
                                   (a[4] / 5.0) * pow(temp, 4) +
                                   (a[5] / temp);
                    Ok(GAS_CONSTANT * temp * val)
                },
                ThermoModelKind::NASA9 => {
                    Ok(0.0)
                }
            }
        } else {
            Err(())
        }
    }

    fn select_polynomial(&self, temp: f64) -> Option<&[f64]> {
        let n_intervals = self.temperature_ranges.len() - 1;
        let mut temp_range_idx: usize = 0;

        if temp < self.temperature_ranges[0] ||
           temp > self.temperature_ranges[n_intervals] {
            return None;
        }

        for k in 0..n_intervals {
            let t_min = self.temperature_ranges[k];
            let t_max = self.temperature_ranges[k + 1];
            if t_min < temp && temp <= t_max {
                temp_range_idx = k;
                break;
            }
        }

        Some(&self.data[temp_range_idx])
    }
}