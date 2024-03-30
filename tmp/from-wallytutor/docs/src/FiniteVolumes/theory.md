# DryTooling.FiniteVolumes theory

```@contents
Pages = ["theory.md"]
Depth = 3
```

## Heat conduction

### Cylindrical coordinates 1-D

Heat equation formulated with temperature as dependent variable is stated as:

```math
\rho{}c_{p}\frac{\partial{}T}{\partial{}t}=\nabla\cdotp{}(k\nabla{}T)
```

For computing the heating dynamics in a cylinder, using the definition of divergence in cylindrical coordinates and using the gradient expansion over the radius we have

```math
\rho{}c_{p}\frac{\partial{}T}{\partial{}t}=
\frac{1}{r}\frac{\partial}{\partial{}r}
\left(rk\frac{\partial{}T}{\partial{}r}\right)
```

To proceed with the finite volume discretization we perform the integration of both sides of the equation over the relevant variables. The order of integration is chosen according to the nature of the derivative term, as discussed by Patankar [Patankar1980](@cite). Care must be taken in the definition of the space integration, which is non-trivial in cylindrical coordinates systems and must be carried over the differential volume ``dV``.

```math
\int_{V}\int_{0}^{\tau}
\rho{}c_{p}\frac{\partial{}T}{\partial{}t}dtdV=
\int_{0}^{\tau}\int_{V}
\frac{1}{r}\frac{\partial}{\partial{}r}
\left(rk\frac{\partial{}T}{\partial{}r}\right)dVdt
```

This differential volume is given by ``dV=rdr{}d\theta{}dz``. Since the problem is specified to be symmetric around cylinder center (this must include initial conditions), the azimuth and axial components can be moved outside the time and radial integration and lead to a common ``2\pi{}z`` factor in both sides of the equation, which cancels out.

```math
\int_{0}^{z}\int_{0}^{2\pi}d\theta{}dz=2\pi{}z
```

The integration over radial coordinate introduces the ``rdr`` factor from the differential volume and we get the final form of the equation to integrate.

```math
\int_{s}^{n}\int_{0}^{\tau}
\rho{}c_{p}\frac{\partial{}T}{\partial{}t}rdtdr=
\int_{0}^{\tau}\int_{s}^{n}
\frac{\partial}{\partial{}r}
\left(rk\frac{\partial{}T}{\partial{}r}\right)drdt
```

Effecting the inner integration and moving out constant terms from the integrals we have

```math
\rho{}c_{p}\left(T_P^{\tau}-T_P^{0}\right)\int_{s}^{n}rdr=
\int_{0}^{\tau}
\left(rk\frac{\partial{}T}{\partial{}r}\right)\bigg\vert_{s}^{n}dt
```

Expanding the evaluation of the definite integral between control volume boundaries ``s`` and ``n`` and performing a Crank-Nicolson integration of the right-hand side one gets

```math
\begin{aligned}
    \frac{\rho{}c_{p}}{\tau}
    \left(T_P^{\tau}-T_P^{0}\right)
    \left(\frac{r_n^2}{2}-\frac{r_s^2}{2}\right)
    &=f\left[
    r_nk_n\frac{T_N^{\tau}-T_P^{\tau}}{\delta_{P,N}}-
    r_sk_s\frac{T_P^{\tau}-T_S^{\tau}}{\delta_{P,S}}
    \right]\\[8pt]
    &+(1-f)\left[
    r_nk_n\frac{T_N^{0}-T_P^{0}}{\delta_{P,N}}-
    r_sk_s\frac{T_P^{0}-T_S^{0}}{\delta_{P,S}}
    \right]
\end{aligned}
```

Some coefficients appearing in the above equations are now grouped. Notice that for thermal conductivity ``k`` which is a function of temperature, the corresponding time-step temperature must be used for its evaluation. For ``\beta_{j}`` the lower case ``j`` represents the evaluation at the interface with control volume ``J``, what is a very specific notation.

```math
\begin{aligned}
    \alpha_{P}  & = \frac{\rho{}c_{p}}{2\tau}\left(r_n^2-r_s^2\right)\\[8pt]
    \beta_{j}   & = \frac{r_jk_j}{\delta_{P,J}}
\end{aligned}
```

For conciseness we make ``g=(1-f)`` and simplify the expression with the new coefficients as

