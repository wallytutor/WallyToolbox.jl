// Packing of *particles* in a regular grid.

SetFactory("OpenCASCADE");

R = 0.50;
f = 0.98;

Nx = 6;
Ny = 5;

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

s = news;
Rectangle(s) = {0.0, 0.0, 0, Lx, Ly, 0};

For particle In {1:Nx*Ny}
    BooleanIntersection{ Surface{s}; }{ Surface{particle}; Delete; }
EndFor

n = 1;
For s In {2:Nx*Ny}
    n = BooleanUnion{ Surface{n}; Delete; }{ Surface{s}; Delete; };
EndFor

BooleanIntersection{ Surface{1}; Delete; }{ Surface{s}; Delete; };
