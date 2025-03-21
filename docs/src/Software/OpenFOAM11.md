# OpenFOAM 11


## Tips and reminders

### General topics

- When converting to OpenFOAM v11 [`viscosityModel`](https://cpp.openfoam.org/v11/viscosityModel_8H.html) instead of `transportModel` in `physicalProperties` files. Currently setting `transportModel Newtonian` does not raise any errors.

- When working with a 2-D extruded mesh (1-cell in thickness), the mass flow rate must be scaled by the width of the domain to keep consistency with what would be expected in 3-D.

### Granular flows

- It is a good idea to set `SOI` to a value higher than zero (dimensioned to match the global time-scale of the problem) so that flow is fully developed before particles arrive.

- If it makes sense to do so, make parameter `U0` in the entries of `injectionModels` of `cloudProperties` identical to the velocity specified for the corresponding path. In most cases this applies, except when modeling a particle jet that originates from another source *outside* of the computational domain.

### Troubleshooting

- `Wedge patch '<name>' is not planar.`: in some cases a warning regarding the precision of face normal vectors might be issued in axisymmetric cases. As [it has been reported by Gerhard Holzinger](https://www.researchgate.net/publication/340174689_OpenFoam_-_a_little_user_manual), when generating the mesh the value of `writePrecision` in `controlDict` might be the cause of this problem. Increasing its value should be enough for solving the problem, and if you want to save disk space with unnecessary precision, it can be decreased back for problem solution. **Notice that if running in parallel, `renumberMesh` and `decomposePar` must be run before falling back to the lower write precision.**

## Solver modules

### `multicomponentFluid`

In OpenFOAM v11 solver module `multicomponentFluid` provides approaches for setting up the simulation of fluids with multiple species, including combustion.

#### Tutorial cases

- DLR_A_LTS
- SandiaD_LTS
- [aachenBomb](https://github.com/OpenFOAM/OpenFOAM-11/tree/master/tutorials/multicomponentFluid/aachenBomb): global combustion kinetics of droplets released in a box.
- counterFlowFlame2D
- counterFlowFlame2DLTS
- counterFlowFlame2DLTS_GRI_TDAC
- counterFlowFlame2D_GRI
- counterFlowFlame2D_GRI_TDAC
- filter
- lockExchange
- membrane
- [nc7h16](https://github.com/OpenFOAM/OpenFOAM-11/tree/master/tutorials/multicomponentFluid/nc7h16): zero dimensional model of homogeneous kinetics.
- [parcelInBox](https://github.com/OpenFOAM/OpenFOAM-11/tree/master/tutorials/multicomponentFluid/parcelInBox): evaporation of a single water particle in a closed box.
- [simplifiedSiwek](https://github.com/OpenFOAM/OpenFOAM-11/tree/master/tutorials/multicomponentFluid/simplifiedSiwek): co-combustion of coal and limestone clouds in Siwek chamber.
- smallPoolFire2D
- smallPoolFire3D
- [verticalChannel](https://github.com/OpenFOAM/OpenFOAM-11/tree/master/tutorials/multicomponentFluid/verticalChannel): water droplet evaporation in a vertical channel.
- [verticalChannelLTS](https://github.com/OpenFOAM/OpenFOAM-11/tree/master/tutorials/multicomponentFluid/verticalChannelLTS): same as [verticalChannel](https://github.com/OpenFOAM/OpenFOAM-11/tree/master/tutorials/multicomponentFluid/verticalChannel) but with local time-stepping.
- [verticalChannelSteady](https://github.com/OpenFOAM/OpenFOAM-11/tree/master/tutorials/multicomponentFluid/verticalChannelSteady): same as [verticalChannel](https://github.com/OpenFOAM/OpenFOAM-11/tree/master/tutorials/multicomponentFluid/verticalChannel) but at steady state.

#### Built cases

- [aachenBombSteady](OpenFOAM11/aachenBombSteady.md): this case was created as a tentative to simulate a steady spray combustion starting from *aachenBomb* tutorial but after several failures it became a case of its own. The case we have today was built bottom-up, from a simple flow in a box to the level of combustion, including several intermediate steps used to understand how the different options and models interacted. For now its name will remain like this in reference to where it started, but in the future I might come up with a better one.

### `incompressibleDenseParticleFluid`

In OpenFOAM v11 solver module `incompressibleDenseParticleFluid` provides approaches for setting up a transient flow interacting with particles. It handles incompressible isothermal flows with fluid-particle interactions, including cases with dense packing of particles, such as packed beds or initialization of fluidized beds for solution with other approaches.

#### Tutorial cases

- Goldschmidt
- GoldschmidtMPPIC
- column
- cyclone
- injectionChannel

#### Boundary fields

Boundary fields in general are almost the same as any case in *pure fluid* simulations but transported quantities must be named by appending the name of the continuous phase specified in  `constant/physicalProperties` as `continuousPhaseName <phase>`. To make it simple let's call this phase `air` in what follows. Notice that pressure file name remains unchanged since it is not really *transported* as you don't have an equation in the form of Reynolds transport theorem for it.

That said, we have things as `k.air` and `U.air`.  The particularity here is that you must provide `phi` for all hydrodynamic solution variables (such as `k.air`, `U.air`) in outlets, what is implicit in single phase flow models. That means that an outlet for velocity should include something as

```C
outlet
{
	type            pressureInletOutletVelocity;
	phi             phi.air;
	inletValue      uniform (0 0 0);
	value           uniform (0 0 0);
}
```

#### Creating `cloudProperties`

Most default values in `solution` dictionary should be fine for typical fluid-particle applications, but for phase interaction it is important to configure `coupled` as `true` so that drag forces are applied to the particles and conversely, particles disturb the fluid. 

We must also turn on `cellValueSourceCorrection`, which will correct cell values using latest transfer information. These elements as given in the following block (you can check the full dictionary in the official OpenFOAM tutorials for other details).

```C
solution
{
	coupled                   true;
	transient                 yes;
	cellValueSourceCorrection on;
	maxCo                     0.7;

	...
}
```

Being a momentum cloud, `MPPICCloud` makes use only of `patchInteractionModel localInteraction` for interaction with the environment and collisions between particles are not taken into account (that is not completely true if you consider the packing effects that can be enabled as *collisions*). Again, it is better to go deeper in the case studies.

The main models for setting up a particle simulation in `constant/cloudProperties`  are the [[Physical Models#Injection models|InjectionModel]] and the [`ParticleForce`](https://cpp.openfoam.org/v11/classFoam_1_1ParticleForce.html) to be used. Notice that when dealing with `incompressibleDenseParticleFluid` the main `ParticleForce` models other than `gravity` are inherited by [`DenseDragForce`](https://cpp.openfoam.org/v11/classFoam_1_1DenseDragForce.html).

## Drag models

The simplest drag model supported by discrete phase models in OpenFOAM is the `sphereDrag` option [implemented](https://github.com/OpenFOAM/OpenFOAM-11/blob/master/src/lagrangian/parcel/submodels/Momentum/ParticleForces/Drag/SphereDrag/SphereDragForce.C) as described by ([[@Amsden1989]]). Its application domain is targeted to describe fuel droplet particles in air. The drag coefficient in this case is defined in terms of particle Reynolds number $\mathrm{Re}_{d}$ as

$$
C_{D} = \begin{cases}
\dfrac{24}{\mathrm{Re}_{d}}\left(1 + \dfrac{\mathrm{Re}_{d}^{2/3}}{6}\right){} &\mathrm{Re}_{d}\le{}1000\\[12pt]
%
0.424{}&\text{otherwise}
\end{cases}
$$

where $\mathrm{Re}_{d}$ is expressed as

$$
\mathrm{Re}_{d} = \dfrac{\rho\vert{}u+u^\prime-v|d}{\mu(\hat{T})}\quad\text{where}\quad\hat{T}=\dfrac{T+2T_{d}}{3}
$$

With these expressions and making $C_{D}^\prime=C_{D}\mathrm{Re}_{d}$ we have the drag force over a particle of diameter $d$ expressed as

$$
\vec{F}=\dfrac{3}{4}\dfrac{m\mu(\hat{T})C_{D}^\prime}{\rho_{d}d^2}
$$

> [!todo] The code implementation already provides both $\mu(\hat{T})$ and $\mathrm{Re}_{d}$ computed to the drag model. Additional inspection on how these quantities are evaluated is required. Also note that ([[@Amsden1989]]) provides the equations formulated in the radius, not diameter, what might generate some confusion.

This formulation is also used as part of [`distortedSphereDrag` implementation](https://github.com/OpenFOAM/OpenFOAM-11/blob/master/src/lagrangian/parcel/submodels/Momentum/ParticleForces/Drag/DistortedSphereDrag/DistortedSphereDragForce.C) , which makes use of the same $C_{D}$ now referred to as $C_{D,sphere}$ with a modified law accounting for particle distortion in the breakup mechanism of fuel sprays, as discussed by ([[@Liu1993]]). The updated drag coefficient is then expressed in terms of drop distortion $y$ from TAB (Taylor Analogy Breakup) model from ([[@Reitz1987]]).

$$
C_{D} = C_{D,sphere}(1+2.632y)
$$

> [!info] The `distortedSphereDrag` model is not available for MPPIC clouds and it is also not used anywhere in the tutorials or source code. For not it does not work yet apparently.

## Combustion models

Models inheriting from [`combustionModel`](https://cpp.openfoam.org/v11/classFoam_1_1combustionModel.html) base class. If you are reading this section you might also be interested in building the case and testing the combustion with OpenSmoke++ or Cantera.

| Type                                                                          | Group       | Description                                                                                                                                       |
| ----------------------------------------------------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| [EDC](https://cpp.openfoam.org/v11/classFoam_1_1combustionModels_1_1EDC.html) | Turbulent   | Eddy Dissipation Concept turbulent combustion model. Probably the most popular approach for simulation of gas combustion in industrial processes. |
| `laminar`                                                                     | Laminar     |                                                                                                                                                   |
| `PaSR`                                                                        | Laminar     |                                                                                                                                                   |
| `FDS`                                                                         | Single-step |                                                                                                                                                   |
| `infinitelyFastChemistry`                                                     | Single-step |                                                                                                                                                   |
| `diffusion`                                                                   | Single-step |                                                                                                                                                   |
| `zoneCombustion`                                                              | Filter      | Enable the reactions within the specified list of cell-zones and set to zero elsewhere.                                                           |
| `noCombustion`                                                                | Dummy       | Dummy combustion model for 'no combustion'.                                                                                                       |

## Cloud models

In OpenFOAM, a *cloud* designate the injection of a secondary phase, generally solid particles or droplets, in a primary continuous carrier phase. The dictionary `cloudProperties` is identified in tutorials related to the following solver modules:

- `incompressibleDenseParticleFluid`
- `incompressibleFluid`
- `multicomponentFluid`
- `multiRegion`

The default version of the dictionary provided [here](https://github.com/OpenFOAM/OpenFOAM-11/blob/master/etc/caseDicts/solvers/lagrangian/cloudProperties) is not yet documented as of OpenFOAM v11 and does not contain any solver specific configurations, so the users must refer to the tutorial cases for setting up their studies.  A post-processing particle tracking function associated to the dictionary is provided [here (untested)](https://github.com/OpenFOAM/OpenFOAM-11/blob/master/etc/caseDicts/postProcessing/solvers/particles).

Currently OpenFOAM implements the following cloud types:

| Cloud                                                                                             | Description                                                                                                                                                          |
| ------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [CollidingCloud](https://cpp.openfoam.org/v11/classFoam_1_1CollidingCloud.html)                   | Adds collisions to clouds.                                                                                                                                           |
| [MomentumCloud](https://cpp.openfoam.org/v11/classFoam_1_1MomentumCloud.html)                     | Templated base class for momentum cloud. Adds particle forces and dispersion, injection, patch interaction, stochastic collision, and surface film models to clouds. |
| [ParcelCloud](https://cpp.openfoam.org/v11/classFoam_1_1ParcelCloud.html)                         | Outermost template for parcel clouds.                                                                                                                                |
| [ThermoCloud](https://cpp.openfoam.org/v11/classFoam_1_1ThermoCloud.html)                         | Templated base class for thermodynamic cloud. Adds heat transfer.                                                                                                    |
| [MPPICCloud](https://cpp.openfoam.org/v11/classFoam_1_1MPPICCloud.html)                           | Adds MPPIC modelling to clouds.                                                                                                                                      |
| [ReactingCloud](https://cpp.openfoam.org/v11/classFoam_1_1ReactingCloud.html)                     | Templated base class for reacting cloud. Supports single phase with variable composition and phase change modeling.                                                  |
| [ReactingMultiphaseCloud](https://cpp.openfoam.org/v11/classFoam_1_1ReactingMultiphaseCloud.html) | Templated base class for multiphase reacting cloud. Supports multiphase composition, devolatilization, and surface reactions.                                        |
| [SprayCloud](https://cpp.openfoam.org/v11/classFoam_1_1SprayCloud.html)                           | Templated base class for spray cloud. Supports atomization and break-up models.                                                                                      |

## [CollidingCloud](https://cpp.openfoam.org/v11/classFoam_1_1CollidingCloud.html) models

### Collision models

These inherit from [CollisionModel](https://cpp.openfoam.org/v11/classFoam_1_1CollisionModel.html).

| Type                                                                          | Description                                                                                                                    |
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| [NoCollision](https://cpp.openfoam.org/v11/classFoam_1_1NoCollision.html)     | Dummy class for the `none` option.                                                                                             |
| [PairCollision](https://cpp.openfoam.org/v11/classFoam_1_1PairCollision.html) | Material properties can be set in detail in sub-dictionary `constantProperties`. Notice that this is computationally expensive |

## [MomentumCloud](https://cpp.openfoam.org/v11/classFoam_1_1MomentumCloud.html) models


### Dispersion models

### Injection models

These inherit from [`InjectionModel`](https://cpp.openfoam.org/v11/classFoam_1_1InjectionModel.html) and implement how particles are injected into a continuous medium. The following table summarizes *some* of the available models.

| Type                                                                          | Description                                                                                                                                                                                                         |
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [coneInjection](https://cpp.openfoam.org/v11/classFoam_1_1ConeInjection.html) | Inject particles in a number of oriented cones. Particles can be generated from a single point or over a disk. Injection can be made at constant velocity, pressure, or with a flow rate and discharge coefficient. |

### Patch interaction models

### Stochastic collision models

### Surface film models
## [ThermoCloud](https://cpp.openfoam.org/v11/classFoam_1_1ThermoCloud.html) models

### Heat transfer models

These inherit from [HeatTransferModel](https://cpp.openfoam.org/v11/classFoam_1_1HeatTransferModel.html). It is possible to provide a [Stefan flow](https://www.sciencedirect.com/topics/engineering/stefan-flow) approximation to the models by using flag `BirdCorrection` in the models dictionaries.

| Type                                                                            | Description                                                                                                                                                    |
| ------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [NoHeatTransfer](https://cpp.openfoam.org/v11/classFoam_1_1NoHeatTransfer.html) | Dummy class for the `none` option.                                                                                                                             |
| [RanzMarshall](https://cpp.openfoam.org/v11/classFoam_1_1RanzMarshall.html)     | The Ranz-Marshall ([[@Ranz1952]]) correlation for heat transfer. For a more recent review, see *e.g.* ([[@Aissa2015a]]). |

## [MPPICCloud](https://cpp.openfoam.org/v11/classFoam_1_1MPPICCloud.html) models

### Packing models

### Isotropy models

### Damping models

## [ReactingCloud](https://cpp.openfoam.org/v11/classFoam_1_1ReactingCloud.html) models

### Phase change models

These inherit from [PhaseChangeModel](https://cpp.openfoam.org/v11/classFoam_1_1PhaseChangeModel.html). 

| Type                                                                                          | Description                                                                                                                |
| --------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| [NoPhaseChange](https://cpp.openfoam.org/v11/classFoam_1_1NoPhaseChange.html)                 | Dummy class for the `none` option.                                                                                         |
| [LiquidEvaporation](https://cpp.openfoam.org/v11/classFoam_1_1LiquidEvaporation.html)         | Liquid evaporation model using ideal gas assumption.                                                                       |
| [LiquidEvaporationBoil](https://cpp.openfoam.org/v11/classFoam_1_1LiquidEvaporationBoil.html) | Liquid evaporation model using ideal gas assumption and includes boiling model based on ([[@Zuo2000a]]). |

## [ReactingMultiphaseCloud](https://cpp.openfoam.org/v11/classFoam_1_1ReactingMultiphaseCloud.html) models

### Devolatilization models

### Surface reaction models

## [SprayCloud](https://cpp.openfoam.org/v11/classFoam_1_1SprayCloud.html) models

### Atomization models

### Breakup models

These inherit from [BreakupModel](https://cpp.openfoam.org/v11/classFoam_1_1BreakupModel.html) for handling particle breakup.

| Type                                                                        | Description                                                                                                                                             |
| --------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [NoBreakup](https://cpp.openfoam.org/v11/classFoam_1_1NoBreakup.html)       |                                                                                                                                                         |
| [PilchErdman](https://cpp.openfoam.org/v11/classFoam_1_1PilchErdman.html)   |                                                                                                                                                         |
| [ReitzDiwakar](https://cpp.openfoam.org/v11/classFoam_1_1ReitzDiwakar.html) | Secondary breakup model adapted to high pressure fuel sprays.                                                                                           |
| [ReitzKHRT](https://cpp.openfoam.org/v11/classFoam_1_1ReitzKHRT.html)       | Secondary breakup model which uses the Kelvin-Helmholtz instability theory to predict the stripped droplets and the Raleigh-Taylor instability as well. |
| [SHF](https://cpp.openfoam.org/v11/classFoam_1_1SHF.html)                   |                                                                                                                                                         |
| [ETAB](https://cpp.openfoam.org/v11/classFoam_1_1ETAB.html)                 | Enhanced TAB model for non-evaporating fuel sprays.                                                                                                     |
| [TAB](https://cpp.openfoam.org/v11/classFoam_1_1TAB.html)                   |                                                                                                                                                         |

## Composition models

These inherit from [CompositionModel](https://cpp.openfoam.org/v11/classFoam_1_1CompositionModel.html) and consists of carrier species (via thermo package), and additional liquids and solids. They are not attached to a type of cloud and each model supports their own cloud types.

| Type                                                                                          | Description                                           | Support                                                                                                                                                |
| --------------------------------------------------------------------------------------------- | ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [NoComposition](https://cpp.openfoam.org/v11/classFoam_1_1NoComposition.html)                 | Dummy class for the `none` option.                    |                                                                                                                                                        |
| [SingleMixtureFraction](https://cpp.openfoam.org/v11/classFoam_1_1SingleMixtureFraction.html) | Templated parcel multi-phase, multi-component class.  | [ReactingMultiphaseCloud](https://cpp.openfoam.org/v11/classFoam_1_1ReactingMultiphaseCloud.html)                                                      |
| [SinglePhaseMixture](https://cpp.openfoam.org/v11/classFoam_1_1SinglePhaseMixture.html)       | Templated parcel single phase, multi-component class. | [SprayCloud](https://cpp.openfoam.org/v11/classFoam_1_1SprayCloud.html), [ReactingCloud](https://cpp.openfoam.org/v11/classFoam_1_1ReactingCloud.html) |
