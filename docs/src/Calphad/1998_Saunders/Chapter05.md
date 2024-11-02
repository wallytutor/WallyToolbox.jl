Chapter 5
Thermodynamic Models for Solution and
Compound Phases

5.1, INTRODUCTION

Thermodynamic modelling of solution phases lies at the core of the CALPHAD
method. Only rarely do calculations involve purely stoichiometric compounds. The
calculation of a complex system which may have literally 100 different stoichio-
metric substances usually has a phase such as the gas which is a mixture of many
components, and in a complex metallic system with 10 or 11 alloying elements it is
not unusual for all of the phases to involve solubility of the various elements.
Solution phases will be defined here as any phase in which there is solubility of
more than one component and within this chapter are broken down to four types:
(1) random substitutional, (2) sublattice, (3) ionic and (4) aqueous. Others types of
solution phase, such as exist in polymers or complex organic systems, can also be
modelled, but these four represent the major types which are currently available in
CALPHAD software programmes.
For all solution phases the Gibbs energy is given by the general formula

G=G° + Gide! 4. Gr. (5.1)

where G° is the contribution of the pure components of the phase to the Gibbs
energy, Gite! is the ideal mixing contribution and G%,, is the contribution due to
non-ideal interactions between the components, also known as the Gibbs excess
energy of mixing.

The random substitutional and sublattice models are intimately related, as a phase
with random occupation of atoms on all sites can technically be considered as a
phase containing a ‘single sublattice’ and mathematically the same general equations
used in both cases. However, it is useful to separate the two types as the sublattice
models implicitly define some internal, spatial substructure and give rise to site
occupations which define stoichiometric compounds. Also, and very importantly,
Gide! and G%*,, are governed by site occupation of the components in the various
sublattices rather than the global concentration of the components themselves.

This chapter will begin, very briefly, with the thermodynamic representation of
Gibbs energy for stoichiometric compounds before concentrating on the situation
when mixing occurs in a phase.

5.2, STOICHIOMETRIC COMPOUNDS

The integral Gibbs energy, Giz, pj, of a pure species or stoichiometric compound is
given simply by the equation

Ger, p) = Her,» — TSyr, (5.2)

where Hr, pj and Sir, p) are the enthalpy and entropy as a function of temperature
and pressure. Thermodynamic information is usually held in databases using some
polynomial function for the Gibbs energy which, for the case of the Scientific
Group Thermodata Europe (Ansara and Sundman 1987), is of the form (Dinsdale
1991)

Grin — HSER = a + bT + cT n(T) +Lar. (5.3)

The left-hand-side of the equation is defined as the Gibbs energy relative to a
standard element reference state (SER) where H5E® is the enthalpy of the element
or substance in its defined reference state at 298.15 K, a, b, c and d, are coefficients
and n represents a set of integers, typically taking the values of 2, 3 and -1. From
Eq. (5.3), further thermodynamic properties can be obtained as discussed in
Chapter 6.

= -b-c-eln(T)~ }ond,T™
H=a-cf-)-(n-1)d,T™
Cy = -c- So n(n-1)d,T™.

Equation (5.3) is given with respect to temperature but other terms associated with
pressure and magnetism can be added. The representation of such effects is
described more completely in Chapters 6 and 8.

5.3. RANDOM SUBSTITUTIONAL MODELS

Random substitutional models are used for phases such as the gas phase or simple
metallic liquid and solid solutions where components can mix on any spatial posi-
tion which is available to the phase. For example, in a simple body-centred cubic
phase any of the components could occupy any of the atomic sites which define the
cubic structure as shown below (Fig. 5.1).

In a gas or liquid phase the crystallographic structure is lost, but otherwise
positional occupation of the various components relies on random substitution
rather than any preferential occupation of site by any particular component.
 
<div style="text-align:center">
<p><img src="figures/placeholder.png" alt></p>
<p><em>Figure 5.1. Simple body-centred cubic structure with random occupation of atoms on all sites.</em></p>
</div>

5.3.1 Simple mixtures

5.3.1.1 Dilute solutions. There are a number of areas in materials processing where
low levels of alloying are important, for example in refining and some age-
hardening processes. In such cases it is possible to deal with solution phases by
dilute solution models (Wagner 1951, Lupis and Elliott 1966). These have the
advantage that there is a substantial experimental literature which deals with the
thermodynamics of impurity additions, particularly for established materials such
as ferrous and copper-based alloys. However, because of their fundamental limi-
tations in handling concentrated solutions they will only be discussed briefly.

In a highly dilute solution, the solute activity (a;) is found to closely match a
linear function of its concentration (2;). In its simplest form the activity is written
as

a; = 990; (6.4)

where +? is the value of the activity coefficient of i at infinite dilution. This is
known as Henry’s law. Equation (5.5) may be rewritten in terms of partial free
energies as

G, = G? + RT log, 2; (5.5)

where G?* has a constant value in the Henrian concentration range and is obtained
directly from 7?. The expression can also be modified to take into account
interactions between the solute elements and Eq. (5.5) becomes

Gi = GF + RT log, + RT) ela; (5.6)

where 2; is the concentration of solute i and e/ is an interaction parameter taking
into account the effect of mixing of component i and j in the solvent. There are
various other treatments of dilute solutions, mainly associated with how secondary
interactions are considered (Foo and Lupis 1973, Kirkaldy et al. 1978, Bhadeshia
1981, Enomoto and Aaronson 1985). Recently a more sophisticated dilute solution
treatment consistent with the Gibbs-Duhem integration in more concentrated
solutions has been put forward by Bale and Pelton (1990). This allows the solute
range handled by dilute solution models to be expanded significantly.

Unfortunately, the dilute solution model is limited in its applicability to concen-
trated solutions. This causes problems for alloys such as Ni-based superalloys, high
alloy steels, etc., and systems where elements partition strongly to the liquid and
where solidification processes involve a high level of segregation. It is also not pos-
sible to combine dilute solution databases which have been assessed for different
solvents. The solution to this problem is to use models which are applicable over
the whole concentration range, some of which are described below.

5.3.1.2 Ideal solutions. An ideal substitutional solution is characterised by the
random distribution of components on a lattice with an interchange energy equal to
zero. The entropy due to configuration is easily calculated and is related to the
proability of interchange of the components. The configurational entropy S** is
given by

sont — k log, We (5.7)

where k is Boltzmann’s constant and Wp is the number of configurations in which
the components can be arranged for a given state. For a multicomponent system
Wp is equal to the number of permutations given by

N!
Wp = Tin! (5.8)
where
N= yn (5.9)

n, is the number of components of i and N is the total number of components in the
system. For one mole of components, N is equal to Avogadro’s number. From
Stirling’s formula, S°! is now equal to

cont slog,
gon = trilogy: (5.10)
The ideal molar entropy of mixing is then given by
sides! — — Nk) x; log, a (8.11)
i

where x; is the mole fraction of component i. With the assumption that the inter-
change energy is zero it is possible to substitute the atoms without changing the
energy of that state and Gide"! is then given by

Gite! = -Tsidet! — RT 2; log, 2; (5.12)
t

where R is the gas constant. The Gibbs energy of an ideal solution phase will then
be

Gm = SiG? + RT Sx; log, 2; (5.13)
a i

with G? defining the Gibbs energy of the phase containing the pure component 1.
For the case of gases, ideal mixing is often assumed and this assumption can often
be quite reasonable. However, in condensed phases there is always some interaction
between components.

5.3.1.3 Non-ideal solutions: regular and non-regular solution models. The
regular solution model is the simplest of the non-ideal models and basically
considers that the magnitude and sign of interactions between the components in a
phase are independent of composition. Assuming the total energy of the solution
(Eo) arises from only nearest-neighbours bond energies in a system A — B then

Ey = waa Egg + wep Epp + wap Esp (5.14)

where waa, Wap, WB, Eva, Epp and Eg are the number of bonds and energies
associated with the formation of different bond types AA, BB and AB. If there are
N atoms in solution and the co-ordination number for nearest neighbours of the
crystal structure is z, the number of bond types being formed in a random solution
is

waa = 5Noa% (5.15a)
wep = 5Neak (5.15b)
wap = Nzzatp (5.15¢)

where x4 and xg are the mole fractions of A and B, Substituting Eqs (5.15 (a-c))
into Eq. (5.14) gives

N.
Eo= > (ta Eaa + 2p Epp + 24 2a(2E ap — Ena — Epp)). (5.16)

If the reference states are taken as pure A and B then Eq. (5.16) reverts to

N.
Hnix = Sea 2p (2Eap — Esa — Epp) (5.17)

where Hmix is the enthalpy of mixing. If the bond energies are temperature
dependent there will also be an excess entropy of mixing leading to the well-known
regular solution model for the Gibbs excess energy of mixing

Gt, = arpQ (5.18)

where 2 is now a temperature-dependent interaction parameter. When generalised
and added to Eq. (5.13) this gives

