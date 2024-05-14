// -----------------------------------------------------------------------------
//
//  Geometry assembly
//
// -----------------------------------------------------------------------------

General.BackgroundGradient = 0;
General.Color.Background = {220, 220, 240};
General.Color.Foreground = White;
General.Color.Text = White;
General.Color.Axes = White;
General.Color.SmallAxes = White;
General.Axes = 0;
General.SmallAxes = 1;
Geometry.OldNewReg = 0;

// -----------------------------------------------------------------------------
//
//  Shared parameters for project
//
// -----------------------------------------------------------------------------

// Box width [m].
L = 2.0;

// Box depth [m]
D = 4.0;

// Coordinate of outlet first point on the left [m].
d = 2.0;

// Height of lower part of the box [m]. 
hl = 0.75;

// Height of upper part of the box [m]. 
ht = 2.05;

// Diameters of pipes [m].
d0 = 0.75;  // Air feed
d1 = 0.21;  // First bottom extraction
d2 = 0.27;  // Second bottom extraction

// Equivalent length of pipe openings in 2D [m].
e0 = Pi*d0^2/(4*L);
e1 = Pi*d1^2/(4*L);
e2 = Pi*d2^2/(4*L);

// Plane perpendicular to air feed attack angle [rad].
theta = Atan(1198/720);
cost = Cos(theta);
sint = Sin(theta);

// Distance below feed after correcting diameter to equivalent length [m].
df = 0.08 + 0.5*(d0-e0);

// Thickness of fins [m].
finthick = 0.010;

// First cell thickness over shell [m]
shellbl = 0.003;

// -----------------------------------------------------------------------------
//
//  Geometry of outer shell of system
//
// -----------------------------------------------------------------------------

// Origin in the lower-left corner of box.
p01 = newp; Point(p01)  = {0, 0, 0};

// Base line with extraction points.
p02 = newp; Point(p02)  = {1.038 - 0.5*e1, 0, 0};
p03 = newp; Point(p03)  = {1.038 + 0.5*e1, 0, 0};
p04 = newp; Point(p04)  = {3.010 - 0.5*e2, 0, 0};
p05 = newp; Point(p05)  = {3.010 + 0.5*e2, 0, 0};

// Last point of baseline is computed from angle and depth.
p06 = newp; Point(p06)  = {D - hl/Tan(42*Pi/180), 0, 0};

// Wall at box depth.
p07 = newp; Point(p07) = {D,      hl,          0};
p08 = newp; Point(p08) = {D,      hl+ht,       0};

// Outlet, outlet imbrication, and top wall.
p09 = newp; Point(p09) = {d,      hl+ht,       0};
p10 = newp; Point(p10) = {d,      hl+ht-0.052, 0};
p11 = newp; Point(p11) = {d-1.28, hl+1.198,    0};

// Particle feed requires some trigonometry... I hope not to need to recompute
// this otherwise a draft will be required to get the angles...
dy12 = df*sint + 0.5*cost + e0*sint;
p12 = newp; Point(p12) = {dy12/Tan(theta), hl+dy12, 0};
p13 = newp; Point(p13) = {(df+e0)*cost-0.5*sint, hl+(df+e0)*sint + 0.5*cost, 0};
p14 = newp; Point(p14) = {df*cost-0.5*sint, hl+df*sint+0.5*cost, 0};
p15 = newp; Point(p15) = {df*cost, hl+df*sint, 0};

// Closure point just above origin.
p16 = newp; Point(p16) = {0, 0.75, 0};

