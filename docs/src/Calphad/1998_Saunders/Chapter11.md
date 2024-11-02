Chapter 11
Combining Thermodynamics and Kinetics

11.1, INTRODUCTION

Knowledge of phase equilibria in its own right is a powerful tool for the under-
standing of materials behaviour even in situations where true equilibrium is never
reached. Knowledge of critical temperatures, pressure and composition ranges for
the formation of phases is very important in defining limiting parameters for usage
or processing. However, certain processes develop microstructures which are well
away from the equilibrium state, for example rapid solidification, mechanical
alloying, vapour deposition, etc., and these cannot be directly interpreted using
equilibrium phase diagrams. Phase equilibria are also not directly applicable to
predicting the development of microstructure and, in this case, some further
knowledge and application of phase transformation theory is necessary.

These limitations to a ‘traditional’ CALPHAD approach have long been under-
stood and the combination of thermodynamics and kinetics is seen as a logical
extension of the CALPHAD methodology. While phase transformation theory is
often seen as a somewhat separate area, certain critical input parameters can only
be obtained from the understanding of phase equilibria. For example, the simplest
case of transformation in steels requires, at the very least, knowledge of the
temperature below which austenite becomes unstable to the precipitation of ferrite
(T7~?). If one wishes to use some form of growth equation, the driving force for
the growth of ferrite in austenite is required. This driving force is often
approximated as some function of the undercooling below T7~® and hidden
within a series of adjustable parameters which take into account other effects. It
is, therefore, not always explicitly recognised as a thermodynamic input
parameter.

The aim of this chapter is to introduce the reader to some of the ways in which
the CALPHAD approach has been combined with kinetics to predict the formation
of phases and/or microstructures under conditions which are not considered to be in
equilibrium. Broadly speaking, the combination of thermodynamics and kinetics
can be broken down into at least two separate approaches: (1) the calculation of
metastable equilibria and (2) the direct coupling of thermodynamic and kinetic
modelling.

In its simplest form, the calculation of metastable equilibria merely requires the
‘suspension’ of an equilibrium phase, for example, the calculation of the Fe-C

41

===========
412 N. Saunders and A. P. Miodownik

phase diagram with or without graphite to give respectively the Fe + graphite phase
diagram or the Fe-Fe3C phase diagram. This is often done empirically; for example
the Fe-graphite phase diagram is used for cast irons while the Fe-Fe;C diagram is
used for steels. Rapid solidification processing is another area where kinetic
limitations are often arbitrarily placed on the system in order to use conventional
G/z diagrams as a tool to help interpret phase formation.

Such an approach should not be confused with the direct coupling of thermo-
dynamic and kinetic parameters. Broadly speaking, this can achieved either

1. By the direct coupling of thermodynamic and kinetic models in a single
software package, where the kinetic model can call the thermodynamic
calculation part as a subroutine for the calculation of critical input parameters.

or

2. Thermodynamic calculations are made separately and calculated data are
input into a kinetic model, perhaps from a datafile.

Direct coupling has a number of significant advantages as ‘local’ effects can be
directly calculated rather than globally approximated under a single external input.
The present chapter will present detailed examples of the above approaches and
discuss their advantages/disadvantages and areas of applicability.

11.2. THE CALCULATION OF METASTABLE EQUILIBRIA

11.2.1 General concepts and sample calculations

An advantage of the CALPHAD method over experimental measurement of phase
diagrams is that it is possible to make predictions for the extension of various phase
fields outside their range of equilibrium stability. For example, Ansara (1979) was
able to straightforwardly show the variety of metastable phase diagrams that could
exist for a system such as Ni-Ti (Fig. 11.1). Some of the diagrams are for regions
which would be highly metastable and, therefore, unlikely to be accessible, but the
figure clearly shows how a phase diagram could be modified if suppression of
various phases were to occur.

Figure 11.2 shows the calculated stable phase diagram for Fe-C from Gustafson
(1985) which is characterised by a eutectic between 7-Fe and graphite. This eutectic
occurs for many cast irons and graphite forms from the liquid state. However, if the
C level is low, as in steels, solidification can occur directly to 6- or y-Fe. On
cooling, the steel becomes unstable to the formation of graphite and there is a
driving force for its precipitation. However, the volume change on forming graphite
from the solid state is high and the nucleation of graphite becomes difficult. A
variety of conditions then lead to the formation of the metastable phase Fe;C which
has transus temperatures only marginally below those found for equilibrium with
graphite. It is difficult to overemphasise the importance of this effect as many

 

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide

 

2000

 

TEMPERATURE, K
S
3
3S

 

 

 

Ni calculated TiNi observed Ti

Figure 11.1. Calculated (a) metastable phase diagrams in the Ni-Ti system, (b)
some combinations of these digrams and (c) comparison of calculated and
observed stable diagram (Ansara 1979).

 

 

===========
414 N. Saunders and A. P. Miodownik

 

 

n
2
n
4
a
oO
w
%
>
&
<
a
a
=
a
&
WEIGHT_PERCENT C
Figure 11.2, Calculated Fe-C phase diagram.
n
2
n
i
a
9,
w
2
>
&
<
2
wo
a
=
a
&

 

WEIGHT_PERCENT C

Figure 11.3. Calculated metastable Fe~C phase diagram. Stable diagram with
graphite is shown by dotted lines (Gustafson 1985).

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 415

common steels are metastable with respect to graphite. It is only because the
kinetics of transformation to graphite is so slow that the breakdown of the desirable
carbide structure to a much weaker graphite-containing alloy is prevented. This
effect has been known empirically for many years and CALPHAD calculations can
be made for the metastable Fe-Fe3C phase diagram (Fig. 11.3). This is done by
‘suspending’ graphite from the calculations but otherwise keeping the same model
parameters for the liquid, f.c.c. and b.c.c. phases.

Another such example occurs in Ti-Si alloys. The stable phase diagram of Ti-Si
indicates that, below 1170°C, G- and a-Ti become unstable with respect to Ti3Si.
However, in practice, Ti3Si only forms after lengthy anneals at high temperature
and TisSi3 is formed instead. Calculations for commercial Ti-alloys (Saunders
1996a) are then routinely made considering only TisSi; and its phase boundaries
are extrapolated by the calculation below 1170°C.

Another use of metastable diagrams is in the processing of some Nimonic super-
alloys which are unstable to 7 phase formation (Betteridge and Heslop 1974).
Usually, alloys of this type rely on the precipitation-hardening of -y, the Ni-based
matrix phase, by +y, an ordered intermetallic based on Ni3Al. However, when the
ratio of Ti/Al becomes too high, a 7-phase based on Ni3Ti can form as well. As the
kinetics of +’ precipitation is faster than 7, most processing can be done so that 7
forms instead, and at some service temperatures transformation kinetics may be
sluggish enough so that the metastable +’ does not then transform to 7. It is
therefore of value to be able to predict both the stable and metastable solvus
temperatures for 7 and +y’ and understand the behaviour of the alloy with either
both phases appearing or with only 7’ taking part. A Nimonic 263 alloy with a
composition (in wt%) Ni-0.5Al-20Co—20Cr-5.9Mo-2. 1 Ti-0.001B-0.06C can
be used as an example. Figures 11.4 and 11.5 show phase % plots for this alloy
with 7 respectively included and excluded. It is interesting to note that the 7’ is
only just metastable and its amount when 7 is excluded is similar to the amount
of equilibrium 7 itself.

While the approach outlined above has proved useful in predicting phase equilibria
for metastable alloys, it is rather limited as it does not allow any predictions to be
made for the conditions under which metastability can be achieved. This means that
the use of the CALPHAD route has to be tempered by the user’s judgement and
past experience. Any quantification is not straightforward when phase competition
is close, for example, in the case of some cast irons where the Fe3C and graphite
phase boundaries are very similar. In this case some cooling conditions give rise to
graphite while others give rise to Fe;C. However, when processing conditions are
far from equilibrium it is possible to be more certain about the conditions where
metastable equilibria are likely to be observed. An example of such an area is rapid-
solidification processing.

===========
416 N. Saunders and A. P. Miodownik

80

40

MOLE % PHASE

   
   

600 800 M,B,, 1000 1200 1400
Mz;C, TEMPERATURE_CELSIUS

Figure 11.4, Calculated phase % vs temperature plot for a Nimonic 263 Ni-based
superalloy.

MOLE % PHASE

800 4B, 1000 1400
M23C, TEMPERATURE_CELSIUS

Figure 11.5. Calculated phase % vs temperature plot for a Nimonic 263 Ni-based
superalloy with stable n-phase suspended.

11.2.2 Rapid-solidification processing

A simple method for predicting limits for glass-forming ability (GFA) in metallic
alloys was proposed by Saunders and Miodownik (1983). They utilised the Tp
criterion to predict the limit to the glass-forming range (GFR) of a number of binary
and ternary systems. The Tp criterion follows the premise that, if cooling conditions

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 417

G (kJ/mol)

“0

empd « | To
limited | 1 Himited

 

 

o 123 6 5 6 7 8 9 wo
MOLE FRACTION Ti x10

Figure 11.6, Calculated G/z curves for Ni-Ti at T, (760 K). Experimental glass-
forming range (GFR) from Polk ef af. (1978).

are sufficiently fast to preclude solute redistribution in the liquid, the GFR would be
limited by the composition region where the liquid is more stable than other com-
peting single phases at the glass transition temperature (T;). It is straightforward to
find this limit by calculating the G/z diagram for the system of interest at Ty.

CALPHAD calculations were made for a number of binary systems including
Au-Si, (Hf,Ti,Zr)—Be and Ni-Ti (Saunders and Miodownik 1983) and a series of
ternaries Hf-Ti-Be, Hf-Zr—Be and Hf-Ti-Be (Saunders et al. 1985). Figure 11.6
shows such a calculation for Ni-Ti. The results were encouraging in that they pre-
dicted with reasonable accuracy the limit to glass formation when the terminal solid
solutions were considered. However, there was limited success when taking into
account compound phases. To this end the approach was extended to include the
kinetics of transformation more explicitly. Remarkably good results were then
obtained for a wide variety of binary and ternary system and these are reported in
Section 11.3.4,

11.2.3 Solid-state amorphisation
The use of G/z diagrams has found more extensive use in the prediction of GFA by
solid-state amorphisation reaction (SSAR) (Johnson 1986, Schwarz 1988). SSAR

===========
418 N. Saunders and A. P. Miodownik

GIBBS FREE ENERGY (kCa¥/g-atom)

 

 

® 02 oe 08 on 10.
A x= La

Figure 11.7. G/z curves for Au-La (from Schwarz and Johnson 1983). Open
circles indicate fully amorphous structure, partly filled circles indicate partly
amorphous structure.