```math
-f\beta_{s}T_S+
(\alpha_{P}+f\beta_{n}+f\beta_{s})T_P
-f\beta_{n}T_N
=
g\beta_{s}T_S^{0}+
(\alpha_{P}-g\beta_{n}-g\beta_{s})T_P^{0}+
g\beta_{n}T_N^{0}
```

\subsection{Implicit implementation}

For the fully implicit time-stepping scheme ``f=1`` the expression reduces to

```math
-\beta_{s}T_S+
(\alpha_{P}+\beta_{n}+\beta_{s})T_P
-\beta_{n}T_N
=
\alpha_{P}T_P^{0}
```

where the following coefficients are identified

```math
\begin{aligned}
    a_{S} & = -\beta_{s}\\[8pt]
    a_{N} & = -\beta_{n}\\[8pt]
    a_{P} & = \alpha_{P}+\beta_{n}+\beta_{s}
\end{aligned}
```

and the standard format FVM discretization is reached

```math
a_ST_S + a_PT_P + a_NT_N = \alpha_{P}T_P^{0}
```

A condition for symmetry is that no flux traverses the center of the cylinder at ``r=0``. That implies that *south* derivatives in discrete form of the equation must vanish to enforce ``\dot{q}(0,t)=0``, so the first row of the problem is modified to

```math
a_1T_P + a_NT_N = \alpha_{P}T_P^{0}\quad\text{where}\quad{}a_1=\alpha_{P}+\beta_{n}
```

Over the external radius ``r=R`` a Robin boundary condition is imposed. In this case the heat flux ``\dot{q}=U(T_\infty-T_P)`` takes the place of *north* term in FVM discretization and the equation writes

```math
a_ST_S + a_RT_P = \alpha_{P}T_P^{0}+UT_\infty\quad\text{where}\quad{}a_R=\alpha_{P}+U+\beta_{s}
```

It must be noted here that ``U=Rh``, where the actual heat transfer coefficient is ``h``. This should be self-evident from a dimensional analysis.

### Spherical coordinates 1-D

In the case of spherical coordinates we start with a modification in divergence operator as follows

```math
\rho{}c_{p}\frac{\partial{}T}{\partial{}t}=
\frac{1}{r^2}\frac{\partial}{\partial{}r}
\left(r^2k\frac{\partial{}T}{\partial{}r}\right)
```

The expression is again integrated over time and the differential volume ``dV``.

```math
\int_{V}\int_{0}^{\tau}
\rho{}c_{p}\frac{\partial{}T}{\partial{}t}dtdV=
\int_{0}^{\tau}\int_{V}
\frac{1}{r^2}\frac{\partial}{\partial{}r}
\left(r^2k\frac{\partial{}T}{\partial{}r}\right)dVdt
```

This differential volume is given by ``dV=r^2\sin\phi{}dr{}d\theta{}d\phi``. Since the problem is specified to be symmetric around sphere center (this must include initial conditions), the polar and azimuth components can be moved outside the time and radial integration and lead to a common ``4\pi`` factor in both sides of the equation, which cancels out.

```math
\int_{0}^{\pi}\int_{0}^{2\pi}\sin\phi{}d\theta{}d\phi=4\pi
```

The integration over radial coordinate introduces the ``r^2dr`` factor from the differential volume and we get the final form of the equation to integrate.

```math
\int_{s}^{n}\int_{0}^{\tau}
\rho{}c_{p}\frac{\partial{}T}{\partial{}t}r^2dtdr=
\int_{0}^{\tau}\int_{s}^{n}
\frac{\partial}{\partial{}r}
\left(r^2k\frac{\partial{}T}{\partial{}r}\right)drdt
```

After effecting the inner integration and moving out constant terms from the integrals and expanding the evaluation of the definite integral between control volume boundaries ``s`` and ``n`` and performing a Crank-Nicolson integration of the right-hand side one gets

```math
\begin{aligned}
    \frac{\rho{}c_{p}}{\tau}
    \left(T_P^{\tau}-T_P^{0}\right)
    \left(\frac{r_n^3}{3}-\frac{r_s^3}{3}\right)
    &=f\left[
    r_n^2k_n\frac{T_N^{\tau}-T_P^{\tau}}{\delta_{P,N}}-
    r_s^2k_s\frac{T_P^{\tau}-T_S^{\tau}}{\delta_{P,S}}
    \right]\\[8pt]
    &+(1-f)\left[
    r_n^2k_n\frac{T_N^{0}-T_P^{0}}{\delta_{P,N}}-
    r_s^2k_s\frac{T_P^{0}-T_S^{0}}{\delta_{P,S}}
    \right]
\end{aligned}
```

