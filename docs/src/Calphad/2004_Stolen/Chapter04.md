Chemical Thermodynamics of Materials: Macroscopic and Microscopic Aspects.
Svein Stolen and Tor Grande
Copyright 2004 John Wiley & Sons, Ltd. ISBN: 0-471-49230-2

Phase diagrams

 

Thermodynamics in materials science has often been used indirectly through phase dia-
grams. Knowledge of the equilibrium state of a chemical system for a given set of condi-
tions is a very useful starting point for the synthesis of any material, for processing of
materials and in general for considerations related to material stability. A phase diagram
is a graphical representation of coexisting phases and thus of stability regions when
equilibrium is established among the phases of a given system. A material scientist will
typically associate a ‘phase diagram’ with a plot with temperature and composition as
variables. Other variables, such as the partial pressure of a component in the system, may
be given explicitly in the phase diagram; for example, as a line indicating a constant par-
tial pressure of a volatile component. In other cases the partial pressure may be used as a
variable. The stability fields of the condensed phases may then be represented in terms of
the chemical potential of one or more of the components.

The Gibbs phase rule introduced in Section 2.1 is an important guideline for the
construction and understanding of phase diagrams, and the phase rule is therefore
referred to frequently in the present chapter. The main objective of the chapter is to
introduce the quantitative link between phase diagrams and chemical thermody-
namics. With the use of computer programs the calculation of phase diagrams from
thermodynamic data has become a relatively easy task. The present chapter focuses
on the theoretical basis for the calculation of heterogeneous phase equilibria with
particular emphasis on binary phase diagrams.

4.1 Binary phase diagrams from thermodynamics
Gibbs phase rule

In chemical thermodynamics the system is analyzed in terms of the potentials
defining the system. In the present chapter the potentials of interest are T (thermal

85

---
86 4 Phase diagrams

potential), p (mechanical potential) and the chemical potential of the components
Hy, H2,---, Ly We do not consider other potentials, e.g. the electrical and magnetic
potentials treated briefly in Section 2.1. In a system with C components there are
therefore C +2 potentials. The potentials of a system are related through the
Gibbs—Duhem equation (eq. 1.93):

SdT -Vdp + > njdp; =0 (4.1)
i

and also through the Gibbs phase rule (eq. 2.15):
F+Ph=C+2 (4.2)

The latter is used as a guideline to determine the relationship between the number
of potentials that can be varied independently (the number of degrees of freedom,
F) and the number of phases in equilibrium, Ph. Varied independently in this con-
text means varied without changing the number of phases in equilibrium.

For a single-component system, the Gibbs phase rule reads F + Ph = C + 2 =3,
and we can easily construct a p,7-phase diagram in two dimensions (see Figure 2.7,
for example). To apply the Gibbs phase rule to a system containing two or more
components (C > 1) it is necessary to take into consideration the nature of the dif-
ferent variables (potentials), the number of components, chemical reactions and
compositional constraints. Initially we will apply the Gibbs phase rule to a binary
system (C = 2). The Gibbs phase rule is then F + Ph = C +2 =4, and since at least
one phase must be present, F is at most 3. Three dimensions are needed to show the
phase relations as a function of 7, p and a compositional variable (or a chemical
potential). Here, we will use the mole fraction as a measure of composition
although in some cases the weight fraction and other compositional variables are
more practical. When a single phase is present (F = 3), T, p and the composition
may be varied independently. With two phases present (F = 2) a set of two intensive
variables can be chosen as independent; for example temperature and a composi-
tion term, or pressure and a chemical potential. With three phases present only a
single variable is independent (F = 1); the others are given implicitly. Finally, with
four phases present at equilibrium none of the intensive variables can be changed.
The observer cannot affect the chemical equilibrium between these four phases.

It is sometimes convenient to fix the pressure and decrease the degrees of
freedom by one in dealing with condensed phases such as substances with low
vapour pressures. Gibbs phase rule then becomes

F=C-Ph+1 (4.3)

often called the reduced or condensed phase rule in metallurgical literature.

For a binary system at constant pressure the phase rule gives F = 3 — Ph and we need
only two independent variables to express the stability fields of the phases. It is most
often convenient and common to choose the temperature and composition, given for

---
4.1 Binary phase diagrams from thermodynamics 87

example as the mole fraction. An example is the phase diagram of the system Ag-—Cu
shown in Figure 4.1 [1]. There are only three phases in the system: the solid solutions
Cu(ss) and Ag(ss) and the Ag—Cu liquid solution. Cu(ss) and Ag(ss) denote solid solu-
tions with Cu and Ag as solvents and Ag and Cu as solutes, respectively. When a single
phase is present, for example the liquid, F = 2 and both composition and temperature
may be varied independently. The stability fields for the liquid and the two solid solu-
tions are therefore two-dimensional regions in the phase diagram. With two phases in
equilibrium, the temperature and composition are no longer independent of each other.
It follows that the compositions of two phases in equilibrium at a given temperature are
fixed. In the case of a solid-liquid equilibrium the composition of the coexisting
phases are defined by the solidus and liquidus lines, respectively. This is illustrated in
Figure 4.1 where the composition of Cu(ss) in equilibrium with the liquid (also having
a distinct composition) for a given temperature, T, is indicated by open circles. Since
F=1 this is called a univariant equilibrium. Finally, when three phases are present at
equilibrium, F = 0 and the compositions of all three phases and the temperature are
fixed. In this situation there are no degrees of freedom and the three phases are there-
fore present in an invariant equilibrium. In the present example, the system Ag—Cu,
the two solid and the liquid phases coexist in an invariant eutectic equilibrium at 1040
K. The eutectic reaction taking place is defined in general for a two-component
system as one in which a liquid on cooling solidifies under the formation of two solid
phases. Hence for the present example the eutectic reaction is

liquid + Cu(ss) + Ag(ss) (4.4)

The temperature of the eutectic equilibrium is called the eutectic temperature and
is shown as a horizontal line in Figure 4.1.

It should be noted that we have here considered the system at constant pressure.
If we are not considering the system at isobaric conditions, the invariant equilib-
rium becomes univariant, and a univariant equilibrium becomes divariant, etc. A

1400

 

1300

1200

T/K

1100

 

 

 

 

1000 Ag(ss)+CuGss) pi Ql
900.
0.0 0.2 0.4 0.6 0.8 1.0

*cu

Figure 4.1 Phase diagram of the system Ag-Cu at 1 bar [1].

---
88 4 Phase diagrams

consequence is that the eutectic temperature in the Ag—Cu system will vary with
pressure. However, as discussed in Section 2.3, small variations in pressure give
only minor variations in the Gibbs energy of condensed phases. Therefore minor
variations in pressure (of the order of 1-10 bar) are not expected to have a large
influence on the eutectic temperature of a binary system.

One of the useful aspects of phase diagrams is that they define the equilibrium
behaviour of a sample on cooling from the liquid state. Assume that we start at high
temperatures with a liquid with composition x in the diagram shown in Figure 4.1.
On cooling, the liquidus line is reached at 7). At this temperature the first crystal-
lites of the solid solution Cu(ss) are formed at equilibrium. The composition of
both the liquid and Cu(ss) changes continuously with temperature. Further cooling
produces more Cu(ss) at the expense of the liquid. If equilibrium is maintained the
last liquid disappears at the eutectic temperature. The liquid with eutectic compo-
sition will at this particular temperature precipitate Cu(ss) and Ag(ss) simulta-
neously. The system is invariant until all the liquid has solidified. Below the
eutectic temperature the two solid solutions Cu(ss) and Ag(ss) are in equilibrium,
and for any temperature the composition of both solid solutions can be read from
the phase diagram, as shown for the temperature 73.

The relative amount of two phases present at equilibrium for a specific sample is
given by the lever rule. Using our example in Figure 4.1, the relative amount of
Cu(ss) and Ag(ss) at 73 when the overall composition is xcy, is given by the ratio

Agtss)
OP __ Xu > cu (45)
oO Cu(ss) _  Ag(ss) .
Qe *cu

where x8") and xA®° denote the mole fractions of Cu in the two coexisting

solid solutions. The lines OP and OQ are shown in the figure. An isothermal line in
a two-phase field, like the line OQ, is called a tieline or conode. As the overall
composition is varied at constant temperature between the points O and Q, the
compositions of the two solid phases remain fixed at O and Q; only the relative
amount of the two phases changes.

 

Conditions for equilibrium

Phase diagrams show coexistent phases in equilibrium. We have seen in Chapter 1
that the conditions for equilibrium in a heterogeneous closed system at constant
pressure and temperature can be expressed in terms of the chemical potential of the
components of the phases in equilibrium:

 

fori=1,2

 

(4.6)

Here a, Band y denote the different phases, whereas i denotes the different components
of the system and C the total number of components. The conditions for equilibrium

---
4.1 Binary phase diagrams from thermodynamics 89

between two phases @ and f in a binary system A-B (at a given temperature and
pressure) are thus

He (x%) = 8 (xB) (4.7)
and

mgr) = mgr) (4.8)
where xR and xB are the mole fractions of A in the phases o and B at equilibrium
(remember that xy + XB =1).

Ata given temperature and pressure eqs. (4.7) and (4.8) must be solved simulta-
neously to determine the compositions of the two phases @and f that correspond to
coexistence. At isobaric conditions, a plot of the composition of the two phases in
equilibrium versus temperature yields a part of the equilibrium 7, x-phase diagram.

Equations (4.7) and (4.8) may be solved numerically or graphically. The latter
approach is illustrated in Figure 4.2 by using the Gibbs energy curves for the liquid

and solid solutions of the binary system Si-Ge as an example. The chemical poten-
tials of the two components of the solutions are given by eqs. (3.79) and (3.80) as

dG iy

Ge

(4.9)

Hee =Gm +(l- xGe)

 

(4.10)

 

Here G,, is the Gibbs energy of the given solution at a particular composition xGe.
The equilibrium conditions can now be derived graphically from Gibbs energy
versus composition curves by finding the compositions on each curve linked by a
common tangent (the common tangent construction). In the case shown in Figure
4.2(a) the solid and liquid solutions are in equilibrium; they are not in the case
shown in Figure 4.2(b). The compositions of the coexisting solid and liquid solu-
tions are marked by arrows in Figure 4.2(a).

