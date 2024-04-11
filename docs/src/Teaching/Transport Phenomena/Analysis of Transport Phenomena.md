
---
## Models

Theses notes intend to provide in a very concise way the mathematical fundamentals of transport phenomena. In this sense, they are devoted to generalities rather than specific closure models. 

Most physical phenomena are actually discrete processes (particles); many phenomena such as heat transfer are actual discrete vibrations in materials. Such systems are described by large systems of coupled ordinary differential equations (ODE's) which quickly become intractable and require numerical solution. Continuum approximations, *i.e.* an averaging process over a representative volume element (RVE), are used to generate a *single* partial differential equation (PDE) from *many* such ODE's. This transformation leads to the concept of *conservation equations*.

Say we have a quantity $b$ such as it represents a number $\#$ concentration of a given physical quantity. Associated to this quantity we have a flux density $\vec{F}$ through the boundaries of the system and a rate production in volume $B_v$ as summarized in the following table.

$$
\begin{align}
b &= \dfrac{\#}{volume}                 &\qquad\text{concentration}  \\
\vec{F} &= \dfrac{\#}{area\cdotp{}time} &\qquad\text{flux density}   \\
B_{v} &= \dfrac{\#}{volume\cdotp{}time} &\qquad\text{production rate}
\end{align}
$$

The most general statement of conservation of this quantity $b$ writes then:

$$
\frac{d}{dt}\left(\int_{V}bdV\right) = -\int_{\Omega}\vec{n}\cdotp\vec{F}dA+\int_{V}B_{v}dV
$$

Using divergence theorem this can be converted into:

$$
\frac{d}{dt}\left(\int_{V}bdV\right) = -\int_{V}\nabla{\vec{F}}dV+\int_{V}B_{v}dV
$$

Assuming an Eulerian reference frame (fixed) to the volume $V$ we can move the time derivative of the above expression inside the left-hand side integral. Rearranging we have

$$
\int_{V}\left(\frac{\partial{}b}{\partial{}t} + \nabla{\vec{F}} - B_{v}\right)dV = 0
$$

For a differential volume $dV$ the integrand must be identically zero, from which the PDE arise:

$$
\frac{\partial{}b}{\partial{}t} + \nabla{\vec{F}} - B_{v} = 0
$$


### Diffusion equation

In the nineteenth century, Fick demonstrated *empirically* that the flux density of a species submitted to concentration gradient field responded linearly to its concentration gradient.

$$
\vec{F}\propto{}-\nabla\cdotp{}b
$$

This is actually the simplest form of diffusion modeling and, in general, is valid only in very specific cases, *i.e.* when a single species is being transported in a system without the effect of other components. Introducing a proportionality coefficient $D$, the diffusivity, we have:

$$
\vec{F}=-D\nabla\cdotp{}b
$$

Using this expression in our conservation equation leads to:

$$
\frac{\partial{}b}{\partial{}t} - \nabla{\left(D\nabla\cdotp{}b\right)} - B_{v} = 0
$$

Under the very specific case where there is no production rate $B_{v}$, *i.e.* no chemical reactions, and constant diffusivity $D$, *i.e.* no composition or space dependence, this simplifies to the well-studied form of the so called Fick's second law:

$$
\frac{\partial{}b}{\partial{}t} = D\nabla^{2}{b}
$$

This expression happens to be isomorph with heat diffusion equation for a constant specific heat medium because Fourier's law is analogous to Fick's first law, leading to the same final mathematical form. Using the thermodynamic definition $dh=\rho{}c_{p}dT$ we have

$$
\frac{\partial{}T}{\partial{}t} = \frac{k}{\rho{}c_{p}}\nabla^{2}{T}
$$

It must be noticed that in the general case, the quantity being transported in heat equation is the enthalpy density $h$ and the potential field is linearized in terms of temperature $T$ through Fourier's equation. Without the constant specific heat simplification and with variable thermal conductivity $k$ it is stated as:

$$
\frac{\partial{}h}{\partial{}t} = \nabla\left(k\nabla\cdotp{T}\right)
$$

Other than for very simple enthalpy-specific heat relationships (such as the constant approximation discussed above), this PDE must be solved numerically with a coupled system of nonlinear equations for computing the field of temperatures in terms of enthalpies. In the above we neglect the volumetric heat production rate, which would be present, *e.g.* in a reacting system or a material undergoing nuclear fission. 

---

## Math appendix

- [ ] Proof of mean value theorem (null integral implies null integrand)
- [ ] Derivation of Gauss (divergence) theorem
