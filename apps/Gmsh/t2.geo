// t2.geo

// Including a file is equivalent to copy-pasting its contents:
Include "t1.geo";

// Edition of geometry and mesh can continue normally here:
p5 = newp; Point(p5) = {0, .4, 0, lc};
l5 = newl; Line(l5) = {4, 5};

// Gmsh also provides tools to transform (translate, rotate, etc.)
Translate {-0.02, 0, 0} { Point{p5}; }

// And it can be further rotated along z-axis by -Pi/4 around (0, 0.3, 0) with:
Rotate {{0,0,1}, {0,0.3,0}, -Pi/4} { Point{p5}; }

// Point 3 can be duplicated and translated by 0.05 along the y axis:
p6 = Translate {0, 0.05, 0} { Duplicata{ Point{p3}; } };

l7 = newl; Line(l7) = {p3, p6};
l8 = newl; Line(l8) = {p6, p5};
c2 = newcl; Curve Loop(c2) = {l5,-l8,-l7, l3};
s2 = news; Plane Surface(s2) = {c2};

// The `Translate' command returns a list containing the tags of the
// translated entities. Let's translate copies of the two surfaces.
// List indexing stars at 0. To get the size of a list, use: len = #mylist[].
// Parentheses can also be used instead of square brackets.
my_new_surfs[] = Translate {0.12, 0, 0} { Duplicata{ Surface{s1, s2}; } };
Printf("New surfaces '%g' and '%g'", my_new_surfs[0], my_new_surfs[1]);

// Volumes are the fourth type of elementary entities in Gmsh. In the same way
// one defines curve loops to build surfaces, one has to define surface loops
// (i.e. `shells') to build volumes. The following volume does not have holes
// and thus consists of a single surface loop:
Point(100) = {0.0, 0.30, 0.12, lc}; 
Point(101) = {0.1, 0.30, 0.12, lc};
Point(102) = {0.1, 0.35, 0.12, lc};

// XXX: get coordinates of point 5.
xyz[] = Point{p5};
Point(103) = {xyz[0], xyz[1], 0.12, lc};

Line(110) = {p4, 100};   Line(111) = {p3, 101};
Line(112) = {p6, 102};   Line(113) = {p5, 103};
Line(114) = {103, 100}; Line(115) = {100, 101};
Line(116) = {101, 102}; Line(117) = {102, 103};

Curve Loop(118) = {115, -111, l3, 110};  Plane Surface(119) = {118};
Curve Loop(120) = {111, 116, -112, -l7}; Plane Surface(121) = {120};
Curve Loop(122) = {112, 117, -113, -l8}; Plane Surface(123) = {122};
Curve Loop(124) = {114, -110, l5, 113};  Plane Surface(125) = {124};
Curve Loop(126) = {115, 116, 117, 114}; Plane Surface(127) = {126};

Surface Loop(128) = {127, 119, 121, 123, 125, 11};
Volume(129) = {128};

// When a volume can be extruded from a surface, it is usually easier to use the
// `Extrude' command directly instead of creating all the points, curves and
// surfaces by hand.
Extrude {0, 0, 0.12} { Surface{my_new_surfs[1]}; }

// Manually assign a mesh size to some of the new points:
MeshSize {103, 105, 109, 102, 28, 24, p6, p5} = lc * 3;

// We finally group volumes 129 and 130 in a single physical group with tag `1'
// and name "The volume":
Physical Volume("The volume", 1) = {129,130};

// Note that, if the transformation tools are handy to create complex 
// geometries, it is also sometimes useful to generate the `flat' geometry, with
// an explicit representation of all the elementary entities. With the built-in
// geometry kernel, this can be achieved with 
// `File->Export' by selecting the `Gmsh Unrolled GEO' format, or by adding
Save "t2.geo_unrolled";

// It can also be achieved with `gmsh t2.geo -0' on the command line.
//
// With the OpenCASCADE geometry kernel, unrolling the geometry can be achieved
// with `File->Export' by selecting the `OpenCASCADE BRep' format, or by adding
//
//   Save "file.brep";
//
// in the script. (OpenCASCADE geometries can also be exported to STEP.)
//
// It is important to note that Gmsh never translates geometry data into a
// common representation: all the operations on a geometrical entity are
// performed natively with the associated geometry kernel. Consequently, one
// cannot export a geometry constructed with the built-in kernel as an
// OpenCASCADE BRep file; or export an OpenCASCADE model as an Unrolled GEO
// file.
