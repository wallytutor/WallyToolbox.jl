// ---------------------------------------------------------------------------
// Packing of *particles* in a regular grid.
// ---------------------------------------------------------------------------

SetFactory("OpenCASCADE");

scale = 1.0e-06;
R = 100 * scale;

f = 0.95;

Nx = 6;
Ny = 4;

// TODO automate from R and f.
DeltaMax = R / 6;

// ---------------------------------------------------------------------------
// CONFIGURE MESH
// ---------------------------------------------------------------------------

// Mesh.MeshSizeExtendFromBoundary = 1;
// Mesh.MeshSizeFromPoints = 1;
// Mesh.MeshSizeFromCurvature = 1;
// Mesh.Algorithm = 8;
Mesh.MeshSizeMax = DeltaMax;

// ---------------------------------------------------------------------------
// GENERATE GRID
// ---------------------------------------------------------------------------

D = 2 * R;
Lx = (Nx - 1) * f * D;
Ly = (Ny - 1) * f * D;

For ny In {0:Ny-1}
    y = (0 + ny * f) * D;

    For nx In {0:Nx-1}
        x = (0 + nx * f) * D;

        c = newc;
        l = newcl;
        s = news;

        Circle(c) = {x, y, 0, R, 0, 2*Pi};
        Curve Loop(l) = {c};
        Plane Surface(s) = {l};
    EndFor
EndFor

// ---------------------------------------------------------------------------
// MANAGE OPERATIONS
// ---------------------------------------------------------------------------

s = news;
Rectangle(s) = {0.0, 0.0, 0, Lx, Ly, 0};

For particle In {1:Nx*Ny}
    inter = BooleanIntersection{ Surface{s}; }{ Surface{particle}; Delete; };
    // Printf("%g", inter);
EndFor

n = 1;
For particle In {2:Nx*Ny}
    n = BooleanUnion{ Surface{n}; Delete; }{ Surface{particle}; Delete; };
EndFor

final = BooleanIntersection{ Surface{1}; Delete; }{ Surface{Nx*Ny+1}; Delete; };

// ---------------------------------------------------------------------------
// TUNE MESH
// ---------------------------------------------------------------------------

Transfinite Curve {1, 3} = 10 * Ny;
Transfinite Curve {2, 4} = 10 * Nx;

// TODO find a reliable way to automate this!
Physical Surface(1) = {final};
Physical Curve(1001) = {1};
Physical Curve(1002) = {3};
Physical Curve(1003) = {2, 4};
Physical Curve(1004) = {5:(Nx-1)*(Ny-1)*4+4};

// Keep track for post-processing.
Printf("Length ..... %.6e", Lx);
Printf("Height ..... %.6e", Ly);

// ---------------------------------------------------------------------------
// EOF
// ---------------------------------------------------------------------------