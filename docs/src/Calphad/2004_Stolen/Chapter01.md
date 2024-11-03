Chemical Thermodynamics of Materials: Macroscopic and Microscopic Aspects.
Svein Stolen and Tor Grande
Copyright 2004 John Wiley & Sons, Ltd. ISBN: 0-471-49230-2

Thermodynamic
foundations

1.1 Basic concepts

Thermodynamic systems

A thermodynamic description of a process needs a well-defined system. A thermo-
dynamic system contains everything of thermodynamic interest for a particular
chemical process within a boundary. The boundary is either a real or hypothetical
enclosure or surface that confines the system and separates it from its surroundings.
In order to describe the thermodynamic behaviour of a physical system, the interac-
tion between the system and its surroundings must be understood. Thermodynamic
systems are thus classified into three main types according to the way they interact
with the surroundings: isolated systems do not exchange energy or matter with their
surroundings; closed systems exchange energy with the surroundings but not matter;
and open systems exchange both energy and matter with their surroundings.

The system may be homogeneous or heterogeneous. An exact definition is difficult,
but it is convenient to define a homogeneous system as one whose properties are the

 

 

same in all parts, or at least their spatial variation is continuous. A heterogeneous
system consists of two or more distinct homogeneous regions or phases, which are sepa-
rated from one another by surfaces of discontinuity. The boundaries between phases are
not strictly abrupt, but rather regions in which the properties change abruptly from the
properties of one homogeneous phase to those of the other. For example, Portland
cement consists of a mixture of the phases B-Ca2SiO4, Ca3SiOs, Ca3AlyO¢ and
Ca4Al,Fe20}19. The different homogeneous phases are readily distinguished from each

---
2 1 Thermodynamic foundations

other macroscopically and the thermodynamics of the system can be treated based
on the sum of the thermodynamics of each single homogeneous phase.

In colloids, on the other hand, the different phases are not easily distinguished
macroscopically due to the small particle size that characterizes these systems. So
although a colloid also is a heterogeneous system, the effect of the surface thermo-
dynamics must be taken into consideration in addition to the thermodynamics of
each homogeneous phase. In the following, when we speak about heterogeneous
systems, it must be understood (if not stated otherwise) that the system is one in
which each homogeneous phase is spatially sufficiently large to neglect surface
energy contributions. The contributions from surfaces become important in sys-
tems where the dimensions of the homogeneous regions are about | tm or les:
size. The thermodynamics of surfaces will be considered in Chapter 6.

A homogeneous system — solid, liquid or gas — is called a solution if the compo-
sition of the system can be varied. The components of the solution are the sub-
stances of fixed composition that can be mixed in varying amounts to form the
solution. The choice of the components is often arbitrary and depends on the pur-
pose of the problem that is considered. The solid solution LaCrj_yFeyO3 can be
treated as a quasi-binary system with LaCrO3 and LaFeO3 as components. Alterna-
tively, the compound may be regarded as forming from La203, Fe2O3 and Cr203 or
from the elements La, Fe, Cr and Op (g). In LayO3 or LaCrO3, for example, the ele-
ments are present in a definite ratio, and independent variation is not allowed.
La O3 can thus be treated as a single component system. We will come back to this
important topic in discussing the Gibbs phase rule in Chapter 4.

 

Thermodynamic variables

In thermodynamics the state of a system is specified in terms of macroscopic state
variables such as volume, V, temperature, 7, pressure, p, and the number of moles of
the chemical constituents i, n;. The laws of thermodynamics are founded on the con-
cepts of internal energy (U), and entropy (S), which are functions of the state variables.
Thermodynamic variables are categorized as intensive or extensive. Variables that are
proportional to the size of the system (e.g. volume and internal energy) are called
extensive variables, whereas variables that specify a property that is independent of
the size of the system (e.g. temperature and pressure) are called intensive variables.

A state function is a property of a system that has a value that depends on the
conditions (state) of the system and not on how the system has arrived at those con-
ditions (the thermal history of the system). For example, the temperature in a room
at a given time does not depend on whether the room was heated up to that tempera-
ture or cooled down to it. The difference in any state function is identical for every
process that takes the system from the same given initial state to the same given
final state: it is independent of the path or process connecting the two states.
Whereas the internal energy of a system is a state function, work and heat are not.
Work and heat are not associated with one given state of the system, but are defined
only in a transformation of the system. Hence the work performed and the heat

---
1.1 Basic concepts 3

adsorbed by the system between the initial and final states depend on the choice of
the transformation path linking these two states.

 

Thermodynamic processes and equilibrium

The state of a physical system evolves irreversibly towards a time-independent state in
which we see no further macroscopic physical or chemical changes. This is the state of
thermodynamic equilibrium, characterized for example by a uniform temperature
throughout the system but also by other features. A non-equilibrium state can be
defined as a state where irreversible processes drive the system towards the state of equi-
librium. The rates at which the system is driven towards equilibrium range from
extremely fast to extremely slow. In the latter case the isolated system may appear to
have reached equilibrium. Such a system, which fulfils the characteristics of an equilib-
rium system but is not the true equilibrium state, is called a metastable state. Carbon in
the form of diamond is stable for extremely long periods of time at ambient pressure and
temperature, but transforms to the more stable form, graphite, if given energy sufficient
to climb the activation energy barrier. Buckminsterfullerene, Cgo, and the related C79
and carbon nanotubes, are other metastable modifications of carbon. The enthalpies of
three modifications of carbon relative to graphite are given in Figure 1.1 [1, 2].
Glasses are a particular type of material that is neither stable nor metastable.
Glasses are usually prepared by rapid cooling of liquids. Below the melting point the
liquid become supercooled and is therefore metastable with respect to the equilib-
rium crystalline solid state. At the glass transition the supercooled liquid transforms
to a glass. The properties of the glass depend on the quenching rate (thermal history)
and do not fulfil the requirements of an equilibrium phase. Glasses represent non-
ergodic states, which means that they are not able to explore their entire phase space,
and glasses are thus not in internal equilibrium. Both stable states (such as liquids
above the melting temperature) and metastable states (such as supercooled liquids
between the melting and glass transition temperatures) are in internal equilibrium
and thus ergodic. Frozen-in degrees of freedom are frequently present, even in crys-
talline compounds. Glassy crystals exhibit translational periodicity of the molecular

