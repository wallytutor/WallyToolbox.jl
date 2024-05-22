// Packing of *particles* in a regular grid.

SetFactory("OpenCASCADE");

scale = 1.0e-06;
R = 100 * scale;
// R = 0.005;
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
    inter = BooleanIntersection{ Surface{s}; }{ Surface{particle}; Delete; };
    // Printf("%g", inter);
EndFor

n = 1;
For particle In {2:Nx*Ny}
    n = BooleanUnion{ Surface{n}; Delete; }{ Surface{particle}; Delete; };
EndFor

final = BooleanIntersection{ Surface{1}; Delete; }{ Surface{31}; Delete; };

Transfinite Curve {1, 3} = 10 * Ny;
Transfinite Curve {2, 4} = 10 * Nx;
// Recombine Surface {final};

Physical Surface(1) = {final};

Physical Curve(1001) = {1};
Physical Curve(1002) = {3};
Physical Curve(1003) = {2, 4};

// TODO find a reliable way to automate this!
Physical Curve(1004) = {
     5, 6, 7, 8, 9, 10,
    11, 12, 13, 14, 15,
    16, 17, 18, 19, 20,
    21, 22, 23, 24, 25,
    26, 27, 28, 29, 30,
    31, 32, 33, 34, 35,
    36, 37, 38, 39, 40,
    41, 42, 43, 44, 45,
    46, 47, 48, 49, 50,
    51, 52, 53, 54, 55,
    56, 57, 58, 59, 60,
    61, 62, 63, 64, 65,
    66, 67, 68, 69, 70,
    71, 72, 73, 74, 75,
    76, 77, 78, 79, 80,
    81, 82, 83, 84
};
