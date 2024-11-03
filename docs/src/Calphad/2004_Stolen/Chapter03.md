Chemical Thermodynamics of Materials: Macroscopic and Microscopic Aspects.
Svein Stolen and Tor Grande
Copyright 2004 John Wiley & Sons, Ltd. ISBN: 0-471-49230-2

Solution thermodynamics

So far we have discussed the thermodynamic properties of materials, which have
been considered as pure and to consist of only a single component. We will now
continue with systems containing two or more components and thereby solutions.
Solutions are thermodynamic phases with variable composition, and are common
in chemical processes, in materials and in daily life. Alloys — solutions of metallic
elements — have played a key role in the development of human civilisation from
the Bronze Age until today. Many new advanced materials are also solutions.
Examples are tetragonal or cubic ZrO2, stabilized by CaO or Y203, with high
toughness or high ionic conductivity, and piezoelectric and dielectric materials
based on BaTiO3 or PbZrO3. In all these cases the mechanical or functional proper-
ties are tailored by controlling the chemical composition of the solid solution. The
chemical and thermal stability of these complex materials can only be understood
if we know their thermodynamic properties.

The understanding of how the chemical potential of a component is changed by
mixing with other components in a solution is an old and fascinating problem. The
aim of this chapter is to introduce the formalism of solution thermodynamics.
Models in which the solution is described in terms of the end members of the solu-
tion, solution models, are given special attention. While the properties of the end
members must be described following the methods outlined in the previous
chapter, the present chapter is devoted to the changes that occur on formation of the
solutions. In principle one could describe the Gibbs energy of a mixture without
knowing the properties of the end members, but since it is often of interest to apply
a solution model in thermodynamic calculations involving other phases, the solu-
tion model often is combined with descriptions of the Gibbs energies of the end
members to give a complete thermodynamic description of the system.

57

---
58 3 Solution thermodynamics
3.1 Fundamental definitions

Measures of composition

The most important characteristic of a solution is its composition, i.e. the concen-
tration of the different components of the phase. The composition of a solution is
best expressed by the ratio of the number of moles of each component to the total
number of moles. This measure of the composition is the mole fraction of a com-
ponent. In the case of a binary solution consisting of the components A and B, the
mole fractions of the two components are defined as

n n
x, =—A— and xp =—B— G.1)
ny +ng ny +ng

and it is evident that

 

Xa +XB (3.2)
For an infinitesimal change in composition of a binary solution the differentials of
the two mole fractions are related as

dx, =-drp (3.3)

In dealing with dilute solutions it is convenient to speak of the component
present in the largest amount as the solvent, while the diluted component is called
the solute.

While the mole fraction is a natural measure of composition for solutions of
metallic elements or alloys, the mole fraction of each molecule is chosen as the
measure of composition in the case of solid or liquid mixtures of molecules.! In
ionic solutions cations and anions are not randomly mixed but occupy different
sub-lattices. The mole fractions of the atoms are thus an inconvenient measure of
composition for ionic substances. Since cations are mixed with cations and anions
are mixed with anions, it is convenient for such materials to define composition in
terms of ionic fractions rather than mole fractions. In a mixture of the salts AB and
AC, where A is a cation and B and C are anions, the ionic fractions of B and C are
defined through

X_=—"8

B= (3.4)
ng +nce

 

 

1 Note that volume fraction rather than mole fraction is recommended in mixtures of molecules
with significant different molecular mass. This will be discussed in Chapter 9.

---
3.1 Fundamental definitions 59

In a binary solution AB—AC, the ionic fractions of B and C are identical to the
mole fractions of AB and AC. It may therefore seem unnecessary to use the ionic
fractions. However, in the case of multi-component systems the advantage of ionic
fractions is evident, as will be shown in Chapter 9.

Mixtures of gases

The simplest solution one can imagine is a mixture of ideal gases. Let us simplify
the case by assuming only two types of ideal gas molecules, A and B, in the mix-
ture. The total pressure in this case is the sum of the partial pressures of the two
components (this is termed Dalton’s law). Thus,

Prot = PA + PB (3.5)

where pa and pp are the partial pressures of the two gases and po is the total pres-
sure. By applying the ideal gas law (eq. 2.23), the volume of the gas mixture is

Viot ="AVm,A +" BVm,B (3.6)

where na and ng are the number of moles of A and B in the mixture and Vm,q and
Vm,B are the molar volumes of pure A(g) and B(g). In this case, where both A and B
are ideal gases, Viy,.4 = Vm,p- It follows that, for a mixture of ideal gases

PA =XAProt (3.7)

The chemical potential of an ideal gas A is given by eq. (2.26) as

Ha (Py) = HS + RT In Pa ="S +RT Inpy (3.8)

Py

where HA is the standard chemical potential of the pure ideal gas A at PS = 1 barat
a given temperature 7. For a mixture of the ideal gases A and B at constant pressure
(Prot = PS =1 bar) the chemical potential of A for a given composition of the solu-
tion, xa, is, by using eq. (3.7)

XAPrtot_ =U +RT Inxg (3.9)
°
Pr

Haq) =HQ +RT In