Gm = J) 2G? + RTS 2; log, 2; +S) Yo 24 5 Ny. (5.19)
i i i p>
However, it has been realised for a long time that the assumption of composition-
independent interactions was too simplistic. This led to the development of the sub-
regular solution model, where interaction energies are considered to change linearly
with composition. The following expression for G75, is then obtained as (Kaufman
and Bernstein 1970)

GH, = 240; (Oia; + 04,25). (5.20)

Taking this process further, more complex composition dependencies to 2 can be
considered and it is straightforward to show that a general formula in terms of a
power series should provide the capability to account for most types of composition
dependence (Tomiska 1980). The most common method is based on the Redlich—
Kister equation and Eq. (5.19) is expanded to become

Gm = S02 GP + RES) xi log. 2; +S) 2125; (ai — 23)” (5.21)

where 8 is a binary interaction parameter dependent on the value of v. The above
equation for Gz‘, becomes regular when v = 0 and sub-regular when v = 1. In
practice the value for v does not usually rise above 2. If it is found necessary to do
so, it is probable that an incorrect model has been chosen to represent the phase.

Equation (5.21) assumes ternary interactions are small in comparison to those
which arise from the binary terms. This may not always be the case and where
evidence for higher-order interactions is evident these can be taken into account by
a further term of the type Gj, = 2; 2; 24 Lizz, where Ly, is an excess ternary
interaction parameter. There is little evidence for the need for interaction terms of
any higher order than this and prediction of the thermodynamic properties of
substitutional solution phases in multi-component alloys is usually based on an
assessment of binary and ternary terms. Various other polynomial expressions for
the excess term have been considered, see for example the reviews by Ansara
(1979) and Hillert (1980). All are, however, based on predicting the properties of the higher-order system from the properties of the lower-component systems.

Equation (5.21) is normally used in metallic systems for substitutional phases
such as liquid, b.c.c., f.c.c., etc. It can also be used to a limited extent for ceramic
systems and useful predictions can be found in the case of quasi-binary and quasi-
ternary oxide systems (Kaufman and Nesor 1978). However, for phases such as
interstitial solutions, ordered intermetallics, ceramic compounds, slags, ionic liquids
and aqueous solutions, simple substitutional models are generally not adequate and
more appropriate models will be discussed in Sections 5.4 and 5.5.

5.3.1.4 The extrapolation of the Gibbs excess energy to multi-component systems.
As mentioned in the previous section, most methods of extrapolating the thermo-
dynamic properties of alloys into multi-component systems are based on the
summation of the binary and ternary excess parameters. The formulae for doing this
are based on various geometrical weightings of the mole fractions (Hillert 1980).
To demonstrate this principle, emphasis will be given to three of the main methods
which have been proposed. For simplicity the binary systems will be represented as
sub-regular solutions.

Muggianu’s equation
The predominant method at the present time uses the equation developed by
Muggianu et al. (1975). In this circumstance the excess energy in a multi-
component system, as given by the last term of Eq. (5.21), expands for a sub-
regular solution to
Guz = tat B{ Lp + Lap (ta — 28)} + te tc{ Loc + Lyc(ta — 2c)}
+ tatc{Li¢ + Lhc(ta - 2c)}- (5.22)

Kohler’s equation
In the Kohler equation (Kohler 1960) Gz, is described by

UNREADABLE (5.23)

Although different in form to the Muggianu equation, it becomes identical in a
binary system as the various terms (z; + 2;) terms become equal to 1.

Toop’s equation

Both the Muggianu and Kohler equations can be considered symmetrical as they
treat the components in the same way and do not differentiate between them. This
is true for another method suggested by Colinet (1967) which is derived differently
than either the Kohler or Muggianu equations but which can be reduced to the
Muggianu equation (Hillert 1980). Toop’s equation (1965) is essentially different
in that it considers one of the binary systems does not behave in the same way as
the others and the extrapolation is based essentially on two of the binaries having
identical mole-fraction products with the mole-fraction products of the third being
different. For a sub-regular solution Toop’s equation breaks down to (Hillert 1980)

Gx = 2a TB{L 4p + Lyp(ta—2a—2c)} + tate {Lae + Lac(ta-2e—t2)}

B- IC
Ly L —— : 5
+e ‘Bc + bo( 0 ato 1 2,,) (5.24)

Again this reduces to the normal sub-regular form in the binaries.

The geometrical representation of the Muggianu, Kohler and Toop equations is
best summarised using the figures below.

In the Muggianu extrapolation it can be seen that the line from the ternary alloy
composition to the edge binaries forms a right-angle to the binary. This has the
consequence that, when the alloy composition is dilute in two of the components,
the interaction parameter of these two components will approach regular behaviour
because the term (x; — z;) becomes small. This is the case even if the ratio x; : 1;
differs substantially from unity. This is not important for systems where the
interaction terms higher than sub-regular are small in comparison to the regular
term. However, for systems such as Cr-Ni where the sub-regular part predominates,
any composition dependence of Cr-Ni interactions in dilute solutions with other
elements will be ignored. This could have significant consequences in the
prediction of activity coefficients in low-alloy steels for example. Kohler’s equation
allows for the composition dependence of the binaries and in these circumstances

<div style="text-align:center">
<p><img src="figures/placeholder.png" alt></p>
<p><em>Figure 5.2. Geometrical constructions of (a) Muggianu, (b) Kohler and (c) Toop models.</em></p>
</div>

may be preferable. In practice, the phase boundaries calculated by either the
Muggianu and Kohler extrapolations seem to provide comparable results (Ansara
et al. 1978), but it was noted that the choice of extrapolation method should receive
more attention when exact knowledge of partial quantities such as activity
coefficients is more critical. The Toop equation is not suitable for metallic systems
but may be appropriate for some ionic liquid systems. However, it should be used
with care in all cases as the extrapolation is dependent on which binary is chosen to
behave differently, and it is possible to obtain three different answers depending on
this choice.

5.4. SUBLATTICE MODELS

5.4.1 Introduction
A sublattice phase can be envisaged as being composed of interlocking sublattices
(Fig. 5.3) on which the various components can mix. It is usually crystalline in
nature but the model can also be extended to consider ionic liquids where mixing
on particular ‘ionic sublattices’ is considered. The model is phenomenological in
nature and does not define any crystal structure within its general mathematical
formulation. It is possible to define internal parameter relationships which reflect
structure with respect to different crystal types, but such conditions must be
externally formulated and imposed on the model. Equally special relationships
apply if the model is to be used to simulate order—disorder transformations.
Sublattice modelling is now one of the most predominant methods used to
describe solution and compound phases. It is flexible and can account for a variety
of different phase types ranging from interstitial phases such as austenite and
ferrite in steels to intermetallic phases, such as sigma and Laves, which have wide
homogeneity ranges. Furthermore, it can be extended to simulate Bragg—
Williams—Gorsky ordering in metallic systems and be adapted to account for

<div style="text-align:center">
<p><img src="figures/placeholder.png" alt></p>
<p><em>Figure 5.3, Simple body-centred cubic structure with preferential occupation of atoms in the body-centre and comer positions.</em></p>
</div>

ionic liquids. This section will begin by giving a detailed description of the multiple
sublattice model of Sundman and Agren (1981) and give some specific examples of
usage.

5.4.2 The generalised multiple sublattice model (Sundman and Agren 1981)

5.4.2.1 Definition of site fractions. The multiple sublattice model is an extension
of earlier treatments of the two-sublattice models of Hillert and Steffansson (1970),
Harvig (1971) and Hillert and Waldenstrom (1977). It allows for the use of many
sublattices and concentration dependent interaction terms on these sublattices. To
work with sublattice models it is first necessary to define what are known as site
fractions, y{. These are basically the fractional site occupation of each of the
components on the various sublattices where

at
i = Ns
nj is the number of atoms of component i on sublattice s and N’* is total number of

sites on the sublattice. This can be generalised to include vacancies, which are
important to consider in interstitial phases, such that Eq. (5.25) becomes

(5.25)

y= mao (5.26)

and né,, is the number of vacancies on sublattice s. Mole fractions are directly
related to site fractions by the following relationship

UN

=~. 5.27
SSN va) 62

5.4.2.2 Ideal entropy of mixing. The ideal entropy of mixing is made up of the
configurational contributions by components mixing on each of the sublattices. The
number of permutations which are possible, assuming ideal interchanges within
each sublattice, is given by the following equation

We = [>= (5.28)

and the molar Gibbs ideal mixing energy is

Gide! = Tide" = RTS N* Sy! log. y! (5.29)

where y? includes contribution from vacancies.

5.4.2.3 Gibbs energy reference state. The Gibbs energy reference state is effectively
defined by the ‘end members’ generated when only the pure components exist on the
sublattice. Envisage a sublattice phase with the following formula (A, B),(C, D)).
It is possible for four points of ‘complete occupation’ to exist where pure A exists
on sublattice 1 and either pure B or C on sublattice 2 or conversely pure B exists on
sublattice 1 with either pure B or C on sublattice 2. The composition space of the
phase can then be considered in Fig. 5.4 below as consisting of four compounds, the
so-called ‘end members’, at the corner of each square. The composition of the
phase is then encompassed in the space between the four ‘end member’ compounds
(Fig. 5.4(a)) and the reference energy surface will look like Fig. 5.4(b).

