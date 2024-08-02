# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField

MGLEVEL = SU2ConfigField(
    "MGLEVEL", 0,
    "Multi-grid levels (0 = no multi-grid).")

MGCYCLE = SU2ConfigField(
    "MGCYCLE", "V_CYCLE",
    "Multi-grid cycle.",
    options=("V_CYCLE", "W_CYCLE", "FULLMG_CYCLE"))

MG_PRE_SMOOTH = SU2ConfigField(
    "MG_PRE_SMOOTH", (1, 2, 3, 3),
    "Multi-grid pre-smoothing level.")

MG_POST_SMOOTH = SU2ConfigField(
    "MG_POST_SMOOTH", (0, 0, 0, 0),
    "Multi-grid post-smoothing level.")

MG_CORRECTION_SMOOTH = SU2ConfigField(
    "MG_CORRECTION_SMOOTH", (0, 0, 0, 0),
    "Jacobi implicit smoothing of the correction.")

MG_DAMP_RESTRICTION = SU2ConfigField(
    "MG_DAMP_RESTRICTION", 0.75,
    "Damping factor for the residual restriction.")

MG_DAMP_PROLONGATION = SU2ConfigField(
    "MG_DAMP_PROLONGATION", 0.75,
    "Damping factor for the correction prolongation.")
