## Mass transfer

### Carbon diffusion in plain iron

$$
\frac{\partial{}x}{\partial{}t}=\nabla\cdotp{}(D(x)\nabla{}T)
$$

$$
\frac{\partial{}x}{\partial{}t}=
\frac{\partial}{\partial{}x}
\left(D(x)\frac{\partial{}x}{\partial{}z}\right)
$$

$$
\int_{s}^{n}\int_{0}^{\tau}
\frac{\partial{}x}{\partial{}t}dtdz=
\int_{0}^{\tau}\int_{s}^{n}
\frac{\partial}{\partial{}z}
\left(D(x)\frac{\partial{}x}{\partial{}z}\right)dzdt
$$

$$
\left(x_P^{\tau}-x_P^{0}\right)(w_{n}-w_{s})=
\int_{0}^{\tau}
\left(D(x)\frac{\partial{}T}{\partial{}r}\right)\bigg\vert_{s}^{n}dt
$$

$$
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
$$

$$
\begin{align}
\alpha_{P}  & = \frac{(w_{n}-w_{s})}{\tau}\\[8pt]
\beta_{j}   & = \frac{D(x_j)}{\delta_{P,J}}
\end{align}
$$

$$
-f\beta_{s}x_S+
(\alpha_{P}+f\beta_{n}+f\beta_{s})x_P
-f\beta_{n}x_N
=
g\beta_{s}x_S^{0}+
(\alpha_{P}-g\beta_{n}-g\beta_{s})x_P^{0}+
g\beta_{n}x_N^{0}
$$

$$
-\beta_{s}x_S+
(\alpha_{P}+\beta_{n}+\beta_{s})x_P
-\beta_{n}x_N
=
\alpha_{P}x_P^{0}
$$

$$
\begin{align}
a_{S} & = -\beta_{s}\\[8pt]
a_{N} & = -\beta_{n}\\[8pt]
a_{P} & = \alpha_{P}+\beta_{n}+\beta_{s}
\end{align}
$$

$$
a_Sx_S + a_Px_P + a_Nx_N = \alpha_{P}x_P^{0}
$$

$$
a_1x_P + a_Nx_N = \alpha_{P}x_P^{0}\quad\text{where}\quad{}a_1=\alpha_{P}+\beta_{n}
$$

$$
a_Sx_S + a_Rx_P = \alpha_{P}x_P^{0}+hx_\infty\quad\text{where}\quad{}a_R=\alpha_{P}+h+\beta_{s}
$$

!!! note "About mass intake calculation"

$$
\rho_{Fe} = \frac{m_{Fe}}{V_{cell}}
$$

$$
y_{C} = \frac{m_{C}}{m_{Fe} + m_{C}}
$$

$$
m_{Fe+C} = \frac{m_{Fe}}{1 - y_{C}}
$$

$$
\rho_{Fe+C} = \rho_{Fe}\frac{1}{1 - y_{C}}
$$

$$
\sigma = \int_{0}^{L}\rho(z)y_{C}(z)dz
$$

$$
\sigma = \rho_{Fe}\int_{0}^{L}\frac{y_{C}(z)}{1-y_{C}(z)}dz
$$

$$
\Delta\sigma = \rho_{Fe}\left(\int_{0}^{L}\frac{y_{C}(z)}{1-y_{C}(z)}dz\right)\biggr\vert_{t=0}^{t=t_{f}}
$$
