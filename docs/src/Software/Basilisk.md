# Basilisk

The goal of this material is to provide support to teaching introductory computational fluid mechanics with aid of [Basilisk](http://basilisk.fr/). The studies are based on commented tutorials and a documentation guide extending what is already provided with the package.

Before going over the tutorials, you need some [C knowledge](https://www.geeksforgeeks.org/c-programming-language/?ref=shm). In the future I intend to provide a synthetic version applied to Basilisk students only. For now, the referred one is pretty good.
## First steps

The source code for the studies is provided [here](https://github.com/wallytutor/Basilisk). The repository keeps a copy of Basilisk at a version that will work with all modified tutorials. It may be eventually updated, but in that case functioning of tutorials will be tested. You will need to clone it then following the steps to [compile Basilisk](http://basilisk.fr/src/INSTALL) before starting. After building Basilisk, instead of adding variables to your environment, consider sourcing them temporarily with help of `source activate.sh` using the provided script.

All tutorials are found under [src](https://github.com/wallytutor/Basilisk/tree/main/src). Just enter the tutorials you want to follow using the command line and run `make`. This not only will compile, but will also run and post-process results.

## Project management

Although Basilisk is a very interesting dialect of C, its documentation is still old-fashioned and lack some structuration. Also sample programs are not written to be easily managed and extended for use in variant cases. Here we propose a structure for creating better projects with Basilisk:

- A Basilisk project lives in its own folder: one executable means one directory.

- A simpler `Makefile` than Basilisk's default one is used for project building.

- The main file is called `app.c` and contains a very simple structure as provided in the dummy listing bellow. All the logic of a project, *i.e. the events*, is implemented in separate header files that are included after Basilisk includes.

```c
// Definitions
#define LEVEL 7
#define ...

// Basilisk includes.
#include "grid/multigrid.h"
#include "run.h"
#include ...  

// Project includes.
#include "project-base.h"
#include "project-init.h"
#include "project-post.h"
#include "project-exec.h"

int main() {
	init_grid(1 << LEVEL);
	...
	run();
}
```

## Parallel computing

Currently I have not tried Basilisk in parallel (actually I did so a few years back but don't really remember the steps). Since there is no dedicated tutorial for going parallel, here are the notes I am taking for writing something in that sense:

- Tutorial [isotropic.c](http://basilisk.fr/src/examples/isotropic.c) has notes on how to run parallel in some of its parent universities supercomputers. Probably some steps there might be recycled here.

---
## Introductory tutorials

### Basilisk basics

| Reference | [Tutorial](http://basilisk.fr/Tutorial)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Code      | 01-Tutorial-Basics                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Notes     | Basilisk is a conceptual solver for investigating problems in a Cartesian domain.<br><br>Different steps of the simulations are set by `event`'s, which use a specific syntax do indicate whether they depend on a time or iteration condition. These steps might include setup of initial conditions, storage of intermediate results or solution, grid refinement, etc.<br><br>For iterating over arrays Basilisk provides a `foreach()`loop extending the C-language.<br><br>A standard `Makefile` is provided by Basilisk for managing common workflows.<br><br>Check the [tips](http://basilisk.fr/src/Tips). |

### Game of life

| Reference | [Conway’s game of life](http://basilisk.fr/src/examples/life.c) |
| ---- | ---- |
| Code | 02-Game-of-life |
| Notes | A simple implementation of [Conway's game of life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) to get used with syntax. |

### Brusselator

| Reference | [Coupled reaction-diffusion equations](http://basilisk.fr/src/examples/brusselator.c)                                                                                                                                                                                                                                                                                                                                                                                                 |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Code      | 03-Brusselator                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| Notes     | Solves the 2D [Brusselator](https://en.wikipedia.org/wiki/Brusselator), a theoretical autocatalytic reaction diffusion system. The set of parameters used in the study for the stable Turin points where the ones proposed by ([[@Pena2001a]]). **Interesting** material for preparing courses extending this to other oscillating systems can be found [here](https://web.archive.org/web/20170909182522/http://www.idea.wsu.edu/OscilChem/#Brusselator%20Model). |

### Ginzburg-Landau

| Reference | [The complex Ginzburg-Landau equation](http://basilisk.fr/src/examples/ginzburg-landau.c) |
| ---- | ---- |
| Code | 04-Ginzburg-Landau |
| Notes | Solves the complex [Ginzburg-Landau equation](https://en.wikipedia.org/wiki/Ginzburg%E2%80%93Landau_equation) describing the nonlinear evolution of disturbances near the transition from a stable to unstable state of a system. Additional materials are provided [here](https://codeinthehole.com/tutorial/index.html). It would be a **good project** to include the term $\alpha$ in the equation and the Laplacian term that goes with it. |

### Distance field

| Reference | [Distance field computation from a 3D model](http://basilisk.fr/src/examples/distance.c) |
| ---- | ---- |
| Code | 05-Distance-Field |
| Notes | This can be seen as a particular case of pre-/post-processing. It can prove useful when initializing domains with scanned surfaces in STL or other compatible format. Additional [steps](http://basilisk.fr/src/gl/INSTALL) must be taken for compilation with rendering (modifications to Makefile). Iteration over dimensions can be done with `foreach_dimension()`. |

### Wavelet transform

| Reference | [Wavelet transforms and filtering](http://basilisk.fr/src/examples/wavelet.c)                                                                                                                                |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Code      | 06-Wavelet-Transform                                                                                                                                                                                         |
| Notes     | Provides a tutorial on wavelet transform and associated filters. It is presented as the basis to understand mesh adaptation in Basilisk. Recommended reading of ([[@Sweldens1998a]]). |

## Navier-Stokes equation

### Decaying turbulence

| Reference | [Decaying two-dimensional turbulence](http://basilisk.fr/src/examples/turbulence.c) |
| ---- | ---- |
| Code | 07-Decaying-Turbulence |
| Notes | For solving Euler equation with vorticity-stream formulation one uses header file [navier-stokes/stream.h](http://basilisk.fr/src/navier-stokes/stream.h). The examples makes a first usage of dimensional quantities for vorticity initialization. |

### Vortex street

| Reference | [Bénard–von Kármán Vortex Street for flow around a cylinder](http://basilisk.fr/src/examples/karman.c) |
| ---- | ---- |
| Code | 08-Vortex-Street |
| Notes | Solves the flow around a solid object using the [navier-stokes/centered.h](http://basilisk.fr/src/navier-stokes/centered.h) solver and introduced the use of passive scalars (tracer). Notice we modify `L0`, which among many other *magic* variables is defined in [common.h](http://basilisk.fr/src/common.h). Illustrates the use of `solid` and `intersection` to accomplish complex domains.  |

### Vortex shedding

| Reference | [Vortex shedding behind a sphere](http://basilisk.fr/src/examples/sphere.c)                                                                                                                                                                  |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Code      | 09-Vortex-Shedding                                                                                                                                                                                                                           |
| Notes     | Solution of Navier-Stokes equations in an adaptive domain embedding an sphere. Vortex detection is made with functionalities from [lambda2.h](http://basilisk.fr/src/lambda2.h) implemented following ([[@Jeong1995a]]). |

### Porous medium

| Reference | [Stokes flow through a complex 3D porous medium](http://basilisk.fr/src/examples/porous3D.c) |
| ---- | ---- |
| Code | 10-Porous-Medium |
| Notes |  |

### Periodic box

| Reference | [Forced isotropic turbulence in a triply-periodic box](http://basilisk.fr/src/examples/isotropic.c) |
| ---- | ---- |
| Code | 11-Periodic-Box |
| Notes |  |

## Two-phase flows

### Pulsed atomization
| Reference | [Atomisation of a pulsed liquid jet](http://basilisk.fr/src/examples/atomisation.c) |
| ---- | ---- |
| Code | 12-Pulsed-Atomisation |
| Notes |  |

### Bubble rising
| Reference | [Bubble rising in a large tank](http://basilisk.fr/src/examples/bubble.c) |
| ---- | ---- |
| Code | 13-Bubble-Rising |
| Notes |  |

### Rotating cylinder
| Reference | [Flow in a rotating bottom-driven cylindrical container](http://basilisk.fr/src/examples/yang.c) |
| ---- | ---- |
| Code | 14-Rotating-Cylinder |
| Notes |  |

### Moving Tangaroa
| Reference | [Two-phase flow around RV Tangaroa](http://basilisk.fr/src/examples/tangaroa.c) |
| ---- | ---- |
| Code | 15-Moving-Tangaroa |
| Notes |  |

## Geophysical applications

### Indian Tsunami

| Reference | [The 2004 Indian Ocean tsunami](http://basilisk.fr/src/examples/tsunami.c) |
| ---- | ---- |
| Code | 16-Indian-Tsunami |
| Notes |  |

### Tohoku Tsunami

| Reference | [The 2011 Tohoku tsunami](http://basilisk.fr/src/examples/tohoku.c) |
| ---- | ---- |
| Code | 17-Tohoku-Tsunami |
| Notes |  |

### Train of Solitons

| Reference | [Breakup of a rectangular perturbation into a train of solitons](http://basilisk.fr/src/examples/madsen.c) |
| ---- | ---- |
| Code | 18-Train-of-Solitons |
| Notes |  |

### Lee Waves

| Reference | [Tidally-induced internal lee waves](http://basilisk.fr/src/examples/lee.c) |
| ---- | ---- |
| Code | 19-Lee-Waves |
| Notes |  |

### Ellipsoidal Shoal

| Reference | [Periodic wave propagation over an ellipsoidal shoal](http://basilisk.fr/src/examples/shoal.c) |
| ---- | ---- |
| Code | 20-Ellipsoidal-Shoal |
| Notes |  |

### Ellipsoidal Shoal Multilayer

| Reference | [Periodic wave propagation over an ellipsoidal shoal (multilayer)](http://basilisk.fr/src/examples/shoal-ml.c) |
| ---- | ---- |
| Code | 21-Ellipsoidal-Shoal-Multilayer |
| Notes | Check for source code in current version. |

### Stokes Wave

| Reference | [3D breaking Stokes wave (multilayer solver)](http://basilisk.fr/src/examples/breaking.c) |
| ---- | ---- |
| Code | 22-Stokes-Wave |
| Notes |  |

### Transcritical Flow

| Reference | [Transcritical flow over a bump](http://basilisk.fr/src/examples/gaussian-ns.c) |
| ---- | ---- |
| Code | 23-Transcritical-Flow |
| Notes |  |

### Shock Instability

| Reference | [A Shallow Water Analogue for the Standing Accretion Shock Instability](http://basilisk.fr/src/examples/swasi.c) |
| ---- | ---- |
| Code | 24-Shock-Instability |
| Notes |  |

## Python interface

### Basic usage

| Reference | [Python interface](http://basilisk.fr/src/examples/example.py) |
| ---- | ---- |
| Code | 25-Python-Interface |
| Notes |  |

### Poisson equation

| Reference | [Poisson problem with Python](http://basilisk.fr/src/examples/poisson.py) |
| ---- | ---- |
| Code | 26-Python-Poisson |
| Notes |  |

---

## Built-in solvers

Basic component solvers:
- [advection.h](http://basilisk.fr/src/advection.h)
- [diffusion.h](http://basilisk.fr/src/diffusion.h)
- [poisson.h](http://basilisk.fr/src/poisson.h)

 It is upon these that the Navier-Stokes equation can be assembled in:

| Header                                                                      | Description                                                                                                                                                                                                                                                                                                                                                                                   |
| --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [navier-stokes/stream.h](http://basilisk.fr/src/navier-stokes/stream.h)     | Solves a 2D incompressible, constant density, constant viscosity Navier-Stokes equation formulated in the vorticity $\omega$. This is and advection-diffusion equation solved with a flux-based advection scheme in [advection.h](http://basilisk.fr/src/advection.h). Given its form, the stream function $\psi$ is solver through the [poisson.h](http://basilisk.fr/src/poisson.h) solver. |
| [navier-stokes/centered.h](http://basilisk.fr/src/navier-stokes/centered.h) |                                                                                                                                                                                                                                                                                                                                                                                               |
| [navier-stokes/perfs.h](http://basilisk.fr/src/navier-stokes/perfs.h)       | Not a solver by itself, it supports other headers under the Navier-Stokes family to follow performance during solution.                                                                                                                                                                                                                                                                       |
 
Other equations:
- [saint-venant.h](http://basilisk.fr/src/saint-venant.h)
## Headers files

| File                                              | Usage                                                                      |
| ------------------------------------------------- | -------------------------------------------------------------------------- |
| [common.h](http://basilisk.fr/src/common.h)       |                                                                            |
| [distance.h](http://basilisk.fr/src/distance.h)   |                                                                            |
| [embed.h](http://basilisk.fr/src/embed.h)         | Allow the creation of general shape boundary conditions inside the domain. |
| [fractions.h](http://basilisk.fr/src/fractions.h) |                                                                            |
| [lambda2.h](http://basilisk.fr/src/lambda2.h)     | Detection of vortex using the criteria by ([[@Jeong1995a]])                |
| [run.h](http://basilisk.fr/src/run.h)             | A generic time loop which executes until termination (to be avoided!).     |
| [tracer.h](http://basilisk.fr/src/tracer.h)       | Provides an event to integrate the advection of tracer elements.           |
| [utils.h](http://basilisk.fr/src/utils.h)         |                                                                            |
| [view.h](http://basilisk.fr/src/view.h)           |                                                                            |


| File                                                        | Usage |
| ----------------------------------------------------------- | ----- |
| [grid/cartesian.h](http://basilisk.fr/src/grid/cartesian.h) |       |
| [grid/multigrid.h](http://basilisk.fr/src/grid/multigrid.h) |       |
| [grid/octree.h](http://basilisk.fr/src/grid/octree.h)       |       |
| [grid/bitree.h](http://basilisk.fr/src/grid/bitree.h)       |       |

## Data types

- `scalar`
- `vector`
- `face`
- [`msgstats`](http://basilisk.fr/src/poisson.h#mgstats) convergence statistics of (multigrid?) solver.

## Functions

| Function | Definition | Uses |
| ---- | ---- | ---- |
| `origin` | [common.h](http://basilisk.fr/src/common.h) | Set the origin of cartesian system. |
| `init_grid` | [`grid/`](http://basilisk.fr/src/grid/) (overloaded) | Level of refinement (size) of initial grid. |
| `size` |  |  |
| `periodic` |  | Set periodic boundary conditions. |
| `statsf` | [utils.h](http://basilisk.fr/src/utils.h) | Retrieve statistics of a scalar field. |
| `output_ppm` | [output.h](http://basilisk.fr/src/output.h) | Generate a image and video output. |
| `adapt_wavelet` | [grid/tree-common.h](http://basilisk.fr/src/grid/tree-common.h) | Adaptive grid refinement routine. |
| `run` | [run.h](http://basilisk.fr/src/run.h) (overloaded) | Generic time loop for events execution. |
| `noise` |  | Generate random noise in $[-1; 1]$. |
| `swap` |  | Swap values of two scalar arrays. |
| `input_stl` | [distance.h](http://basilisk.fr/src/distance.h#input_stl) | Read an STL file as an array of triplets. |
| `bounding_box` | [distance.h](http://basilisk.fr/src/distance.h#bounding_box) | Determines the bounding box of inputs (segments or triangles). |
| `distance` | [distance.h](http://basilisk.fr/src/distance.h#distance) | Distance to coordinate. |
| `view` | [draw.h](http://basilisk.fr/src/draw.h#view) | Setup of viewing (camera) parameters. |
| `isosurface` | [draw.h](http://basilisk.fr/src/draw.h#isosurface) | Displays an isosurface of a field. |
| `draw_vof` | [draw.h](http://basilisk.fr/src/draw.h#draw_vof) | Display VOF reconstructed interfaces. |
| `clear` | [draw.h](http://basilisk.fr/src/draw.h#clear) | Removes previous objects. |
| `save` | [view.h](http://basilisk.fr/src/view.h#save) | Dumps image(s) to file. |
| `refine_biquadradic` | [grid/multigrid-common.h](http://basilisk.fr/src/grid/multigrid-common.h#refine_biquadratic) |  |
| `wavelet` | [grid/multigrid-common.h](http://basilisk.fr/src/grid/multigrid-common.h#wavelet) |  |
| `inverse_wavelet` | [grid/multigrid-common.h](http://basilisk.fr/src/grid/multigrid-common.h#inverse_wavelet) |  |
| `boundary_level` |  |  |
| `unrefine` |  |  |
| `vorticity` | [utils.h](http://basilisk.fr/src/utils.h#vorticity) | Computes the vorticity from a velocity field. |
