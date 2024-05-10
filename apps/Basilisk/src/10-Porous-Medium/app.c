// app.c
#define LEVEL 8

#include "grid/multigrid3D.h"
#include "navier-stokes/centered.h"
#include "navier-stokes/perfs.h"
#include "lambda2.h"
#include "view.h"
#include "maxruntime.h"

#include "project-base.h"
#include "project-init.h"
#include "project-post.h"
#include "project-exec.h"

int main(int argc, char * argv[])
{
    maxruntime(&argc, argv);

    if (argc > 1)
    {
        maxlevel = atoi(argv[1]);
    }

    // Domain is a cube of side 2pi.
    L0 = 2.0 * pi [1];

    // Domain is triply-periodic.
    foreach_dimension()
    {
        periodic (right);
    }

    // Transfer data for names in solver.
    mu = muc;
    a = av;
    N = 1 << maxlevel;

    run();
}