can be achieved in a number of ways, for example by isothermal inter-diffusion
reactions between thin films of elements (Schwarz and Johnson 1983) and
mechanical alloying of elemental powders (Koch et al. 1983). The process relies on
the fast diffusion of one of the elements into the other and the kinetics being
sufficiently slow to prevent the formation of the intermetallic compounds. The
thermodynamic stability of the amorphous phase is then the controlling factor in
whether or not an alloy will form a glass.

The early work of Schwarz and Johnson (1983) used a prediction of the under-
lying thermodynamics of the Au-La system to explain the relative stability of the
liquid/amorphous phase in their elemental layered composites (Fig. 11.7). How-
ever, they utilised the method proposed by Miedema (1976) for thermodynamic
stability of the liquid/amorphous phase. There are clear limitations to the Miedema
approach; firstly it is not guaranteed to produce the correct phase diagram and
therefore phase competition is at best only approximated, and secondly, the thermo-
dynamics of the terminal solid solutions are chosen quite arbitrarily.

There are a number of studies where the CALPHAD approach to GFA in amor-
phous systems has been used. Bormann and co-workers (1988, 1990, 1993) and
Saunders and Miodownik (1986) have all used G/z diagrams to help explain the
formation of amorphous phases in SSAR. This work has shown that as well as

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 419

predicting the phase diagram, it is possible to demonstrate on a more quantitative
basis the relative underlying stability of the various phases. While Saunders and
Miodownik (1986) extrapolated the properties of the high-temperature liquid to the
SSAR temperature, Bormann et al. (1988, 1990) considered the possibility of further
stabilisation due to the liquid-to-glass transition and this has significant advantages
in helping to understand the thermodynamic properties of the amorphous state.
The use of the CALPHAD route also pointed to a potential reaction sequence
that could explain the initial stages of the amorphisation reaction (Saunders and
Miodownik 1986). It is clear from the G/s diagrams of a number of systems that a
preceding step in the formation of an amorphous phase could be the supersaturation
of an element such as Zr by fast-moving atoms such as Co and Ni (Fig. 11.8). This
would then lead to a collapse of the crystalline structure to a more stable amorphous
phase beyond a critical Co or Ni concentration. Some findings of the supersaturation
of Zr by Co in layered structures have been reported (Samwer et al. 1988, Pampus ef
al. 1987), which would be consistent with the proposed mechanism, and this was
again suggested by Gfeller et al. (1988). However, it seems that the main mechanism
for formation of the amorphous phase is by reaction at the interface (Johnson 1986).
A further method of producing amorphous phases is by a strain-driven solid-state
reaction (Blatter and von Allmen 1985, 1988, Blatter et al. 1987, Gfeller et al.
1988). It appears that solid solutions of some transition metal-(Ti,Nb) binary
systems, which are only stable at high temperatures, can be made amorphous. This
is done by first quenching an alloy to retain the high-temperature solid solution.
The alloy is then annealed at low temperatures where the amorphous phase appears
transiently during the decomposition of the metastable crystalline phase. The effect
was explained by the stabilisation of the liquid phase due to the liquid—glass

30

Co-Zr

+ = equilibrium compound

G (kJ/mol)

+ LiguID

+ +

 

 

0 10 20 30 40 0 60 70 80 % 100
At% Zr

Figure 11.8. Calculated G/z curves for Co-Zr at 200°C (Saunders and
Miodownik 1986).

===========
420 N. Saunders and A. P. Miodownik

s

-10

Gibbs energy (kJ/mol)

   

-0 Noni,
. wot nat

2

on prt
m 20 30 40 S060 70 BO 9H

 

 

 

 

Ni ‘composition [a1%] Nb

Figure 11.9. Calculated G/z curves for Nb-Ni at 580°C (Gfeller et al. 1988). L,

B and a represent, respectively, the undercooled liquid, the b.c.. solid solution

and the amorphous phase. (™@) are results from enthalpy of crystallisation

experiments. Horizontal bars represent amorphous phase by (1) interdiffusion
reaction and (2) by laser-quenching.

transition and supported using both calculated G/x curves and experimental meas-
urements of crystallisation enthalpies (Fig. 11.9).

11.2.4 Vapour deposition

The approaches described previously assume that reactions will be suppressed,
without giving any specific mechanism, and then rationalise the behaviour of the
Process using calculated metastable equilibria. A more innovative approach was
taken by Saunders (1984) and Saunders and Miodownik (1985, 1987) for the
prediction of phases formed by vapour co-deposition of alloys. It was postulated that
the formation of phases on the substrate is controlled by the diffusional breakdown
of fully intermixed depositing atoms so that three kinetic regimes are observed:

(i) At low substrate temperatures the surface mobility is insufficient for the nec-
essary diffusional movement to transform to multi-phase mixtures. The final
structure of the deposited film is, therefore, constrained to be single phase.

(ii) With increasing substrate temperature the decomposition to non-equilibrium
multi-phase mixtures is observed.

(iii) When the substrate temperature is high enough, the atomic mobility at the
surface is sufficient to allow the necessary atomic re-arrangements for the
formation of equilibrium phases.

 

References are listed on pp. 458-461.

===========
CALPHAD~A Comprehensive Guide 421

By using a simple kinetic model it was possible to predict the distance an atom could
move on the surface, d, and show that, when d<5 nm, a co-deposited alloy would be
constrained to be single-phase. It was further hypothesised that, as depositing atoms
lose their kinetic energy within a few atomic vibrations, any transformation in-
volving an intermediate high-temperature phase, whether liquid or solid, was
unlikely. As nucleation and growth processes are controlled by the substrate temp-
erature, the phase formed in the first kinetic regime should be the most thermo-
dynamically stable phase at the temperature of the substrate. G/x diagrams for a
number of alloys which had been vapour co-deposited were constructed and used to
validate the hypothesis. Figures 11.10-11.12 show a few such diagrams with the
structures observed during deposition superimposed.

 

reported supersaturation

G kJ/mol

 

 

 

0 10 20 30 40 50 60 70 80 90 100

Ni Ath Fe Fe
Figure 11.10, G/z curves for the Ni-Fe system at 100°C (Saunders and
Miodownik 1985).

 

 

ak
oF +------- _
‘ reported supersaturation
3s 2k sigma
£
3 °r N.B. no results reported
oak bcc, below 50 At% Fe
~a PNK _fee.
oh
---e a------
PF fee bee
-10

0 10 20 30 40 $0 60 70 80 90 100
Cr/Ni = 0.37 At% Fe Fe

Figure 11.11. G/z curves for the section Cr/Ni = 0.37 of the Fe-Ni-Cr system at
100°C (Saunders and Miodownik 1985).

===========
422 N. Saunders and A. P. Miodownik

KZ)

sigma phase
reported by
Yukawa et al. (1972)

G kJ/mol

predicted
sigma formation

 

0 10 20 30 40 50 60 70 80 90 100
Ni At% Cr Cr

Figure 11.12. G/z curves for the Ni-Cr system at 25°C (Saunders and
Miodownik 1985). Hashed box indicates phase observed in vapour-deposited
alloys (Yukawa et al. 1972) and dashed line predicted region of formation.

11.3. THE DIRECT COUPLING OF THERMODYNAMICS AND KINETICS

Historically, the main area of this type of modelling has been in steels and for con-
structing transformation diagrams (Kirkaldy et al. 1978, Bhadeshia 1982, Kirkaldy
and Venugopolan 1983, Enomoto 1992, Lee and Bhadeshia 1992). The models
have considered simple formalisms for describing the Gibbs energy of the solution
phases (Kirkaldy and Baganis 1978, Hasiguchi et al. 1984, Enomoto and Aaronson
1985, Sugden and Bhadeshia 1989) which have usually been austenite and ferrite,
and in the dilute solution range. The models have been shown to work well and
have been extensively used for low to medium alloyed steels. However, although
quite complex carbides can be included within the formalisms (Kroupa and Kirkaldy
1993) they are generally limited in their application to only small additions of
substitutional elements.

The use of more generally applicable concentrated solution models has, until
recently, been somewhat neglected. This has been mainly due to the increase in
computational time which is necessary to calculate equilibria with the more
complex models and, to a somewhat lesser extent, the lack of good assessments
using more generally applicable concentrated solution models. In recent years the
Thermo-Calc software programme (Sundman 1991) has been used to calculate the
necessary thermodynamic input for kinetic modelling and included in the DICTRA
software programme for simulation of diffusional reactions in multi-component

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 423

alloys (Agren 1992). This has led to a series of publications for a variety of material
types (Liu 1994, Engstrém et al. 1994, Du and Agren 1994) and has demonstrated
the advantage of producing a more generalised approach to phase transformations.

The direct coupling of thermodynamics and kinetics for predicting phase for-
mation in rapidly solidified (RS) alloys has proved a fruitful area of research. The
use of explicitly derived thermodynamic input parameters in standard kinetic
formalisms has shown that the entropy of fusion is one of the controlling features in
the liquid—solid transformation at these high cooling rates. This has led to
excellent predictions for the glass-forming ability (GFA) in metallic alloys
(Saunders and Miodownik 1986, 1988) and the prediction of solubility extension in
RS Al-alloy alloys as a function of cooling rate (Saunders and Tsakiropoulos 1988,
Pan et al. 1989, Saunders and Miodownik 1991). More complex work which
considers diffusional effects during growth has been undertaken by Jonsson and
Agren (1988) and Jénsson (1991).

At more conventional cooling rates the kinetic model proposed by Gulliver
(1922) and developed further by Scheil (1942) has been used with excellent success
for certain types of alloys. This formalism assumes that back diffusion in the solid
during solidification can be considered small enough to be neglected and this
process can be simulated by a simple modification of an equilibrium calculation.
Predictions for such solidification in Al-alloys can almost completely match
extensive and detailed experimental results (Backerud et al. 1990). Further, the use
of calculated fraction solid vs temperature curves and associated heat evolution
leads to superior simulations for the freezing behaviour of an LM25 alloy during
sand-casting (Spittle et al. 1995).

More complex formalisms have been used with excellent success, particularly
for steels where fast diffusion of C in the solid occurs. To account for this Yamada
and Matsumiya (1992), Mettinen et al. (1992) and Matsumiya et al. (1993) have all
included the effect of back diffusion in their modelling.

The next four sections will discuss some of the above work in detail. The first
two sections concem solid state transformations with section (11.3.1) concentrating
on steels while section (11.3.2) looks in more detail at the DICTRA programme.
The last two sections concern liquid—solid transformations. Section (11.3.3) deals
with conventional solidification while section (11.3.4) deals with rapid solidification.

11.3.1 Phase transformations in steels

