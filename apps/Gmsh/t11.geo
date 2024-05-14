// t11.geo

Point(1) = {-1.25, -.5, 0};
Point(2) = {1.25, -.5, 0};
Point(3) = {1.25, 1.25, 0};
Point(4) = {-1.25, 1.25, 0};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Curve Loop(4) = {1, 2, 3, 4};
Plane Surface(100) = {4};

Field[1] = MathEval;
Field[1].F = "0.01*(1.0+30.*(y-x*x)*(y-x*x) + (1-x)*(1-x))";
Background Field = 1;

// To generate quadrangles instead of triangles, we can simply add
Recombine Surface{100};

// Testing "Frontal-Delaunay for quads"
Mesh.Algorithm = 8;

// The default recombination algorithm might leave some triangles in the mesh,
// if recombining all the triangles leads to badly shaped quads. In such cases,
// to generate full-quad meshes, you can either subdivide the resulting hybrid
// mesh (with Mesh.SubdivisionAlgorithm = 1), or use the full-quad recombination
// algorithm, which will automatically perform a coarser mesh followed by
// recombination, smoothing and subdivision. Uncomment the following line to try
// the full-quad algorithm:
Mesh.RecombinationAlgorithm = 2; // or 3

// Note that you could also apply the recombination algorithm and/or the
// subdivision step explicitly after meshing, as follows:
// Mesh 2;
// RecombineMesh;
// Mesh.SubdivisionAlgorithm = 1;
// RefineMesh;
