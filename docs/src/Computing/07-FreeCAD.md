# FreeCAD

[FreeCAD](https://www.freecad.org/index.php) is an open source design tool that with its 1.0 release confirmed itself as the leading in the domain. This document aim at maintaining a tutorial of its use for computational mechanics engineers and those in related fields.

## Installation

Go to the [download page](https://www.freecad.org/downloads.php) and get the version for your operating system. For Windows users it is simpler to get the portable version (7z) as it requires no administration rights. Under Linux only [AppImage](https://appimage.org/) bundles are available; for installing them, please check the ideas provided somewhere [around here](02-General-Computing-Skills.md). More about installation in the [FreeCAD Wiki](https://wiki.freecad.org/Installing_additional_components).

Upon first launch the application will ask for some trivial user preferences setup.

## General usage

- Pressing *Esc* or *right-click* exits a selected tool. Do not press several times to stay in the environment; if accidentally left, click the element on tree and *Edit sketch*.

## Tutorials

The supported tutorials are provided in [this wiki](https://wiki.freecad.org/Tutorials). It must be noted that not all of them are conceived with a recent version of FreeCAD and *none* (Dec 20th 2024) with the first major release. In what follows we try to focus in part conception for mechanical design, what may include sketching, part conception, and detailed drawings.

### Basic part design

Based on [this tutorial](https://wiki.freecad.org/Basic_Part_Design_Tutorial_019). Follow these global steps:

- Launch *Part Design Workbench* and create a new part and save it.

Step 1: *base sketch*

- Click *Create sketch* icon (XY), it will later handle part creation automatically.
- Click the *Create rectangle* tool and draw a rectangle around origin.
- Select the *Constrain horizontal distance* and add a `length` named constraint.
- Select the *Symmetrical constraint* with respect to the horizontal line.
- Select the *Vertical distance constraint* and add a `width` named constraint.
- Leave the sketch workbench and rename the `Sketch000`.

Step 2: *top profile sketch*

- For side view creation use *Create sketch* (YZ).
- Use *Create polyline* to freehand draw the rough shape of the profile.
- Make sure vertical and horizontal lines are properly auto-constrained.
- Select the top vertical point and Y-axis and *Constraint coincident*.
- Select the bottom vertical point and the origin and *Constraint horizontal*.
- Select the top line and add a *Constrain horizontal distance* to set its length.
- Select the vertical line and add a *Constrain vertical distance* to set its length.
- Select the bottom line and add a *Constrain horizontal distance* to set its length; in this case an expression will be used: set it to `<<Sketch000>>.Constraints.width`.
- Leave the sketch workbench.

Step 3: *padding of top profile*

- Select `<<Sketch001>>` and click on *Pad*; again use an expression to set the value of length to `<<Sketch000>>.Constraints.length` (notice the use of the names of step 1 again) and make it symmetric to plane.

Step 4: *corner cutouts*

Step 5: