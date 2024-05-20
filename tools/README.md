# Portable Toolbox

The goal of this directory is to provide an easy way to setup a portable toolbox for working with scientific computing and development under Windows. It is intended to leave minimal track on host system, but I am not enforcing this in its development, so take care if you are not allowed to execute some software in a given computer.

## Tools

- [VS Code](https://code.visualstudio.com/Download)
- [Git](https://git-scm.com/download/win)
- [Julia](https://julialang.org/downloads/)
- [Python](https://github.com/winpython/winpython/releases)
- [gmsh](https://gmsh.info/#Download)
- [ElmerFEM](https://www.nic.funet.fi/pub/sci/physics/elmer/bin/windows/)
- [ParaView](https://www.paraview.org/download/)
- [Salome](https://www.salome-platform.org/?page_id=2430)

### Next deployments

- [Blender]()
- [MikTeX]()
- [JabRef]()
- [texstudio]()
- [strawberry-perl]()
- [SU2]()

### Optional deployments

- [7-zip]()
- [Fiji]()
- [FileZilla]()
- [inkscape]()
- [pandoc]()
- [Orange3]()
- [puTTy]()
- [Tabby]()
- [MSYS2]()
- [Octave]()
- [Scilab]()
- [ZeroBraneStudio (Lua)]()
- [nteract]()
- [nvim]()
- [Cantera]()
- [CasADi]()
- [DualSPHysics]()
- [DWSIM]()
- [Dyssol]()
- [Ipopt]()
- [MUSEN]()
- [OpenCALPHAD]()

## Setup of environment

- Extract downloaded software to their own directories; right-click the compressed packages and select the option to select to a directory (some software are compressed directly to the root of the file and can make a mess otherwise).

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