<div style="text-align:center">
<p><img src="figures/placeholder.png" alt></p>
<p><em>Figure 5.4. (a) Composition space encompassed by the system \\((A, B)\_{1}(C, D)\_{1}\\) and (b) the reference energy surface described by equation (5.30) after Hillert and Staffanson (1980).</em></p>
</div>


The surface in Fig. 5.4(b) can be represented by the equation
Gn = yaye Cac + ya ye Gig + YA YD Gp + YB YD Gbp- (5.30)
Equation (5.30) holds for the simple case of a phase with the formula
(A, B),(C, D),. But for more complex phases the function for the Gibbs reference
energy surface may be generalised by arranging the site fractions in a (! + c) matrix
if there are | sublattices and c components.
www ee we
hu w %
au # .


Each row represents a sublattice and each column a component. The information
contained in the subscript and superscript can be represented by a component array
I, which defines one component for each sublattice. Using this notation a more
generalised formula can be obtained (Sundman and Agren 1981)

Gr = SPY) -G? (5.31)
I

where G7 represent the Gibbs energy of the compound defined by J and P;(Y)
represents the corresponding product of site fractions from the Y matrix.

5.4.2.4 Gibbs excess energy of mixing. The method for describing the Gibbs
excess energy can, again, be best shown by using a two-sublattice system (4, B),(C,
D), before generalising to a multi-component system. In this alloy A~C, A—D, B-C
and B-D interactions are controlled by the Gibbs energy of the compounds AC, BC,
AD and BD. Mixing on the sublattices controls A-B and C-D interactions and the
simplest form of interaction is a regular solution format such that

Gils = Va Lp. + vou Bop (5.32)
where L°,. and L%¢ py denote regular solution parameters for mixing on the
sublattices irrespective of site occupation of the other sublattice. A sub-regular
model can be introduced by making the interactions compositionally dependent on
the site occupation in the other sublattice.

Gils = Va Ub ve Linc + va Ub Yb Lip

+ueubth Lac + ve vb Lec (5.33)

Finally some site fraction dependence to these parameters can be added such that
Lipo = Uh vave Lape (vs - vb)” (5.34a)

Diep = v4 Ub voy Lipo (Ya vb)” (5.34b)

Lop = vave vb x Lic (ve - Yb)" (5.34c)

Lic = Ye ve Yb Xx Lisc.p (Ye - vb)" (5.34d)

It is clear that this can be expanded to any number of sublattices and components
and Eq. (5.33) can be generalised using the notation of Eq. (5.31)

G3. = > Pr(¥)- Ln. (5.35)
7

I) refers to a component array of the first order, where one sublattice contains two
components, but the remaining sublattices are occupied by only one component
with the summation being taken over all different J1. The type of component array
that was introduced in Eq. (5.31) can then be denoted JO and referred to as a
component of the zeroth order. Equation (5.35) is general for the case of regular
solutions but can be further extended to include interactions of a higher order, as in
Eq. (5.34), by introducing the appropriate arrays JZ but with a further restriction
that component array must not contain any component more than once in each
sublattice. In this way the excess Gibbs energy can be written as

(co > Pr2(¥)- Liz (5.36)

Z>0 IZ

and the total energy of the phase including the reference energy, the ideal entropy
and excess terms becomes

Get => Pro(¥) -Giy + RT DN? > yi loge y+ )— >- Pra(¥) + Liz. (5.37)
10 s i

230 1Z

5.4.3 Applications of the sublattice model

5.4.3.1 Line compounds. These are phases where sublattice occupation is restricted
by particular combinations of atomic size, electronegativity, etc., and there is a
well-defined stoichiometry with respect to the components. Many examples occur
in transition metal borides and silicides, //I-V compounds and a number of carbides.
Although such phases are considered to be stoichiometric in the relevant binary
systems, they can have partial or complete solubility of other components with
preferential substitution for one of the binary elements. This can be demonstrated
for the case of a compound such as the orthorhombic Cr2B-type boride which exists
in a number or refractory metal-boride phase diagrams. Mixing then occurs by
substitution on the metal sublattice.

For example in the Fe-Cr-B system (Fig. 5.5) Cr2B extends across the diagram
at a constant stoichiometry of boron as (Cr,Fe)2B (Villars and Calvert 1985). Also
shown is the corresponding extension of the tetragonal Fe2B compound. Such
phases are commonly called ‘line compounds’. Generally, sublattice occupation
can be described as

(A, B, C...),(Z),

where A, B and C are the elements which mix on the first sublattice and Z is the
element with fixed stoichiometry. The Gibbs energy of such a phase can be written

Gm = So uiG2, + RTuy yf loge ul + > Yo uly} SO Ly(ot - yj)” (6.38)

<div style="text-align:center">
<p><img src="figures/placeholder.png" alt></p>
<p><em>Figure 5.5. Partial isothermal section for \\(Fe-Cr-B\\) showing stoichiometric behaviour of the \\((Cr,Fe)\_{2}B\\) compound.</em></p>
</div>

where i and j denote the elements mixing on sublattice 1 while Z is the
stoichiometric element. u is the molar number of sites in sublattice 1 and G2,
denotes the Gibbs energies of the various compounds when sublattice 1 is com-
pletely occupied by one of the components mixing on sublattice 1. The excess
energy term is associated only with interactions between the components on the
first sublattice. Because of the fixed stoichiometry, mole fractions can straight-
forwardly be expressed as 1; = (u/(u + v)) y} and Eq. (5.38) becomes equivalent
to the line compound models used by Kaufman and Bernstein (1970).

5.4.3.2 Interstitial phases. These are predominant in steels and ferrous-based
alloys, where elements such as C and N occupy the interstitial sites of the ferrite
and austenite lattices. In this case the structure of the phase can be considered as
consisting of two sublattices, one occupied by substitutional elements, such as Fe,
Cr, Ni, Mn, etc., and the other occupied by the interstitial elements, such as C or N,
and interstitial vacancies (Va). As the concentration of C, N,..., etc., increases the
interstitial vacancies are filled until there is complete occupation. The occupation of
the sublattices is shown below as

(Fe, Cr, Ni, Mn...), (Va, C, N...),-

In the case of an f.c.c.__Al structure, with u= v= 1, the state of complete
occupation of interstitial carbon corresponds to a MC carbide with the NaC] lattice.
For the c.p.h._A3 structure, with u = 1 and v = 0.5, complete occupation of the
interstitial sites by carbon gives the M2C carbide with a hexagonal Fe2N-type
structure.

For the case of the f.c.c._Al, austenite phase in Cr-Fe-C, the Gibbs energy of
the phase is represented by the formula (Cr, Fe), (C, Va); and its Gibbs energy
given by the following equation

Gm = Vora Gerve + Urea Reva + YorveCErc
+ UreveGPuc + RT (1- (yo, log. vor + vee loge Yee)
+1: (vlog. ve + Ha loge Vis))

+ abate (SO Hessevalits~ vh)")

