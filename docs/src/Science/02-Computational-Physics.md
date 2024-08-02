# Computational Physics

# Molecular Dynamics (MD)

The [Materials Project](https://next-gen.materialsproject.org/) has many interesting for those working on MD and especially [DFT](02-Computational-Physics.md). Theoretical basis can be found in the work by [Hinchliffe](https://www.wiley.com/en-us/Molecular+Modelling+for+Beginners%2C+2nd+Edition-p-9781119964810) which maybe will require some refreshing on the [The Feynman Lectures on Physics](https://www.feynmanlectures.caltech.edu/) to be followed.

Since molecular dynamics is a field essentially related to simulation (there is no MD without simulation!), it is worth listing the major open source projects related to the field, [LAMMPS](https://www.lammps.org), [ESPReSo](https://espressomd.org/wordpress/), and [Gromacs](https://www.gromacs.org/).  Other interesting projects include [HOOMD](http://glotzerlab.engin.umich.edu/hoomd-blue/) and the popular [NAMD](https://www.ks.uiuc.edu/Research/namd/); I have refrained from the last given its greedy licensing scheme. My studies are currently focused in [LAMMPS](../Software/LAMMPS.md) because its fields of application and system portability.

# Density Functional Theory (DFT)

- [Abinit webpage](https://www.abinit.org/)
- [BigDFT](https://l_sim.gitlab.io/bigdft-doc/)
- [CP2K](https://www.cp2k.org/)
- [Dalton/LSDalton](https://daltonprogram.org/)
- [DIRAC webpage](http://www.diracprogram.org/doku.php/)
- [FLEUR webpage](https://www.flapw.de/MaX-6.0/)
- [Quantum Espresso webpage](https://www.quantum-espresso.org/)
- [Siesta](https://siesta-project.org/siesta/)
- [Yambo](http://www.yambo-code.org/)


# Finite Element Method

Personal path towards mastering finite element method (FEM).

The goal of this repository is to track my learning path of finite element method. As a secondary goal, all tools included in the study must be open source with a permissive license. Finally, I will study again some subjects related to the physics of applied problems that will be solved through FEM.

<details>
<summary>
It is not my first time trying this and I learned a few things in the past failures. Below I expose my reasoning about the choices I make today for structuring this repository and its future.
</summary>
<br>

1. During my college years I almost neglected solid mechanics and statics. It happens that most quality materials for learning FEM are applied to structural analysis (because that is the most import numerical method in that field). Because my applied work is mostly related to fluids and heat transfer, doing some bibliographic research I found the books by [Lewis et al.](https://www.wiley.com/en-fr/Fundamentals+of+the+Finite+Element+Method+for+Heat+and+Fluid+Flow-p-9780470014165) and its newer edition by [Nithiarasu et al.](https://www.wiley.com/en-fr/Fundamentals+of+the+Finite+Element+Method+for+Heat+and+Mass+Transfer%2C+2nd+Edition-p-9781118535431) adapted to my expertise level.

1. From a mathematical standpoint the most accessible material I have studied so far is the draft book by [H. P. Langtangen and K.-A. Mardal](https://hplgit.github.io/fem-book/doc/web/). Unfortunatelly the main author deceased just after the release of the final draft and the material remained unfinished. That is not really a blocking point because the content is pretty much finished from a non-specialist standpoint. Furthermore, its exercises where converted into notebooks by [Mojtaba Barzegari](https://github.com/mbarzegary/finite-element-intro) and the material is quite accessible.

1. During the years I have tested several FEM packages and libraries. The most promissing FEM package in the open source world is certainly [FEniCSx](https://fenicsproject.org/), but it comes with the disadvantage of requiring Linux/WSL and having an unclear documentation. In terms of power I couldn't find anything comparable to [MOOSE](https://mooseframework.inl.gov/index.html) - if you see the list of developer labs it becomes pretty clear why - but it is something to experienced FEM users since it requires low level implementation of the problems in C++. [Elmer](https://www.csc.fi/web/elmer) could be a candidate package for learning the practice, but for going into the mathematics of FEM it is not the right tool. Next comes [Kratos](https://github.com/KratosMultiphysics/Kratos) but its documentation is messy and things moved around too much over the years. Finally we have [FreeFEM++](https://freefem.org/). It is a pretty old software what means that it outlived most of the other applications and now is very stable. What is interesting about FreeFEM++ is its portability across operating systems and good documentation. In what follows I will stick with FreeFEM++ and later with FEniCSx.

1. Learning a numerical method for continuum mechanics is essentially useless without the capacity to apply it to real world geometries. Unfortunatelly the field of open source CAD is very poor so we have just a few options. Although [Gmsh](https://gmsh.info/doc/texinfo/gmsh.html) is pretty powerfull with respect to its meshing capabilities, conceiving the geometry with the software can quickly scale to *trigonometry hell* level. I have been using the software for many years for 2D cases but systematically fall back to proprietary software when things become complex. In this study I intend to reach a *sorcerer Gmsh* mastery level. It can be complemented by STL files generation with [Blender](https://www.blender.org/) or CAD in [FreeCAD](https://www.freecad.org/).

1. Advanced post-processing is also a *must*, so we will also follow some tutorials to improve [ParaView](https://www.paraview.org/) skills.
</details>

## Software version

While doing such an ambitious study, it is important to stick with software versions.

In what follows we will be using exclusivelly the following software:

- Gmsh 4.11.1
- FreeFEM++ 4.13
- ParaView 5.10.1
- FreeCAD 0.21.1
- Blender 4.0.2

Processing utilities in Julia and/or Python will have their own versioning so they are not reported here.

## Study planning

Because it can become frustrating to progress in the study and not be able to apply the knowledge to real cases, we will start by growing competencies in geometry and meshing before entering the mathematical and software aspects. Planning is idealized in a weekly basis.

Because of its simpler format, Nithiarasu's book is followed at a faster pace than Langtangen's. At some point the subjects being studied at Langtangen's book will become a review and deepening of previously studied subjects.

For materials that were not cited above, here follow the links:

- [Engineering Statics | Lectures](https://www.youtube.com/playlist?list=PLLSzlda_AXa36lD_wsg40uhbyvkj4x6er)
- [Intro to Continuum Mechanics | Seminars](https://www.youtube.com/playlist?list=PLLSzlda_AXa0SQuj_GoTW3DUv4uDE8wkm)
- [Solid Mechanics | Theory](https://www.youtube.com/playlist?list=PLLSzlda_AXa1wN1EfoYdWZf31f_BOnWeY)
- [Intro to the Finite Element Method | Lectures](https://www.youtube.com/playlist?list=PLLSzlda_AXa3yQEJAb5JcmsVDy9i9K_fi)

The book series by O.C. Zienkiewicz and collaborators will be included later since its in depth and general approach trespasses my current capacity on how to organize their study. After learning the basics over the next months I hope to be able to skecth a learning strategy to go over those books and feed this time-line.

Complementary studies to take at any time during the series:

- The first 4 videos of [this](https://www.youtube.com/playlist?list=PLjEaoINr3zgEPv5y--4MKpciLaoQYZB1Z) playlist.
- The first 5 videos of [this](https://www.youtube.com/playlist?list=PLjEaoINr3zgHJVJF3T3CFUAZ6z11jKg6a) playlist.
- This [video](https://www.youtube.com/watch?v=LKERWfQYa-8) and the sequence (no playlist created).
- This [video](https://www.youtube.com/watch?v=cBflsSEJQ9E) with a full Gmsh introduction.

Review and in-depth studies for solidification of knowledge:

- [Continuum physics](https://www.youtube.com/playlist?list=PLJhG_d-Sp_JHvh47eZ8fSuUCUdp86i__y)
- [Introduction to finite element methods](https://www.youtube.com/playlist?list=PLJhG_d-Sp_JHKVRhfTgDqbic_4MHpltXZ)
- [Wolfgang Bangerth's video lectures](https://www.math.colostate.edu/~bangerth/videos.html)

### Week 1

- [ ] Follow 21 tutorials provided with Gmsh
- [x] Follow [this](https://www.youtube.com/playlist?list=PL4eMS3gkRNXcvNnawxzuzRlFDa5CseoQV) short course on FreeCAD.
- [x] Follow [this](https://www.youtube.com/playlist?list=PL6fjYEpJFi7Wu9ZFlak7r0QgrF0aNi8H1) tutorial on FreeFEM without practicing.
- [x] Nithiarasu (2016), chapters 1 and 2
- [x] Langtangen (2016), chapters 1 and 2 (1/3)
- [ ] Barzegari's notebook associated to Langtangens chapter 1
- [ ] Engineering Statics | Lectures videos 1 to 10
- [ ] Intro to the Finite Element Method | Lectures 1

### Week 2

- [ ] Nithiarasu (2016), chapter 3 (1/2)
- [ ] Langtangen (2016), chapter 2 (2/3) 
- [ ] FreeFEM++ guided tutorials 2.1 to 2.9
- [ ] Engineering Statics | Lectures videos 11 to 14
- [ ] Solid Mechanics | Theory (all at once)
- [ ] Intro to Continuum Mechanics | Seminars 1
- [ ] Intro to the Finite Element Method | Lectures 2

### Week 3

- [ ] Nithiarasu (2016), chapter 3 (2/2)
- [ ] Langtangen (2016), chapter 2 (3/3) 
- [ ] Barzegari's  notebook associated to Langtangens chapter 2
- [ ] FreeFEM++ guided tutorials 2.10 to 2.13
- [ ] Engineering Statics | Lectures videos 15 to 18
- [ ] Intro to Continuum Mechanics | Seminars 2
- [ ] Intro to the Finite Element Method | Lectures 3

### Week 4

- [ ] Nithiarasu (2016), chapter 4
- [ ] Langtangen (2016), chapter 3 (1/5) 
- [ ] FreeFEM++ guided tutorials 2.14 to 2.19
- [ ] Engineering Statics | Lectures videos 19 to 22
- [ ] Intro to Continuum Mechanics | Seminars 3
- [ ] Intro to the Finite Element Method | Lectures 4
- [ ] Follow [these](https://www.youtube.com/playlist?list=PL6fjYEpJFi7W6ayU8zKi7G0-EZmkjtbPo) ParaView tutorials.

### Week 5

- [ ] Nithiarasu (2016), chapter 5
- [ ] Langtangen (2016), chapter 3 (2/5) 
- [ ] Engineering Statics | Lectures videos 23 to 24
- [ ] Intro to Continuum Mechanics | Seminars 4
- [ ] Intro to the Finite Element Method | Lectures 5
- [ ] Follow [these](https://www.youtube.com/playlist?list=PLvkU6i2iQ2fpcVsqaKXJT5Wjb9_ttRLK-) ParaView tutorials.

### Week 6

- [ ] Nithiarasu (2016), chapter 6
- [ ] Langtangen (2016), chapter 3 (3/5) 
- [ ] Intro to Continuum Mechanics | Seminars 5
- [ ] Intro to the Finite Element Method | Lectures 6
- [ ] Follow [this](https://www.youtube.com/watch?v=aVlOcc828uM) ParaView seminar.

### Week 7

- [ ] Nithiarasu (2016), chapter 7 (1/3)
- [ ] Langtangen (2016), chapter 3 (4/5) 
- [ ] Intro to Continuum Mechanics | Seminars 6
- [ ] Intro to the Finite Element Method | Lectures 7
- [ ] Follow [this](https://www.youtube.com/watch?v=fGcD4dC6Pug&t=5s) ParaView seminar.

### Week 8

- [ ] Nithiarasu (2016), chapter 7 (2/3)
- [ ] Langtangen (2016), chapter 3 (5/5) 
- [ ] Barzegari's  notebook associated to Langtangens chapter 3
- [ ] Intro to Continuum Mechanics | Seminars 7
- [ ] Intro to the Finite Element Method | Lectures 8
- [ ] Follow [this](https://www.youtube.com/watch?v=7WMaHXLK6No) ParaView seminar.

### Week 9

- [ ] Nithiarasu (2016), chapter 7 (3/3)
- [ ] Langtangen (2016), chapter 4 (1/2) 
- [ ] Intro to Continuum Mechanics | Seminars 8
- [ ] Intro to the Finite Element Method | Lectures 9
- [ ] Follow [this](https://www.youtube.com/watch?v=knWz0LCSgic) ParaView seminar.

### Week 10

- [ ] Nithiarasu (2016), chapter 8
- [ ] Langtangen (2016), chapter 4 (2/2) 
- [ ] Barzegari's  notebook associated to Langtangens chapter 4
- [ ] Intro to Continuum Mechanics | Seminars 9
- [ ] Intro to the Finite Element Method | Lectures 10
- [ ] Follow [this](https://www.youtube.com/watch?v=J6PTrFUFD00) ParaView seminar.

### Week 11

- [ ] Follow 7 extended tutorials provided with Gmsh (Python)
- [ ] Nithiarasu (2016), chapter 9
- [ ] Langtangen (2016), chapter 5 (1/3) 
- [ ] Intro to Continuum Mechanics | Seminars 10
- [ ] Follow [this](https://www.youtube.com/watch?v=IXXDxM62tUU) ParaView seminar.

### Week 12

- [ ] Nithiarasu (2016), chapter 10
- [ ] Langtangen (2016), chapter 5 (2/3) 

### Week 13

- [ ] Nithiarasu (2016), chapter 11
- [ ] Langtangen (2016), chapter 5 (3/3) 
- [ ] Barzegari's  notebook associated to Langtangens chapter 5

### Week 14

- [ ] Nithiarasu (2016), chapter 12
- [ ] Langtangen (2016), chapter 6 (1/2) 

### Week 15

- [ ] Nithiarasu (2016), chapter 13
- [ ] Langtangen (2016), chapter 6 (2/2) 
- [ ] Barzegari's  notebook associated to Langtangens chapter 6

### Week 16

- [ ] Nithiarasu (2016), chapter 14 and 15
- [ ] Langtangen (2016), chapter 7 
- [ ] Barzegari's  notebook associated to Langtangens chapter 7

### Week 17

- [ ] Langtangen (2016), chapter 8
- [ ] Barzegari's  notebook associated to Langtangens chapter 8

### Week 18

- [ ] Langtangen (2016), chapter 9 (1/4)

### Week 19

- [ ] Langtangen (2016), chapter 9 (2/4)

### Week 20

- [ ] Langtangen (2016), chapter 9 (3/4)

### Week 21

- [ ] Langtangen (2016), chapter 9 (4/4)
- [ ] Barzegari's  notebook associated to Langtangens chapter 9

### Week 22

- [ ] Langtangen (2016), chapter 10

### Week 23

- [ ] Langtangen (2016), chapter 11

# Finite Volume Method

## Formulations of heat conduction

### Temperature formulation

Before attempting to derive heat conduction equation in terms of enthalpy, it is worth warming up with its handling in temperature formulation. In this case, the equation is solved directly in terms of temperature as dependent variable which is also used in the governing potential (Fourier's law). This simple case is applicable to many engineering problems. First we formulate the problem with constant thermophysical properties before proceeding to variable density and specific heat.

#### Constant thermophysical properties

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

Applying a general Crank-Nicolson ([[@Crank1996]]) scheme we integrate numerically the right-hand side. The weighting factor $f$ introduces the implicit degree: for $f=1$ we have a fully implicit solution, which $f=0$ represents a standard Euler integration. It should be self evident that $\sum{}f^{(I)}=1$. *Notice that the parenthetical superscript notation $(I)$ does not imply exponentiation, but the instant at which the corresponding values are to be evaluated.*

$$
\frac{\rho{}c_{p}}{\tau}\left(T_P^{\tau}-T_P^{0}\right)\int_{s}^{n}\beta{}dr=
\sum_{I=\{0,\tau\}}
%
f^{(I)}\left[
    \beta_n{}k_n^{(I)}\frac{T_N^{(I)}-T_P^{(I)}}{\delta_{P,N}}-
    \beta_s{}k_s^{(I)}\frac{T_P^{(I)}-T_S^{(I)}}{\delta_{P,S}}
\right]
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
a_{P}^{(0)}T_P^{(0)}
$$

where the following coefficients are identified

$$
\begin{aligned}
    a_{S} & = -\kappa_{s}\\[8pt]
    a_{N} & = -\kappa_{n}\\[8pt]
    a_{P} & = \alpha_{P}+\kappa_{n}+\kappa_{s}\\[8pt]
    a_{P}^{(0)} &= \alpha_{P}
\end{aligned}
$$

and the standard finite volume formalism discretization is reached

$$
a_ST_S + a_PT_P + a_NT_N = a_{P}^{(0)}T_P^{(0)}
$$

The interested reader may wish to derive the boundary conditions to this case. We will refrain from that here because it will be done for the rather more general case in the following sections.

---
#### Variable thermophysical properties

To enter the variable thermophysical properties formulation it is worth saying a few words ahead of time about the next subject, the enthalpy formulation. That is because for variable density $\rho(T)$ and specific heat capacity $c_{p}(T)$ under constant pressure the left-hand side of heat equation can be better expressed in terms of enthalpy $H(T)=\rho(T)h(T)=\rho(T){}c_{p}(T)T$. Such a formulation is a requirement when dealing with phase change, such as solidification and melting - where we find discontinuities in enthalpy function; it is also needed in situations where material properties change above a certain degree for which constant properties could no longer be assumed over the foreseeable temperature range.

!!! info

	In practical applications, especially in high-dimensional problems coupled to fluid dynamics, it is worth performing a sensitivity analysis with different sampling points over $\rho(T){}c_{p}(T)$ to determine whether solving the problem with temperature-dependent properties is really required. For most cases this can lead to impressive speed-ups in simulations.

Although of high practical relevance, it is almost incredible that most standard engineering textbooks ignore this sort of development. A recent paper by ([[@Hristov2023]]) tries to handle this sort of formalism analytically with properties expanded as simple temperature functions. Expanding the left-hand side of heat equation formulated in $H(T)$ leads to

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

It is worth mentioning here, although we will not develop further for now, that in materials science and other fields, when involving a phase transformation kinetics described by an Avrami-like formalism such as discussed by ([[@Shirzad2023]]), we could end with a system of coupled partial differential equations. For instance, if density only is changed through an arbitrary kinetics $f(t,\rho,T,\dot{T})$, the next (unrealistic) model would arise. In fact, as discussed by ([[@Mittemeijer1988]]), we should solve for a new non-equilibrium thermodynamic state $\beta$ for the kinetics and analytically evaluate a JMAK expression for density, but that is beyond our scope here (for now!).

$$
\begin{align}
\left(
	\rho{}c_{p}+
	\rho{}T\frac{\partial{}c_{p}}{\partial{}T}
\right)\frac{\partial{}T}{\partial{}t}
&=\nabla\cdotp{}(k\nabla{}T)-c_{p}T\frac{\partial{}\rho}{\partial{}t}\\[12pt]
\frac{\partial{}\rho}{\partial{}t}&=f(t,\rho,T,\dot{T})
\end{align}
$$

The base development of the integral form of the heat equation in different coordinate systems being already treated in the previous sections, we use that result here to get

$$
\int_{s}^{n}\int_{0}^{\tau}
\beta
\left(
	\rho{}c_{p}+
	c_{p}T\frac{\partial{}\rho}{\partial{}T}+
	\rho{}T\frac{\partial{}c_{p}}{\partial{}T}
\right)
\dfrac{\partial{}T}{\partial{}t}dtdr=
\displaystyle\int_{0}^{\tau}\int_{s}^{n}
\dfrac{\partial}{\partial{}r}
\left(\beta{}k\dfrac{\partial{}T}{\partial{}r}\right)drdt
$$

Solving left-hand side of this integral is non-trivial and we will skip it for now; consider then the non-expanded version of the enthalpy problem:

$$
\int_{s}^{n}\int_{0}^{\tau}
\beta
\dfrac{\partial{}(\rho{}c_{p}T)}{\partial{}t}dtdr=
\displaystyle\int_{0}^{\tau}\int_{s}^{n}
\dfrac{\partial}{\partial{}r}
\left(\beta{}k\dfrac{\partial{}T}{\partial{}r}\right)drdt
$$

Next we integrate both sides of the equation at once and apply a fully implicit interpolation to the right-hand side; for the analogous details provided for constant thermophysical properties, please check the previous section. This leads to the following discrete equation:

$$
\frac{r_n^\gamma-r_s^\gamma}{\gamma\tau}
\left[(\rho{}c_{p}T_P)-(\rho{}c_{p}T_P)^{0}\right]
=
\beta_n{}k_n\frac{T_N-T_P}{\delta_{P,N}}-
\beta_s{}k_s\frac{T_P-T_S}{\delta_{P,S}}
$$

where we can identify the following coefficients (not exactly the same as before!):

$$
\begin{aligned}
\alpha_{P}  & = \frac{r_n^\gamma-r_s^\gamma}{\gamma\tau}\\[8pt]
\kappa_{j}   & = \frac{\beta_j{}k_j}{\delta_{P,J}}
\end{aligned}
$$


$$
-\kappa_n{}T_N
+(\alpha_{P}(\rho{}c_{p})^{(\star)}+\kappa_n{}+\kappa_s{})T_P
-\kappa_s{}T_S
=
\alpha_{P}(\rho{}c_{p})^{(0)}T_P^{(0)}
$$

where the following coefficients are identified

$$
\begin{aligned}
    a_{S} & = -\kappa_{s}\\[8pt]
    a_{N} & = -\kappa_{n}\\[8pt]
    a_{P} & = \alpha_{P}(\rho{}c_{p})^{(\star)}+\kappa_{n}+\kappa_{s}\\[8pt]
    a_{P}^{(0)} &= \alpha_{P}(\rho{}c_{p})^{(0)}
\end{aligned}
$$

There are two main differences in the above coefficients with respect to the constant properties case: both $a_{P}$ and $a_{P}^{(0)}$ need to be updated. Since the previous case already considered variable thermal conductivity, it was intrinsically non-linear and solution should already be iterative. In that sense, using a $(\star)$ superscript in $(\rho{}c_{p})^{(\star)}$ is not needed because the $\kappa$ already need to be updated on a iteration basis until time-step convergence; nonetheless, it was kept to emphasize the different in the present formulation. The final problem statement remains the same, say

$$
a_ST_S + a_PT_P + a_NT_N = a_{P}^{(0)}T_P^{(0)}
$$

##### Boundary conditions

TODO
##### Special cases coordinates

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
### Enthalpy formulation

Enthalpy formulation is less trivial from the perspective that both sides of the equation do not use the same variable; balance is performed over enthalpy while driving force remains the temperature gradient (as per Fourier's law). In this case an extra step is added to the solution, solve a (generally) nonlinear equation for $T=f(h)$. Quite often this is formulated as a root finding problem stated as $h-\hat{h}(T)=0$, where $h$ represents the integrate enthalpy in a control volume and $\hat{h}$ the provided function relating temperature to enthalpy. The equation is this case is stated as:

$$
\frac{\partial{}(\rho{}h)}{\partial{}t}=\nabla\cdotp{}(k\nabla{}T)
$$



#### Spherical coordinates 1-D


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
