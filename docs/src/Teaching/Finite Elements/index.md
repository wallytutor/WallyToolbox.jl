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
