1.1

Introduction

The Calphad technique has reached maturity. It started from a vision of combining data
from thermodynamics, phase diagrams, and atomistic properties such as magnetism into a
unified and consistent model. It is now a powerful method in a wide field of applications
where modeled Gibbs energies and derivatives thereof are used to calculate properties
and simulate transformations of real multicomponent materials. Chemical potentials and
the thermodynamic factor (second derivatives of the Gibbs energy) are used in diffu-
sion simulations. The driving forces of the phases are used to simulate the evolution of
microstructures on the basis of the Landau theory. In solidification simulations the frac-
tions of solid phases and the segregation of components, as well as energies of metastable
states, which are experimentally observed by carrying out rapid solidification, are used.
Whenever the thermodynamic description of a system is required, the Calphad technique
can be applied.

The successful use of Calphad in these applications relies on the development of multi-
component databases, which describe many different kinds of thermodynamic functions
in a consistent way, all checked to be consistent with experimental data. The construction
of these databases is still a very demanding task, requiring expertise and experience.
There are many subjective factors involved in the decisions to be made when judging
and selecting which among redundant experimental data are the most trustworthy. Even
more subjective is the assessment of phases of which little or nothing is known, except
perhaps in a narrow composition and temperature range. Furthermore, the growing range
of applications of these databases increases the feedback and several corrections and
modifications are required. The development of new models and the rapid advance of
first-principles (from the Latin ab initio) calculations makes the assessment techniques
very dynamic and challenging.

Computational thermodynamics

Thermodynamics describes the equilibrium state of a system. This is a necessary
foundation for simulations of phase transitions and processes, since all systems try to
reach this state. In computational thermodynamics (CT) the equilibrium state is described
using thermodynamic functions that depend on temperature, pressure, and composition.

===========
2

Introduction

These functions can be extrapolated also outside the equilibrium state and thus, when they
are included in a simulation model, provide information about values and gradients of
the thermodynamic properties in space and time outside the range of stability of a phase.

The thermodynamic models used by CT contain adjustable parameters, which can be
optimized in such a way that the models can reproduce many kinds of experimental
data as well as theoretical models and first-principles data. Thus CT is more flexible
and has much wider possibilities for realistic application calculations than merely using
first-principles data. The quality of the results of CT is based on the fit to experimental
data, which is also the criterion in judging the quality of results from first-principles
calculations.

More fundamental theories are focused on understanding particular mechanisms and
isolated properties, which they do very well, but they are not able to describe their cou-
pling in complex systems. CT can make use of theoretical results as well as traditional
experimental data and provides a unique framework of various types of information
that can be obtained using rather simple models. Thus CT is able to provide consistent
thermodynamic information with the accuracy required to describe multicomponent sys-
tems of technological interest. It is versatile enough to be extended to new applications
and incorporate related types of information such as magnetism (see section 5.4.2) and
viscosity (Seetharaman et al. 2005).

The important fact is that the thermodynamic information which can be extracted
from CT can describe the equilibrium state as well as extrapolations from it. There are
types of simulation software used today that depend on thermodynamic information such
as heat capacities, partition coefficients, and latent heats, but for which the data have
been collected from various sources and are inconsistent and cannot reproduce the real

 

 

equilibrium state. The results from simulations using such software may be reasonable
because the kinetic model has parameters that can be adjusted to compensate for the
errors in the thermodynamic data, but the range of applicability of the simulation is poor.
Of course, even with correct thermodynamics one will have to fit kinetic parameters in
simulation models, but these will have a larger range of validity because they depend less
on the thermodynamic properties of the system.

CT has shown its importance for calculating multicomponent phase diagrams and for
process and phas
in section 8.10. It is used by experimental researchers as a tool to test the compatibility
between their results and for data found in the literature, as well as planning new
experimental work. CT is also interesting to theoreticians, not only to use as a “reality”
against which they can check their predictions from fundamental models but, also and
more importantly, as a technique to improve the usefulness of their results by combining
them with experimental data, i.e. the Calphad method.

Knowledge of phase equilibria is fundamental to all aspects of materials science,
since the properties are determined by the microstructure, see for example Durand-
Charre (2004), and the microstructure consists of several phases arranged in space as
in Fig. 1.1. A practical way to obtain the phase equilibria in a multicomponent system
is by calculations using assessed thermodynamic databases. Hence the generation of
reliable and consistent computer-readable thermodynamic databases is very important.

