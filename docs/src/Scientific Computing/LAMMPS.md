# LAMMPS

[Large-scale Atomic/Molecular Massively Parallel Simulator](https://www.lammps.org/#gsc.tab=0) or simply LAMMPS is a popular molecular dynamics software. It has probably the largest community and is highly mature, reasons why I have chosen this software to learn molecular dynamics at first.

In what follows I will be mostly guided by the [LAMPPS tutorials](https://lammpstutorials.github.io/) by [Simon Gravelle](https://scholar.google.com/citations?user=9fD2JlYAAAAJ&hl=en) in what concerns the contents, with some touches of automation by myself.

The official documentation of LAMMPS can be found [here]([LAMMPS Documentation (17 Apr 2024 version) — LAMMPS documentation](https://docs.lammps.org/Manual.html)).

## Concepts

- Langevin thermostat, see ([[@Schneider1978a]]).

## Setting up a MD simulation

- System initialization: comprises all basic definitions, such as domain boundaries specification, types of atoms, potentials, etc.

- Energy minimization

- Integration of the equations of motion

- Trajectory visualization.

## LAMMPS usage

- A simulation script is simply parsed and run with `lmp -in inputs.lammps`.

- LAMMPS supports some regular expressions, *i.e.* you can set all masses to unity by calling `mass * 1.0`, where the `*` evaluates to all atom types already created.

- Omitted pairwise interaction parameters are by default computed by geometric averaging; Lorentz-Berthelot arithmetic rule is more common, though there is no rigorous argument for justifying any of them and they should be used with care in the absence of better data.

