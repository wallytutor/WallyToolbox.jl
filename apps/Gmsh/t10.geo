// t10.geo

// Let's create a simple rectangular geometry
lc = 0.15;
Point(1) = {0.0, 0.0, 0, lc};
Point(2) = {1.0, 0.0, 0, lc};
Point(3) = {1.0, 1.0, 0, lc};
Point(4) = {0.0, 1.0, 0, lc};
Point(5) = {0.2, 0.5, 0, lc};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Curve Loop(5) = {1,2,3,4};
Plane Surface(6) = {5};

// Testing with quadrangles.
// Recombine Surface{6};

// Say we would like to obtain mesh elements with size lc/30 near curve 2 and
// point 5, and size lc elsewhere. To achieve this, we can use two fields:
// "Distance", and "Threshold". We first define a Distance field (`Field[1]') on
// points 5 and on curve 2. This field returns the distance to point 5 and to
// (100 equidistant points on) curve 2.
Field[1] = Distance;
Field[1].PointsList = {5};
Field[1].CurvesList = {2};
Field[1].Sampling = 100;

// We then define a `Threshold' field, which uses the return value of the
// `Distance' field 1 in order to define a simple change in element size
// depending on the computed distances
//
// SizeMax -                     /------------------
//                              /
//                             /
//                            /
// SizeMin -o----------------/
//          |                |    |
//        Point         DistMin  DistMax
Field[2] = Threshold;
Field[2].InField = 1;
Field[2].SizeMin = lc / 30;
Field[2].SizeMax = lc;
Field[2].DistMin = 0.15;
Field[2].DistMax = 0.5;

// To apply the background field "2" we could simply to the following, but
// something more elaborate will be done in what follows.
// Background Field = 2;

// Say we want to modulate the mesh element sizes using a mathematical function
// of the spatial coordinates. We can do this with the MathEval field:
Field[3] = MathEval;
Field[3].F = "Cos(4*Pi*x) * Sin(4*Pi*y) / 10 + 0.101";

// We could also combine MathEval with values coming from other fields. For
// example, let's define a `Distance' field around point 1
Field[4] = Distance;
Field[4].PointsList = {1};

// We can then create a `MathEval' field with a function that depends on the
// return value of the `Distance' field 4, i.e., depending on the distance to
// point 1 (here using a cubic law, with minimum element size = lc / 100)
Field[5] = MathEval;
Field[5].F = Sprintf("F4^3 + %g", lc / 100);

// We could also use a `Box' field to impose a step change in element sizes
// inside a box
Field[6] = Box;
Field[6].VIn = lc / 15;
Field[6].VOut = lc;
Field[6].XMin = 0.3;
Field[6].XMax = 0.6;
Field[6].YMin = 0.3;
Field[6].YMax = 0.6;
Field[6].Thickness = 0.3;

// Many other types of fields are available: see the reference manual for a
// complete list. You can also create fields directly in the graphical user
// interface by selecting `Define->Size fields' in the `Mesh' module.

// Let's use the minimum of all the fields as the background mesh size field
Field[7] = Min;
Field[7].FieldsList = {2, 3, 5, 6};
Background Field = 7;

// To determine the size of mesh elements, Gmsh locally computes the minimum of
//
// 1) the size of the model bounding box;
// 2) if `Mesh.MeshSizeFromPoints' is set, the mesh size specified at
//    geometrical points;
// 3) if `Mesh.MeshSizeFromCurvature' is positive, the mesh size based on
//    curvature (the value specifying the number of elements per 2 * pi rad);
// 4) the background mesh size field;
// 5) any per-entity mesh size constraint.
//
// This value is then constrained in the interval [`Mesh.MeshSizeMin',
// `Mesh.MeshSizeMax'] and multiplied by `Mesh.MeshSizeFactor'. In addition,
// boundary mesh sizes are interpolated inside surfaces and/or volumes depending
// on the value of `Mesh.MeshSizeExtendFromBoundary' (which is set by default).
//
// When the element size is fully specified by a mesh size field (as it is in
// this example), it is thus often desirable to set the following. This will
// prevent over-refinement due to small mesh sizes on the boundary.
Mesh.MeshSizeExtendFromBoundary = 0;
Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeFromCurvature = 0;

// The "Delaunay" algorithm (Mesh.Algorithm = 5) will handle complex mesh size
// fields better:
Mesh.Algorithm = 5;
