// t8.geo

Include "shared/t1_mini.geo";
Include "shared/view1.pos"; // 0
Include "shared/view1.pos"; // 1
Include "shared/view4.pos"; // 2, 3

General.Trackball = 0;
General.RotationX = 0;
General.RotationY = 0;
General.RotationZ = 0;
General.Color.Background = White;
General.Color.Foreground = Black;
General.Color.Text = Black;
General.Orthographic = 0;
General.Axes = 0;
General.SmallAxes = 0;

// We also set some options for each post-processing view:
v0 = PostProcessing.NbViews-4;
v1 = v0+1;
v2 = v0+2;
v3 = v0+3;

View[v0].IntervalsType = 2;
View[v0].OffsetZ = 0.05;
View[v0].RaiseZ = 0;
View[v0].Light = 1;
View[v0].ShowScale = 0;
View[v0].SmoothNormals = 1;

View[v1].IntervalsType = 1;
View[v1].ColorTable = { Green, Blue };
View[v1].NbIso = 10;
View[v1].ShowScale = 0;

View[v2].Name = "Test...";
View[v2].Axes = 1;
View[v2].Color.Axes = Black;
View[v2].IntervalsType = 2;
View[v2].Type = 2;
View[v2].IntervalsType = 2;
View[v2].AutoPosition = 0;
View[v2].PositionX = 85;
View[v2].PositionY = 50;
View[v2].Width = 200;
View[v2].Height = 130;

View[v3].Visible = 0;


// A script can be used to build much more complex animations:

t = 0; // Initial step

// Loop on num from 1 to 3
For num In {1:3}
  // Set time step
  View[v0].TimeStep = t;
  View[v1].TimeStep = t;
  View[v2].TimeStep = t;
  View[v3].TimeStep = t;

  t = (View[v0].TimeStep < View[v0].NbTimeStep-1) ? t+1 : 0; // Increment

  View[v0].RaiseZ += 0.01/View[v0].Max * t; // Raise view v0

  If (num == 3)
    // Resize the graphics when num == 3, to create 640x480 frames
    General.GraphicsWidth = General.MenuWidth + 640;
    General.GraphicsHeight = 480;
  EndIf

  frames = 50;

  // Loop on num2 from 1 to frames
  For num2 In {1:frames}
    // Incrementally rotate the scene
    General.RotationX += 10;
    General.RotationY = General.RotationX / 3;
    General.RotationZ += 0.1;

    // Sleep for 0.01 second
    Sleep 0.01;

    // Draw the scene (one could use `DrawForceChanged' instead to force the
    // reconstruction of the vertex arrays, e.g. if changing element clipping)
    Draw;

    If (num == 3)
      // Uncomment the following lines to save each frame to an image file (the
      // `Print' command saves the graphical window; the `Sprintf' function
      // permits to create the file names on the fly):
      // Print Sprintf("t8-%g.gif", num2);
      // Print Sprintf("t8-%g.ppm", num2);
      // Print Sprintf("t8-%g.jpg", num2);
    EndIf
  EndFor

  If(num == 3)
    // Make a system call to generate a movie.
    // System "ffmpeg -i t8-%d.jpg t8.mpg"
  EndIf
EndFor
