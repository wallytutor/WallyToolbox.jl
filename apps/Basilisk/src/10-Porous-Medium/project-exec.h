#pragma once

// Compute average velocity and add the corresponding linear forcing term.
event acceleration(i++)
{
    double a = 0.1;
    coord ubar;

    foreach_dimension()
    {
        stats s = statsf(u.x);
        ubar.x = s.sum / s.volume;
    }

    foreach_face()
    {
        av.x[] += a*((u.x[] + u.x[-1])/2. - ubar.x);
    }
}

// Optional grid adaptation routine.
#if TREE
event adapt(i++)
{
    double uemax = 0.2 * normf(u.x).avg;
    adapt_wavelet((scalar *){u}, (double[]){uemax, uemax, uemax}, maxlevel);
}
#endif
