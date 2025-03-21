///////////////////////////////////////////////////////////////////
// Slab inside large block.
///////////////////////////////////////////////////////////////////

SetFactory("OpenCASCADE");

General.BackgroundGradient = 0;
General.Color.Background = {200, 220, 240};
General.Color.Foreground = White;
General.Color.Text = White;
General.Color.Axes = White;
General.Color.SmallAxes = White;
General.Axes = 0;
General.SmallAxes = 1;
Geometry.OldNewReg = 0;

///////////////////////////////////////////////////////////////////
// Provided values
///////////////////////////////////////////////////////////////////

// Width of semi-domain (symmetry at x=0).
L = 1.0;

// Height of domain.
H = 1.0;

// Depth of slab.
d = 0.15;

// Width in semi-domain of slab w.r.t. its depth.
n = 3;

///////////////////////////////////////////////////////////////////
// Computed values
///////////////////////////////////////////////////////////////////

x0 = 0.0;
x1 = n * d;
x2 = L;

y0 = 0.0;
y1 = H - d;
y2 = H;

///////////////////////////////////////////////////////////////////
// Points
///////////////////////////////////////////////////////////////////

Point(1) = {x0, y0, 0.0};
Point(2) = {x2, y0, 0.0};
Point(3) = {x2, y2, 0.0};
Point(4) = {x1, y2, 0.0};
Point(5) = {x1, y1, 0.0};
Point(6) = {x0, y1, 0.0};
Point(7) = {x0, y2, 0.0};

///////////////////////////////////////////////////////////////////
// Lines
///////////////////////////////////////////////////////////////////

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 6};
Line(6) = {6, 1};
Line(7) = {6, 7};
Line(8) = {7, 4};

///////////////////////////////////////////////////////////////////
// Surfaces
///////////////////////////////////////////////////////////////////

Curve Loop(1) = {6, 1, 2, 3, 4, 5};
Plane Surface(1) = {1};

Curve Loop(2) = {5, 7, 8, 4};
Plane Surface(2) = {2};

///////////////////////////////////////////////////////////////////
// Structured Mesh
///////////////////////////////////////////////////////////////////

Transfinite Curve {4} = (100 * d + 1) Using Progression 1.08;
Transfinite Curve {-7} = (100 * d + 1) Using Progression 1.08;

Transfinite Curve {3} = (100 * n * d + 1);
Transfinite Curve {5} = (100 * n * d + 1);
Transfinite Curve {8} = (100 * n * d + 1);

Transfinite Surface {2};
Recombine Surface {2};
Recombine Surface {1};

MeshSize {1, 2, 3, 6} = 0.05;

Coherence;

///////////////////////////////////////////////////////////////////
// Physics
///////////////////////////////////////////////////////////////////

// Physical Curve("hot", 1) = {8};
// Physical Curve("sym_slab", 2) = {7};
// Physical Curve("sym_block", 3) = {6};
// Physical Curve("bottom_block", 4) = {1};
// Physical Curve("side_block", 5) = {2};
// Physical Curve("top_block", 6) = {3};
// Physical Surface("slab", 7) = {2};
// Physical Surface("block", 8) = {1};

Physical Curve(1) = {8};
Physical Curve(2) = {7};
Physical Curve(3) = {6};
Physical Curve(4) = {1};
Physical Curve(5) = {2};
Physical Curve(6) = {3};
Physical Surface(1) = {2};
Physical Surface(2) = {1};

///////////////////////////////////////////////////////////////////
// Meshing
///////////////////////////////////////////////////////////////////

Mesh 2;

RefineMesh;

Save "structured.unv";

///////////////////////////////////////////////////////////////////
// EOF
///////////////////////////////////////////////////////////////////