graphite diamond

 

Figure 1.1 Standard enthalpy of formation per mol C of C¢o [1], C70 [2] and diamond rela-
tive to graphite at 298 K and 1 bar.

---
4 1 Thermodynamic foundations

centre of mass, whereas the molecular orientation is frozen either in completely
random directions or randomly among a preferred set of orientations. Strictly

1.2 The first law of thermodynamics

Conservation of energy
The first law of thermodynamics may be expressed as:

Whenever any process occurs, the sum of all changes in energy, taken over all
the systems participating in the process, is zero.

The important consequence of the first law is that energy is always conserved. This
law governs the transfer of energy from one place to another, in one form or another:
as heat energy, mechanical energy, electrical energy, radiation energy, etc. The
energy contained within a thermodynamic system is termed the internal energy or
simply the energy of the system, U. In all processes, reversible or irreversible, the
change in internal energy must be in accord with the first law of thermodynamics.

Work is done when an object is moved against an opposing force. It is equivalent
to a change in height of a body in a gravimetric field. The energy of a system is its
capacity to do work. When work is done on an otherwise isolated system, its
capacity to do work is increased, and hence the energy of the system is increased.
When the system does work its energy is reduced because it can do less work than
before. When the energy of a system changes as a result of temperature differences
between the system and its surroundings, the energy has been transferred as heat.
Not all boundaries permit transfer of heat, even when there is a temperature differ-
ence between the system and its surroundings. A boundary that does not allow heat
transfer is called adiabatic. Processes that release energy as heat are called exo-
thermic, whereas processes that absorb energy as heat are called endothermic.

The mathematical expression of the first law is

Sau = ¥dq + Ydw =0 (1.1)

where U, q and w are the internal energy, the heat and the work, and each summa-
tion covers all systems participating in the process. Applications of the first law
involve merely accounting processes. Whenever any process occurs, the net energy
taken up by the given system will be exactly equal to the energy lost by the sur-
roundings and vice versa, i.e. simply the principle of conservation of energy.

 

‘in volume. In the simplest example, work is done when a gas expands and drives back
the surrounding atmosphere. The work done when a system expands its volume by an
infinitesimal small amount dV against a constant external pressure is

dw =—pexdV (1.2)

---
a

1.2 The first law of thermodynamics

Table 1.1 Conjugate pairs of variables in work terms for the fundamental equation for the
internal energy U. Here fis force of elongation, / is length in the direction of the force, ois
surface tension, Ag is surface area, Qj is the electric potential of the phase containing spe-
cies i, gj is the contribution of species i to the electric charge of a phase, E is electric field
strength, p is the electric dipole moment of the system, B is magnetic field strength (mag-
netic flux density), and m is the magnetic moment of the system. The dots indicate scalar
products of vectors.

 

Type of work Intensive variable Extensive variable Differential work in dU

 

Mechanical

Pressure—volume -p Vv -pdVv
Elastic f 1 fal
Surface o As odAg

Electromagnetic
Charge transfer ®; 4h dq;
Electric polarization E p E-dp
Magnetic polarization B m B-dm

 

The negative sign shows that the internal energy of the system doing the work
decreases.
In general, dw is written in the form (intensive variable)-d(extensive variable) or

as a product of a force times a displacement of some kind. Several types of work

‘tions of materials. A number of types of work that may be involved in a

thermodynamic system are summed up in Table 1.1. The last column gives the form
of work in the equation for the internal energy.

Heat capacity and definition of enthalpy

In general, the change in internal energy or simply the energy of a system U may
now be written as

dU =dq + dwyy + dWyon-e (1.3)

where dw py and diyon-¢ are the expansion (or pV) work and the additional non-
expansion (or non-pV) work, respectively. A system kept at constant volume
cannot do expansion work; hence in this case dw py =0. If the system also does not
do any other kind of work, then dw,,.. =0. So here the first law yields

dU =dgy (1.4)

where the subscript denotes a change at constant volume. For a measurable change,
the increase in the internal energy of a substance is

---
6 1 Thermodynamic foundations
AU =qy (1.5)

The temperature dependence of the internal energy is given by the heat capacity
at constant volume at a given temperature, formally defined by