// Join all points.
l01 = newl; Line(l01) = {p01, p02};
l02 = newl; Line(l02) = {p02, p03};
l03 = newl; Line(l03) = {p03, p04};
l04 = newl; Line(l04) = {p04, p05};
l05 = newl; Line(l05) = {p05, p06};
l06 = newl; Line(l06) = {p06, p07};
l07 = newl; Line(l07) = {p07, p08};
l08 = newl; Line(l08) = {p08, p09};
l09 = newl; Line(l09) = {p09, p10};
l10 = newl; Line(l10) = {p10, p11};
l11 = newl; Line(l11) = {p11, p12};
l12 = newl; Line(l12) = {p12, p13};
l13 = newl; Line(l13) = {p13, p14};
l14 = newl; Line(l14) = {p14, p15};
l15 = newl; Line(l15) = {p15, p16};
l16 = newl; Line(l16) = {p16, p01};
l17 = newl; Line(l17) = {p12, p15};

// Distinguish shell from the rest.
Color Orange{ Curve{ l01, l02, l03, l04, l05, l06, l07, l08, l09,
                     l10, l11, l12, l13, l14, l15, l16, l17}; }

// Enclose region with a curve loop.
theloops[0] = newll;
Curve Loop(theloops[0]) = {
    l01, l02, l03, l04, l05, l06, l07, l08, l09,
    l10, l11, l17, l15, l16};

// Add region to be fully structured.
clk = newll;  Curve Loop(clk) = {l12, l13, l14, -l17};

// -----------------------------------------------------------------------------
//
//  Creation of fins
//
// -----------------------------------------------------------------------------

idl = 1;
idk = 1;

Macro MakeFin
    // Rename some globals for local use.
    t = finthick;
    href = hl;
    lref = D;

    dy = (y1 - y0);
    dx = (x1 - x0);
    alpha = Atan(dy / dx);
    
    // Coordinates in drawing are not all provided the same way, for now I will
    // keep the user-defined length, but in the future the computation of each
    // fin barycenter needs to be improved by better coordinates.
    // Printf("L = %.5f", Sqrt(dx^2+dy^2));
    
    x = lref-0.5*(x0+x1);
    y = href+0.5*(y0+y1);

    dlx1 = 0.5*(l) * Cos(alpha);
    dly1 = 0.5*(l) * Sin(alpha);
    dtx1 = 0.5*(t) * Sin(alpha);
    dty1 = 0.5*(t) * Cos(alpha);

    xf1 = x + dlx1;
    yf1 = y - dly1;
    xh1 = x - dlx1;
    yh1 = y + dly1;

    p01 = newp; Point(p01) = {xf1 - dtx1, yf1 - dty1, 0};
    p02 = newp; Point(p02) = {xf1 + dtx1, yf1 + dty1, 0};
    p03 = newp; Point(p03) = {xh1 + dtx1, yh1 + dty1, 0};
    p04 = newp; Point(p04) = {xh1 - dtx1, yh1 - dty1, 0};

    l01 = newl; Line(l01) = {p01, p02};
    l02 = newl; Line(l02) = {p02, p03};
    l03 = newl; Line(l03) = {p03, p04};
    l04 = newl; Line(l04) = {p04, p01};

    // Store CL for later subtraction of main surface.
    theloops[idl] = newcl;
    Curve Loop(theloops[idl]) = {l01, l02, l03, l04};

    firstcell = 0.001;
    farcell = 0.05;
    blthick = 0.01;

    Field[idk+0] = Distance;
    Field[idk+0].CurvesList = {l01, l02, l03, l04};
    Field[idk+0].Sampling = 10;

    Field[idk+1] = Threshold;
    Field[idk+1].InField = idk+0;
    Field[idk+1].SizeMin = 10*firstcell;
    Field[idk+1].SizeMax = farcell;
    Field[idk+1].DistMin = blthick;
    Field[idk+1].DistMax = 0.5;

    Field[idk+2] = BoundaryLayer;
    Field[idk+2].AnisoMax = 0.1;
    Field[idk+2].Quads = 1;
    Field[idk+2].Thickness = blthick;
    Field[idk+2].CurvesList = {l01, l02, l03, l04};
    Field[idk+2].Ratio = 1.2;
    Field[idk+2].Size = firstcell;
    Field[idk+2].SizeFar = 10*firstcell;
    Field[idk+2].IntersectMetrics = 1;
    
    Background Field = idk+1;
    BoundaryLayer Field = idk+2;

    // Increment counter.
    idl += 1;
    idk += 3;
