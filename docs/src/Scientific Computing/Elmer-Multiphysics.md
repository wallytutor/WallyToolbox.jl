# Elmer Multiphysics

Elmer is a multiphysics finite element method (FEM) solver mainly developed by CSC and maintained at [GitHub](https://github.com/ElmerCSC/elmerfem). Several resources can be found in is [official webpage](https://www.csc.fi/web/elmer) and in the [community portal](https://www.elmerfem.org/blog/) and in the [forum](https://www.elmerfem.org/forum/index.php). There is also an [YouTube channel](https://www.youtube.com/@elmerfem) with several tutorials and illustration of the package capabilities.

The goal of this page is not to supersede the [documentation](https://www.csc.fi/web/elmer/documentation), but to make it (partially) available as a webpage where search and navigation become more intuitive. *Notice that this will be fed according to my personal projects and learning, so any contribution to accelerate the process is welcome.* Here you find a *user-guide-style* page while more details are provided in the selected notes of [Elmer Documentation](Elmer-Documentation.md).

---
## Quick answers

- [Is Elmer the adequate tool for my projects?](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/ElmerOverview.pdf) In this document you find a short introduction to what Elmer can do and the main executables. 

- [How do I start learning Elmer?](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/GetStartedElmer.pdf) Simply put, Elmer does not require basic users to master all the fundamentals of FEM, so following the *getting started* guide seems a good starting point. There you learn how to install, configure, and run the software.

- [Where do I get the binaries of Elmer?](https://www.nic.funet.fi/pub/sci/physics/elmer/) If willing to run in Windows, the previous link provides the compiled binaries; there are also instructions for installing directly in Ubuntu as well as all the documentation and other test and sample cases.

- [I feel alone, where do I find other users?](https://www.elmerfem.org/forum/) The forum seems to be moderately active, so you can go there to chat with other users and developers if you are not in a hurry.

---
## Limitations and issues

- Currently the GUI is not able to import SIF files generated manually because it stores its state in a XML file; to be able to re-run cases from the GUI users need to create the equivalent case (eventually using the free text fields) in the GUI itself before regenerating a SIF file. Notice that this will overwrite the SIF file, so keep in mind to backup the file in another directory; that is especially required for highly customized cases.

---
## Ongoing work

- Development of a [VS Code syntax highlight extension](https://github.com/wallytutor/WallyToolbox.jl/tree/main/tools/vscode/extensions/wally-sif) with help of data provided in [SOLVER.KEYWORDS](https://github.com/ElmerCSC/elmerfem/blob/devel/fem/src/SOLVER.KEYWORDS).

---
## Retrieving materials

Because there are plenty of interesting materials in Elmer public directory, it is worth downloading it all and selecting what to keep later. In a Linux terminal one could run the following command. If you also want to retrieve the animations, binaries, and virtual machines, consider removing and/or modifying the `-X` options.

```bash
#!/usr/bin/env bash

URL="https://www.nic.funet.fi/pub/sci/physics/elmer/"

wget -r -l 20 --no-parent           \
    -X /pub/sci/physics/elmer/anim/ \
    -X /pub/sci/physics/elmer/bin/  \
    -R "index.html*"                \
    ${URL}
```

---

## Preprocessing steps

- Other than the native `ElmerGrid`, several other software can be used for conceiving a geometry and mesh generation workflow. Users are encouraged to use external tools such as [gmsh](https://gmsh.info/) or [Salome](https://www.salome-platform.org/) to generate computational meshes, built-in support in Elmer bein limited to very simple geometries only. For complex geometries [FreeCAD](https://www.freecad.org/) is a standout alternative. For more consider reading [Geometry and Preprocessing](Geometry-and-Preprocessing.md).

- Not all `gmsh` standard mesh formats are supported, but only version 2 (as for OpenFOAM); that said, users are encouraged to export mesh in UNV format to avoid compatibility issues, and also because both proposed tools support it. You can control the element orders in command line using option `-order <N>`; gmsh operates this way so that the same script can generate any supported element type.

- For importing meshes one uses `ElmerGrid <input-format> <output-format>`, where the format arguments are documented in the [manual](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/ElmerGridManual.pdf) sections 1.3 and 1.4. The UNV input is given by number 8 while standard `ElmerSolver` output by number 2, so that the conversion command would start with `ElmerGrid 8 2 <other-arguments...>`. Always verify the number of nodes remain untouched after conversion - or if it changed when using option `-merge <dist>`, merging nodes that are closer than the user-defined `<dist>`.

- Remember to use `Coherence;`  with OpenCASCADE factory in gmsh scripts to automatically strip internal faces; that might not be enough for complex cases, see below. **Note:** I tried doing so and unless `Physical Surfaces` naming the external boundaries are provided every interface is dumped and imported by Elmer; maybe I misunderstood the use of command!

- Because faces are not named in Elmer, *i.e.* no matter what `Physical Surface` names you provide in gmsh, even for the advanced user working from command line it might be interesting to use the interactive zone grouping capabilities of `ElmerGUI`. That might even become a *requirement* as geometric complexity grows.

| Software | Notes                                                                                                              |
| -------- | ------------------------------------------------------------------------------------------------------------------ |
| FreeCAD  | Geometry only for now, probably the best in the list; good parametric modeling support.                            |
| Salome   | Can export UNV (8) meshes readable by Elmer. An extension to call Elmer directly from Salome is under development. |
| gmsh     | Can export MSH2 (14) and UNV (8) formats readable by Elmer.                                                        |
| netgen   | Is able to write native Elmer linear meshes; can be used as a plug-in.                                             |
| tetgen   | Can be used as a plug-in.                                                                                          |

## Using Elmer

- Newcomers might be interested in `ElmerGUI`; although very intuitive, the interface is quite limited and for complex programs running from command line is the preferred mode.

- Most users will finally end setting up an workflow employing both to `ElmerSolver` (to run the simulations) and `ElmerGrid` (to prepare the grid and setup parallelization).

- There is also `ViewFactors` which might be useful in special cases involving radiation and other executables but they are not mentioned here because they fall in the legacy code family.

- Users must be aware that Elmer has no default unit system; one must take care that units are coherent across the different models and materials.

- Support to mathematical operations in SIF through MATC, which has its own [syntax and documentation](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/MATCManual.pdf). It can be used, *e.g.* for computing temperature dependent properties, what can be helpful for simple expressions (instead of writing Fortran 90 code for extensions).

## Parallel computing

- Before running in parallel a working case running in serial is required; using `ElmerGUI` this can be enabled in `Run > Parallel settings...`. Notice that after running postprocessing of `.pvtu` needs to be done in ParaView directly.

- To partition the mesh from command line one needs to run `ElmerGrid 2 2 <mesh-name> -partdual -metiskway <N>`, which will convert `<mesh-name>` from Elmer mesh format (2) into itself (thus the `2 2` in the command) and dump the resulting mesh in `partitions.<N>`, with `<N>` being the number of physical cores to run the simulation.

- Parallel cases can be run with `mpiexec -n <N> ElmerSolver_mpi`. Notice that under Linux the MPI runner is called `mpirun` instead of `mpiexec`.

## Tips and ideas


- Use `Coordinate Mapping` to rotate meshes with oriented particles
- Scaling of a single direction can be done with `Coordinate Scaling`
- Time step can be changed with a list of elements in `Timestep Intervals`, *e.g.*

```Fortran
! Run 10 time-steps of 0.1 s, then 100 with 1.0 s.
Timestep Intervals(2) = 10 100
Timestep Sizes(2) = 0.1 1.0
```

- Take care with `Linear System Abort Not Converged = True` for physical consistency; generally continuing a simulation after a failed step is worthless unless one is pseudo-stepping towards a difficult (highly nonlinear) steady-state.

## Material properties

Material properties can be specified as:

- Constant: just the default numeric input in SIF files

- Tabulated linearly or using a cubic spline, *e.g.*

```Fortran
! Linear interpolation
Viscosity = Variable Temperature
  Real
	298.15 1.0
	! ... more data here
	373.15 2.0
End

! Cubic spline interpolation
Viscosity = Variable Temperature
  Real cubic
	298.15 1.0
	315.15 1.1
	345.15 1.5
	! ... more data here
	373.15 2.0
End
```

- Arrays: for representing anisotropic bodies, *e.g.*

```Fortran
Heat Conductivity(3,3) = 1 0 0\
                         0 1 0\
                         0 0 2
```

- Using MATC as explained [here](Elmer-Documentation.md). Notice that sourcing files in MATC is the recommended way to get reusable code; coding MATC in SIF files requires to escape all lines and quickly becomes messy.

- User-defined functions (UDF) can also be provided in Fortran; notice that even when MATC can be used, this may lead to a speed-up of calculations with the inconvenient of needing more code. So for cases that are intended to be reused, it is important to consider writing proper extensions in Fortran. The following example illustrates a temperature dependent thermal conductivity function which is evaluated by Elmer at all nodes. In most cases a simple `USE DefUtils` is enough to get the required Elmer API to write the extension.

```Fortran
FUNCTION conductivity(model, n, time) RESULT(k)
    !**************************************************************
    ! Load Elmer library.
    !**************************************************************
    
    USE DefUtils
    IMPLICIT None

    !**************************************************************
    ! Function interface.
    !**************************************************************
    
    TYPE(Model_t) :: model
    INTEGER       :: n
    REAL(KIND=dp) :: time, k

    !**************************************************************
    ! Function internals.
    !**************************************************************
    
    TYPE(Variable_t), POINTER :: varptr
    REAL(KIND=dp) :: T
    INTEGER :: idx

    !**************************************************************
    ! Actual implementation
    !**************************************************************

    ! Retrieve pointer to the temperature variable.
    varptr => VariableGet(model%Variables, 'Temperature')

    ! Access index of current node.
    idx = varptr%Perm(n)

    ! Retrieve nodal temperature.
    T = varptr%Values(idx)

    ! Compute heat conductivity from NodalTemperature, k=k(T)
    k = 2.0 - T * (2.5e-03 - 1.0e-06 * T)
END FUNCTION conductivity
```

In order to compile the above assume it is written to `properties.f90` file; then one can call `elmerf90 properties.f90 –o properties` to generate the required shared library that is loaded in runtime by Elmer. Below we illustrate the use of `Procedure` to attach this library to a given material; first one provides the name of the shared library then the name of the function. A single library can in fact contain several functionalities.

```C
Material 1
  Name = "Solid"
  Heat Conductivity = Variable Time
    Procedure "properties" "conductivity"
  Heat Capacity = 1000
  Density = 2500
End
```

## Postprocessing

For postprocessing the recommended way is by using external tools as [ParaView](https://www.paraview.org/) and [PyVista](https://docs.pyvista.org/version/stable/), both handling well the VTK format of outputs. Nonetheless there are a some in-solver processing utilities that are worth knowing, especially in what concerns extracting and filtering data from certain regions, creating new fields, and computing fluxes.

### Creating a new scalar

The keyword set of materials is actually not fixed; one can, for instance, create composition field in different units with MATC, as illustrated below (case [here](https://github.com/wallytutor/WallyToolbox.jl/tree/main/apps/Elmer/diffusion_solids/carburizing_slycke_gui)):

```Fortran
MoleFraction = Variable Concentration
  Real MATC "carbonmolefraction(tx)"
```

Then in solver `SaveMaterials`, this new name `MoleFraction` can be used as a variable:

```Fortran
Solver 1
  Equation = SaveMaterials
  Parameter 1 = Concentration Diffusivity
  Parameter 2 = MoleFraction
  Procedure = "SaveData" "SaveMaterials"
  Exec Solver = After Timestep
End
```

Another situation that can be frequently found is unit conversion for temperature. It was chosen to implement it in [this case](https://github.com/wallytutor/WallyToolbox.jl/tree/main/apps/Elmer/conduction_refractory/transient_parallel) because it is multi-material; that is a reminder that in such cases the new variable needs to be created for all materials (as this is a tweak, since the temperature is not a material property, but a global field). If forgotten in one material, an error will show up in ParaView telling you that the field is not available in some regions.