This section will begin by looking at how thermodynamic and kinetic modelling
has been combined to understand time-temperature-transformation diagrams in
steels. The work, for the most part, is semi-empirical in nature, which is forced
upon the topic area by difficulties associated with the diffusional transformations,
particularly where nucleation aspects have to be considered. The approaches have
considered how best to predict the time/temperature conditions for austenite to

===========
424 N. Saunders and A. P. Miodownik

Ferrite

Temp

Time

Figure 11.13. Schematic TTT diagram for a low-alloy steel showing ferrite and
bainite formation.

transform to various products such as ferrite, pearlite, bainite and martensite. Figure
11.13 shows a simple schematic isothermal transformation diagram for a low-alloy
steel and is characterised by the appearance of two ‘noses’ and a bay. The ‘noses’,
or ‘C’ curves, correspond to (1) the diffusional transformation of austenite to ferrite
and/or pearlite and (2) displacive reactions concerned with the formation of
Widmanstatten ferrite and/or bainite. The bay corresponds to an area where there is
insufficient undercooling necessary to nucleate the displacive transformations while
there is insufficient diffusive movements to allow ferrite or pearlite to form.

11.3.1.1 The prediction of transformation diagrams after Kirkaldy et al. (1978). A
model for the calculation of ferrite and pearlite was first presented by Kirkaldy et
al. (1978) based on Zener-Hillert type expressions (Zener 1946, Hillert 1957). In
this first effort, no attempt was made to differentiate between the diffusive and
displacive transformations and a overall ‘C’ curve was produced of the type shown
schematically in Fig. 11.14. Kirkaldy et al. (1978) used the formalism below where
the general formula for the time (7) to transform z fraction of austenite at a temp-
erature T is given by

z
1 dz
8.0) = aaa aan | ag a re aa)
where a = 82(-)/2, @ is an empirical coefficient, G is the ASTMS grain size, AT
is the undercooling below the temperature where austenite is unstable with respect
to ferrite (the Aes temperature) and q is an exponent dependent on the effective
diffusion mechanism.

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 425

Ferrite

Temp

Bainite

Time
Figure 11.14, Schematic TTT diagram for a low-alloy steels showing ferrite and
bainite formation with ‘overall’ C curve behaviour assumed by Kirkaldy ef al.
(1978).

They also assumed that there was an effective diffusion coefficient (De) which
was dependent on a series resistance relationship (R) involving the alloying elements
such that

1 nm
Rear pa x el D'S Vas C; (11.2)

‘eff j=l
where a; is an constant for each element, j, C; is the concentration of the element,

Jj, and Qeé is an effective activation energy for diffusion. The modified formula is
given below

 

AT)-3
TrTT = os el Qea/ RT) Na Cj. (11.3)
T

=
The critical input parameters are then (1) the grain size, which should be known for
each case, (2) the Ae3 temperature which is calculated from thermodynamics, (3)
the effective diffusion activation energy, Qe, and (4) the empirical constants a, for
each element. Qeg and a; were determined by empirically fitting curves derived
using Eq. (11.12) to experimentally observed TTT curves, and the final formula for
calculating 7 was given as

2000/ RT
To% = 7 (60x%C + 90x%Si + 160x%Cr + 200x%Mo). (11.4)

xp
25/8( Aes

The above derivation means that, once the composition and grain size are provided,

===========
426 N. Saunders and A. P. Miodownik

only the Ae3 temperature needs to be calculated. This was done using dilute solu-
tion theory via Taylor expansions for the activity coefficients after Wagner (1951).
The limitations to dilute solution theory have been discussed earlier (Chapter 5) and
mean that, at best, the total level of alloy addition cannot rise much beyond a few
per cent. However, for the case of the hardenable steels of interest to Kirkaldy et al.
(1978) this limitation does not present any real problems, as total levels of C do not
tise above 0.7wt% and the total addition of the other alloying elements does not rise
above 2.75wt%. Some comparisons between calculated and observed TTT
diagrams are shown in Figs. 11.15((a)}(d)).

11.3.1.2 The prediction of transformation diagrams after Bhadeshia (1982). Later
work by Bhadeshia (1982) noted that the approach of Kirkaldy et al. (1978) could
not predict the appearance of the bay in the experimentally observed TTT diagrams
of many steels, and he proposed that the onset of transformation was governed by
nucleation. He considered that the time period before the onset of a detectable
amount of isothermal transformation, +, could be reasonably defined as the
incubation period, 7,, necessary to establish a steady-state nucleation rate. The
following expression for 7, was then utilised

Ts XK

T
(yD (11.5)
where D is an effective diffusion coefficient relating to boundary or volume
diffusion depending on the coherency state of the nucleus, G?, is the maximum
volume free-energy change accompanying the formation of a nucleus in a large
amount of matrix phase and p is an exponent dependent on the nature of the
nucleus. Taking a simple expression for the diffusion coefficient,

D « exp(S/R) exp(—Q/RT) (11.6)

where Q and S are respectively the activation enthalpy and entropy for diffusion,
assuming T = 7, and multiplying G¥, by the molar volume of ferrite, the following
expression was obtained

P,
Voge [or |= 240 (11.7)

where Q is the activation enthalpy for diffusion and C, is a constant. The critical
input parameters are then: (1) Gm, which is calculated from thermodynamics, (2)
the diffusion coefficient, Q, (3) the exponent p and (4) the constant C}.

Q, p and C; were then determined by empirically fitting curves, derived using
Eq. (11.7), to experimentally observed TTT curves. Unfortunately, although good
correlation coefficients were obtained during the fitting process, the results proved
insufficiently accurate to predict further TTT diagrams. However, it was observed

 

References are listed on pp. 458-461.

===========
°c
800

 

PREDICTED AE3 (790 °C)

°c
800

700

 

PREDICTED AE3 (761 °C)

 

 

 

 

 

 

 

 

 

600 ?
r
'
‘
500 ‘
400 ex PRED.
joiit tt 1
os 1 2 5 10 100 1000
°c
800 PREDICTED AE3 (772 °C)
700
600
500
400 EXP. PRED.
14 1 {tt jt 1
os 1 5s 10 100 1000 os 1 2 5 10 100 1000
TIME (SEC) TIME (SEC)

Figure 11.15. Comparison of predicted and experimental TTT start curves for steel types (a) 4135, (b) 5140, (c) 4050 and (d) 4135 from

Kirkaldy et al. (1978).

apinp aaisuayaaduoy ¥—GVHdT¥O

Lt

===========
428 N. Saunders and A. P. Miodownik

that the graph of log,(G,7/T) against 1/RT exhibited a systematic curvature
instead of being linear, as expected from the form of Eq. (11.7). Bhadeshia (1982)
noted that this would be consistent with a temperature dependence of the activation
enthalpy and entropy for diffusion and further manipulated Eqs (11.5) and (11.6) to
derive

(Gm)?r] _ Q'
log, [2227] =~ +0" .

loge | 7 mete (11.8)
where z, Q’ and C’ are constants. This yielded much improved results and the
following values for the constants and the exponent p were obtained which are

shown in Table 11.1 below.

Table 11.1, Parameters obtained by maximising the correlation coefficient Ry using Eq. (11.8)

Constant Correlation

Q'x 10% Constant coefficient

Jmol —C'x 107 R Exponent p Constant z  C' curve
0.2432 135 0.97428 5 20 Shear
0.6031 1.905 0.91165 4 20 Diffusional

Bhadeshia (1982) associated the two sets of parameters with (1) diffusional
transformations such as the formation of ferrite and (2) shear-related transforma-
tions such as bainite or Widmanstitten ferrite. Some additional conditions were made
concerning the upper temperature limit to the shear C' curve and the M, temperature
was calculated by a thermodynamic method (Bhadeshia 1981). The calculated TTT
diagrams were then compared with experiment for a wide number of alloys (Figs.
11.16(a)}-(d)) where there was good agreement, particularly with the more medium-
alloyed steels where total levels of substitutional elements could be as high as 5wt%.

Bhadeshia (1982) utilised dilute solution thermodynamics to obtain the critical
values of Gn for his calculations and also used the parallel tangent construction
method to predict the composition of the ferrite which would nucleate from aus-
tenite. The parallel tangent construction (Hillert 1953) defines the composition which
would have the maximum driving force to form a from + and is shown graphically in
Fig. 11.17, where Gm is the Gibbs energy to precipitate a with the maximum driving
force and G, is the Gibbs energy to form the equilibrium a and + phases with
compositions °2?, and ¢x?, respectively. It should be noted that Bhadeshia (1982) also
assumed that no partitioning of the substitutional elements was possible, i.e., the
transformation proceeded under conditions of para-equilibrium.

11.3.1.3 The prediction of transformation diagrams after Kirkaldy and
Venugopolan (1984). Kirkaldy and Venugopolan (1984) refined the work of
Kirkaldy et al. (1978) by considering that there should be C curves associated with

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 429

TEMPERATURE, °C

 

Figure 11.16. Comparison between calculated (~ - -) and experimental (— —)
TTT diagrams for steel types (a) En 36, (b) En 17, (c) En 24 and (4) En 23 from
Bhadeshia (1982).

 

eyo °
Xm Xe Xe

Y
Xe

Figure 11.17. Parallel tangent construction used to derive the maximum driving
force (Gm) to form a from a + alloy of composition 2°...

===========
430 N. Saunders and A. P. Miodownik

the three types of transformation, ferritic (F), pearlitic (P) and bainitic (B) and
modified the early equation of Kirkaldy et al. (1978), Eq. (11.4), so that three
curves could be calculated. Exponents for the equations where again found
empirically and the following expressions were produced:

_ 59.6%Mn + 1.45%Ni + 67.7%Cr + 24.4%Mo

2(6-0)/2(AT)* exp(—23500/RT) J (11.9)

a 1.79 + 5.42(%Cr + %Mo + 4%Mo x %Ni) 1

26-)/72(ATD (11-10)
where
1 1 4 .01%Or + 0.52%Mo aut)
D~ exp(—27,500/RT) '  exp(—37500/RT) .
and
i dz
I= | aoa (11.12)

0

The bainite reaction was treated in a slightly different way and an expression for 75
given as

_ (2.34 + 10.1%C + 3.8%Cr + 19%Mo) - 10-4
2G-1)/2(AT)? exp(—27500/RT)

where I’ is an empirical modification of I such that I’ > I to account for the slug-
gish bainite termination. It is then possible to account for the observed transfor-
mational effects; typical agreements are shown in Figs. 11.18(a}{b). A more
rigorous thermodynamic basis for the underlying thermodynamics was produced by
Hashiguchi et al. (1984) and this was later incorporated by Kroupa and Kirkaldy
(1993). Further refinements to the dilute solution method have been proposed by
Sugden and Bhadeshia (1989) and Enomoto (1985).