The relationship between the Gibbs energy of the phases present in a given system
and the phase diagram may be further illustrated by considering the variation of the
Gibbs energy of the phases in the system Si—Ge with temperature. Similar common
tangent constructions can then be made at other temperatures as well using thermo-
dynamic data by Bergman ef al. [2]. The phase diagram of the system is given in
Figure 4.3(a). A sequence of Gibbs energy—composition curves for the liquid and
solid solutions are shown as a function of decreasing temperature in Figures
4.3(b)-(f). The two Gibbs energy curves are broad and have shallow minima and the
excess Gibbs energies of mixing are small since Ge and Si are chemically closely

---
90 4 Phase diagrams

&

Gy / kJ mol
‘
S

Gm /kJ mol!
&

i
Ea
1
\
eo.

    

 

12 12
0.0 0.2 04 0.6 08 1.0 0.0 0.2 04 06 08 10
XGe *Ge
Figure 4.2. Gibbs energy curves for the liquid and solid solution in the binary system Si-Ge
at 1500 K. (a) A common tangent construction showing the compositions of the two phases

in equilibrium. (b) Tangents at compositions that do not give two phases in equilibrium.
Thermodynamic data are taken from reference [2].

related. This is often termed near-ideal behaviour. At high temperatures, e.g. at T),
where the liquid solution is stable over the whole composition region, the Gibbs
energy of the liquid is more negative than that of the solid solution for all composi-
tions (Figure 4.3(b)). On cooling, the Gibbs energy of the solid solution, having
lower entropy than the liquid solution, increases more slowly than that of the liquid
solution. At Tz, the Gibbs energies of pure liquid Si and pure solid Si are equal, and
the melting temperature of pure Si is reached (Figure 4.3(c)). For xs; < 1 the liquid
solution is more stable than the crystalline phase. Further cooling gives situations
corresponding to T3 or T4, where the solid solution is stable for the Si-rich composi-
tions and the liquid solution for the Ge-rich compositions. The Gibbs energy curves
at these two temperatures are shown in Figures 4.3(d) and (e). The compositions of
the two phases in equilibrium at these temperatures are given by the common tangent
construction, as illustrated in Figure 4.3(d). At 75 the liquid has been cooled down to
the melting temperature of pure Ge (see Figure 4.3(f)). Below this temperature the
solid solution is stable for all compositions. Since Ge and Si are chemically closely
related, Si-Ge forms a complete solid solution at low temperatures. The resulting
equilibrium phase diagram, shown in Figure 4.3(a), is a plot of the locus of the
common tangent constructions and defines the compositions of the coexisting
phases as a function of temperature. The solidus and liquidus curves here define the
stability regions of the solid and liquid solutions, respectively.

Ideal and nearly ideal binary systems

Let us consider a binary system for which both the liquid and solid solutions are
assumed to be ideal or near ideal in a more formal way. It follows from their near-

---
4.1 Binary phase diagrams from thermodynamics

a1

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

1800
10} 7;
1600 - 35
“ =
@ > ) 2 OW cot
1400 é
5 liq
1200 -10
00 02 04 06 08 1.0 00 02 0406 08 1.0
XGe *Ge
tol 7,
_ 5
£
© 2°
5 sol
S
5 liq
Sula
Msi=Hsi
-10 HRW
00 02 0406 08 1.0 02 04 06 08 1.0
*Ge %Ge
10 1; 10 Ts
liq
= 35 liq = 3
E E
@ 2° 20
& sol & sol
5 5
=10 -10
00 02 04 06 08 1.0 00 02 04 06 08 1.0
*Ge *Ge

Figure 4.3 (a) Phase diagram for the system Si—Ge at | bar defining the five temperatures
for the Gibbs energy curves shown in (b) 71; (c) Tz; (d) T3; (e) T4; (f) Ts . Thermodynamic
data are taken from reference [2].

ideal behaviour that the two components must have similar physical and chemical
properties in both the solid and liquid states. Two systems which show this type of
behaviour are the Si-Ge system discussed above and the binary system

---
92 4 Phase diagrams

FeO-MnO!.2. However, we will initially look at a general A-B system. The chem-
ical potentials of component A in the liquid and solid states are given as

ss = 80 ss
MX = MA + RT Inay (4.11)
hd =y)o + RT Ina)’ (4.12)

Similar expressions are valid for the chemical potential of component B of the two
phases. According to the equilibrium conditions given by eqs. (4.7) and (4.8), the
solid and liquid solutions are in equilibrium when p> =a and py = is , giving
the two expressions

WS + RT InaS =p? +RT Ina (4.13)
My? +RT nay =pg° +RT Inaje (4.14)

which may be rearranged as

 

 

liq os 1)
a A
inf “A [=a (4.15)
as RT
A
and
liq os)
a A
In “B_ Jee a (4.16)
ay
Here Au 93>) is the change in chemical potential or Gibbs energy on fusion of

i

pure i. By using G = H — TS we have
AMD = ph? — WS? =A gysGP =A gus? —TA gus S? (4.17)

At the melting temperature we have AnusG; =0, which implies that A fs S? =
A tus ?/Tus.i- If the heat capacity of the solid and the liquid are assumed to be
equal, the enthalpy of fusion is independent of temperature and eq. (4.17) becomes

 

1 The FeO-MnO system is in principle a three-component system, but can be treated as a two-
component system. This requires that the chemical potential of one of the three elements is
constant.

2. The fact that FeO is non-stoichiometric is neglected.

---
4.1 Binary phase diagrams from thermodynamics 93

SS? = Apull? Thee S? Bout] (4.18)
fus,i

Substitution of eq. (4.18) into eqs. (4.15) and (4.16) gives

 
 

 
 

 

 

 

li sol
In ag — AW Atal iol (4.19)
as RT RUT Tiasa .
and
li sol
in| SB Ag OY  MeasB(1 (4.20)
ay RT R T Thus,p .

If we furthermore assume that the solid and liquid solutions are ideal the activi-
ties can be replaced by mole fractions and eqs. (4.19) and (4.20) rearrange to

 

 

 

 

 

A fuse
xl = p-—tetaft__t (4.21)
R T Tras,a
and
A fas?
alld = 8 exp) — Bilt (4.22)
T Trsp

 

Analytical equations for the solidus and liquidus lines can now be obtained from
these equations by noting that xia + apt =land x¥ +x5 =1 giving

° oO
eS exp —ataf tt Vy iss a Ate (tt Ly
A B
ROT Tras. R UT Trp
(4.23)

 

 

 

and

 

 

 

---
94 4 Phase diagrams

1700

1600

ideal model

Cp =0

ss

 

0.0 0.2 0.4 0.6 0.8 1.0
XGe

Figure 4.4 Phase diagram for the system Si-Ge at 1 bar. The solid lines represent experi-
mental observations [2] while the dotted and dashed lines represent calculations assuming
that the solid and liquid solutions are ideal with AC, #0 and AC, =0, respectively.

In this particular case of ideal solutions the phase diagram is defined solely by the
temperature and enthalpy of fusion of the two components.

Using the analytical equations derived above, we are now able to consider the
phase diagrams of the two nearly ideal systems mentioned above more closely. In
the calculations we will initially use only the melting temperature and enthalpy of
fusion of the two components as input parameters; both the solid and liquid solu-
tions are assumed to be ideal. The observed (solid lines) and calculated (dashed
lines) phase diagrams for the systems Si-Ge [2] and FeEO-MnO [3] are compared in
Figure 4.4 and 4.5. Although the agreement is reasonable, the deviation between
the calculated and observed solidus and liquidus lines is significant.

 

2200

 

2000

TIK

1800

 

 

 

 

1600
0.0 0.2 0.4 0.6 0.8 1.0

*Mno

Figure 4.5 Phase diagram of FeEO-MnO at | bar. The solid lines represent experimental
observations [3]. The activity of iron is kept constant and equal to | by equilibration with
liquid Fe. Dashed lines represent calculations assuming that the solid and liquid solutions
are ideal.

---
4.

Binary phase diagrams from thermodynamics 95

 

=. AG) =0

    

°
AfwGn,/ kJ mol

 

 

 

-15
1200 1300 1400 1500 1600 1700
TIK

Figure 4.6 Gibbs energy of fusion of Ge and Si. The solid lines represent experimental data
[4] while the broken lines are calculated neglecting the heat capacity difference between
liquid and solid.

Let us now consider the effect of a difference between the heat capacity of pure
liquid i and pure solid i on the enthalpy and entropy of fusion and subsequently on
the phase diagram. This effect is easily taken into consideration by using eqs.
(1.24) and (1.54). Awes>d is now given as

°

Tr T AC
AUD =A sys? + face jar -7 Agus S? + J phar (4.25)

Tras,i Trus.i

where AC =c}° —C 7°. We will use the system Si-Ge as example. Ameer for
Si and Ge with (solid lines) and without (dashed lines) taking the heat capacity dif-
ference into consideration are shown in Figure 4.6 [4], while the effect of AC} on
the calculated liquidus and solidus lines is shown in Figure 4.4 (dotted lines). In
this particular case, the liquids and solidus lines are shifted some few degrees up
and down in temperature, respectively, and the resulting two-phase field is only
slightly broader than that calculated without taking the heat capacity difference
between the liquid and the solid into consideration. The lack of quantitative agree-
ment between the experimentally observed phase diagram and the calculated ones
shows that significant excess Gibbs energies of mixing are present for one or both
of the solution phases in the Si-Ge system. This indicates what is in general true:
non-ideal contributions to the solution energetics in general have a much larger
effect on the calculated phase diagrams than the heat capacity difference between
the liquid and solid. This is reflected in the phase diagram for the binary system
KCI-NaCl shown in Figure 4.7(a) [5]. This system is characterized by negative
deviation from ideal behaviour in the liquid state and positive deviation from
ideality in the solid state (see the corresponding G—x curves for the solid and liquid
solutions in Figure 4.7(b)). In general a negative excess Gibbs energy of mixing

---
9% 4 Phase diagrams

1100

v

 

 

1050 0

   
 

(a) ¥ 1000
BR

     
  

solid solution

   

liquid

 

 

 

 

 

 