+ ubsvhe (30 Here (vts—¥h)")

+ibatsin (So Lcwlié-#,)')

+ vbatah (SO Uheclib ut"). )

The first two terms represent the Gibbs energy of f.c.c._Al Cr and Fe because the
second sublattice consists entirely of unfilled interstitial sites. The next two terms
represent the Gibbs energy of the CrC and FeC compounds which are formed when
all of the interstitial sites of the f.c.c._A1 lattice are filled with C. The second line is
the ideal entropy term while the last four lines correspond to the excess term. It can
be seen that, when we =0, the model reduces to Eq. (5.21) for the simple
substitutional mixing of Cr and Fe. This is particularly useful as thermodynamic
assessments of metallic binary systems can be extended to include interstitial
elements without the need for changing any of the existing parameters.

5.4.3.3 Complex intermetallic compounds with significant variation in stoichio-
metry. In many binary systems intermetallic compounds may exhibit significant
solubility and there may be more than two crystallographic sublattices to consider.
This is the case for compounds such as the a, 1, x and Laves phases, and in such
circumstances the sublattice model should, as closely as possible, follow the
internal sublattice structure of the compound itself. Taking the case of oc, this
consists of five crystallographically distinct sublattices occupied by atoms in the
ratio 2:4:8:8:8 (Villars and Calvert 1991). The total number of atoms per unit cell is
then 30. Full mixing of all components on all sublattices yields a prohibitively high
number of variables, making a CALPHAD calculation in a multi-component
system almost impossible. Even modelling the phase in a binary would be
extremely difficult and some simplification is necessary.

This can be achieved for o by considering two types of components differen-
tiated almost exclusively by size considerations. The sublattice occupation can then
be simplified. One possibility is to consider o as either (A, B)6(A, B)1o(B)4 where
the first and third sublattices and fourth and fifth sublattices are ‘joined’, i.e., site
occupation of A and B atoms are considered to be equal on the sites. Alternatively
(A, B)i6(A)i0(B)4 may be used where mixing is considered only to occur on the
fourth and fifth sublattices (Ansara et al. 1997). The latter occupation arises when
solubility of B components is small in the second sublattice, as appears to be the
case for most o phases. The consequence of this simplification is that the sublattice
formula for the Co-Mo @ phase is given by (Co, Mo)j6(Co)19(Mo), and the Gibbs
energy is then

Gm = GSo.coito + Ghtorcoato + PT (16 » (Yio !08e Yo + Yeo 108s Yito))
+ tbsthotbstho (3 Htaswcome(tls~ th)”: (6.0)
:

As ydo = tuto = 1, Eq. (5.40) becomes rather like Eq. (5.21) in that mixing is
simplified to two components on a single sublattice but the points of complete
occupation do not reach pure Co or Mo. The expressions for Gibbs energy become
more complex when, with the addition of further elements, mixing can occur on all
sublattices as in the case of Ni~Co-Mo-W. Here the sublattice formula would be
(Ni, Co, Mo, W):6(Ni, Co)io(Mo, W),, but this degree of complexity can be
handled straightforwardly by most current software.

5.4.3.4 Order-disorder transformations. The previous examples considered strict
site preference for the components in sublattice phases. For example, in the (Cr,
Fe)2B compound, B is not considered to mix on the metal sublattice, nor are Cr and
Fe considered to mix on the B sublattice. This strict limitation on occupancy does
not always occur. Some phases, which have preferential site occupation of elements
on different sublattices at low temperatures, can disorder at higher temperatures
with all elements mixing randomly on all sublattices.

It was demonstrated by Sundman (1985) and later by Ansara et al. (1988) that an
otder—disorder transformation could be modelled by setting specific restrictions on
the parameters of a two-sublattice phase. One of the first phases to be considered
was an A3B-ordered compound. In such circumstances the sublattice formula
(A, B)3(A, B) can be applied and the possible relationships between site fractions
and mole fractions are given in Figure 5.6. The dashed lines denoted rg = 0.25,
0.5 and 0.75 show variations in order of the phase while the composition is
maintained constant. When these lines cross the diagonal joining A34 and B3B the
phase has disordered completely as y}, = y3 = xg. AS the lines go toward the
boundary edge the phase orders and, at the side and comers of the composition
square, there is complete ordering of A and B on the sublattices.

The two-sublattice order-disorder model (2SLOD) requires first that the Gibbs
energy should always have an extremum along the diagonal representing the
disordered state with respect to fluctuations in site fractions at constant
composition. Further, when the disordered phase is stable this extremum must be
a minimum. By assuming that G9., and G3. are zero and applying the above
conditions it is possible to define interconnected parameters for the various values

<div style="text-align:center">
<p><img src="figures/placeholder.png" alt></p>
<p><em>Figure 5.6. Relationship between site and atomic fractions in the 2SLOD model for \\(Ni\_{3}Al\\).</em></p>
</div>

of G9.z and G4 and the excess mixing terms, such that the 43B phase is ordered
at low temperature but disorders as the temperature is increased. For the case of an
A3B compound one solution gives (Ansara et al. 1988)

Gig =u
GB.a = U2
Lipa = 8u; + u2/2 + 3ug

 

Lips = uy /2 + 3uz + 3ug
Ling = 2/2 + us
Dh.ap = 11/2 + us

Lipa = 34
Tips = 3us
Tha = U4
Lhap = 4s
Tipap = 4uy — dus. (5.41)

The above terms give the ordering contribution to the total energy, and to provide
the necessary disordered energy it was necessary to add further terms. This is done
by using the relationships

tasu-yytu-y, and rg=u-yhtu-ys (5.42)

where u and v are the number of sites on sublattices 1 and 2. Replacing x4 and zg
in Eq. (5.21), expanding and comparing with the formula for the two-sub-lattice
model, an equivalence in Gibbs energy between the disordered substitutional solid
solution and a two-sublattice model can be obtained if the following parameters are
used (Saunders 1989):

Gig = uv- D9, + uv(u—v)- Lig + uv(u— 0) Lap
G84 = uv 12, —uv(u—v)- Lig + uv(u—v)"- Dap
Lipa =u. 19, + 3u’v- Lh, + u’v(5u— 2u)- Lag
Tipe =u? - Lip — 3u’v- Lig + u’v(5v ~ 2u)- Lig
Lipa =U - Lhg + 4u'v- Lig
Lipp =v: Lip — 4u'v- Lip
Thea =ul- Tha
Tes aul. Lig
Lap =v: Lp + 3v'u- Lh + u(5u — 20) - Lig
Loap =v 19, — 3u7u- Lig + v?u(Su — 2v)- Lig
Lhap=v*- Lhg + 4v'u- Lig
Lyap = + Ly — 408u- Dig
Tap =v'- Lip
Lap =v The
Tipap = —24u’v? - Lip (5.43)

where Loe are the respective excess parameters from Eg. (5.21) (note L replaces
Q in the above notation). Adding the ordered and disordered part together
provides the total Gibbs energy of the phase both in the ordered and disordered
state. This method was used by Gros (1987), Ansara et al. (1988) and Saunders
(1989) and, in general, calculations give quite reasonable results. However, the
model proved to have some flaws (Saunders 1996). Firstly, when asymmetrical
terms for the ordering energies are used (i.¢., u; # U2) they give rise to a residual,
extraneous excess Gibbs energy when the phase disorders and there is no longer an
equivalence in Gibbs energy between the 2SLOD model and the original disordered
phase. Secondly, when the disordered part is extended to higher order systems there
is an incompatibility with the substitutional model when sub-regular or higher
terms are used for the various L°!? parameters in Eq. (5.43).

Some of the problems with the model were addressed in later work by Dupin
(1995) who used a more complex formulation for the ordering parameters. Firstly,
the ordering contribution was separated from disordered contribution and added
straightforwardly to the Redlich-Kister energy polynomial. This also made it
simpler to combine with a Redlich-Kister model and removed the need for re-
formatting existing phases already modelled using this format. Secondly, the
extraneous excess energies from the ordering parameters were empirically removed
such that the excess Gibbs energy due to the ordered parameters became zero on
disordering. The Gibbs energy is then expressed as a sum of three terms

2

Gm = Gin (ai) + Gar (uly?) — Gr (ut = aii 9

 

(5.44)

 

where Gils(2;) is the Gibbs energy contribution of the disordered state, Go"4(y}y?)
is the Gibbs energy contribution due to ordering and G°4(y! = 2;; y? = 2) is a
term which represents the extraneous excess energy contribution from the ordered
parameters when the phase disorders. A more accurate representation of the Ni~Al
diagram was achieved using this model (Dupin 1995) and the work was extended to
Ni-AI-Ti-Cr and Ni-Al-Ta-Cr.

However, the empirical removal of the residual, extraneous energies, Gad
(y} = 24; y? = 2;), causes internal inconsistencies in the model. For example, in an
ordered compound such as an AB or A3B type, it is possible that the Gibbs energy
which is actually calculated for the fully ordered state is quite different from that
specified for G74 or Cry (Saunders 1996). It would therefore be better if the
model was derived in such a way that these extraneous energies did not arise. This
is actually the case when ordering energies are symmetrical in the form where
G4.2 = Gh.q and LY y. = L?4 g = —G9.q (Saunders 1989). This is equivalent to
the conditions of the Bragg—Williams-Gorsky model of Inden (1975a, 1975b,
1977a, 1977b). However, this limits the model when it is applied to phases such as
Ti3Al and Ni3Al where substantial asymmetries are apparent.

The empirical nature of the 2SLOD model is such that it cannot be considered a
true ordering model in its own right and is therefore included in this chapter rather
than the more fundamental chapter on ordering (Chapter 7). However, Sundman
and Mohri (1990), using a hybrid sublattice model, showed it was possible to model
the Cu-Au system such that it closely matched the phase diagram achieved by a
Monte-Carlo method (see Chapter 7). This was done by combining a four-sublattice
model, with composition-independent interaction energies, and a gas cluster model
for the short-range ordering which was modified to account for a restriction in the
degrees of freedom in the solid state. The sublattice model was equivalent to a
classical Bragg~Williams (1934) treatment at low temperatures and therefore
remains a basic ordering treatment. To model complex ordering systems such as
Ti-Al it is almost certainly necessary to include at least third nearest-neighbour
interchange energies (Pettifor 1995).

5.5. IONIC LIQUID MODELS

Phase diagrams containing ionic liquids, such as slag systems and molten salts,
can be complex and show apparently contradictory behaviour. For example the
SiOz-CaO phase diagram shows liquid immiscibility as well as thermodynamically
stable compounds. Immiscibility is usually associated with positive deviations from
ideality and, at first sight, is not consistent with compound-forming systems which
exhibit large negative deviations. Such features arise from a complex Gibbs energy
change with composition and, although the Gibbs energy of mixing can be negative
over the whole composition range, inflections in the mixing curve give rise to
spinodal points with subsequent decomposition to two liquids (Taylor and Dinsdale
1990). The use of simple mixture models for ionic liquids has not been successful.
They need large numbers of coefficients to mimic the sharp changes in enthalpy
around critical compositions, and binary systems thus modelled tend to predict the
behaviour of multi-component systems badly.

Many models have been proposed to account for the thermodynamic behaviour
of ionic liquids and some important ones are listed below:

(1) Cellular models

(2) Modified quasichemical models
(3) Sublattice models

(4) Associated solution models

The above is not intended to be a definitive list but rather to indicate some of the
more commonly used models at the present time. Other, more historical, models
have been used extensively, for example the polymerisation models of Toop and
Samis (1962) and Masson (1965), the models of Flood (1954), Richardson (1956)
and Yokakawa and Niwa (1969). More recently the ‘central atom’ model by Satsri
and Lahiri (1985, 1986) and the ‘complex’ model of Hoch and Arpshofen (1984)
have been proposed. Each has been used with some success in lower-order systems,
but the extension to multicomponent systems is not always straightforward.

5.5.1 The cellular model

Kapoor and Frohberg (1973) applied this model to the ternary system CaO-FeO-Si02.
They envisaged that mixing occurred by formation of three ‘asymmetric cells’
obtained by a reaction between ‘symmetric cells’ of the metallic oxides and silica.
For CaO-SiO,, the formation energy for the asymmetric cell is denoted Wjs, where
the subscripts / and S denote the combination of ‘symmetric’ cells from CaO and
SiO,. In addition interactions between the various symmetric and asymmetric cells
were considered such that

Erss = 2€15,55 (5.45)

where €7,55 denotes the interaction between the symmetric CaO and SiO, cells and
€7s,s the interaction between the asymmetric cell formed between CaO and SiO,
and the symmetric silica cell. This is expanded with the addition of FeO so that the
two further asymmetric cells are formed with energies Wys and W,;, where J
denotes the FeO cell, and the additional interaction energies between the cells were
related in the following way:

E198 = E1s,ss + Es5,58 (5.45a)

where €ys,ss is the interaction energy between the asymmetric cell formed between
FeO and SiO, and the silica cell. It was further assumed that interactions terms were
negligibly small in comparison to the cell formation energies and that €ys,55/kT
and €js,55/kT were small compared to unity. Based on these assumptions they were
able to define the Gibbs energy of mixing in a system such as CaQ-FeO-SiQ, as

Griz _ 3555 1, (0 =a)

Soe log,(1 — Ns) ~ Nrlog, Nr — Ny log, Ns
+ (Nr — Ris — R13) log.(Nr — Ris — Rrs)
+ (Ny — Rus — Ris) log.(Ny — Ras — Ris)
+ (Ns — Ris — Rus) log,(Ns — Rrs — Rus)
+ 2Rys log, Ris + 2Rys log, Rys + 2Rrz log, Rry
4 2WisRis + 2WisRas 4 2Wrs Riz

 

RT RT RT
2e(1 — Ns)(Ns — Ris — Rus)
+ P (5.46)

with

Nj ==

> ny + 2ng

7

and

ns
Ns =—— SS
> 75 + Ins
a

where i denotes either CaO or FeO and n; and ng denote the number of moles of
CaO, FeO and SiO2. The interaction parameter ¢ is given by

Do nieisss

and the various values of Rj;s by

15
Ry = 5.48a)
ij Son + 2ns ( )

i

(Nr — Ris — R13) (Ny — Ras — Ris) = Rise (- a) (5.48b)

 

QW, 2e(1 — Ny
(N1—- Ris—R1s) (Ns—Ris—Rys)= Risexr(- ne) exp ¢ ate)

(5.48c)

(Ny-Rais—Rrs) (Ns— Ris—Rys)= Ris oo(- 7) on(- a)

(5.48)

where r,; are the number of moles of the different asymmetric cell types. In Eq.
(5.46) it can be seen that the first five lines correspond to the configurational
entropy term. This is no longer ideal because of preferential formation of the
various asymmetrical cells and the system effectively orders. This is a feature of
ionic systems and gives rise to forms of quasichemical entropy which will also be
discussed in the next section.

From the above equations, activities of metallic oxides and silica were calculated
for various binary slag systems and CaO-FeO-SiO2 and found to be in good
agreement. The drawback of the model is that equivalents need to be made between
various anionic and cationic types and problems can arise when these are poly-
valent. Also, considering that only a ternary system was considered, the expressions
for Gibbs energy are complex in comparison to the simple mixture and sublattice
types. Gaye and Welfringer (1984) extended this model to multi-component
systems but the treatment is too lengthy to consider here.

5.5.2 Modified quasichemical models

A modified form of the quasichemical model of Guggenheim (1935) and Fowler
and Guggenheim (1939) has recently been developed by Pelton and Blander
(1986a, 1986b, 1988) for application to ionic liquids. The model considers that the
liquid has a strong tendency to order around specific compositions, associated with
specific physical or chemical phenomena. This was considered to be a general
feature of ionic liquids and that previous attempts at modelling of ordered salts and
silicate slags were either too specific in nature to the type of system, i.e., oxide or
halide, or too complicated for general usage, particularly when considering extrap-
olation to higher-order systems. The model is therefore phenomenological in nature
which has the advantage that it can be widely applied.

First, consider a binary liquid A~B in which A and B atoms mix substitutionally
on a quasi-lattice with coordination number Z. There is the possibility that A-B
pairs will be formed from A-A and B-B pairs by the following relation

(A—A) + (B~B) = (A-B).

The molar enthalpy and entropy change of this reaction, denoted respectively w
and 7 by Pelton and Blander (1986a, 1986b, 1988), is given by (w — nT). If this is
zero the solution is ideal. However, if (w— nT) is negative then there will be
ordering of the mixture around the 50:50 composition and the enthalpy and entropy
of mixing will show distinct minima at the AB composition. As ordering does not
always occur at AB it is desirable to allow other compositions to be chosen for the
position of the minima, which is done by replacing mole fractions with equivalent
fractions ya and yg where

me Bata
Bata+ Bare

Bare

do yp =e
one 98 Fea + Baap

(5.49)
where (4 and @g are numbers chosen so that y4 = yg = 0.5 at the composition of
maximum ordering. Letting x44, Zag and xg be the fractions of each type of pair
in the liquid gives

 

Hix = (Bata + Ba 2)(“42)w (6.50)
seen Re (Bata + Bpzp) (0a log, “44 + app log, 22 + zap log, -—42 )
2 vA vb 2ya ve,
— R(x4 log, 4 + xg log, xp) (5.51)
and
St, = (Baza + Bete) F2)n (5.52)

where Z is the average co-ordination number. Two mass balance equations can be
written

ya = Waat+ tap (5.53a)
2yp = app + Zap (5.53b)

and minimisation of the Gibbs energy then gives the ‘quasichemical equilibrium
constant’

2
TAB ~2(w- nT)
—_*-=4 ——_=>=— a
LAALBB o( 2zRT (5.54)

Eqs (5.53) and (5.54) can be solved for any given values of w and 7 to provide za,
pp and z4p which can then be used to define the enthalpy and entropy values

given in Eqs (5.50)}{5.52). The choice of 84 and @g can be found using the
following equation

(1 — 1) log.(1 — r) + vlog, r = 268 r log, 0.5 (5.55)

where r = 84/(84 + Bg). Finally, some simple compositional dependence is
defined for w and

w= Pu ys (5.56a)
n=0
and
n= ony (5.56b)
n=O

The approach has been used effectively for a variety of systems, for example oxide
and silicate slags, salt systems, and is readily extendable to multi-component
systems (Pelton and Blander 1984, 1986a, 1986b, Blander and Pelton 1984). The
general applicability of the model is demonstrated by the recent work of Eriksson et
al. (1993) who are in the process of creating a comprehensive database for the
system SiO,—Al,0;-CaO-MgO-MnO-FeO-Na,O-K,0-TiO,-Ti,03-ZrO,S.

5.5.3 Sublattice models

Essentially, sublattice models originate from the concepts of Temkin (1945) who
proposed that two separate sublattices exist in a solid-state crystal for cations and
anions. The configurational entropy is then governed by the site occupation of the
various cations and anions on their respective sublattices. When the valence of the
cations and anions on the sublattices are equal, and electroneutrality is maintained,
the model parameters can be represented as described in Section 5.4.2. However,
when the valence of the cations and anions varies, the situation becomes more
complex and some additional restrictions need to be made. These can be expressed
by considering equivalent fractions (f) which, for a sublattice phase with the
formula (I+, J+3...)(M-™, N-"...), are given by

(5.57a)

and

uh (5.57b)
“me
where i and m are the valences of I and M respectively. These replace site

fractions in the general expressions for the Gibbs energy reference and excess
mixing terms. The ideal mixing term is given as (Pelton 1988)

ca (su) * (Sree was) (Spt) (5.58)

This approach works well for systems where no neutral ions exist and a database
for the system (Li, Na, K)(F, Cl, OH, CO3, SO,) has been developed (Pelton 1988)
which gives good estimates for activities in multi-component liquids. However, the
above approach is more limited in the presence of neutral ions which are necessary
if one wishes to model ionic liquids which may contain neutrals such as S,

To overcome this problem an extension of the sublattice model was proposed by
Hillert et al. (1985) which is now known as the ionic two-sublattice model for
liquids. As in the previous case it uses constituent fractions as composition vari-
ables, but it also considers that vacancies, with a charge corresponding to the charge
of the cations, can be introduced on the anion sublattice so that the composition can
move away from the ideal stoichiometry and approach an element with an electro-
positive character. The necessary neutral species of an electronegative element are
added to the anion sublattice in order to allow the composition to approach a pure
element. The sublattice formula for the model can then be written as

 

(Cf")p (45, Va, ) (5.59)

where C represents cations, A anions, Va hypothetical vacancies and B neutrals.
The charge of an ion is denoted v; and the indices i, j and k are used to denote
specific constituents. For the following description of the model, superscripts 0, v
and 0 will be excluded unless needed for clarity. The number of sites on the
sublattices is varied so that electroneutrality is maintained and values of P and Q
are calculated from the equation

P=) yy, + Qyva (5.60a)
7

and
Q= se, (6.606)

Egs (5.60a) and (5.60b) simply mean that P and Q are equal to the average charge
on the opposite sublattice with the hypothetical vacancies having an induced charge
equal to Q. Mole fractions for the components can be defined as follows:

= Pyc,
P+Q(1— va)

tp, = —— 2 .
 P+Q(1— va)

Cations ro (5.61a)

Anions (5.61b)

The integral Gibbs energy for this model is then given by
Gm => Yo ¥0, 9A, G8,:4, + Quve Dy; G2, + QD yn, GB,
i j a k
+ ra Pye loge Yo, + (So, ose, + walog, ye
1 a

+ oun, log. vs)
¥
+ => Y Vir Vir Ys Lining + S20 vir Yin Yoo Lininve

ook ip

+O Vai ws Lins +) Du uswve Ligve
i jn ag

inh

tO DY wy Lise + OY vive we Liver
TT k 7“

+> xy ky Vix Liye (5.62)
Bi

where G@,.4, is the Gibbs energy of formation for (v, + v2) moles of atoms of
liquid C;A; and AG@, and AG§, are the Gibbs energy of formation per mole of
atoms of liquid C; and B; respectively. The first line represents the Gibbs energy
reference state, the second line the configurational mixing term and the last three
lines the excess Gibbs energy of mixing. As the list of excess parameters is long
and the subscript notation is complex, it is worth giving some specific examples for
these parameters after Sundman (1996):

Liyizg — tepresents the interaction between two cations in the presence of a
common anion; for example Lcq+2,qg+?,0-2 Tepresents an interaction term
from the system CaO-MgO.

Lijiz:va Tepresents interactions between metallic elements; for example Loa mg in
Ca-Mg.

Lj.j  Tepresents interactions between two anions in the presence of a common
cation; for example Leq+2.9n-1,co;? in Ca(OH)2-CaCOs.

Li.jz represents interactions between an anion and a neutral atom; for example
Dye+2,s-2g in the S-rich part of Fe-S.

Li:vak represents interactions between a metal and a neutral; for example
Dret?.vac in Fe-C.

Lk,,k2  Fepresents interactions between two neutrals; for example Lsi,n,,sio, in
Si;N4-SiO}. It should be noted that the cation is irrelevant here as the
number of cation sites has become zero when only neutrals are taken into
account.

The model is certainly complex, but perhaps no more so than previous ionic
liquid models described in Sections 5.5.1 and 5.5.2. The initial experience (Selleby
1996) suggests that the number of terms needed to describe a ternary system such
as Fe-Mn-S is quite similar for both ionic two-sublattice liquid and associate
models (see next section). The modelling of ionic liquids is, in the main, complex
and the advantages of the various techniques can only become apparent as they
become more commonly used.

There are a number of immediate advantages to the two-sublattice ionic liquid
model. The first is that it becomes identical to the more usual Redlich—Kister
representation of metallic systems when the cation sublattice contains only
vacancies. This immediately allows data from an assessed metallic system to be
combined with data from an oxide system so that the full range of compositions is
covered. In binary cases the model can be made equivalent to an associated model.
For example in Cu-S the associated mode! would consider a substitutional solution
of Cu, S and Cu,S. If an ionic two-sublattice model with a formula (Cu*')p(S, Va,
S)g is used, it is straightforward to derive parameters to give identical results to the
associate model. However, it should be noted that the Gibbs energy of the two
models does not remain equivalent if they are extended into ternary and higher-
order systems (Hillert et al. 1985).

5.5.4 Associated solution models

There are a number of papers dealing with the associated models (Predel and
Oehme 1974, Sommer 1977, Sharma and Chang 1979, Chuang et al. 1981,
Bjérkman 1985) which are all very similar in principle. There are differences in the
way the excess terms are handled, but all consider that some type of complex or
associate is formed inside the liquid from a reaction between the components of the
system in question. The thermodynamic properties of the liquid then depend
predominantly on the Gibbs energy of formation of these complexes, or associates,
rather than by interactions between the components. This gives rise to enthalpy of
mixing diagrams which are characterised by sharp changes at critical compositions
where the associate(s) exist and also by markedly non-ideal mixing entropies.

The derivation of Sommer (1977, 1980, 1982) can be used as an example. This
considers the formation of a single associate with a formula A,B; within a binary
system A-B. It is assumed the liquid contains n4, and ng, number of moles of
‘free’ A and B in equilibrium with m4,p, number of moles of the associate A:B;.
The mole fractions of A, B and A;B,, in a binary alloy containing 1 mole of A and
B atoms, are then given by the formula

TA=NA, +inas; Tea=Np, +jnas, and A,B, = NAB, (5.63)

The excess Gibbs energy of mixing is then given by the general formula
GB, = G+ G's (5.64)

G*™ is the Gibbs energy due to the formation of the associate defined as
G™ = naj, CAB, (5.65)

where G4, B; is the Gibbs energy of formation of one mole of the associate. G™®
considers the Gibbs energy due to the interactions between the components A and B
themselves and with the associate A,B; such that

NA, NB, NA, A,B, B, NA,B,
Gh = CE 4 Og Ot OB (5.66)

where n = na, + Ng, + 74,8,. The configurational entropy is given simply by
scot — —R(na, log. ca + ne, log, zB + 14,5, log, £4,B,)- (5.67)

The model was applied to numerous ionic melts and good agreement was found
with experimental results (Sommer 1982). One of the main criticisms of the
associate formalism has been that, although the concept considers associates or
complexes to be ‘diffuse’ in nature, the mathematical formalism implies that
distinct molecules exist, which is harder to justify. However, if this stringent view
is relaxed, it can be seen that the model merely implies some underlying structure
to the liquid, which is quite reasonable, and it does provide functions which allow
for the temperature dependence of the enthalpy of mixing. A more serious criticism is
that some knowledge of the relevant associate is necessary before Eqs (5.64)-(5.67)
can be applied. The most appropriate associate can be selected by fitting of
experimental results for enthalpies of mixing which is sufficient in a large number
of cases. However, in some systems there may be a number of different associates
and it is not always obvious as to which types actually exist. The main advantages
of the associate models is that they allow a simple strategy to be adopted for
optimisation. It is further easy to define ternary and higher-order associates and
extend the model to multi-component systems. For example, Bjérkman (1985)
showed this to good effect in the system Fe-O-SiO2.

To complete this section it is interesting to show the equivalence between the
ionic two-sublattice model and the associate model as demonstrated by Hillert et al.
(1985). Equation (5.62) can be simplified for a system (A+), (B**®, Va-"4, B°) 9
where +va = —vb to become, for one mole of atoms,

Gn VE FAceB/ vay, + RT (yp log, ys + yolog. yp + yva log. Yva) + Grix/VA
~ yBuB
(0-7)

where y is the site fraction occupation of the neutral B° on sublattice Q. Equations
(5.65)-(5.67) will yield for one mole of atoms

 

 

(5.68)

2A,Bj,G™* + RT(rA,p, log. 24,8, + TA, log, A, + ZB, log, tB,)
+24, BB, Gye p, + TA, TA.Bj,C an a,B, + TB TAB, Co A,B,
(1+ 24,3, +3-1))

 

(5.69)

 

The two models become identical for the case where i = j = vA = —vB = 1 and it
is then possible to show the following identities: (1) x4,2, = ya, (2) 2a, = ys and
(3) 24, = yva-

As ya = 1, the C'S term has the following equivalence

A,B, GP = ya YB Gyswag-v0 (5.70)
and the excess terms of the associate show the following equivalences

2a, ZB, ORS; = YA Ya YB Laser, peya-s
TA, TAB, OAaB, = YA Wa YB Laws.p-3va
ZB, TA,B, Oos,p, = YA Yo YB Lawn.pop—vB- (5.71)
7

They can also be made identical in the general case if the conditions i = —vB/vA
and j = 1. The equivalences break down in ternary and higher-order systems as
there is the introduction of more compositional variables in the associate model
than for the two-sublattice case. This was considered (Hillert et al. 1985) to
demonstrate the advantages of the sub-lattice model, but as mentioned previously it
turns out that the number of excess terms to describe Fe-Mn-S is very similar.

5.6 AQUEOUS SOLUTIONS

Aqueous solutions form a large area for thermodynamic modelling and hold great
importance in their own right. However, they are, by definition, basically dilute
solutions and almost all models deal exclusively with the thermodynamic
properties of the aqueous solution, only considering some possible precipitation
reactions of insoluble, mainly stoichiometric, compounds. The integration of these
models into concentrated solution databases which are often used at high tempera-
tures has therefore not been seriously undertaken by any group as far as the authors
are aware. There has, however, been quite significant use of aqueous models in
conjunction with substance databases for prediction of thermodynamic properties
and solubility products in a number of important areas such as corrosion and
geochemistry. To this end some discussion of aqueous modelling is worthwhile.

One of the main conceptual differences between the models discussed so far and
aqueous solutions is that the units which are used to define thermodynamic
functions are often different. This is because they apply to the properties which are
actually measured for aqueous systems, and molarity (c;) and molality (m,) are far
more common units than mole fraction. Molarity is defined as

 

10-37;
c= (5.72)
and molality as
m= mi (5.73)
nw My

where M,, is the molar mass of water and V the volume of the solution in m3. The
partial ideal mixing term for component i, (Gi4*) can be defined with respect to
molality as

Gites! — Ge + RT log, (mi) (5.74)

where G? is the chemical potential of component i in its standard state. This can be
combined with some term for the partial excess Gibbs energy so that the chemical
potential of i can be defined. The excess Gibbs energy term is defined using the
ionic strength (J) where

1=05> mz (5.75)

where z; is the charge in electron units of the component i. This can be used to
define the limiting excess Gibbs energy of an electrolyte solution containing cations
of charge z* and anions of charge z~ via the Debye—Hiickel limiting law as
A apn, (5.76)
(nw My RT) 3

References are listed on pp. 124-126.

Differentiation of Eq. (5.76) with respect to the amount of solute leads to the
expression

loge i = —2 AVI. (5.77)

The above equation assumes that the ions are point charges and interact in a
continuous dielectric. It is essentially correct in the limit, but problems arise when
considering finite concentrations of solute where an extended Debye—Hiickel
expression may be more appropriate

—2AVT

a bavi (5.78)

log. 1 =

Here A and B are temperature-dependent parameters which are properties of pure
water only and q; is the effective diameter of the hydrated ion. This expression can
be used up to ionic strengths of 5x 10"? (Davies 1985) but for higher concentrations
further terms are needed. One of the simplest expressions is to consider a linear
term with respect to ionic strength such that

2 AVT
k 4 = —+—_ + BI 5.79
087 (i+ Bayi *® (5.79)
or, more generally,
-2AVT i
I ;= et r. 5.80)
8 = To Ba) uA (5.80)

By considering Ba; as a single adjustable parameter, data can then be fitted using
only Ba; and f as variables. A further simplification is to make Ba; equal to unity
and add a further constant ionic strength term which gives the Davies equation
(Davies 1962)

=-2a(—VE__
bes = eta YE oat). (5.81)

Further expansions are possible following Bromley (1973) and Zemaitis (1980)
such that
—#AyT , (0.06 +0.66)2?

av) (+4)

