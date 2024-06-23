# Scientific Computing

Notes related to my learning and teaching interests in several fields related to scientific computing (mostly applied mathematics and machine learning) and related applications. This home page is the entry point with interesting links and an index to the materials.

It can also be used as a general guide for introducing scientific computing as it tries to introduce the minimal skill set any scientific computing engineer or scientist should have:

- Version control comes first, everything else is worthless without it, currently that means Git.
- Next comes software documentation with Doxygen, Sphinx, and/or Documenter.jl.
- A low(er) level programming language among C, C++, and Fortran, preferably all of them.
- Scripting languages, as of 2024, Python is mandatory, Julia highly recommended.
- Basic machine learning in one of the above scripts, everything is ML these days.
- Shell automation, basis of both Bash/other UNIX shell and PowerShell are required.
- Typesetting equations reports and presentations (beamer) in $\LaTeX$.
- Domain specific skills related to the field of study (CFD, DFT, MD, ML, ...).

Some technologies have been mainstream or important in the past, but nowadays some of them have already died or are becoming too niche to be put in such a list. That is the case of SVN for version control. As for programming languages in science, that is the case of *matlabish* (MATLAB, Octave, Scilab) environments, which are still used by *controls and automation* people, but are incompatible with good software practices and should be discouraged.

---
## Programming

Those new to programming can find a quite interesting environment at [Exercism](https://exercism.org/).

### C++

### Cuda

- [GPU-optimized AI, Machine Learning, & HPC Software | NVIDIA NGC](https://catalog.ngc.nvidia.com/?filters=&orderBy=weightPopularDESC&query=&page=&pageSize=)

### Fortran

### Haskell

-  [GHCup](https://www.haskell.org/ghcup/)
- [Haskell for Numerics?](https://idontgetoutmuch.wordpress.com/2017/06/02/1090/)
- [Course by Dmitrii Kovanikov](https://github.com/haskell-beginners-2022/course-plan)

### Lisp

### Octave

### OpenCL

### Pascal

- [Free Pascal Docs](https://www.freepascal.org/docs.html)
- [Free Pascal Wiki](https://wiki.freepascal.org/Main_Page)
- [Pascal Wikibook](https://en.wikibooks.org/wiki/Pascal_Programming)

### Python

General stuff:

- [8 surprising ways how to use Jupyter Notebook](https://mljar.com/blog/how-to-use-jupyter-notebook/)

Some (yet crude) visual programming in Python:

- [Barfi](https://barfi.readthedocs.io/en/latest/)
- [nodezator](https://nodezator.com/)

All you need is a package:

- [casadi](https://web.casadi.org/): Optimal control and MPC.
- [mip](https://www.python-mip.com/): Mixed-integer linear programming.

### Rust

Rust community often organizes *books* on the main topics regarding the language:

- [Rust Book](https://doc.rust-lang.org/book/)
- [The Cargo Book](https://doc.rust-lang.org/cargo/index.html)
- [The rustup book](https://rust-lang.github.io/rustup/index.html)
- [Rust Cookbook](https://rust-lang-nursery.github.io/rust-cookbook/intro.html)

Some resources for learning Rust (start with *rustlings*):

- [rustlings](https://github.com/rust-lang/rustlings/)
- [Rust By Example](https://doc.rust-lang.org/stable/rust-by-example/)
- [Rust Playground](https://play.rust-lang.org/)

Useful links for working with `cargo`:

- [Bundle Cargo](https://stackoverflow.com/questions/67562843/)
- [The Manifest Format](https://doc.rust-lang.org/cargo/reference/manifest.html)

Useful links for doing numerical stuff in Rust:

- [Vec in std::vec - Rust](https://doc.rust-lang.org/std/vec/struct.Vec.html)
- [plotters](https://docs.rs/plotters/latest/plotters/)

### Scilab

### Other programming materials

- [Why Futhark?](https://futhark-lang.org/index.html)

---
## External links

### High-performance computing (HPC)

- [Top 500](https://top500.org/): the most powerful computers on Earth
- [Specification benchmarking](https://spec.org/): check of hardware specification
- [Slurm](https://www.schedmd.com/): job management for multi-user systems

### Version control

- [TortoiseGIT](https://tortoisegit.org/): for Windows users, this applications add the possibility of managing version control and other features directly from the file explorer.

### Simulation software

- [OpenSmoke++](https://www.opensmokepp.polimi.it/) is a framework for detailed kinetics modeling of large reacting systems. This paper might be of interest:  [Dalili (2020)](https://www.tandfonline.com/doi/full/10.1080/13647830.2020.1800823) - modeling of a single droplet evaporation and combustion.
- [DWSIM: Curso (Pr. Felix Monteiro Pereira)](https://sistemas.eel.usp.br/docentes/visualizar.php?id=5817066)
- [DWSIM: Curso (Pr. Delano Mendes de Santana)](https://dwsim.org/files/ENG438_Aula02_DWSIM_rev0.pdf)
- [DWSIM: YouTube Playlist](https://www.youtube.com/playlist?list=PLkdIY_5Zxa7WN-8FEYjTqvX8tEKEhjCTu)

### Mathematical software

- [Mathics](https://mathics.org/)

### Computational thermodynamics

- [sundmanbo/opencalphad](https://github.com/sundmanbo/opencalphad)
- [pycalphad/pycalphad](https://github.com/pycalphad/pycalphad)
- [materialsgenomefoundation/kawin](https://github.com/materialsgenomefoundation/kawin)
- [ORNL-CEES/thermochimica](https://github.com/ORNL-CEES/thermochimica)
- [ORNL/Equilipy](https://github.com/ORNL/Equilipy)
- [hasundue/Calmato.jl](https://github.com/hasundue/Calmato.jl)
- [npaulson/pduq](https://github.com/npaulson/pduq)
