#pragma once

// Inflow B.C. on left side.
u.n[left]  = dirichlet(U0);
p[left]    = neumann(0.0);
pf[left]   = neumann(0.0);

// Outflow B.C. in the right side.
u.n[right] = neumann(0.0);
p[right]   = dirichlet(0.0);
pf[right]  = dirichlet(0.0);


// No slip B.C. over embedded sphere.
u.n[embed] = dirichlet(0.0);
u.t[embed] = dirichlet(0.0);
u.r[embed] = dirichlet(0.0);

event init (t = 0)
{
    // Open log file.
    fplog = fopen("logfile.log", "w");

    // Initially refine only in a sphere, slightly larger than the embedded.
    refine(x*x + y*y + z*z < sq(1.2*D/2.0) && level < maxlevel);

    // We define the unit sphere.
    solid(cs, fs, x*x + y*y + z*z - sq(D/2.0));

    // Set initial horizontal velocity to inflow value outside the sphere.
    foreach()
    {
        u.x[] = cs[] ? U0 : 0.;
    }
}