950 fs '
solidsolution + | fot
2000 0.2 04 06 08 10 ~%o 02 04 06 O8 10
Nac *NaCl

Figure 4.7 (a) Phase diagram of the system KCI-NaCl. (b) Gibbs energy curves for the
solid and liquid solutions KCI-NaCl at 1002 K. Thermodynamic data are taken from refer-
ence [5].

corresponds to a stabilization of the solution and a deeper curvature of the G—x
curve compared to ideal solution behaviour. Correspondingly, a positive deviation
from ideal behaviour destabilizes the solution and the G—x curve becomes shal-
lower. These features affect the resulting phase diagrams and the liquidus and sol-
idus lines may show maxima or minima for intermediate compositions, as evident
for the KCI-NaCl system in Figure 4.7(a).

Simple eutectic systems

Ag-Cu (Figure 4.1) and many other inorganic systems give rise to simple eutectic
phase diagrams. In these systems the two solid phases have such different chemical
and physical properties that the solid solubility is limited. The phases may have dif-
ferent structures and hence be represented by different Gibbs energy curves, or
they may take the same structure but with a large positive enthalpic interaction
giving rise to phase separation or immiscibility at low temperatures. The latter situ-
ation, where two solid solutions are miscible at high temperatures, is more usual
for alloys and less usual in inorganic material systems. It is, however, a very useful
situation for illustrating the link between thermodynamics and phase diagrams, as
we will see in the next section on regular solution modelling. It is worth noting that
two components that have different properties in the solid state still may form a
near-ideal liquid solution.

The system MgO-Y203 [6] can be used to exemplify the link between Gibbs
energy curves and the characteristic features of a simple eutectic phase diagram.
The MgO-Y203 phase diagram is shown in Figure 4.8(a). MgO and Y203 have dif-
ferent crystal structures and the solid solubility of the two oxides is therefore lim-
ited. Furthermore, Y2O3 is found in both hexagonal and cubic polymorphs. Gibbs

---
4.1 Binary phase diagrams from thermodynamics 97

 

 

 

 

 

 

 

 

 

3200
- 10 7,
3000 liquid 5 ©-¥,0;
€-¥20,(68) -_ ‘MgO
2800 Zo
@& ) 2
2600 e
-10
2400
-15 liquid
2200 3
0.0 02 04 06 08 10 0.0 02 04 06 08 10
*YOis XYO;5
15} %

   
    

©-¥,0,(6)

S
Gm/ kJ mol

5

 

liquid

000304 06 08 1.0 0.0 020406 08 10
*YO15

 

 

 

 

 

&
Gm/ kJ mol

MgO(s)

 

 

 

 

 

 

0.0 02 04 06 08
*YO1s

 

Figure 4.8 (a) Phase diagram of the binary system Y03—MgO at | bar defining the five
temperatures for the Gibbs energy curves shown in (b) T; (c) T2; (d) T3; (e) Ta; (£) Ts. Ther-
modynamic data are taken from reference [6].

energy representations for the selected temperatures given in the phase diagram are
shown in Figures 4.8(b)—-(f). At 7; the liquid is stable at all compositions (Figure
4.8(b)). At Tz solid MgO(ss) has become stable for MgO-rich compositions
(Figure 4.8(c)) and the two-phase field between MgO(ss) and the liquid is

---
98 4 Phase diagrams

established by the common tangent construction. At 73 solid MgO(ss) is stable
for MgO-rich compositions, while the cubic polymorph of Y203(ss) is stable
for Y203-rich compositions. At intermediate compositions the liquid is stable.
The compositions of the liquid coexisting with MgO(ss) and Y 03(ss) are
again defined by common tangent constructions. Cubic Y203(ss) transforms to
the hexagonal polymorph at the phase transition temperature given by the hori-
zontal line at T = 2540 K. This transition will be further considered below. At the
eutectic temperature, 74, three phases are in equilibrium (see Figure 4.8(e))
according to

liquid = h- Y203(ss) + MgO(ss) (4.26)

At an even lower temperature, 75, a sample in equilibrium will consist of the
crystalline phase h- Y203(ss), MgO(ss) or a two-phase mixture of these (see Figure
4.8(f)). The compositions of the two phases in equilibrium are again given by the
common tangent construction.

Regular solution modelling

The examples focused on so far have demonstrated that phase diagrams contain
valuable information about solution thermodynamics. We will illustrate this fur-
ther by using the regular solution model, introduced in Section 3.4, to calculate a
range of phase diagrams. Although the regular solution model may represent a very
crude approximation for a large number of real solutions, it has proven to be very
efficient in many respects.

The equilibrium conditions given by eqs. (4.15) and (4.16) can in general be
expressed through the activity coefficients. Using a solid—liquid phase equilibrium
as an example we obtain

 

liq lig. liq o(s1)
inf “8 |e q) 2A YA =-Ya (4.27)
ss sys
ay Tala
and
liq liq liq o(s1)
in 2B loin) 2B 4B. |__AHB (4.28)
ag xBYB RT

These expressions can be simplified since the activity coefficient in the particular
case of a regular solution can be expressed by the regular solution constant Q
through eqs. (3.84) and (3.85):

---
4.1 Binary phase diagrams from thermodynamics 99

1400

 

 

solid solution

1200

1000
M
N b
(a) = (b)

800

AmixGm/ KI mol

600 V,0,(ss) — Cry

 

 

 

 

 

 

 

 

009 0.2 04 06 08 1.0 00 02 04 06 O08 10

X13 XAl,0;

Figure 4.9 (a) Immiscibility gap of the binary solid solution V203-Cr703 as described by
the regular solution model. (b) Gibbs energy of mixing curve of the solid solution at the
temperatures marked in the phase diagram. Thermodynamic data are taken from reference

(71.

 

gia ss 5 Auer)
Ind — lid) +22 ¢ligy)? ~ ing — x8) -=_ (a8)? =- A (4.29)
Oo xB RT &B (xB RF B RT ‘
. qliia 5 Qs Aus>d
In lid 4 q— yl)? — Jy x88 — = _— x8)? =-  B__ 4.30)
BRT (ox) B RT B RT ‘

These two simultaneous equations can then be solved numerically to calculate the
solidus and liquidus lines.

It should be remembered that if we assume that a solution phase in a hypothetical
A-B system is regular, a positive interaction parameter implies that the different
types of atom interact repulsively and that if the temperature is not large enough
phase separation will occur. Let us first consider a solid solution only. The
immiscibility gap of the solid solution in the binary system V203-—Cr203 [7] given
in Figure 4.9(a) can be described by a regular solution model and thus may be used
as an example. The immiscibility gap is here derived by using the positive interac-
tion parameter reported for the solid solution [7]. There is no solubility at absolute
zero. As the temperature is raised, the solubility increases with the solubility limits
given by the interaction coefficient, Q , and by temperature. Figure 4.9(b) show the
Gibbs energy curves for the solid solution and the common tangent constructions
defining the compositions of the coexisting solid solutions at different selected
temperatures.

Let us now return to our hypothetical system A-B where we also consider the
liquid and where the solid and liquid solutions are both regular (following Pelton and

---
100 4 Phase diagrams

Thompson [8]). Pure A and B are assumed to melt at 800 and 1000 K with the
entropy of fusion of both compounds set to 10 J K-! mol! (this is the typical entropy
of fusion for metals, while semi-metals like Ga, In and Sb may take quite different
values — in these three specific cases 18.4, 7.6 and 21.9 J K~! mol-!, respectively).
The interaction coefficients of the two solutions have been varied systematically in
order to generate the nine different phase diagrams given in Figure 4.10.

In the diagram in the middle (Figure 4.10(e)), both the solid and liquid solutions
are ideal. Changing the regular solution constant for the liquid to -15 or +15 kJ
mol-!, while keeping the solid solution ideal evidently must affect the phase dia-
gram. In the first case (Figure 4.10(d)), the liquid is stabilized relative to the solid
solution. This is reflected in the phase diagram by a shift in the liquidus line to
lower temperatures and in this particular case a minimum in the liquidus tempera-
ture is present for an intermediate composition. Correspondingly, the positive
interaction energy for the liquid destabilizes the liquid relative to the solid solution
and the liquidus is in this case shifted to higher temperatures: see Figure 4.10(f).
For the composition corresponding to the maximum or minimum in the liquidus/
solidus line, the melt has the same composition as the solid. A solid that melts and
forms a liquid phase with the same composition as the solid is said to melt congru-
ently. Hence the particular composition that corresponds to the maximum or min-
imum is termed a congruently melting solid solution.

Positive deviations from ideal behaviour for the solid solution give rise to a mis-
cibility gap in the solid state at low temperatures, as evident in Figures 4.10(a)-(c).
Combined with an ideal liquid or negative deviation from ideal behaviour in the
liquid state, simple eutectic systems result, as exemplified in Figures 4.10(a) and
(b). Positive deviation from ideal behaviour in both solutions may result in a phase
diagram like that shown in Figure 4.10(c).

Negative deviation from ideal behaviour in the solid state stabilizes the solid solu-
tion. QS°! =-10 kJ mol-!, combined with an ideal liquid or a liquid which shows pos-
itive deviation from ideality, gives rise to a maximum in the liquidus temperature for
intermediate compositions: see Figures 4.10(h) and (i). Finally, negative and close to
equal deviations from ideality in the liquid and solid states produces a phase diagram
with a shallow minimum or maximum for the liquidus temperature, as shown in
Figure 4.10(g).

The mathematical treatment can be further simplified in one particular case, that
corresponding to Figure 4.10(a). As we saw in the previous section, in some binary
systems the two terminal solid solution phases have very different physical proper-
ties and the solid solubility may be neglected for simplicity. If we assume no solid
solubility (i.e. a’ =a =1) and in addition neglect the effect of the heat capacity
difference between the solid and liquid components, eqs. (4.29) and (4.30) can be
transformed to two equations describing the two liquidus branches:

 

liq AfusHe
In.xlia 42 (glia? Af al 1d (4.31)
RT R LT Tyasa

---
4.1 Binary phase diagrams from thermodynamics 101

 

 

 

 

 

 

Q"9/kI mol
-15 0 1S
@) ) ©
liq 1200
lig lig + A(ss)
900
liq + A(ss) x
&
fig + Biss) A(ss) + BGss) 600
A(ss) + B(ss)
A(ss) B(ss)
300
A(ss) + B(ss)
(d) (e) () lig
liq + ss liq

 
    

 
 

