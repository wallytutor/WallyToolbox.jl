#pragma once

// Evolution of viscous dissipation, kinetic energy, an microscale Re.
event logfile (i++; t <= 300)
{
    coord ubar;
    double ke = 0.0, vd = 0.0, vol = 0.0;

    foreach_dimension() 
    {
        stats s = statsf(u.x);
        ubar.x = s.sum / s.volume;
    }
  
    foreach(reduction(+:ke) reduction(+:vd) reduction(+:vol))
    {
        vol += dv();

        foreach_dimension()
        {
            // mean fluctuating kinetic energy
            ke += dv()*sq(u.x[] - ubar.x);

            // viscous dissipation
            vd += dv()*(sq(u.x[1] - u.x[-1]) +
                sq(u.x[0,1] - u.x[0,-1]) +
                sq(u.x[0,0,1] - u.x[0,0,-1]))/sq(2.0*Delta);
        }
    }

    ke /= 2.*vol;
    vd *= MU/vol;

    if (i == 0)
    {
        fprintf (stderr, "t dissipation energy Reynolds\n");
    }

    fprintf (stderr, "%g %g %g %g\n",
        t, vd, ke, 2./3.*ke/MU*sqrt(15.*MU/vd));
}

// Generate a movie of the vortices. 
event movie (t += 0.25; t <= 150)
{
    view(
        fov = 44,
        camera = "iso",
        ty = 0.2,
        width = 600,
        height = 600,
        bg = {1,1,1},
        samples = 4
    );
    clear();

    squares("u.y", linear = true);
    squares("u.x", linear = true, n = {1,0,0});

    scalar omega[];
    vorticity(u, omega);
    squares("omega", linear = true, n = {0,1,0});

    scalar l2[];
    lambda2(u, l2);
    isosurface("l2", -1);

    save("movie.mp4");
}
