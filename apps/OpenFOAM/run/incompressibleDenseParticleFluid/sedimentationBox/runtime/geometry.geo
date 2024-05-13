// geometry.geo

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

Mesh.SaveAll = 0;
Mesh.MshFileVersion = 2.2;

Point(1) = {0.0, 0.0, 0};
Point(2) = {0.1, 0.0, 0};
Point(3) = {0.1, 1.0, 0};
Point(4) = {0.0, 1.0, 0};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Curve Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};

Transfinite Line {1, -3} = 20;
Transfinite Line {2, -4} = 200;
Transfinite Surface {1};
Recombine Surface{1};

Extrude {0, 0, 0.1} { Surface{1}; Layers{1}; Recombine; }

Physical Volume("volume") = {1};
Physical Surface("frontAndBack") = {1, 7};
Physical Surface("walls") = {3, 4, 5, 6};