The difference between the chemical potential of a pure and diluted ideal gas is
simply given in terms of the logarithm of the mole fraction of the gas component.
As we will see in the following sections this relationship between the chemical
potential and composition is also valid for ideal solid and liquid solutions.

---
60 3 Solution thermodynamics

In mixtures of real gases the ideal gas law does not hold. The chemical potential
of A of a mixture of real gases is defined in terms of the fugacity of the gas, fq. The
fugacity is, as discussed in Chapter 2, the thermodynamic term used to relate the
chemical potential of the real gas to that of the (hypothetical) standard state of the
gas at | bar where the gas is ideal:

Ma (xa) =H + RT In] a =H. +RT In(fa) (3.10)

Pr

Solid and liquid solutions - the definition of activity

In the solid or liquid state the activity, a, is introduced to express the chemical
potential of the components of a solution. It is defined by

Ma =Ha +RT Inay G.11)

where Ma is the chemical potential of A in the reference state. For p = 1 bar La, = Hy.
One of the most important tasks of solution thermodynamics is the choice of an appro-
priate reference state, and this is the topic of one of the following sections.

3.2 Thermodynamics of solutions

Definition of mi

 

ing properties

The volume of an ideal gas mixture is given by eq. (3.6). Let us now consider only
solid or liquid mixtures. Our starting point is an arbitrary mixture of na mole of
pure A and ng mole of pure B. The mixing process is illustrated in Figure 3.1. We

p, T constant

 

 

Vin, | 7B VinB

 

 

 

mixing

 

nyVa +npVg

 

 

 

Figure 3.1 Mixing of na moles of A and ng moles of B at constant p and T. The molar vol-
umes of pure A and B are Va and Vg. The partial molar volumes of A and B in the solution
are V, and Vg, respectively.

---
3.2 Thermodynamics of solutions 61

will first derive the expressions for the volume of the system before and after the
mixing. The volume before mixing is

V(before) =n 4Vn,a +”2BVm.B (3.12)

where V,,,4 and V,,,p are the molar volumes of pure A and B. We now mix A and B
at constant pressure p and temperature T and form the solution as illustrated in
Figure 3.1. The expression for the volume of the solution is then

Vaafter) =n,Vq +ngVpg (3.13)

where V, and Vg represent the partial molar volumes of A and B (defined by eq.
1.87) in the solution. These partial molar volumes may be seen as apparent vol-
umes that when weighted with the number of A and B atoms give the observed total
volume of the solution. The difference in the volume of the solution before and
after mixing, the volume of mixing, is designated A ,,;,V:

AmixV =V(after) — V(before) =n, (Va, —Va) +np(Vp -Vp) (3.14)

The volume of mixing for one mole of solution is termed the molar volume of
mixing, A jx Vm, and is derived by dividing eq. (3.14) by the total number of moles
(nq +ng) in the system

A mixV

Amix¥m =
(ny +np)

=A AmixVa + *BA mixVB (3.15)

The molar volume of mixing of two binary systems is shown in Figure 3.2.
Pb-Sn shows positive deviation from the ideal behaviour at 1040 K [1] while the
volume of mixing of Pb-Sb at 907 K is negative, with a minimum at xpp #0.5 and
asymmetric with respect to the composition [2].

S
S
S

—0.04

—0.08

0.12

Anmix¥m /10° m3 mol

 

 

-0.16
0.0 0.2 04 0.6 0.8 1.0

Figure 3.2 Molar volume of mixing of molten Pb-Sn at 1040 K [1] and Pb-Sb at 907 K [2]
as a function of composition.

---
62 3 Solution thermodynamics

The phenomenology described above can be applied to any thermodynamic
extensive function, Y;, for a solution. The integral molar enthalpy, entropy and
Gibbs energy of mixing are thus

Amixlm =*AA mix a + *BA mix B (3.16)
AmixSm =*AAmix Sa + XpAmix SB G.17)
AmixGm =XAAmixGa + XBA mixGB (3.18)

The three functions are interrelated by

AmixGm =A mix m ~TA mix Sm GB.19)

Since AnixGa =Ha — HA , the integral molar Gibbs energy of mixing can alterna-
tively be expressed in terms of the chemical potentials as

AmixGm = XA (Ha HA) + XB(Ulg ~My) =RT (vq Ina + xg Inag)
(3.20)

