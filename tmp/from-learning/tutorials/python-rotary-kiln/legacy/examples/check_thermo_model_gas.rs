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

use plotters::prelude::*;
use rotary_kiln::*;

fn main() {
    println!("Rotary Kiln: running *check_thermo_model_gas*");

    println!("- check_thermo_model_gas::check_specific_heat");
    check_specific_heat();

    println!("- check_thermo_model_gas::check_enthalpy");
    check_enthalpy();
}

fn check_specific_heat() {
    let xrng = (499.0, 3001.0);
    plot_specific_heat(&SPEC_HH,   xrng, (20.78615653, 20.78615655));
    plot_specific_heat(&SPEC_CC,   xrng, (20.70000000, 21.70000000));
    plot_specific_heat(&SPEC_NN,   xrng, (20.77400000, 20.96000000));
    plot_specific_heat(&SPEC_OO,   xrng, (20.80000000, 21.23000000));
    plot_specific_heat(&SPEC_AR,   xrng, (20.50000000, 21.00000000));
    plot_specific_heat(&SPEC_H2,   xrng, (28.99999999, 37.10000000));
    plot_specific_heat(&SPEC_N2,   xrng, (28.99999999, 37.10000000));
    plot_specific_heat(&SPEC_O2,   xrng, (30.99999999, 40.10000000));
    plot_specific_heat(&SPEC_C1O1, xrng, (28.99999999, 37.10000000));
    plot_specific_heat(&SPEC_C1O2, xrng, (44.99999999, 62.50000000));
    plot_specific_heat(&SPEC_C1H4, xrng, (44.99999999, 115.10000000));
    plot_specific_heat(&SPEC_H2O1, xrng, (34.99999999, 60.10000000));
}

fn check_enthalpy() {
    let xrng = (298.15, 3001.0);
    plot_enthalpy(&SPEC_HH,   xrng, (220.0, 280.0));
    plot_enthalpy(&SPEC_CC,   xrng, (720.0, 780.0));
    plot_enthalpy(&SPEC_NN,   xrng, (470.0, 530.0));
    plot_enthalpy(&SPEC_OO,   xrng, (250.0, 310.0));
    plot_enthalpy(&SPEC_AR,   xrng, (0.000, 60.00));
    plot_enthalpy(&SPEC_H2,   xrng, (0.000, 90.00));
    plot_enthalpy(&SPEC_N2,   xrng, (0.000, 90.00));
    plot_enthalpy(&SPEC_O2,   xrng, (0.000, 100.0));
    plot_enthalpy(&SPEC_C1O1, xrng, (-110.0, -10.0));
    plot_enthalpy(&SPEC_C1O2, xrng, (-380.0, -240.0));
    plot_enthalpy(&SPEC_C1H4, xrng, (-100.0, 200.0));
    plot_enthalpy(&SPEC_H2O1, xrng, (-240.0, -110.0));
}

fn plot_specific_heat(s: &Species, xrng: (f64, f64), yrng: (f64, f64)) {
    println!("Specific heat of {} at 500 K is {:.12e} J/(mol.K)",
             s.name, s.specific_heat_mole(500.0));

    let rng = s.thermo.temperature_ranges;
    let (tmin, tmax) = (rng[0], rng[rng.len() - 1]);
    let t = linspace(tmin, tmax, 1000);
    let y = t.iter().map(|&tk| s.specific_heat_mole(tk)).collect();

    let filename = format!("examples/plots/cp_{}_builtin.png", s.name);
    let caption = format!("Specific Heat of {}", s.name);
    let ylabel = "Specific heat [J/(mol.K)]";

    plot_thermal_property(&filename, &caption, &ylabel, &t, &y, xrng, yrng);
}

fn plot_enthalpy(s: &Species, xrng: (f64, f64), yrng: (f64, f64)) {
    println!("Enthalpy of {} at 500 K is {:.12e} J/mol",
             s.name, s.enthalpy_mole(500.0));

    let rng = s.thermo.temperature_ranges;
    let (tmin, tmax) = (rng[0], rng[rng.len() - 1]);
    let t = linspace(tmin, tmax, 1000);
    let y = t.iter().map(|&tk| s.enthalpy_mole(tk) / 1000.0).collect();

    let filename = format!("examples/plots/h_{}_builtin.png", s.name);
    let caption = format!("Molar Enthalpy of {}", s.name);
    let ylabel = "Enthalpy [J/mol]";

    plot_thermal_property(&filename, &caption, &ylabel, &t, &y, xrng, yrng);
}

fn plot_thermal_property(filename: &str, caption: &str, ylabel: &str,
                         x: &Vec<f64>, y: &Vec<f64>,
                         xrng: (f64, f64), yrng: (f64, f64)) {
    let (xmin, xmax) = xrng;
    let (ymin, ymax) = yrng;
    let data = x.iter().enumerate().map(|(k, &xk)| (xk, y[k]));

    let root = BitMapBackend::new(&filename, (768, 576))
        .into_drawing_area();

    root.fill(&WHITE).unwrap();

    let mut chart = ChartBuilder::on(&root)
        .x_label_area_size(65u32)
        .y_label_area_size(65u32)
        .margin(20u32)
        .caption(caption, ("sans-serif", 24.0).into_font())
        .build_cartesian_2d(xmin..xmax, ymin..ymax)
        .unwrap();

    chart
        .configure_mesh()
        .x_desc("Temperature [K]")
        .y_desc(ylabel)
        .draw()
        .unwrap();

    chart.draw_series(LineSeries::new(data, &BLUE)).unwrap();
}
