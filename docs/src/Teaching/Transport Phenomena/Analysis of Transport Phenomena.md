
---
# Models

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
\frac{d}{dt}\left(\int_{V}bdV\right) = -\int_{V}\nabla\cdotp{\vec{F}}dV+\int_{V}B_{v}dV
$$

Assuming an Eulerian reference frame (fixed) to the volume $V$ we can move the time derivative of the above expression inside the left-hand side integral. Rearranging we have

$$
\int_{V}\left(\frac{\partial{}b}{\partial{}t} + \nabla\cdotp{\vec{F}} - B_{v}\right)dV = 0
$$

For a differential volume $dV$ the integrand must be identically zero, from which the PDE arise:

$$
\frac{\partial{}b}{\partial{}t} + \nabla\cdotp{\vec{F}} - B_{v} = 0
$$

---
## Mass and energy diffusion equations

In the nineteenth century, Fick demonstrated *empirically* that the flux density of a species submitted to gradient field responded linearly to its concentration $c$ gradient. Notice here $c$ takes the place of the more general $b$ in the conservation form derivation. In the more general case we should use subindexes for species concentrations and diffusivities, but that will be neglected here.

$$
\vec{F}\propto{}-\nabla{}c
$$

This is actually the simplest form of diffusion modeling and, in general, is valid only in very specific cases, *i.e.* when a single species is being transported in a system without the effect of other components. Introducing a proportionality coefficient $D$, the diffusivity, we have:

$$
\vec{F}=-D\nabla{}c
$$

Using this expression in our conservation equation leads to:
  
$$
\frac{\partial{}c}{\partial{}t} - \nabla\cdotp{\left(D\nabla{}c\right)} - R_{v} = 0
$$

Under the very specific case where there is no volumetric production rate $R_{v}$, *i.e.* no chemical reactions, and constant diffusivity $D$, *i.e.* no composition or space dependence, this simplifies to the well-studied form of the so called Fick's second law:

$$
\frac{\partial{}c}{\partial{}t} = D\nabla^{2}{c}
$$

This expression happens to be isomorph with heat diffusion equation for a constant specific heat medium because Fourier's law is analogous to Fick's first law, leading to the same final mathematical form. Using the thermodynamic definition $dh=\rho{}c_{p}dT$ we have

$$
\frac{\partial{}T}{\partial{}t} = \frac{k}{\rho{}c_{p}}\nabla^{2}{T}
$$

It must be noticed that in the general case, the quantity being transported in heat equation is the enthalpy density $h$ and the potential field is linearized in terms of temperature $T$ through Fourier's equation. Without the constant specific heat simplification and with variable thermal conductivity $k$ it is stated as:

$$
\frac{\partial{}h}{\partial{}t} = \nabla\cdotp\left(k\nabla{T}\right)
$$

Other than for very simple enthalpy-specific heat relationships (such as the constant approximation discussed above), this PDE must be solved numerically with a coupled system of nonlinear equations for computing the field of temperatures in terms of enthalpies. In the above we neglect the volumetric heat production rate, which would be present, *e.g.* in a reacting system or a material undergoing nuclear fission.

## Conservation laws in fluid mechanics

Moving towards a fluid mechanics application, one often needs to express the *continuity* equation for the overall mass of the system and the flowing species.

In this case, term $b$ of previous formulation is replaced by the mass density $\rho_{m}$ of the fluid. Flux is expressed as $\vec{F}_{m}=\vec{v}_{m}\rho_{m}$, where $\vec{v}_{m}$ is the mass averaged velocity. It is useful to introduce this quantity $\vec{v}_{m}$ because in many multi-species formulations it might become difficult to find a single velocity representing the fluid motion.

In the absence of creation rates $B_{v}$ the continuity equation writes

$$
\frac{\partial\rho_{m}}{\partial{}t}+\nabla\cdotp\left(\rho_{m}\vec{v}_{m}\right)=0
$$

For incompressible flows (constant $\rho_{m}$) the time derivative is by definition null and the divergent term can be expanded in terms of its components gradients as

$$
\nabla\cdotp\left(\rho_{m}\vec{v}_{m}\right)=\rho_{m}\nabla\vec{v}_{m}+\vec{v}_{m}\nabla\rho_{m}=0
$$

Since $\rho_{m}$ is constant, this simplifies to the so-called *incompressible fluid continuity equation*

$$
\nabla\vec{v}_{m}=0
$$

Now assume a flow where chemical species $c_{i}$ are advected by the velocity $\vec{v}_{i}$ and diffuse following the negative of their gradient. The flux in this case is given as $F_{i} = c_{i}\vec{v}_{i}-D_{i}\nabla{}c_{i}$. Applying this to the equation of conservation of $c_{i}$ leads to

$$
\frac{\partial{}c_i}{\partial{}t}+\nabla\cdotp\left(c_{i}\vec{v}_{i}-D_{i}\nabla{}c_{i}\right)=R_{v}
$$

Splitting the terms under the divergence operator in right-hand side and reorganizing:

$$
\frac{\partial{}c_i}{\partial{}t}+\nabla\cdotp\left(c_{i}\vec{v}_{i}\right)=\nabla\cdotp\left(D_{i}\nabla{}c_{i}\right)+R_{v}
$$

It is often beneficial to further expand the divergence of convection term so that the equation can be reshaped as follows:

$$
\frac{D{}c_i}{D{}t}=
\frac{\partial{}c_i}{\partial{}t}+
\vec{v}_{i}\nabla{}c_{i}=
\nabla\cdotp\left(D_{i}\nabla{}c_{i}\right)-
c_{i}\nabla\cdotp\vec{v}_{i}
+R_{v}
$$

In this expression the *big-D* notation represents a material or convective derivative. It provides us the behavior of transported quantity in the fluid reference frame, what can be useful for some local analysis. Even more useful than that, under this form we can promptly simplify the remaining terms in the left-hand side for cases of constant diffusivity, incompressible flow, and absence of chemical reactions (in the order of appearance of terms). For numerical solution of transport equations for incompressible flows, using the null divergent of velocity can save us a lot of trouble.

---

## Math appendix

- [ ] Proof of mean value theorem (null integral implies null integrand)
- [ ] Derivation of Gauss (divergence) theorem
