# Gmsh

The original files were copied from `share/doc/gmsh/tutorials` directory from
Gmsh installation directory.  During the course of the tutorials I have edited
and most likely cleaned-up/minified the files because that is part of my
learning methodology.

## Topics

1. [Geometry basics, elementary entities, physical groups](t1.geo)

1. [Transformations, extruded geometries, volumes](t2.geo)
    - Getting coordinates of points
    - How to export an unrolled geometry file

1. [Extruded meshes, ONELAB parameters, options](t3.geo)
    - Extrusion with default kernel is limited to `Pi` radians
    - OpenCASCADE kernel allows for any size of rotation
    - Defining constants with ONELAB
    - ONELAB parameters can be overridden through CLI `-setnumber <var> <val>`
    - Setting general parameters in scripts

1. [Built-in functions, holes in surfaces, annotations, entity colors](t4.geo)
    - As for rotation, circle arcs are also limited in default kernel
    - A surface with `N` holes needs `N+1` curve loops to be defined
    - The first curve loop defines the external shell of the surface
    - A `View` can be created for annotations, *i.e.* for presentations
    - Click capture may be useful for getting surfaces in complex geometries

1. [Mesh sizes, macros, loops, holes in volumes](t5.geo)
    - Scaling of all mesh dimensions can be done with `-clscale <val>`

1. [Transfinite meshes, deleting entities](t6.geo)
    - Use `Delete` for removing `Surface` and `Curve` entities
    - With `Transfinite Curve` specify the number of grid points over a curve
    - Transfinite of more than 4 points need 4 corners to be provided manually
    - Use `Mesh.Smoothing` to apply smoothing for a more regular mesh

1. [Background meshes](t7.geo)
    - Mesh sizes can be specified accurately by providing a background mesh
    - Background meshes *BM* are composed, *e.g* of scalar triangles `ST`
    - If the *BM* is based on an actual mesh, create `NewModel` (see comment)

1. [Post-processing, image export and animations](t8.geo)
    - In Gmsh a `View` is a post-processing dataset maniputation
    - For large datasets do not use *parsed* format, but MSH instead
    - Text in 2D and 3D are created with `T2` and `T3` (also see t4.geo)
    - It is possible to export animations directly from *time steps*

1. [Plugins](t9.geo)
    - Interesting maniputation but need to check how to get any data

1. [Mesh size fields](t10.geo)
    - Combining `Distance` and `Threshold` we can refine mesh near features
    - Using `Mesh.Algorithm = 5;` is recommended for complex gradients of mesh

1. [Unstructured quadrangular meshes](t11.geo)
    - Recombination of all surfaces with `Recombine Surface {:};`
    - Alternativelly one can use `Mesh.RecombineAll` flag
    - `Mesh.Algorithm = 8;` allows mostly right triangles
    - Algorithm can be controlled through `Mesh.RecombinationAlgorithm`

1. [Cross-patch meshing with compounds](t12.geo)
    - Curves and surfaces can be enforced to be meshed as a whole.
    - Limited to simple shapes, for more complex the next see the tutorials.

1. [Remeshing an STL file without an underlying CAD model](t13.geo)

1. [Homology and cohomology computation](t14.geo)

1. [Embedded points, lines and surfaces](t15.geo)

1. [Constructive Solid Geometry, OpenCASCADE geometry kernel](t16.geo)

1. [Anisotropic background mesh](t17.geo)

1. [Periodic meshes](t18.geo)

1. [Thrusections, fillets, pipes, mesh size from curvature](t19.geo)

1. [STEP import and manipulation, geometry partitioning](t20.geo)

1. [Mesh partitioning](t21.geo)

## Projects

- [x] Conceive a reasonably complex mesh with boundary layers
- [ ] Use a STL file exported from external CAD/Blender for 3D meshing
- [ ] Create a progressive tutorial with all learned resources but for a fixed geometry

## Useful links

- [Tutorial by SAE Miller](https://www.youtube.com/playlist?list=PLbiOzt50Bx-l2QyX5ZBv9pgDtIei-CYs_)
