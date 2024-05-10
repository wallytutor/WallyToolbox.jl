#pragma once

event movies (t = 30; t += 0.25; t <= 60)
{
    scalar l2[], vyz[];

    foreach()
    {
        vyz[] = (u.y[0,0,1] - u.y[0,0,-1]) - (u.z[0,1] - u.z[0,-1]);
        vyz[] /= (2.0*Delta);
    }

    lambda2(u, l2);

    view(
        fov = 11.44,
        quat = {0.072072, 0.245086, 0.303106, 0.918076},
        tx = -0.307321,
        ty = 0.22653,
        bg = {1, 1, 1},
        width = 802,
        height = 634
    );

    draw_vof("cs", "fs");
    isosurface("l2", -0.01, color = "vyz", min = -1, max = 1,
               linear = true, map = cool_warm);

    save("movie.mp4");
}