Lee and Bhadeshia (1992) have recently compared the models of Kirkaldy and
Venugopolan (1984) and Bhadeshia (1982) with experimental TIT diagrams of
various low- to medium-alloyed steels. They found that low-alloy steels were best
fitted using the Kirkaldy and Venugopolan model, while medium-alloy steels worked
best with the Bhadeshia model. They further attempted to refine both models but,
although some improvement was possible, they still performed best under different
alloy regimes and the inherent limitations in both models persisted. The main
limitation of the Kirkaldy and Venugopolan model was the underestimation of the
transformation time around the ‘bay’ region and the bainite finish time, while for

a (11.13)

 

References are listed on pp. 458-461.

===========
TEMPERATURE (°C)

TEMPERATURE (°C)

CALPHAD—A Comprehensive Guide

800

——— EXPERIMENTAL
—— CALCULATED

700

600

500

400

300
1 10 100

TIME (S)
(b)

—— EXPERIMENTAL
—— CALCULATED

800

700

600

500

400

300
1 10 100

TIME (S)

 

 

431

5140 STEEL

4037 STEEL

1000

Figure 11.18, Comparison between predicted and experimental TTT diagrams for
steel types (a) 5140 and (b) 8630 from Kirkaldy and Venugopolan (1983).

===========
432 N. Saunders and A. P. Miodownik
the Bhadeshia model it was only possible to calculate the transformation start time.

11.3.1.4 The prediction of transformation diagrams after Enomoto (1992).
Enomoto (1992) has recently developed a model for predicting the growth of pro-
eutectoid ferrite from austenite using an approach which considers the nucleation of
ferrite in a fashion similar to that of Bhadeshia (1982). In addition, capillarity
effects due to the volume change in transforming from austenite to ferrite are
considered and the change between the condition of para-equilibrium and local
equilibrium is taken into account. In the presence of capillarity the composition of
the nucleus, x’, in the temary system Fe-M-C was obtained by solving the
following equations:

 

 

Hie — He = Be = Bh = Be ~ BE Be (11.14)
7s Va ve .
‘e M Cc

Once the composition of the critical nucleus is found, the driving force for its
formation can be obtained using the equation:

=k DWH (11.15)
ras
For the case of para-equilibrium, where M is a substitutional atom, 21’ is calculated
from the equation

elt

Ve Vg
Where py = (ttre — Om)/(1+0) and V, = (Vee + 6Vm)/(1 +6) are, respec-
tively, the average chemical potential and partial molar volumes of Fe and M
atoms and @ = {,/z$,, where xf, and xf, are the bulk concentrations of Fe and M.
Local equilibrium is assumed to exist at the interface of the growth of ferrite which
is considered to be ‘momentarily stationary’. Under these conditions it is possible
to derive a position for a planar interface as

1-2 €— (Qn +1)?x?7
“Hi-e- Saar? =| an Quin)

   

 

(11.16)

n=0
where the solute supersaturation 2 = (27 — x°)/(x7 — 2°), € = S/d (where S is
the position of the interface at time t), 2d=the grain size and r = Dt/d?, where D
is the solute diffusivity. For a spherical particle Eq. (11.17) becomes
-2 8 nar
Wits = 1-59" Sep en|- "I. (11.18)

n=l

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 433

A critical part of the calculations is to calculate the tie-line at the interface corres-
ponding to local equilibrium, and Enomoto (1992) used the ‘central atoms’ model
to predict the thermodynamic properties of a and -y. Some assumptions were made
concerning the growth mode and the calculation of this tie-line is dependent on
whether growth occurred under the following alternative conditions:

(1) Local equilibrium, i.e., both the substitutional elements and carbon partition
between austenite and ferrite. This was called the PLE mode and was taken to
occur at high temperatures.

(2) Para-equilibrium, where only carbon partitions between austenite and ferrite
and the concentration of the substitutional elements Fe and Mn does not vary.
This was called the PARA mode and occurred at low temperatures.

(3) An intermediate mode between PLE and PARA modes was also taken to
occur. In this case only carbon partitions between austenite and ferrite, but
there is also a narrow diffusion spike of Fe and Mn at the vicinity of the inter-
face. This was called the NPLE mode.

The calculation of the composition of austenite and ferrite at the interface is
further modified by the diffusivity of the various elements and, using the above
approach, Enomoto (1992) was able to calculate TTT diagrams for a number of
Fe-Mn-C alloys and compare these with experiment (Figs. 11.19(a) and (b)).
Results were reasonable and the effect of assumptions concerning planar and
spherical growth on results were also discussed. More recently papers by Tanaka et
al, (1995a-c), Bourne et al. (1994) and Akbay et al. (1993) have sought to combine
thermodynamics and kinetics in a similar fashion, mainly in the area of growth or
dissolution of proeutectoid ferrite.

11.3.2 The DICTRA programme

Probably the most closely coupled thermodynamic and kinetic approach to phase
transformations has been undertaken in the development of the DICTRA
programme (Agren 1992). The philosophy has been to make a software programme
which can access Thermo-Calc and utilise a full range of thermodynamic models. It
is therefore more generalised and can be applied to a variety of material types. For
example, it is possible to deal with such diverse problems as the dissolution of
cementite in Fe-Cr—C alloys (Liu et al. 1991), the nitriding and nitrocarburizing of
Fe (Du and Agren 1994), the carburizing of Ni-based alloys (Engstrém et al. 1994),
the growth of o in Ni-based superalloys (Jénsson et al. 1993) and solidification
(Agren 1995).

The DICTRA programme is based on a numerical solution of multi-component
diffusion equations assuming that thermodynamic equilibrium is locally maintained
at phase interfaces. Essentially the programme is broken down into four modules
which involve: (1) the solution of the diffusion equations, (2) the calculation of

===========
434 N. Saunders and A. P. Miodownik

1000

Fe -0.11wt% C
=f

800

Temperature, °C
‘

600

 

 

500
0.1 1 10 100 1,000 10,000
Time, sec

800

   
  

A: Fe-0.12wt%C-3.08wt%Mn

750 B: Fe-0.37w1%C-3.14w1%Mn_

700

650

Temperature, °C

 

 

10° 104 105 10° 107 108
Time, sec

Figure 11.19. Comparison between predicted (——) and experimental
(C--) TTT curves for various steels (Enomoto 1992).

thermodynamic equilibrium (Thermo-Calc is called a sub-routine) (3) the solution
of flux-balance equations and (4) the displacement of phase interface positions and
adjustment of grid points.

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 435

A sample calculation for growth of a second phase in a matrix phase (i.e., the
growth of ferrite in austenite) would take the following procedure. The flux balance
equation at the moving phase interface is formulated as

v%ef — ue] = JP — Ji (11.19)

where c® and c/ are the concentrations of component i in the a and -y phases at the
phase interface, v® and v’ are interface migration rates and J, and Jj correspond
to the diffusional flux of component i in the a and ¥ phases either side of the phase
interface. The latter can be obtained from Fick’s law where

ace Oc}

= i =-p’
J? = -Dt as and J? Di = Oz" (11.20)
A frame of reference for the phase interface is then taken, either ‘number-fixed’
with respect to the number of moles of components, i, (Agren 1992) where

n

Yug= Sou =0 (11.21)

i=l i=1

or ‘volume-fixed’ which is defined in such a way that there is no net flow of volume
(Andersson et al. 1990)

Srueve = yew =0. (11.22)

i=] i=1

This leaves (n — 1) independent flux balance equations. The rate v can be found
straightforwardly for a binary system as the composition of a and + are fixed at any
temperature. In a ternary system there is a further degree of freedom as the number
of thermodynamically possible tie-lines between the a and phases is infinitely
large. However, each tie-line may be specified uniquely by the chemical potential
of one of the three components and thus there are only two unknowns and two
equations to solve. The above approach can be generalised for multi-component
systems and forms the platform for the DICTRA software package.

Examples of DICTRA usage for steels can be found in papers by Liu et al.
(1991) and Agren (1992). Liu et al. (1991) studied the dissolution of cementite in
Fe-2.06Cr-3.91C (at%) alloy and compared this to simulations using DICTRA.
They were able to simulate both the rate of dissolution (Fig. 11.20) and the
composition profiles of Cr in the sample as a function of time (Fig. 11.21) with a
high degree of accuracy. Agren (1992) reported on the construction of a CCT
diagram for grain boundary ferrite in a Fe-0.2C (wt%) alloy previously studied by
Jénsson (1991) (Fig. 11.22).

The advantage in using a software package such as DICTRA lies in its general
applicability. However, as the solution of the diffusion equations is performed

===========
436 N. Saunders and A. P. Miodownik

0.18
0.16
0.14
0.12
0.10
0.08
0.06
0.04
0.02
0
0.01 0.1. 1 10 100 1000 10000
Time (s)
Figure 11.20. Comparison between calculated (— —) and experimental (x)

volume fractions of cementite in a Fe-2.06Cr-3.91C (at%) alloy showing
dissolution of cementite as a function of time from Liu et al. (1991).

Volume Fraction

0.16
0.14
0.12
0.10
0.08
0.06
0.04
0.02

0
-1.0-0.5 0 0.5 1.0 1.5 2.0

Dist. From Interface, um

,

xy

Yor

2
2
o
&
oO
Oo

 

Figure 11.21. Comparison between calculated (— —) and measured
(symbols) Cr distribution in ferrite and cemtitie after annealing at 735°C in a
Fe-2.06Cr-3.91C (at%) alloy from Liu et al. (1991).

 

References are listed on pp. 458-461.

===========
CALPHsD—A Comprehensive Guide 437

1120

 

110

1100

1090

1080

1070

T(K)

1060

1050

1040

1030

 

Time (s)

Figure 11.22, Calculated CCT ¢.agram for grain-boundary ferrite in a Fe-0.2C
(wt%) alloy from Agren (1992).

rigorously, and complex thermodynamic modelling is used, there is a time penalty.
This means that, although one can consider quite complex alloys and precipitation
reactions involving a number of different phases, the computation time can become
high if the more complex type of commercial alloys are considered. However, it
should be stressed that problems associated with computational power will be
overcome as computer speeds increase and the development of such packages will
then present the user with a substantially more powerful platform on which phase
transformations can be simulated.

11.3.2.1 Diffusion couple problems. Using the same governing principles as
described in the previous section, the DICTRA package is also able to simulate
situations which, broadly speaking, lie in the realm of diffusion couples; for
example, coatings on Ni-based alloys (Engstrém and Agren 1996, Engstrém et al.
1997), carburization (Engstrém et al. 1994) and nitriding (Du and Agren 1994).
Instead of starting with a simple alloy, the finite element grid is separated into two
parts, one with a composition of the substrate and the other with the composition of
the coating. Resulting simulations have been very encouraging.

