## Heat conduction in 1D

### Temperature formulation

Heat equation formulated with temperature as dependent variable is stated as:

$$
\rho{}c_{p}\frac{\partial{}T}{\partial{}t}=\nabla\cdotp{}(k\nabla{}T)
$$

Applying the divergence operator and expanding the gradient term for different coordinate systems leads to the following expressions. Notice that coordinate was expressed as $r$ even in cartesian coordinates for homogeneity of notation in what follows.

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

Stated this way the problem can be reformulated as

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
dxdydz & \text{cartesian}\\[12pt]
%
rdr{}d\theta{}dz & \text{cylindrical}\\[12pt]
%
r^2\sin\phi{}dr{}d\theta{}d\phi & \text{spherical}
\end{cases}
$$

#### Cylindrical coordinates

Since the problem is specified to be symmetric around cylinder center (this must include initial conditions), the azimuth and axial components can be moved outside the time and radial integration and lead to a common $2\pi{}z$ factor in both sides of the equation, which cancels out.

$$
\int_{0}^{z}\int_{0}^{2\pi}d\theta{}dz=2\pi{}z
$$

The integration over radial coordinate introduces the $rdr$ factor from the differential volume and we get the final form of the equation to integrate.

$$
\int_{s}^{n}\int_{0}^{\tau}
\rho{}c_{p}\frac{\partial{}T}{\partial{}t}rdtdr=
\int_{0}^{\tau}\int_{s}^{n}
\frac{\partial}{\partial{}r}
\left(rk\frac{\partial{}T}{\partial{}r}\right)drdt
$$

Effecting the inner integration and moving out constant terms from the integrals we have

$$
\rho{}c_{p}\left(T_P^{\tau}-T_P^{0}\right)\int_{s}^{n}rdr=
\int_{0}^{\tau}
\left(rk\frac{\partial{}T}{\partial{}r}\right)\bigg\vert_{s}^{n}dt
$$

Expanding the evaluation of the definite integral between control volume boundaries $s$ and $n$ and performing a Crank-Nicolson integration of the right-hand side one gets:

$$
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
$$

Some coefficients appearing in the above equations are now grouped. Notice that for thermal conductivity $k$ which is a function of temperature, the corresponding time-step temperature must be used for its evaluation. For $\beta_{j}$ the lower case $j$ represents the evaluation at the interface with control volume $J$, what is a very specific notation.

$$
\begin{aligned}
    \alpha_{P}  & = \frac{\rho{}c_{p}}{2\tau}\left(r_n^2-r_s^2\right)\\[8pt]
    \beta_{j}   & = \frac{r_jk_j}{\delta_{P,J}}
\end{aligned}
$$

For conciseness we make $g=(1-f)$ and simplify the expression with the new coefficients as

$$
-f\beta_{s}T_S+
(\alpha_{P}+f\beta_{n}+f\beta_{s})T_P
-f\beta_{n}T_N
=
g\beta_{s}T_S^{0}+
(\alpha_{P}-g\beta_{n}-g\beta_{s})T_P^{0}+
g\beta_{n}T_N^{0}
$$

For the fully implicit time-stepping scheme $f=1$ the expression reduces to

$$
-\beta_{s}T_S+
(\alpha_{P}+\beta_{n}+\beta_{s})T_P
-\beta_{n}T_N
=
\alpha_{P}T_P^{0}
$$

where the following coefficients are identified

$$
\begin{aligned}
    a_{S} & = -\beta_{s}\\[8pt]
    a_{N} & = -\beta_{n}\\[8pt]
    a_{P} & = \alpha_{P}+\beta_{n}+\beta_{s}
\end{aligned}
$$

and the standard format FVM discretization is reached

$$
a_ST_S + a_PT_P + a_NT_N = \alpha_{P}T_P^{0}
$$

A condition for symmetry is that no flux traverses the center of the cylinder at $r=0$. That implies that *south* derivatives in discrete form of the equation must vanish to enforce $\dot{q}(0,t)=0$, so the first row of the problem is modified to

$$
a_1T_P + a_NT_N = \alpha_{P}T_P^{0}\quad\text{where}\quad{}a_1=\alpha_{P}+\beta_{n}
$$

Over the external radius $r=R$ a Robin boundary condition is imposed. In this case the heat flux $\dot{q}=U(T_\infty-T_P)$ takes the place of *north* term in FVM discretization and the equation writes