liq 48s
lig + ss

  

ss

28" /kI mol! >

 

00 02 04 06 08 10
*~B

 

lig

      

lig
liq+
liq +s
-10 liq + ss
lig + ss
8s ss
(g) (h) w@

 

 

 

 

 

 

 

Figure 4.10 (a)-(i) Phase diagrams of the hypothetical binary system A-B consisting of regular
solid and liquid solution phases for selected combinations of Q1i4 and Q°!, The entropy of fusion
of compounds A and B is 10 J K-! mol~! while the melting temperatures are 800 and 1000 K.

 

. liq AfusHe
tn xlid 4 2 (lia? —_ fpf 1d (4.32)
RT R(T Trop

---
102 4 Phase diagrams

The two branches intersect at the eutectic point and the phase diagram thus relies
ona single interaction parameter, Q!'4, only.

In the present section we have focused on the calculation of phase diagrams from
an existing Gibbs energy model. We can turn this around and derive thermody-
namic information from a well-determined phase diagram. Modern computational
methods utilize such information to a large extent to derive consistent data sets for
complex multi-components systems using both experimental thermodynamic data
and phase diagram information. Still, it should be remembered that the phase dia-
gram data does not give absolute values for the Gibbs energy, but rather relative
values. A few well-determined experimental data points are, however, enough to
‘calibrate the scale’, and this allows us to deduce a large amount of thermodynamic
data from a phase diagram.

Invariant phase equilibria

In the examples covered so far several invariant reactions defined by zero degrees
of freedom have been introduced. For a two-component system at isobaric condi-
tions, F = 0 corresponds to three phases in equilibrium. Eutectic equilibria have
been present in several of the examples. Also, congruent melting for the solid solu-
tions with composition corresponding to the maxima or minima in the liquidus
lines present in Figures 4.10(f) and (d), for example, corresponds to invariant reac-
tions. At the particular composition corresponding to the maximum or minimum,
the system can be considered as a single-component system, since the molar ratio
n,a/ng = X,a/xg remains constant in both the solid and liquid solutions. The molar
ratio between the two components is a stoichiometric restriction that reduces the
number of components from two to one. A third invariant reaction is the hexagonal
to cubic phase transition of pure Y203 represented in Figure 4.8(a). While pure
Y203 is clearly a single-component system, the solid solubility of the component
MgO in h-Y203(ss) and c-Y03(ss) increases the number of components by one
relative to pure Y203. Two coexisting condensed phases give one degree of
freedom and the solid—solid transition is no longer an invariant reaction according
to the phase rule, but occurs over a temperature interval. The two-phase region is,
however, narrow and not visible in Figure 4.8(a).

Several other invariant equilibria may take place. A peritectic reaction is
defined as a reaction between a liquid and a solid phase under the formation of a
second solid phase during cooling. Such an invariant reaction is seen in Figure
4.10(c), where the reaction

B(ss) + liquid > A(ss) (4.33)

takes place at T = 837 K. It is possible for a solid solution to play the role of the
liquid in a similar reaction. Equilibria of this type between three crystalline phases
are termed peritectoid. Similarly, eutectic reactions, where the liquid is replaced
by a solid solution (hence involving only solid phases), are termed eutectoid.

---
4.1 Binary phase diagrams from thermodynamics 103

 

  
    
    

1600
liquid
1400
Alig) + Bdliq) Big) + co
1200 |
“
© 1000

solid solution

 

 

 

800
lacs) (ss) +." (s5) ass)
600.
0.0 0.2 0.4 0.6 0.8 1.0
*B

Figure 4.11 Phase diagram of the hypothetical binary system A-B consisting of regular
solid and liquid solutions. Qld = 20 kJ mol! and Q8°! = 15 kJ mol“! Thermodynamic data
for components A and B as in Figure 4.10.

A miscibility gap in the liquid state in general results in another invariant reac-
tion in which a liquid decomposes on cooling to yield a solid phase and a new
liquid phase

liqi > (ss) + liqa (4.34)

in a monotectic reaction.

Finally, a phase diagram showing phase separation in both the liquid and solid
states is depicted in Figure 4.11. Here a syntectic reaction (liq; + liqz — a(ss))
takes place at 1115 K.

Formation of intermediate phases

The binary systems we have discussed so far have mainly included phases that are
solid or liquid solutions of the two components or end members constituting the
binary system. Intermediate phases, which generally have a chemical composi-
tion corresponding to stoichiometric combinations of the end members of the
system, are evidently formed in a large number of real systems. Intermediate
phases are in most cases formed due to an enthalpic stabilization with respect to the
end members. Here the chemical and physical properties of the components are dif-
ferent, and the new intermediate phases are formed due to the more optimal condi-
tions for bonding found for some specific ratios of the components. The stability of
a ternary compound like BaCO3 from the binary ones (BaO and COo(g)) may for
example be interpreted in terms of factors related to electron transfer between the
two binary oxides; see Chapter 7. Entropy-stabilized intermediate phases are also
frequently reported, although they are far less common than enthalpy-stabilized
phases. Entropy-stabilized phases are only stable above a certain temperature,

---
104 4 Phase diagrams

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

3200
CSZ + liq liq
2800 ligt e-CaZ10,
al b
(a) -10 (b) f a
% 2400 oe -
g C82 e-Cazi05 [eCaz10,+ Cx0(s)
& wy
x c CSZ+
% = 2000 0-CaZi0, “7.
S 19 C20)
snd, | C8280)
Lcsz} /F%62sPua|
1600 O62 0-CaZr03+ Ca0(6s)
‘T8Z + 0-CaZr03
1200
30 Pp MSZ. + 0-CaZs03
00 02 04 06 08 10 00 02 04 06 O08 10
XCa0 *Ca0

Figure 4.12 (a) Gibbs energy representation of the phases in the system ZrO7—CaO at 1900
K. exo =H%,0, = 0. TSZ is not included for clarity. (b) Calculated phase diagram of the
system ZrO3-CaO. Thermodynamic data are taken from reference [9].

where the entropy contribution to the Gibbs energy exceeds the enthalpy difference
between this phase and the phase or phase assemblage stable at lower tempera-
tures. One example is wiistite, Fe;_,O, which forms eutectoidally from Fe and
Fe304 at 850 K. The formation of intermediate phases will naturally significantly
influence the phase diagram of a given system.

Before we give some examples of phase diagrams involving intermediate phases,
it is useful to discuss the compositional variation of the Gibbs energy of such
phases. Some intermediate phases may be regarded as stoichiometric. Here the
homogeneity range or the compositional width of the single-phase region is
extremely narrow. This reflects the fact that the Gibbs energy curves rise extremely
rapidly on each side of the minimum, which is located at exactly the stoichiometric
composition of the phase. This is illustrated in Figure 4.12(a) for CaZrO3, which
may be seen as an intermediate phase of the system CaO-ZrOp [9].5 The sharpness
of the G-x curve implies that CaZrO3 is represented by a vertical line in the
CaO-ZrO> phase diagram shown in Figure 4.12(b). The fact that the solid solu-
bility or non-stoichiometry of CaZrO3 is negligible is understood by considering
the crystal structures of the compounds involved; CaZrO3 takes a perovskite-
related crystal structure, while the two end members ZrOz and CaO have the fluo-
rite and rock salt structures, respectively. In the perovskite structure there are

 

3. The system Ca-Zr-O is principally a ternary system. However, as long as the oxidation state
of Zr and Ca are the same in all phases, the system can be redefined as a two-component
system consisting of CaO and ZrOp.

---
4.1 Binary phase diagrams from thermodynamics 105

 

 

 

 

 

 

 

 

 

 

 

 

 

 

TisSiz
° TisSiy
2000 1504
B-ti. J lig.
M L |
& 1000
aeti_>| —TisSi Tisi_ | TiSir
' “il a ae
0
0.0 0.2 0.4 0.6 0.8 1.0

Xsi

Figure 4.13 Phase diagram of the system Si-Ti [10].

unique lattice sites for both Ca and Zr, and neither interchange of Zr and Ca nor the
generation of vacant sites are thermodynamically favourable for CaZrO3.4 In opti-
mization of thermodynamic properties of stoichiometric compounds, the
compositional variation is often neglected and the Gibbs energy is simply given as
a function of temperature (and possibly pressure).

CaZrO3 melts congruently, i.e. the coexisting liquid and solid phases have the
exact same composition and CaZrO3 may hence be considered as a single-compo-
nent system. Here two phases present in equilibrium at constant pressure give zero
degrees of freedom. The congruent melting of CaZrO3 is therefore an invariant
equilibrium. Correspondingly, an incongruently melting compound melts under
the formation of a new solid phase and a liquid with composition different from the
original compound.

The phase diagram of the binary system Si-Ti shown in Figure 4.13 [10] is even
more complex. In this system several intermediate phases are formed. Solid solu-
bility is present for the intermediate phase TisSi3, while the other intermediate
phases Ti3Si, TisSi4, TiSi and TiSiz all have very narrow homogeneity ranges. The
G-x curve for ‘TisSi3’ should therefore display a shallow minimum at the TisSi3
composition, while the G—x curve for the other intermediate phases should possess
sharp minima at the exact composition of the phases. In the thermodynamic
description of the Gibbs energy of the non-stoichiometric phase TisSi3, the varia-
tion of the Gibbs energy with composition must be taken into account explicitly in
order to calculate the homogeneity range. In this particular case, the Gibbs energy
model may contain several different sub-lattices (see Chapter 9) so that the distri-
bution of different species on the relevant sub-lattices is represented.

 

4 It should be mentioned that oxygen vacancies are often formed in the perovskite-type
structure ABO3 in cases where the B atom is a transition metal that readily exists in more than
one oxidation state.

---
106 4 Phase diagrams

The intermediate phases in the system Si-Ti display also a variety of other fea-
tures. While TiSiz and TisSi3 are congruently melting phases, TisSig and TiSi melt
incongruently. Finally, Ti3Si decomposes to B-Ti and TisSiz at T= 1170 K, ina
peritectoid reaction while B-Ti decomposes eutectoidally on cooling forming @-Ti
+ Ti3Si at T= 862 K.