oU
Cy =| — 1.6
v (z \ (1.6)

For a constant-volume system, an infinitesimal change in temperature gives an
infinitesimal change in internal energy and the constant of proportionality is the
heat capacity at constant volume

dU =CydT (1.7)

The change in internal energy is equal to the heat supplied only when the system
is confined to a constant volume. When the system is free to change its volume,
some of the energy supplied as heat is returned to the surroundings as expansion
work. Work due to the expansion of a system against a constant external pressure,
Pext gives the following change in internal energy:

dU =dq + dw =dq — pox, dV (1.8)

For processes taking place at constant pressure it is convenient to introduce the
enthalpy function, H, defined as

H=U+pV (1.9)
Differentiation gives

dH =d(U + pV) =dg + dw + Vdp + pdV (1.10)
When only work against a constant external pressure is done:

dw =—pexpdV (1.11)
and eq. (1.10) becomes

dH =dq +Vdp (1.12)
Since dp = 0 (constant pressure),

dH =dq, (1.13)

---
1.2 The first law of thermodynamics 7
and

AH = dp (1.14)

The enthalpy of a substance increases when its temperature is raised. The tem-

perature dependence of the enthalpy is given by the heat capacity at constant
pressure at a given temperature, formally defined by

Cy (2 (1.15)
ar),

Hence, fora constant pressure system, an infinitesimal change in temperature gives
an infinitesimal change in enthalpy and the constant of proportionality is the heat
capacity at constant pressure.

 

dH =C,dT (1.16)

of VT

Kr

where @ and ky are the isobaric expansivity and the isothermal compressibility

respectively, defined by

anf (1.18)
via J,

 

Cp -Cy = (1.17)

and

kp =f (1.19)
V\& Je

Typical values of the isobaric expansivity and the isothermal compressibility are

given in Table 1.2. The difference between the heat capacities at constant volume

Since the heat absorbed or released by a system at constant pressure is equal to
its change in enthalpy, enthalpy is often called heat content. If a phase transforma-
tion (i.e. melting or transformation to another solid polymorph) takes place within

---
8 1 Thermodynamic foundations

Table 1.2 The isobaric expansivity and iso-
thermal compressibility of selected compounds at

 

 

300 K.
Compound @NO-SK-1— x;/10-!2 Pa
Mgo 3.12 6.17
Al,03 1.62 3.97
MnO 3.46 6.80
Fe304 3.56 4.52
NaCl 118 417
C (diamond) 0.54 1.70
C (graphite) 2.49 179
Al 69 13.2
130]
= 120
A
Guo f
= r 3
> 100)
° @/ 105K"
90]
ALO, 2
80|

 

 

 

 

500 1000 1500 500 1000 1500
TIK

Figure 1.2 Molar heat capacity at constant pressure and at constant volume, isobaric
expansivity and isothermal compressibility of Al2O3 as a function of temperature.

the system, heat may be adsorbed or released without a change in temperature. At
constant pressure the heat merely transforms a portion of the substance (e.g. from
solid to liquid — ice—water). Such a change is called a first-order phase transition
and will be defined formally in Chapter 2. The standard enthalpy of aluminium rel-
ative to 0 K is given as a function of temperature in Figure 1.3. The standard
enthalpy of fusion and in particular the standard enthalpy of vaporization con-
tribute significantly to the total enthalpy increment.

Reference and standard states

Thermodynamics deals with processes and reactions and is rarely concerned with
the absolute values of the internal energy or enthalpy of a system, for example, only
with the changes in these quantities. Hence the energy changes must be well
defined. It is often convenient to choose a reference state as an arbitrary zero.
Often the reference state of a condensed element/compound is chosen to be at a
pressure of | bar and in the most stable polymorph of that element/compound at the

---
1.2 The first law of thermodynamics 9

   

400
T, 300 Avap Ha= 294 kJ mol
z
2 200)
of
&
<I 100 Agyg,= 10.8 kJ mol!
© 500 1000 1500 2000 2500 3000

TIK

Figure 1.3 Standard enthalpy of aluminium relative to 0 K. The standard enthalpy of fusion

(AjusHm) is significantly smaller than the standard enthalpy of vaporization (AyayHm)-

temperature at which the reaction or process is taking place. This reference state is
called a standard state due to its large practical importance. The term standard

The term reference state will be
used for states obtained from standard states by a change of pressure. It is impor-
tant to note that the standard state chosen should be specified explicitly, since it is
indeed possible to choose different standard states.

Let us give an example of a standard state that not involves the most stable
polymorph of the compound at the temperature at which the system is considered.
Cubic zirconia, ZrOg, is a fast-ion conductor stable only above 2300 °C. Cubic zir-
conia can, however, be stabilized to lower temperatures by forming a solid solution
with for example Y203 or CaO. The composition—temperature stability field of this
important phase is marked by Css in the ZrO,—CaZrO 3 phase diagram shown in
Figure 1.4 (phase diagrams are treated formally in Chapter 4). In order to describe
the thermodynamics of this solid solution phase at, for example, 1500 °C, it is con-
venient to define the metastable cubic high-temperature modification of zirconia
as the standard state instead of the tetragonal modification that is stable at 1500 °C.
The standard state of pure ZrO (used as a component of the solid solution) and the
investigated solid solution thus take the same crystal structure.

The standard state for gases is discussed in Chapter 2.

Enthalpy of physical transformations and chemical reactions

The enthalpy that accompanies a change of physical state at standard conditions is
called the standard enthalpy of transition and is denoted A ,,,H°. Enthalpy changes
accompanying chemical reactions at standard conditions are in general termed stan-
dard enthalpies of reaction and denoted A, H°. Two simple examples are given in
Table 1.3. In general, from the first law, the standard enthalpy of a reaction is given by

---
10 1 Thermodynamic foundations

 

   

 

 

 

 

 

2500 CaZr0,
2000
2
© 1500
w
1000 SSASEEZOP CaZrO. CaZr0y
Mss + CaZr,Oy +CaZrO,
Mss 3
500
0 1 20 «230 40 SO
Z10, *Ca0 CaZr0,

Figure 1.4 The ZrO2-CaZrO3 phase diagram. Mss, Tss and Css denote monoclinic,
tetragonal and cubic solid solutions.

Table 1.3 Examples of a physical transformation and a chemical reaction and their respec-
tive enthalpy changes. Here Ag,,Hy, denotes the standard molar enthalpy of fusion.

 

 

 

