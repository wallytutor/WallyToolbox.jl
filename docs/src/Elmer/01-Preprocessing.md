# Preprocessing

## Software

Other than the native `ElmerGrid`, one can try the following software for conceiving a geometry and mesh generation workflow.

### [FreeCAD](https://www.freecad.org/)

- Geometry only for now, probably the best in the list
- Good parametric modeling support
	
### [gmsh](https://gmsh.info/)

- Can export MSH2 (14) and UNV (8) formats readable by Elmer

### [netgen](https://ngsolve.org/)

- Is able to write native Elmer linear meshes
- Can be used as a plug-in
	
### [Salome](https://www.salome-platform.org/)

- [Documentation](https://docs.salome-platform.org/latest/main/gui.html)
- Can export UNV (8) meshes readable by Elmer
- An extension to call Elmer directly from Salome is under development
	
### [tetgen](https://wias-berlin.de/software/tetgen/1.5/index.html)

- Can be used as a plug-in

## Recommendations

- Users are encouraged to use external tools such as [gmsh](https://gmsh.info/) or [Salome](https://www.salome-platform.org/) to generate computational meshes, built-in support in Elmer bein limited to very simple geometries only.

- Not all `gmsh` standard mesh formats are supported, but only version 2 (as for OpenFOAM); that said, users are encouraged to export mesh in UNV format to avoid compatibility issues, and also because both proposed tools support it. You can control the element orders in command line using option `-order <N>`; gmsh operates this way so that the same script can generate any supported element type.

- For importing meshes one uses `ElmerGrid <input-format> <output-format>`, where the format arguments are documented in the [manual](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/ElmerGridManual.pdf) sections 1.3 and 1.4. The UNV input is given by number 8 while standard `ElmerSolver` output by number 2, so that the conversion command would start with `ElmerGrid 8 2 <other-arguments...>`. Always verify the number of nodes remain untouched after conversion - or if it changed when using option `-merge <dist>`, merging nodes that are closer than the user-defined `<dist>`.

- Remember to use `Coherence;`  with OpenCASCADE factory in gmsh scripts to automatically strip internal faces; that might not be enough for complex cases, see below. **Note:** I tried doing so and unless `Physical Surfaces` naming the external boundaries are provided every interface is dumped and imported by Elmer; maybe I misunderstood the use of command!

- Because faces are not named in Elmer, *i.e.* no matter what `Physical Surface` names you provide in gmsh, even for the advanced user working from command line it might be interesting to use the interactive zone grouping capabilities of `ElmerGUI`. That might even become a *requirement* as geometric complexity grows.