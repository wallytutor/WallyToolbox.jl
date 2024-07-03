---

kanban-plugin: basic

---

## Organização pessoal

- [ ] Nouvelle acte de mariage
- [ ] Add LibreOffice and Obsidian to scientific-environment
- [ ] Garantia Shokz
- [ ] Concluir/enviar dossier de naturalização
- [ ] RDV Ophtalmologue
- [ ] Terminar update to clubot com envio de emails
- [ ] Atualizar CV Lattes
- [ ] Aplicar validação do doutorado
- [ ] Migrar planejamento de DryTooling.jl aqui
- [ ] Check purchase of new tower
- [ ] Pédalier Shimano Deore FC 30 dents
- [ ] Chambre à air X2
- [ ] Organizar e mover links de esportes à página
- [ ] Terminar de organizar links técnicos nas páginas de bookmarks.
- [ ] Deploy [paperless](https://github.com/paperless-ngx/paperless-ngx?tab=readme-ov-file)
- [ ] Deploy [Wiki.js](https://js.wiki/)


## OpenFOAM

- [ ] Start creating a CHT case step-by-step from aachenBombSteady (compatible with radiation and wall heat losses)
- [ ] **(paper C2H2)** migrate to OpenFOAM11 and publish
- [ ] **(aachenBomb)** Provide post-processing
- [ ] **(aachenBombSteady)** Finish case construction
- [ ] Test [this](https://github.com/OpenFOAM/OpenFOAM-11/blob/master/etc/caseDicts/postProcessing/solvers/particles) function for post-processing.
- [ ] Add case for testing PSD
- [ ] **(sedimentationBox):** export STL model from SpaceClaim and mesh in snappyHexMesh
- [ ] **(sedimentationBox):** Impose [flow rate at outlet](https://cpp.openfoam.org/v11/classFoam_1_1flowRateOutletVelocityFvPatchVectorField.html#af375c1a054fb3aeb98443f71ccc9b335) with pressure inlet if possible
- [ ] **(sedimentationBox)**  Post-process cases
- [ ] **(horizontalMixer)** Compute fractional mass in system with respected to injected (extract from log files).
- [ ] **(horizontalMixer)** Work towards enabling `particleTracks` in `cloudFunctions`.
- [ ] **(horizontalMixer)** Ensure individual time-steps converged during solution (residuals get first value only).
- [ ] **(horizontalMixer)** Plots of data in `patchFlowRate(patch=outlet, cloud:massFlux)` files.
- [ ] **(horizontalMixer)** Process `lagrangian/cloud/patchPostProcessing1/*` (Julia script ongoing).
- [ ] **(horizontalMixer)** Explore [`solution`](https://cpp.openfoam.org/v11/classFoam_1_1cloudSolution.html#details) configuration.
- [ ] **(horizontalMixer)** Organize scripts as a single module and runners.
- [ ] **(horizontalMixer)** Download all related papers!
- [ ] **(horizontalMixer)** learn from Clérac's fvSolution for better controls


## Cursos online

- [ ] [Computational thinking](https://computationalthinking.mit.edu/Fall23/)
- [ ] [*Course SciML*](https://book.sciml.ai/)
- [ ] [Mecânica Newtoniana](https://www.coursera.org/learn/mecanique-newton/home/week/1)
- [ ] [Mêcânica de pontos materiais](https://www.coursera.org/learn/mecanique-point-materiel/home/week/1)
- [ ] [Mêcânica de corpos massivos](https://www.coursera.org/learn/mecanique-solide/home/week/1)
- [ ] [Mecânica Lagrangiana](https://www.coursera.org/learn/mecanique-lagrangienne/home/week/1)
- [ ] [Cursos MITx (ver dashboard)](https://mitxonline.mit.edu/dashboard/)
- [ ] [Cursos EDx (ver dashboard)](https://home.edx.org/)
- [ ] [Videos OpenFOAM 9](https://www.youtube.com/playlist?list=PLoI86R1JVvv8JHTymlAmDChejiwm846Wl)
- [ ] [Tutorials Doggo dot Jl](https://github.com/julia4ta/tutorials/tree/master)
- [ ] Concluir Introduction to Simulation (EDX)
- [ ] Concluir [Ansys Track](https://courses.ansys.com/index.php/courses/)
- [ ] Concluir [Cornell SimCafe](https://confluence.cornell.edu/display/simulation/home)
- [ ] [Introduction to numerical analysis](https://ocw.mit.edu/courses/18-330-introduction-to-numerical-analysis-spring-2012/)
- [ ] [Michigan State FEM + deal.ii](https://www.coursera.org/learn/finite-element-method)
- [ ] [Computational methods on aerospace engineering](https://dspace.mit.edu/bitstream/handle/1721.1/143656/16-90-spring-2014/contents/?sequence=9&isAllowed=y)
- [ ] Boltzmann Law EDX
- [ ] [Verificar pacotes FEM](https://en.wikipedia.org/wiki/List_of_finite_element_software_packages)
- [ ] Code Saturne
- [ ] Yade-OpenFOAM coupling
- [ ] Kratos
- [ ] [Tutoriais Simon Gravelle](https://lammpstutorials.github.io/)
- [ ] [Tutoriais Mark Tschopp](https://github.com/mrkllntschpp/lammps-tutorials)
- [ ] [Tutoriais Nuwan Dewapriya](https://github.com/nuwan-d/LAMMPS_tutorials_for_short_courses)
- [ ] Estudar ESPResSo
- [ ] Estudar Quantum Espresso


## Portfolio

- [ ] Comparison of drag models using a sedimentation box in OpenFOAM
- [ ] Cyclone separator with MPPIC cloud in OpenFOAM
- [ ] Setup of thermophysical properties with temperature dependence
- [ ] Droplet combustion with arbitrary user-defined composition
- [ ] Multicomponent airlock system
- [ ] Arbitrary user-defined gas phase kinetics with Graf (2007)
- [ ] Carbonitriding model with example of complex part
- [ ] Spray dryer
- [ ] Coded reactor wall coupling
- [ ] Simplified acetylene kinetics model
- [ ] Estudar MFiX


%% kanban:settings
```
{"kanban-plugin":"basic"}
```
%%