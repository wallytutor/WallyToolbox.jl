# Setup guide

```@meta
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/WallyToolbox/setup-guide.md"
```

You probably ended up here because you are looking for a full working setup of a reasonable computing environment under Windows and that is exactly the goal of this guide: to provide an easy way to setup a portable toolbox for working with scientific computing and development under Windows. It is intended to leave minimal track on host system[^1], but I am not enforcing this in its development, so take care if you are not allowed to execute some software in a given computer. Except for the fact that you will probably want [Microsoft MPI ](https://learn.microsoft.com/en-us/message-passing-interface/microsoft-mpi) to be able to perform parallel computations, everything else can be deployed without administration rights.

!!! warn

    Notice that this guide is under development and instructions may still be incomplete; do not hesitate to reach me for more detailed instructions.

[^1]: Probably a few files and directories on your user home directory or under *AppData*.

## Workflow description

First of all, you have to clone [WallyToolbox.jl](https://github.com/wallytutor/WallyToolbox.jl) somewhere in the target computer. You can consider using [GitHub Desktop](https://github.com/apps/desktop) at this stage, assuming you do not have Git yet. Everything else we perform here will be done under its [tools/](https://github.com/wallytutor/WallyToolbox.jl/tree/main/tools) directory. Before anything, read all the elements provided below, simply trying to follow them in order will certainly lead to errors or confusion.

For each of the applications you will install, make sure to perform the following generic steps:

1. Download the portable (often a compressed file) version of the application; the links to the currently supported applications are provided in the next section. It is recommended to create a `sandbox/` directory under `tools/` to save these files, it is ignored by version control.

2. If it is a compressed file, inspect it to check whether the software is contained in a compressed directory or if files are straight at the container root; in the later case create a directory with the software name and version under `tools/bin/` and copy the file inside before extraction; otherwise extract it to that same directory. Several packages are stored directly at *zip* roots and that may be messy to clean. Once finished, you can delete the copy of the compressed file to free space.

3. Under `tools/bin/` you find [source.bat](https://github.com/wallytutor/WallyToolbox.jl/blob/main/tools/bin/source.bat) which is responsible by making sure all the executables may be found in your newly created environment. This file is a batch script and modifying it is the trickiest step of this guide. To open it you cannot *click* the file, but *right-click* and *edit*, as Windows see these as executables. First you need to find the section marked by the comment `@REM NEW SYMBOLS` and identify the variable associated to the software you are trying to install. Modify its value to the name of the directory you just created, that is everything you need to for most software.

Once you have finished installing everything, comment out all `set PATH` related to software you are not installing; this way you avoid telling the system to search for  executables under non-existing directories. Other commands such as `call` to non-existing scripts might break your system. Also remove any `REG ADD` that is not being used.

Now you can launch the editor with access to the deployed software by clicking [`tools/code.vbs`](https://github.com/wallytutor/WallyToolbox.jl/blob/main/tools/code.vbs). It is recommended you create a symbolic link to this file in your desktop for each of use later, as navigating to this directory every time may be excruciating.

## Minimal environment

These are required to get your system working for the first time. After installing `VS Code`, do **NOT** enable its [portable mode](https://code.visualstudio.com/docs/editor/portable) (because the VBS file for launching will point to a specific user-data folder) and install required extensions (Python and Julia support, ...). Also notice that there is a [`tools/vscode/`](https://github.com/wallytutor/WallyToolbox.jl/tree/main/tools/vscode) directory for keeping user configurations in a version controlled way.

- [VS Code](https://code.visualstudio.com/Download)
- [Git](https://git-scm.com/download/win)
- [Julia](https://julialang.org/downloads/)
- [Python](https://github.com/winpython/winpython/releases)

From a `VS Code` terminal launched using [code.vbs](https://github.com/wallytutor/WallyToolbox.jl/blob/main/tools/code.vbs) script you can run `wjulia` as an alias to launch the toolbox; notice that launching this way is the only meaningful way to work with the toolbox as described here since that script will set all the required environment variables.

To be able to use module `WallyToolbox.Notebook` or launch its exported interface for literate programming in the [utilities](utilities.md), an user-defined value of environment variable `JUPYTER_DATA_DIR` must be provided to avoid conflict with system files. It must be noticed that this utility module is intentionally undocumented.

Python modules are currently second-grade citizens to `WallyToolbox`; they consist mostly of domain-specific code that I did not yet migrate to Julia. Nonetheless, some code will remain in Python because fields such as computer vision and overall machine learning have a much broader community and thus quality tools. Wrapping these in Julia through [PythonCall](https://github.com/JuliaPy/PythonCall.jl) is not considered as an alternative for now. 

```bash
# Install `virtualenv`:
pip install virtualenv

# Create a virtual environment:
virtualenv venv

# Alternativelly use built-in `venv`:
# python -m venv venv

# Activate the environment:
./venv/Scripts/activate

# Install dependencies, if any:
pip install -r requirements.txt
```

## LaTeX and related

Although LaTeX is not mandatory, it is highly encouraged; otherwise, what is the point of doing any scientific computing and not publishing its results? Also for a fully operational *Jupyter notebook* environment you need both `pandoc` and `inkscape`. 

- [MikTeX](https://miktex.org/howto/portable-edition)
- [texstudio](https://www.texstudio.org/#download)
- [JabRef](https://www.fosshub.com/JabRef.html?dwl=JabRef-5.13.msi)
- [pandoc](https://pandoc.org/installing.html)
- [inkscape](https://inkscape.org/release/inkscape-1.3.2/windows/64-bit/)

Globally install [`pip install Pygments`](https://pygments.org/) for enabling syntax highlight in LaTeX using `minted`; that is the most flexible highlighting method for adding code snippets to your documents.

To append to `TEXMF` variable one can use the MiKTeX Console graphical interface and under `Settings > Directories` navigate and select the local path. Alternativelly on can add to `bin/<miktex-dir>/texmfs/install/miktex/config/miktexstartup.ini` a line as

```ini
CommonRoots=C:/Path/To/Local/TeX/Tree
```

pointing to a directory implementing the user's [TeX Directory Structure](https://miktex.org/kb/tds).

## Project management

Project management tools may be useful; you can try Gantt Project liste below. Full integration to the working environment is not yet established and you might need to tweak the launch script (tip, `JAVA_HOME` environment variable) to get it working.

- [Gantt Project](https://www.ganttproject.biz/download/free#zip)
- [JRE (select full version)](https://bell-sw.com/pages/downloads/#jdk-21-lts)

## Domain-specific

### Science and Engineering

Since these are mostly domain-specific, it is up to you to select from the list.

- [DualSPHysics](https://dual.sphysics.org/downloads/)
- [Cantera](https://github.com/Cantera/cantera/releases/tag/v3.0.0)
- [CasADi](https://web.casadi.org/get/)
- [DWSIM](https://dwsim.org/index.php/download/)
- [ElmerFEM](https://www.nic.funet.fi/pub/sci/physics/elmer/bin/windows/)
- [FreeFem++](https://github.com/FreeFem/FreeFem-sources/releases)
- [LAMMPS](https://packages.lammps.org/windows.html)
- [OpenModelica](https://openmodelica.org/download/download-windows/)
- [RadCal](https://github.com/firemodels/radcal)
- [SU2](https://su2code.github.io/download.html)

For DualSPHysics one might also want to install [this FreeCAD addon](https://github.com/DualSPHysics/DesignSPHysics) and [this Blender addon](https://github.com/EPhysLab-UVigo/VisualSPHysics).

Read comments in [`tools/bin/source.bat`](https://github.com/wallytutor/WallyToolbox.jl/blob/main/tools/bin/source.bat) for additional instructions, *e.g.* how to setup a Frankenstein LAMMPS installation. It requires a good familiarity with the inner workings of software and libraries; in the future I will reach LAMMPS maintainers to make this simpler and part of the official releases.

#### MFiX

This package is [installed](https://mfix.netl.doe.gov/products/mfix/download/) in a separate environment and not added to the toolbox path; that is because other Python environments could interact with each other and lead to unpredictable behavior. The following instructions are provided:

- Install [miniforge3](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Windows-x86_64.exe) under the toolbox directory `tools/bin/miniforge3`
- Launch miniforge console by running [`tools/bin/miniforge3.bat`](https://github.com/wallytutor/WallyToolbox.jl/blob/main/tools/bin/miniforge3.bat)
- Run script [`tools/bin/mfix-install.bat`](https://github.com/wallytutor/WallyToolbox.jl/blob/main/tools/bin/mfix-install.bat) from within the console
- To run the software activate the created environment and call its executable:

```batch
conda activate mfix-24.3
mfix
```

### Geometry and preprocessing

Again some domain-specific software, select what you need.

- [Blender](https://www.blender.org/download/)
- [FreeCAD](https://www.freecad.org/downloads.php)
- [gmsh](https://gmsh.info/#Download)
- [gnuplot](https://sourceforge.net/projects/gnuplot/files/gnuplot/6.0.0/)
- [MeshLab](https://github.com/cnr-isti-vclab/meshlab)
- [ParaView](https://www.paraview.org/download/)
- [Salome](https://www.salome-platform.org/?page_id=2430)

### Additional languages

It is highly discouraged to use Octave for any large project, but it might be interesting to use it for teaching linear algebra and the basics of numerical mathematics, so it is also supported.

- [Octave](https://octave.org/download)

## Possible roadmap

- 7-zip
- Dyssol
- Fiji
- FileZilla
- Ipopt
- Jamovi
- JASP
- lazarus
- [lite-xl](https://github.com/lite-xl/lite-xl)
- MSYS2
- MUSEN
- Notepad
- nteract
- nvim
- OpenCALPHAD
- Orange3
- puTTy
- Scilab
- strawberry-perl
- Tabby
- ZeroBraneStudio

## Documentation build

Documentation is generated by a GitHub Actions workflow at every commit to the main branch. Because of the multiple modules in a repository structure, this documentation follows *intrinsically* a rolling release logic. Because the package and modules are not registered, they also do not appear in the `docs/Project.toml`. So it is up to the maintainers to ensure that section `[deps]` of `docs/Project.toml` points to **ALL** dependencies of **ALL** sub-packages.

For generating the documentation locally, run `julia --project=docs/` and in REPL run the following command:

```repl
julia> include("docs/make.jl")
   Resolving package versions...
   ...
```
