// Experimentation with boundary layer.
SetFactory("OpenCASCADE");
General.Axes = 3;

Point(1) = {0.00, 0.00, 0};
Point(2) = {2.00, 0.20, 0};
Point(3) = {2.00, 0.80, 0};
Point(4) = {0.00, 1.00, 0};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Circle(5) = {0.5, 0.5, 0, 0.1, 0, 2*Pi};

Curve Loop(1) = {1, 2, 3, 4};
Curve Loop(2) = {5};
Plane Surface(1) = {1, 2};

Transfinite Curve {1, 3} = 30;
Transfinite Curve {2, 4} = 30;
Transfinite Curve {5} = 30;
Recombine Surface {1};

Field[0] = BoundaryLayer;
Field[0].CurvesList = {1, 3, 5};
Field[0].PointsList = {1, 2, 3, 4};
Field[0].AnisoMax = 1.0e+10;
Field[0].Quads = 1;
Field[0].IntersectMetrics = 1;
Field[0].Ratio = 1.2;
Field[0].Size = 0.005;
Field[0].SizeFar = 0.05;
Field[0].Thickness = 0.05;
BoundaryLayer Field = 0;

Mesh.Algorithm = 8;
Mesh.MeshSizeMax = 0.05;
Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeExtendFromBoundary = 1;
Mesh.MeshSizeFromCurvature = 0;
Mesh.Smoothing = 100;

Mesh 2;
RefineMesh;

// Other fields from BoundaryLayer:
// Field[0].Beta = 1.01;
// Field[0].BetaLaw = 0;
// Field[0].NbLayers = 5;
// Field[0].ExcludedSurfacesList = {};
// Field[0].FanPointsList = {};
// Field[0].FanPointsSizesList = {};
// Field[0].SizesList = {};