Melting temperature: depression or elevation?

While until now we have considered relatively simple phase diagrams and the fun-
damentals of the connection between phase diagrams and thermodynamics, we are
here going to consider a somewhat more complex example, but only briefly.

The calculation of phase diagrams is possible if the equilibrium between the dif-
ferent phases can be evaluated as a function of the variables of the system. A rela-
tively simple case is obtained by considering the effect of impurities on the melting
temperature of a ‘pure metal’ following Lupis’s treatment of the calculation of the
phase boundaries in the vicinity of invariant points [11]. The impurity may be
solved both in the solid and liquid phases and the presence of impurities in a ‘pure’
metal leads to interval freezing. The fusion interval is generally offset towards
higher or lower temperatures depending on the nature of the impurity. These alter-
natives are discussed here with reference to binary phase diagrams exemplifying
either a eutectic-type or peritectic-type behaviour in the composition range
adjoining the pure metal. The term eutectic-like behaviour is used for all diagrams
with the liquidus line sloping downwards, and peritectic-like is used for all those
with the liquidus line sloping upwards. Monotectic diagrams, as well as those
that include intermediate phases decomposing peritectically below the fusion tem-
perature of the pure metal (e.g. SnSb in the phase diagram of the Sn—Sb system
in Figure 4.14) are presently classed in the eutectic-like category. Nearly ideal

 

 

 

 

 

 
   
  

   

 

 

550
lig 800 liq
500} liq + Sb
Sbiss)
~ 450 lig. + Bi v
a ~ 600
& 5
Sn;Sbz|
400 |S") 7
|
Biss)
Sn+Bi _ 400f — sn+Snsb SnSb +Sb
350
0.0 02 04 06 O08 10 00 02 04 06 08 10
x sp

Bi

Figure 4.14 Phase diagrams of the systems (a) Sn—Bi [13] and (b) Sn-Sb [14]. Reprinted

from [12]. Copyright (1999), with permission from Elsevier.

---
4.1 Binary phase diagrams from thermodynamics 107

systems, with complete solid and liquid solubility, are categorized as peritectic if
the impurity fuses at a higher temperature than the pure metal.

The equilibrium compositions of an impurity B, x® and xP, in the two phases a
and f at a given temperature are given by eqs. (4.27) and (4.28), which may be
rewritten as

 

_ yo Au%%)
In +In7{ ~Iny -—A_—_=0 (4.35)
-xA
xo Aue)
In = +iny% -InyB aT =0 (4.36)
x,
B

Here Raoultian standard states are used for both the pure metal and the impurity.
The slope dxg/dT of the phase boundaries can now be derived by differentiation
with respect to temperature. Let f(xg) denote the left-hand side of eq. (4.35) or
(4.36); then (see Lupis, Further reading)

 

(“)] _{ afew) | (at) farce) ) (ane (22)
eq xe x8

aT ax , aT axB : dT oT

(4.37)

where dxp /dT and axB/ar are the slopes of the two phase boundaries [11]. Equa-
tion 4.37 is identical to zero since f(xg) is zero along the boundaries. The slope of
the phase boundaries can now be evaluated using eqs. (4.35) and (4.36). Further
treatment [11] gives the following equations for the slopes of the phase boundaries
— using a solid-liquid transition (melting) as an example:

 

ax’ _ YE Aguas S% PRT fas,a) (438)
© ali, _ 72.88 a A GOT RT.) °
AP) yg Ve ~ 1B exPl—A fusGy / RT fs.)
and
dy _ 1p Atas Sg, / RT fus,a) XP tus Gp / RT fas.) (4.39)
qr 1859 Ye YR exp gusGp / RT tus,a)

---
108 4 Phase diagrams

Here vata and vy; are the activity coefficients of component B in the liquid and
solid solutions at infinite dilution with pure solid and liquid taken as reference
states. A pus se is the standard molar entropy of fusion of component A at its fusion
temperature T,, 4 and AtusG is the standard molar Gibbs energy of fusion of
component B with the same crystal structure as component A at the melting tem-
perature of component A.

The melting temperature depression or enhancement may now be expressed in
terms of the melting temperature and the entropy of fusion of component A, the
activity coefficients of impurity B in the liquid and solid solutions at infinite dilu-
tion, and the total concentration of the impurity B, xp [12]:

XpRT,
AT =T -Tiasa --7es | | (4.40)
Afus Sy -

where F is the fraction of the sample melted at AT departure from T,,, 4, and K is an
interaction coefficient. If the liquid standard state is used for the activity coeffi-
cient of component B in both solid and liquid solutions:

liq
K-28 (4.41)
coliq _ 00,88

Ye YB

In this case the equations are greatly simplified and the ratio of the slopes of the
two phase boundaries at x, =1 is given by the activity coefficients of B at infinite
dilution in the liquid and solid phases [11]:

 

(AT / deg) ss 0,88
p20 | YB
(dT / dx!) 0 liq (4.42)
Bxt850 YB

Eutectic behaviour persists for 0 > K > —o, that is for y2"!4 — Yq" <0. Peritectic

behaviour is obtained for 1 < K < ©, that is for yo" — Yn >0.

The phase diagrams of the Sn—Bi and Sn-Sb systems are shown in Figure 4.14,
and they illustrate the effect of Bi and Sb on the melting temperature of pure Sn.
Experimental thermodynamic data for the Sn—Bi system gives A®: =7.5 and
agetia =1.3 [13]; the slope of the Sn solidus is steeper than for the Sn liquidus,
-0.2, and a eutectic type behaviour is expected. For the Sn-Sb system
Ag =0.12 and agiia =0.27[14], the slope of the Sn liquidus is steeper than that
for the Sn solidus, K = 1.8, and a peritectic-type behaviour is suggested. Both
results are in agreement with the experimental phase diagrams.

Activity coefficients at infinite dilution are in general very important and fre-
quently used in thermodynamic analyses. Examples are analyses of trace element

  

---
4.2 Multi-component systems 109

partitioning between solids and melts in geological systems [15] and analyses of
the distribution of long-lived chemicals throughout the environment [16].

Minimization of Gibbs energy and heterogeneous phase equilibria

The heterogeneous phase equilibria considered in the preceding sections have
implicitly been derived by finding the phase or phase assemblage with the lowest
Gibbs energy. Heterogeneous phase equilibria in general are calculated by mini-
mizing the Gibbs energy, and computer software has been available for several
decades to perform similar calculations in multi-component systems consisting of
any number of components and phases. Generally, the Gibbs energy in a system
consisting of the components A, B, C, ..., the stoichiometric phases @, B, y, ...and
the solution phases 1, 2, 3, ... can be expressed as

G=ngAsGy +npAsGe +nyAsGy +...

+> XS aj(u? + RT Ina;)
i=12,3,. j=A,B,C,.. /

(4.43)

For a given set of constraints (for example temperature, pressure and overall
composition), the algorithm identifies the phases present and the relative amounts
of these phases, as well as the mole fraction of all the components in all phases. The
global minimum evidently must obey the Gibbs phase rule, and not all phases need
to be present at the global equilibrium.

A thorough description of strategies and algorithms for minimization of Gibbs
energy in multi-component systems is outside the scope of the present text. The
monograph by Smith and Missen (see Further reading) gives an excellent over-
view of the topic.

4.2 Multi-component systems

Ternary phase diagrams

For three-component (C = 3) or ternary systems the Gibbs phase rule reads Ph + F=
C+2=S. Inthe simplest case the components of the system are three elements, but
a ternary system may for example also have three oxides or fluorides as compo-
nents. As a rule of thumb the number of independent components in a system can
be determined by the number of elements in the system. If the oxidation state of all
elements are equal in all phases, the number of components is reduced by 1. The
Gibbs phase rule implies that five phases will coexist in invariant phase equilibria,
four in univariant and three in divariant phase equilibria. With only a single phase
present F = 4, and the equilibrium state of a ternary system can only be represented
graphically by reducing the number of intensive variables.

---
110 4 Phase diagrams

   

.00 02° 04 06 O08 10
c Xs

Figure 4.15 Equilateral composition triangle for defining composition in a ternary system
A-B-C.

It is sometimes convenient to fix the pressure and decrease the degrees of
freedom by one in dealing with condensed phases such as substances with low
vapour pressure. The Gibbs phase rule for a ternary system at isobaric conditions is
Ph+F=C+1=4, and there are four phases present in an invariant equilibrium,
three in univariant equilibria and two in divariant phase fields. Finally, three
dimensions are needed to describe the stability field for the single phases; e.g. tem-
perature and two compositional terms. It is most convenient to measure composi-
tion in terms of mole fractions also for ternary systems. The sum of the mole
fractions is unity; thus, in a ternary system A—B-C:

Xx, +xptrxc=l (4.44)

and there are two independent compositional variables. A representation of com-
position, symmetrical with respect to all three components, may be obtained from
the equilateral composition triangle as shown for the system A-B-C in Figure
4.15. The three corners of the triangle correspond to the three pure components.
Along the three edges are found the compositions corresponding to the three binary
systems A-B, B-C and A-C. Lines of constant mole fraction of component A are
parallel to the B—C edge (exemplified by the broken line for x, =0.2), while lines
of constant mole fraction of B and C are parallel to the A-C and A-B binary edges
respectively (exemplified by broken lines for xg =0.2 and xc =0.6). The three
lines intersect at the point marked X, which thus have the composition x, =0.2,
xp =0.2, xc =0.6. Note that the sum of the lengths of the perpendiculars from any
composition point to the three edges is constant (using the point X as an example
once more, the perpendiculars are given by bold lines in the figure). It is upon this
property that the representation is based and the three perpendiculars are measures
of the mole fractions of the three components.

---
4.2 Multi-component systems 111

(a)
1000

 

Figure 4.16 (a) Triangular prism phase diagram for a ternary system A-B-C with the equi-
lateral triangular base giving composition. Temperature is given along the vertical axis
[17]. (b) Projection of the liquidus surface onto the ternary composition triangle. The bold
line is the intersection between the primary crystallization fields of C and the solid solution
@. The dashed line represents the extension of the solid solution @. Reprinted with permis-
sion of The American Ceramic Society, www.ceramics.org. Copyright [1984]. All rights
reserved.

