// sample.geo

Point(1) = {0.000, 0.000, 0};
Point(2) = {0.004, 0.000, 0};
Point(3) = {0.004, 0.004, 0};
Point(4) = {0.000, 0.004, 0};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Curve Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};

Transfinite Curve {1, 3} = 40 Using Bump 0.3;
Transfinite Curve {2, 4} = 2;

Transfinite Surface {1};
Recombine Surface {1};

Physical Curve(1) = {1, 3};
Physical Curve(2) = {2, 4};
Physical Surface(1) = {1};
