@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE ENVIRONMENT
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set HERE=%~dp0
set LANG="en_US.UTF-8"

@REM This directory may also contain launcher scripts.
set PATH=%HERE%;%PATH%

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM NEW SYMBOLS
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@REM Coding environment
set GIT_VERSION=PortableGit-2.46.2
set VSCODE_VERSION=VSCode-win32-x64-1.93.1

@REM Molecular dynamics
set LAMMPS_VERSION=LAMMPS-64bit-Python-17Apr2024-MSMPI
set VMD_VERSION=vmd194a53win64-SetupV7

@REM Pre/postprocessing
set BLENDER_VERSION=blender-4.1.1-windows-x64
set FREECAD_VERSION=FreeCAD_0.21.2-2023-12-17-conda-Windows-x86_64-py310
set GMSH_VERSION=gmsh-4.13.0-Windows64-sdk
set GNUPLOT_VERSION=gp600-win64-mingw
set INKSCAPE_VERSION=inkscape-1.3.2_2023-11-25_091e20e-x64
set MESHLAB_VERSION=MeshLab2023.12d-windows
set PARAVIEW_VERSION=ParaView-5.13.1-Windows-Python3.10-msvc2017-AMD64
set SALOME_VERSION=SALOME-9.12.0

@REM Simulation software
set CANTERA_VERSION=Cantera-3.0.0
set CASADI_VERSION=casadi-3.6.5-windows64-octave7.3.0
set DUALSPHYSICS_VERSION=DualSPHysics_v5.2
set ELMER_VERSION=ElmerFEM-gui-mpi-Windows-AMD64
set FREEFEM_VERSION=FreeFem++-4.14-dev
set MODELICA_VERSION=OpenModelica1.23.0-64bit
set SU2_VERSION=SU2-v8.0.1-win64-mpi

@REM LaTeX environment
set JABREF_VERSION=JabRef-5.15-portable_windows
set MIKTEX_VERSION=basic-miktex-24.1-x64
set TEXSTUDIO_VERSION=texstudio-4.8.0-win-portable-qt6
set PANDOC_VERSION=pandoc-3.4

@REM Main languages
set JULIA_VERSION=julia-1.10.5
set WINPYTHON_VERSION=WPy64-31180
set PYTHON_VERSION=python-3.11.8.amd64
set OCTAVE_VERSION=octave-8.4.0-w64
@REM set WINPYTHON_VERSION=WPy64-31231b3
@REM set PYTHON_VERSION=python-3.12.3.amd64

@REM Java
set GANTT_VERSION=ganttproject-3.3.3312
set JAVA_HOME=%HERE%\bellsoft-jre17.0.13+12-windows-amd64-full\jre-17.0.13-full

if exist "%HERE%overrides.bat" ( 
    echo Overriding some setups.
    call %HERE%overrides.bat
    echo %VSCODE_VERSION%
) else ( 
    echo No override file found... keeping defaults.
)

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE VSCODE
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set VSCODEEXTENSIONS=%HERE%..\vscode\extensions
set VSCODESETTINGS=%HERE%..\vscode\user-data

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE GMSH
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set PATH=%HERE%%GMSH_VERSION%\bin;%PATH%
set PATH=%HERE%%GMSH_VERSION%\lib;%PATH%

@REM Keep this out unless needed....
@REM set JULIA_LOAD_PATH=%HERE%%GMSH_VERSION%\lib;%JULIA_LOAD_PATH%
@REM set PYTHONPATH=%HERE%%GMSH_VERSION%\lib;%PYTHONPATH%

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE ELMER
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set ELMER_HOME=%HERE%%ELMER_VERSION%
set ELMERGUI_HOME=%ELMER_HOME%\share\ElmerGUI
set PATH=%ELMER_HOME%\bin;%PATH%
set PATH=%ELMER_HOME%\lib;%PATH%

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE SU2
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set SU2_RUN=%SU2_VERSION%\bin
set PATH=%HERE%%SU2_RUN%;%PATH%

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE VMD
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set VMDDIR=%HERE%%VMD_VERSION%
set PATH=%VMDDIR%;%PATH%

@REM VMD wants HKLM but I can't set it in any machine without being admin...
REG ADD "HKCU\Software\University of Illinois\VMD\1.9.4" /v VMDDIR /t REG_SZ /d %VMDDIR% /f

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE LAMMPS
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@REM Note that in distribution there is no package with simultaneous Python,
@REM MPI support, and GUI. I compared the subfolders of the Python+MPI version
@REM with the one from GUI and stripped the GUI to merge the packages. I hope
@REM that works seamlessly. In the end I ended copying the `qt5plugins/` to
@REM the Python+MPI directory and the additional binaries from `bin`.

