# OpenFOAM 11

Working repository for OpenFOAM v11.

## Applications

- [jmakLaplacianFoam](applications/jmakLaplacianFoam/): solver for time-temperature reactive heat release in solids.

## Simulation cases

### jmakLaplacianFoam

- [cylinder](run/jmakLaplacianFoam/cylinder/): solve temperature evolution in a self heating cylinder under JMAK kinetics.

### incompressibleDenseParticleFluid

- [sedimentationBox](run/incompressibleDenseParticleFluid/sedimentationBox/): study the role of some drag models over falling particle dynamics.

### Other or multi-solver

- [thermophysicalProps](run/thermophysicalProps/): reference case for setting up thermophysical properties. This case illustrates how to use constant and functional forms of thermophysical properties. It might also be useful in conjunction with other solvers using the thermophysical library. One must keep in mind that solution with temperature dependent properties is quite expensive and tabulation of data is also available in OpenFOAM (to be added to this case in the future).
