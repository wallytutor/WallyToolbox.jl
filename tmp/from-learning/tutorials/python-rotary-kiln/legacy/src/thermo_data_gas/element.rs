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

use crate::thermo_model_gas::element::*;

pub static ELEM_HH: Element = Element {
    name: "H",
    atomic_number: 1,
    mass: 1.008,
    entropy298: 65340.0
};

pub static ELEM_CC: Element = Element {
    name: "C",
    atomic_number: 6,
    mass: 12.011,
    entropy298: 5740.0
};

pub static ELEM_NN: Element = Element {
    name: "N",
    atomic_number: 7,
    mass: 14.007,
    entropy298: 95804.5
};

pub static ELEM_OO: Element = Element {
    name: "O",
    atomic_number: 8,
    mass: 15.999,
    entropy298: 102573.5
};

pub static ELEM_AR: Element = Element {
    name: "Ar",
    atomic_number: 18,
    mass: 39.95,
    entropy298: 154845.0
};
