#pragma once

// Initial refinement level.
const int initlevel = 6;

// Maximum refinement level.
const int maxlevel = 8;

// Diameter of sphere in domain..
const double D = 1.0 [1];

// Inflow velocity.
const double U0 = 1.0;

// Inflow Reynolds number.
const double Re = 300.0;

// Field to compute the viscosity from Reynolds number.
face vector muv[];

// Global log file.
static FILE * fplog;
