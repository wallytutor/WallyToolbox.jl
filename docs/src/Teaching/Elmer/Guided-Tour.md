# Guided Tour

## Quick answers

- [Is Elmer the adequate tool for my projects?](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/ElmerOverview.pdf) In this document you find a short introduction to what Elmer can do and the main executables. 

- [How do I start learning Elmer?](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/GetStartedElmer.pdf) Simply put, Elmer does not require basic users to master all the fundamentals of FEM, so following the *getting started* guide seems a good starting point. There you learn how to install, configure, and run the software.

- [Where do I get the binaries of Elmer?](https://www.nic.funet.fi/pub/sci/physics/elmer/) If willing to run in Windows, the previous link provides the compiled binaries; there are also instructions for installing directly in Ubuntu as well as all the documentation and other test and sample cases.

- [I feel alone, where do I find other users?](https://www.elmerfem.org/forum/) The forum seems to be moderately active, so you can go there to chat with other users and developers if you are not in a hurry.

## Geometry and mesh

- Users are encouraged to use external tools such as [gmsh](https://gmsh.info/) or [Salome](https://www.salome-platform.org/) to generate computational meshes, built-in support in Elmer bein limited to very simple geometries only.

- Not all `gmsh` standard mesh formats are supported, but only version 2 (as for OpenFOAM); that said, users are encouraged to export mesh in UNV format to avoid compatibility issues, and also because both proposed tools support it. You can control the element orders in command line using option `-order <N>`; gmsh operates this way so that the same script can generate any supported element type.

- For importing meshes one uses `ElmerGrid <input-format> <output-format>`, where the format arguments are documented in the [manual](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/ElmerGridManual.pdf) sections 1.3 and 1.4. The UNV input is given by number 8 while standard `ElmerSolver` output by number 2, so that the conversion command would start with `ElmerGrid 8 2 <other-arguments...>`. Always verify the number of nodes remain untouched after conversion - or if it changed when using option `-merge <dist>`, merging nodes that are closer than the user-defined `<dist>`.

- Remember to use `Coherence;`  with OpenCASCADE factory in gmsh scripts to automatically strip internal faces; that might not be enough for complex cases, see below. **Note:** I tried doing so and unless `Physical Surfaces` naming the external boundaries are provided every interface is dumped and imported by Elmer; maybe I misunderstood the use of command!

- Because faces are not named in Elmer, *i.e.* no matter what `Physical Surface` names you provide in gmsh, even for the advanced user working from command line it might be interesting to use the interactive zone grouping capabilities of `ElmerGUI`. That might even become a *requirement* as geometric complexity grows.

## Using Elmer

- Newcomers might be interested in `ElmerGUI`; although very intuitive, the interface is quite limited and for complex programs running from command line is the preferred mode.

- Most users will finally end setting up an workflow employing both to `ElmerSolver` (to run the simulations) and `ElmerGrid` (to prepare the grid and setup parallelization).

- There is also `ViewFactors` which might be useful in special cases involving radiation and other executables but they are not mentioned here because they fall in the legacy code family.

- Users must be aware that Elmer has no default unit system; one must take care that units are coherent across the different models and materials.

- Support to mathematical operations in SIF through MATC, which has its own [syntax and documentation](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/MATCManual.pdf). It can be used, *e.g.* for computing temperature dependent properties, what can be helpful for simple expressions (instead of writing Fortran 90 code for extensions).

- Before running in parallel a working case running in serial is required; using `ElmerGUI` this can be enabled in `Run > Parallel settings...`. Notice that after running postprocessing of `.pvtu` needs to be done in ParaView directly.

## Postprocessing

- Also for postprocessing the recommended way is by using external tools as [ParaView](https://www.paraview.org/) and [PyVista](https://docs.pyvista.org/version/stable/), both handling well the VTK format of outputs.

## Limitations and issues

- Currently the GUI is not able to import SIF files generated manually because it stores its state in a XML file; to be able to re-run cases from the GUI users need to create the equivalent case (eventually using the free text fields) in the GUI itself before regenerating a SIF file. Notice that this will overwrite the SIF file, so keep in mind to backup the file in another directory; that is especially required for highly customized cases.
