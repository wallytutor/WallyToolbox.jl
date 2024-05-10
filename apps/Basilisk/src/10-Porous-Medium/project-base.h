#pragma once

// Constant viscosity.
const double MU = 0.01;
const face vector muc[] = {MU, MU, MU};

// We need to store the variable forcing term.
face vector av[];

// Maximum grid refinement level.
int maxlevel = 7;
