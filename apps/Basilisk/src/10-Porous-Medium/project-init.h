#pragma once

event init (i = 0)
{
    double u0 = 1.0, k = 1.0;

    // The initial condition is "ABC" flow. 
    if (!restore (file = "restart"))
    {
        foreach()
        {
            u.x[] = u0 * (cos(k * y) + sin(k * z));
            u.y[] = u0 * (sin(k * x) + cos(k * z));
            u.z[] = u0 * (cos(k * x) + sin(k * y));
        }
    }
}
