# Dimensionless groups

When dealing with reactor models, it is always useful to be able to quickly compute approximate dimensionless numbers for the studied case. In what follows we provide a brief description of these quantities. Definitions might vary according to the author or field of application and here we follow mostly  ([[@Bird2001]]).

## G

### [Grashof](https://en.wikipedia.org/wiki/Grashof_number)

*Franz Grashof (1826-1893) (pronounced "Grahss-hoff). He was professor of applied mechanics in Karlsruhe and one of the founders of the Verein Deutscher Ingenieure in 1856* ([[@Bird2001]]). The Grashof number is the characteristic group occurring in analyses of free convection. It approximates the ratio of the buoyancy to viscous force acting on a fluid, defined as

$$
\mathrm{Gr}=\frac{g\beta(T_s-T_{\infty})L^3}{\nu^2}
$$

and is analogous to Reynolds number in natural convection. Increasing the value of this number above a given threshold promotes buoyancy driven flow.

## K

### Knudsen

Particles mean free path over system characteristic dimension. Division between rarefied gas (Boltzmann) and continuum mechanics (Navier-Stokes).

## N

### [Nusselt](https://en.wikipedia.org/wiki/Nusselt_number)

Ratio of convective to conductive heat transfer at a boundary in a fluid, defined as $\mathrm{Nu}=\frac{hL}{k}$. Often in buoyancy-driven flow analysis it is correlated as $\mathrm{Nu}=a\mathrm{Ra}^b$. A Nusselt number of value one represents heat transfer by pure conduction. Increasing this number implies a laminar conductive-dominant flow and then a convective dominant turbulent flow.

## P

### [Péclet](https://en.wikipedia.org/wiki/Péclet_number)

*Jean-Claude-Eugene Peclet (pronounced "Pay-clay" with the second syllable accented) (1793-1857) authored several books including one on heat conduction*  ([[@Bird2001]]). This number is nothing more than the multiplication of Reynolds and Prandtl or Schmidt numbers. By simplifying factors one easily determines that it represents the ratio of convective by diffusive transport (thermal or species). High $\mathrm{Pe}$ limit represents the plug-flow behavior.  

$$
\mathrm{Pe}_{th} = \mathrm{Re} \mathrm{Pr}\qquad
\mathrm{Pe}_{ch} = \mathrm{Re} \mathrm{Sc}
$$

### [Prandtl](https://en.wikipedia.org/wiki/Prandtl_number)

Ratio of momentum diffusivity to thermal diffusivity $\mathrm{Pr}=\frac{\nu}{\alpha}$. High $\mathrm{Pr}$ indicates that momentum transfer is more effective than heat transfer (oils), while low values (liquid metals) indicate thermal boundary layer is more important than viscous one.

*Ludwig Prandtl (1875-1953) (pronounced "Prahn-t'), who taught in Hannover and Gottingen and later served as the Director of the Kaiser Wilhelm Institute for Fluid Dynamics, was one of the people who shaped the future of his field at the beginning of the twentieth century; he made contributions to turbulent flow and heat transfer, but his development of the boundary-layer equations was his crowning achievement* ([[@Bird2001]]). The dimensionless quantity appear under two forms of interest for the analysis of reactors: its thermal and its chemical versions. In thermal version, this number compares the kinematic viscosity $\nu$ to the thermal diffusivity $\alpha$, which is replaced by species diffusivity in its chemical version, which is more often referred to as Schmidt number. *Ernst Heinrich Wilhelm Schmidt (1892-1975), who taught at the universities in Gdansk, Braunschweig, and Munich (where he was the successor to Nusselt)* ([[@Bird2001]])_. The ratio $\frac{\nu}{\alpha}$ indicates the relative ease of momentum and energy or species transport in flow systems. This dimensionless ratio in thermal form is given by

$$
\mathrm{Pr} = \frac{\nu}{\alpha} = \frac{C_{p} \mu}{k}
$$

If transport properties for a gas are not available, thermal Prandtl number can be estimated at low pressure and non-polar molecules mixtures with help of Eucken formula as

  
$$
\mathrm{Pr} = \frac{C_{p}}{C_{p} + \frac{5}{4}R}
$$
   
## R

### [Rayleigh](https://en.wikipedia.org/wiki/Rayleigh_number)

Product of Grashof $\mathrm{Gr}$ and Prandtl $\mathrm{Pr}$ numbers. Related to the transition from laminar to turbulent in buoyancy-driven flows. Laminar to turbulent is assumed to take place at $10^9$  ([[@Balaji2014]]).

### [Reynolds](https://en.wikipedia.org/wiki/Reynolds_number)

*This dimensionless group is named for Osborne Reynolds (1842-1912), professor of engineering at the University of Manchester. He studied the laminar-turbulent transition, turbulent heat transfer, and theory of lubrication* ([[@Bird2001]]). In general we denote Reynolds number by $\mathrm{Re}$ and it is used to delineate flow regimes. For circular tubes it is defined as:

$$

\mathrm{Re} = \frac{\rho \langle v_{z} \rangle D}{\mu}

$$

where $\langle v_{z} \rangle$ is the average flow velocity in axial direction and $D$ is the tube diameter. For values up 2100 the flow is assumed laminar if steady state is established and density is constant. For more, see ([[@Bird2001]]), Chapter 2.

## S

### [Schmidt](https://en.wikipedia.org/wiki/Schmidt_number)

Schmidt number is the mass diffusion equivalent of Prandtl's. Its range can be much broader than its thermal relative, Prandtl number. This is given by the effects of cross-section and molar weight determining mass diffusivity of gas species. For more, see ([[@Bird2001]])_, Chapter 9.

$$
\mathrm{Sc} = \frac{\nu}{D}
$$

### [Sherwood](https://en.wikipedia.org/wiki/Sherwood_number)

Also called the **mass transfer [Nusselt number](https://en.wikipedia.org/wiki/Nusselt_number "Nusselt number")** is a dimensionless number used in mass-transfer operation. It represents the ratio of the total mass transfer rate (convection + diffusion) to the rate of diffusive mass transport, and is named in honor of [Thomas Kilgore Sherwood](https://en.wikipedia.org/wiki/Thomas_Kilgore_Sherwood "Thomas Kilgore Sherwood").

## W

### [Weber](https://en.wikipedia.org/wiki/Weber_number)

This group is often found in applications of multiphase flows where strongly curved surfaces are present. It represents the ratio of drag forces to cohesion forces, and can be thought of as a measure of the relative importance of the fluid's inertia compared to its surface tension. As reminded by ([[@Amsden1989]]), for $\mathrm{We}>1$, *drop oscillations, distortions, and breakup must be considered*, requiring other sub-models other than simple drag to describe the flow.