Engstrém et al. (1997) looked at diffusion couples in Ni-Cr—Al alloys and found
that extremely complex diffusion paths were possible, see for example (Figs.
11.23(a) and (b)). These seem strange, but they are all consistent with the observed

===========
438 N. Saunders and A. P. Miodownik

0.30 ()
“LO 7

Mole-fraction Al
©
8

MLN

0.10
0.60 0.70 0.80

Mole-fraction Ni

0.20

Mole-fraction Al

 

 

0.10
0.50 0.60 0.70
Mole-fraction Ni
Figure 11.23, Calculated diffusion paths for (a) 7/7 + 8 and (b) 7+ 6/7+8
diffusion couples in the Ni-Cr-Al system after 100 h at 1200°C (Engstrm et al.
1997).

behaviour of such alloys and can be understood using the ideas proposed by Morral
et al. (1996) concerning local equilibrium and the formation of three distinct boun-
dary types. Such studies were applied to the more complex situation of a NiCrAl
coating on a Ni-19Cr-1.5Al-14Co-4.3Mo-3Ti superalloy. Figure 11.24 shows the

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 439

0.40

°
3

Ni-22Cr-10AL Substrate
Coating

Mole-fraction of phase
2
8

2
S

 

 

Distance {meter}

Figure 11.24, Calculated mole fractions phases across the interface of a NiCrAl-
coated superalloy after 10 h at 1100°C. Dotted line shows the initial fraction of 8

 

 

 

in the coating.
25
cr
get \NN\N__]
—
3
3
So IS Co
5
5 Al
& 10
=
2 Ti
ZS osb Mo
0
-2 -1 0 1 2
E-4

Distance [meter]

Figure 11.25. Calculated composition profiles (wt%) for various elements across
the interface of a NiCrAl-coated superalloy after 10 h at 100°C.

predicted behaviour of the coating after 10 hrs at 1100°C while Fig. 11.25 shows
calculated composition profiles for the same conditions. It is interesting to note the
‘spiky’ appearance of the Cr plot in Fig. 11.25 around the original interface. This is
a real effect and can only be understood when it is realised that, although the

===========
440 N. Saunders and A. P. Miodownik

Ni-30Cr, 1000h
850°C, ast

© Quadakkers et al. (1987)

Overall Weight-Fraction of Carbon

 

0 2 4 6 8 10 12 14 16 18 20
Penetration depth [meter]
Figure 11.26, Comparison between calculated (——) and experimental ((9) total

C concentration (wt fraction) vs penetration depth for a Ni~30Cr (wt%) alloy after
carbonization at 850°C for 1000 h (Engstrim et al. 1994).

 

 

concentration of Cr can change in an abrupt fashion, its activity changes smoothly
through this region.

Carburization and nitriding have proved to be a promising field of application for
DICTRA. Engstrém et al. (1994) looked at carburization of Ni-~Cr and Ni-Cr-Fe
alloys and were able to accurately predict both the penetration of C into the alloys
of interest (Fig. 11.26) and the carbides formed during the process (Fig. 11.27). Du
and Agren (1994) performed similar studies for nitriding and carbo-nitriding of Fe.
Recently, Helander and Agren (1997) have simulated multi-component diffusion in
joints of dissimilar steels. They were able to successfully simulate features such as
C activity and its concentration profile (Fig. 11.28) and the formation of high levels
of Mz3Cg and M,C; carbides at the interface (Fig. 11.29).

11.3.3 Conventional solidification

In almost all practical cases, solidification during more traditional processing routes
such as investment casting, strip casting, etc., occurs in a non-equilibrium fashion,
giving rise to ‘cored’ castings with large variations in chemistry across the sample.
This leads to a number of problems. Some of these are associated with metastable
low-melting-point eutectics which can hinder solution heat treatments, which

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 441

Ni-30Cr, 1000h

850°C, a.=1

 

Mole-Fraction of Carbides

 

o 2 4 6 8 10, 12 4 16 18 20
Penetration depth [meter]
Figure 11.27. Calculated mole fraction of precipitated carbides vs penetration

depth for a Ni-30Cr (wt%) alloy after carbonization at 850°C for 1000h
(Engstrim et al. (1994),

 

3.0
725°C

? 2.5 ===) 700°C

2 sereees 650°C

& — -- 600°C

= 20

S

2

g

8

2 4s

g

3

3

$

= 10

a

s

>

3

0.5

   

° .
-10 0.8 0.6 0.4 0.2 Oo 0.2
Distance from interface (mm)
Figure 11.28, Calculated concentration profile for C in a diffusion couple

between two dissimilar steels at various temperatures. (From Helander and Agren
1997.)

===========
442 N. Saunders and A. P. Miodownik

1
t
1
1

Mole-fraction of carbides

 

0 0.02 0.04 0.06 0.08 0.10
Distance from interface (mm)

Figure 11.29. Calculated mole fraction of carbides in a diffusion couple between
two dissimilar steels at various temperatures. (From Helander and Agren 1997.)

themselves are designed to homogenise the ‘cored’ structure. Others are associated
with the formation of secondary phases which are detrimental to the mechanical
properties of the casting. Early classical treatments of non-equilibrium solidification
by Gulliver (1922), Scheil (1942) and Pfann (1952) have led to an equation for
predicting the amount of transformation in a binary alloy as a function of
temperature based on knowledge of the liquid/solid elemental partition coefficients.
It is instructive to briefly derive what has become known as the ‘Scheil equation’.

For solidification described by the lever rule and assuming linear liquidus and
solidus lines, the composition of the solid (C,) as a function of the fraction solid
transformed (f,) is given by the equation

=—_keo__
~ fi(k—-1) +1

where k is the partition coefficient and is constant during solidification, and Co is
the composition of the original liquid alloy. This can be re-arranged to give

eaGa)GS)

where T;, and Ty are the equilibrium liquidus and solidus temperatures. A

G (11.23)

 

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 443

complementary limiting case to equilibrium solidification is to assume that solute
diffusion in the solid phase is small enough to be considered negligible, and that
diffusion in the liquid is extremely fast, fast enough to assume that diffusion is
complete. In this case Eq. (11.23) can be rewritten as

 

Cy = kOo(1— fa)" (11.2)
and Eq. (11.24) as
-1-(%2T
fe=l # = nm): (11.26)

The treatment above is the traditional derivation of the Scheil equation. However, it
is not possible to derive this equation, using the same mathematical method, if the
partition coefficient, k, is dependent on temperature and/or composition. The Scheil
equation is applicable only to dendritic solidification and cannot, therefore, be applied
to eutectic-type alloys such Al-Si-based casting alloys, or even for alloys which may
be mainly dendritic in nature but contain some final eutectic product. Further, it
cannot be used to predict the formation of intermetallics during solidification.
Using a CALPHAD route all of the above disadvantages can be overcome. The
process that physically occurs during ‘Scheil’ solidification can be envisaged as
follows (Fig. 11.30). A liquid of composition Cp is cooled to a small amount below
its liquidus to 7;. It precipitates out solid with a composition C$ and the liquid
changes its composition to C/. However, on further cooling to T the initial solid
cannot change its composition owing to lack of back-diffusion and it is effectively

 

%Solute —

Figure 11.30. Schematic representation of solidification occurring under ‘Scheil’
conditions.

===========
444 N. Saunders and A. P. Miodownik

‘isolated’. A local equilibrium is then set up where the liquid of composition Cf
transforms to a liquid of composition C# and a solid with composition C$ which is
precipitated onto the original solid with composition C$. This process occurs again
on cooling to T; where the liquid of composition C} transforms to a liquid of com-
position Cl, and a solid with composition C$ grows on the existing solid. This
process occurs continuously during cooling and, when k < 1, leads to the solid
phase becoming lean in solute in the centre of the dendrite and the liquid becoming
more and more enriched in solute as solidification proceeds. Eventually, the com-
position of the liquid will reach the eutectic composition and final solidification will
occur via this reaction.

Any appearance of secondary phases can be easily taken into account in this
approach with the assumption that no back-diffusion is involved. Therefore all
transformations can be handled, including the final eutectic solidification. This
approach is based on a series of isothermal steps but, as the temperature step size
becomes small, it provides results which are almost completely equivalent to those
which would be obtained from continuous cooling.

The procedure described above is simple to model in a computer programme and
has a number of significant advantages: (1) The ‘Scheil equation’ is only applicable
to binary alloys and is not easily derived with multiple k values, which would be
necessary for a multi-component alloy. A calculation as described above can be
applied to an alloy with any number of elements. (2) The partition coefficients need
not be constant, which is a prerequisite of the ‘Scheil equation’. (3) The ‘Scheil
equation’ cannot take into account other phases which may form during such a
solidification process. This is handled straightforwardly by the above calculation
route.

11.3.3.1 Using the Scheil solidification model. Although it is realised that some
back-diffusion will occur, results on the calculation of solidification using the
Scheil simulation have proved to be successful in a number of cases. For Al-alloys
it appears to be particularly successful, allowing not only very accurate predictions
for fraction solid transformed (f,) as a function of temperature but also for predict-
ing the phases which appear during solidification, which in Al-alloys, is a complex
phenomenon.

Saunders (1997a) made extensive comparisons between predicted solidification
behaviour and the experimental work of Backerud et al. (1986) who examined
nearly 40 Al-alloys, encompassing all types ranging from the 1000 series through
the various casting alloys to 7000 series alloys such as AA7075. Their work
provides ‘fraction solid (f,)’ vs temperature curves for all alloys and detailed
information on the phases formed during solidification. All of the alloys studied by
Backerud et al. (1986) were modelled and results predicted for both fs vs
temperature and phase formation. Figure 11.31 shows comparisons for some of
these which encompass most of the major types of Al-alloys, ranging from the

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 445

 

 

 

 

   

 

 

 

 

 

700 700 700
‘AA1050 204.2 ‘AA3004
650' 650 650
600 600 600
350 $50 $50
500 500 500
450 450 450
0 02 04 06 0810 0 0.2 04 06 08 1.0 0 02 04 0.6 0.8 1.0
2
700 700 700
% 339.1 B390.1
a 650
w! 600
%
>
5 550
gi 500
=
z 450
0 0.2 04 06 0810 0 0.2 0.4 06 08 1.0 0 0.2 0.4 06 0.8 1.0
700 1 700
‘AASOOS 0 ‘AA6063 ‘AA7075
650 650
600 600
$50 550
500 500
aso-—L—_L_1__1 4s9-—_L_1_1_1 450
0 0.2 04 06 0810 0 02 04 06 081.0 0 0.2 0.4 06 08 1.0

FRACTION_SOLID