Some coefficients appearing in the above equations are now grouped. Notice that for thermal conductivity ``k`` which is a function of temperature, the corresponding time-step temperature must be used for its evaluation. For ``\beta_{j}`` the lower case ``j`` represents the evaluation at the interface with control volume ``J``, what is a very specific notation.

```math
\begin{aligned}
    \alpha_{P}  & = \frac{\rho{}c_{p}}{3\tau}\left(r_n^3-r_s^3\right)\\[8pt]
    \beta_{j}   & = \frac{r_j^2k_j}{\delta_{P,J}}
\end{aligned}
```

For conciseness we make ``g=(1-f)`` and simplify the expression with the new coefficients as

```math
-f\beta_{s}T_S+
(\alpha_{P}+f\beta_{n}+f\beta_{s})T_P
-f\beta_{n}T_N
=
g\beta_{s}T_S^{0}+
(\alpha_{P}-g\beta_{n}-g\beta_{s})T_P^{0}+
g\beta_{n}T_N^{0}
```

\subsection{Implicit implementation}

For the fully implicit time-stepping scheme ``f=1`` the expression reduces to

```math
-\beta_{s}T_S+
(\alpha_{P}+\beta_{n}+\beta_{s})T_P
-\beta_{n}T_N
=
\alpha_{P}T_P^{0}
```

where the following coefficients are identified

```math
\begin{aligned}
    a_{S} & = -\beta_{s}\\[8pt]
    a_{N} & = -\beta_{n}\\[8pt]
    a_{P} & = \alpha_{P}+\beta_{n}+\beta_{s}
\end{aligned}
```

and the standard format FVM discretization is reached

```math
a_ST_S + a_PT_P + a_NT_N = \alpha_{P}T_P^{0}
```

A condition for symmetry is that no flux traverses the center of the sphere at ``r=0``. That implies that *south* derivatives in discrete form of the equation must vanish to enforce ``\dot{q}(0,t)=0``, so the first row of the problem is modified to

```math
a_1T_P + a_NT_N = \alpha_{P}T_P^{0}\quad\text{where}\quad{}a_1=\alpha_{P}+\beta_{n}
```

Over the external radius ``r=R`` a Robin boundary condition is imposed. In this case the heat flux ``\dot{q}=U(T_\infty-T_P)`` takes the place of *north* term in FVM discretization and the equation writes

```math
a_ST_S + a_RT_P = \alpha_{P}T_P^{0}+UT_\infty\quad\text{where}\quad{}a_R=\alpha_{P}+U+\beta_{s}
```

It must be noted here that ``U=R^2h``, where the actual heat transfer coefficient is ``h``. This should be self-evident from a dimensional analysis.

## Heat conduction formulated in enthalpy

### Spherical coordinates 1-D

Heat equation for a constant density phase using enthalpy as dependent variable is stated as:

```math
\rho{}\frac{\partial{}h}{\partial{}t}=\nabla\cdotp{}(k\nabla{}T)
```

For computing the heating dynamics in a sphere, using the definition of divergence in spherical coordinates and using the gradient expansion over the radius we have

```math
\rho{}\frac{\partial{}h}{\partial{}t}=
\frac{1}{r^2}\frac{\partial}{\partial{}r}
\left(r^2k\frac{\partial{}T}{\partial{}r}\right)
```

This is now integrated over the differential volume ``dV`` as described in previous sections and for conciseness we skip that discussion. The integration over radial coordinate introduces the ``r^2dr`` factor from the differential volume and we get the final form of the equation to integrate.

```math
\int_{s}^{n}\int_{0}^{\tau}
\rho{}\frac{\partial{}h}{\partial{}t}r^2dtdr=
\int_{0}^{\tau}\int_{s}^{n}
\frac{\partial}{\partial{}r}
\left(r^2k\frac{\partial{}T}{\partial{}r}\right)drdt
```

After effecting the inner integrations and moving out constant terms from the integrals and expanding the evaluation of the definite integral between control volume boundaries ``s`` and ``n`` and performing a Crank-Nicolson integration of the right-hand side one gets

