# OpenFOAM 11

## Table of Contents

- [Solver Modules](02-Solver-Modules.md)
- [Physical Models](03-Physical-Models.md)
- [Drag Models](04-Drag-Models.md)

## Tips and reminders

### General topics

- When converting to OpenFOAM v11 [`viscosityModel`](https://cpp.openfoam.org/v11/viscosityModel_8H.html) instead of `transportModel` in `physicalProperties` files. Currently setting `transportModel Newtonian` does not raise any errors.

- When working with a 2-D extruded mesh (1-cell in thickness), the mass flow rate must be scaled by the width of the domain to keep consistency with what would be expected in 3-D.

### Granular flows

- It is a good idea to set `SOI` to a value higher than zero (dimensioned to match the global time-scale of the problem) so that flow is fully developed before particles arrive.

- If it makes sense to do so, make parameter `U0` in the entries of `injectionModels` of `cloudProperties` identical to the velocity specified for the corresponding path. In most cases this applies, except when modeling a particle jet that originates from another source *outside* of the computational domain.

### Troubleshooting

- `Wedge patch '<name>' is not planar.`: in some cases a warning regarding the precision of face normal vectors might be issued in axisymmetric cases. As [it has been reported by Gerhard Holzinger](https://www.researchgate.net/publication/340174689_OpenFoam_-_a_little_user_manual), when generating the mesh the value of `writePrecision` in `controlDict` might be the cause of this problem. Increasing its value should be enough for solving the problem, and if you want to save disk space with unnecessary precision, it can be decreased back for problem solution. **Notice that if running in parallel, `renumberMesh` and `decomposePar` must be run before falling back to the lower write precision.**
