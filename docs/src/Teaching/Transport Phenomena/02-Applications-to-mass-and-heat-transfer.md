# Applications to mass and energy transfer

## Derivation of conservation equations

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

## Formulation of boundary conditions

When dealing with mass and heat transfer in the absence of more *exotic* physics such as electromagnetic effects, a pair of possible descriptions for the boundary fluxes arise; the first must be provided as a closure model for the surface species production rates $R_{s}$ for mass transfer, and heat generation rate $q_{s}$ for heat transfer; the other possibility is to assume the medium outside of the modeled domain is a *reservoir* with constant $b_{\infty}$, the the proper $b$ depending on the phenomena being described. The latter is generally modeled through a constitutive law under the form $\vec{F}=h\left(b-b_{\infty}\right)$, where $h$ is introduced as a transfer coefficient.

$$
-\vec{n}\cdotp{}D\nabla{}c=
\begin{cases}
R_{s}\\[6pt]
h_{m}(c-c_{\infty})
\end{cases}
\qquad\text{and}\qquad
-\vec{n}\cdotp{}k\nabla{}T=
\begin{cases}
q_{s}\\[6pt]
h_{e}(T-T_{\infty})
\end{cases}
$$

The actual meaning of $h$, be for mass transfer $h_{m}$ or energy $h_{e}$ depends of the physics being approximated in the external reservoir. There are specific, generally (semi-)empirical methods for evaluating reasonable values for the analysis of their values; this will be the subject of a future topic because the current context is still focused in general principles.

As a side note, it is worth mentioning here that in analytical methods the $b_{\infty}$ is treated as constant because otherwise analysis could grow exponentially in complexity. For the numerical solution of models it can be often treated as an explicit time function. For instance, imagine a material treatment where pulses of a reacting species are controlled and their concentration in the reactor is known in time; if modeling the solid state uncoupled from the reactor - what is generally the case due to computational time limitations - then the value of $b_{\infty}$ can be provided explicitly, keeping in mind that $h$ can also be a function of this value or surface concentration, depending on the closure model used for the specific simulation.

## Microscopic models of diffusion

The models discussed so far are in fact the macroscopic response to discrete phenomena happening at the atomic and molecular scales. Particles moving randomly due to thermal energy in a fluid or solid follow a path described by a probability density function in steps that in most cases happen at a typical rate due to these thermal fluctuations.

### Diluted mixtures

In the most simple of cases, a *non-interacting particle* in a dilute mixture performs a *random walk*; when many such particles are present in one part of the domain, as we will show later, the resulting gradient of concentration that will be established over a sufficiently large amount of time leads to Fick's law. The terminology was created by [Pearson (1905)](https://www.nature.com/articles/072294b0) for which [Rayleigh (1905)](https://www.nature.com/articles/072318a0) had already found a solution many years beforehand; is also appears in the solution of Brownian motion by [Einstein (1905)](https://myweb.rz.uni-augsburg.de/~eckern/adp/history/einstein-papers/1905_17_549-560.pdf) (translated [here](https://www.damtp.cam.ac.uk/user/gold/pdfs/teaching/old_literature/Einstein1905.pdf)) and turbulent diffusion by [Taylor (1922)](https://courses.washington.edu/mengr537/Lecture_Notes/DiffusionContinuousMovements_TaylorDispersion_ProcMathSocLon1921.pdf).

In the derivation of diffusion equation, following the already mentioned *non-interacting particles* hypothesis, one also needs steps to be *independent, identically distributed* (IDD) and limited by a *finite variance* $\sigma^{2}$, *i.e.* $p(x\pm{}K\sigma)\to{}0$ quickly for some finite $K$.

$$
P_{N+1}(x) = \int{}P_{N}(x-y)p(y)dy = (P_{N} \ast p)(x)
$$

> *The probability $P_{N+1}(x)$ that a particle is found at $x$ at step $N+1$ is equal to the sum of the probabilities $p(y)$ of particles at a distance $y$ from $x$ execute a movement of such amplitude to reach $x$ times the probability of a particle being at the position $P_{N}(x-y)$.*

$$
P_{N} = (P_{0} \ast p \ast p \ast \dots p)(x) = (P_{0} \ast p^{\ast{}N})(x)
$$

$$
\begin{align}
P_{N+1}(x)
&= \int{}\left(P_{N}(x) - yP_{N}^{\prime}(x) + \dfrac{1}{2}y^{2}P_{N}^{\prime\prime}(x)\right)p(y)dy\\
%
&=P_{N}(x)\int{}p(y)dy - P_{N}^{\prime}(x)\int{}yp(y)dy + \dfrac{1}{2}P_{N}^{\prime\prime}(x)\int{}y^{2}p(y)dy\\
%
&=P_{N}(x) - \langle{}y\rangle{}P_{N}^{\prime}(x) + \dfrac{1}{2}\langle{}y^{2}\rangle{}P_{N}^{\prime\prime}(x)
\end{align}
$$

The fourth and last requirement now is that process take place with a *finite mean step $\langle\tau\rangle$*:

$$
\dfrac{P_{N+1}(x) - P_{N}(x)}{\langle\tau\rangle} + \dfrac{\langle{}y\rangle{}}{\langle\tau\rangle}P_{N}^{\prime}(x) = \dfrac{\langle{}y^{2}\rangle{}}{2\langle\tau\rangle}P_{N}^{\prime\prime}(x)
$$

Introducing $c(x-vt,t)\sim{}P_{N}(x-vt)$ with $t=N\langle\tau\rangle$

> [!todo] Finish the additional Taylor expansion from the above expression to get formally to the final result provided below.

$$
\dfrac{\partial{}c}{\partial{}t} + v\dfrac{\partial{}c}{\partial{}x} = D\dfrac{\partial^{2}c}{\partial{}x^{2}}
%
\quad\text{where}\quad{}v=\dfrac{\langle{}y\rangle}{\langle\tau\rangle}
%
\quad\text{and}\quad{}D=\dfrac{\langle{}y^{2}\rangle-\langle{}y\rangle^{2}}{2\langle\tau\rangle}
$$


> [!info] More about this in chapter 4 of ([[@Mehrer2007]]) [Mehrer2007](@cite).

### Concentrated mixtures

On the other limit one finds the concentrated mixtures for which particle-particle interactions intervene on the probability distribution of motion and results obtained through *non-equilibrium thermodynamics* lead to a more complex law.


