// -----------------------------------------------------------------
// pipe.geo
// -----------------------------------------------------------------

General.FltkTheme = "plastic";
General.TextEditor = "nvim %s";

// -----------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------

// Total tube length.
length = 1.0;

// Reactor tube radius.
radius = 0.005;

// Wedge angle.
theta = 1 * Pi / 180;

// Cell size over length.
size_length = 0.0010;

// Cell characteristic size over radius.
size_radius = 0.0002;

// Number of cells over length.
nl = 1 + Ceil(length / size_length);

// Number of cells over radius.
nr = 1 + Ceil(radius / size_radius);

// Progression factor over length.
prl = 1.0;

// Progression factor over radius.
prr = 0.95;

// -----------------------------------------------------------------
// Construction
// -----------------------------------------------------------------

// Points over axis.
Point(1) = {0, 0, 0};
Point(2) = {length, 0, 0};

// Points over radius.
Point(3) = {length, radius, 0};
Point(4) = {0, radius, 0};

// Get lines.
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

// Join path.
Line Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};

// Structure on radius.
Transfinite Line {-4, 2} = nr Using Progression prr;

// Structure on length.
Transfinite Line {1, -3} = nl Using Progression prl;

// Structure surfaces.
Transfinite Surface {1};
Recombine Surface {1};

// Rotate before extrusion.
Rotate {{1, 0, 0}, {0, 0, 0}, -Pi/72} { Surface{1}; }

// Rotate-extrude and add inner volume.
ext[] = Extrude {{1, 0, 0}, {0, 0, 0}, Pi/36} { 
  Surface{1}; Layers{1}; Recombine; };
Physical Volume("volume") = { ext[1] };

// Add physical boundaries.
Physical Surface("front") = {1};
Physical Surface("back") = {21};
Physical Surface("walls") = {17};
Physical Surface("inlet") = {20};
Physical Surface("outlet") = {13};

// -----------------------------------------------------------------
//                               EOF
// -----------------------------------------------------------------