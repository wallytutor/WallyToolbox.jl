# Portable Toolbox

The goal of this directory is to provide an easy way to setup a portable toolbox for working with scientific computing and development under Windows. It is intended to leave minimal track on host system, but I am not enforcing this in its development, so take care if you are not allowed to execute some software in a given computer.

## Tools

- [VS Code](https://code.visualstudio.com/Download)
- [Git](https://git-scm.com/download/win)

- [Julia](https://julialang.org/downloads/)
- [Python](https://github.com/winpython/winpython/releases)

- [MikTeX](https://miktex.org/howto/portable-edition)
- [texstudio](https://www.texstudio.org/#download)
- [JabRef](https://www.fosshub.com/JabRef.html?dwl=JabRef-5.13.msi)

- [ElmerFEM](https://www.nic.funet.fi/pub/sci/physics/elmer/bin/windows/)
- [SU2](https://su2code.github.io/download.html)

- [Blender](https://www.blender.org/download/)
- [DualSPHysics](https://dual.sphysics.org/downloads/)
- [FreeCAD](https://www.freecad.org/downloads.php)
- [gmsh](https://gmsh.info/#Download)
- [gnuplot](https://sourceforge.net/projects/gnuplot/files/gnuplot/6.0.0/)
- [ParaView](https://www.paraview.org/download/)
- [Salome](https://www.salome-platform.org/?page_id=2430)

Next deployment:

- [FreeFem++]()
`
For DualSPHysics one might also want to install [this FreeCAD addon](https://github.com/DualSPHysics/DesignSPHysics) and [this Blender addon](https://github.com/EPhysLab-UVigo/VisualSPHysics).

### Optional deployments

- [7-zip]()
- [Cantera]()
- [CasADi]()
- [DWSIM]()
- [Dyssol]()
- [Fiji]()
- [FileZilla]()
- [inkscape]()
- [Ipopt]()
- [MUSEN]()
- [nteract]()
- [nvim]()
- [OpenCALPHAD]()
- [Octave]()
- [Orange3]()
- [pandoc]()
- [puTTy]()
- [Scilab]()
- [strawberry-perl]()
- [ZeroBraneStudio]()

### Still thinking about

- [Tabby]()
- [MSYS2]()
- [Notepad++]

## Setup of environment

- Extract downloaded software to their own directories; right-click the compressed packages and select the option to select to a directory (some software are compressed directly to the root of the file and can make a mess otherwise).

- Enable VSCode [portable mode](https://code.visualstudio.com/docs/editor/portable) and install required extensions (Python and Julia support, ...).

## Creating a launcher

```batch
@echo off
call %~dp0\env
Code.exe
```

```vb
Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c bin\Code.bat"
oShell.Run strArgs, 0, false
```

## MiKTeX tweaks

To append `TEXMF` variable one can use the MiKTeX Console graphical interface and under `Settings > Directories` navigate and select the local path. Alternativelly on can add to `bin/<miktex-dir>/texmfs/install/miktex/config/miktexstartup.ini` a line as

```ini
CommonRoots=C:/Path/To/Local/TeX/Tree
```