Figure 11.31. Fraction solid vs temperature plots for various Al-alloys calculated
under ‘Scheil’ conditions (Saunders 1997) with experimental results (C) of
Backerud et al. (1986) shown for comparison.

commercially pure grade AA1050, through the casting alloys such as the hypo-
eutectic type 356/LM25, a complex eutectic type 339.1 and a hyper-eutectic type
B390.1, to the wrought types such as AA3004, AA6063 and AA7075. The level of
accuracy achieved for these alloys is typical of that attained overall in the
comparison with Bakerud ef al. (1986), and excellent results were also obtained for
the phases formed during solidification.

Another case where the ‘Scheil’ simulation may work reasonably well is in
eutectic cast irons (Harding and Saunders 1997). While it is well known that C
diffusion in the solid is rapid and that the assumption of no diffusion during
solidification is incorrect, cast irons are unique in that graphite is involved for most

===========
446 N. Saunders and A. P. Miodownik

1200

1180

Equilibrium

1160

1140

1120

1100
1080

1060

TEMPERATURE_CELSIUS

1040

1020

 

1000
0 0.2 04 0.6 08 1.0

FRACTION_SOLID

Figure 11.32. Predicted equilibrium and ‘Scheil’ solidification of an LGI cast
iron (Harding and Saunders 1997, Saunders 19976).

of the solidification process. Therefore the concentration of C in austenite at the
liquid-solid interface remains fairly constant and little diffusion of C will actually
occur. Some questions may still be raised about the degree to which Si diffuses, but
predicted composition profiles in austenite appear consistent with those observed
experimentally (Jolley and Gilbert 1987).

Figure 11.32 shows a f, vs temperature plot for a lamellar grey cast iron and
compares this with that predicted for equilibrium solidification. While the behaviour
in both cases is similar up to about 70-80% of the transformation, the two curves
deviate sharply above this point as the liquid becomes increasingly enriched with
elements such as P, Mo and Cr. Final solidification (f, >0.97) involves both
cementite and FesP, both of which can be observed in interdendritic regions of cast
irons (Elliott 1988). Although the P level is only 0.05wt%, its formation is
consistent with experimental observations of interdendritic phosphide (Janowak
and Gundlack 1982). Figure 11.33 shows the solute profile in the liquid and the
behaviour of all elements is consistent with experimental observation, particularly
the sharp increase of Mo in the final interdendritic liquid. Both the Cr and Mn
decrease at the very end of transformation which is associated with the formation of
Fe3C in this last part of solidification.

Simulations for Ni-based superalloys have been carried out by Saunders (1995,
1996b), Chen et al. (1994) and Boettinger et al. (1995). Saunders (1995) used a
straightforward Scheil simulation to predict chemical partitioning and the for-
mation of interdendritic phases in a modified ‘single crystal’ U720 alloy containing

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 447

WT% ELEMENT IN LIQUID

 

FRACTION_SOLID

Figure 11.33, Predicted elemental partitioning to the liquid during ‘Scheil”

solidification of a lamellar grey cast iron (Harding and Saunders 1997, Saunders
1997).

 

no B or C. The simulation predicted that the interdendritic regions would contain
both y’ and Ni;Ti, and experimental results (Small 1993) indeed confirmed the
presence of both phases, showing that the Scheil simulation was able to produce
good results for liquid/solid partitioning.

Recent attempts at solidification modelling have been made for René N4 (Chen
et al. 1994) and IN718 (Boettinger et al. 1995) using a database collected from
early Kaufman work. The work on IN718 by Boettinger et al. (1995) is in reason-
able agreement with the known behaviour of this alloy, and the form of their
‘Scheil’ plot is similar to that predicted by Saunders (1996b), who also included B
and C in the calculation (Fig. 11.34). However, the results for René N4 suggested
that a ‘Scheil’ simulation for this alloy produced a freezing range greater than
observed in practice. To account for this apparent discrepancy a new type of
solidification mechanism was proposed and a modified ‘Scheil’ plot was produced.
However, it is noted that a straightforward ‘Scheil’ plot using a recently assessed
Ni-database (Saunders 1996b) gives a similar freezing range to the modified plot of
Chen et al. (1994). Clearly there is little need to resort to new, complex
solidification mechanisms in this particular case.

11.3.3.2 Modifying the Scheil solidification model. The ‘Scheil equation’ can be
modified to allow some back diffusion into the solid during a small isothermal
increment of solidification. The composition of the liquid is then modified to a new

===========
448 N. Saunders and A. P. Miodownik
1400
1350
1300

1250

1200

1150

1100

TEMPERATURE_CELSIUS

1050
1000
0 0.2 0.4 0.6 08 10
FRACTION_SOLID

Figure 11.34, Predicted equilibrium and ‘Scheil’ solidification of an IN718
superalloy.

value and this liquid then proceeds to the next isothermal step. Flux balance needs
to be maintained but, if k is kept constant, it is possible to derive a modification to
Eqs (11.21) and (11.22) (Brody and Flemings 1966) such that, for parabolic growth,

 

C, = kCo[1 — (1 — 20k) f,] 0-7 (11.27)
and
1 Ty — T\ 8-200
= ("3a f - Ea) aes)
where a is a function which takes into account solute back-diffusion given by
4D,t,
a= £ (11.29)

where Dg is the solute diffusivity, ty is the local solidification time and 2 is the
primary dendrite arm spacing. A number of different expressions have been
developed for a, notably by Clyne and Kurz (1981) and recently by Ohnaka (1986)
and Chen ef al. (1991).

By ensuring that correct flux balance is maintained, it is quite possible to modify
the liquid composition during a simulation and this has been successfully
implemented for Al-Li-based alloys by Chen et al. (1991) and by Yamada et al.
(1991), Yamada and Matsumiya (1992) and Matsumiya et al. (1993) for steels.

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 449

Chen et al. (1991) studied the solidification of two Al-Li-Cu alloys in an attempt
to predict f, vs temperature behaviour and the phases formed during solidification.
They modified the composition of the liquid in a fashion very similar to Brody and
Flemings (1966) but solved the diffusion equations within their programme. Their
results produced good predictions for the formation of the secondary phases for
both alloys and for f, of primary phase in one alloy (Al-Sat%Li—lat%Cu).
However, for a Al-9.9at%Li-7.5at%Cu alloy their predicted f, for the primary
phase was significantly different from that observed experimentally.

Yamada et al. (1991) and Yamada and Matsumiya (1992) tried a similar modi-
fication but with the composition of the liquid being modified according to Clyne
and Kurz (1981). In this case the concentration of the solute, i, in the liquid changes
by dC; given by the equation

(1 = fa)dCi + 204k fad; = Ci(1 — ki) dfs (11.30)

where k; is the partition coefficient of solute i between the liquid and solid, df, is
the increment of solid transformed and 1); is given by

Q§ = a : -e0(z)| ~jeo(Fa.) (11.31)

where a; is given by Eq. (11.29). Yamada et al. (1991) analysed a simple Fe-Ni-Cr
alloy to observe the effect of the diffusion parameter on the f, vs temperature plot
and this is shown in Fig. 11.35. In this case it is clear that the diffusion of Cr and Ni

1465
1460
1455
1450
1445

1440

\

(Clyne-kurz treatment)

1435 present model

Liquidus temperature (C)

1430

 

1425
0 0.2 0.4 0.6 0.8 10

Fraction solid

Figure 11.35. Comparison between various calculated modes of solidification in
‘an austenitic stainless steel from Yamada and Matsumiya (1992).

===========
450 N. Saunders and A. P. Miodownik

in 6-ferrite is significant and cannot be ignored. They then proceeded to look at the
inclusions which were likely to form during solidification, and the work was further
extended by Yamada and Matsumiya (1992).

11.3.3.3 More explicit methods of accounting for back-diffusion. It is also
possible to take into account the effects of back-diffusion by more explicitly
solving the diffusion equations during the solidification process. This requires that
the thermodynamic and kinetic parts of the transformation are solved simulta-
neously. One of the strengths of the DICTRA programme is that, in addition to
handling solid-state transformations, it can be applied to solidification. This has
been done for stainless steels (DICTRA 1996) and Ni-based superalloys (Saunders
1997b). Figure 11.36 shows solidification of a ‘single-crystal’ Ni-based superalloy
under three conditions: (1) equilibrium, (2) ‘Scheil’ and (3) taking into account
back-diffusion in the solid.

Meittinen et al. (1992) and Matsumiya et al. (1993) have also attempted to
explicitly solve the diffusion equations using a finite difference approach for the
diffusion of solute in the solid phase. Meittinen et al. (1992) used different
approaches dependent on whether the solute was fast-moving or slow-moving and
treated solidification involving 6-ferrite and austenite in different ways. This may
give reasonable answers for steels but the programme then loses general
applicability to other material types.

1350

1300

1280

1200

‘Scheil’

1150

TEMPERATURE_CELSIUS

 

1100
0 0.2 04 0.6 08 1.0

FRACTION_SOLID

Figure 11.36. Comparison of equilibrium and ‘Scheil’ solidificetion for an ‘ideal’
IN100 superalloy with DICTRA simulation for back-diffusion (Saunders 19976).

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 451

11.3.4 Rapid solidification

Rapid solidification (RS) requires different solutions concerning kinetic questions
than to conventional solidification. While solidification at conventional cooling
rates mainly concems itself with diffusion in the solid, and usually takes diffusion
in the liquid to be complete, the time scales involved in rapid solidification are so
small that diffusion in the solid state can effectively be ignored and the main
questions concerning diffusivity lie within the liquid. Also, a number of phenomena
such as glass formation and extension of solid solubility limits have been treated by
modelling nucleation effects as well as those involving growth.

One of the earliest attempts to explicitly combine thermodynamics and kinetics
in rapid solidification was by Saunders ef al. (1985). They examined the equations
derived by Davies (1976) and Uhlmann (1972) for predicting TTT diagrams. These
were based on Johnson-Meh!-Avrami kinetics for predicting glass formation
during rapid solidification where the ruling equation could be given as

. 1/4
tw 237 (eee) (11.32)

