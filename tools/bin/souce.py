# -*- coding: utf-8 -*-
""" Helper to generate a better `source.bat`. """
from pathlib import Path

basepaths = {
    "MYENV_BLENDER":      "blender-4.1.1-windows-x64",
    "MYENV_DUALSPHYSICS": "DualSPHysics_v5.2.2",
    "MYENV_ELMER":        "ElmerFEM-gui-mpi-Windows-AMD64",
    "MYENV_FREECAD":      "FreeCAD_0.21.2-2023-12-17-conda-Windows-x86_64-py310",
    "MYENV_GIT":          "PortableGit-2.45.1",
    "MYENV_GMSH":         "gmsh-4.13.0-Windows64-sdk",
    "MYENV_GNUPLOT":      "gp600-win64-mingw",
    "MYENV_JABREF":       "JabRef-5.13-portable_windows",
    "MYENV_JULIA":        "julia-1.10.3",
    "MYENV_LAMMPS":       "LAMMPS-64bit-Python-17Apr2024-MSMPI",
    "MYENV_MIKTEX":       "basic-miktex-24.1-x64",
    "MYENV_PARAVIEW":     "ParaView-5.12.0-Windows-Python3.10-msvc2017-AMD64",
    "MYENV_PYTHON":       "python-3.12.3.amd64",
    "MYENV_SALOME":       "SALOME-9.12.0",
    "MYENV_SU2":          "SU2-v8.0.1-win64-mpi",
    "MYENV_TEXSTUDIO":    "texstudio-4.8.0-win-portable-qt6",
    "MYENV_VMD":          "vmd194a53win64-SetupV7",
    "MYENV_VSCODE":       "VSCode-win32-x64-1.89.1",
    "MYENV_WINPYTHON":    "WPy64-31231b3",
}

# TODO...