```math
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
```

Some coefficients appearing in the above equations are now grouped. Notice that for thermal conductivity ``k`` which is a function of temperature, the corresponding time-step temperature must be used for its evaluation. For ``\beta_{j}`` the lower case ``j`` represents the evaluation at the interface with control volume ``J``, what is a very specific notation.

```math
\begin{align}
\alpha_{P}  & = \frac{\rho{}}{3\tau}\left(r_n^3-r_s^3\right)\\[8pt]
\beta_{j}   & = \frac{r_j^2k_j}{\delta_{P,J}}
\end{align}
```

For conciseness we make ``g=(1-f)`` and simplify the expression with the new coefficients as

```math
\begin{align}
\alpha_{P}h_P^{\tau}-\alpha_{P}h_P^{0}

&=f\beta_{n}T_N^{\tau}-f(\beta_{n}+\beta_{s})T_P^{\tau}-f\beta_{s}T_S^{\tau}
\\[8pt]
&+g\beta_{n}T_N^{0}-g(\beta_{n}+\beta_{s})T_P^{0}-g\beta_{s}T_S^{0}
\end{align}
```

For the fully implicity time-stepping scheme ``f=1`` and making ``\gamma_{j}^{k}=\alpha_{P}^{-1}\beta_{j}^{k}`` one gets

```math
h_P^{\tau}-h_P^{0}-\gamma_{n}^{k}T_N^{\tau,k}+(\gamma_{n}^{k}+\gamma_{s}^{k})T_P^{\tau,k}-\gamma_{s}^{k}T_S^{\tau,k}=0
```

A condition for symmetry is that no flux traverses the center of the sphere at ``r=0``. That implies that *south* derivatives in discretizes form of the equation must vanish to enforce ``\dot{q}(0,t)=0``, so the first row of the problem is modified to

```math
h_P^{\tau}-h_P^{0}-\gamma_{n}^{k}T_N^{\tau,k}+\gamma_{n}^{k}T_P^{\tau,k}=0
```

Over the external radius ``r=R`` a Robin boundary condition is imposed. In this case the heat flux ``\dot{q}=U(T_\infty-T_P)`` takes the place of *north* term in FVM discretization and the equation writes

```math
h_P^{\tau}-h_P^{0}-\alpha_{P}^{-1}UT_{\infty}+(\alpha_{P}^{-1}U+\gamma_{s}^{k})T_P^{\tau,k}-\gamma_{s}^{k}T_S^{\tau,k}=0
```

It must be noted here that ``U=R^2h``, where the actual heat transfer coefficient is ``h``. This should be self-evident from a dimensional analysis.

This is no longer a linear problem and thus cannot be solved directly. We need now an strategy for solving this coupled system of nonlinear equations. The iterative solution of the problem is indicated in the above equations through the introduction of superscript ``k`` indicating the iteration number. One can rework the system as

```math
\begin{align}
-\gamma_{1,2}^{k}T_2^{\tau,k}+\gamma_{1,2}^{k}T_1^{\tau,k}+h_1^{\tau}&=h_1^{0}\\
&\dots \\
-\gamma_{n}^{k}T_N^{\tau,k}+(\gamma_{n}^{k}+\gamma_{s}^{k})T_P^{\tau,k}-\gamma_{s}^{k}T_S^{\tau,k}+h_P^{\tau}&=h_P^{0}\\
&\dots \\
(\alpha_{K}^{-1}U+\gamma_{K-1,K}^{k})T_K^{\tau,k}-\gamma_{K-1,K}^{k}T_{K-1}^{\tau,k}+h_K^{\tau}&=h_K^{0}+\alpha_{K}^{-1}UT_{\infty}
\end{align}
```

It is clear now that for implementation purposes one can store the required coefficients in a tridiagonal matrix ``A^{k}``. Making ``\Gamma_{i}=(\gamma_{i-1,i}+\gamma_{i,i+1})`` and ``\tilde{U}=\alpha_{K}^{-1}U`` we can identify the terms in

```math
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
```

Since the temperature vector ``T^{\tau,k}`` is updated every iteration, the coefficients of ``A^{k}`` must also be updated. With the intermediate vector ``H^{\tau,k}`` the nonlinear problem is rewriten as

```math
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
```