EP \ [1 exp(—Gn/ RT)

where ¢ is the time taken to transform 10~° volume fraction of crystalline phase (the
limiting case for glass formation), 7 the viscosity of the liquid, K is an alloy-
dependent constant, G* the activation energy for nucleation and G,, the Gibbs
energy of the liquid-crystal transformation.

The three most important factors in the equation are the viscosity and the
thermodynamic parameters G* and G,,. The viscosity can be approximated
between the liquidus temperature, Tjjq, and the liquid—glass transition temperature,
T;,, by a Doolittle expression involving the relative free volume (Ramachandrarao
et al. 1977) while G* can be calculated using the relationship

Ga ™ (2) (11.33)

where oy, is the liquid/crystal interfacial energy which can in turn be related to the
molar heat of fusion, H/,, such that

Om = A+ HE (11.34)

where A is 0.3-0.45 (Turnbull 1950). G,, and Hf, are calculated directly from
thermodynamic modelling.

Equation (11.32) is largely controlled by 7 and G*. 7 is strongly controlled by the
value of T, and alloys with high values of Tiiq/T, are generally better glass formers
than those where Tiiq/T, is low. This is in accord with the finding that the best
glass-forming alloys occur at low-melting-point eutectics. The value of G* is also a

===========
452 N. Saunders and A. P. Miodownik

powerful factor and most previous treatments had assumed it was constant for all
types of liquid—solid transformations. Saunders et al. (1985), however, were able
to show that G* could vary markedly both between various alloy systems and
between various competing phases in the same alloy system. This was first demon-
strated in the Ti-Be system (Saunders et al. 1985) where the metastable compound,
TiBe, controls the ability of Ti-Be alloys to form glasses. This was successfully
modelled (Fig. 11.37(a) and (b)) and the method was further applied to the Au-Si
and Ag~Si systems (Kambli et al. 1985) where GFA was also controlled by phases
not observed in the stable phase diagram (Figs. 11.38 (a) and (b)).

temperature (°C)

 

200
0 10 20 30 40 So 60 70 80 90 100
Ti At% Be Be

temperature (°C)

 

log time (secs)

Figure 11.37. (a) Calculated phase diagram for Ti-Be showing liquidus for the
metastable compound TiBe and (b) calculated TTT curves for the precipitation of
TiBe and TiBe, from a liquid Ti-40Be (at%) alloy (Saunders et al. 1985).

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 453

(a)
LoGi0
4

log Re (K sec”)

log Re (K sec")

 

o ft 2 3 4 $ 6 7 8 9 10
mole Fraction Si x10"

Figure 11.38. Calculated critical cooling rates for suppression of various phases
in (a) Ag-Si and (b) Au-Si from Kambli et al. (1985). Horizontal bars indicate
experimental glass-forming range by laser quenching.

===========
454 N. Saunders and A. P. Miodownik

Such effects are largely controlled by the entropy of fusion, Sf. A simple
derivation of Eqs (11.29) and (11.30) shows that

 

Gs,
wan * (11.35)

where AT, = (Tiiq—T), Tr = T'/Tiiq and K' is a geometric constant based on the
shape of the nucleus. Therefore, phases which have a high entropy of fusion will be
more difficult to form than those with low entropies of fusion. This can perhaps be
best understood by the fact that the work needed to form the interface relates back
to the entropy of fusion. As the entropy of fusion increases the work necessary to
create the interface will become larger, hence the activation barrier to nucleation
increases, The approach culminated in a paper where the glass-forming ability of
nearly 20 binary and ternary systems was predicted with excellent results (Saunders
and Miodownik 1988). Figure 11.39(a}(d) show results from some of the binary
systems and Fig. 11.40 for the Ti-Zr-B ternary systems. A great strength of the
combined thermodynamic and kinetic model is that once an alloy system has been
thermodynamically characterised, the only additional input parameter for the
software programme is the value of T;.

A nucleation approach was also applied to predicting the extension of solid
solubility obtained in Al-alloys by rapid solidification. In this case the competition
for forming either the supersaturated Al solid solution or the equilibrium compound
was taken to be nucleation controlled (Saunders and Tsakiropoulos 1988). The
model was first applied to high-pressure gas-atomised (HPGA) Al-Cr and Al-Zr
alloys and was immediately able to predict a number of important general effects,
all of which are consistent with experimental observation.

(1) The necessary undercooling for the formation of compounds is far larger
than those for the supersaturated Al phase, undercooling being defined as
(Tiiq — Terit,a), Where Terit,a is the critical nucleation temperature of the phase
in question.

(2) The formation of supersaturated Al is favoured by decreasing powder size/
increasing cooling rate and the composition at which the intermetallic phases
become rate limiting is shifted to higher concentrations of solute with
decreasing powder size/increasing cooling rate.

(3) As had been found in the glass-forming systems, the predicted undercoolings
for compounds could vary markedly both between various types alloy systems
and between various competing phases in the same alloy system.

Predominant nucleation maps could then be constructed (Figs. 11.41(a) and (b))
which show how the Al solution phase is extended as a function of composition and
powder size. Pan et al. (1989) improved the model and the approach was further
applied by Saunders and Miodownik (1991) to a wide range of Al binary and

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 455

 

 

 

 

 

 

 

 

 

 

2000 2000
o 1800 Co 1800 xe
& 1600 & 1600 --\cac3
2 2
EB 1400 gs 1400
3 3
3 1200 3 1200
é E
é 1000 £ 1000
800 800 FF ———|
600 600
0 10 20 30 40 50 60 70 80 90 100 0 10 20 30 40 50 60 70 80 90 100
Pd At% Si Si Zr At% Be Be
b d
2000 1600
g 1800 S 1400
& 1600 Y
g 2
3 1400 5 1200
§ 1200 5
g) 1000
2B &
§ 1000 § LE
* on Lo Fa
00 600 Lit
0 10 20 30 40 50 60 70 80 90 100 0 10 20 30
cu At% Zr Zr Pd At% P
z k
Figure 11.39. Comparison between calculated (C3) glass-forming ranges at
~10" K sec’ and observed (1m) glass-forming ranges at melt spin cooling rates for
(a) Pd-Si, (b) Zr-Be, (c) Cu-Zr and (d) Pd-P (Saunders and Miodownik 1988).
Ti Z Ti ar

Figure 11.40. (a) Calculated critical cooling rates for glass formation in Ti-Zr-Be
(Saunders and Miodownik 1988) and (b) observed glass-forming range (Saunders
et al, 1988).

===========
456 N. Saunders and A. P. Miodownik

3
8

diameter (um)

10

diameter (um)

 

0 1.0 20 3.0 40 5.0
at%Cr

Figure 11.41. Predominant nucleation maps for (a) Al-Zr and (b) AILCr high-
pressure gas-atomised powders (Saunders and Tsakiropoulos 1988).

ternary alloys with excellent success. Later work (Shao and Tsakiropoulos 1994)
examined the effect of transient nucleation effects in Al-Cr and AI-Ti alloys.

A more complex approach to rapid solidification was undertaken by Jonsson
(1990) to take into account the growth effects which govern important features of the
final RS alloy such as morphology, microsegregation, coupled growth structures, etc.
Firstly, the heat-flow characteristics of the RS technique were modelled to define the
temperature conditions felt by the undercooled liquid. A nucleation expression
similar to Eq. (11.33) was then used, taking into account more specifically the
effects of heterogeneous nucleation. Growth was then modelled considering solute

 

References are listed on pp. 458-461.

===========
CALPHAD—A Comprehensive Guide 457

diffusivity in the liquid and ‘solute drag’ effects (Agren 1989), The solute-drag
model considers the deviation from local equilibrium condition such that

G} = Gi + (AG; + AG, + Ani?) (11.36)

where G! and G} are the ordinary chemical potentials of component i in the liquid
and solid next to the phase interface, AG; and AG, are the deviations from local
equilibrium due to the finite interface kinetics and the Gibbs-Thompson effect
respectively and Ay‘ is the deviation due to the solute drag effect of component i.
AG; is given by

