// t1.geo

// The following command defines a new variable `lc':
lc = 1.0e-02;

// Create a few tagged points with tag `p*` and target mesh size `lc`:
p1 = newp; Point(p1) = {0.0, 0.0, 0.0, lc};
p2 = newp; Point(p2) = {0.1, 0.0, 0.0, lc};
p3 = newp; Point(p3) = {0.1, 0.3, 0.0, lc};
p4 = newp; Point(p4) = {0.0, 0.3, 0.0, lc};

// Create a few tagged lines with tag `l*` from the above points:
l1 = newl; Line(l1) = {p1, p2};
l2 = newl; Line(l2) = {p3, p2};
l3 = newl; Line(l3) = {p3, p4};
l4 = newl; Line(l4) = {p4, p1};

// Before creating a surface, a curve loop must be defined. Notice that lines
// must be right-hand oriented to enclose a region.
c1 = newcl; Curve Loop(c1) = {l4, l1, -l2, l3};

// We can then define the surface as a list of curve loops (only one here).
s1 = news; Plane Surface(s1) = {c1};

// This is for a more advanced tutorial, just playing around here.
// Transfinite Surface{s1};
// Recombine Surface {s1};

// By default, if physical groups are defined, Gmsh will export in output files
// only mesh elements that belong to at least one physical group. (To force Gmsh
// to save all elements, whether they belong to physical groups or not, set
// `Mesh.SaveAll=1;', or specify `-save_all' on the command line.) 
Physical Curve("walls") = {l1, l2, l4};
Physical Surface("the_surface") = {s1};

// Now that the geometry is complete, you can
// - either open this file with Gmsh and select `2D' in the `Mesh' module to
//   create a mesh; then select `Save' to save it to disk in the default format
//   (or use `File->Export' to export in other formats);
// - or run `gmsh t1.geo -2` to mesh in batch mode on the command line.
// - you could also uncomment the following lines in this script, which would
//   lead Gmsh to mesh and save the mesh every time the file is parsed. (To
//   simply parse the file from the command line, you can use `gmsh t1.geo -')
//
// By default, Gmsh saves meshes in the latest version of the Gmsh mesh file
// format (the `MSH' format). Above we also save to Ideas-UNV format, what can
// be useful if generating meshes that can be imported in Ansys Fluent. 
//
// - In the GUI: open `File->Export', enter your `filename.msh' and then pick
//   the version in the dropdown menu.
// - On the command line: use the `-format' option (e.g. `gmsh file.geo -format
//   msh2 -2').
// - In a `.geo' script: add `Mesh.MshFileVersion = x.y;' for any version
//   number `x.y'.
// - As an alternative method, you can also not specify the format explicitly,
//   and just choose a filename with the `.msh2' or `.msh4' extension.

Mesh.SaveAll = 1;
Mesh.MshFileVersion = 2.2;
Mesh 2;

Save "t1.msh";
Save "t1.unv";
