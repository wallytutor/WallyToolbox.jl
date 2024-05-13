// -----------------------------------------------------------------------------
//
//  Helper for making flaps in the system
//
// -----------------------------------------------------------------------------

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

    // Ends.
    Transfinite Curve{l0} = 4;
    Transfinite Curve{l2} = 4;

    // Main direction.
    Transfinite Curve{l1} = 50 * dims[1];
    Transfinite Curve{l3} = 50 * dims[1];

    // XXX: Fixed size/thickness values.
    idf = NEXTFIELD++;
    Field[idf] = BoundaryLayer;
    Field[idf].CurvesList = {l0, l1, l2, l3};
    Field[idf].Quads = 1;
    Field[idf].Ratio = 1.2;
    Field[idf].Size = 0.001;
    Field[idf].Thickness = 0.025;
    BoundaryLayer Field = idf;
Return

// -----------------------------------------------------------------------------
//
//  EOF
//
// -----------------------------------------------------------------------------