where Hy and 1° are the chemical potentials of pure A and B, whereas [U and [lg
are the chemical potentials of A and B in the given solution. Using G = H - TS, the
partial molar Gibbs energy of mixing is given as

AmixGa =Amix4a —TAmixS, =Ha — MQ =RT Inag B21)

The partial molar entropy, enthalpy or volume of mixing can be derived from eq.
(3.21) and are given by the relations

 

Awmix Sa --(AmZa) =-Rinay rr Rea.) (3.22)
Co. P Co. P
> Olnay
Amixa = 3.23)
mix fone ), ¢
AmixVa -{BanGa } ~r[ aa ma | (3.24)
op T op dr

Corresponding equations can be derived for the partial molar properties of B.

---
3.2 Thermodynamics of solutions 63

Ideal solutions

In Section 3.1 we showed that the chemical potential of an ideal gas in a mixture
with other ideal gases is simply given in terms of a logarithmic function of the mole
fraction. By comparing eqs. (3.9) and (3.10) we see that the fugacity/activity of the
ideal gas is equal to the mole fraction. A solution (gas, liquid or solid) is in general
called ideal if there are no extra interactions between the different species in addi-
tion to those present in the pure components. Thermodynamically this implies that
the chemical activity is equal to the mole fraction, a; = x;, over the entire composi-
tion range. The molar Gibbs energy of mixing for an ideal solution then becomes

Ail Gm =RT (xq Inxy +X In-xp) (3.25)

The Gibbs energy of mixing of an ideal solution is negative due to the positive
entropy of mixing obtained by differentiation of Al Gm with respect to
temperature:

id 2A ix Gm
MnixSm =~ a =-R(x, Inx, + Xp In xg) (3.26)

P

In the absence of additional chemical interactions between the different species
that are mixed the solution is stabilized entropically; the solution is more disor-
dered than a mechanical mixture of the components. The origin of the entropy con-
tribution is most easily understood by considering the distribution of two species
on a crystalline lattice where the number of lattice sites is equal to the sum of the
number of the two species A and B. For an ideal solution, a specific number of A
and B atoms can be distributed randomly at the available sites, i.e. in a large
number of different ways. This gives rise to a large number of different structural
configurations with the same enthalpy and thus to the configurational entropy
given by eq. (3.26). This will be discussed further in Chapter 9.

Two other characteristic properties of ideal solutions are

id —aid a id =
AM Hy =A) Gm + TA Sy =0 (3.27)
aa’ G
id a mix’™ | _¢ (3.28)
mix ~~

Ip

Or in words: in the absence of additional chemical interactions between the two
types of atom, the enthalpy and volume of mixing are both zero.

The partial molar properties of a component i of an ideal solution are readily
obtained:

---
64 3 Solution thermodynamics

 

— {aa G
Ani =| =RT In x; (3.29)
on
‘ PT NM jai
‘a aa’ Gi;
Mix di =- a =-Rin x; (3.30)
DTN jzi ° PN joi

The thermodynamic properties of an ideal binary solution at 1000 K are shown in
Figure 3.3. The integral enthalpy, entropy and Gibbs energy are given in Figure
3.3(a), while the integral entropy of mixing and the partial entropy of mixing of
component A are given in Figure 3.3(b). Corresponding Gibbs energies are given
in Figure 3.3(c). The largest entropic stabilization corresponds to the minimum
Gibbs energy of mixing, which for an ideal solution is RT Ing) or —RT In 2, or
about 0.7 times the thermal energy (R7) at 1000 K.

Excess functions and deviation from ideality

Most real solutions cannot be described in the ideal solution approximation and it
is convenient to describe the behaviour of real systems in terms of deviations from
the ideal behaviour. Molar excess functions are defined as

ASS Ym =A mix¥m — Ai ¥m G31)

mix mix
The excess molar Gibbs energy of mixing is thus

Axim =AmixGm ~RT (x, Inxa + Xp In xg) (3.32)

= RT(x, Ind, + xp lnag)—RT(x,Q Inx, + xg In xg)

The activity coefficient of component i, y;, is now defined as a measure of the
deviation from the ideal solution behaviour as the ratio between the chemical
activity and the mole fraction of i in a solution.

or a; =Y;X; (3.33)

 

For an ideal solution y; =1.
The partial molar Gibbs energy of mixing of a component i in a non-ideal mix-
ture can in general be expressed in terms of activity coefficients as

A nixG; =RT Ina; =RT Inx; +RT ny; (3.34)

---
3.2 Thermodynamics of solutions

—> |
“
Hot-~o, 52

B

 

(a)

 

°

Hay --| HR
_?
a

kJ mol!
plow Lar

(b)

 

 

 

0.2 0.4 0.6 0.8 1.0
XB

Figure 3.3 Thermodynamic properties of an arbitrary ideal solution A—B at 1000 K. (a)
The Gibbs energy, enthalpy and entropy. (b) The entropy of mixing and the partial entropy

of mixing of component A. (c) The Gibbs energy of mixing and the partial Gibbs energy of
mixing of component A.

Using eq. (3.34) the excess Gibbs energy of mixing is given in terms of the mole
fractions and the activity coefficients as

AnixGm = RT(xq Ina,y + xp lnag)= aid m tAQEG m (3.35)

=RT (xq Inxy +. Xp lnxg)+RT (x, Inv, + xp lnypg)

65

---
66 3 Solution thermodynamics
Implicitly:
AxGm =RT (xq nya + xg ln 7g) (3.36)

Since Al Hy =A‘ Vin =0 (eqs. 3.27 and 3.28), the excess molar enthalpy and

mix
volume of mixing are simply

AO =AmixVm (3.37)
Am =A mix4m (3.38)

The excess molar entropy of mixing is the real entropy of mixing minus the ideal
entropy of mixing. Using a binary A-B solution as an example, Am is

Ax Sm =AmixSm —R(r4 nx, + Xp In xp) (3.39)

For a large number of the more commonly used microscopic solution models it is
assumed, as we will see in Chapter 9, that the entropy of mixing is ideal. The dif-
ferent atoms are assumed to be randomly distributed in the solution. This means
that the excess Gibbs energy is most often assumed to be purely enthalpic in nature.
However, in systems with large interactions, the excess entropy may be large and
negative.