-transformation simulations as mentioned above and in detail described

   

 

===========
1.2

1.2 The past and present, the Calphad technique 3

 

Figure 1.1 The microstructure of a low-carbon steel with many different stable and metastable
phases formed during cooling. The properties of the material depend on the amounts and
arrangements of these phases and their compositions. Computational thermodynamics together
with application software can be used to simulate the development of such microstructures and
predict the properties of materials. Courtesy of Mats Hillert.

New experiments are still very important, because the validated databases are based on
the combination of theoretical and experimental data.

The past and present, the Calphad technique

Phase diagrams had been calculated from Gibbs-energy models by van Laar (1908a,
1908b) and many others, but the first general description of Calphad was written by
Larry Kaufman in the book Computer Calculations of Phase Diagrams (Kaufman and
Bernstein 1970), in which he developed the important concept of “lattice stability” which
he had introduced earlier (Kaufman 1959). He explained clearly how parameters could be
derived both from experimental phase diagrams and from the rudimentary first-principles
techniques available at that time, and how they could be used to calculate phase diagrams.
The concept of lattice stability was essential for the development of multicomponent
thermodynamic databases, which was a very far-sighted goal because at that time it was
a challenge to calculate even a ternary phase diagram.

The method of extrapolating solubility lines into the metastable range to obtain a
thermodynamic property, such as the melting temperature of metastable fec Cr, shows
one of the important advantages of combining phase diagrams and thermodynamics.

===========
4

1.3

Introduction

Many such combinations have been used in exploring properties of other systems during
the development of the Calphad techniques. Important contributions on how to use
experimental and theoretical data in thermodynamic models were made by Kubaschewski
et al. (1967), Hillert and Staffanson (1970), Hasebe and Nishizawa (1972), Ansara et al.
(1973), and Lukas er al. (1977). For historic details, the recent paper by Kaufman (2002)
is recommended.

Originally the term “Calphad” meant calculating phase diagrams from thermodynamic
models with parameters adjusted to the available experimental data. The term “Calphad
technique” has come to mean the technique of selecting models for phases that can be
extrapolated both in composition and in temperature ranges, including also metastable
ranges. A comprehensive description of this Calphad technique can be found in Kattner
(1997). The “Calphad method” means the use of all available experimental and theoretical
data to assess the parameters of the Gibbs energy models selected for each phase.
That is the topic of this book. To describe the use of these models and parameters
stored in thermodynamic databases for various applications, the term “computational
thermodynamics” has been adopted.

It may be instructive to mention here that in the early days of Calphad there was a
heated argument among material scientists about how to model a dilute solution. The
thermodynamic properties of a dilute solution of B in a solvent A can be modeled with
a simple Henrian coefficient as described in section 5.5.9. With the Calphad technique
one needed two parameters, one representing the solvent phase consisting of pure B, i.e.
a “lattice stability,” and one interaction parameter between A and B. In the dilute range
the sum of these two parameters is the only important quantity and is in fact identical
to the Henrian coefficient. The fact that the Calphad technique needed more parameters,
and that the parameter representing pure B in the same phase as A often was an unstable
phase (like pure fec Cr), was taken to be a severe drawback of the Calphad technique.

However, the drawback of dilute models is more severe because there are many
cases, for example at solidification, for which one must find a way to describe how the
thermodynamic properties vary when the solvent phase changes. Upon investigating this
problem in more detail, one finds that the Calphad technique is the simplest and most
consistent way to handle a multicomponent thermodynamic system with many “solvent”
phases. Similar modeling problems in which one has to evaluate “lattice stabilities” of
phases with more or less limited solubilities occur often in Calphad assessments. This is
discussed in chapter 6.

 

The future development of databases and software applications

As computers become faster, models and techniques of greater sophistication and accuracy
are being developed within CT. However, there is an important “inertia” present in the
thermodynamic databases, which are compiled from a large number of both independent
and inter-dependent assessments. In a reference book like Hultgren et al. (1973) one may
replace the data for one element without changing anything else, but in a database the
binary assessments depend on the unary data for pure elements and on the models selected

===========
1.4

1.4 The structure of the book 5

