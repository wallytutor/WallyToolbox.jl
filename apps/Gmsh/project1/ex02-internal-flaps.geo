// Experimentation with internal flaps.
SetFactory("OpenCASCADE");
General.Axes = 3;

Point(1) = {0.00, 0.00, 0};
Point(2) = {2.00, 0.25, 0};
Point(3) = {2.00, 0.75, 0};
Point(4) = {0.00, 1.00, 0};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Circle(5) = {0.5, 0.5, 0, 0.1, 0, 2*Pi};

c0 = newl; Curve Loop(c0) = {1, 2, 3, 4};
c1 = newl; Curve Loop(c1) = {5};
theloops[0] = c0;
theloops[1] = c1;

FIRSTLAYER = 0.001;
MAXSIZE = 0.015;

NEXTFIELD = 0;
NEXTFLAP = #theloops[];

Macro AddInternalFlap
    // Arguments:
    // - xc    : (x, y) coordinates of central point [m] (0, 1)
    // - dims  : thickness, width [m] (2, 3)
    // - angle : clockwise angle with horizontal [°] (4)
    xc[] = {pars[0], pars[1]};
    dims[] = {pars[2], pars[3]};
    angle = pars[4];

    theta = Pi/2 * (1 - angle/90);
    gamma = Pi/2 - theta;

    reccord = 0.5 * Hypot(dims[0], dims[1]);
    alpha = theta + Atan(dims[1] / dims[0]);

    x0[] = {xc[0] - reccord * Cos(alpha), xc[1] - reccord * Sin(alpha)};
    x1[] = {x0[0] + dims[0] * Cos(theta), x0[1] + dims[0] * Sin(theta)};
    x2[] = {x1[0] - dims[1] * Cos(gamma), x1[1] + dims[1] * Sin(gamma)};
    x3[] = {x2[0] - dims[0] * Cos(theta), x2[1] - dims[0] * Sin(theta)};

    Printf("*** Flap No. %d", NEXTFLAP);
    Printf("Center ---> (%.3f, %.3f)", xc[0], xc[1]);
    Printf("    x0 ---> (%.3f, %.3f)", x0[0], x0[1]);
    Printf("    x1 ---> (%.3f, %.3f)", x1[0], x1[1]);
    Printf("    x2 ---> (%.3f, %.3f)", x2[0], x2[1]);
    Printf("    x3 ---> (%.3f, %.3f)", x3[0], x3[1]);

    p0 = newp; Point(p0) = {x0[0], x0[1], 0};
    p1 = newp; Point(p1) = {x1[0], x1[1], 0};
    p2 = newp; Point(p2) = {x2[0], x2[1], 0};
    p3 = newp; Point(p3) = {x3[0], x3[1], 0};

    l0 = newl; Line(l0) = {p0, p1};
    l1 = newl; Line(l1) = {p1, p2};
    l2 = newl; Line(l2) = {p2, p3};
    l3 = newl; Line(l3) = {p3, p0};

    ck = newl; Curve Loop(ck) = {l0, l1, l2, l3};
    theloops[NEXTFLAP++] = ck;

    idf = NEXTFIELD++;
    Field[idf] = BoundaryLayer;
    Field[idf].CurvesList = {l0, l1, l2, l3};
    Field[idf].AnisoMax = 1.0e+10;
    Field[idf].Quads = 1;
    Field[idf].IntersectMetrics = 1;
    Field[idf].Ratio = 1.2;
    Field[idf].Size = 4*FIRSTLAYER;
    Field[idf].SizeFar = MAXSIZE;
    Field[idf].Thickness = 40*FIRSTLAYER;
    
    BoundaryLayer Field = idf+0;
Return

pars[] = {1.0, 0.5, 0.1, 0.50, 90.0};
Call AddInternalFlap;

pars[] = {1.5, 0.5, 0.1, 0.40, 90.0};
Call AddInternalFlap;

Plane Surface(1) = {theloops[]};

Transfinite Curve {1, 3} = 90;
Transfinite Curve {2, 4} = 50;
Transfinite Curve {5} = 20;
Recombine Surface {1};

Field[666] = BoundaryLayer;
Field[666].CurvesList = {1, 3, 5};
Field[666].PointsList = {1, 2, 3, 4};
Field[666].AnisoMax = 1.0;
Field[666].Quads = 1;
Field[666].IntersectMetrics = 1;
Field[666].Ratio = 1.2;
Field[666].Size = FIRSTLAYER;
Field[666].SizeFar = MAXSIZE;
Field[666].Thickness = 60*FIRSTLAYER;
BoundaryLayer Field = 666;

Extrude {0, 0, 0.1} { Surface{1}; Layers{1}; Recombine; }

Physical Volume("volume") = {1};
Physical Surface("frontAndBack") = {1, 15};
Physical Surface("inlet") = {5};
Physical Surface("outlet") = {3};
Physical Surface("shell") = {2, 4};
Physical Surface("cylinder") = {6};
Physical Surface("flap1") = {7, 8, 9, 10};
Physical Surface("flap2") = {11, 12, 13, 14};

Mesh.Algorithm = 8;
Mesh.MeshSizeMax = MAXSIZE;
Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeExtendFromBoundary = 1;
Mesh.MeshSizeFromCurvature = 0;
Mesh.Smoothing = 100;
// Mesh.SaveAll = 1;
// Mesh.MshFileVersion = 2.2;
// Mesh 3;

// Save "geometry.msh2";