As shown above, the activity coefficients express the departure from ideality and
thus define the excess Gibbs energy of the solution. Deviation from ideality is said
to be positive when y > 1 (In 7 is positive) and negative when y< 1 (In y is negative).
A negative deviation implies a negative contribution to the Gibbs energy relatively
to an ideal solution and hence a stabilization of the solution relative to ideal solu-
tion behaviour. Similar arguments imply that positive deviations from ideality
result in destabilization relative to ideal solution behaviour.

The activities of Fe and Ni in the binary system Fe—Ni [3] and the corresponding
Gibbs energy and excess Gibbs energy of mixing are shown in Figures 3.4 and 3.5,
respectively. The Fe—Ni system shows negative deviation from ideality and is thus
stabilized relative to an ideal solution. This is reflected in the negative excess
Gibbs energy of mixing. The activity coefficients y;, defined by eq. (3.33) as a;/x;,
are readily determined from Figure 3.4. 7; for the selected composition xyj = 0.4
is given by the ratio MQ/PQ. At the point of infinite dilution, x; = 0, the activity
coefficient takes the value y;°. y;° is termed the activity coefficient at infinite
dilution and is, as will be discussed in Chapter 4, an important thermodynamic
characteristic of a solution. The activity coefficient of a given solute at infinite
dilution will generally depend on the nature of the solvent, since the solute atoms at
infinite dilution are surrounded on average by solvent atoms only. This determines
the properties of the solute in the solution and thus 7;”.

i

      

---
3.3 Standard states 67

YNi

0.0 0.2 0.4 0.6 0.8 1.0

Figure 3.4 The activity of Fe and Ni of molten Fe-Ni at 1850 K [3]. Atxyj = 0.4 the activity
coefficient of Ni is given by MQ/PQ.

 

\—__7
- 3
7
s
2 6
2
& -9
9,
g¢ -12
-15
0.0 0.2 0.4 0.6 08 1.0

Figure 3.5. The molar Gibbs energy of mixing and the molar excess Gibbs energy of mixing
of molten Fe-Ni at 1850 K. Data are taken from reference [3].

The formalism shown above is in general easily extended to multi-component
systems. All thermodynamic mixing properties may be derived from the integral
Gibbs energy of mixing, which in general is expressed as

+ id
AmixGm =A.Gm +A°S Gm = RTD x; Ina;

i (3.40)
= RTD x; Inx; + RT x; Iny;
i i

3.3 Standard states

In solution thermodynamics the standard or reference states of the components of
the solution are important. Although the standard state in principle can be chosen
freely, the standard state is in practice not taken by chance, but does in most cases
reflect the type of model one wants to fit to experimental data. The choice of

---
68 3 Solution thermodynamics

standard state is naturally influenced by the data available. In some cases the
vapour pressure of one of the components is known in the whole compositional
interval. In other cases the activity of the solute is known for dilute solutions only.

In the following, the Raoultian and Henrian standard states will be presented.
These two are the far most frequent standard states applied in solution thermody-
namics. Before discussing these standard states we need to consider Raoult’s and
Henry’s laws, on which the Raoultian and Henrian standard states are based, in
some detail.

Henry's and Raoult's laws

In the development of physical chemistry, investigations of dilute solutions have
been very important. A dilute solution consists of the main constituent, the solvent,
and one or more solutes, which are the diluted species. As early as in 1803 William
Henry showed empirically that the vapour pressure of a solute i is proportional to
the concentration of solute i:

Pi = Xk (3.41)

where x; is the mole fraction solute and ky ; is known as the Henry’s law constant.
Here we have used mole fraction as the measure of the concentration (alternatively
the mass fraction or other measures may be used).

More than 80 years later Frangois Raoult demonstrated that at low concentra-
tions of a solute, the vapour pressure of the solvent is simply

 

Pi =XiPi (3.42)

where x; is the mole fraction solvent and D; is the vapour pressure of the pure
solvent.

Raoult’s and Henry’s laws are often termed ‘limiting laws’. This use reflects that
real solutions often follow these laws at infinite dilution only. The vapour pressure
above molten Ge-Si at 1723 K [4] is shown in Figure 3.6 as an example. It is evi-
dent that at dilute solution of Ge or Si, the vapour pressure of the dominant compo-
nent follows Raoult’s law. Raoult’s law is expressing that a real non-ideal solution
approaches an ideal solution when the concentration of the solvent approaches
unity. In the corresponding concentration region Henry’s law is valid for the solute.
The Ge-Si system shows positive deviation from ideality and the activity coeffi-
cients of the two components, given as a function of x; in Figure 3.6(b), are thus
positive for all compositions (using Si and Ge as standard states).

Raoult’s law is obeyed for a solvent at infinite dilution of a solute. Mathemati-
cally this implies

(da y/dx,)y, 1 =1 (3.43)

---
3.3 Standard states 69

 

 

(b)

 

 

 

1.0
0.0 0.2 0.4 0.6 0.8 1.0

XSi

 

Figure 3.6 (a) The vapour pressure above molten Si-Ge at 1723 K [4]. (b) The corre-
sponding activity coefficients of the two components.

In terms of activity coefficients eq. (3.43) can be transformed to

