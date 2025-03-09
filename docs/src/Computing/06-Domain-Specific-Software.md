# Domain specific software


## Transport phenomena


The list below provides useful links for learning transport phenomena simulation:

- [CFD Online (forum)](https://www.cfd-online.com/)
- [NASA Turbulence LARC](https://turbmodels.larc.nasa.gov/)
- [CFD General Notation System (CGNS)](http://cgns.github.io/)
- [CFD Support (list of software)](https://www.cfdsupport.com/cae-open-source-software.html)
- [CFDyna](http://cfdyna.com/)

And below you find some supporting tools for setting up a CFD simulation:

- [Y-Plus](https://www.cfd-online.com/Tools/yplus.php)
- [Skin friction](https://www.cfd-online.com/Wiki/Skin_friction_coefficient)
- [Fluid Mechanics 101](https://fluidmechanics101.com/pages/tools.html)

The following is a list of water property calculators for use in detailed simulations:

- [IAPWS-95](http://www.iapws.org/relguide/IAPWS-95.html)
- [iapws](https://iapws.readthedocs.io/en/latest/iapws.iapws95.html)
- [CoolProp](http://www.coolprop.org/)
- [freesteam](http://freesteam.sourceforge.net/)
- [qingfengxia/freesteam](https://github.com/qingfengxia/freesteam)

It is also interesting to have access to some combustion-related materials:

- [Methane/air combustion](https://www.cerfacs.fr/cantera/mechanisms/meth.php)

### SU2

- [SU2 webpage](https://su2code.github.io/)

### OpenFOAM

OpenFOAM distributions

- [OpenFOAM.org (CFD Direct)](https://openfoam.org/)
- [OpenFOAM.com (ESI)](https://www.openfoam.com/)

General purpose, tutorials, and documentation:

- [OpenFOAM Wiki](https://openfoamwiki.net/index.php/Main_Page)
- [TU Wien tutorials](https://www.cfd.at/tutorials)
- [3-week series tutorials](https://wiki.openfoam.com/index.php?title=%223_weeks%22_series)
- [Tutorials by author](https://wiki.openfoam.com/Collection_by_authors)
- [FEA for All tutorials of OpenFOAM](https://feaforall.com/category/tutorial/openfoam/)
- [CEMF tutorials](https://www.cemf.ir/category/tutorials/)

External solvers:

- [catalyticFoam](https://github.com/multiscale-catalysis-polimi/catalyticFoam)
- [CEMF solvers](https://www.cemf.ir/openfoam/cemf-solvers-based-on-openfoam/)

Conjugate heat transfer:

- [Tutorial of chtMultiRegionFoam](https://www.youtube.com/watch?v=Nhhm-ZPxVRc&list=PLykdptEQ2lFintoU5dgerzQbQprd9zwTY)
- [Tutorial - Heat sink](https://www.youtube.com/watch?v=MD3cjOF8S60)

Volume of fluid (VoF):

- [interFoam tutorial - raising bubble](https://www.youtube.com/watch?v=JYHhF25OTm0&list=PLykdptEQ2lFintoU5dgerzQbQprd9zwTY&index=2)

Moving reference frame (MRF):

- [Video tutorial by Asmaa Hadane](https://www.youtube.com/watch?v=KccubqHQS-0)

### Reduced order modeling (ROM)

- [GeN-ROM paper](https://www.sciencedirect.com/science/article/pii/S0149197022000282)
- [ITHACA-FV ROM for OpenFOAM](https://github.com/mathLab/ITHACA-FV)
- [BYU-PRISM/Seeq](https://github.com/BYU-PRISM/Seeq)

### Lattice-Boltzmann method

The following links provide simple implementations to learn DEM development:

- [LBM in Python from scratch](https://medium.com/swlh/create-your-own-lattice-boltzmann-simulation-with-python-8759e8b53b1c)
- [Repository with implementation samples](https://github.com/jviquerat/lbm)

### Smooth Particle Hydrodynamics

- [Several projects](https://www.spheric-sph.org/sph-projects-and-codes)

---
## Systems modeling

### DWSIM

Generical chemical process simulation software.

- [DWSIM](https://dwsim.org/)
- [DWSIM: Curso (Pr. Felix Monteiro Pereira)](https://sistemas.eel.usp.br/docentes/visualizar.php?id=5817066)
- [DWSIM: Curso (Pr. Delano Mendes de Santana)](https://dwsim.org/files/ENG438_Aula02_DWSIM_rev0.pdf)
- [DWSIM: YouTube Playlist](https://www.youtube.com/playlist?list=PLkdIY_5Zxa7WN-8FEYjTqvX8tEKEhjCTu)

### Dyssol

  Dyssol is process unit operations simulator conceived from granular processes.

- [Dyssol repository](https://github.com/FlowsheetSimulation/Dyssol-open)
- [Dyssol documentation](https://flowsheetsimulation.github.io/Dyssol-open/)

### Modelica

Modelica is an acausal programming language for systems modeling:

- [Modelica Association](https://modelica.org/index.html)
- [Modelica Documentation](https://doc.modelica.org/)
- [Modelica Specification](https://specification.modelica.org/)
- [OpenModelica (FOSS implementation)](https://www.openmodelica.org/)
- [Modelica University](https://mbe.modelica.university/)
- [ThermoSysPro package](https://thermosyspro.com/)

---
## Combustion and kinetics

### Cantera

[Cantera](https://cantera.org/) is the *standard* package for modeling reacting systems. As it was my main toolkit in the final parts of my PhD and still is a major part of my professional life, I am quite knowledgeable on this software. It can be considered the final replacement of classical Chemkin. I am currently working in a Julia interface to its core library.

### Fire Models

- [GitHub - firemodels/fds: Fire Dynamics Simulator](https://github.com/firemodels/fds)
- [FDS-SMV Manuals](https://pages.nist.gov/fds-smv/manuals.html)

### OpenSmoke++

- [OpenSmoke++](https://www.opensmokepp.polimi.it/) is a framework for detailed kinetics modeling of large reacting systems. This paper might be of interest:  [Dalili (2020)](https://www.tandfonline.com/doi/full/10.1080/13647830.2020.1800823) - modeling of a single droplet evaporation and combustion.

---
## Mathematical software

- [Mathics](https://mathics.org/)
- [Maxima](https://maxima.sourceforge.io/)

### Optimization packages

The following lists some #constrained-optimization packages:

- [CVXPY](https://www.cvxpy.org/index.html)
- [CVXOPT](https://cvxopt.org/?ref=localhost)
- [PICOS](https://picos-api.gitlab.io/picos/index.html)
- [Pyomo](https://www.pyomo.org/)
- [CasADi](https://web.casadi.org/docs/)
- [pymoo](https://pymoo.org/index.html)
- [platypus](https://platypus.readthedocs.io/en/latest/index.html)
- [MEALPY](https://mealpy.readthedocs.io/en/latest/?badge=latest)
- [JuMP](https://jump.dev/)
- [ModelingToolkit](https://docs.sciml.ai/ModelingToolkit/stable/tutorials/optimization/)

---
## Computational thermodynamics

- [sundmanbo/opencalphad](https://github.com/sundmanbo/opencalphad)
- [pycalphad/pycalphad](https://github.com/pycalphad/pycalphad)
- [materialsgenomefoundation/kawin](https://github.com/materialsgenomefoundation/kawin)
- [ORNL-CEES/thermochimica](https://github.com/ORNL-CEES/thermochimica)
- [ORNL/Equilipy](https://github.com/ORNL/Equilipy)
- [hasundue/Calmato.jl](https://github.com/hasundue/Calmato.jl)
- [npaulson/pduq](https://github.com/npaulson/pduq)

---
## Entering

This section contains other software to check; I don't necessarily know them and as I might them useful or consider the projects abandoned they might be dropped from the list until they find their right place in this file.

- [ASL GitHub](https://github.com/AvtechScientific/ASL)
- [Dymos](https://openmdao.github.io/dymos/index.html)
- [GitHub - flame-code/FLAME: FLAME: a library for atomistic modeling environments](https://github.com/flame-code/FLAME)
- [stitching/stitching at main · lukasalexanderweber/stitching](https://github.com/lukasalexanderweber/stitching/tree/main/stitching)
- [usnistgov/atomman: Atomistic Manipulation Toolkit](https://github.com/usnistgov/atomman)
- [GrossfieldLab/loos: LOOS: a lightweight object-oriented structure analysis library](https://github.com/GrossfieldLab/loos)
- [glotzerlab/freud: Powerful, efficient particle trajectory analysis in scientific Python.](https://github.com/glotzerlab/freud)
- [GitHub - xiaoh/sediFoam: CFD-DEM Solver with emphasis on sediment transport](https://github.com/xiaoh/sediFoam)
- [GitHub - CoolProp/CoolProp: Thermophysical properties for the masses](https://github.com/CoolProp/CoolProp)
- [GitHub - fwitte/fluprodia: Fluid property diagrams](https://github.com/fwitte/fluprodia)
- [shiftkey/desktop](https://github.com/shiftkey/desktop/releases)
- [bjodah/chempy: A package useful for chemistry written in Python](https://github.com/bjodah/chempy)
- [BenLand100/chroma: Ultra-fast Photon Monte Carlo](https://github.com/BenLand100/chroma)
- [preCICE: coupling between different solutions](https://precice.org/index.html)
- [ASALI](https://github.com/srebughini/ASALI)
- [CSIRO](https://github.com/csiro/oss-directory)
- [Lethe](https://chaos-polymtl.github.io/lethe/documentation/index.html)