for the phases. Ternary and higher-order assessments depend on the selected assessments
of the corresponding lower-order systems. This means that, in order to introduce a new
value for a pure element, a new assessment of a binary system, or a new model for a
phase present in a thermodynamic database one must revise all assessments depending on
this value, assessment, or model. The current commercial databases depend on a number
of decisions taken for pure elements and models made more than 20 years ago by the
Scientific Group Thermodata Europe (SGTE, http://www.sgte.org). It is a great credit to
the scientists involved in these decisions that there have been so few problems with using
these data to build multicomponent databases for so many years. Nonetheless, there is a
need to revise the set of unary and binary data as well as models continuously and maybe
every 10 years one should start creating improved versions of the databases from a new
revised set of data. The maintaining of databases is briefly discussed in chapter 8.

The number of publications on thermodynamically assessed systems is increasing
rapidly and most of them use SGTE unary data (Dinsdale 1991), but many important bina-
ries have been assessed several times using different models for some of the phases, which
are not always compatible. When selecting which assessed version of a system should
be incorporated into a database, the thermodynamic description should, at least ideally,
be the best that can be obtained at present, taking into account theoretical approaches
and technical possibilities. Of course, what should be judged the “best” assessment is not
easy to define, but some rules can be established, as will be discussed in this book.

A series of thermodynamic and modeling workshops organized by the Max Planck
Institute in Stuttgart and held in the conference center at Schloss Ringberg was initiated
in 1995. The aim of these workshops was to build the foundation for the next generation
of thermodynamic databases and software. They had a unique organization with from
five to seven groups, with from seven to nine participants in each. The participants in
each of the groups were expected to write a paper together on a specific topic during
the workshop, with some time to complete it allowed afterwards. The participants had
quite different opinions initially, but during the workshop many new ideas on how to
resolve the differences or find ways to resolve them appeared. The first workshop was
dedicated to pure elements and compounds and was published as a special issue of
Calphad (Aldinger et al. 1995). The second workshop was dedicated to modeling of
solutions and was published in Calphad (Aldinger et al. 1997). The third was dedicated
to applications and published in Calphad (Aldinger et al. 2000) and the Zeitschrift fiir
Metallkunde (Burton et al. 2001). The fourth was about applications and modeling of
special phases such as oxides and was also published in the Zeitschrift fiir Metallkunde
(Aldinger et al. 2001). The fifth workshop was about Calphad and ab initio techniques
and was published in Calphad (Aldinger et al. 2007).

 

The structure of the book

This book is intended to be an introductory text as well as a reference book for optimization
of thermodynamic descriptions, but it is not intended to be read from beginning to end.
This first chapter gives some introduction to the scope of the book. The second chapter is

===========
6

Introduction

for reference, since its content should be well known to any student of physics, chemistry,
or materials science, and the notation for thermodynamic quantities used in the book is
explained.

Chapter 3 gives a short introduction to ab initio calculations, in particular how results
from such calculations can be used for thermodynamic modeling and assessments. In
the fourth chapter various experimental techniques that provide the data necessary for
assessments are described. The fifth chapter gives a detailed description of most of the
models currently used to describe thermodynamic functions of phases. This is mainly
intended to be a reference for the sixth chapter, where the selection of models for phases
is discussed in terms of their properties.

Chapter 6 is the central part of the book, where the experience from many assessments
has been condensed into a few rules of practice. As usual, any good rule has many
exceptions; many of these exceptions will be described in chapter 9, which deals with
case studies. The reader may find that some topics are repeated several times; that is
usually because they are important.

Chapter 7 describes two of the most-used software systems for thermodynamic assess-
ments, BINGSS, developed by H.L. Lukas (Lukas et al. 1977, Lukas and Fries 1992)
and PARROT, developed by Dr. B. Jansson (Jansson 1983) as a part of the Thermo-Cale
software (Sundman er al. 1985, Andersson et al. 2002). The emphasis is on the main
features of these items of software; many of the peculiarities will be explained only in
the case studies in chapter 9. Chapter 8 deals with the creation of databases from separate
assessments and how to maintain a database.

Chapter 9 is again a crucial part of the book. The beginner should try to follow some of
the case studies in order to learn the technique from a known system. A careful reading of
the case studies is recommended, since they give many hints on how to use experimental
data of various types. The reader is also advised to look at the website for the book,
because more case studies will be available there. References to existing software and
databases can be found in a special issue of Calphad (2002, 26, pp. 141-312).
