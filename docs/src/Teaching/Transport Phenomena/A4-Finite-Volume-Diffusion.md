# Formulations of heat conduction

## Temperature formulation

Before attempting to derive heat conduction equation in terms of enthalpy, it is worth warming up with its handling in temperature formulation. In this case, the equation is solved directly in terms of temperature as dependent variable which is also used in the governing potential (Fourier's law). This simple case is applicable to many engineering problems. First we formulate the problem with constant thermophysical properties before proceeding to variable density and specific heat.

### Constant thermophysical properties

Heat equation formulated with temperature as dependent variable applied to constant density $\rho$ and specific heat $c_{p}$ can be stated as:

$$
\rho{}c_{p}\frac{\partial{}T}{\partial{}t}=\nabla\cdotp{}(k\nabla{}T)
$$

Applying the divergence operator to the right hand side to a single coordinate and expanding the gradient term for different coordinate systems (cartesian, cylindrical, and spherical) leads to the following expressions. *Notice that coordinate was expressed as $r$ even in cartesian coordinates for homogeneity of notation in what follows.*

$$
\rho{}c_{p}\dfrac{\partial{}T}{\partial{}t}=\begin{cases}
\dfrac{\partial}{\partial{}r}
\left(k\dfrac{\partial{}T}{\partial{}r}\right) & \text{cartesian}\\[12pt]
%
\dfrac{1}{r}\dfrac{\partial}{\partial{}r}
\left(rk\dfrac{\partial{}T}{\partial{}r}\right) & \text{cylindrical}\\[12pt]
%
\dfrac{1}{r^2}\dfrac{\partial}{\partial{}r}
\left(r^2k\dfrac{\partial{}T}{\partial{}r}\right) & \text{spherical}
\end{cases}
$$

Stated this way the problem can be reformulated with a simpler notation as

$$
\rho{}c_{p}\dfrac{\partial{}T}{\partial{}t}=
\dfrac{1}{\beta}\dfrac{\partial}{\partial{}r}
\left(\beta{}k\dfrac{\partial{}T}{\partial{}r}\right)
\qquad\text{where}\qquad\beta=
\begin{cases}
1 & \text{cartesian}\\[12pt]
%
r & \text{cylindrical}\\[12pt]
%
r^2 & \text{spherical}
\end{cases}
$$

To proceed with the finite volume discretization we perform the integration of both sides of the equation over the relevant variables. The order of integration is chosen according to the nature of the derivative term, as discussed by ([[@Patankar1980]]). Care must be taken in the definition of the space integration - which is non-trivial in cylindrical and spherical coordinates systems - and must be carried over the differential volume $dV$.

$$
\int_{V}\int_{0}^{\tau}
\rho{}c_{p}\dfrac{\partial{}T}{\partial{}t}dtdV=
\int_{0}^{\tau}\int_{V}
\frac{1}{\beta}\dfrac{\partial}{\partial{}r}
\left(\beta{}k\dfrac{\partial{}T}{\partial{}r}\right)dVdt
$$

$$
dV=
\begin{cases}
drdydz & \text{cartesian}\\[12pt]
%
rdr{}d\theta{}dz & \text{cylindrical}\\[12pt]
%
r^2\sin\phi{}dr{}d\theta{}d\phi & \text{spherical}
\end{cases}
$$

The components of volume integration not explicitly appearing in the 1-D differential formulation can be moved out of the integrand. For cartesian coordinates the terms leads to the area of the perpendicular plane; for cylindrical coordinates this corresponds to the azimuth and axial components and integration produces a factor $2\pi{}z$; lastly, for spherical coordinates we have the polar and azimuth components moved out and a factor $4\pi$. Since these terms appear in both sides of the equation, they end by cancelling out.

$$
\Phi=
\begin{cases}
A&=\displaystyle\int_{0}^{Z}\int_{0}^{Y}dydz
& \text{cartesian}\\[12pt]
%
2\pi{}z&=\displaystyle\int_{0}^{z}\int_{0}^{2\pi}d\theta{}dz
& \text{cylindrical}\\[12pt]
%
4\pi&=\displaystyle\int_{0}^{\pi}\int_{0}^{2\pi}\sin\phi{}d\theta{}d\phi
& \text{spherical}
\end{cases}
$$

Applying the remaining component of differential volume to the equations lead to the following expressions. *Notice that the meaning of $\beta$ is now clear:  it is simply the factor multiplying $dr$ in the different coordinate systems. It will make the multiplied factor simplify in the right-hand side and appear back in the left-hand side. You should try performing this step by yourself to get a full insight of what is happening here.* So far the equations remain formulated identically.

$$
\int_{s}^{n}\int_{0}^{\tau}
\beta\rho{}c_{p}\dfrac{\partial{}T}{\partial{}t}dtdr=
\displaystyle\int_{0}^{\tau}\int_{s}^{n}
\dfrac{\partial}{\partial{}r}
\left(\beta{}k\dfrac{\partial{}T}{\partial{}r}\right)drdt
$$

In the above expression, instead of integrating over the full domain, we applied limits over the *north* and *south* interfaces of a single finite volume cell (logically using a cell-centered formulation). Because $\beta$ is not time-dependent, we can effect the integration of the inner term and move out constant terms from the integrals, leading to:

$$
\rho{}c_{p}\left(T_P^{\tau}-T_P^{0}\right)\int_{s}^{n}\beta{}dr=
\int_{0}^{\tau}
\left(\beta{}k\frac{\partial{}T}{\partial{}r}\right)\bigg\vert_{s}^{n}dt
$$

For simplicity, in what follows we use an unbounded first-order approximation scheme for space derivatives, *i.e.* they are approximated as:

$$
\frac{\partial{}T}{\partial{}r}\approx\frac{T_{i+1}-T_{i}}{\delta_{i,i+1}}
\qquad\text{where}\qquad{}
\delta_{i,i+1}=r_{i+1}-r_{i}
$$

Applying a general Crank-Nicolson ([[@Crank1996]]) scheme we integrate numerically the right-hand side. The weighting factor $f$ introduces the implicit degree: for $f=1$ we have a fully implicit solution, which $f=0$ represents a standard Euler integration. *Notice that the parenthetical superscript notation $(I)$ does not imply exponentiation, but the instant at which the corresponding values are to be evaluated.*

$$
\frac{\rho{}c_{p}}{\tau}\left(T_P^{\tau}-T_P^{0}\right)\int_{s}^{n}\beta{}dr=
\sum_{I=\{0,\tau\}}
%
f^{(I)}\left[
    \beta_n{}k_n^{(I)}\frac{T_N^{(I)}-T_P^{(I)}}{\delta_{P,N}}-
    \beta_s{}k_s^{(I)}\frac{T_P^{(I)}-T_S^{(I)}}{\delta_{P,S}}
\right]
\quad\text{where}\quad\sum{}f^{(I)}=1
$$

Integration of the remaining space integral is trivial given the definition of $\beta$; to remain generic no matter what coordinate system we introduce the constant $\gamma$. Notice that for cartesian coordinates this corresponds simply to the cell length and for other coordinate systems other relationships associated to cell volume can be interpreted.

$$
\int_{s}^{n}\beta{}dr=\frac{r_n^\gamma}{\gamma}-\frac{r_s^\gamma}{\gamma}
\qquad\text{where}\qquad\gamma=
\begin{cases}
1 & \text{cartesian}\\[12pt]
%
2 & \text{cylindrical}\\[12pt]
%
3 & \text{spherical}
\end{cases}
$$

Putting it all together leads to the final expression:

$$
\frac{\rho{}c_{p}}{\tau}\left(T_P^{\tau}-T_P^{0}\right)
\left(\frac{r_n^\gamma}{\gamma}-\frac{r_s^\gamma}{\gamma}\right)=
\sum_{I=\{0,\tau\}}
f^{I}\left[
    \beta_n{}k_n^{I}\frac{T_N^{I}-T_P^{I}}{\delta_{P,N}}-
    \beta_s{}k_s^{I}\frac{T_P^{I}-T_S^{I}}{\delta_{P,S}}
\right]
$$

Some coefficients appearing in the above equations are now grouped. Notice that for thermal conductivity $k$ which is a function of temperature, the corresponding instant $(I)$ temperature must be used for its evaluation. *For $\kappa_{j}$ the lower case $j$ represents the evaluation at the interface with control volume $J$, a very specific notation used here.*

$$
\begin{aligned}
    \alpha_{P}  & = \frac{\rho{}c_{p}}{\gamma\tau}\left(r_n^\gamma-r_s^\gamma\right)\\[8pt]
    \kappa_{j}   & = \frac{\beta_j{}k_j}{\delta_{P,J}}
\end{aligned}
$$

Using these definitions the equation can be reworked as:

$$
\alpha_{P}\left(T_P^{\tau}-T_P^{0}\right)=
\sum_{I=\{0,\tau\}}
f^{(I)}\left[
    \kappa_{n}^{(I)}\left(T_N^{(I)}-T_P^{(I)}\right)-
    \kappa_{s}^{(I)}\left(T_P^{(I)}-T_S^{(I)}\right)
\right]
$$

To get the matrix form of the problem we start by expanding all products. For conciseness we make $f=f^{(0)}$ and $g=f^{(\tau)}$;  also everything that is evaluated at $t=\tau$ has the superscript dropped; using these ideas the expression is rewritten as:

$$
-f\kappa_{s}T_S+
(\alpha_{P}+f\kappa_{n}+f\kappa_{s})T_P
-f\kappa_{n}T_N
=
g\kappa_{s}^{(0)}T_S^{(0)}+
(\alpha_{P}-g\kappa_{n}^{(0)}-g\kappa_{s}^{(0)})T_P^{(0)}+
g\kappa_{n}^{(0)}T_N^{(0)}
$$

For the fully implicit time-stepping scheme $f=1$ the expression reduces to

$$
-\kappa_{s}T_S+
(\alpha_{P}+\kappa_{n}+\kappa_{s})T_P
-\kappa_{n}T_N
=
\alpha_{P}T_P^{(0)}
$$

where the following coefficients are identified

$$
\begin{aligned}
    a_{S} & = -\kappa_{s}\\[8pt]
    a_{N} & = -\kappa_{n}\\[8pt]
    a_{P} & = \alpha_{P}+\kappa_{n}+\kappa_{s}
\end{aligned}
$$

and the standard finite volume formalism discretization is reached

$$
a_ST_S + a_PT_P + a_NT_N = \alpha_{P}T_P^{0}
$$

The interested reader may wish to derive the boundary conditions to this case. We will refrain from that here because it will be done for the rather more general case in the following sections.

---
### Variable thermophysical properties

To enter the variable thermophysical properties formulation it is worth saying a few words ahead of time about the next subject, the enthalpy formulation. That is because for variable density $\rho(T)$ and specific heat capacity $c_{p}(T)$ under constant pressure the left-hand side of heat equation can be better expressed in terms of enthalpy $H(T)=\rho(T)h(T)=\rho(T){}c_{p}(T)T$. Such a formulation is a requirement when dealing with phase change, such as solidification and melting - where we find discontinuities in enthalpy function; it is also needed in situations where material properties change above a certain degree for which constant properties could no longer be assumed over the foreseeable temperature range.

!!! info

	In practical applications, especially in high-dimensional problems coupled to fluid dynamics, it is worth performing a sensitivity analysis with different sampling points over $\rho(T){}c_{p}(T)$ to determine whether solving the problem with temperature-dependent properties is really required. For most cases this can lead to impressive speed-ups in simulations.

In such formulations, all problem coefficients are required to be assumed temperature-dependent. Although of high practical relevance, most standard engineering textbooks ignore this sort of development.

A recent paper by ([[@Hristov2023]]) tries to handle this sort of formalism, but expanded in temperature units. Let's assume the enthalpy to be related to other variables as $H(T)=\rho(T)h(T)=\rho(T){}c_{p}(T)T$, then


$$
\frac{\partial{}H}{\partial{}t}=
\rho{}c_{p}\frac{\partial{}T}{\partial{}t}+
c_{p}T\frac{\partial{}\rho}{\partial{}t}+
\rho{}T\frac{\partial{}c_{p}}{\partial{}t}
$$

If (continuous) relationships for $\rho(T)$ and $c_{p}(T)$ are available, it can be expanded to

$$
\frac{\partial{}H}{\partial{}t}=
\left(
	\rho{}c_{p}+
	c_{p}T\frac{\partial{}\rho}{\partial{}T}+
	\rho{}T\frac{\partial{}c_{p}}{\partial{}T}
\right)
\frac{\partial{}T}{\partial{}t}
$$

so that heat equation writes with the proper divergence operator as

$$
\left(
	\rho{}c_{p}+
	c_{p}T\frac{\partial{}\rho}{\partial{}T}+
	\rho{}T\frac{\partial{}c_{p}}{\partial{}T}
\right)
\frac{\partial{}T}{\partial{}t}=
\nabla\cdotp{}(k\nabla{}T)
$$

Cite ([[@Shirzad2023]])


#### Boundary conditions

TODO
#### Special cases coordinates

For cylindrical and spherical systems, a condition for symmetry is that no flux traverses the center of the cylinder at $r=0$. That implies that *south* derivatives in discrete form of the equation must vanish to enforce $\dot{q}(0,t)=0$, so the first row of the problem is modified to

$$
a_1T_P + a_NT_N = \alpha_{P}T_P^{0}\quad\text{where}\quad{}a_1=\alpha_{P}+\beta_{n}
$$
$$
a_1T_P + a_NT_N = \alpha_{P}T_P^{0}\quad\text{where}\quad{}a_1=\alpha_{P}+\beta_{n}
$$

Over the external radius $r=R$ a Robin boundary condition is imposed. In this case the heat flux $\dot{q}=U(T_\infty-T_P)$ takes the place of *north* term in FVM discretization and the equation writes

$$
a_ST_S + a_RT_P = \alpha_{P}T_P^{0}+UT_\infty\quad\text{where}\quad{}a_R=\alpha_{P}+U+\beta_{s}
$$

It must be noted here that $U=\beta{}h$, where the actual heat transfer coefficient is $h$. This should be self-evident from a dimensional analysis.

---
!!! danger

	From here on everything is in draft mode.

---
## Enthalpy formulation

Enthalpy formulation is less trivial from the perspective that both sides of the equation do not use the same variable; balance is performed over enthalpy while driving force remains the temperature gradient (as per Fourier's law). In this case an extra step is added to the solution, solve a (generally) nonlinear equation for $T=f(h)$. Quite often this is formulated as a root finding problem stated as $h-\hat{h}(T)=0$, where $h$ represents the integrate enthalpy in a control volume and $\hat{h}$ the provided function relating temperature to enthalpy. The equation is this case is stated as:

$$
\frac{\partial{}(\rho{}h)}{\partial{}t}=\nabla\cdotp{}(k\nabla{}T)
$$



### Spherical coordinates 1-D


For computing the heating dynamics in a sphere, using the definition of divergence in spherical coordinates and using the gradient expansion over the radius we have

$$
\rho{}\frac{\partial{}h}{\partial{}t}=
\frac{1}{r^2}\frac{\partial}{\partial{}r}
\left(r^2k\frac{\partial{}T}{\partial{}r}\right)
$$

This is now integrated over the differential volume ``dV`` as described in previous sections and for conciseness we skip that discussion. The integration over radial coordinate introduces the ``r^2dr`` factor from the differential volume and we get the final form of the equation to integrate.

$$
\int_{s}^{n}\int_{0}^{\tau}
\rho{}\frac{\partial{}h}{\partial{}t}r^2dtdr=
\int_{0}^{\tau}\int_{s}^{n}
\frac{\partial}{\partial{}r}
\left(r^2k\frac{\partial{}T}{\partial{}r}\right)drdt
$$

After effecting the inner integrations and moving out constant terms from the integrals and expanding the evaluation of the definite integral between control volume boundaries ``s`` and ``n`` and performing a Crank-Nicolson integration of the right-hand side one gets

$$
\begin{align}
\frac{\rho{}}{\tau}
\left(h_P^{\tau}-h_P^{0}\right)
\left(\frac{r_n^3}{3}-\frac{r_s^3}{3}\right)
&=f\left[
r_n^2k_n\frac{T_N^{\tau}-T_P^{\tau}}{\delta_{P,N}}-
r_s^2k_s\frac{T_P^{\tau}-T_S^{\tau}}{\delta_{P,S}}
\right]\\[8pt]
&+(1-f)\left[
r_n^2k_n\frac{T_N^{0}-T_P^{0}}{\delta_{P,N}}-
r_s^2k_s\frac{T_P^{0}-T_S^{0}}{\delta_{P,S}}
\right]
\end{align}
$$

Some coefficients appearing in the above equations are now grouped. Notice that for thermal conductivity ``k`` which is a function of temperature, the corresponding time-step temperature must be used for its evaluation. For ``\beta_{j}`` the lower case ``j`` represents the evaluation at the interface with control volume ``J``, what is a very specific notation.

$$
\begin{align}
\alpha_{P}  & = \frac{\rho{}}{3\tau}\left(r_n^3-r_s^3\right)\\[8pt]
\beta_{j}   & = \frac{r_j^2k_j}{\delta_{P,J}}
\end{align}
$$

For conciseness we make ``g=(1-f)`` and simplify the expression with the new coefficients as

$$
\begin{align}
\alpha_{P}h_P^{\tau}-\alpha_{P}h_P^{0}

&=f\beta_{n}T_N^{\tau}-f(\beta_{n}+\beta_{s})T_P^{\tau}-f\beta_{s}T_S^{\tau}
\\[8pt]
&+g\beta_{n}T_N^{0}-g(\beta_{n}+\beta_{s})T_P^{0}-g\beta_{s}T_S^{0}
\end{align}
$$

For the fully implicit time-stepping scheme ``f=1`` and making $\gamma_{j}^{k}=\alpha_{P}^{-1}\beta_{j}^{k}$ one gets

$$
h_P^{\tau}-h_P^{0}-\gamma_{n}^{k}T_N^{\tau,k}+(\gamma_{n}^{k}+\gamma_{s}^{k})T_P^{\tau,k}-\gamma_{s}^{k}T_S^{\tau,k}=0
$$

A condition for symmetry is that no flux traverses the center of the sphere at ``r=0``. That implies that *south* derivatives in discretizes form of the equation must vanish to enforce ``\dot{q}(0,t)=0``, so the first row of the problem is modified to

$$
h_P^{\tau}-h_P^{0}-\gamma_{n}^{k}T_N^{\tau,k}+\gamma_{n}^{k}T_P^{\tau,k}=0
$$

Over the external radius ``r=R`` a Robin boundary condition is imposed. In this case the heat flux ``\dot{q}=U(T_\infty-T_P)`` takes the place of *north* term in FVM discretization and the equation writes

$$
h_P^{\tau}-h_P^{0}-\alpha_{P}^{-1}UT_{\infty}+(\alpha_{P}^{-1}U+\gamma_{s}^{k})T_P^{\tau,k}-\gamma_{s}^{k}T_S^{\tau,k}=0
$$

It must be noted here that ``U=R^2h``, where the actual heat transfer coefficient is ``h``. This should be self-evident from a dimensional analysis.

This is no longer a linear problem and thus cannot be solved directly. We need now an strategy for solving this coupled system of nonlinear equations. The iterative solution of the problem is indicated in the above equations through the introduction of superscript ``k`` indicating the iteration number. One can rework the system as

$$
\begin{align}
-\gamma_{1,2}^{k}T_2^{\tau,k}+\gamma_{1,2}^{k}T_1^{\tau,k}+h_1^{\tau}&=h_1^{0}\\
&\dots \\
-\gamma_{n}^{k}T_N^{\tau,k}+(\gamma_{n}^{k}+\gamma_{s}^{k})T_P^{\tau,k}-\gamma_{s}^{k}T_S^{\tau,k}+h_P^{\tau}&=h_P^{0}\\
&\dots \\
(\alpha_{K}^{-1}U+\gamma_{K-1,K}^{k})T_K^{\tau,k}-\gamma_{K-1,K}^{k}T_{K-1}^{\tau,k}+h_K^{\tau}&=h_K^{0}+\alpha_{K}^{-1}UT_{\infty}
\end{align}
$$

It is clear now that for implementation purposes one can store the required coefficients in a tridiagonal matrix ``A^{k}``. Making ``\Gamma_{i}=(\gamma_{i-1,i}+\gamma_{i,i+1})`` and ``\tilde{U}=\alpha_{K}^{-1}U`` we can identify the terms in

$$
\begin{pmatrix}
H_{1}^{k}    \\
H_{2}^{k}    \\
H_{3}^{k}    \\
\vdots   \\
H_{K-1}^{k}  \\
H_{K}^{k}    \\
\end{pmatrix}
=
\begin{pmatrix}
 \gamma_{1,2}^{k} & -\gamma_{1,2}^{k} &  0                & \dots  & 0 & 0 \\
-\gamma_{1,2}^{k} &  \Gamma_{2}^{k}   & -\gamma_{2,3}^{k} & \dots  & 0 & 0 \\
 0 & -\gamma_{2,3}^{k} &  \Gamma_{3}^{k} & -\gamma_{3,4}^{k}\ddots &  0 &  0 \\
\vdots  & \ddots & \ddots & \ddots & \ddots  & \vdots \\
 0 &  0 & 0 & -\gamma_{K-2,K-1}^{k} &  \Gamma_{K-1}^{k}   & -\gamma_{K-1,K}^{k} \\
 0      &  0     &  0     &  0     & -\gamma_{K-1,K}^{k} & \tilde{U}+\gamma_{K-1,K}^{k} \\
\end{pmatrix}
\begin{pmatrix}
T_{1}^{\tau,k}   \\
T_{2}^{\tau,k}   \\
T_{3}^{\tau,k}   \\
\vdots           \\
T_{K-1}^{\tau,k} \\
T_{N}^{\tau,k}   \\
\end{pmatrix}
$$

Since the temperature vector ``T^{\tau,k}`` is updated every iteration, the coefficients of ``A^{k}`` must also be updated. With the intermediate vector ``H^{\tau,k}`` the nonlinear problem is rewritten as

$$
\begin{pmatrix}
H_{1}^{k}    \\
H_{2}^{k}    \\
H_{3}^{k}    \\
\vdots       \\
H_{K-1}^{k}  \\
H_{K}^{k}    \\
\end{pmatrix}
+
\begin{pmatrix}
h_{1}^{\tau}   \\
h_{2}^{\tau}   \\
h_{3}^{\tau}   \\
\vdots         \\
h_{K-1}^{\tau} \\
h_{K}^{\tau}   \\
\end{pmatrix}
=
\begin{pmatrix}
h_1^{0}                 \\
h_2^{0}                 \\
h_3^{0}                 \\
\vdots                  \\
h_{K-1}^{0}             \\
h_{K}^{0} + \tilde{U}T_{\infty} \\
\end{pmatrix}
$$

The choice not to write the problem in this format reflects the fact that the term ``H^{\tau,k}`` on the left-hand side is updated on a iteration basis, while the vector ``b^{0}`` is computed once per time step. This last vector was called ``b^{0}`` instead of ``h^{0}`` because it also includes the boundary condition in its last element. This is useful for the conception of the inner and outer loop functions used for solution update.

The traditional approach to solve this sort of problems is to provide a *initial guess* ``T^{\tau,0}=T^{0}``.

$$
\begin{align}
h^{\tau,0}               &= b^{0}-A^{0}T^{\tau,0}\\
h(T^{\tau,1})-h^{\tau,0} &= 0\\
\Delta{}T                &= T^{\tau,1}-T^{\tau,0}\\
T^{\tau,1}               &= T^{\tau,0}+(1-\alpha)\Delta{}T\\
\varepsilon^{1}          &= \vert\Delta{}T\vert\\
&\text{repeat}\\
h^{\tau,1}               &= b^{0}-A^{1}T^{\tau,1}\\
h(T^{\tau,2})-h^{\tau,1} &= 0\\
\Delta{}T                &= T^{\tau,2}-T^{\tau,1}\\
T^{\tau,2}               &= T^{\tau,1}+(1-\alpha)\Delta{}T\\
\varepsilon^{2}          &= \vert\Delta{}T\vert\\
&\dots\\
h^{\tau,k}                 &= b^{0}-A^{k}T^{\tau,k}\\
h(T^{\tau,k+1})-h^{\tau,k} &= 0\\
\Delta{}T                  &= T^{\tau,k+1}-T^{\tau,k}\\
T^{\tau,k+1}               &= T^{\tau,k}+(1-\alpha)\Delta{}T\\
\varepsilon^{k+1}          &= \vert\Delta{}T\vert\\
\end{align}
$$
