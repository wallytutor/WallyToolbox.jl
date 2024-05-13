# jmakLaplacianFoam

Solver for time-temperature reactive heat release in solids.

Implements differential Johnson–Mehl–Avrami–Kolmogorov (JMAK) reaction progress kinetics for non-isothermal process as proposed by [Mittemeijer et al.](https://doi.org/10.1007/BF02628377).

This solver was initially implemented and tested with OpenFOAM v2212 and later migrated to OpenFOAM 11. The original implementation is made available under [legacy](legacy/) directory and is no longer maintained.

A [sample case](../../run/jmakLaplacianFoam/cylinder/) simulating the temperature evolution of a cylinder immersed in coded external convective boundary conditions is provided for illustration of usage.

In the future, it would be desirable to have the following features implemented:

- [ ] Generalization for an arbitrary number of reactions.
- [ ] Implement `solidThermo` to use `externalWallHeatFluxTemperature`.