Reaction Enthalpy change
Al (s) = Al (liq) AusH®, = AgsH2, = 10789 J mol at Thus
3SiO> (s) + 2Np (g) = Si3Nq (s) + 302 (g) A,H° = 1987.8 kJ mol-! at 298.15 K
AH? =) vjHaD- LvtmO (1.20)
J t

where the sum is over the standard molar enthalpy of the reactants i and products j
(vy; and v; are the stoichiometric coefficients of reactants and products in the chem-
ical reaction).

Of particular importance is the standard molar enthalpy of formation, A;H,,
which corresponds to the standard reaction enthalpy for the formation of one mole
of a compound from its elements in their standard states. The standard enthalpies
of formation of three different modifications of AlpSiOs are given as examples in
Table 1.4 [3]. Compounds like these, which are formed by combination of
electropositive and electronegative elements, generally have large negative
enthalpies of formation due to the formation of strong covalent or ionic bonds. In
contrast, the difference in enthalpy of formation between the different modifica-
tions is small. This is more easily seen by consideration of the enthalpies of forma-
tion of these ternary oxides from their binary constituent oxides, often termed the
standard molar enthalpy of formation from oxides, A ¢_,x Hy, Which correspond
to A, H@, for the reaction

SiO (s) + Aly03 (s) = AlySiOs (s) (1.21)

---
1.2 The first law of thermodynamics 11

Table 1.4 The enthalpy of formation of the three polymorphs of AlpSiOs, kyanite, andalu-
site and sillimanite at 298.15 K [3].

 

 

Reaction ArH, /kJ mol!
2 Al (s) + Si (8) + 5/2 Op (g) = ALpSiOs (kyanite) -2596.0
2 Al (s) + Si (8) + 5/2 Op (g) = ALSiOs (andalusite) -2591.7
2 Al (s) + Si (8) + 5/2 Op (g) = AlpSiOs (sillimanite) -2587.8

 

These are derived by subtraction of the standard molar enthalpy of formation of
the binary oxides, since standard enthalpies of individual reactions can be com-
bined to obtain the standard enthalpy of another reaction. Thus,

AgoxH m (Al SiO5) = ApH p, (Ab SiO5) — ApH, (ALO3) (1.22)

—A;H (SiO)

The standard enthalpy of an overall reaction is the sum of the standard
enthalpies of the individual reactions that can be used to describe the overall
reaction of AljSiOs.

Whereas the enthalpy of formation of Al)SiOs5 from the elements is large and
negative, the enthalpy of formation from the binary oxides is much less so.
AgoxH m is furthermore comparable to the enthalpy of transition between the dif-
ferent polymorphs, as shown for AlpSiOs in Table 1.5 [3]. The enthalpy of fusion is
also of similar magnitude.

The temperature dependence of reaction enthalpies can be determined from the
heat capacity of the reactants and products. When a substance is heated from T| to
T2 at a particular pressure p, assuming no phase transition is taking place, its molar
enthalpy change from AH, (T;) to AH, (T>) is

Table 1.5 The enthalpy of formation of kyanite, andalusite and sillimanite from the binary
constituent oxides [3]. The enthalpy of transition between the different polymorphs is also
given. All enthalpies are given for T= 298.15 K.

 

 

Reaction A,HE, = Ag ox H9, (kJ mol!
‘Als03 (s) + SiO> (s) = AlpSiOs (kyanite) -9.6

Als03 (s) + SiO> (s) = AlpSiOs (andalusite) 53

Al203 (s) + SiO> (s) = AlpSiOs (sillimanite) -14

AlsSiOs (kyanite) = AlpSiOs (andalusite) 43

ALSi05 (andalusite) = AlySi0s (sillimanite) 39

 

---
12 1 Thermodynamic foundations

Ty
AH yy (T))=AH (Ty) + FC
qT

(1.23)

pmdT

This equation applies to each substance in a reaction and a change in the standard
reaction enthalpy (i.e. p is now p® = | bar) going from T| to T> is given by

A,H°(T))=A,H°(T)) + + fa, Cc
qT

(1.24)

pm

where A Com is the difference in the standard molar heat capacities at constant

pressure of the products and reactants under standard conditions taking the
stoichiometric coefficients that appear in the chemical equation into consideration:

A,C?,

pam =

iC pm) dvic pam (i) (1.25)

 

1.3 The second and third laws of thermodynamics

The second law and the definition of entropy

 

A system can in principle undergo an indefinite number of processes under the con-
straint that energy is conserved. While the first law of thermodynamics identifies
the allowed changes, a new state function, the entropy S, is needed to identify the
spontaneous changes among the allowed changes. The second law of thermody-
namics may be expressed as

The entropy of a system and its surroundings increases in the course of a
spontaneous change, AS jo >0.

The law implies that for a reversible process, the sum of all changes in entropy,
taken over all the systems participating in the process, AS jot, is zero.
Reversible and non-reversible processes

Any change in state of a system in thermal and mechanical contact with its sur-
roundings at a given temperature is accompanied by a change in entropy of the
system, dS, and of the surroundings, dS.y,:

dS + dS yp 20 (1.26)

---
1.3 The second and third laws of thermodynamics 13

The sum is equal to zero for reversible processes, where the system is always
under equilibrium conditions, and larger than zero for irreversible processes. The
entropy change of the surroundings is defined as

d
dS uy =f (1.27)

where dq is the heat supplied to the system during the process. It follows that for
any change:

as (1.28)

which is known as the Clausius inequality. If we are looking at an isolated system
ds >0 (1.29)