i

logio i = +B4+xP +60. (5.82)

A further approach is to consider a more specific form of ion interaction and replace
Eq. (5.80) with the Bronsted—Guggenheim equation (Guggenheim and Turgeon
1955)

—2#
log. i = a+ Tea t Desa (5.83)

The last term represents ion interactions between i and j as a function of ionic
strength. A simplification of Eq. (5.83) was suggested by Pitzer and Brewer (1961)
such that

—0.510727 VT
logi9. 4 = ———— (+vt) “+ Tews (5.84)

where the interaction coefficients become concentration independent. The Debye—
Hiickel term then has similarities with the Davies equation in that Ba; is made
equal to unity.

One of the main models which is available in CALPHAD calculation pro-
grammes is that based on Pitzer (1973, 1975), Pitzer and Mayorga (1973) and
Pitzer and Kim (1974). The model is based on the development of an explicit
function relating the ion interaction coefficient to the ionic strength and the addition
of a third virial coefficient to Eq. (5.83). For the case of an electrolyte MX the
excess Gibbs energy is given by

=fD FLY AM mim + YY minmimjm, (5.85)
ij tog ok
with

j= At Toga(t +1.2VT)

where ,;(I) and jj, are second and third virial coefficients from the non-
electrostatic part of G74, mix, and A? is the Debye-Hiickle limiting slope. 4:3, is taken
to be independent of ionic strength and set to zero if ions i, j and k have the same
charge sign. Equation (5.86) is similar in form to the excess terms considered for
simple mixture phases, except that some specific terms arising from the unique
properties of aqueous systems are included. Differentiation of Eq. (5.85) with
Tespect to concentration yield the following expression for activity coefficients of
cation (M), anion (X) and neutral species (N) (Clegg and Brimblecombe 1989)

