#pragma once

event properties (i++)
{
    foreach_face()
    {
        muv.x[] = fm.x[]*D*U0/Re;
    }
}

event logfile (i++)
{
    fprintf(fplog, "%d %g %d %d\n", i, t, mgp.i, mgu.i);
}

event adapt (i++)
{
    astats s = adapt_wavelet(
        {cs,u}, 
        (double[]){0.01, 0.02, 0.02, 0.02}, // FIXME: these are not seen....
        maxlevel, 4
    );

    fprintf (fplog, "# refined %d cells, coarsened %d cells\n", s.nf, s.nc);
}