Hence, for an isolated system, the entropy of the system alone must increase when
a spontaneous process takes place. The second law identifies the spontaneous
changes, but in terms of both the system and the surroundings. However, it is pos-
sible to consider the specific system only. This is the topic of the next section.

Conditions for equilibrium and the definition of Helmholtz and Gibbs
energies

Let us consider a closed system in thermal equilibrium with its surroundings at a
given temperature 7, where no non-expansion work is possible. Imagine a change
in the system and that the energy change is taking place as a heat exchange between
the system and the surroundings. The Clausius inequality (eq. 1.28) may then be
expressed as

ds -— 20 (1.30)

If the heat is transferred at constant volume and no non-expansion work is done,

as -1U 59 (1.31)
T

The combination of the Clausius inequality (eq. 1.30) and the first law of thermo-
dynamics for a system at constant volume thus gives

TdS > dU (1.32)

---
14 1 Thermodynamic foundations
Correspondingly, when heat is transferred at constant pressure (pV work only),
TdS > dH (1.33)

For convenience, two new thermodynamic functions are defined, the Helmholtz
(A) and Gibbs (G) energies:

A=U -TS (1.34)
and
G=H-TS (1.35)
For an infinitesimal change in the system
dA = dU —TdS — SdT (1.36)
and
dG =dH —TdS — SdT (1.37)
At constant temperature eqs. (1.36) and (1.37) reduce to
dA =dU —TdS (1.38)
and
dG =dH -TdS (1.39)
Thus for a system at constant temperature and volume, the equilibrium condition is
dApy =0 (1.40)
Ina process at constant 7 and V in a closed system doing only expansion work it
follows from eq. (1.32) that the spontaneous direction of change is in the direction
of decreasing A. At equilibrium the value of A is at a minimum.
For a system at constant temperature and pressure, the equilibrium condition is
dG, =0 (1.41)
Ina process at constant T and p in aclosed system doing only expansion work it fol-

lows from eq. (1.33) that the spontaneous direction of change is in the direction of
decreasing G. At equilibrium the value of G is at a minimum.

---
1.3 The second and third laws of thermodynamics 15

Equilibrium conditions in terms of internal energy and enthalpy are less appli-
cable since these correspond to systems at constant entropy and volume and at con-
stant entropy and pressure, respectively

dUs y =0 (1.42)
dH » =0 (1.43)

The Helmholtz and Gibbs energies on the other hand involve constant tempera-
ture and volume and constant temperature and pressure, respectively. Most experi-
ments are done at constant T and p, and most simulations at constant T and V. Thus,
we have now defined two functions of great practical use. In a spontaneous process
at constant p and T or constant p and V, the Gibbs or Helmholtz energies, respec-
tively, of the system decrease. These are, however, only other measures of the
second law and imply that the total entropy of the system and the surroundings
increases.

Maximum work and maximum non-expansion work

The Helmholtz and Gibbs energies are useful also in that they define the maximum
work and the maximum non-expansion work a system can do, respectively. The
combination of the Clausius inequality TdS > dg and the first law of thermody-
namics dU =dg + dw gives

dw = dU —TdS (1.44)

Thus the maximum work (the most negative value of dw) that can be done by a
system is

dWypax = dU -TdS (1.45)
At constant temperature dA = dU — TdS and
Wmax = 4A (1.46)

If the entropy of the system decreases some of the energy must escape as heat in
order to produce enough entropy in the surroundings to satisfy the second law of
thermodynamics. Hence the maximum work is less than| AU |. AA is the part of the
change in internal energy that is free to use for work. Hence the Helmholtz energy
is in some older books termed the (isothermal) work content.

The total amount of work is conveniently separated into expansion (or pV) work
and non-expansion work.

dw =dWyon-e — PAV (1.47)

---
16 1 Thermodynamic foundations
For a system at constant pressure it can be shown that

dw =dH -TdS (1.48)

non -e,max

At constant temperature dG = dH — TdS and
Wnon-emax = AG (1.49)

Hence, while the change in Helmholtz energy relates to the total work, the change
in Gibbs energy at constant temperature and pressure represents the maximum
non-expansion work a system can do.

Since A,G° for the formation of 1 mol of water from hydrogen and oxygen gas at
298 K and | bar is —237 kJ mol-!, up to 237 kJ mol"! of ‘chemical energy’ can be
converted into electrical energy in a fuel cell working at these conditions using
H)(g) as fuel. Since the Gibbs energy relates to the energy free for non-expansion
work, it has in previous years been called the free energy.

The variation of entropy with temperature

For a reversible change the entropy increment is dS = dq/T. The variation of the
entropy from 7| to 7 is therefore given by

Ty
edd rey
S(T) = S(T, ey 1.50
(Tz) me} r (1.50)
i

For a process taking place at constant pressure and that does not involve any non-
pV work

dq rey = dH =C,dT (1.51)
and
t

C)aT
S(Tp)= S(T) + f (1.52)
T, Tr

 

The entropy of a particular compound at a specific temperature can be determined
through measurements of the heat capacity as a function of temperature, adding
entropy increments connected with first-order phase transitions of the compound:

* CT)
T

Tow
ST)=SO)+ | of)
) T

dT + Aus Sm +] Yar (1.53)

Tes

---
1.3 The second and third laws of thermodynamics 17

 

 

 

 

200
Al AvapSin =
L150 105.3 J. K7!mol™
g —
1 Anse =
% 199 frm =
& 11.56 J K mol
a se
50
0
0 500 1000 1500 2000 2500 3000
TIK
Figure 1.5 Standard entropy of aluminium relative to 0 K. The standard entropy of fusion
(Agus Sm) is significantly smaller than the standard entropy of boiling (A yap Sm)-

