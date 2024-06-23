
Courses to follow:

\item\href{https://ocw.mit.edu/courses/mathematics/18-075-advanced-calculus-for-engineers-fall-2004/}{Advanced Calculus}

\item\href{https://ocw.mit.edu/courses/mechanical-engineering/2-06-fluid-dynamics-spring-2013/}{Fluid Dynamics}:

\item\href{https://ocw.mit.edu/courses/mechanical-engineering/2-25-advanced-fluid-mechanics-fall-2013/}{Advanced Fluid Mecanics}

\item\href{https://ocw.mit.edu/courses/mechanical-engineering/2-27-turbulent-flow-and-transport-spring-2002/}{Turbulent Flow and Transport}

\item\href{https://ocw.mit.edu/courses/mechanical-engineering/2-051-introduction-to-heat-transfer-fall-2015/}{Introduction to Heat Transfer}

\item\href{https://ocw.mit.edu/courses/mechanical-engineering/2-51-intermediate-heat-and-mass-transfer-fall-2008/}{Intermediate Heat Transfer}

\item\href{https://ocw.mit.edu/courses/mechanical-engineering/2-58j-radiative-transfer-spring-2006/}{Radiative Transfer}

\item\href{https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-336j-introduction-to-numerical-simulation-sma-5211-fall-2003/}{Introduction to Simulation}

\item\href{https://ocw.mit.edu/courses/aeronautics-and-astronautics/16-920j-numerical-methods-for-partial-differential-equations-sma-5212-spring-2003/}{Numerical Methods for PDE}

\item\href{https://ocw.mit.edu/courses/mechanical-engineering/2-29-numerical-fluid-mechanics-spring-2015/}{Numerical Fluid Mechanics}

\item\href{https://ppc.cs.aalto.fi/}{Programming Parallel Computers} (and its extension to \href{https://github.com/parallel-rust-cpp}{Rust})

\item\href{https://www.youtube.com/playlist?list=PLfF--3o8i4r82vJ0kjCVYgqKgyVM5QwN0}{Fluid Mechanics (classical)}

\item\href{https://www.youtube.com/playlist?list=PL6S8U84PCLB27bdd15l1xnTSQKf3AOOoj}{Turbulent mixing conference (ICTP)}

\item\href{https://www.youtube.com/playlist?list=PL80xBr8Wq0b5qXRPwyTxmGDOhO4obKOiC}{Turbulent flows}

\item\href{https://www.youtube.com/playlist?list=PLp0hSY2uBeP8rhCbecD1Icahfbr6GSZ19}{Mathematical methods (ICTP)}

\item\href{https://www.youtube.com/playlist?list=PLp0hSY2uBeP_7jL7uqlsxDmvimK2q6eF5}{Fluid dynamics (ICTP)}

\item\href{https://www.youtube.com/channel/UCYlD7XynaJIBuYvmXlRBtnQ}{Pr. Dr. Carlos Thompson channel}


- [ ] Proof of mean value theorem (null integral implies null integrand)
- [ ] Derivation of Gauss (divergence) theorem

## Thermodynamics quick review

- When order increases entropy decreases.
- An endothermic process is a process that absorbs heat from its surroundings; on the other hand, an exothermic process releases heat to its surroundings.
## Granular flows

- **Parcel** is a computational particle unit that may be composed of several particles which are all identical sharing a state, which include velocity, size, temperature, etc. See ([[@ORourke2010]]) for details.

- **Cloud** is the term OpenFOAM uses to describe particle flows. Here we will use both `MPPICCloud` and`collidingCloud`, other types being available for reacting or multiphase solvers, such as `thermoCloud`.
## Technological

- **Siwek chamber** is a reactor often used to determine the dispersion of solid fuels for combustion. Validation of simulations can be done through [this](https://www.sciencedirect.com/science/article/abs/pii/S0950423009000801) and [this](https://www.sciencedirect.com/science/article/abs/pii/S0950423014002332) paper. Other than the OpenFOAM [case](https://github.com/OpenFOAM/OpenFOAM-11/tree/master/tutorials/multicomponentFluid/simplifiedSiwek) there is also [this](https://fetchcfd.com/view-project/763-Simplified-Siwek) setup available on Fetch CFD.
## Mathematical

- **Hopf bifurcation**  is a critical point where, as a parameter changes, a system's stability switches and a periodic solution arises. (see [this](https://en.wikipedia.org/wiki/Hopf_bifurcation)).
## Combustion

- [HyChem](https://web.stanford.edu/group/haiwanglab/HyChem/) is an approach for modeling combustion of real liquid fuels by decomposing the problem into a lumped parameter model of evaporation/devolatilization and a detailed or simplified chemical kinetics approach applied to the gas phase. It is available for high-end fuels such as jet fuel and gasoline.

### Condensate fuel combustion

This matter enters a intrinsically multiphysics domain and problem formulation needs to take into account at what level the model is required to act. For liquids, that might include spray droplets formation, evaporation, devolatilization, mass transfer to gas phase, and finally, oxidation kinetics of gas products. In the case of solids, due to high uncertainty and variability in material properties, and complex mass transfer phenomena, one must expect qualitative or semi-quantitative agreement of models and measurements. Furthermore, lumped-parameter modeling is a requirement in the field, making it difficult to be generalized to a physical level as of today.

[[@Saario2005a]] used Ansys Fluent to simulate HFO (heavy-fuel oil) combustion using the standard mixture fraction approach coupled to a Lagrangian particle tracking for evaporating droplets and $k-\epsilon$ turbulence modeling. This is a highly standard industrial application of global combustion simulation from an energy standpoint but lacks the generality of considering a detailed chemistry of gas phase (for instance, for coupling with solid calcination reactions, if that is the case).

[[@Garaniya2012a]] used StarCD to simulate HFO in the context of ship engines. From the same authors ([[@Garaniya2012b]]), we also have the the thermodynamic formulation of the problem.

[[@Nowruzi2014]] successfully simulated a spray jet of HFO with OpenFOAM without accounting for chemistry and combustion. In the absence of a proper PSD (particle size-distribution) this step is required to initialize a simulation, but can hardly be integrated in a reacting flow simulation, which would become overly complex. 

[[@Sanchez2023a]] studied the combustion of biomass with help of OpenFOAM with some semi-quantitative results within 13% from the measurements, what is already considered a very good agreement in the field.

- [ ] Continue the research [here](https://www.jstage.jst.go.jp/result/journal/-char/en?cdjournal=jime&globalSearchKey=heavy+fuel+oil).

## Combustion of heavy oil fuel

[[@Lawn1987]]