(“a {rs +x, dy } =| (3.44)
dea Je. dea Ie.

Since y, 1when x, 1 the expression for Raoult’s law becomes

(2 } =0 (3.45)
dea).

This is a necessary and sufficient condition for Raoult’s law.
A solute B obeys Henry’s law at infinite dilution if the slope of the activity curve
dg Versus xg has a nonzero finite value when xg > 0:

(dag/dxg) x», 50 =7B (3.46)

---
70 3 Solution thermodynamics

The finite value of the slope when xg 0, 7g, is the activity coefficient at infi-
nite dilution defined earlier. In terms of activity coefficients eq. (3.46) becomes

[| -[ r+ 22) =78 (3.47)
dry Je, 50 B )x330

It follows that if Henry’s law behaviour is obeyed at infinite dilution:

[x22] =0 (3.48)
AB Jy 50

Equation (3.48) is a necessary consequence of Henry’s law, but it is not a sufficient
condition. It can be shown that Raoult’s law behaviour of the solvent follows as a
consequence of Henry’s law behaviour for the solute, while the reverse does not
follow.

Raoultian and Henrian standard states

The Raoultian standard state is the most frequently used standard state for a com-
ponent in a solution. The Raoultian standard state implies that all thermodynamic
properties are described relative to those of the pure component with the same
structure as the solution. For liquids the specification of the structure seems artifi-
cial, but for solid solutions, which may have different crystal structures, this is of
great importance. The activity of Ni in molten Fe—Ni at 1850 K using the Raoultian
standard state is given in Figure 3.7 (ordinate given on the left-hand y-axis). The
activity of pure Ni is set as standard state and is thus unity. While the Raoultian
standard state represents a real physical reachable state, the Henrian standard state
is a hypothetical one. The Henrian standard state for Ni in the Fe—Ni solution is
found by extrapolation of the Henrian law behaviour at xyj_,9 to xy =1; see Figure

 

1.0

0.8
1.0
0.6 H
ak, an
0.4 05

0.2
0.0 0.0

0.0 0.2 0.4 0.6 08 1.0

Ni

Figure 3.7 The activity of Ni of molten Fe—Ni at 1850 K using both a Raoultian and a
Henrian standard state. Data are taken from reference [3].

---
3.3 Standard states 71
3.7. The activity of Ni in molten Fe-Ni at 1850 K using the Henrian standard state
is also given in the figure (ordinate given on the right-hand y-axis).

If an arbitrary standard state is marked with *, a formal definition of a Raoultian
standard state for component A of a solution is

Ha =u (3.49)

It follows that the activity coefficient with this standard state:

R_4A
A
= 3.50)
an re
approaches | when the mole fraction x, approaches | or
(Dx, =1 (3.51)

Correspondingly, a formal definition of a Henrian standard state for component
B of a solution is

Mp =H (3.52)

The activity coefficient with this standard state:

all
ve = 53. (3.53)
*B
approaches | when xg approaches 0 or
(78)x530 =! (3.54)
The activities on the two standard states are related since
Hy =H + RT Ina® =u) +RT nat (3.55)
which gives
R R H
a (us -
Se ogg) Mi Hi? (3.56)
H RT

8

---
72 3 Solution thermodynamics

The ratio of two activities defined on the basis of two different standard states is
constant and does not vary with the composition of the solution:

R R R

a

Ba Te “BL tn (3.57)
43 Yg 7B YR

For the present case this constant can be deduced by using the conditions at infinite
dilution as a constraint, thus:

 

 

R R
fe tn (3.58)
Ya \Ys
Y
1h =e (3.59)
Ys

Whereas the total Gibbs energy of the solution is independent of the choice of the
standard state, the standard state must be explicitly given when it comes to the
mixing properties of a solution. The molar Gibbs energy of mixing of the Fe-Ni
system for which the activity of Ni is shown in Figure 3.7 is given in Figure 3.8.
The solid and dashed lines represent Gibbs energies of mixing based on the
Raoultian and Henrian standard states for Ni, respectively.

R_yH
HNiWENi

AmixGm /kJ mol!

 

 

Figure 3.8 The molar Gibbs energy of mixing of molten Fe-Ni at 1850 K using both the
Raoultian (solid line) and Henrian (dashed line) standard states for Ni as defined in Figure
3.7. The Raoultian standard state is used for Fe. Data are taken from reference [3].

---
3.4 Analytical solution models 73
3.4 Analytical solution models

Dilute solutions

Binary solutions have been extensively studied in the last century and a whole
range of different analytical models for the molar Gibbs energy of mixing have
evolved in the literature. Some of these expressions are based on statistical
mechanics, as we will show in Chapter 9. However, in situations where the inten-
tion is to find mathematical expressions that are easy to handle, that reproduce
experimental data and that are easily incorporated in computations, polynomial
expressions obviously have an advantage.

Simple polynomial expressions constitute the most common analytical model
for partial or integral thermodynamic properties of solutions:

n
¥(xp)=Qo + Qi xp +O xp +..+O, 28 = VOjx4, (3.60)
i=0
or
¥(xp)= xa xB Ri(xq — xp)! = xp— xp) Ril -2xp)' (3.61)
i=0 i=0

