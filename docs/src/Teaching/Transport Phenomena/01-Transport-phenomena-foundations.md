# Models

## Introduction

Most physical phenomena are actually discrete processes (particles); many phenomena such as heat transfer are actual discrete vibrations in materials. Such systems are described by large systems of coupled ordinary differential equations (ODE's) which quickly become intractable and require numerical solution. Continuum approximations, *i.e.* an averaging process over a representative volume element (RVE), are used to generate a *single* partial differential equation (PDE) from *many* such ODE's. This transformation leads to the concept of *conservation equations*.

Say we have a quantity $b$ such as it represents a number $\#$ concentration of a given physical quantity. Associated to this quantity we have a flux density $\vec{F}$ through the boundaries of the system and a rate production in volume $B_v$ as summarized in the following table.

$$
\begin{align}
b &= \dfrac{\#}{volume}                 &\qquad\text{concentration}  \\
\vec{F} &= \dfrac{\#}{area\cdotp{}time} &\qquad\text{flux density}   \\
B_{v} &= \dfrac{\#}{volume\cdotp{}time} &\qquad\text{production rate}
\end{align}
$$

## General conservation equation

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

## Conservation at system boundaries

So far we have a PDE describing the conservation *inside* the RVE of the system being described. To be able to solve such a system we also need to provide a description of its interactions with its surroundings through the specification of *boundary conditions*.

Assume a volume of thickness $l$ enclosing a boundary $S$ splitting domains $V_{1}$ and $V_{2}$, where discontinuities in properties and all quantities describing the system may be present. We can write the continuity equation for this *thick* boundary as

$$
\frac{d}{dt}\left(\int_{V}bdV\right) = -\int_{\Omega}\vec{n}\cdotp\vec{F}dA+\int_{V}B_{v}dV+\int_{\Omega}B_{s}dA
$$

where the last term has been added to describe the net surface production rate of $b$. Collapsing the volume over the boundary $S$ by taking the limit where $l\to{}0$, it should be evident that all volume integrals in the above vanish. The integral form of boundary condition then simplifies to

$$
\int_{\Omega}\vec{n}\cdotp\vec{F}dA=\int_{\Omega}B_{s}dA
$$

Defining as positive the normal of $S$ pointing outwards $V_{1}$ the integrant on right-hand side can be written as $\vec{n}\left(\vec{F}_{2}-\vec{F}_{1}\right)$. Applying mean value theorem as if all terms where in the same side of the equation (that vanishes overall) leads to the differential form of boundary condition

$$
\vec{n}\left(\vec{F}_{2}-\vec{F}_{1}\right)=B_{s}
$$

This expression has a very straightforward interpretation. If there is no creation rate $B_{s}$ at the interface, flux is continuous across interface; otherwise some arbitrary form of discontinuity should arise, whose form would depend on the volume governing equations at each side of $S$.

> [!todo] The following is something I need to abstract better, although I fully understand the mathematical origins. The argument that it is formulated in the interface reference frame but viewed from the observer frame bothers me.
	
In the case of moving interfaces, the previous formulation needs to account for the relative motion of the boundary and the associated fictitious fluxes that follow it. In the interface reference frame, a relative flux $b_{i}\vec{v}_{s}$ needs to be accounted for, resulting in the modified boundary condition

$$
\vec{n}\left(\vec{F}_{2}-b_{2}\vec{v}_{s}\right)-\vec{n}\left(\vec{F}_{1}-b_{1}\vec{v}_{s}\right)=B_{s}
$$

From this condition it arrises that the magnitude of the normal component of the interface velocity is constrained to the following expression. No matter what physics is governing the movement, this compatibility constraint must be verified.

$$
v_{s} = \frac{\vec{n}\left(\vec{F}_{2}-\vec{F}_{1}\right)-B_{s}}{b_{2}-b_{1}}
$$