(5.86)

loge 1m = ZF + Lim(2Bue + ZCma) + Lm (20 + Tote]
@

$Y meme hae + Jul Sm

@ <a’

+2 made +32Yo mymesnase (5.87a)
n j ok

loge7x = %F + D> me(2Bex + ZCex) + D> Me (20. + Dmx)

+ OY meme xce + lel 9S D> me Ma Coa

€ <c ©

+23 mp Arn t3 > dom; Mk BXjk (5.87b)
n jk

loge tv = 2) > ma Ava +2) me Ave +2) Ma Ave +3) dM Ms Lis
7 © a 7
(5.87¢)

where the subscripts c, a, and n represent cations, anions and neutrals respectively.
Summation indices c < ¢ and a < a’ denote sums over all distinguishable pairs of
cations and anions while summations with indices i, j and k cover all species and
are unrestricted, Z = }; m;|z;| while F is defined as

pan a( vi Meal) 5S mem Be

(1+ bVT) b
tLe me Be + OD ma ma Bigs: (5.88)
© <e a <a!

The ionic strength dependence of the coefficients, Byx, is

Bhrx = lax + Bx exp(-avT) (6.89)

Bux = Blyx + Bax 9(avT) (5.90)
1 ’ V1

Bux = Phas (ov) (5.91)

