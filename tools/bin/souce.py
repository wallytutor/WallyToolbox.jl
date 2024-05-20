# -*- coding: utf-8 -*-
""" Helper to generate a better `source.bat`. """
from pathlib import Path

basepaths = {
    "MYENV_ELMER":     "ElmerFEM-gui-mpi-Windows-AMD64",
    "MYENV_GIT":       "PortableGit-2.45.1",
    "MYENV_GMSH":      "gmsh-4.13.0-Windows64-sdk",
    "MYENV_JULIA":     "julia-1.10.3",
    "MYENV_PARAVIEW":  "ParaView-5.12.0-Windows-Python3.10-msvc2017-AMD64",
    "MYENV_PYTHON":    "python-3.12.3.amd64",
    "MYENV_SALOME":    "SALOME-9.12.0",
    "MYENV_VSCODE":    "VSCode-win32-x64-1.89.1",
    "MYENV_WINPYTHON": "WPy64-31231b3",
}

# TODO...