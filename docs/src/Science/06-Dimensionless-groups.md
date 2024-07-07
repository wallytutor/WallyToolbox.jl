# Dimensionless groups

### [Grashof](https://en.wikipedia.org/wiki/Grashof_number)

*Franz Grashof (1826-1893) (pronounced "Grahss-hoff). He was professor of applied mechanics in Karlsruhe and one of the founders of the Verein Deutscher Ingenieure in 1856* ([[@Bird2001]]). The Grashof number is the characteristic group occurring in analyses of free convection. It approximates the ratio of the buoyancy to viscous force acting on a fluid, defined as

$$
\mathrm{Gr}=\frac{g\beta(T_s-T_{\infty})L^3}{\nu^2}
$$

and is analogous to Reynolds number in natural convection. Increasing the value of this number above a given threshold promotes buoyancy driven flow.

### Knudsen

Particles mean free path over system characteristic dimension. Division between rarefied gas (Boltzmann) and continuum mechanics (Navier-Stokes).

### [Péclet](https://en.wikipedia.org/wiki/Péclet_number)

*Jean-Claude-Eugene Peclet (pronounced "Pay-clay" with the second syllable accented) (1793-1857) authored several books including one on heat conduction*  ([[@Bird2001]]). This number is nothing more than the multiplication of Reynolds and Prandtl or Schmidt numbers. By simplifying factors one easily determines that it represents the ratio of convective by diffusive transport (thermal or species). High $\mathrm{Pe}$ limit represents the plug-flow behavior.  

$$
\mathrm{Pe}_{th} = \mathrm{Re} \mathrm{Pr}\qquad
\mathrm{Pe}_{ch} = \mathrm{Re} \mathrm{Sc}
$$

### [Rayleigh](https://en.wikipedia.org/wiki/Rayleigh_number)

Product of Grashof $\mathrm{Gr}$ and Prandtl $\mathrm{Pr}$ numbers. Related to the transition from laminar to turbulent in buoyancy-driven flows. Laminar to turbulent is assumed to take place at $10^9$  ([[@Balaji2014]]).

### [Schmidt](https://en.wikipedia.org/wiki/Schmidt_number)

Schmidt number is the mass diffusion equivalent of Prandtl's. Its range can be much broader than its thermal relative, Prandtl number. This is given by the effects of cross-section and molar weight determining mass diffusivity of gas species. For more, see ([[@Bird2001]])_, Chapter 9.

$$
\mathrm{Sc} = \frac{\nu}{D}
$$

### [Sherwood](https://en.wikipedia.org/wiki/Sherwood_number)

Also called the **mass transfer [Nusselt number](https://en.wikipedia.org/wiki/Nusselt_number "Nusselt number")** is a dimensionless number used in mass-transfer operation. It represents the ratio of the total mass transfer rate (convection + diffusion) to the rate of diffusive mass transport, and is named in honor of [Thomas Kilgore Sherwood](https://en.wikipedia.org/wiki/Thomas_Kilgore_Sherwood "Thomas Kilgore Sherwood").

### [Weber](https://en.wikipedia.org/wiki/Weber_number)

This group is often found in applications of multiphase flows where strongly curved surfaces are present. It represents the ratio of drag forces to cohesion forces, and can be thought of as a measure of the relative importance of the fluid's inertia compared to its surface tension. As reminded by ([[@Amsden1989]]), for $\mathrm{We}>1$, *drop oscillations, distortions, and breakup must be considered*, requiring other sub-models other than simple drag to describe the flow.