To represent a ternary system at constant pressure completely, the effect of tem-
perature must be incorporated in the phase diagram. Such a ternary tempera-
ture-composition phase diagram at constant pressure may be plotted as a three-
dimensional space model using a triangular prism. The ternary composition tri-
angle would then form the base while temperature is given along the vertical axes
as shown in Figure 4.16(a) for a hypothetical ternary system A-B-C [17]. On
the three faces of the prism we find the phase diagrams of the three binary
systems A-B, B-C and A-C. In the hypothetical system illustrated in Figure
4.16(a) complete solid solubility is present in the close to ideal binary system A-B
(the solid solution phase is denoted @), while the two other binary systems B-C and
A-C are eutectic systems with a limited solubility of C in the solid solution phase
a.

Recall that the Gibbs phase rule gives F + Ph = C + 1 =4 fora ternary system at
constant pressure. Within the prism two liquidus surfaces are shown: one descending
from the melting temperature of pure C and the other from the liquidus of @ in the
binary A—B system. Compositions on the two surfaces corresponds to compositions
of the liquid in equilibrium with one of the two solid phases, C or @. For an equilib-
rium between a solid and the liquid, Ph = 2 and thus F = 2; the two surfaces are
divariant. The two liquidus surfaces intersect along the univariant line (F = 1)
starting from one of the binary eutectics (E;) and ending in the other (E2). The inter-
section of adjoining liquidus surfaces in a ternary phase diagram is generally termed

---
112 4 Phase diagrams

acommon boundary line. Along the univariant common boundary line three phases
(liq, C and @) are in equilibrium.

In the present case there are no ternary invariant equilibria in the system, partly
due to the complete solid solubility of the A-B system. In a ternary system com-
posed from three binary eutectic sub-systems, three univariant lines would meet in
a ternary eutectic equilibrium:

lig. <> A(ss) + B(ss) + C(ss) (4.45)

which is an invariant equilibrium at isobaric conditions.

Phase diagrams based on the triangular prism give an illustrative representation
of isobaric ternary systems, but the construction of the diagram is very time-con-
suming and of less convenience. A more convenient two-dimensional representa-
tion of the ternary liquidus surface may be obtained by an orthogonal projection
upon the base composition triangle. This is shown for the system A—B-C in Figure
4.16(b) [17]. The lines of constant temperature are called liquidus isotherms. In
Figure 4.16(b) the bold line shows the common boundary line of the two liquidus
surfaces descending from the melting temperature of pure C and from the liquidus
of ain the binary A—B system discussed above. Often an arrow is used to indicate
the direction of decreasing temperature along univariant lines.

We will now apply Figure 4.16 to find the equilibrium behaviour of a sample
with overall composition marked P in the diagrams, when it is cooled from above
the liquidus surface to below the solidus temperature for the given overall composi-
tion. The point marked P lies within the primary crystallization field of a. That
is, it lies within the composition region in which @ will be the first solid to precipi-
tate during cooling. When cooling the liquid, @ will start to precipitate when
the liquidus temperature is reached just below 700 °C; see Figure 4.16(b). During
further cooling the amount of solid @ will increase at the expense of the amount of
liquid. It is important to note that the composition of @ is not constant during the
crystallization.

Two selected isothermal sections of the phase diagram that show relevant two-
phase equilibria are given in Figure 4.17 [17]. The thin lines illustrate the tielines
between the compositions of two phases in equilibrium (@ + liq.) or (C + liq). The
tieline going through the overall composition point P in Figure 4.17(a) defines the
composition of the two conjugate phases, @ and liquid, at that particular tempera-
ture. During cooling the composition of @ is enriched on A and also the composi-
tion of the liquid changes. The two phases remain in equilibrium until the liquid
reaches the intersection of the primary crystallization fields of a and phase C. At
this temperature, the second solid phase, denoted phase C, will start to precipitate
in addition to @. On further cooling, the composition of the liquid is defined by the
common boundary line from E, to Ep in Figure 4.16, where the liquid is in equilib-
rium with @ and C. The compositions of the three phases in equilibrium are given
by a triangle in an isothermal section. This is illustrated for the temperature corre-
sponding to that where the liquid phase disappears, i.e. when P reaches the edge of

---
4.2 Multi-component systems 113

Vey

650°

 

(a) A

Figure 4.17 Isothermal sections of the ternary phase diagram A-B-C shown in Figure 4.16
at (a) 650 °C and (b) 450 °C [17]. Here L denotes liq. Reprinted with permission of The
American Ceramic Society, www.ceramics.org. Copyright [1984]. All rights reserved.

the three-phase triangle in Figure 4.17(b). On further cooling the two solid phases
remain in equilibrium. Since the solubility limit of @ decreases with decreasing
temperature, the relative amounts of the two phases in equilibrium also change.

A sample in the primary crystallization field of phase C will behave differently
during crystallization. Here phase C precipitates with composition identical to C
(no solid solubility) during cooling keeping the A:B ratio in the melt constant until
the melt hits the intersection of the two primary crystallization fields. At this tem-
perature o will start to precipitate together with further C and from this point on the
cooling process corresponds to that observed for the sample with overall composi-
tion P after this sample reaches the same stage of the crystallization path.

The relative amount of the different phases present at a given equilibrium is
given by the lever rule. When the equilibrium involves only two phases, the calcu-
lation is the same as for a binary system, as considered earlier. Let us apply the
lever rule to a situation where we have started out with a liquid with composition P
and the crystallization has taken place until the liquid has reached the composition
2 in Figure 4.17(a). The liquid with composition 2 is here in equilibrium with a
with composition 2’. The relative amount of liquid is then given by

2P

— 4.46
7 (4.46)

Yiig =
where 2'P denotes the distance between 2’ and P and 2’2 that from 2' to 2. The
amount of solid (@) yy is given by 1— y\,4- With three phases in equilibrium, the
relative amounts of the three phases are also given by the lever rule, but its use is
slightly more complex. In this case the relative amounts of the three phases are
determined in terms of a triangle defined by the composition of the three phases in
equilibrium. A line from each of the three corners is drawn through the point repre-
senting the overall composition of the sample to the opposite edge. The relative

---
114 4 Phase diagrams

 

 

NaF ‘s0835" ‘0 1030" 40 906" 20 MOF,

wey Naor, Mol. % omy
Figure 4.18 Phase diagram for the ternary system NaF—MgF -CaF> [18]. Reprinted with
permission © 2001 by ASM International and TMS (The Minerals, Metals and Materials
Society).

amount of a given phase (represented as a corner in the diagram) is defined as the
length of the line from the overall composition to the opposite edge divided by the
total length from the corner to the edge. This is illustrated in Figure 4.15. Here
the relative amount of phase B for a sample with overall composition X is equal to
QX/QP. Similar procedures for the two other components give the relative amount
of all three phases in equilibrium.

Let us now consider two real ternary systems to illustrate the complexity of ter-
nary phase diagrams in some detail. While the first is a system in which the solid
state situation is rather simple and attention is primarily given to the liquidus sur-
faces, the solid state is the focus of the second example.

The phase diagram of the ternary system NaF—MgF>—CaF) is shown in Figure
4.18 [18]. Of the three binary sub-systems NaF—CaF2 and MgF2-CaF) are simple
eutectic systems, while an intermediate phase, NaMgF3, is formed in the third
system, NaF—MgF>. The latter can however be divided into two simple eutectic
subsystems: NaF—NaMgF; and NaMgF3—MgF>. The overall system consists of
the four solid phases described above, all with their own primary crystallization
field and all four phases melt congruently. The borderline between the primary
crystallization fields of the phases are shown as bold lines. Two ternary eutectics
are shown with the eutectic compositions within the two ternary subsystems
NaF-CaF)—-NaMgF3 and CaF)-MgF2—-NaMgF3. The binary join between CaF2
and NaMgF;3 is termed a true Alkemade line defined as a join connecting the com-
positions of two primary phases having a common boundary line. This Alkemade
line intersects the boundary curve separating the primary phases CaF2 and
NaMgF3. The point of intersection represents the temperature maximum on the

---
4.2 Multi-component systems 115

Si Si
T=1400°C _- Lesiesic T=1800°C

 

08 c

\nc 06
Mole fraction C

 

Figure 4.19 Isothermal sections of the ternary system C-Si-Ti at (a) 1400 °C and (b) 1800°C
[10]. Reprinted with permission of The American Ceramic Society, www.ceramics.org. Copy-
right [2000]. All rights reserved.

boundary curve, while the liquidus along the Alkemade line has a minimum at the
same composition; hence the intersection represents a saddle point. If the
Alkemade line does not intersect the boundary curve, then the maximum on the
boundary curve is represented by that end which if prolonged would intersect the
Alkemade line. The binary join NaF—MgF> is not an Alkemade line since these two
solid phases are not coexistent. Finally, the @-f CaF) phase transition at 1151 °C is
shown as a bold line in the figure.

For ternary systems with complex phase behaviour in the solid state it is more
convenient to use only isothermal sections. This is shown for two temperatures for
the ternary system Ti-Si—C in Figure 4.19 [10]. In this system several binary and
ternary intermediate phases are stable, and the system is divided into several ter-
nary sub-systems. Tielines for two-phase equilibria are also shown in the two iso-
thermal sections.

Quaternary systems

Ina quaternary system, three dimensions are required to represent composition and
a fourth dimension is needed for the temperature if the temperature dependence is
to be displayed. Since we live in a three-dimensional world this is awkward. The
dilemma is partly overcome by constructing a diagram, which is analogous to the
plane projection made for ternary systems. This is shown for the system A~B-C-D
in Figure 4.20. The phase diagram is a tetrahedron, and the four corners of the tetra-
hedron correspond to the four components. The four faces of the tetrahedron corre-
spond to the plane projections of the four limiting ternary systems. The Gibbs
phase rule for the quaternary system at isobaric conditions is Ph+F=C+1=5.
With only a single phase present and for a given temperature, three composition
variables may be varied (i.e. F = 3), and the stability field for each phase is thus a

---
116 4 Phase diagrams

 

