
## `multicomponentFluid`

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

### Built cases

- [aachenBombSteady](../Cases/aachenBombSteady.md): this case was created as a tentative to simulate a steady spray combustion starting from *aachenBomb* tutorial but after several failures it became a case of its own. The case we have today was built bottom-up, from a simple flow in a box to the level of combustion, including several intermediate steps used to understand how the different options and models interacted. For now its name will remain like this in reference to where it started, but in the future I might come up with a better one.
## `incompressibleDenseParticleFluid`

In OpenFOAM v11 solver module `incompressibleDenseParticleFluid` provides approaches for setting up a transient flow interacting with particles. It handles incompressible isothermal flows with fluid-particle interactions, including cases with dense packing of particles, such as packed beds or initialization of fluidized beds for solution with other approaches.
### Tutorial cases

- Goldschmidt
- GoldschmidtMPPIC
- column
- cyclone
- injectionChannel
### Boundary fields

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
### Creating `cloudProperties`

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