The variable x is usually the mole fraction of the components. The last expression
was first introduced by Guggenheim [5]. Equation (3.60) is a particular case of the
considerably more general Taylor series representation of Y as shown by Lupis [6].
Let us apply a Taylor series to the activity coefficient of a solute in a dilute binary
solution:

 

> a2
Inyg=Inyp -{G20) xB +5 oie Xpte
XB )r— 30 ax, 930 3.62)
i
ah o'iInyg xi
iN at
B )x_-90

The derivatives of the Taylor series are all finite. It is not necessary to expand the
series at xg = 0, but it is most common and convenient for dilute solutions. The
Taylor series expansion of In yg may be expressed in a different notation as

a
Inyp= dP xh (3.63)
i=0

---
74 3 Solution thermodynamics

 

0.0 0.1 0.2 0.3 0.4
“TL

Figure 3.9 An illustration of low-order terms in the Taylor series expansion of In; for
dilute solutions using Iny-y, for the binary system TI-Hg at 293 K as example. Here
Iny =-2.069, ef! =10683 and J3! =-14.4. Data are taken from reference [8].

where

(3.64)

 

xg 0

The coefficients J are called interaction coefficients of order i. The coefficient of
zeroth order is just the value of In yg at infinite solution. The first-order coefficient
is the most used and is often designated by ep [7]. This coefficient is a measure of
how an increase in the concentration of B changes In yg, which explains why it is
called the self-interaction coefficient. The expression for In yg with only three
coefficients is

Inyg=Inyg +epxg +P x (3.65)

The orders of magnitude of the coefficients depend very much on the system
studied. Generally stronger atomic interactions give larger interaction coefficients.
An illustration of low order terms in the Taylor series expansion of In y7 in the
binary system TI-Hg is given in Figure 3.9 [8].

The same type of polynomial formalism may also be applied to the partial molar
enthalpy and entropy of the solute and converted into integral thermodynamic
properties through use of the Gibbs—Duhem equation; see Section 3.5.

Solution models

The simplest model beyond the ideal solution model is the regular solution model,
first introduced by Hildebrant [9]. Here A,ix Sj, is assumed to be ideal, while
A mix m is not. The molar excess Gibbs energy of mixing, which contains only a
single free parameter, is then

---
3.4 Analytical solution models 75

AX Ga, = OX XB (3.66)

mix

where Q is named the regular solution constant or the interaction coefficient.
The molar Gibbs energy is in this approximation

Gm =XaHX +xXply t+ RT (xq Inxa + Xp Inxg) + Qxa xB (3.67)

The molar Gibbs energy of mixing
AmixGm =RT (xq Inxay + Xp In-xg) + Qxa xB (3.68)
thus consists of one entropic and one enthalpic contribution:
AmixSm =—R(%,q Inx, + Xp In xg) (3.69)
Amix4m = 2X4 %p (3.70)

For ideal solutions Q is zero and there are no extra interactions between the spe-
cies that constitute the solution. In terms of nearest neighbour interactions only, the
energy of an A-B interaction, wap, equals the average of the A~A, waa, and B-B,
Upp, interactions or

2 =2L nan Finn +o) (3.71)

where z is the coordination number and L is Avogadro’s number. For the general
case of a non-ideal solution Q < 0 gives an increased stability of the solution rela-
tive to an ideal solution, while Q > 0 destabilizes the solution. It follows that Q<0
and Q > 0 are usually interpreted as attraction and repulsion, respectively, between
the A and B atoms. Repulsion between the different atoms of the solution will
imply that the atoms do not mix at absolute zero, where the entropic contribution is
zero. Complete solubility will be obtained when the temperature is raised suffi-
ciently so that the entropy gain due to randomization of the atoms is larger than the
positive enthalpic contribution to the Gibbs energy. The integral Gibbs energies of
systems with Q/RT larger and smaller than zero are shown in Figure 3.10.
The regular solution model can be extended to multi-component systems, in
which case the excess Gibbs energy of mixing is expressed as
mal.
AX Gm = DD xj Qi (3.72)
i=l jel

Thus for a ternary system

---
76 3 Solution thermodynamics

 

04 QURT=4

ee
rr

“os SF

0.8

AmixGm/RT

-12

 

 

 

0.0 0.2 0.4 0.6 0.8 1.0
“B

Figure 3.10 The molar Gibbs energy of mixing of a regular solution A-B for different
values of QURT.

Aenix Gm = XpX7Qyy +.44x3Q43 + 47 X3Q93 (3.73)

An additional ternary interaction term, 2173, may be incorporated.

The regular solution model (eq. 3.68) is symmetrical about x, = xg =0.5. In
cases where the deviation from ideality is not symmetrical, the regular solution
model is unable to reproduce the properties of the solutions and it is then necessary
to introduce models with more than one free parameter. The most convenient poly-
nomial expression with two parameters is termed the sub-regular solution model.

AiG m =XAXB(AgX, + Ayn Xp) (3.74)

If more than two parameters are necessary a general polynomial expression may be
applied:
exe Udy pj
AG m “Ldap (3.75)
i=l j=

The Redlich-Kister expression
2
Axe m =X, XplQ + Aj(x,q — xg) + Ay (XQ — XB)~ (3.76)
+A3(Kq — xB) te]