The choice not to write the problem in this format reflects the fact that the term ``H^{\tau,k}`` on the left-hand side is updated on a iteration basis, while the vector ``b^{0}`` is computed once per time step. This last vector was called ``b^{0}`` instead of ``h^{0}`` because it also includes the boundary condition in its last element. This is useful for the conception of the inner and outer loop functions used for solution update.

The traditional approach to solve this sort of problems is to provide a *initial guess* ``T^{\tau,0}=T^{0}``.

```math
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
```

## Mass transfer

### Carbon diffusion in plain iron

```math
\frac{\partial{}x}{\partial{}t}=\nabla\cdotp{}(D(x)\nabla{}T)
```

```math
\frac{\partial{}x}{\partial{}t}=
\frac{\partial}{\partial{}x}
\left(D(x)\frac{\partial{}x}{\partial{}z}\right)
```

```math
\int_{s}^{n}\int_{0}^{\tau}
\frac{\partial{}x}{\partial{}t}dtdz=
\int_{0}^{\tau}\int_{s}^{n}
\frac{\partial}{\partial{}z}
\left(D(x)\frac{\partial{}x}{\partial{}z}\right)dzdt
```

```math
\left(x_P^{\tau}-x_P^{0}\right)(w_{n}-w_{s})=
\int_{0}^{\tau}
\left(D(x)\frac{\partial{}T}{\partial{}r}\right)\bigg\vert_{s}^{n}dt
```

```math
\begin{align}
\left(x_P^{\tau}-x_P^{0}\right)\frac{(w_{n}-w_{s})}{\tau}&=
f\left[
D(x_n)\frac{x_N^{\tau}-x_P^{\tau}}{\delta_{P,N}}-
D(x_s)\frac{x_P^{\tau}-x_S^{\tau}}{\delta_{P,S}}
\right]\\[8pt]
&+(1-f)\left[
D(x_n)\frac{x_N^{0}-x_P^{0}}{\delta_{P,N}}-
D(x_s)\frac{x_P^{0}-x_S^{0}}{\delta_{P,S}}
\right]
\end{align}
```

```math
\begin{align}
\alpha_{P}  & = \frac{(w_{n}-w_{s})}{\tau}\\[8pt]
\beta_{j}   & = \frac{D(x_j)}{\delta_{P,J}}
\end{align}
```

```math
-f\beta_{s}x_S+
(\alpha_{P}+f\beta_{n}+f\beta_{s})x_P
-f\beta_{n}x_N
=
g\beta_{s}x_S^{0}+
(\alpha_{P}-g\beta_{n}-g\beta_{s})x_P^{0}+
g\beta_{n}x_N^{0}
```

```math
-\beta_{s}x_S+
(\alpha_{P}+\beta_{n}+\beta_{s})x_P
-\beta_{n}x_N
=
\alpha_{P}x_P^{0}
```

```math
\begin{align}
a_{S} & = -\beta_{s}\\[8pt]
a_{N} & = -\beta_{n}\\[8pt]
a_{P} & = \alpha_{P}+\beta_{n}+\beta_{s}
\end{align}
```

```math
a_Sx_S + a_Px_P + a_Nx_N = \alpha_{P}x_P^{0}
```

```math
a_1x_P + a_Nx_N = \alpha_{P}x_P^{0}\quad\text{where}\quad{}a_1=\alpha_{P}+\beta_{n}
```

```math
a_Sx_S + a_Rx_P = \alpha_{P}x_P^{0}+hx_\infty\quad\text{where}\quad{}a_R=\alpha_{P}+h+\beta_{s}
```

!!! note "About mass intake calculation"

```math
\rho_{Fe} = \frac{m_{Fe}}{V_{cell}}
```

```math
y_{C} = \frac{m_{C}}{m_{Fe} + m_{C}}
```

```math
m_{Fe+C} = \frac{m_{Fe}}{1 - y_{C}}
```

```math
\rho_{Fe+C} = \rho_{Fe}\frac{1}{1 - y_{C}}
```

```math
\sigma = \int_{0}^{L}\rho(z)y_{C}(z)dz
```

```math
\sigma = \rho_{Fe}\int_{0}^{L}\frac{y_{C}(z)}{1-y_{C}(z)}dz
```

```math
\Delta\sigma = \rho_{Fe}\left(\int_{0}^{L}\frac{y_{C}(z)}{1-y_{C}(z)}dz\right)\biggr\vert_{t=0}^{t=t_{f}}
```
