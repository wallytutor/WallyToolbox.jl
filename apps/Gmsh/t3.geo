// t3.geo

// Including a file is equivalent to copy-pasting its contents:
Include "t1.geo";

// Use `Extrude` with `Layers` to also extrude the mesh.
h = 0.1;
Extrude {0, 0, h} {
  Surface{s1}; Layers{ {8, 2}, {0.5, 1} };
}

// Extrusion-rotation is also possible:
Extrude { {0, 1, 0} , {-0.1, 0, 0.1} , -Pi/2 } {
  Surface{28}; Layers{7}; Recombine;
}

// Define a ONELAB parameter.
DefineConstant[ angle = {90, Min 0, Max 120, Step 1,
                         Name "Parameters/Twisting angle"} ];

// Perform another extrusion using the parameter. Here we retrieve the volume
// number programmatically by using the return value (a list) of the `Extrude'
// command. This list contains the "top" of the extruded surface (in `out[0]'),
// the newly created volume (in `out[1]') and the tags of the lateral surfaces
// (in `out[2]', `out[3]', ...).
out[] = Extrude { {-2*h,0,0}, {1,0,0} , {0,0.15,0.25} , angle * Pi / 180 } {
  Surface{50}; Layers{10}; Recombine;
};

// We can then define a new physical volume (with tag 101) to group all the
// elementary volumes:
Physical Volume(101) = {1, 2, out[1]};

// All interactive options are accessible in Gmsh's scripting language:
General.BackgroundGradient = 0;
General.Color.Text = White;
Geometry.PointNumbers = 1;
Geometry.Color.Points = Orange;
Geometry.Color.Surfaces = Geometry.Color.Points;
Mesh.Color.Points = {255, 0, 0};

// You can use the `Help->Current Options and Workspace' menu to see the current
// values of all options. To save all the options in a file, use
// `File->Export->Gmsh Options'. To associate the current options with the
// current file use `File->Save Model Options'. To save the current options for
// all future Gmsh sessions use `File->Save Options As Default'.