is a frequently used special case of this general polynomial approach. While the
first term is symmetrical about x = 0.5, the second term changes sign for x = 0.5.
The compositional variation of the third and fourth terms is given in Figure 3.11. In
all these models the entropy of mixing is assumed to be ideal and the excess Gibbs
energy is an analytical model for the enthalpy of mixing.

The entropy of mixing of many real solutions will deviate considerably from the
ideal entropy of mixing. However, accurate data are available only in a few cases.
The simplest model to account for a non-ideal entropy of mixing is the quasi-reg-
ular model, where the excess Gibbs energy of mixing is expressed as

---
3.4 Analytical solution models 77

 
   

Contribution to

0.0 0.2 0.4 0.6 0.8 1.0

Figure 3.11 Contributions to the molar excess Gibbs energy of mixing from the four first
terms of the Redlich—Kister expression (eq. 3.76). For convenience Q = Aj = Ay = A =1.

AtnixGm = sqxp0(1-2) B77)
Thus
AX. Gn)
A Sy, = mix) “aT - -sam( 2) (3.78)
é

The sign of the excess entropy is given by the sign of Tt.

Derivation of partial molar properties

The partial molar properties of binary solutions may be determined by both analyt-
ical and graphical methods. In cases where analytical expressions for integral
extensive thermodynamic quantities are available, the partial molar quantities are
obtained by differentiation, but graphical determination of partial molar properties
also has a long history in thermodynamics. The molar Gibbs energy of mixing of
molten Si-Ge at 1500 K is given as a function of the mole fraction of Ge in Figure
3.12. Pure solid Si and pure liquid Ge are chosen as standard states. If we draw a
tangent to the curve at any composition, the intercept of this tangent upon the ordi-
nate xg; =lequals Wg; and the intercept for xg. =l equals Ug..

In mathematical terms the partial molar properties of a binary system will in gen-
eral be given through

dn (3.79)

Ya =Y¥n —*
asYn BE

and

---
78 3 Solution thermodynamics

 

 

 

 

6
- 3
3
z
20 HGe
of °
O 3h MS
m
oF Hs Hoe
00 02 04 06 ~~ «08 1.0

*Ge

Figure 3.12. The integral molar Gibbs energy of liquid Ge-Si at 1500 K with pure liquid Ge
and solid Si as standard states. Data are taken from reference [4].

> dy,
Yg =Yy +(-xg)—™ 3.80)
B=Ym + -xp) ip ¢
Application to the Gibbs energy of the two components of a binary solution there-
fore gives

dG»

Ha =Gm — xB ip (3.81)
lp =Gm +0~ xp) 2S (3.82)
dxp
Taking the excess Gibbs energy of a regular solution as an example:
Ax m =Q2XAXB (3.83)
the partial excess Gibbs energies of the two components are
exe
mix” A Q 2
mk = In =—_x 3.84)
RT Yaar *B ‘
Axe B Q 2
mix” =Inyp =——x* 3.85)
RT 7B Rp “A ‘

In general, the chemical potential of species i for a multi-component system is
given as

---
3.5 Integration of the Gibbs-Duhem equation 79

¢ dGm
Hj =Gm + DG pa (3.86)
jr J

where 6; =O fori # j and 6,; =1 for i = j.

3.5 Integration of the Gibbs-Duhem equation

In experimental investigations of thermodynamic properties of solutions, it is
common that one obtains the activity of only one of the components. This is in par-
ticular the case when one of the components constitutes nearly the complete
vapour above a solid or liquid solution. A second example is when the activity of
one of the components is measured by an electrochemical method. In these cases
we can use the Gibbs-Duhem equation to find the activity of the second
component.

We have already derived the Gibbs—Duhem equation in Chapter 1.4. At constant
pand T:

nada +ngdipg =0 (3.87)

In terms of activity and mole fractions this yields

xadina, +xgdlnag =0 (3.88)
or
xadinx, +xadIny, +xgdIn xg + xgdIn yg =0 (3.89)
Since
xadinxg +xpdlnxy =x, A + xy 2B ary + deg =0 (3.90)
Xa *B

eq. (3.89) may be rewritten
xadiny, +xgdinypg =0 (3.91)

or by integration