Return

// -----------------------------------------------------------------------------

l = 0.550;
y0 = 0.654;
y1 = 1.075;
x0 = 2.808;
x1 = 3.161;
Call MakeFin;

l = 0.730;
y0 = 0.000;
y1 = 0.546;
x0 = 1.882;
x1 = 2.371;
Call MakeFin;

l = 0.600;
y0 = 0.141;
y1 = 0.441;
x0 = 0.705;
x1 = 1.225;
Call MakeFin;

// -----------------------------------------------------------------------------
//
//  Put it all together
//
// -----------------------------------------------------------------------------

ps1 = news; Plane Surface(ps1) = {theloops[]};
ps2 = news; Plane Surface(ps2) = {clk};

// Transfinite Curve{2, 4} = 6;
Transfinite Curve{8} = 120;
Transfinite Curve{12, -14} = 25;
Transfinite Curve{15} = 25;
Transfinite Curve{16} = 40;
Transfinite Curve{13, -17} = 25;
Transfinite Surface{ps2};
Recombine Surface {ps1, ps2};

Compound Curve{1:7, 14, 15, 16};
Compound Curve{9:12};
Compound Surface{ps1, ps2};

// -----------------------------------------------------------------------------
//
//  Boundary layer
//
// -----------------------------------------------------------------------------

Field[idk] = BoundaryLayer;
Field[idk].CurvesList = {1:7, 9, 10, 11, 12};
Field[idk].PointsList= {1, 8, 13, 14};    
Field[idk].AnisoMax = 0.1;
Field[idk].Quads = 1;
Field[idk].Thickness = 0.02;
Field[idk].Ratio = 1.1;
Field[idk].Size = shellbl;
Field[idk].SizeFar = 0.05;
Field[idk].IntersectMetrics = 1;
BoundaryLayer Field = idk;

// Field[5] = BoundaryLayer;
// Field[5].AnisoMax = 0.1;
// Field[5].Quads = 1;
// Field[5].Thickness = 0.05;
// Field[5].CurvesList = {9, 10};
// Field[5].PointsList= {9, 11};    
// Field[5].Ratio = 1.1;
// Field[5].Size = shellbl;
// Field[5].SizeFar = 0.05;
// Field[5].IntersectMetrics = 1;
// BoundaryLayer Field = 5;

// -----------------------------------------------------------------------------
//
//  Patch naming
//
// -----------------------------------------------------------------------------

// Extrude {0, 0, 0.2} { Surface{ps1, ps2}; Layers{1}; Recombine; }

// Physical Volume("volume") = {1, 2};
// Physical Surface("frontAndBack") = {1, 2, 30, 36};
// Physical Surface("inlet") = {33};
// Physical Surface("outlet") = {11};
// Physical Surface("flap1") = {18, 19, 20, 21};
// Physical Surface("flap2") = {22, 23, 24, 25};
// Physical Surface("flap3") = {26, 27, 28, 29};
// Physical Surface("shell") = {4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 16, 17, 32, 34};

// -----------------------------------------------------------------------------
//
//  Meshing
//
// -----------------------------------------------------------------------------

// Mesh.MeshSizeExtendFromBoundary = 0;
// Mesh.MeshSizeFromPoints = 0;
// Mesh.MeshSizeFromCurvature = 0;

Mesh.SaveAll = 1;
Mesh.MshFileVersion = 2.2;
Mesh.MeshSizeFactor = 0.5;
Mesh.MeshSizeMin = 0.0005;
Mesh.MeshSizeMax = 0.10;
Mesh.Algorithm = 5;
Mesh.Smoothing = 200;

// Mesh 1;
// RefineMesh;

// Save "geometry.unv";
// Save "geometry.msh";

// -----------------------------------------------------------------------------
//
//  EOF
//
// -----------------------------------------------------------------------------