The variation of the standard entropy of aluminium from 0 K to the melt at 3000 K
is given in Figure 1.5. The standard entropy of fusion and in particular the standard
entropy of vaporization contribute significantly to the total entropy increment.

Equation (1.53) applies to each substance in a reaction and a change in the stan-
dard entropy of a reaction (p is now p° = | bar) going from 7| to 72 is given by
(neglecting for simplicity first-order phase transitions in reactants and products)

PAC o mT
A,S°r)=A,8%(n)+ [MO g

IT (1.54)
T
q,

where A,C pm (T) is given by eq. (1.25).

The third law of thermodynamics
The third law of thermodynamics may be formulated as:

If the entropy of each element in some perfect crystalline state at T= 0 K is taken
as zero, then every substance has a finite positive entropy which at T= 0 K
become zero for all perfect crystalline substances.

In a perfect crystal at 0 K all atoms are ordered in a regular uniform way and the
translational symmetry is therefore perfect. The entropy is thus zero. In order to
become perfectly crystalline at absolute zero, the system in question must be able
to explore its entire phase space: the system must be in internal thermodynamic
equilibrium. Thus the third law of thermodynamics does not apply to substances
that are not in internal thermodynamic equilibrium, such as glasses and glassy
crystals. Such non-ergodic states do have a finite entropy at the absolute zero,
called zero-point entropy or residual entropy at 0 K.

---
18 1 Thermodynamic foundations

Cym/IK™ mol!
AggS/I. Ko! molt

 

 

0 100 200 300 400°
TIK

Figure 1.6 Heat capacity of rhombic and monoclinic sulfur [4,5] and the derived entropy of
transition between the two polymorphs.

The third law of thermodynamics can be verified experimentally. The stable
rhombic low-temperature modification of sulfur transforms to monoclinic sulfur at
368.5 K (p = | bar). At that temperature, 7j;s, the two polymorphs are in equilib-
rium and the standard molar Gibbs energies of the two modifications are equal. We
therefore have

AusGm =AusHm —TsAtes Sm =0 (1.55)

It follows that the standard molar entropy of the transition can be derived from the
measured standard molar enthalpy of transition through the relationship

AusSm =AtsHm / Tus (1.56)

Calorimetric experiments give A,,,H;, =401.66 J mol-! and thus Ay, 5), = 1.09
JK-! mol"! [4]. The entropies of the two modifications can alternatively be derived
through integration of the heat capacities for rhombic and monoclinic sulfur given
in Figure 1.6 [4,5]. The entropy difference between the two modifications, also
shown in the figure, increases with temperature and at the transition temperature
(368.5 K) it is in agreement with the standard entropy of transition derived from the
standard enthalpy of melting. The third law of thermodynamics is thereby con-
firmed. The entropies of both modifications are zero at 0 K.

The Maxwell relations

Maxwell used the mathematical properties of state functions to derive a set of
useful relationships. These are often referred to as the Maxwell relations. Recall
the first law of thermodynamics, which may be written as

dU =dq + dw (1.57)

---
1.3 The second and third laws of thermodynamics 19

For a reversible change in a closed system and in the absence of any non-expansion
work this equation transforms into

dU =TdS — pdV (1.58)

Since dU is an exact differential, its value is independent of the path. The same
value of dU is obtained whether the change is reversible or irreversible, and eq.
(1.58) applies to any change for a closed system that only does pV work. Equation
(1.58) is often called the fundamental equation. The equation shows that the
internal energy of a closed system changes in a simple way when S and V are
changed, and U can be regarded as a function of S and V. We therefore have

au (2) as+f22Z) av (1.59)
as Jy av )s

 

It follows from eqs. (1.58) and (1.59) that

 

Ww) Lp (1.60)
a jy

and that
(2 =-p (1.61)
av )s

Generally, a function f(x,y) for which an infinitesimal change may be expressed
as

df = gdx + hdy (1.62)

is exact if

o8 -(2 (1.63)
oy), \ex)y

Thus since the internal energy, U, is a state function, one of the Maxwell relations
may be deduced from (eq. 1.58):

or) (2 (1.64)
vi, as jy

---
20 1 Thermodynamic foundations

Table 1.6 The Maxwell relations.

 

 

 

 

Thermodynamic Differential Equilibrium Maxwell's relations
function condition
U(S,V) dU = TdS — pdV (dU)s y=0 (=), -{2),
av. as
H(S,p) dH = TdS + Vdp or -(3),
op), \es
A(T,V) dA =-SdT - pdv (dA)py=0 (5) “
av), \arly
G(T, p) dG =-SdT + Vdp (dG)rp=0 as
OP), (a,
Vv A T
U G
Ss H P

Figure 1.7 The thermodynamic square. Note that the two arrows enable one to get the right
sign in the equations given in the second column in Table 1.6.

Using H =U + pV, A=U —TS andG =H —TS the remaining three Maxwell rela-
tions given in Table 1.6 are easily derived starting with the fundamental equation (eq.
1.58). A convenient method to recall these equations is the thermodynamic square
shown in Figure 1.7. On each side of the square appears one of the state functions
with the two natural independent variables given next to it. A change in the internal
energy dU, for example, is thus described in terms of dS and dV. The arrow from S to
T implies that TdS is a positive contribution to dU, while the arrow from p to V
implies that pdV is a negative contribution. Hence dU =TdS — pdV follows.

Properties of the Gibbs energy

Thermodynamics applied to real material systems often involves the Gibbs energy,
since this is the most convenient choice for systems at constant pressure and tem-
perature. We will thus consider briefly the properties of the Gibbs energy. As the
natural variables for the Gibbs energy are T and p, an infinitesimal change, dG, can
be expressed in terms of infinitesimal changes in pressure, dp, and temperature, dT.

ac -{22) 4 oF), aT (1.65)
Op )r or