XB
Inyg-Inyg(vy=D=- f “Adin, (3.92)

xpol “B

---
80 3 Solution thermodynamics

 

-0.4 -0.3 -0.2 -0.1 0.0

Ing,

Figure 3.13 xyj/xpe versus In 7; of molten Fe-Ni at 1850 K. Data are taken from reference

(31.

If a Raoultian reference state is chosen for both A and B, In yg =O when xg =L.
Now by plotting x,4/xg against In y,, as done for the activity coefficient of Fe of
molten Fe—Ni at 1850 K in Figure 3.13, the Gibbs-Duhem equation may be inte-
grated graphically by determining the area between the limits. The challenge in our
case is that when xp, 0, xyj/Xp. > 2 and In yy; 0. It may therefore be diffi-
cult to evaluate the integral accurately since this demands a large amount of experi-
mental data for xp, > 0.

We may also integrate the Gibbs—Duhem equation using an Henrian reference
state for B:

xB
Inyg—Inyp(tg=0=- f ~Adinyg (3.93)
‘ xB
xp=0
Henry’s law for B leads to In yg =0 when xg =0.
An alternative method of integrating the Gibbs-Duhem equation was developed
by Darken and Gurry [10]. In order to calculate the integral more accurately, a new
function, @, defined as

In .
;- > (i=AorB) (3.94)
(l-x;)
was introduced for binary solutions, since this gave a convenient expression for the
much used regular solution model. An expression for dlny, is obtained by
differentiation:

din 7, =x) =2e, xpdrg + xpdora (3.95)

---
3.5 Integration of the Gibbs-Duhem equation 81

By substituting eq. (3.95) into the Gibbs—-Duhem equation (eq. 3.92) we obtain

XB XB
In7yp =- J2oqxqdep - Jxarpdoy (3.96)
xp=l xpol

Integrating by parts the second integral, we obtain

XB XB XB
Jxarpdoy =loyxaxpl? , - feaxadty + Jeaxndep (3.97)
xpel xpel xpel

which gives the following expression for In 7g (eq. 3.96):

AB XB
InY¥g =—-Oa Xa X_B- Josra +xp)dxg =O, Xa, XB - Jaadrp (3.98)
xg=l xgel

Integration of the Gibbs-Duhem equation applying the method by Darken and
Gurry is illustrated by using the Fe—Ni system as an example: see Figure 3.14. ayj
plotted against xpe gives a curve that is more easily integrated.

A graphical integration of the Gibbs-Duhem equation is not necessary if an ana-
lytical expression for the partial properties of mixing is known. Let us assume that
we have a dilute solution that can be described using the activity coefficient at infi-
nite dilution and the self-interaction coefficients introduced in eq. (3.64).

Inyg=Inyg +epxp +S xh (3.99)

 

 

 

0.0
0.0 0.2 0.4 0.6 0.8 1.0

Re

 

Figure 3.14 aj plotted versus xf¢ for molten Fe—Ni at 1850 K. Data are taken from refer-
ence [3]. The area under the curve represents integration from xfe = 1.0 to 0.1.

---
82 3 Solution thermodynamics
The Gibbs—Duhem equation can be modified to

Olnya 4x Olnyg =0
Oxg Oxg

(l= xp) (3.100)

and thus if the first- and second-order terms in the Taylor series for the solvent are
termed us and Ip (i.e. Nya =I) xp + Js xp):

(= xp)Uf +20}\xg) + xpep +2J3.x8) =0 (3.101)

Hence this implies that

Ji =0 (3.102)
and
1
JS =-58t (3.103)

We are thus able to express the activity coefficient of the second component, A,
in terms of eS:

B

nya =-Fet x, (3.104)

All other properties follow. For example, the excess Gibbs energy of mixing is

AX! Gy =RT (xg ln yp +peps +higher order terms) (3.105)

mix’

The relationship between the different self-interaction coefficients of component
AandB, Js and JP, may in general be obtained in a similar way.

Although the Gibbs—Duhem equation due to the development of versatile and
user-friendly thermodynamic software packages is less central than before, it is
still of great value, for example for testing the consistency of experimental data and
also for systematization of thermodynamic data. The order of magnitude of the
major interaction coefficients discussed above may for alloy systems, for instance,
be estimated with a fair degree of confidence by looking at trends and by compar-
ison with data on similar systems.

---
3.5 Integration of the Gibbs-Duhem equation 83

References

[1] H.R. Thresh, A. F. Crawley and D. W. G. White, Trans. Min. Soc. AIME, 1968, 242,
819.

[2] O. Sato, Bull. Res. Inst. Mineral. Dress. Metall. 1955, 11, 183.

[3] G.R. Zellars, S. L. Payne, J. P. Morris and R. L. Kipp, Trans. Met. Soc. AIME 1959,
215, 181.

[4] C. Bergman, R. Chastel and R. Castanet, J. Phase Equil. 1992, 13, 113.

[5] E. A. Guggenheim, Proc. Roy. Soc. London, Ser. A 1935, 148, 304.

[6] C.H.P. Lupis, Acta Merall., 1968, 16, 1365.

[7] C. Wagner, Thermodynamics of Alloys. Reading, MA, Addison-Wesley, 1962.

[8] _T. W. Richards and F. Daniels, J. Am. Chem. Soc. 1919, 41, 1732.

[9] J. H. Hildebrand, J. Am. Chem. Soc. 1929, 51, 66.

(10)

L. S. Darken and R. W. Gurry, Physical Chemistry of Metals. New York: McGraw-
Hill, 1953, p. 264.

Further reading

P. W. Atkins and J. de Paula, Physical Chemistry, 7th edn. Oxford: Oxford University Press,
2001.

E, A. Guggenheim, Thermodynamics: An Advanced Treatment for Chemists and Physicists,
7th edn. Amsterdam: North-Holland, 1985.

C. H. P. Lupis, Chemical Thermodynamics of Materials. New York: North-Holland, 1983.

K. S. Pitzer, Thermodynamics. New York: McGraw-Hill, 1995. (Based on G. N. Lewis and
M. Randall, Thermodynamics and the free energy of chemical substances. New York:
McGraw-Hill, 1923.

---