set LAMMPSHOME=%HERE%%LAMMPS_VERSION%
set LAMMPS_PLUGIN_PATH=%LAMMPSHOME%\plugins
set LAMMPS_POTENTIALS=%LAMMPSHOME%\Potentials
set MSI2LMP_LIBRARY=%LAMMPSHOME%\frc_files
set PLUMED_ROOT=%LAMMPSHOME%
@REM set PYTHONPATH=%LAMMPSHOME%\Python;%PYTHONPATH%
set PATH=%LAMMPSHOME%\bin;%PATH%

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE OPENMODELICA
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set OPENMODELICAHOME=%HERE%%MODELICA_VERSION%
set PATH=%OPENMODELICAHOME%\bin;%PATH%

REG ADD "HKCU\Software\OpenModelica" /v InstallMode    /t REG_SZ /d CurrentUser /f
REG ADD "HKCU\Software\OpenModelica" /v Path           /t REG_SZ /d %OPENMODELICAHOME% /f
REG ADD "HKCU\Software\OpenModelica" /v StartMenuGroup /t REG_SZ /d OpenModelica /f

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE CANTERA
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set CANTERA_HOME=%HERE%%CANTERA_VERSION%
set CANTERA_SHARED=%CANTERA_HOME%\bin\cantera_shared.dll

set PATH=%CANTERA_HOME%\bin;%PATH%
set PATH=%CANTERA_HOME%\lib;%PATH%

REG ADD "HKCU\Software\Cantera\Cantera 3.0" /v InstallDir /t REG_SZ /d %CANTERA_HOME% /f

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE FREEFEM
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set FREEFEM_HOME=%HERE%%FREEFEM_VERSION%

set PATH=%FREEFEM_HOME%;%PATH%

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM SIMPLE PATH APPENDS
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set PATH=%HERE%%VSCODE_VERSION%;%PATH%
set PATH=%HERE%%GIT_VERSION%\cmd;%PATH%
set PATH=%HERE%%GANTT_VERSION%;%PATH%
set PATH=%HERE%%BLENDER_VERSION%;%PATH%
set PATH=%HERE%%DUALSPHYSICS_VERSION%\bin\windows;%PATH%
set PATH=%HERE%%FREECAD_VERSION%\bin;%PATH%
set PATH=%HERE%%GNUPLOT_VERSION%\gnuplot\bin;%PATH%
set PATH=%HERE%%INKSCAPE_VERSION%\inkscape\bin;%PATH%
set PATH=%HERE%%JABREF_VERSION%\JabRef;%PATH%
set PATH=%HERE%%OCTAVE_VERSION%\mingw64\bin;%PATH%
set PATH=%HERE%%OCTAVE_VERSION%;%PATH%
set PATH=%HERE%%MESHLAB_VERSION%;%PATH%
set PATH=%HERE%%PARAVIEW_VERSION%\bin;%PATH%
set PATH=%HERE%%SALOME_VERSION%;%PATH%
set PATH=%HERE%%TEXSTUDIO_VERSION%;%PATH%
set PATH=%HERE%%PANDOC_VERSION%;%PATH%

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM ACTIVATE LATEX
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

call %HERE%%MIKTEX_VERSION%\miktex-portable.cmd
set PATH=%HERE%%MIKTEX_VERSION%\texmfs\install\miktex\bin\x64\internal;%PATH%
set PATH=%HERE%%MIKTEX_VERSION%\texmfs\install\miktex\bin\x64;%PATH%

@REM IMPORTANT: Julia and Python come last to override others.

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE PYTHON
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set PYTHON_HOME=%HERE%%WINPYTHON_VERSION%\%PYTHON_VERSION%
set PATH=%PYTHON_HOME%;%PATH%
set PATH=%PYTHON_HOME%\Scripts;%PATH%

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM CONFIGURE JULIA
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set PATH=%HERE%%JULIA_VERSION%-win64\%JULIA_VERSION%\bin;%PATH%
set JULIA_DEPOT_PATH=%HERE%%JULIA_VERSION%-win64\depot

@REM Jupyter to be used with IJulia.
set JUPYTER=%PYTHON_HOME%\Scripts\jupyter.exe
set JUPYTER_DATA_DIR=%HERE%..\jupyter

@REM Workaround for creating CondaPkg elsewhere
@REM set JULIA_CONDAPKG_ENV=%HERE%CondaPkg

set WALLYROOT=%HERE%..\..\

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM EOF
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@