Figure 4.20 Tetrahedron space model for the phase diagram of the quaternary system
A-B-C-D. The isotherms T}, 72, T3 are shown for the primary phase volume of component
A [17]. Reprinted with permission of The American Ceramic Society, www.ceramics.org.
Copyright [1984]. All rights reserved.

volume in the tetrahedron. Two phases are in equilibrium along surfaces, three
phases are present in univariant equilibria and finally there are four phases in
invariant equilibria.

The addition of further components makes the presentation of the phase dia-
grams increasingly complex. The principles are general, however, and calculation
of a vertical section in a quinternary system like Fe~-Cr-Mo—W-C [19], for
example, is fairly easily done by the use of large computer programs for calculation
of phase diagrams based on thermodynamics.

Ternary reciprocal systems

A ternary reciprocal system is a system containing four components, but where
these components are related through a reciprocal reaction. One example is the
system LiC]-LiF-KCI-KF. Solid LiCl, LiF, KCI and KF are highly ionic materials
and take the rock salt crystal structure, in which the cations and anions are located
on separate sub-lattices. It is therefore convenient to introduce ionic fractions (Xj)
for each sub-lattice as discussed briefly in Section 3.1. The ionic fractions of the
anions and cations are not independent since electron neutrality must be fulfilled:

Xp tX qe = Xp t Xe a1 (4.47)

For this reason, the system is defined by the four neutral components LiCl, LiF,
KCI and KF, which in addition can be related by the reciprocal reaction

---
4.3 Predominance diagrams 117

zo

   

   

04363 08
‘Male fraction ort)

Figure 4.21 Calculated phase diagram of the ternary reciprocal system LiCI-LiF-KCI-KF
[20]. Reprinted with permission © 2001 by ASM International and TMS (The Minerals,
Metals and Materials Society).

LiCl + KF=LiF+ KCl (4.48)

The sign of the Gibbs energy of this reciprocal reaction determines which of the
two pairs of compounds are coexistent at a given temperature (and pressure). In our
specific case, the Gibbs energy of the reciprocal reaction is negative and the prod-
ucts are coexistent phases, while the reactants are not. A reciprocal ternary phase
diagram is in general constructed by the combination of two ternary systems that
both contain the two coexistent phases. Thus in the present case the ternary phase
diagrams of the systems LiF—KCI-LiCI and LiF-KCI-KF are combined. The cal-
culated phase diagram of the ternary reciprocal system considered is shown in
Figure 4.21 [20]. Here the sign of the reciprocal reaction is reflected in that the
stable diagonal in the system is LiF—KCI and not LiCI-KF.

Both the ternary systems are simple eutectic ones and the composition of the
system is represented by the ionic fraction of one of the cations and one of the
anions. In Figure 4.21 the ionic fraction of Li* is varied along the X-axis, while the
ionic fraction of F~ is varied along the Y-axis.

 

4.3 Predominance diagrams

In the preceding sections the phase diagrams have been represented in terms of
composition. Alternatively, the chemical potential of one or more of the compo-
nents may be used as variables. This gives rise to a range of similar diagrams that

---
118 4 Phase diagrams

 

 

 

 

0
-~ > Fe203
S
a
S -10
z Fe30.
2 oss Feo
-15
" B-Fe
10 a-Fe|
600 800 1000 1200
TI°C

Figure 4.22 log po, versus T predominance phase diagram for the binary system Fe-O.
Thermodynamic data are taken from reference [21].

have many applications in materials science. These will here be termed predomi-
nance diagrams. They are of great importance for understanding materials’ sta-
bility under hostile conditions (for example hot corrosion) and in planning the
synthesis of materials; for example for chemical vapour deposition. In addition to
being of great practical value, they also further illustrate the principles of Gibbs
energy minimization and the Gibbs phase rule.

In predominance diagrams one or more base elements are defined which must be
present in all the condensed phases. A predominance diagram for the binary system
Fe-O is shown in Figure 4.22. The diagram is divided into areas or domains of sta-
bility of the various solid phases of the Fe—O system. In this simple binary case the
base element is iron, which is present in all five condensed phases in the system:
three oxides and two solid modifications of Fe. The Gibbs phase rule reads Ph + F=
C+2=4 if the pressure of oxygen is considered as the mechanical potential p.
Alternatively, po, may be considered to be constant e.g. | bar. In the latter case, a
third component, an inert gas, must be added to the system to maintain the isobaric
condition. Thus Ph + F = C + 1, which for C = 3 again gives Ph + F = 4. In conclu-
sion, we may have a maximum of four phases in equilibrium: three condensed
phases and a gas phase. A univariant line (F = 1) is for this two component system a
phase boundary separating the domains of two condensed phases, for instance
Fe304 and Fe203. These univariant lines are defined by heterogeneous phase
equilibria like

4/3 Fe30q(s) + 1/3 On(g) = 2 Fe203(s) (4.49)

The stability fields for the condensed phases correspond to F = 2, which means that
both temperature and the partial pressure of O» can be varied independently.

In order to derive the phase boundaries in Figure 4.22 we need the Gibbs energy
of formation of the oxides. This type of data is conveniently given in an Ellingham

---
4.3 Predominance diagrams 119

~200

—400

(aeq /Od)80}

-600

AG°/ kJ mol!

-800

—1000.

 

—1200

 

0 500 1000 1500 2000

T/K

Figure 4.23 Ellingham diagram for various metal oxides. Thermodynamic data are taken
from reference [21].

diagram [22,23] where the Gibbs energy ‘of formation’ of various oxides is
plotted versus the temperature, as shown in Figure 4.23. Note that the Gibbs energy
of formation is given per mole Oo, which is not in accordance with the definition of
the energies of formation given in Chapter | and used frequently thereafter.

For a binary oxide like Fe2O3 the reaction in question is

4/3 Fe(s) + Oo(g) = 2/3 Fe203(s) (4.50)

Assuming that the metal and oxygen are in their standard states, the equilibrium
constant corresponding to reaction (4.50) is given as

K =Vpo, =exp(-A,G°/RT) (4.51)

If the oxygen partial pressure is lower than po, =1/K the reactant (in our case Fe) is
stable. If it is higher, the product (in our case Fe203) is formed.

The slopes of the lines in the Ellingham diagram are given by the entropy change
of the formation reaction: —A , S°. The entropy changes are in general negative due
to the consumption of gas molecules with higher entropy and the slopes are thus
positive. In the large scale of the plot the lines appear to be linear, suggesting

---
120 4 Phase diagrams

constant entropies of the reactions (or in other words that the difference in heat
capacity between the reactants and products is zero). Ona different scale the curva-
ture of the Gibbs energy curves is visible. Furthermore, it should be noted that the
breaks in the slopes of the curves are due to first-order phase transitions of the
metal or the oxide.

The Ellingham diagram contains a lot of useful information. By drawing a line
from the point P that intersects the Gibbs energy curve of a particular compound at
a temperature of interest, the partial pressure that corresponds to decomposition/
formation of the oxide from pure metal and gas at that particular temperature can
be derived. The partial pressure of oxygen is obtained by extrapolation to the
log po, scale on the right-hand side of the diagram. For example, at 1000 K the par-
tial pressure of oxygen corresponding to equilibrium between Zn and its mon-
oxide, ZnO, is 10-2 bar. From the diagram in Figure 4.23 it is evident that the
oxides with the more negative Gibbs energies of formation have the highest sta-
bility and are harder to reduce to the elemental state.

In materials science, the controlled partial pressure of oxygen is often obtained
by using gas mixtures. Here the ratio of the partial pressures of e.g. H2(g) and
H20(g) or CO(g) and CO2(g) are varied to give the desired po, at a given tempera-
ture. The ratios py,/Pu,o and pco/pco, are related to the partial pressure of O2 by
the reactions oo .

2H20(g) = 2Ha(g) + Or(g) (4.52)
2CO2(g) = 2CO(g) + O2(g) (4.53)

Calculated ratios pco/Pco, and py,/Py,0 for selected partial pressures of oxygen
at a total pressure of | bar are given in Figure 4.24.

The equilibrium between a metal and an oxide in a CO—CO) atmosphere can then
be obtained by combining the formation reaction of the oxide with reaction (4.53).
As an example the equilibrium between Co, O2 and CoO combined with reaction
(4.53) gives

Co(s) + CO2(g) = CO(g) + CoO(s) (4.54)

After finding the partial pressure of oxygen at a given temperature through Figure
4.23, the composition of the gas mixture is obtained from Figure 4.24(a).

Let us now include an additional component to the Fe-O system considered
above, for instance S, which is of relevance for oxidation of FeS and for hot corro-
sion of Fe. In the Fe-S—O system iron sulfides and sulfates must be taken into con-
sideration in addition to the iron oxides and ‘pure’ iron. The number of components
C is now 3 and the Gibbs phase rule reads Ph + F = C + 2=5, and we may have a
maximum of four condensed phases in equilibrium with the gas phase. A two-
dimensional illustration of the heterogeneous phase equilibria between the pure
condensed phases and the gas phase thus requires that we remove one degree of

---
4.3 Predominance diagrams 121

 

 

 

  

 

(a) 10 (b) 10
0
2 =
x -10 2
So =
2 %
-20
-30
500 1000 1500 2000 500 1000 1500 2000
TIK TIK

Figure 4.24 Relationship between the partial pressure of oxygen and the composition of
CO-CO2 and Hy-H30 gas mixtures at 1 bar. (a) peo/peo, versus temperature and (b)
Pu, /Py,o Versus temperature at selected partial pressures of oxygen. Thermodynamic data
are taken from reference [21].

freedom. This can be done by keeping either the temperature or a chemical poten-
tial constant. To exemplify the former choice, the isothermal predominance dia-
gram for the Fe-S—O system at 800 K is shown in Figure 4.25. Here the partial
pressures of SO and Op are used as variables. An univariant line (F = 1) or phase
boundary separates domains of two different condensed phases. For Fe2O3 and
FeSO, this line is defined by the heterogeneous phase equilibrium

 

     

 

 

 

2] Fess
~ Fe(SO,)3
q
20
BR
—4|
20 =15 =10 5 0
log (Po, / bar)

