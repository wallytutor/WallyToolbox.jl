# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField

MESH_FILENAME = SU2ConfigField(
    "MESH_FILENAME", "NONE",
    "Mesh input file.")

MESH_FORMAT = SU2ConfigField(
    "MESH_FORMAT", "SU2",
    "Mesh input file format.",
    options=("SU2", "CGNS"))

MESH_OUT_FILENAME = SU2ConfigField(
    "MESH_OUT_FILENAME", "mesh_out.su2",
    "Mesh output file.")

SOLUTION_FILENAME = SU2ConfigField(
    "SOLUTION_FILENAME", "solution_flow.dat",
    "Restart flow input file.")

SOLUTION_ADJ_FILENAME = SU2ConfigField(
    "SOLUTION_ADJ_FILENAME", "solution_adj.dat",
    "Restart adjoint input file.")

TABULAR_FORMAT = SU2ConfigField(
    "TABULAR_FORMAT", "CSV",
    "Output tabular file format.",
    options=("CSV", "TECPLOT"))

OUTPUT_FILES = SU2ConfigField(
    "OUTPUT_FILES", ("RESTART_ASCII", "PARAVIEW", "SURFACE_PARAVIEW"),
    "Files to output.",
    options=(
        "CGNS",
        "CSV",
        "PARAVIEW",
        "PARAVIEW_ASCII",
        "PARAVIEW_LEGACY",
        "PARAVIEW_MULTIBLOCK",
        "RESTART",
        "RESTART_ASCII",
        "STL",
        "STL_BINARY",
        "SURFACE_CSV",
        "SURFACE_PARAVIEW",
        "SURFACE_PARAVIEW_ASCII",
        "SURFACE_PARAVIEW_LEGACY",
        "SURFACE_TECPLOT",
        "SURFACE_TECPLOT_ASCII",
        "TECPLOT",
        "TECPLOT_ASCII"
    ),
    many_options=True)

CONV_FILENAME = SU2ConfigField(
    "CONV_FILENAME", "history",
    "Output file convergence history (w/o extension).")

BREAKDOWN_FILENAME = SU2ConfigField(
    "BREAKDOWN_FILENAME", "forces_breakdown.dat",
    "Output file with the forces breakdown.")

RESTART_FILENAME = SU2ConfigField(
    "RESTART_FILENAME", "restart_flow.dat",
    "Output file restart flow.")

RESTART_ADJ_FILENAME = SU2ConfigField(
    "RESTART_ADJ_FILENAME", "restart_adj.dat",
    "Output file restart adjoint.")

VOLUME_FILENAME = SU2ConfigField(
    "VOLUME_FILENAME", "flow",
    "Output file flow (w/o extension) variables.")

VOLUME_ADJ_FILENAME = SU2ConfigField(
    "VOLUME_ADJ_FILENAME", "adjoint",
    "Output file adjoint (w/o extension) variables.")

VALUE_OBJFUNC_FILENAME = SU2ConfigField(
    "VALUE_OBJFUNC_FILENAME", "of_eval.dat",
    "Output Objective function.")

GRAD_OBJFUNC_FILENAME = SU2ConfigField(
    "GRAD_OBJFUNC_FILENAME", "of_grad.dat",
    "Output objective function gradient (using continuous adjoint).")

SURFACE_FILENAME = SU2ConfigField(
    "SURFACE_FILENAME", "surface_flow",
    "Output file surface flow coefficient (w/o extension).")

SURFACE_ADJ_FILENAME = SU2ConfigField(
    "SURFACE_ADJ_FILENAME", "surface_adjoint",
    "Output file surface adjoint coefficient (w/o extension).")

READ_BINARY_RESTART = SU2ConfigField(
    "READ_BINARY_RESTART", "YES",
    "Read binary restart files.",
    options=("YES", "NO"))

REORIENT_ELEMENTS = SU2ConfigField(
    "REORIENT_ELEMENTS", "YES",
    "Reorient elements based on potential negative volumes.",
    options=("YES", "NO"))