$$
a_ST_S + a_RT_P = \alpha_{P}T_P^{0}+UT_\infty\quad\text{where}\quad{}a_R=\alpha_{P}+U+\beta_{s}
$$

It must be noted here that $U=Rh$, where the actual heat transfer coefficient is $h$. This should be self-evident from a dimensional analysis.

#### Spherical coordinates

In the case of spherical coordinates we start with a modification in divergence operator as follows


The expression is again integrated over time and the differential volume $dV$.

$$
\int_{V}\int_{0}^{\tau}
\rho{}c_{p}\frac{\partial{}T}{\partial{}t}dtdV=
\int_{0}^{\tau}\int_{V}
\frac{1}{r^2}\frac{\partial}{\partial{}r}
\left(r^2k\frac{\partial{}T}{\partial{}r}\right)dVdt
$$

Since the problem is specified to be symmetric around sphere center (this must include initial conditions), the polar and azimuth components can be moved outside the time and radial integration and lead to a common $4\pi$ factor in both sides of the equation, which cancels out.

$$
\int_{0}^{\pi}\int_{0}^{2\pi}\sin\phi{}d\theta{}d\phi=4\pi
$$

The integration over radial coordinate introduces the $r^2dr$ factor from the differential volume and we get the final form of the equation to integrate.

$$
\int_{s}^{n}\int_{0}^{\tau}
\rho{}c_{p}\frac{\partial{}T}{\partial{}t}r^2dtdr=
\int_{0}^{\tau}\int_{s}^{n}
\frac{\partial}{\partial{}r}
\left(r^2k\frac{\partial{}T}{\partial{}r}\right)drdt
$$

After effecting the inner integration and moving out constant terms from the integrals and expanding the evaluation of the definite integral between control volume boundaries $s$ and $n$ and performing a Crank-Nicolson integration of the right-hand side one gets

$$
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
$$

Some coefficients appearing in the above equations are now grouped. Notice that for thermal conductivity $k$ which is a function of temperature, the corresponding time-step temperature must be used for its evaluation. For $\beta_{j}$ the lower case $j$ represents the evaluation at the interface with control volume $J$, what is a very specific notation.

$$
\begin{aligned}
    \alpha_{P}  & = \frac{\rho{}c_{p}}{3\tau}\left(r_n^3-r_s^3\right)\\[8pt]
    \beta_{j}   & = \frac{r_j^2k_j}{\delta_{P,J}}
\end{aligned}
$$

For conciseness we make $g=(1-f)$ and simplify the expression with the new coefficients as

$$
-f\beta_{s}T_S+
(\alpha_{P}+f\beta_{n}+f\beta_{s})T_P
-f\beta_{n}T_N
=
g\beta_{s}T_S^{0}+
(\alpha_{P}-g\beta_{n}-g\beta_{s})T_P^{0}+
g\beta_{n}T_N^{0}
$$

\subsection{Implicit implementation}

For the fully implicit time-stepping scheme $f=1$ the expression reduces to

$$
-\beta_{s}T_S+
(\alpha_{P}+\beta_{n}+\beta_{s})T_P
-\beta_{n}T_N
=
\alpha_{P}T_P^{0}
$$

where the following coefficients are identified

$$
\begin{aligned}
    a_{S} & = -\beta_{s}\\[8pt]
    a_{N} & = -\beta_{n}\\[8pt]
    a_{P} & = \alpha_{P}+\beta_{n}+\beta_{s}
\end{aligned}
$$

and the standard format FVM discretization is reached

$$
a_ST_S + a_PT_P + a_NT_N = \alpha_{P}T_P^{0}
$$

A condition for symmetry is that no flux traverses the center of the sphere at $r=0$. That implies that *south* derivatives in discrete form of the equation must vanish to enforce $\dot{q}(0,t)=0$, so the first row of the problem is modified to

$$
a_1T_P + a_NT_N = \alpha_{P}T_P^{0}\quad\text{where}\quad{}a_1=\alpha_{P}+\beta_{n}
$$

Over the external radius $r=R$ a Robin boundary condition is imposed. In this case the heat flux $\dot{q}=U(T_\infty-T_P)$ takes the place of *north* term in FVM discretization and the equation writes

$$
a_ST_S + a_RT_P = \alpha_{P}T_P^{0}+UT_\infty\quad\text{where}\quad{}a_R=\alpha_{P}+U+\beta_{s}
$$

It must be noted here that $U=R^2h$, where the actual heat transfer coefficient is $h$. This should be self-evident from a dimensional analysis.

## Enthalpy formulation