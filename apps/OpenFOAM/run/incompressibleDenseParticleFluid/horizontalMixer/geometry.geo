// -----------------------------------------------------------------------------
//
//  Geometry assembly
//
// -----------------------------------------------------------------------------

General.AbortOnError = 1;
General.BackgroundGradient = 0;
General.Color.Background = {0, 0, 0};
General.Color.Foreground = White;
General.Color.Text = White;
General.Color.Axes = White;
General.Color.SmallAxes = White;
General.Axes = 0;
General.SmallAxes = 1;
Geometry.OldNewReg = 0;
Geometry.Surfaces = 1;

OPENFOAM = 1;

RECOMBINESURFACE = 0;

// -----------------------------------------------------------------------------
//
//  Main coordinates
//
// -----------------------------------------------------------------------------

x0 = 0.0;
x1 = 0.2;
x2 = 1.5;
x3 = 1.8;
x4 = 2.0;

y0 = 0.0;
y1 = 0.5;
y2 = 1.5;
y3 = 1.2;
y4 = 1.5;
y5 = 1.8;

rc = 0.05;

// -----------------------------------------------------------------------------
//
//  Points, lines, and plane
//
// -----------------------------------------------------------------------------

Point(1)  = {x0,    y2, 0};
Point(2)  = {x1,    y2, 0};
Point(3)  = {x1,    y0+rc, 0};
Point(4)  = {x1+rc, y0+rc, 0};
Point(5)  = {x1+rc, y0, 0};
Point(6)  = {x2,    y0, 0};
Point(7)  = {x4,    y1, 0};
Point(8)  = {x4,    y4, 0};
Point(9)  = {x3,    y4, 0};
Point(10) = {x3,    y3, 0};
Point(11) = {x0,    y5, 0};

Line(1)   = {1, 2};
Line(2)   = {2, 3};
Circle(3) = {3, 4, 5};
Line(4)   = {5, 6};
Line(5)   = {6, 7};
Line(6)   = {7, 8};
Line(7)   = {8, 9};
Line(8)   = {9, 10};
Line(9)   = {10, 11};
Line(10)  = {11, 1};

Curve Loop(1) = {1:10};
Plane Surface(1) = {1};

// -----------------------------------------------------------------------------
//
//  Structuring mesh
//
// -----------------------------------------------------------------------------

// Refine bottom radius
Transfinite Curve(3) = 5;

// Recombine if required
If (RECOMBINESURFACE)
    Recombine Surface {1};
EndIf

// -----------------------------------------------------------------------------
//
//  Boundary modeling
//
// -----------------------------------------------------------------------------

no = 1;
Field[no] = BoundaryLayer;
Field[no].CurvesList = {1:6, 8:9};
Field[no].PointsList = {1, 8, 9, 11};
Field[no].Quads = 1;
Field[no].Ratio = 1.2;
Field[no].Size = 0.003;
Field[no].Thickness = 0.05;
BoundaryLayer Field = no;

// -----------------------------------------------------------------------------
//
//  Preparing for OpenFOAM
//
// -----------------------------------------------------------------------------

If (OPENFOAM)
    Extrude {0, 0, 0.01} { Surface{1}; Layers{1}; Recombine; }

    Physical Volume("volume") = {1};
    Physical Surface("frontAndBack") = {1, 13};
    Physical Surface("inlet") = {12};
    Physical Surface("outlet") = {9};
    Physical Surface("walls") = {3:8, 10:11};
EndIf

// -----------------------------------------------------------------------------
//
//  Meshing controls
//
// -----------------------------------------------------------------------------

Mesh.SaveAll = 0;
Mesh.MshFileVersion = 2.2;

Mesh.Algorithm = 8;
Mesh.MeshSizeMax = 0.05;
Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeFromCurvature = 0;
Mesh.MeshSizeExtendFromBoundary = 1;
Mesh.Smoothing = 100;

Mesh 3;
Save "geometry.msh";

// -----------------------------------------------------------------------------
//
//  EOF
//
// -----------------------------------------------------------------------------
