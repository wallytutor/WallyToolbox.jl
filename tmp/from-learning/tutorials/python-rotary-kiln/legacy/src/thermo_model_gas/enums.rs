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

pub enum ThermoModelKind {
    NASA7,
    NASA9,
}

pub enum TransportPhaseKind {
    GAS,
}

pub enum TransportGeometryKind {
    ATOM,
    LINEAR,
}

impl fmt::Display for ThermoModelKind {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            ThermoModelKind::NASA7 => write!(f, "NASA7"),
            ThermoModelKind::NASA9 => write!(f, "NASA9")
        }
    }
}

impl fmt::Display for TransportPhaseKind {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            TransportPhaseKind::GAS => write!(f, "GAS")
        }
    }
}

impl fmt::Display for TransportGeometryKind {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            TransportGeometryKind::ATOM   => write!(f, "ATOM"),
            TransportGeometryKind::LINEAR => write!(f, "LINEAR")
        }
    }
}