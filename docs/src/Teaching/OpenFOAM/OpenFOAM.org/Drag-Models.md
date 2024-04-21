
# Drag models

The simplest drag model supported by discrete phase models in OpenFOAM is the `sphereDrag` option [implemented](https://github.com/OpenFOAM/OpenFOAM-11/blob/master/src/lagrangian/parcel/submodels/Momentum/ParticleForces/Drag/SphereDrag/SphereDragForce.C) as described by ([[@Amsden1989]]) [Amsden1989](@cite). Its application domain is targeted to describe fuel droplet particles in air. The drag coefficient in this case is defined in terms of particle Reynolds number $\mathrm{Re}_{d}$ as

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

> [!todo] The code implementation already provides both $\mu(\hat{T})$ and $\mathrm{Re}_{d}$ computed to the drag model. Additional inspection on how these quantities are evaluated is required. Also note that [Amsden1989](@cite) provides the equations formulated in the radius, not diameter, what might generate some confusion.

This formulation is also used as part of [`distortedSphereDrag` implementation](https://github.com/OpenFOAM/OpenFOAM-11/blob/master/src/lagrangian/parcel/submodels/Momentum/ParticleForces/Drag/DistortedSphereDrag/DistortedSphereDragForce.C) , which makes use of the same $C_{D}$ now referred to as $C_{D,sphere}$ with a modified law accounting for particle distortion in the breakup mechanism of fuel sprays, as discussed by ([[@Liu1993]]) [Liu1993](@cite). The updated drag coefficient is then expressed in terms of drop distortion $y$ from TAB (Taylor Analogy Breakup) model from ([[@Reitz1987]]) [Reitz1987](@cite).

$$
C_{D} = C_{D,sphere}(1+2.632y)
$$

> [!info] The `distortedSphereDrag` model is not available for MPPIC clouds and it is also not used anywhere in the tutorials or source code. For not it does not work yet apparently.







