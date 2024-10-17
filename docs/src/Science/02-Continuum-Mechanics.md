# Notes by video lecture

## Bazant course

This section organizes notes by lecture, serving as a basis for writing the body of the main text or as complementary material for those willing to follow Bazant's course only. The playlist with all lectures is found in this [link](https://www.youtube.com/playlist?list=PLkdIY_5Zxa7WYkMvY48WQIxSZE-bI7R4w).

### 019 Steady homogeneous reaction-diffusion

#reaction-diffusion

![@video](https://www.youtube.com/embed/0UTKHB_OzAQ)

The scale estimates of penetration depth, boundary flux, and total concentration match the analytical values for steady-state first order linear reaction-diffusion equation submitted to a Dirichlet condition on one side of a semi-infinite medium:

$$
D\dfrac{\partial^{2}C}{\partial{}x^{2}}-kC=0\implies\begin{cases}
\delta     &\sim& \sqrt{\dfrac{D}{k}}\\[12pt]
%
F          &\sim& C_{0}\sqrt{Dk}\\[12pt]
%
C_{\infty} &\sim& C_{0}\sqrt{\dfrac{D}{k}}
\end{cases}
$$

### 020 The Damköhler number

#dimless-damkohler

![@video](https://www.youtube.com/embed/Du4y2lueQWM)

Damköhler number arises from reaction diffusion-equation discussed in lecture 019; we can make the equation dimensionless by making $\tilde{x}=xL^{-1}$, $\Theta=C/C_0$, and dividing everything by $k$, then we can define:

$$
\dfrac{\partial^{2}\Theta}{\partial{}\tilde{x}^{2}}-\mathrm{Da}\Theta=0
%
\quad\text{where}\quad
%
\mathrm{Da}=\frac{k}{D}L^2=\left(\frac{L}{\delta}\right)^2
$$

Limiting cases are:

- $\mathrm{Da}\ll{}1$: fast diffusion limit, length scale $\delta$ is much larger than $L$, so diffusion *crosses* the domain; interaction of diffusion fronts is possible. On may be interested in *e.g* computing the deviation from surface concentration $C_0$ at the body core, $\Delta{}C/C_0\sim{}\sqrt{\mathrm{Da}}$.

- $\mathrm{Da}\gg{1}$: fast reaction-limited transport; a thin layer of reaction products limits the affected depth and diffusion layer is thin beyond that. The relative amount of material that diffuses with respect to the other limiting case is $C/(C_0L^{d-1})\sim{}1/\sqrt{\mathrm{Da}}$.

### 021 Dimensionless equations

![@video](https://www.youtube.com/embed/rrZgH7y15XU)

In fact it is in this lecture that the stripping of dimensions of the equation as presented above in 020 is formalized; *do not even try to solve a problem before making it dimensionless*. The general procedure for making differential operators dimensionless is summarized as follows:

$$
\tilde{x}_{i} = \dfrac{x_{i}}{L_{i}} \implies
%
\begin{cases}
\dfrac{d}{d\tilde{x}_{i}}&=&L_{i}\dfrac{d}{dx_{i}}\\[12pt]
\dfrac{d^{n}}{d\tilde{x}_{i}^{n}}&=&L_{i}^{n}\dfrac{d^{n}}{dx_{i}^{n}}\\[12pt]
\end{cases}
$$

### 022 Symmetric domains

#bessel-function

![@video](https://www.youtube.com/embed/Bi9jWgw_aQ8)

*Always start any modeling with the simplest geometry that captures the basic features of the system being modeled; e.g. when expanding a solution of reaction-diffusion into exponential terms, it is worth noticing that they can be replaced by hyperbolic functions, and since $\sinh$ breaks the symmetry, that term may be eliminated already during constant identification from boundary conditions*.

### 023 Steady convection-diffusion

#dimless-peclet #plug-flow #convection-diffusion

![@video](https://www.youtube.com/embed/LBSzqxjQl2k)

Similarly to lecture 019, here we develop convection-diffusion equation instead; in this case the flux of a transported concentration $C$ is given by the following expression: 

$$
\vec{F}=\vec{u}C-D\nabla{}C
$$

Applying the general conservation law to steady state and incompressible ($\nabla\vec{u}=0$) gives:

$$
\vec{u}\cdotp\nabla{C}-D\nabla^{2}C=0
$$

Using the same approach to make the equation dimensionless as in lecture 019 we have:

$$
\begin{align*}
\dfrac{D}{L^2}\tilde{\nabla}^{2}\Theta-\dfrac{u}{L}\tilde{\nabla}\Theta&=0\\[12pt]
\dfrac{1}{\tau_{d}}\tilde{\nabla}^{2}\Theta-\dfrac{1}{\tau_{c}}\tilde{\nabla}\Theta&=0\\
\end{align*}
$$

where $\tau_c$ is the characteristic convection time and $\tau_d$ the characteristic diffusion time; to reach the final dimensionless equation we can multiply the whole equation by $\tau_d$, what introduces the ratio of diffusion to advection times, commonly called the Péclet number. The results may be summarized as

$$
\tilde{\nabla}^{2}\Theta-\mathrm{Pe}\tilde{\nabla}\Theta=0
\implies
\begin{cases}
\delta      &\sim& \dfrac{D}{u}\\[12pt]
\mathrm{Pe} &=& \dfrac{uL}{D}
\end{cases}
$$

In the limiting case of $\mathrm{Pe}\gg{1}$ diffusion is much slower than convection and the flow can be approximated as purely advective; this characterizes the plug-flow regime.

### 024 Equilibrium drift-diffusion

#diffusion #mobility

![@video](https://www.youtube.com/embed/328868nsFH4)

Particle drift in response to a conservative force field $f$ in a potential $\epsilon$:

$$
f = -\dfrac{d\epsilon}{dx}
\quad\text{then}\quad{}
\bar{u} = Mf
\quad\text{and}\quad{}
F\_{d}=-cM\dfrac{d\epsilon}{dx}
$$

This result can be applied to a general conservation law at steady-state:

$$
F=-cM\dfrac{d\epsilon}{dx}-D\dfrac{dc}{dx}0
$$

This equation can be solved as

$$c(x)=c_{0}\exp\left(-\dfrac{M}{D}\epsilon\right)$$

which is analogous to Boltzmann equilibrium, as stated by Einstein, *i.e.*. $c(x)=c_{0}\exp\left(-\dfrac{\epsilon}{k_{B}T}\right)$; from this arises the equality of the exponential coefficients, known as Einstein relation

$$
D=Mk_{B}T=\dfrac{k_{B}T}{C_{D}}
$$

which is a manifestation of fluctuation-dissipation theorem. This can be extended to the drag of a spherical particle in the theory of Brownian motion, leading to Einstein-Stokes relation, not further discussed here.

> [!todo]  Find and read the reference with the argument of equality by Einstein.

### 025 Thickness of Earths atmosphere

![@video](https://www.youtube.com/embed/aEe10NkgI98)

*This video presents a simple example; there is nothing inherently theoretical I would like to extract from it; recommend it in notes because analysis is interesting.*

### 026 Péclet number

#dimless-peclet #plug-flow #convection-diffusion
 
![@video](https://www.youtube.com/embed/hdkt3S78f8A)

### 027

![@video](https://www.youtube.com/embed/NX_KwqHmXe8)

### 028

![@video](https://www.youtube.com/embed/IuKyK3ysekI)

### 029

![@video](https://www.youtube.com/embed/0BU9KNXCPa0)

### 030

![@video](https://www.youtube.com/embed/b7T32rqo2UI)

### 031

![@video]()

---
## Biddle course on fluid mechanics

### 026 Introduction to compressible flow

![@video](https://www.youtube.com/embed/ewoUwCVa3QY?si=9XWMLZl9VCPmPuFy)


---
## Biddle course on heat transfer

### 015 Introduction to radiation

![@video](https://www.youtube.com/embed/iOwpPodGenA?si=3xdV_BJoykUJpf5j)

- Electromagnetic radiation by a body due to its temperature; spectra range from 0.1 to 100 $\mu{m}$.

- Black body: emits the maximum possible radiation at a given wavelength and absorbs all incident radiation according to black body emissive power $E_{b,\lambda}$.

$$
E_{b,\lambda} = \dfrac{C_{1}}{\lambda^5\left[\exp\left(\dfrac{C_2}{\lambda{}T}\right)-1\right]}
$$

- The distribution $E_{b,\lambda}$ is displaced towards the right as temperature decreases (Wien's shift): as temperature decreases the wavelength at maximum emission moves towards the infrared.

$$
\lambda_{max}T=C_{3}=2897.6\:\mu{m}\cdotp{K}
$$

- The total emissive power $E_{b}$ obtained by integrating its spectral counterpart $E_{b,\lambda}$ gives rise to Stefan-Boltzmann law:

$$
E_{b} = \sigma{}T^4
$$

- Other useful concepts are the *fractional emitted power* up to a given wavelength which can be used to compute the *band emission* over an interval.

### 016 Radiation surface properties

![@video](https://www.youtube.com/embed/GatZqqYXW24?si=nb_LnGQmKfpRlbE9)

- Incident radiation $G$ can be reflected ($\rho$), absorbed ($\alpha$), or transmitted ($\tau$); emitted radiation is always less then the black-body idealization by a factor given by the emissivity ($\epsilon$).

- From energy balance one derives $\rho + \alpha + \tau = 1$; for opaque surfaces $\tau = 0$.

- Radiosity $J$ of an opaque surface is given by $J=\epsilon{}E_{b}+\rho{}G$; the net radiation leaving a surface $q^{\prime\prime}=J-G$. Applying the previous definition $J=\epsilon{}E_{b}+\rho{}G-G=J=\epsilon{}E_{b}-\alpha{}G$.

- The spectral properties $\epsilon_{\lambda}=\alpha_{\lambda}$ if (1) irradiation is diffuse or (2) the surface is diffuse; by diffuse we understand independence on emission/absorption angle. The values $\epsilon=\alpha$ if surface is grey, meaning properties are independent on wavelength $\lambda$ (simple attenuation of black-body).

- Emissivity (or other properties) can be computed by averaging emissive power (or incident radiation, as applicable) over spectral emissivity and computing the value with respect to black-body radiation, or simply

$$
\epsilon =
%
\dfrac{\displaystyle\int_{0}^{\infty}\epsilon_{\lambda}E_{b,\lambda}d\lambda}{E_{b}}
%
\quad\text{where}\quad
%
E_{b} = \displaystyle\int_{0}^{\infty}E_{b,\lambda}d\lambda
$$

### 017 Radiation surface properties examples

![@video](https://www.youtube.com/embed/HPfs_LrqK0E?si=virGFddMJxImbL3t)

- 

### 018

![@video](https://www.youtube.com/embed/CiSA_MQv41I?si=8MH2MJrU7y_YxKxJ)

### 019

![@video](https://www.youtube.com/embed/nz8wA8VCV5I?si=0_63MDit0s9jg74T)

### 020

![@video](https://www.youtube.com/embed/H5sFz47N0rY?si=IhbJF7jRtVf0FzY4)

### 021

![@video](https://www.youtube.com/embed/CUZGj-NxqnU?si=A8Wg6qFZLaZMSgun)

### 022

![@video](https://www.youtube.com/embed/yxHZomAnKqw?si=5Z0K10v_AnXKHGPV)

---
## Bansal course

### 025 Discrete ordinate method

![@video](https://www.youtube.com/embed/8mzKCYdu4xI?si=9RqEO_Ns12zXO9jM)

- Discretize finite angular directions (RTE transformed in a set of simultaneous first order PDE's), so that radiative heat flux and incident radiation are solved only over those directions.

- Depending on the order of the chosen method, a given set of ordinates and weights needs to be chosen to enforce zeroth (total intensity), first (energy conservation), and second (volumetric) moments:

$$
\begin{align}
\displaystyle\int_{4\pi}d\Omega
& = \sum_{i=1}^{n}w_{i}
  = 4\pi
\\[12pt]
%
\displaystyle\int_{4\pi}\hat{s}\;d\Omega
& = \sum_{i=1}^{n}w_{i}\hat{s}_{i}
  = 0
\\[12pt]
%
\displaystyle\int_{4\pi}\hat{s}\cdotp\hat{s}\;d\Omega
& = \sum_{i=1}^{n}w_{i}\hat{s}_{i}\hat{s}_{i}
  = \dfrac{4\pi}{3}\delta
%
\end{align}
$$

- The method is limited by false scattering (beam broadening) due to spatial discretization error; because of angular discretization some cells may not receive radiation.

### 035 Weighted sum of gray gases

![@video](https://www.youtube.com/embed/zTWhyQA5POQ?si=qQxd1os9gA0J__NW)

- 