---
1.3 The second and third laws of thermodynamics 21

The Gibbs energy is related to enthalpy and entropy through G = H — TS. For an
infinitesimal change in the system

dG =dH —TdS — SdT (1.66)
Similarly, H = U + pV gives
dH =dU + pdV + Vdp (1.67)

Thus in the absence of non-expansion work for a closed system, the following
important equation

dG =Vdp— SdT (1.68)

is easily derived using also eq. (1.58). Equations (1.65) and (1.68) implies that the
temperature derivative of the Gibbs energy at constant pressure is —S:

0G
=-S (1.69)
(=),

 

and thus that

T,
G(T;) =G(T,) - j sar (1.70)
;

where i and f denote the initial and final p and T conditions. Since S is positive fora
compound, the Gibbs energy of a compound decreases when temperature is
increased at constant pressure. G decreases most rapidly with temperature when S
is large and this fact leads to entropy-driven melting and vaporization of com-
pounds when the temperature is raised. The standard molar Gibbs energy of solid,
liquid and gaseous aluminium is shown as a function of temperature in Figure 1.8.
The corresponding enthalpy and entropy is given in Figures 1.2 and 1.5. The
melting (vaporization) temperature is given by the temperature at which the Gibbs
energy of the solid (gas) and the liquid crosses, as marked in Figure 1.8.
Equation (1.70) applies to each substance in a reaction and a change in the stan-
dard Gibbs energy of a reaction (p is now p® = | bar) going from 7; to Tf is given by

T;
A,G°(p) =A,G°(T) ~ JA, S°AT (71)
i

A,S° is not necessarily positive and the Gibbs energy of a reaction may increase
with temperature.

---
22 1 Thermodynamic foundations

 

 

 

 

 

0
~T 50
3 Trg= 933.47 K es
& -100 li :
Z ‘a:
o
& -150
of
6
ag ~200 Al a
cS Teap= 2790.8 K
250
0 1000 2000 3000
TIK

Figure 1.8 Standard Gibbs energy of solid, liquid and gaseous aluminium relative to the
standard Gibbs energy of solid aluminium at T= 0 K as a function of temperature (at p = 1
bar).

The pressure derivative of the Gibbs energy (eq. 1.68) at constant temperature is
Vv

 

0G
=V (1.72)
| op ),

and the pressure variation of the Gibbs energy is given as

Pr

G(p_) =G(pi) + | Vap (1.73)
Pi

Since V is positive for a compound, the Gibbs energy of a compound increases
when pressure is increased at constant temperature. Thus, while disordered phases
are stabilized by temperature, high-density polymorphs (lower molar volumes) are
stabilized by pressure. Figure 1.9 show that the Gibbs energy of graphite due to its
open structure increases much faster with pressure than that for diamond. Graphite
thus transforms to the much denser diamond modification of carbon at 1.5 GPa at
298 K.

Equation (1.73) applies to each substance in a reaction and a change in the Gibbs
energy of a reaction going from pj to p¢ is given by

Pr
A,G(pp) =A,G(pi) + | Ay Vp (1.74)
Pi

---
1.3 The second and third laws of thermodynamics 23

 

 

 

 

Ln

3

= c

Z5 Lo

3 Zt

°F Diamond .--~ \

= a 1,

Bh 's

mS Graphite

I

EO

S00 05 10 15 2.0
p/GPa

Figure 1.9 Standard Gibbs energy of graphite and diamond at T = 298 K relative to the
standard Gibbs energy of graphite at | bar as a function of pressure.

 

 

 

 

 

0
= -l <
te Kyanite ‘
= 2 a Sillimanite
a “a
& 3b
Be
4 Andalusite ALSiO,
Bo 0.5 1.0 15 2.0
p/GPa

Figure 1.10 The standard Gibbs energy of formation from the binary constitutent oxides of
the kyanite, sillimanite and andalusite modifications of Al7SiOs as a function of pressure at
800 K. Data are taken from [3]. All three oxides are treated as incompressible.

A,V is not necessarily positive, and to compare the relative stability of the different
modifications of a ternary compound like AlpSiOs the volume of formation of the
ternary oxide from the binary constituent oxides is considered for convenience.
The pressure dependence of the Gibbs energies of formation from the binary con-
stituent oxides of kyanite, sillimanite and andalusite polymorphs of AljSiOs are
shown in Figure 1.10. Whereas sillimanite and andalusite have positive volumes of
formation and are destabilized by pressure relative to the binary oxides, kyanite
has a negative volume of formation and becomes the stable high-pressure phase.
The thermodynamic data used in the calculations are given in Table 1.7 [3].!

 

1 Note that these three minerals, which are common in the Earth’s crust, are not stable at
ambient pressure at high temperatures. At ambient pressure, mullite (3Al203-2SiO2), is
usually found in refractory materials based on these minerals.

---
24 1 Thermodynamic foundations

Table 1.7 Thermodynamic properties of the kyanite, sillimanite and andalusite poly-
morphs of Al7SiOs at 800 K [3].

 

 

 

Compound AH SQV ArawHl Aco At Atala

moet TKI mmol! mort JKT Tmo = Gm mor!
mol! mol!

Sillimanite -2505.57 252.4 50.4 —3.32 0.1 -3400 .

Kyanite 2513.06 240.1 44.8 10.81 -12.2 1050 43

Andalusite -2509.08 248.8 52.2 6.83 -3.5 4030 3.1