Figure 4.25 log pso, versus log po, predominance diagram for the system Fe-S—O at
527 °C. Thermodynamic data are taken from reference [21].

---
122 4 Phase diagrams

Fe203(s) + SO2(g) + 402(g) = FeSOu(s) (4.55)
Since
A,G° =-RT In K =-RT In —. (4.56)
PSO; Po,

the phase boundary is given by the line log K =—log pso, ~4log Po, where K is
the equilibrium constant for reaction (4.55). The domain of stability for each of the
condensed phases corresponds to two degrees of freedom (F = 2), while three con-
densed phases are in equilibrium with the gas phase at an invariant point (F = 0).
Three lines corresponding to three different univariant phase equilibria meet at an
invariant point.

As indicated above, rather than keeping the temperature constant, we can replace
the partial pressure of one of the gas components with the temperature as a variable.
Figure 4.26 is a diagram of the Fe-S—O system in which In po, is plotted versus tem-
perature. Here pgo, is fixed in order to allow a two-dimensional representation.

There are in principle no restrictions on the number of components in a predomi-
nance diagram and examples of four- and five-component systems are shown in
Figure 4.27. In Figure 4.27(a) the predominance diagram of the system Si-C-O-N
at 1500 K is given as a function of log po, and log py, . The system has four compo-
nents, and Si and C are the two base elements. The amount of Si is assumed to be in
excess relative to SiC. At constant temperature, the Gibbs phase rule gives Ph + F=
C+1=5. Thus at an invariant point four condensed phases are in equilibrium with
the gas phase. Two such invariant points are evident in Figure 4.27(a). Three con-
densed phases are in equilibrium along the lines in the diagram (F = 1), whereas

1200

 

     

1100 pes, FeS)
FeO,

1000

900

TI°C

 

 

 

-20 =15 =10 -5 0
log (Po,/ bar)

Figure 4.26 T versus log po, predominance diagram for the Fe-S—O system at pso, = 0.1
bar. Thermodynamic data are taken from reference [21]. .

---
4.3 Predominance diagrams 123

 

  
   
   

 

 

 

 

 

 

 

-18 4
@ Si0,+C ©) SiC + 3A1,0325i0, /
~20 SiO, + 3A10,-2Si0,
S SiO, + SiC
B22 F& 6 | Sin, +3A1,0;28i0,
“Ss = ~ f
g SiN, é /"' sic +
Baa sissic | siny+sic ped © SiNj+Al0, (A130,
Z /
2
unstable gas
-26 8 mixture
~28
3s 6 4+ 2 0 4 3 #2 1 ~0
log (py, / bar) log (peo! bar)

Figure 4.27 (a) Predominance diagram for the system Si-C-O-N at 1500 K, Ng, > Nc. (b)
Predominance diagram for the system Al-Si-C-O-N at 1700 K and py, =05 bar,
Ngj > 0.25N a. Thermodynamic data are taken from reference [21]. .

two condensed phases are coexistent in the two-dimensional phase fields. Si3N4
and SiC, which are often present in ceramic composites, are only thermodynami-
cally coexistent in a narrow log py, range at low partial pressures of O2. Thermo-
dynamic data for the oxynitride phase Si2ON> are not available, but at 1500 K it has
a narrow stability region between SiO» and Si3N4.

In Figure 4.27(b) the predominance diagram of the five-component system
Si-Al-C-O-N is shown as a function of log peg, and log peo at a constant partial
pressure of N> equal to 0.5 bar at 1700 K. The two base elements of the plot are Si
and Al (ng; >0.25n q)). The Gibbs phase rule reads Ph + F = C+ 2=7, which at con-
stant temperature and constant partial pressure of Ny gives Ph + F=5. The predom-
inance diagram shown in Figure 4.27(b) is therefore analogous to the one shown in
Figure 4.27(a), in that the same number of phases is present for a certain degree of
freedom. Aluminium nitride is only stable at low partial pressures of CO and CO).

Note that the gas mixture in the lower right corner in Figure 4.27(b) is unstable
due to the Boudouard reaction

C(s) + CO2(g) = 2 CO(g) (4.57)
At 1700 K the equilibrium constant for this reaction is

K =6946 = peo/Pco, (4.58)

The CO-CO} gas mixture is therefore unstable at conditions below the line defined
by eq. (4.57) and will here lead to formation of graphite. It may be useful to note

---
124 4 Phase diagrams

 

(a)

 

 

 

 

 

 

HO)

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

0 (Ti)/ RT 120

 

 

 

 

 

 

 

“60 ~40 “20 0 20
log Po,/ bar

Figure 4.28 (a) Three-dimensional chemical potential diagram for the system Co-Ti-O at

1000 K. (b) Two-dimensional chemical potential diagram at the same conditions [24].

Reprinted with permission of The American Ceramic Society, www.ceramics.org. Copy-

right [1989]. All rights reserved.

that in many commercial thermodynamic software packages it is not prohibited to
calculate phase equilibria for unstable gas compositions, and care should be taken.
In cases where ternary compounds, e.g. oxides, are being investigated, other
related types of diagrams may be more efficient. The thermodynamic stability of
ternary oxides at constant pressure, for example, is visually well represented in
three-dimensional chemical potential diagrams [24]. In Figure 4.28(a) the phase
relations in the system Co-Ti-O are plotted as a function of the chemical potential
of the three elements. At constant temperature, the Gibbs phase rule gives Ph + F=
3 + 1 =4, and an invariant point corresponds to three condensed phases in equilib-
rium with the gas phase. The stability field of each single phase is given as a plane,
while two phases are in equilibrium along univariant lines. The same phase equi-
libria may also be represented in two dimensions, as exemplified by Figure 4.28(b).
Here the stability of the metallic elements and their binary oxides and double

---
4.3 Predominance diagrams 125

oxides are presented as areas in a log(a_4/ag) versus log po, plot (at constant tem-
perature). Complex phase relations for double oxides are in this way visualized ina
clear and compact manner.

References

[1] | P.R. Subramanian and J. H. Perepezko, Ag—Cu (silver—copper) system, in Phase Dia-
grams of Binary Copper Alloys (P. R. Subramanian, D. J. Chakrabarti and D. E.
Laughlin, eds.). Materials Park, OH: ASM International, 1994.

[2] C. Bergman, R. Chastel and R. Castanet, J. Phase Equilibria 1992, 13, 113.

[3] | P. Wu, G. Eriksson and A. D. Pelton, J. Am. Ceram. Soc. 1993, 76, 2065.

[4] NIST-JANAF Thermochemical Tables, 4th edn (M. W. Chase Jr, ed.). J. Phys. Chem.
Ref. Data Monograph No. 9, 1998.

[5] A.D. Pelton, A. Gabriel and J. Sangster, J. Chem. Soc. Faraday Trans. 1, 1985, 81, 1167.

[6] Y. Du and Z. P. Jin, J. Alloys and Comp. 1991, 176, L1.

[7] S.S. Kim and T. H. Sanders Jr, J. Am. Ceram. Soc. 2001, 84, 1881.

[8] A.D. Pelton and W. T. Thompson, Progr. Solid State Chem. 1975, 10, 119.

[9]  Y. Du, Z. P. Jin and P. Y. Huang, J. Am. Ceram. Soc. 1992, 75, 3040.

[10] Y. Du, J.C. Schuster, H. J. Seifert and F. Aldinger, J. Am. Ceram. Soc., 2000, 83, 197.

[11] C.H. P. Lupis, Chemical Thermodynamics of Materials, New York: North-Holland,

1983, p. 221.

S. Stglen and F. Grgnvold, J. Chem. Thermodyn. 1999, 31, 379.

H. Ohtani and K. Ishida, J. Electron. Mater. 1994, 23, 747.

B. Jénsson and J. Agren, Mater. Sci. Techn. 1986, 2, 913.

N.L. Allan, J. D. Blundy, J. A. Purton, M. Yu. Laurentiev and B. J. Wood, EMU Notes

in Mineralogy, 2001, 3(11), 251.

[16] S.I. Sandler, Pure Appl. Chem. 1999, 71, 1167.

[17] C.G. Bergeron and S. H. Risbud, Introduction to Phase Equilibria in Ceramics, The

American Ceramic Society, Westerville, Ohio, 1984.

P. Chartrand and A. D. Pelton, Metal. Mater. Trans. 2001, 32A, 1385.

B. Jénsson and B. Sundman, High Temp. Sci. 1990, 26, 263.

P. Chartrand and A. D. Pelton, Metal. Mater. Trans. 2001, 32A, 1417.

C. W. Bale, A. D. Pelton and W. T. Thompson, F*A*C*T (Facility for the Analysis of

Chemical Thermodynamic), Ecole Polytechnique, Montreal, 1999, http://

www.crct.polymtl.ca/.

[22] H.T. T. Ellingham, J. Soc. Chem. Ind. 1944, 63, 125.

[23] F. D. Richardson and J. H. E. Jeffes, J. Iron Steel Inst. 1948, 160, 261.

[24] H. Yokokawa, T. Kawada and M. Dokiya, J. Am. Ceram. Soc. 1989, 72, 2104.

 

Further reading

J. W. Gibbs, The Collected Works, Volume I Thermodynamics. Harvard: Yale University
Press, 1948.

M. Hillert, Phase Equilibria, Phase Diagrams and Phase Transformations. Cambridge:
Cambridge University Press, 1998.

L. Kaufman and H. Bernstein, Computer Calculation of Phase Diagrams. New York: Aca-
demic Press, 1970.

---
126 4 Phase diagrams

C.H. P. Lupis, Chemical Thermodynamics of Materials, New York: North-Holland, 1983.

A. Prince, Alloy Phase Equilibria. Amsterdam: Elsevier Science, 1966.
A. D. Pelton, Phase diagrams, in Physical Metallurgy, 4th edn (R. W. Cahn and P. Haasen,

eds.). Amsterdam: Elsevier Science BV. Volume 1, Chapter 6, 1996.
N. Saunders, and A. P. Miodownik, CALPHAD: Calculation of Phase Diagrams. Oxford:

Pergamon, Elsevier Science, 1998.
W. R. Smith and R. W. Missen, Chemical Reaction Equilibrium Analysis: Theory and Algo-

rithms. New York: Wiley, 1982.

---