with the function g and 9’ given by

- a(t - ( + evT) en(-avI))

g= oT (5.92a)
—2(1-(1+avI+a7l/2 -avT

where a is usually assigned a value of 2 for electrolytes of low charge. The mixture
terms 4°, ® and ®’ are defined as

BF, = 655 +70;3(1) + 1°91, (1) (5.93)
ij = 655 +" 0;; (1) (5.94)
1, = 61, (1) (5.95)

6,; is a constant for each pair of ions. "6,;(I) and "6{,(I) are universal functions
that are required when ions of differing charge types are mixed.

As can be seen from the above equations, modelling of concentrated aqueous
solutions becomes complex and it is not possible within the scope of this book to do
justice to what is a major field in its own right. There are a number of articles which
can be recommended to give the reader some idea of what can be achieved with
aqueous models. Harvie and Weare (1980) developed a model for calculating
mineral solubilities in natural waters based on the Pitzer equations which achieved
good accuracy up to strengths of 20 m. This work was extended by Harvie et al.
(1982, 1984) so that a database exists for the prediction of mineral solubilities in
water up to high ionic strengths at 25°C for the system Na, K, Mg, Ca, H, Cl, S04,
OH, HCO3, CO3, CO2, H20. More recently Clegg and Brimblescombe (1989)
presented a database, again using the Pitzer model, for the solubility of ammonia in.
aqueous and multi-component solutions for the system Li, Na, Mg, NH4, Mg, Ca,
Sr, Ba, F, Cl, Br, I, OH, CNS, NO3, NO2, C103, ClO4, S, SO;, CH;COO, HCOO
and (COO),, H20. Further models and applications can be found in articles by
Zemaitis (1980) and Grenthe and Wanner (1988). The review of Davies (1985) also
gives details of software programmes which are available for calculating equilibria
in aqueous solutions.

REFERENCES

Ansara, I. (1979) Int. Met. Reviews, 22, 20.

Ansara, I. and Sundman, B, (1987) in Computer Handling and Dissemination of Data, ed.
Glaeser, P. S., p. 154, CODATA.

Ansara, I., Sundman, B. and Willemin, P. (1988) Acta Metall., 36, 977.

Ansara, I, Bernard, C., Kaufman, L. and Spencer, P. (1978) CALPHAD, 2, 1.

Ansara, I, Chart, T. G., Hayes, F. H., Pettifor, D. G., Kattner, U., Saunders, N. and Zeng, K.
(1997) CALPHAD, 21, 171.

Bale, C. W. and Pelton, A. D. (1990) Met. Trans. A, 21A, 1997.

Bhadeshia, H. K. D, H (1981) Metal Science, 15, 175.

Bjorkman, B. (1985) CALPHAD, 9, 271.

Blander, M. and Pelton, A. D. (1984) in Second International Symposium on Metallurgical
Slags & Fluxes, eds Fine, A. H. and Gaskell, D. R. (Met. Soc. AIME, New York), p. 295.

Bragg, W. L. and Williams, E. J. (1934) Proc. Roy. Soc., A145, 69.

Bromley, L. A. (1973) J. Amer. Inst. Chem. Eng., 19, 313.

Chuang, Y.-Y., Hsieh, K.-C. and Chang, Y. A. (1981) CALPHAD, 5, 277.

Clegg, S. L. and Brimblecombe, P. (1989) J. Phys. Chem., 93, 7237.

Colinet, C. (1967) D.E.S. University of Grenoble, France.

Davies, C. W. (1962) Jon Association (Butterworths, Washington).

Davies, R. H (1985) in Critical Thermodynamics in Industry: Models and Computation, ed.
Barry, T. 1. (Blackwell Scientific, Oxford), p. 40.

Dinsdale, A. T. (1991) CALPHAD, 15, 317.

Dupin, N. (1995) PhD. Thesis, I’Institut National Polytechnique de Grenoble, France.

Enomoto, M. and Aaronson, H. I. (1985) CALPHAD, 9, 43.

Eriksson, G., Wu, P. and Pelton, A. D. (1993) CALPHAD, 17, 189.

Flood, H. ef al. (1954) Z. Anorg. Allg. Chem., 276, 289.

Foo, E,-H. and Lupis, C. H, P. (1973) Acta Met., 21, 1409.

Fowler, R. H. and Guggenheim, E. A. (1939) Statistical Thermodynamics (Cambridge
University Press, Cambridge).

Gaye, H. and Welfringer, J. (1984) in Proceedings of Second Symposium on Metallurgical
Slags and Fluxes, eds Fine, H. A. and Gaskell, D. R. (Met. Soc. AIME, New York), p. 357.

Grenthe, I. and Wanner, H. (1988) Guidelines for the extrapolation to zero ionic strength,
Report TDB-2 to OECD Nuclear Energy Agency, Data Bank, F-91191 Gif-sur-Yvette,
France (December 5, 1988).

Gros, J. P. (1987) Dr. Ing. Thesis, l'Institut National Polytechnique de Grenoble, France.

Guggenheim, E. A. (1935) Proc. Roy. Soc., A148, 304.

Guggenheim, E. A. and Turgeon, J. C. (1955) Trans. Farad. Soc., 51, 747.

Harvie, C. E. and Weare, J. H. (1980) Geochim. Cosmochim. Acta, 44, 981.

Harvie, C. E., Euguster, H. P. and Weare, J. H. (1982) Geochim. Cosmochim. Acta, 46, 1603.

Harvie, C. E., Meller, N. and Weare, J. H. (1984) Geochim. Cosmochim. Acta, 48, 723.

Harvig, H. (1971) Acta Chem. Scand., 25, 3199.

Hillert, M. (1980) CALPHAD, 4, 1.

Hillert, M. and Steffansson, L.-I, (1970) Acta Chem. Scand., 24, 3618.

Hillert, M. and Waldenstrom, M. (1977) CALPHAD, 1, 97.

Hillert, M., Jansson, B., Sundman, B. and Agren, J. (1985) Met. Trans. A, 16A, 261.

Hoch, M. and Arpshofen, M. (1984) Z. Metallkde., 75, 23 and 30.

Inden, G. (1975a) Z. Metallkde., 66, 577.

Inden, G. (1975b) Z. Metallkde., 66, 648.

Inden, G. (1977a) Z. Metallkde., 68, 529.

Inden, G. (1977b) J. de Physique, Colloque, C7, 373.

Kapoor, M. L. and Frohberg, G. M. (1973) in Chemical Metallurgy of Iron and Steel (Iron
and Steel Institute, London), p. 17.

Kaufman, L. and Bernstein, H. (1970) Computer Calculation of Phase Diagrams (Academic
Press, New York).

Kaufman, L. and Nesor, H. (1978) CALPHAD, 2, 35.

Kirkaldy, J. S., Thomson, B. A. and Baganis, E. A. (1978) in Hardenability Concepts with
Applications to Steel, eds Kirkaldy, J. S. and Doane, D. V. (AIME, Warrendale), p. 82.

Kohler, F. (1960) Monatsh. Chem, 91, 738.

Lupis, C. H. P. and Elliott, C. H. P. (1966) Acta Met., 4, 529 and 1019,

Masson, C. R. (1965) Proc. Roy. Soc., A287, 201.

Muggianu, Y. M., Gambino, M. and Bros, J. P. (1975) J. Chim. Phys., 22, 83.

Pelton, A. D. and Blander, M. (1984) in Second International Symposium on Metallurgical
Slags & Fluxes, eds Fine, A. H. and Gaskell, D. R. (Met. Soc. AIME, New York), p. 281.

Pelton, A. D. (1988) CALPHAD, 12, 127.

Pelton, A. D. and Blander, M. (1986a) Met. Trans, B, 17B, 805.

Pelton, A. D. and Blander, M. (1986b) in Computer Modelling of Phase Diagrams, ed.
Bennett, L. H. (TMS, Warrendale), p. 19.

Pelton, A. D. and Blander, M. (1988) CALPHAD, 12, 97.

Pettifor, D. G. (1995) private communication.

Pitzer, K. S. (1973) J. Phys. Chem., 77, 268.

Pitzer, K. S. (1975) J. Soln. Chem., 4, 249.

Pitzer, K. S. and Brewer, L. (1961) Thermodynamics; 2nd Edition (McGraw-Hill, New York).

Pitzer, K. S. and Kim, J. J. (1974) J. Am. Chem. Soc., 96, 5701.

Pitzer, K. S. and Mayorga, G. (1973) J. Phys. Chem., 77, 2300.

Predel, B. and Oehme, G. (1974) Z. Metalikde, 65, 509.

Richardson, F, D. (1956) Trans. Farad. Soc., 52, 1312.

Sastri, P. and Lahiri, A. K. (1985) Met. Trans. B, 16B, 325.

Sastri, P. and Lahiri, A. K. (1986) Met. Trans. B, 17B, 105.

Saunders, N. (1989) Z. Metallkde., 80, 894,

Saunders, N. (1996) CALPHAD, 4, 491.

Selleby, M. (1996) unpublished research.

Sharma, R. C. and Chang, Y. A. (1979) Met. Trans. B., 10B, 103.

Sommer, F. (1977) CALPHAD, 2, 319.

Sommer, F. (1980) Z. Metallkde, 71, 120.

Sommer, F. (1982) Z. Metallkde., 73, 72 and 77.

Sundman, B. (1985) private communication.

Sundman, B. (1994) unpublished research.

Sundman, B. (1996) private communication.

Sundman, B. and Mohri, T. (1990) Z. Metalikde, 81, 251.

Sundman, B. and Agren, J. (1981) J. Phys. Chem. Solids, 42, 297.

Taylor, J. R. and Dinsdale, A. T. (1990) CALPHAD, 14, 71.

Temkin, M. (1945) Acta Phys. Chim. USSR, 20, 411.

Tomiska, J. (1980) CALPHAD, 4, 63.

Toop, G. W. (1965) Trans. Met. Soc. Aime, 233, 855.

Toop, G. W. and Samis, C. S. (1962) Can. Met. Quart., 1, 129.

Villars, P. and Calvert, L. D. (1991) Pearson’s Handbook of Crystallographic Data for
Intermetallic Phases; 2nd Edition (ASM International, Materials Park, OH).

Wagner, C. (1951) Thermodynamics of Alloys, Addison-Wesley, Reading, Mass.

Yokokawa, T. and Niwa, T. (1969) Trans. Japan Inst. Met., 10, 1.

Zemaitis, J. F. (1980) in Themodynamics of Aqueous Systems with Industrial Applications,
ed. Newman, S. A. (American Chemical Society), p. 227.