v
AG; = —RTIn( 1-— 11.37,
f n( 2) (11.37)

where v is the interface velocity, vp is a kinetic parameter of the order of the speed
of sound and AG, is given by

1 1
AG, = o(> +3) Vn (11.38)

where o is the surface tension and p; and pp are the principal radii of the interface
curvature. To determine Ay‘ further limiting conditions have to be made, such as
the assumption that growth is steady state and that there is proportionality between
the diffusive flux at the liquid side of the interface and the difference in diffusion
potential acting over the interface. The following equation can be derived for a
binary system A-B (Agren 1989):
-L

°= ope (Quit — Api) (11.39)

where x“/* and x*/ are the interfacial concentrations of B in the liquid and the
solid phases respectively. L can be estimated from the equation

— Di (, _ t)\ b/s
Lae (i z )z' (11.40)

where Dj; is the trans-interphase diffusivity and 6 is the width of the interphase.
There are further equations which interrelate the various parameters and these can
then be used to define a system of non-linear equations which can be solved and
allow the calculation of the crystal growth rate. From this it is possible to account
for a transition between partitionless massive growth and partitioned growth, using
a Cu-13%Ag alloy as an example.

The two growth regimes are associated with correspondingly distinct rates of
latent heat evolution and, at some critical heat extraction rate, an interesting oscil-
lation between the two growth types is predicted to occur. At sufficiently high

===========
458 N. Saunders and A. P. Miodownik

undercoolings, i.e., at high heat extraction rates, nucleation occurs below the
temperature where partitionless growth is favoured. Growth is then rapid, which
gives rise to sufficient recalescence to bring its temperature back above the
temperature where partitioned growth occurs. The rate of latent heat evolution then
slows down and the heat extraction rate is sufficient so that the temperature begins
to drop again and at some point falls below the critical temperature for partitionless
transformation. The cycle can then begin again and a banded microstructure is
predicted to occur. Such an effect was found to be consistent with microstructures
observed experimentally by Boettinger ef al. (1984).

REFERENCES

Agren, J. (1989) Acta Met., 37, 181.

Agren, J. (1992) ISU International, 32, 291.

Agren, J. (1995), unpublished research.

Akbay, T., Reed, R. and Enomoto, M. (1993) in Computer Aided Innovation of New
Materials: Vol. 1, eds Doyama, M et al. (Elsevier Science, Amsterdam), p. 771.

Andersson, J.-O., Héglund, L., Jonsson, B. and Agren, J. (1990) in Fundamentals and
Applications of Ternary Diffusion, ed. Purdy, G. R. (Pergamon Press, New York), p. 153.

Ansara, I. (1979) Int. Met. Reviews, 22, 1.

Backerud, L., Krol, E. and Tamminen, J, (1986) Solidification Characteristics of Aluminium
Alloys: Vols, 1 and 2 (Tangen Trykk A/S, Oslo).

Betteridge, W. and Heslop, J. (1974) in The NIMONIC Alloys and Other Ni-Based High
Temperature Alloys: 2nd Edition (Edward Amold Ltd, London).

Bhadeshia, H. K. D. H. (1981) Met. Sci., 15, 175.

Bhadeshia, H. K. D. H. (1982) Met. Sci., 16, 159.

Blatter, A. and von Allmen, M. (1985) Phys. Rev. Lett., $4, 2103.

Blatter, A. and von Allmen, M. (1988) Mat. Sci. Eng., 97, 93.

Blatter, A., von Allmen, M. and Baltzer, N. (1987) J. Appl. Phys., 62, 276.

Boettinger, W. J., Shechtman, D., Schaefer, R. J. and Biancaniello, F. S. (1984) Met. Trans.
A, 15, 55.

Boettinger, W. J., Kattner, U. R., Coriell, S. R., Chang, Y. A. and Mueller, B. A. (1995) in
Modeling of Casting, Welding and Advanced Solidification Processes, VII, eds Cross, M.
and Campbell, J. (TMS, Warrendale. PA), p. 649.

Bormann, R. (1993) Mat. Sci. Eng., A179/A180, 31.

Bormann, R. and Biisch, R. (1990) J. Non-Crystal. Solids, 117-118, 539.

Bormann, R., Gartner, F, and Haider, F. (1988) Mat. Sci. Eng., 97, 79.

Bourne, J. P., Atkinson, C. and Reed, R. C. (1994) Met. Mater. Trans. A, 24A, 2683.

Brody, H. D, and Flemings, M. C. (1966) Trans. Met. Soc. AIME, 236, 615.

Chen, S.-L., Oldfield, W., Chang, Y. A. and Thomas, M. K. (1994) Met. Mater. Trans. A,
25A, 1525.

Chen, S.-W., Chuang, Y.-Y., Chang, Y. A. and Chu, M. G. (1991) Met. Trans. A, 22A, 2837.

Clyne, T. W. and Kurz, W. (1981) Met. Trans. A, 12A, 965.

Davies, H. A. (1976) Phys. Chem. Glasses, 17, 159.

===========
CALPHAD—A Comprehensive Guide 459

DICTRA (1996) in DICTRA Examples Manual: Ver. 18 (Div. Physical Metallurgy, Dept.
Mater. Sci. Eng., Royal Institute of Technology, S-100 44 Stockholm, Sweden, February),
Examples b4a-b4c.

Du, H. and Agren, J. (1994) Trita-Mac 0570, Report, Royal Institute of Technology, S-100
44 Stockholm, Sweden.

Elliott, R. (1988) in Cast Iron Technology (Butterworths, London).

Engstrém, A. and Agren, J, (1996) to be published in Defect and Diffusion Forum.

Engstrom, A., Héglund, L. and Agren, J. (1994) Met. Mater. Trans. A, 25A, 1127.

Engstrom, A., Morral, J. E. and Agren, J. (1997) Acta Mater., 45, 1189.

Enomoto, M. and Aaronson, H. I. (1985) CALPHAD, 9, 43.

Enomoto, M. (1992) JSIJ International, 32, 297.

Gfeller, J., Blatter, A. and Kambli, U. (1988) J. Less Common Metals, 145, 105.

Gulliver, G. M. (1922) Metallic Alloys (Griffen, London).

Gustafson, P. (1985) Scand. J. Metallurgy, 14, 259,

Harding, R. and Saunders, N. (1997) to be published in Trans. American Foundrymen’s
Society.

Hashiguchi, K., Kirkaldy, J. S., Fukuzumi, T. and Pavaskar, V. (1984) CALPHAD, 8, 173.

Helander, T. and Agren, J. (1997) Met. Mater. Trans. A, 28A, 303.

Hillert, M. (1953) Acta Met., 1, 764.

Hillert, M. (1957) Jerkontorets Ann., 141, 758.

Janowak, J. F. and Gundlach, R. B. (1982) Trans. American Foundrymen’s Society, 90, 847.

Johnson, W. L. (1986) Progr. Mater. Sci., 30, 81.

Jolley, G. and Gilbert, G. N. J. (1987) The British Foundryman, March vol., 79.

Jénsson, B. (1990) ‘Thermodynamics and kinetics of rapid solidification’, Ph.D. Thesis,
The Royal Institute of Technology, Stockholm, Sweden.

Jénsson, B. (1991) Met. Trans. A, 22A, 2475.

Jonsson, B. and Agren, J. (1988) J. Less Common Metals, 145, 153.

Jonsson, B., Agren, J. and Saunders, N. (1993) unpublished research.

Kambli, U., Von Allmen, M., Saunders, N. and Miodownik, A. P. (1985) Appl. Phys. A, 36,
189,

Kirkaldy, J. S. and Baganis, E. A. (1978b) Met. Trans., 9, 495.

Kirkaldy, J. S. and Venugopolan, D. (1984) in Phase Transformations in Ferrous Alloys, eds
Marder, A. R. and Goldstein, J. I. (AIME, Warrendale), p. 125.

Kirkaldy, J. S., Thomson, B. A. and Baganis, E. A. (1978) in Hardenability Concepts with
Applications to Steel, eds Kirkaldy, J. S. and Doane, D, V. (AIME, Warrendale), p. 82.

Koch, C. C., Cavin, O. B., McKamey, C. G. and Scarbrough, J. O. (1983) Appl. Phys. Lett.,
43, 1017.

Kroupa, A. and Kirkaldy, J. S. (1993) J. Phase Equilibria, 14, 150.

Lee, J.-L. and Bhadeshia, H. K. D. H. (1992) China Steel Report, 6, 19.

Liu, Z.-K. (1994) in Solid—+Solid Phase Transformations, eds Johnson, W. C., Howe, J. M.,
Laughlin, D. E. and Soffa, W. A. (TMS, Warrendale), p. 39.

Liu, Z.-K., Hoglund, L., Jénsson, B, and Agren, J. (1991), Met. Trans, A, 22A, 1745.

Matsumiya, T., Yamada, W. and Koseki, T. (1993) in Computer Aided Innovation of New
Materials II, eds Doyama, M. et al. (Elsevier Science, Amsterdam), p. 1723.

Miettinen, J. (1992) Met. Trans. A, 23A, 1155.

Miedema, A. R (1976) Phillips Tech. Rev., 36, 217.

===========
460 N. Saunders and A. P. Miodownik

Morral, J. E., Jin, C., Engstrém, A. and Agren, J. (1996) Scripta Metall., 34, 12.

Oehring, M. and Bormann, R. (1991) Mat. Sci. Eng. A, A134, 1330.

Ohnaka, I. (1986) Trans. Iron Steel Inst. Japan, 26, 1045.

Pampus, K., Bettiger, J., Torp, B., Schroder, H. and Samwer, K. (1987) Phys. Rev. B, 35,
7010.

Pan, L.-M., Saunders, N. and Tsakiropoulos, P. (1989) 5, 609.

Pfann, W. G. (1942) Trans. AIME, 194, 70.

Polk, D. E., Calka, A. and Giessen, B. C. (1978) Acta Met., 26, 1097.

Ramachandrarao, P., Cantor, B. and Cahn, R. W. (1977) J. Mat. Sci., 12, 2488.

Samwer, K., Schroder, H. and Pampus, K. (1988) Mat. Sci. Eng., 97, 63.

Saunders, N. (1984) Ph.D. Thesis, University of Surrey, Guildford, UK.

Saunders, N. (1995) Phil. Trans. A, 351, 543.

Saunders, N. (1996a) in Titanium '95: Science and Technology, eds Blenkinsop, P. et al.
(Inst. Materials, London), p. 2167.

Saunders, N. (1996b) in Superalloys 1996, eds Kissinger, R. D. et al. (TMS, Warrendale,
PA), p. 101.

Saunders, N. (1997a) in Light Metals 1997, ed. Hugten, R. (TMS, Warrendale, PA), p. 911.

Saunders, N. (1997b) in ‘‘Solidification Processing 1997'’ eds Beech, J. and Jones, H.
(University of Sheffield, Sheffield, UK), p. 362.

Saunders, N. and Miodownik, A. P. (1983) Ber. Bunsenges. Phys. Chem., 87, 830.

Saunders, N. and Miodownik, A. P. (1985) CALPHAD, 9, 283.

Saunders, N. and Miodownik, A. P. (1986) J. Mater. Res., 1, 38.

Saunders, N. and Miodownik, A, P. (1987) J. Mater. Sci., 22, 629.

Saunders, N. and Miodownik, A. P. (1988) Mater. Sci. Tech., 4, 768.

Saunders, N. and Miodownik, A. P. (1991) in High Temperature-Low Density Powder
Metallurgy, eds Frazier, W. E., Koczak, M. J. and Lee, P. W. (ASM, Materials Park, OH),
p. 3.

Saunders, N. and Tsakiropoulos, P. (1988) Mat. Sci. Tech., 4, 157.

Saunders, N., Miodownik, A. P. and Tanner, L. E. (1985) in Rapidly Quenched Metals, eds
Steeb, S. and Warlimont, H. (Elsevier Science, Amsterdam, 1985), p. 191.

Scheil, E. (1942) Z. Metallkde., 34, 70.

Schwarz, R. B. (1988) Mat. Sci. Eng., 97, 71.

Schwarz, R. B. and Johnson, W. L. (1983) Phys. Rev. Lett., 51, 415.

Shao, G. and Tsakiropoulos, P. (1994) Acta Met. Mater., 42, 2937.

‘Small, C. (1993) private communication. Rolls-Royce plc, Derby, UK.

Spittle, J. A., Brown, S. G. R. and Al Meshhedani, M. (1995) presented at the 9th Int. Conf.
on Numerical Methods in Thermal Problems, Atlanta, USA, July 1995.

Sugden, A. A. B. and Bhadeshia, H. K. D. B. (1989) Mat. Sci. Tech., 5, 977.

Sundman, B. (1991) in User Aspects of Phase Diagrams, ed. Hayes, F. H. (Inst. Metals,
London), p. 130.

Tanaka, T., Aaronson, H. I. and Enomoto, M. (1995a) Met. Mater. Trans. A, 26A, 535.

Tanaka, T., Aaronson, H. I. and Enomoto, M. (1995b) Met. Mater. Trans. A, 26A, 547.

Tanaka, T., Aaronson, H. I. and Enomoto, M. (1995c) Met. Mater. Trans. A, 26A, 560.

Tumbull, D. (1950) J. Appl. Phys., 21, 1022.

Uhlmann, D. R. (1972) J. Non-Cryst. Sol., 7, 337.

Wagner, C. (1951) in Thermodynamics of Alloys (Addison Wesley, Reading, Mass), p. 51.

===========
CALPHAD—A Comprehensive Guide 46)

Yamada, W. and Matsumiya, T. (1992) Nippon Steel Tech. Rpt. No. 52, January 1992, p. 31.

Yamada, W., Matsumiya, T. and Sundman, B. (1991) in Computer Aided Innovation of New
Materials, eds Doyama, M., et al. (Elsevier Science, Amsterdam), p. 587.

Yukawa, N., Hida, M., Imura, T., Kawamura, K. and Mizuno, Y. (1972) Met. Trans., 3, 887.

Zener, C. (1946) Trans. AIME, 167, 550.
