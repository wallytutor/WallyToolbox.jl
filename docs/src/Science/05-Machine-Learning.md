# Machine Learning

## Data Driven Science and Engineering

Notes based on *Data-Driven Science and Engineering* by Steven L. Brunton and J. Nathan Kurz. Their proposed teaching materials for the book can be found [here](https://www.databookuw.com/page-6/page-14/). Supplementary notes that might be useful for understanding the concepts are provided in course [AMATH301](https://www.youtube.com/@amath3019/videos). The set of open source materials proposed by Kurz's team is found [here](https://faculty.washington.edu/kutz/page5/page23/).

### Singular Value Decomposition

### Fourier and Wavelet Transforms

### Sparsity and Compressed Sensing

### Regression and Model Selection

### Clustering and Classification

### Neural Networks and Deep Learning

### Data-Driven Dynamical Systems

### Linear Control Theory

### Balanced Models for Control

### Data-Driven Control

### Reduced Order Models (ROMs)

#### POD for Partial Differential equations (11.1)

![](https://www.youtube.com/watch?v=I8n8a7q8wLk)

- Proxy models are much faster (lower dimensional)
- Classical discretization (FD) lead to high dimensional schemes
- Model expansion can produce much lower dimension problems
	$$u(x,t) = \sum_{k=1}^{n}a_{k}(t)\psi_k(x)$$
- Idea: plug the modal expansion in the PDE and expand it
- With modal basis the approximations are non-local (global)
- Option 1: Fourier mode expansion - FFT
	$$\psi_k(x)=\frac{1}{L}\exp\left(i\frac{2\pi{}kx}{L}\right)$$
- Goal: try to approximate with $r$ basis instead of large $n$
- Example: try to approximate a Gaussian with FME
- Localized structures require more expansion modes
- Construction similar to spectral methods

#### Optimal Basis Elements (11.2)

![](https://www.youtube.com/watch?v=IlYDfGXL0nI)

- Key idea: simulate the dynamics of the system and save snapshots of time-step solutions to then identify a modal expansion.
- The $\tilde{U}$ POD basis $\psi_k$ found by truncating the SVD matrix $U$ at rank $r$ is the optimal in the $L^2$ sense for the given data.
- Use energy *accumulated* in modes as discussed in Chapter 1 *Singular Value Decomposition* to define the optimal (or good enough) value of $r$.
- The produced ROM is not assured to be safe outside the subspace to which it was identified, though that is fine for several physics.

#### POD and Soliton Dynamics (11.3)

![](https://www.youtube.com/watch?v=2GFDVLzFSJU)

#### Continuous Formulation of POD

![](https://www.youtube.com/watch?v=TRtAkiOdIP4&feature=youtu.be)

#### POD with Symmetries

![](https://www.youtube.com/watch?v=Zl3GjE_C7Vk)

### Interpolation for Parametric ROMs

### Additional materials

![Professor Nick Trefethen, University of Oxford, Linear Algebra Optimization](https://www.youtube.com/watch?v=JngdaWe3-gg)

---
## Physics-Informed Neural Networks

Physics-Informed Neural Networks (PINNs) were first introduced by ([[@Raissi2017]]) in the context of providing data-driven solutions of nonlinear PDE's. In what follows we review the basic concepts and approaches developed in this field during the past few years. Both mathematical and application aspects will be treated in the review.
### Common applications

 As per ([[@Guo2024a]]) the following common applications arise from PINNs:
 
*Predictive modeling and simulations*

- Solution of dynamical systems (even high-dimensional)
- Acceleration of multi-physics simulations

*Optimization and systems control*

- Surrogate models for design optimization
- Inverse design (finding conditions)
- Model predictive control
- Optimal sensor placement
	
*Data-driven insights*

*Data-driven enhancement*

*Monitoring, diagnostic, and health assessment*

### Key Ideas

- *Inject* the prediction values in the governing equations to compose the loss function, enforcing the NN to *obey* the underlying physics.

- There are 2 components in the loss function, the *physical loss* evaluated from the deviation from training data (as is commonplace in NN training) and the PDE loss, which is further divided into *boundary* and *initial condition* losses.

- **Collocation points** is how we call the temporal and spacial coordinates where evaluation of physical properties are computed, corresponding to nodes or cell centers in classical numerical schemes.

### Research opportunities

- Following ([[@Guo2023a]]) citing the work by ([[@Wu2022a]]), resampling and refinement methods could be improved by better PDF's and the use of active or reinforcement learning to improve sampling.

### References

Unraveling the design pattern of physics-informed neural networks:

| Post          | Subject                                                                                  | Main reference(s)       |
| ------------- | ---------------------------------------------------------------------------------------- | ----------------------- |
| ([[@Guo2023a]]) | Resampling of residual points                                                            | ([[@Wu2022a]])            |
| ([[@Guo2023b]]) | Ensemble learning and dynamic solution interval expansion                                | ([[@Haitsiukevich2022a]]) |
| ([[@Guo2023c]]) | Improving performance through gradient boosting                                          | ([[@Fang2023a]])          |
| ([[@Guo2023d]]) | Incorporate the gradient of residual terms as an additional loss term for stiff problems | ([[@Yu2022a]])            |
| ([[@Guo2023e]]) |                                                                                          | ([[@Wang2023a]])          |
| ([[@Guo2023f]]) |                                                                                          | ([[@Wang2022a]])          |
| ([[@Guo2023g]]) |                                                                                          | ([[@Arthurs2021a]])       |

| Reference | Subject |
| ---- | ---- |
| ([[@Lagaris1997a]]) | Seminal work on PINNs. |
| ([[@Antonelo2021a]]) |  |
| ([[@Cai2021a]]) |  |
| ([[@Cuomo2022a]]) |  |
| ([[@Haitsiukevich2022a]]) |  |
| ([[@Karniadakis2021a]]) |  |
| ([[@Lu2019a]]) |  |
| ([[@Lu2021a]]) |  |
| ([[@Nabian2021a]]) |  |
| ([[@Sanyal2022a]]) |  |
| ([[@Wurth2023a]]) | Use of PINNs to solve diffusion equation (heat transfer) during the curing of composites. The paper is more focused in the application than in the implementation. Benchmark against FDM/FEM. |

Other current readings:

- [ ] [Discovering Differential Equations with Physics-Informed Neural Networks and Symbolic Regression](https://towardsdatascience.com/discovering-differential-equations-with-physics-informed-neural-networks-and-symbolic-regression-c28d279c0b4d)

- [ ] [Solving Inverse Problems With Physics-Informed DeepONet: A Practical Guide With Code Implementation](https://towardsdatascience.com/solving-inverse-problems-with-physics-informed-deeponet-a-practical-guide-with-code-implementation-27795eb4f502)

- [ ] [Introduction to Physics-informed Neural Networks](https://towardsdatascience.com/solving-differential-equations-with-neural-networks-afdcf7b8bcc4)

- [ ] [Solving ODE system with PINN](https://discourse.julialang.org/t/solving-ode-system-with-pinn/54750)

- [ ] [Mathematics for Machine Learning and Simulation](https://github.com/Ceyron/machine-learning-and-simulation)

- [ ] [Physics-Informed Neural Networks (PINNs) - An Introduction - Ben Moseley | The Science Circle](https://www.youtube.com/watch?v=G_hIppUWcsc)

- [ ] [Teaching Neural Network to Solve Navier-Stokes Equations](https://www.youtube.com/watch?v=ISp-hq6AH3Q)

- [ ] [Physics-Informed Neural Networks in Julia](https://www.youtube.com/watch?v=Xfb7tqs7gQA)

- [ ] [Scientific AI: Domain Models With Integrated Machine Learning | Chris Rackauckas | JuliaCon 2019](https://www.youtube.com/watch?v=FGfx8CQHdQA&t=925s)
