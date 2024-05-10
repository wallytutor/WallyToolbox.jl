// app.c
#include "grid/octree.h"
#include "embed.h"
#include "navier-stokes/centered.h"
#include "navier-stokes/perfs.h"
#include "view.h"
#include "lambda2.h"

#include "project-base.h"
#include "project-init.h"
#include "project-post.h"
#include "project-exec.h"

int main() {
    // Initialize the grid at a coarse level.
    init_grid(1 << initlevel);

    // Make domain sufficiently larger than sphere.
    size(16.0*D);

    // Move the origin so that the sphere is not too close to the boundaries.
    origin(-3.0*D, -L0/2.0, -L0/2.0);

    // Initialize viscosity of solver.
    mu = muv;
    
    // Run main solver.
    run();
}

