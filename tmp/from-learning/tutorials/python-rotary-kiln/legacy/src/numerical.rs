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

pub fn pow(a: f64, n: i32) -> f64 {
    match n {
        -4 => 1.0 / pow(a, 4),
        -3 => 1.0 / pow(a, 3),
        -2 => 1.0 / pow(a, 2),
        -1 => 1.0 / a,
         0 => 1.0,
         1 => a,
         2 => a * a,
         3 => a * a * a,
         4 => a * a * a * a,
        _ => f64::powf(a, n as f64)
    }
}

pub fn linspace(xstart: f64, xend: f64, n: usize) -> Vec<f64> {
    let dx = (xend - xstart) / (n as f64 - 1.0);
    (0..n).map(|i| xstart + (i as f64) * dx).collect()
}