ALO; 1622.62 152.2 25.8

SiO -879.63 100.1 23.3

 

1.4 Open systems

Definition of the chemical potential

A homogeneous open system consists of a single phase and allows mass transfer
across its boundaries. The thermodynamic functions depend not only on tempera-
ture and pressure but also on the variables necessary to describe the size of the
system and its composition. The Gibbs energy of the system is therefore a function
of T, p and the number of moles of the chemical components i, n;:
G=G(T,p,n;) (1.75)

The exact differential of G may be written

a(S) ar+(2) [2] dn; (1.76)
OT Jn P Irn, TT panjei

The partial derivatives of G with respect to T and p, respectively, we recall are —S
and V. The partial derivative of G with respect to nj is the chemical potential of
component /, Ll;

eG
Mi (3 | (1.77)
oni Ip PR ji

Equation (1.68) can for an open system be expressed as

 

 

 

G =-SdT + Vdp + > w;dn; (1.78)
i
The internal energy, enthalpy and Helmholtz energy can be expressed in an analo-
gous manner:

---
1.4 Open systems 25

dU =TdS — pdV + Yj dn; (1.79)
i

dH =TdS + Vdp + ¥°u;dn; (1.80)
i

dA =-SdT — pdV +) u;dn; (1.81)

i

The chemical potential is thus defined by any of the following partial derivatives:

én; )y Pl jai en; TV ngs én; SPM jei én; SV npg;

Conditions for equilibrium in a heterogeneous system

 

 

 

Recall that the equilibrium condition for a closed system at constant T and p was
given by eq. (1.41). For an open system the corresponding equation is

 

(dG)r pn, =9 (1.83)
For such a system, which allows transfer of both heat and mass, the chemical poten-
tial of each species must be the same in all phases present in equilibrium; hence

ue =p? =p =... (1.84)

Here a, B and y denote different phases in the system, whereas i denotes the dif-
ferent components of the system.

Partial molar properties

In open systems consisting of several components the thermodynamic properties
of each component depend on the overall composition in addition to T and p.
Chemical thermodynamics in such systems relies on the partial molar properties
of the components. The partial molar Gibbs energy at constant p, T and nj (eq. 1.77)
has been given a special name due to its great importance: the chemical potential.
The corresponding partial molar enthalpy, entropy and volume under the same
conditions are defined as

A, {#) (1.85)
Oi NP pn jo

 

5 {2) (1.86)
On; )y PAR i

---
26 1 Thermodynamic foundations

7; {*) (1.87)
én; TPM pi

Note that the partial molar derivatives may also be taken under conditions other
than constant p and 7.

 

The Gibbs-Duhem equation

In the absence of non pV-work, an extensive property such as the Gibbs energy of a
system can be shown to be a function of the partial derivatives:

 

on; i i

0G =
| } =)0,G; = Vin; (1.88)
i TPM jei

In this context G itself is often referred to as the integral Gibbs energy.
For a binary system consisting of the two components A and B the integral Gibbs

energy eq. (1.88) is

G=ngly +nplp (1.89)
Differentiation of eq. (1.89) gives

dG =nadua +daaty +ngdig +dngug (1.90)
By using eq. (1.78) at constant T and p, G is also given by

dG =uUadn,y +Upgdng (1.91)

By combining the two last equations, the Gibbs—Duhem equation for a binary
system at constant 7 and p is obtained:

nad, +ngdug=0 ie. S'nj;du; =0 (1.92)
i

In general, for an arbitrary system with i components, the Gibbs—Duhem equa-
tion is obtained by combining eq. (1.78) and eq. (1.90):

SdT -Vdp + > njdp; =0 (1.93)
i
Expressions for the other intensive parameters such as V, S and H can also be
derived:

YinidV; =0 (1.94)
i

---
1.4 Open systems 27
Yinjd5; =0 (1.95)
i
¥in,dH; =0 (1.96)
i

The physical significance of the Gibbs-Duhem equation is that the chemical
potential of one component in a solution cannot be varied independently of the
chemical potentials of the other components of the solution. This relation will be
further discussed and used in Chapter 3.

References

[1] _H.D.Beckhaus, T. Ruchardt, M. Kao, F, Diederich and C. S. Foote, Angew. Chem. Int.
Ed., 1992, 31, 63.

[2] H.P. Diogo, M. E. M. da Piedade, A. D. Darwish and T. J. S. Dennis, J. Phys. Chem.
Solids, 1997, 58, 1965.

[3] S.K. Saxena, N. Chatterjee, Y. Fei and G. Shen, Thermodynamic Data on Oxides and
Silicates, Berlin: Springer-Verlag, 1993.

[4] E. D. West, J. Am. Chem. Soc., 1959, 81, 29.

[5] _E. D. Eastman and W. C. McGavock, J. Am. Chem. Soc., 1937, 59, 145.

Further reading

P. W. Atkins and J. de Paula, Physical Chemistry, 7th edn. Oxford: Oxford University Press,
2001.

E, A. Guggenheim, Thermodynamics: An Advanced Treatment for Chemists and Physicists,
7th edn. Amsterdam: North-Holland, 1985.

K. S. Pitzer, Thermodynamics. New York: McGraw-Hill, 1995. (Based on G. N. Lewis and
M. Randall, Thermodynamics and the free energy of chemical substances. New York:
McGraw-Hill, 1923.)

D. Kondepudi and I. Prigogine, Modern Thermodynamics: from Heat Engines to
Dissipative Structures. Chichester: John Wiley & Sons, 1998.

F. D. Rossini, Chemical Thermodynamics. Chichester: John Wiley & Sons, 1950.

---
