@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE ENVIRONMENT
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set HERE=%~dp0
set LANG="en_US.UTF-8"

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM NEW SYMBOLS
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set BLENDER_VERSION=blender-4.1.1-windows-x64
set DUALSPHYSICS_VERSION=DualSPHysics_v5.2.2
set ELMER_VERSION=ElmerFEM-gui-mpi-Windows-AMD64
set FREECAD_VERSION=FreeCAD_0.21.2-2023-12-17-conda-Windows-x86_64-py310
set GIT_VERSION=PortableGit-2.45.1
set GMSH_VERSION=gmsh-4.13.0-Windows64-sdk
set GNUPLOT_VERSION=gp600-win64-mingw
set JABREF_VERSION=JabRef-5.13-portable_windows
set JULIA_VERSION=julia-1.10.3
set MIKTEX_VERSION=basic-miktex-24.1-x64
set WINPYTHON_VERSION=WPy64-31231b3
set PARAVIEW_VERSION=ParaView-5.12.0-Windows-Python3.10-msvc2017-AMD64
set PYTHON_VERSION=python-3.12.3.amd64
set SALOME_VERSION=SALOME-9.12.0
set SU2_VERSION=SU2-v8.0.1-win64-mpi
set TEXSTUDIO_VERSION=texstudio-4.8.0-win-portable-qt6
set VSCODE_VERSION=VSCode-win32-x64-1.89.1

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE JULIA
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set PATH=%HERE%\%JULIA_VERSION%-win64\%JULIA_VERSION%\bin;%PATH%
set JULIA_DEPOT_PATH=%HERE%\%JULIA_VERSION%-win64\depot

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE PYTHON
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set PATH=%HERE%\%WINPYTHON_VERSION%\%PYTHON_VERSION%;%PATH%
set PATH=%HERE%\%WINPYTHON_VERSION%\%PYTHON_VERSION%\Scripts;%PATH%

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE GMSH
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set PATH=%HERE%\%GMSH_VERSION%\bin;%PATH%
set PATH=%HERE%\%GMSH_VERSION%\lib;%PATH%
set JULIA_LOAD_PATH=%HERE%\%GMSH_VERSION%\lib;%JULIA_LOAD_PATH%
set PYTHONPATH=%HERE%\%GMSH_VERSION%\lib;%PYTHONPATH%

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE ELMER
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set ELMER_HOME=%HERE%\%ELMER_VERSION%
set ELMERGUI_HOME=%ELMER_HOME%\share\ElmerGUI
set PATH=%ELMER_HOME%\bin;%PATH%
set PATH=%ELMER_HOME%\lib;%PATH%

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE SU2
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set SU2_RUN=%SU2_VERSION%\bin
set PATH=%HERE%\%SU2_RUN%;%PATH%

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM SIMPLE PATH APPENDS
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set PATH=%HERE%\%VSCODE_VERSION%;%PATH%
set PATH=%HERE%\%GIT_VERSION%\cmd;%PATH%
set PATH=%HERE%\%BLENDER_VERSION%\bin;%PATH%
set PATH=%HERE%\%DUALSPHYSICS_VERSION%\DualSPHysics_v5.2\bin\windows;%PATH%
set PATH=%HERE%\%FREECAD_VERSION%\bin;%PATH%
set PATH=%HERE%\%GNUPLOT_VERSION%\gnuplot\bin;%PATH%
set PATH=%HERE%\%JABREF_VERSION%\JabRef;%PATH%
set PATH=%HERE%\%PARAVIEW_VERSION%\bin;%PATH%
set PATH=%HERE%\%SALOME_VERSION%;%PATH%
set PATH=%HERE%\%TEXSTUDIO_VERSION%;%PATH%

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM ACTIVATE LATEX
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

call %HERE%\%MIKTEX_VERSION%\miktex-portable.cmd
set PATH=%HERE%\%MIKTEX_VERSION%\texmfs\install\miktex\bin\x64\internal;%PATH%
set PATH=%HERE%\%MIKTEX_VERSION%\texmfs\install\miktex\bin\x64;%PATH%

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM EOF
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@