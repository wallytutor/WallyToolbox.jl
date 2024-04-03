# OpenFOAM 11

## Table of Contents

- [Solver Modules](OpenFOAM.org/Solver-Modules.md)
- [Physical Models](OpenFOAM.org/Physical-Models.md)

## Tips and reminders

### General topics

- When converting to OpenFOAM v11 [`viscosityModel`](https://cpp.openfoam.org/v11/viscosityModel_8H.html) instead of `transportModel` in `physicalProperties` files. Currently setting `transportModel Newtonian` does not raise any errors.

- When working with a 2-D extruded mesh (1-cell in thickness), the mass flow rate must be scaled by the width of the domain to keep consistency with what would be expected in 3-D.

### Granular flows

- It is a good idea to set `SOI` to a value higher than zero (dimensioned to match the global time-scale of the problem) so that flow is fully developed before particles arrive.

- If it makes sense to do so, make parameter `U0` in the entries of `injectionModels` of `cloudProperties` identical to the velocity specified for the corresponding path. In most cases this applies, except when modeling a particle jet that originates from another source *outside* of the computational domain.