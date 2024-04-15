# Applications to fluid mechanics

## Derivation of continuity equation

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

## Application to advection-diffusion-reaction

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
