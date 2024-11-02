Chapter 12
Future Developments

As summarised at the end of Chapter 2, CALPHAD has come of age. Complex
phase equilibria calculations can be performed as a routine operation and, as a
subject area, it is now at a watershed. In terms of thermodynamic modelling, many
current ideas are based on concepts which are actually quite old, e.g. the sub-lattice
model, the quasi-chemical model and the cluster variation method. Although there
have been clear advances in programming, the current Gibbs energy minimisation
packages utilise code whose main principles remain firmly based on historical
mathematical concepts. Major advances in these areas are therefore unlikely to be
achieved by modifications to existing models and software. It is more likely that
CALPHAD will be invigorated in the new millennium by an expansion of
CALPHAD methods into new fields and the discovery of vital new concepts.

As far as new applications are concerned, the existence of validated multi-
component databases means that their output can, effectively, be considered as
equivalent to adding further experimental data into larger projects. This will lead to
application in wider areas of materials production and processing. Input into the
field of materials design will also expand. For example, recent work by Olson
(1997) shows how a traditional CALPHAD approach can be integrated into a
modern systems approach, incorporating a variety of numerical treatments for
materials properties, in order to design better ultra-high strength steels.

However, it is clear that, if the CALPHAD methodology is to be applied to
materials with new combinations of components and where sound validated
databases do not exist, its predictive capability must be extended. Otherwise, its
future application will always have a significant, and potentially unacceptable, time
lag associated with building up the necessary binary and ternary assessments. This
emphasises the need to incorporate more results from First Principles Calculations
into CALPHAD software programmes. The difficulties in achieving this should not
be underestimated. However, if one looks back at the history of the subject area it is
unlikely that the early researchers would have predicted that phase equilibria in
highly complex multi-component materials could be estimated so accurately (and
so quickly) as is currently possible. The advantages would be not only a better
estimation of unknown thermodynamic parameters but, also, the associated genera-
tion of many other physical properties which are required in more comprehensive
approaches to the design of new materials. This is a challenging project but the
rewards will be proportionately great.

463

===========
464 N. Saunders and A. P, Miodownik

At present electron energy codes relate to relatively small arrays of atoms with
fixed atomic placement in crystallographically distinct configurations. At the other
end of the structural spectrum, better methods must be found which can look at
random atomic placements on both crystallographically distinct and indistinct
arrays. Amongst the major stumbling blocks to incorporating ab-initio methods into
CALPHAD software is the current lack of any reliable treatment of the liquid
phase, and the inability to properly account for the effect of temperature on the
Gibbs energy. If such features cannot be included in the future, ab-initio approaches
will remain of interest only as a source of data for ground state configurations and
will not be capable of being directly used for high temperature phase equilibria.

Fundamentally based ordering models which consider short-range ordering
phenomena are rarely incorporated in CALPHAD software, and this is another area
which the authors would like to see expanded. However, before this can be done in
a general fashion, it is clear that ordering models need to be made more flexible,
while retaining a sound physical basis, and that vibrational entropy as well as
complex compositional effects must be included.

In order to achieve these goals, the speed of calculation must be substantially
increased. However, one has only to look at the huge leaps which have occurred in
computing power over the last 10-15 years to appreciate that new theoretical
foundations should be put in place now, in order to take advantage of any new
advances in computing which will undoubtedly occur in the future. Codes based on
principles of molecular dynamics have not been explored in any depth by the
CALPHAD community; so perhaps it is also time to see what this subject area can
offer.

In terms of more conventional modelling it is surprising to find that there is still
incompatibility between databases that handle complex metallic materials and
slags. Sound databases exist for both separately but as yet there is no major
integrated database that can handle the very important area of overlap. In terms of a
total materials modelling capability it is clearly of benefit to have one self-
consistent database rather than a series of separate ones to span a greater range of
applications.

The trend to directly incorporate codes for Gibbs energy minimisation into
software packages which deal with kinetic and/or process modelling is certain to be
a growth area. The DICTRA programme (Agren 1992) marked one of the first
attempts to incorporate a fully functional, generalised minimisation code into a
software package which solved a series of complex diffusional equations. The
advantages of such treatments are only just being appreciated by industry and the
concept of extending such calculations still further to include the mobility of charge
carriers in semiconductors and opto-electronic materials (Anderson 1997) is an
exciting possibility. However, progress is being held back by the lack of an
extensive database for such mobilities. The direct inclusion of CALPHAD software
into codes that deal with process modelling has begun and Thermo-Calc and

References are listed on p. 465

===========
CALPHAD—A Comprehensive Guide 465

ChemSage have developed a common interface with the direct aim of enabling
such applications (Eriksson et al. 1994). Recently, the PMLFKT code, developed
for the Lukas programmes (Lukas ef al. 1982) and extended by Kattner et al.
(1996), has been directly coupled with the complex finite element package
ProCAST (Samonds and Waite 1993) to predict heat evolution and solidification
paths during casting (Bannerjee et al. 1997).

The forthcoming years will offer a great deal of excitement if the CALPHAD
method is extended and infused with new ideas and directions. For our part, we
would like to see efforts continue which place CALPHAD on the soundest possible
physical basis so that the semi-empirical nature of the subject area can be reduced.
This, alongside the exciting new areas of application which are continually appear-
ing, promises to provide the necessary scientific stimulus to keep alive the long
pioneering tradition of the early workers in this field.

REFERENCES

Agren, J. (1992) ISL International, 32, 291.

Anderson, T. (1997) private communication at 1997 Ringberg III Workshop, Schloss
Ringberg, Bavaria, Nov. 30-Dec. 5.

Bannerjee, D. K., Kattner, U. and Boettinger, W. (1997) Solidification Processing 1997, eds
Beech, J. and Jones, H. (University of Sheffield, UK), p. 354.

Eriksson, G., Sippola, H. and Sundman, B. (1994) A Proposal for a General Thermodynamic
Software Interface, Proceedings of The Colloquium on Process Simulation, ed. Jokilaakso,
H. (Helsinki University of Technology, Finland), p. 67.

Kattner, U. R., Boettinger, W. J. and Coriell, S. R. (1996) Z. Metallkde., 87, 522.

Lukas, H. L., Weiss, J. and Henig, E.-Th. (1982) CALPHAD, 6, 229.

Olson, G. (1997) Science, 277, 1237.

Samonds, M. and Waite, D. (1993) Mathematical Modelling for Materials Processing, eds
Cross, M. et al. (Oxford University Press, Oxford), p. 283.
