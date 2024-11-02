8 Creating thermodynamic
databases

In the previous chapters it has been shown how to obtain the best possible agreement
between thermodynamic models and experimental data using adjustable model parame-
ters for binary and ternary systems. Even if each such assessment can be very important
by itself, the main purpose of these assessments is to provide the building blocks of
multicomponent thermodynamic databases. This objective must be considered when per-
forming an assessment because it imposes some restrictions on the assessment of the
individual system and on the possibilities of adjusting data and models to new experi-
mental data. Such problems will be discussed in this chapter, together with the general
concepts concerning thermodynamic databases.

Experience has shown that thermodynamic databases based on a limited number
of ternary assessments, all centered around a “base” element like Fe or Al, can
give reliable extrapolations to multicomponent alloys based on that element. This
means that the database can be used to calculate the amounts of phases, their com-
positions, and transformation temperatures and that the calculated values have an
accuracy close to that of an experimental measurement. Such databases are a very
valuable tool for planning new experimental work in alloy development, since detailed
experimental investigations of multicomponent systems are very expensive to per-
form. It is important that the databases are based on ternary assessments, not just
binaries, because the mutual solubilities in binary phases must be described, other-
wise the extrapolations are not reliable. There are also many ternary compounds that
must be in the database. The number of quaternary compounds, however, is much
smaller.

Another factor that makes ternary assessments important is that they can reveal
that many binary assessments require modification when used in ternary assessments.
There can be many reasons for this, the most important being that the experimen-
tal information on a binary system is scattered and insufficient. In such a case
many sets of model parameters can reproduce the available data in a binary sys-
tem with equal accuracy, but these parameters will give different extrapolations
into ternary systems. Extrapolations from a binary system to several ternary sys-
tems should be carried out and the results compared before a binary assessment is
accepted.

243

===========
244

8.1

8.2

Creating thermodynamic databases

Unary data

The data for the pure elements must be the same in all assessments in which the element
appears in order to make it possible to merge these into a database. This may be considered a
trivial statement, but, since assessments may be performed by different research groups and
over a period of several years, there is a need for international agreement on pure-element
data. In particular, data for the metastable modifications of the element are critical because
these are essential for describing solubilities. The assessment of solution phases requires
data for the “end members” of the models and, in many cases, such “end members” are
not stable, for example Cr in the fec structure and Au in the bec structure. Data for stable
and metastable modifications of the elements, i.e. lattice stabilities, see section 1.2, have
been collected by Dinsdale (1991) and these are the recommended values. Updated versions
of this collection are available on several websites, for example http://www.sgte.org.

The accepted set of unary data will inevitably be subject to changes when new data
become available, but any attempt to improve the description of the data for the pure
elements in an assessment will make this assessment incompatible with other assessments
performed using the old value and thus not suitable for merging with an existing database.
A thermodynamic database consists of a large number of separate assessments and requires
several years’ development. The initial selection of unary data must be maintained even
if it is later evident that some values for the pure elements could be improved. Changing
an important item of unary data usually means the start of a new database.

It is important that the development of new data for unaries does not stop. The 1995
Ringberg meeting (Aldinger er al. 1995) was designated to set the foundation for a
completely new set of such data. When this work has been completed, it will be necessary
to reassess all binary and ternary systems. For a period of time assessments of new
systems may have to be done using both the new and the old set of unary data. Such
reassessments may occur even more frequently in the future and it is desirable to develop
an automatic and continuous reassessment procedure.

 

Model compatibility

When combining two assessments it is essential that a phase that forms or may form a
continuous solution from one binary system to another is described with the same model in
both assessments. This is obvious for the terminal solution phases, but some intermediate
phases may also exist across a system. It is then important that the models describing
the binary systems make it possible to combine these to give a single Gibbs-energy
description. The naming of such phases is a practical problem.

A simple case is a phase with fcc lattice with and without a sublattice for interstitials.
It is unproblematic to combine a model for a substitutional phase in the Fe-Cr system
with an fcc lattice with the austenite phase in the Fe-C system which has a B1 structure
with Fe and C on two interwoven fcc lattices. One just adds the interstitial sublattice to
the model for fec in the Fe-Cr system with the vacancy as the only constituent. In the
ternary Fe-Cr—C system this phase will then form a reciprocal solution with the model

===========
8.3

8.3 Experimental databases 245

(Cr, Fe) (C, Va). This will create a new “end member” belonging to the Cr—C binary
system, which has to be estimated (no phase with Al or B1 structure is stable in the Cr—C
binary system).

Phases with the simple fec, bec, and hep lattices appear in many systems, but also
many other phases with more complicated lattices, such as o and spinel phases, are
not uncommon. It is important that they are modeled in the same way in all systems.
Deciding whether two phases in different systems should be combined and, if so, what
model to select is not trivial. In the Cr-Si, Fe-Si, and Mn-Si systems there are phases
with the general stoichiometry M;Si. However, only Fe,Si and Mn,Si are similar; Cr,Si
has a different structure. A great help in identifying phases that are the same is the
Strukturbericht notation, but it is not available for many phases.

Many phases should be treated as the same even if they do not form a continuous
stable solution from one end to the other because other phases are more stable. It is very
important to identify the phases in different assessments that should be treated as the
same, because this has a large influence on the extrapolations to higher-order systems.

The recommended modeling of phases with an order—disorder transition is to partition
the Gibbs energy into a disordered part and an ordered part as described in section 5.8.4.1.
That makes it easier to combine the ordered phase with phases from other systems
which only the disordered part may be stable. For example, the B2 phase in the Al-Ni
system should be combined with the A2 phase in the Cr—Ni system. The B2 phase with
partitioning of the Gibbs energy has one part describing the disordered part (which has
an A2 structure) and one part describing the contribution due to ordering. One can then
simply add the parameters from the A2 phase in the Cr—Ni system to the A2 part in the
AI-Ni system and keep the additional parameters for the ordered part as zero. Great care
must be taken when merging phases that have an order—disorder transition, since it is easy
to make mistakes that make the disordered state become unstable at all temperatures.
essments will require reassessments of a system
in order to achieve the required model compatibility. It is strongly recommended that
one select models that are compatible with the systems with which the assessment should
be combined later. Otherwise, one should be prepared to reassess all systems for which
the “wrong” model has been used.

 

 

in

  

Sometimes the combination of two

   

Experimental databases

In each assessment the sor must create a file with experimental data used in the
optimization. In BINGSS it is the *.dat and in PARROT it is the *.POP file, as described
in chapter 7. In the experimental datafile each item of experimental information extracted
from the literature should be referenced correctly and all transformations or corrections
made from the original publication documented. In some cases the assessor may have
used theoretical information, either from publications, which then should be referenced,
or introduced as “fictitious” experimental information, for example to avoid a solution
phase appearing in a region where there is no information indicating that this phase should
be stable. This should be documented in the experimental datafile also. Each item of

 

 

===========
246

8.4

Creating thermodynamic databases

experimental information has an uncertainty that normally should have been provided by
the experimentalist, but often the assessor has to modify this uncertainty and the assessor
can also assign a weight to each experimental value. The final weightings depend on all
experimental values used in the assessment, as discussed in more detail in chapter 9.

The experimental datafile represents a large amount of work and it is important that
it is kept for future use, for example when new experimental data become available or
when a model for a phase is changed, both of which cases may necessitate a reassessment.
However, even with a well-documented experimental datafile, it is not trivial to carry out
a reassessment. The original assessment may have included conflicting datasets and the
original assessor may have selected one of these. The new information may indicate that
this selection was wrong and then a completely new assessment is required because all
weightings for various experimental data must be carefully revised.

The experimental datafiles should be kept on a public internet site and be made
available to anyone who is interested in carrying out a reassessment using a new model
for a phase or a new set of unary data, for example. The authors of this book will provide
such an internet site, from which assessors may upload their experimental datafile or
download previous files. For testing new software for assessments, it is also interesting to
have access to previous experimental datafiles. Testing new models, in particular, must
be done using identical experimental data; otherwise it is impossible to make proper
comparisons. The experimental data files are useful also when assessing a ternary or
higher-order system when it may be necessary also to vary model parameters for some of
the lower-order systems. As noted above, changes for a lower-order system may require
further modifications of other higher-order systems dependent on that system.

 

Naming of phases

In a thermodynamic database it is desirable to have a unique name for a phase that can
extend into a multicomponent system, even if that phase may have a different name in
each subsystem. A simple example of the problem can be found in the Ca-Mg—Fe-O
system, where pure CaO is called lime, pure MgO is called periclase, and both of these
form a continuous solution with the wustite phase in the Fe-O system, all having the
NaCl (B1) structure type. In a database the parameters for these three phases must be
stored together with a single name. At present the name “halite” has been selected for this
because halite is a kind of “generic” name for all phases with the NaCl structure type.

For metallic systems the phases are usually given greek letters as names, starting with
a for the low-temperature form, but a-Fe and a-Cu do not even have the same lattice.
For binary systems, phase names like “(Fe, Ni)” are used for extended solution phases,
but on adding carbon, the same solution phase may be called “austenite.” In a database all
parameters for a phase with the same structure type and the same Gibbs-energy function
must be stored with the same phase name.

In a database for steel, the phase name ferrite can be used for the bee structure and
austenite for the fec structure. However, in an aluminum database the fee structure type
must not be called austenite and one should try to find a phase name that is independent of

===========
8.4 Naming of phases 247

the composition of the phase. In diverse fields of science like geochemistry and metallurgy
the same phase has often been assigned different names, but it would be helpful, in
particular for students and other non-experts, if one could agree to use the same name
for the same phase for many applications.

In the assessments of a binary, ternary, or higher-order system one should thus try to
select phase names that are related to the structure rather than to a particular composition.
Some simple structures based on bec, fec, and hep lattices appear in many systems and,
although these notations actually characterize lattice types only, rather than a structure or
a phase, it is generally accepted to use fec, bec, and hcp as phase names. The use of these
phase names in a database can be extended to include also phases with more complex
structures, but that are modeled in such a way that the simple structure is included as a
special case. For example, the interstitial solution of carbon in austenite can be regarded
as an fcc phase even if it has a B1 structure and might be called “halite.” The TiC phase
has the same structure type and, in the Fe-Ti-C system, the Fe-rich phase with fcc lattice
with interstitial solution of C and substitutional solution of Ti can be modeled as the
same phase as the Ti-rich phase with a high fraction of interstitial C and a small fraction
of substitutional Fe. This model is actually an example of a reciprocal solution, in this
case (Fe, Ti)(C, Va); see section 5.8.1.

To go further, one must first review the various ways in which a structure type can be
designated. There are many ways to express the crystalline properties, such as in terms
of Pearson symbols, the space group, and the prototype phase; see section 2.2.3.2. All of
them are related to the crystal symmetry needed for identification of X-ray information on
a phase with given composition. This is not sufficient or even correct for a thermodynamic
identification of the phase, for example the space group Fm3m includes both the Al and
the DO, structure.

The Strukturbericht designation has the advantage that the nomenclature has no
relation to the actual structure. It consists of a letter followed by a number and pos-
sibly superscripts and subscripts. The letter A is used for phases for pure elements
(although A15 is a mistake), B for binary compounds with equal stoichiometry, C for
compounds with stoichiometry 2:1, etc. After C the letter has less obvious mean-
ing. There is no independent authority assigning these any longer, but the notation
is popular and various scientists are inventing “Strukturbericht”-like notations for new
phases.

It is generally advisable to use the Strukturbericht, if it is known, as a prefix or
suffix to a more “application-oriented” phase name. Many phases have no Strukturbericht
designation and in that case the prototype phase can be used instead. In the Strukturbericht
designation there are subscripts and sometimes superscripts. The various parts of a phase
name are usually connected by “_” (underscore), and for simplicity that can be used also
to separate subscripts or superscripts in the Strukturbericht designation, for example L1_2
for the L1, phase. Thi ll a matter of discussion though; in this book several styles
of phase names are used since that is the current situation.

It still remains to consider phase names when the same thermodynamic model is
used to describe several structure types, for example Al, L1,, and Ll, as discussed in
section 5.8.4. Such a “structure family” is usually based on a simple disordered lattice

 

 

===========
248

Creating thermodynamic databases

such as fec, bec, or hep and one may use this as the first part of a name. In the existing
databases there are ordered structures like B2, D0;, and L2, based on the bec lattice,
L1, and LI, based on the fee lattice, and D0,, and B19 based on the hep lattice. With
a four-sublattice model it is possible to treat both L1, and L1, ordering with a single
Gibbs-energy model, but, to include also DO,, ordering, eight sublattices are needed,
which is not realistic at present, so it must be treated as a separate phase. Using the
disordered lattice as the first part and the structure with the most complex ordering as the
last part, the name of an fcc phase with four sublattices for ordering is thus fec_L1_02.

The partitioning of the Gibbs energy of a phase with B2 structure into a disordered
part (with a substitutional lattice) and an ordered part (with two sublattices), as described
in section 5.8.4.1, makes it possible to use the phase name bec_A2 for the parameters
describing the disordered part and the phase name bec_B2 for the ordered part. When a
user asks the database for the parameters of a system in which there is no ordered phase
with B2 structure, the parameters for the ordering may be ignored and parameters for the
disordered phase only are retrieved. However, on retrieving data for a system in which
the B2 phase may be stable, as in the AI-Ni-Cr system, it may happen that, when the user
calculates an equilibrium in which a stable phase called bec_B2 appears, it may actually
be disordered A2. It is possible to implement in the software the use of different names
of phases depending on the composition or the state of order of a phase, but it may be
even more confusing for the user if a phase suddenly is replaced by another just because
it has undergone ordering. An interstitial sublattice for carbon and nitrogen can be added
both to the ordered and to the disordered model without changing the ordering model or
the use of a single Gibbs-energy function both for ordered and for disordered phases.

Phases with more complicated structures that are not ordered superstructures of simpler
structures sometimes have accepted names like the Laves phase, spinel, and M23 carbide.
It is recommended that such names be retained unless they are ambiguous. In the case
of Laves phases, which have the general formula A,B, there are three different structures
with the Strukturbericht names C14, C15, and C36 and it is recommended that these be
used as prefixes, for example C14_Laves phase.

A phase that has a fixed composition and does not dissolve any other elements should
normally keep its accepted name, provided that there is little or no solubility of other ele-
ments in higher-order systems. Some structure information should be added, give a name
like graphite_A9 or cristobalite_C9. If there is no accepted name, the recommendation
is to use the stoichiometric formula, possibly prefixed with some structural information,
like DO_I_MO2B5. Note that some stoichiometric phases can be stable with different
structure types at different temperatures.

Some compounds and intermetallic phases with solubilities have traditional names like
o and p, and, although the use of greek names like a, B, etc. is discouraged, names
like sigma_D8_B and mu_D8_5S are acceptable because they have been used for just one
unique structure. For carbides, names like M23C6 and M7C3 are established. Here M
stands for metallic atoms like Cr, Fe, and Mo, and C can actually be replaced by N or B,
but one should give the Strukturbericht designation as a suffix, thus M23C6_D8_4 and
M7C3_D10_1. For oxides, names like periclase_B1 (MgO), corundum_D5_1 (AI,O,),
and spinel_H1_1 (Al,MgO,) for the respective structure types are recommended. For salt

===========
8.5

8.5 From assessments to databases 249

systems, the phase name halite_B1 is recommended for NaCl and all phases with the same
lattice. Note that halite, periclase, and an interstitial solution of carbon in fcc tit
all have the same Strukturbericht designation, but there is no possibility of forming a
continuous solution between these extremes and thus they can be treated as different
phases.

The liquid phase usually has complete solubility of all elements and should thus be
treated as a single phase in all systems. In some systems the liquid has a large miscibility
gap and it may be tempting to treat, for example, the metallic liquid as a phase other than
an oxide or sulfide liquid and use different models for these. However, this should be
discouraged, since it is possible to change from a metallic liquid composition to almost
any other liquid composition by adding appropriate elements without passing any phase
interface. The amorphous phase can be treated as a supercooled liquid if an appropriate
glass-transition model is implemented, otherwise it should be treated as a separate phase.

Aqueous solutions and polymers may be treated as separate phases because it is not
possible to form a continuous solution with metallic or oxide liquids.

  

nium

 

From assessments to databases

A database is a merged set of thermodynamic assessments of binary, ternary, and higher-
order systems. To create a database, one must first collect all the necessary assessments.
Each such assessment usually represents a complete description of a system and there
is thus considerable redundancy if each assessment is stored separately. It is nonetheless
important to have them separate in order to check that the unary data are identical, that
compatible models are used for the same phases, and that the parameters really describe
the system as expected.

When the assessments have been checked, the phase names should be unified. For
this there is specific software, tdbmerger, by M. Jacobs (unpublished, 1999, available
from the website of this book), which can merge database files for individual assessments
written with the Thermo-Calc package and performs several checks during the merging.
This software allows selection of data and some interactive modifications of the data in
order to make data compatible. However, if different unaries or incompatible models have
been used in two assessments, that means that one of the assessments must be revised.

The main reason for keeping individual assessments on separate files and using merging
software is to simplify the updating of a database. If the database manager at a later stage
wants to replace a binary assessment with a new, better, one, that is virtually impossible
unless the database can be merged again using the new binary data.

In some cases it may be possible to transform one model into a more general one
without reassessment. For example, a metallic liquid treated as a substitutional solution,
(A, B), may be changed by manual editing into an ionic liquid model, (A**, B’*) p(Va) 9,
and merged with other assessments of ionic systems, but the tdbmerger software cannot
make this change by itself.

Each thermodynamic software system will store its databases in a format unique to
that software. However, there is a definition by the SGTE for a database-transfer format

 

===========
250

8.5.1

8.5.2

8.5.3

Creating thermodynamic databases

that is close to the TDB database format used by tdbmerger. The intention is that it should
be possible to translate the SGTE transfer format to and from any specific software-
database format. The SGTE transfer format is described on the website.

The effort involved in combining published assessments to produce a validated
database is considerable and should not be confused with a simple merging of assessments.

Merging of assessments

Output from BINGSS or other software used for an assessment must first be converted
to the Thermo-Cale format. For BINGSS, conversion software, coe2ges, is available on
the website of this book. The LIST-DATA command in the GES module of Thermo-Calc
can generate a database file with option N.

The output from this LIST-DATA command will normally contain some V variables
that have been optimized. The software rvbv, available on the website of this book, will
replace the V variables by their final values.

Unassessed parameters

On merging assessments, a large number of unassessed parameters may appear. Such
parameters can be, for example, ternary interactions, but also carbides and intermetallic
phases like a Laves phase may cause problems. If the Laves phase exists in two binaries
and is modeled as (A, B),(A, B) and (A, C),(A, C), this phase will, in the database, be
modeled as (A,B, C),(A, B, C) and the parameters °Gg.c and °Ge.g will be listed as
unassessed. By default, such parameters are treated as zero in most software, but that
might not be a good assumption.

All unassessed parameters can be listed using the GES module and the database
manager has to decide on a value of these or choose to leave them unassessed as a
warning to the users of the database.

Many such unassessed parameters can be assigned an estimated value by the database
manager because usually they have very little influence on any stable equilibrium cal-
culated with the database. The estimated parameters are usually far from any stable
composition of the phase and have no influence on the calculated equilibria. However,
the manager should be aware of the fact that the database is sometimes used also to
extrapolate to metastable states by suspending the stable phases and in such cases the
estimates may be very critical because the composition of the phase can then be far from
the stability range. Thus a clear reference must be given for each estimated parameter as
well as for the assessed parameters.

Missing parameters

Another problem that may appear on merging assessments is that phases ignored in the
assessment of a binary system may appear as stable in that system after the merger. For
example, the Cu—Fe system has no hep-A3 phase and, in a normal assessment of the

===========
8.5.4

8.5 From assessments to databases 251

 

 

 

 

 

 

 

 

 

 

2100 2000
o = 1600
g g
= 1500 $1400
5 1200 5 1200
Ee = 1000
5 900 5
r F800

600 600

300 400

0 02 04 06 08 10 A Oo 02 04 06 08 1.0
Mole fraction Fe Mole fraction Fe
(a) (b)

Figure 8.1 What may happen when a binary is added to a database. (a) The Cu-Fe system with
an ideal modeling for the hcp phase. (b) The Cu-Fe system with the interaction for the hep phase
as for the fec phase.

Cu-Fe system, no interaction parameter is assessed for the hcp-A3 phase. However, if
this assessment is merged with systems in which Cu and Fe dissolve in an hcp-A3 phase,
for example, Cu-Zn and Fe—Zn, the database may be used to calculate a ternary section,
Cu-Fe-Zn. The binary interaction in hcp-A3 between Cu and Fe will be zero, and, since
there is a positive interaction between Cu and Fe in the liquid, fec-A1, and bec-A2 phases,
one will find that the hep-A3 phase becomes a stable phase along the Cu-Fe binary, even
with very little Zn present. Unless the hcp-A3 phase is explicitly suspended, this phase
will also appear in the binary Cu-Fe system; see Fig. 8.1(a). The correct Cu-Fe phase
diagram is shown in Fig. 8.1(b). It is the database manager's responsibility to check all
assessed systems after the database has been merged and ensure that there are no surprises.
Some software may notify the user of such missing parameters, but, in a multicomponent
database, there is a very large number of those and it is a tedious problem to handle these
for the user.

This is something to consider whenever one is adding a binary assessment to a database.
The important phases are the phases which normally exhibit large solubilities, like liquid,
fec, bec, and hep. For the liquid there will always be some parameters and, if hcp is
missing but fcc has been assessed, one should copy the same parameters in hep as in fec.
If there is neither fec nor hep in a binary, one could set the regular-solution parameter for
these equal to that for the liquid or the bec phase, whichever seems the most reasonable at
low temperature. If the bec phase is not stable in the binary, its regular-solution parameter
can be set the same as that of the liquid.

Validation of the database

Checking that the assessed systems can be recalculated from the complete database
without errors and that no new phases appear is a first step in the validation, but
it does not guarantee that errors do not appear on extrapolating to higher-order sys-
tems. The database manager must thus have experimental information on a number of

===========
252

8.6

8.6.1

8.6.2

Creating thermodynamic databases

multicomponent systems that he uses to check that the extrapolations from the assessed
systems are reasonable. These checks can be used to define the valid composition range
for each component in the database.

It may be interesting to learn from an example to do with compiling a thermodynamic
database for steels. The first SGTE solution database released in 1989 could not describe
the austenite/ferrite equilibria at 1150°C for duplex stainless steels correctly, although it
contained the best available assessments of the most important ternary and, in some cases,
quaternary systems. These steels contain high amounts of Cr, Ni, and Mo (22, 5, and
3 mass percent, respectively) and all ternaries, Fe-Cr—-Ni, Fe~Cr-Mo, Fe-Ni—Mo, and
Cr-Ni-Mo, were assessed. The problem could not be solved by adjusting parameters for
alloying elements with smaller amounts. Instead, these ternaries were investigated and the
problem could be solved when it was realized that the fec-Al phase was being treated as
ideal in the Cr—Mo system, because it is not stable in that binary. By introducing the same
positive interaction in the fec-Al phase in the Cr—Mo system as for the bec-A2 phase
and reassessing the Fe-Cr—Mo system, it was possible to get reasonable descriptions of
the duplex stainless steels.

Database management and updating

A database requires constant updating and the tdbmerger software of Jacobs was designed
for this. Updating can be of two kinds, adding new assessments or replacing existing
assessments. In order to simplify the replacement, all individual assessments used to create
a database must be kept on separate files all the time. The tdbmerger software should
merge these files each time the database is updated and it is then easy to replace one
assessment with another simply by selecting the new file for that assessment. Replacing
an old assessment or adding a new one can affect the extrapolations to higher-order
systems and this should be checked by the manager.

The estimated parameters that the database manager has added to the database should
be kept in a special “add-on” file that is merged last.

Cancellation of errors

It is important to consider that adding a binary that was missing from the original database
does not necessarily improve the database. It may actually make the extrapolations in the
database worse. One reason for this is that the manager may have added estimations of
missing parameters to the previous version of the database in order to compensate for the
missing binary. Revision of such estimated parameters can be very difficult.

Documentation of a database

Since a database is likely to be used for longer than a single manager can keep it updated,
it is important that the manager keep sufficient documentation of the systems in the

===========
8.7

8.7.1

8.8 Mobility databases 253

database and of the test points he uses for the extrapolations. This makes it possible for
the next manager to continue the work on updating and extending the database.

For commercially available thermodynamic databases, a user should always request
a list of references of all assessed systems in the database. Some databases can provide
a list of references for each system retrieved from the database, which makes it easier
to verify that the database is up to date. Databases should be expected to be useful for
many years with proper updating, but it is important to know the origin of all parameters
in a database. There is a facility to reference each parameter to either a paper or any
other documentation in the database format used by Thermo-Calc, namely the so-called
“TDB format,” which is very similar to the “SGTE format for database transfer.” The
documentation of both of these is available from the appropriate websites.

Existing thermodynamic databases

Several databases are available and they are usually classified in terms of their main
component (for example, Al databases), a special physical property (semiconductors
database, superconductors database) or a class of materials (steels database, Ni-based-
superalloys database), or even a special application (solders database). More details about
existing databases and the software required in order to use them are given in a special
issue of Calphad (2002, 26, pp. 141-312).

Referencing a database

When a database is used for a publication, it should be properly referenced with its name,
supplier, and year and version identification if possible. The reference for a database is
more like describing an instrument used for a measurement than referencing an article
or book. Stating, for example, “SGTE solution database” is not sufficient because there
are many such databases. Referencing software is not appropriate because most software
can be used with several different databases. If the database supplier has a website, that
should be included in the reference.

Mobility databases

Although this whole book is devoted to thermodynamics, the fact is that computational
thermodynamics is most important for simulating phase transformations. The thermody-
namic description of the phase gives important quantities also in the metastable ranges
of the phases, such as the chemical potentials of the components and the thermodynamic
factor for diffusion. In addition, one must have mobilities of the elements in the various
phases, but that quantity usually varies more smoothly than does the diffusion coefficient.
The main problem is that there is so little experimental data, in most cases one may know
only the self-diffusion or tracer diffusion. The mobility is often closely related to the bulk

===========
254

8.9

Creating thermodynamic databases

modulus, which can easily be calculated with ab initio techniques; this is a pos
estimating mobilities.

There is a special version of PARROT for assessment of mobilities, either using diffu-
sion data or by fitting directly to measured concentration profiles. These assessments are
dependent on the thermodynamic descriptions, of course, since they are used to calculate
the thermodynamic factors and chemical potentials. The model for mobilities used in
PARROT is described in Campbell (2005) and is based on mobilities of each compo-
nent in each single-component phase. There are a few commercial mobility databases
available; see, for example, http://www.thermocalc.com.

  

ility for

Nano-materials

One new area of thermodynamic applications is to nano-materials. Real materials often
consist of several crystalline phases spatially arranged. Between the phases there are
phase interfaces where the composition and crystal lattice change. In single-phase regions
of the materials there are grain boundaries between grains that have the same crystal
lattice but varying orientation of the crystal axes. Each grain is a “single crystal” and
its size is typically of the order of 100nm to 100m. The fact that almost all inorganic
materials are “polycrystalline” is very important because that is the reason for their
isotropic mechanical properties. Only for a few applications, such as turbine blades, is
there a reason to take advantage of the fact that a single crystal has different mechanical
properties in different directions.

Thermodynamics normally applies to “bulk” polycrystalline materials when the surface
properties are several orders of magnitude less important than the bulk properties. The
phase boundaries in phase diagrams represent equilibria between two phases separated
by a planar interface. If the interface is curved, there may be a pressure term to be added
even to the “bulk” thermodynamics in order to get the correct equilibrium composition;
this is discussed in detail by Hillert et al. (1998).

The interface region between two different crystalline grains has a larger density of
defects than do the inner regions of the grains and the atoms at the interface can have
different coordination numbers from those they have in the bulk. These factors make the
interface properties different from those of the “perfect” crystal by a factor that can reach
30%. This fact has inspired the idea of creating materials mainly formed by interfaces in
order to discover properties different from those of a perfect crystal. Reducing the size
of the grains to nanometers makes the number of atoms in the grain comparable to the
number of atoms at the interface and, as a consequence, the macroscopic properties of
the material are no longer governed by the interaction of atoms inside a crystal. These so-
called “nano-materials” can be in a metastable equilibrium or even in a “non-equilibrium”
state (Bustamante er al. 2005) and their properties will be different from those of the
equilibrium state of materials that has been treated in this book. In other cases equilibrium
thermodynamics can still be applied and an addition to the Gibbs thermodynamics of
small systems can be found in the book by Hill (1994).

===========
8.9.1

8.9.2

8.9 Nano-materials 255

Surfaces in materials

Although this book deals only with bulk thermodynamics of materials, it is important
to mention some relations to surface properties. The grains in a polycrystalline material
usually form at solidification or when the material is recrystallized, as described in any
textbook on materials science. The internal surfaces like phase interfaces and grain bound-
aries are important for many macroscopic properties, but also for phase transformations
in materials. Grain boundaries can move and, with increasing temperature, the grains may
become very large, since this makes the surface area smaller and minimizes the energy. It
has been known for a long time that mechanical properties are usually better for materials
with small grains and much effort has been devoted to stabilizing the grain size against
changes in temperature, for example by pinning the grain boundaries by placement of
particles.

For phase transformations the relative stability of the different phases at the phase inter-
face is the most important factor determining the interface movement. Usually both the
crystal lattice and the composition change across a phase interface and thus bulk diffusion
is also needed in order for the interface to move. Even during phase transformations, it is
a useful assumption that one has “local equilibrium” at the phase interface, which means
that the compositions at the interface are given by an equilibrium tie-line in the phase
diagram. The movement of the interface and the bulk diffusion must balance to maintain
the equilibrium compositions for the two phases at the interface, taking into account that
the actual tie-line may change with time in multicomponent systems. This is used, for
example, in the DICTRA software (Ande n et al. 2002); see also section 8.10.2. When
the elements have very different mobilities, this “local equilibrium” may be replaced
by a “para-equilibrium” assumption, as discussed by Hillert et al. (1998). For rapidly
moving interfaces, one may use the “solute-drag” theory, see section 8.10.3, to describe
the transition from local equilibrium to massive transformation. All of these models for
phase transformations depend on a good description of the bulk thermodynami

 

 

 

 

Nucleation in materials

When a new phase wants to form, there is a nucleation stage during which the surface
energy of the new phase is just as important as, or more important than, the bulk energy.

 

Classical nucleation theory gives the critical radius of a spherical particle of the new
phase as
— 20Vin (8.1)
r=aG .

where o is the surface energy, V,, the molar volume of the new phase, and AG,, the
difference in energy between the new and old phases, also known as the “driving force”
(see section 2.3.6).

Several models for estimating the surface energy, a, from the bulk thermodynamic
data have been proposed. Since this energy depends on many local factors, such as lattice
orientations and segregation of solute toward the boundary, such models can give only a
rough average value.

===========
256

8.10

8.10.1

Creating thermodynamic databases

Examples using databases

Many examples of the use of a thermodynamic database can be found in the literature,
for example Hack (1996), Kattner et al. (1996), and Saunders and Miodownik (1998).
Here, only a few examples are given.

Multicomponent phase-diagram calculations

The classical example of the use of a thermodynamic database is the calculation of the
phase diagram for a multicomponent system. An isopleth for a high-speed steel with
metal composition 4% Cr, 9% Mo, 1.5% W, 1% V, 8% Co and the rest Fe for varying
carbon content is shown in Fig. 8.2.

The reliability of any line in such a diagram calculated from a validated database
within its range of applicability is normally the same as for an experimental determination.
Since the calculation may take a minute whereas the experiment may take a month or

1500

 

1400 4

    

liquid + aust

1200 5

1100 5

1000 5

Temperature (°C)

900 5
800 4

700 4

0 05 1.0 15 2.0 25 3.0
Mass percent C

Figure 8.2 An isoplethal section of a high-speed steel. The lines indicate where a phase appears
or disappears (zero-phase-fraction lines). The stable phases in some regions have been indicated;
to write all of them on the figure would be too confusing.

 

 

 

===========
8.10.2

8.10 Examples using databases 257

longer, the gain in speed for alloy design is obvious. Of course, any conclusions drawn
from a calculation must be verified experimentally, but one can reduce the number of
experiments needed significantly. In addition, the calculation can be used also to obtain
chemical potentials, heats of transformations, and amounts and compositions of individual
phases for any temperature and overall composition.

The equilibrium phase diagram will normally deviate from the behavior of any nor-
mal material that has been processed too quickly to obtain full equilibrium. Below
800°C diffusion, except of carbon, is usually too slow to produce the equilibrium set of
phases.

Simulation of phase transformations

A thermodynamic database is developed to describe the stable state of a system, but it
provides the possibility of extrapolating outside the stability range because the modeling
of each phase is usually done for the whole system. This is a very important feature when

Figure 8.3 Concentration profiles of Cr across the interface after various times. The origin of the

 

 

 

 

 

 

 

 

 

 

 

 

 

horizontal axis is always at the interface.

 

 

 

07 07
0.6 After 10s 0.6 After 100s
5 05 6 05
§ §
3 0.4 3 0.4
= 03 = 03
£ g
= 02 = 02
04 04
0 0
6 420 2 4 6 4 20 2 4 6
Distance (10-7 m) Distance (1077 m)
(a) (b)
0.40 0.35
0.35
After 1000s 0.30 After 10000s
6 290 6 0.25
5 0.25 5
2 2 0.20
3 B
© 0.20 8
= = 0.15
© 0.15 g 7
= o.10 = 0.10
0.05 0.05 +
x
0 0
4321012345 2-10123 456
Distance (10-7 m) Distance (1077 m)
© (a)

===========
258

Creating thermodynamic databases

there is an interest in describing phase transformations since it provides the possibility of
calculating driving forces for nucleation and the thermodynamic factor for diffusion also
outside the stable equilibrium. In order to simulate processes and other transformations
together with kinetic data for mobilities, accurate values of such thermodynamic properties
are essential.

The DICTRA software (Andersson et al. 2002) was developed to handle phase trans-
formations, including diffusion in multicomponent alloys, which can be simulated along
one spatial coordinate. The application selected here is the dissolution of a spherical
cementite particle in an Fe-Cr—C matrix. The cementite particle was formed at low
temperature in equilibrium with ferrite in order to have an equilibrium partitioning of
Cr and C. The material was then heated to 1183K, the ferrite transformed to austen-
ite, and the particle started to dissolve in the austenite matrix. In Figs. 8.3(a)—(d) the
concentration profiles of Cr around the interface after various times are shown. At the
interface it is assumed that one has equilibrium partitioning of Cr and C, but since C can
move much faster, there is a very sharp concentration profile for Cr. Measurements of
the concentration profile from Liu et al. (1991) are shown together with the calculated
profile.

The interface between the cementite and austenite cannot move until the Cr concen-
tration in the cementite particle begins to become more uniform. In Fig. 8.4 the volume
fraction of the particle is plotted versus time. The experimental points at short times
are very uncertain and deviate from the calculation, but the simulation predicts cor-
rectly the amount of carbide after a long time. The dissolution of a cementite particle
in a binary Fe-C alloy takes less than a second, as a comparison. The Cr content of
the alloy thus has the effect of slowing down the transformation and that is correctly
predicted by the simulation. The simulation is based on independent thermodynamic

 

 

 

 

g | =$=---—— |
3
2 0104 L
5
3
5
s
g
‘o
E0054 L
$
0 ra 1
104 103 102107 4 10 102 10° 108

Time (s)

Figure 8.4 The volume fraction of carbide.

===========
8.10.3

8.10 Examples using databases 259

assessments of the Fe-Cr—C system and mobilities of Cr and C in austenite and cementite.
The experimental data shown in the figures have not been used to fit the simulation.

Solute-drag simulations

The solute-drag model was developed to explain how grain-boundary mobilities could
depend on the concentration of solutes at the grain boundary (Liicke and Detert 1957,
Cahn 1962, Hillert and Sundman 1976). This has been extended to phase inter-
faces (Hillert and Sundman 1977) and, more recently, to multicomponent systems (Hillert
and Schalin 2000). The interesting feature of the solute-drag theory is that it gives a
continuous curve of the Gibbs energy across the phase interface between two different
phases as shown for a binary system in Fig. 8.5.
The dotted curve in Fig. 8.5 represents the Gibbs energy at any position across the
interface and is simply given by the equation
Gi, = xGi"' + (1— y)GE (8.2)

where y is the length coordinate across the interface, going from zero to one. At y =0
one has only fee with the composition xy and at y = 1 one has only liquid with the
composition x""""". In between the composition varies between these limits and the
Gibbs energies of the two phases can be calculated from the thermodynamic models using
the same composition for the same value of the coordinate y. Note that the equilibrium
compositions for the fee and liquid phases are given by the common tangent. When
the interface is moving the composition at the interface of the growing phase can differ

from the equilibrium composition, but the composition at the interface of the shrinking

 

Gibbs energy (kJ mol)

 

 

 

 

T T T
A 0.28 0.30 0.32 0.34 0.36

Mole fraction B

Figure 8.5 Gibbs-energy curves related to an interface between the liquid and fcc phases.

===========
260

8.10.4

Creating thermodynamic databases

phase must always be inside the two-phase region. These compositions as well as the
composition profile across the interface can be solved using a differential equation as
described in Hillert and Sundman (1977).

The phase-field method

The simulation of phase transformations in two or three dimensions is based on the
phase-field method, since it is impossible to treat directly the movement of “sharp”
individual phase interfaces in two and three dimensions in the same way as is done in
DICTRA for movement in one dimension. Instead a grid is imposed and the amounts of
phases at each grid point are calculated by the phase-field method, which is based on
thermodynamics and kinetic data, i.e., a “diffuse” interface. The first simulations using the
phase-field method had very simple thermodynamic descriptions and a single continuous
Gibbs-energy function across the composition range. This would apply only to ordering
transformations in which the ordered and disordered phases have the same Gibbs-energy
function. The phase-field method combined with realistic Calphad databases has recently
been applied to a variety of phase transformations (Grafe et al. 2000, Warnken et al. 2002,
Qin and Wallach 2003, Loginova et al. 2004, Zhu et al. 2004, Béttger et al. 2006).

Figures 8.6 to 8.8(d) show a simulation of equiaxial solidification of an Al alloy using
MICRESS phase-field software (http://www.micress.de), the TQ interface of Thermo-
Cale (http://www.thermocalc.com) and the COST-507 light-alloy database (Ansara
1998a). The alloy contains xy, = 5.53 at%, xy, = 0.401 at%, and the rest is Al. The
figures show the formation of the fec, Al,Mn, and AlMg-f solid phases from the
liquid.

In Fig. 8.6 the cooling curve of the alloy is shown. In the first part of the curve
dendrites of Al are formed. The start of the solidification of Al dendrites is magnified
in Fig. 8.6(b), which shows that a slight undercooling is necessary to nucleate the solid

907
906
905
904
903
902

901

700 900
0 20 40 60 80 100 005 115 2 25 3 35 4 45 5

Time (s) Time (s)
(a) (b)

 

 

900

850

Temperature (K)
@
8
Temperature (K)

750

 

 

 

 

 

 

Figure 8.6 The temperature-time curves for solidification of an AI-Mg-Mn alloy at constant
heat flux. In (b) a magnification of the first part of the curve in (a) is shown. Courtesy of Bernd
Bottger.

===========
8.10 Examples using databases 261

 

 

 
 
     
 

 

 

 

 

 

 

 

 

 

 

950 a 950 1 1 1 1
liquid
900 + - t 900 + foc r
liq + AlMn
| 8504 Fg 8804 L
g g
= 8004 - fF % 8004 fec + AlgMn’ F
3 liq + fec + Al 5
£
& 7504 F 5 750 4 F
foc + AlgMn
700 | | 700 4 foc + AlgMn + AIMg-B |
icc + AlgMn + AIMg-B
650 Tt 650 T T T T
A o 5 10 15 20 25 30 35 40 YX Oo 02 04 06 08 1.0
Mass percent Mg Fraction solid phases
(a) (b)

Figure 8.7. The phase diagram for Al-0.4Mn—Mg is shown in (a). A curve of the fraction of solid
versus temperature from a Scheil-type solidification simulation is shown in (b).

phase. After most of the alloy has solidified, the Al,Mn starts to form and finally also
AIMg-8. This four-phase equilibrium is an invariant reaction in the ternary system and
the temperature remains constant.

The cooling curves can be related to the calculated phase diagram in Fig. 8.7(a) from
Ansara (1998a) and compared with a “Scheil—Gulliver” (SG)-type solidification (Gulliver
1913, Scheil 1942) calculation shown in Fig. 8.7(b). The alloy composition is shown as a
dotted line in Fig. 8.7(a). When it starts forming fcc (Al dendrites), the liquid composition
will move toward higher Mg content until the Al;Mn phase starts to form also. That
temperature is marked in Fig. 8.7(b). In the SG simulation no diffusion takes place in the
solid phases and the liquid is assumed to be homogeneous.

The following figures are from simulations obtained using the phase-field method
and show the development of the microstructure in two dimensions. In Fig. 8.8(a) the
temperature is just below the liquidus temperature and the formation of Al dendrites
has just started. The compositions of the components are indicated by the grayscale. In
Fig. 8.8(b) the dendrites have grown and one can notice a gradient in composition from
the center to the interface with the liquid.

In Fig. 8.8(c) the precipitation of Al,Mn can be seen to have occurred inside the liquid
phase, but this cannot be noticed on the cooling curve because the latent heat is very
small. Finally, in Fig. 8.8(d) the dissolution of the Al,Mn phase has started and the final
liquid transforms to fec and AlMg-B.

In the phase-field method the surface energies and interface mobilities play an impor-
tant role. Such quantities are even more difficult to assess than the thermodynamic and
mobility data. Often one can only vary these in a simulation model until one finds agree-
ment with a real microstructure, but using validated thermodynamic databases makes it
easier to find realistic values for these quantities.

===========
262

Creating thermodynamic databases

, f 4
al 7 §
oy Bm
|

a , il

4
Ye d

oH

 

Be

ae

 

+
+

=

 

Figure 8.8 Steps in the phase-field-method simulation of the solidification. (a) Temperature just
below liquidus after 1s, the Al dendrites have nucleated. (b) The Al dendrites have grown after
16s. (c) The dendrites after 40 s and the Al,Mn phase has nucleated in the liquid. (d) The material
is now completely solidified. The composition is displayed as a grayscale. The formation of the
second solid phase in the liquid is shown in (c). In (d) the alloy is completely solid. Courtesy of
Bernd Bottger.

However, there are many problems still to solve, such as that of which value of the
Gibbs energy to use across a phase interface. Various approximate methods have been
applied in various forms of software, but, unfortunately, there is still little interest in
developing this further because the thermodynamic coupling slows the software down
considerably and many software users have more interest in producing nice graphs than
in realistic microstructures.

The technique from the multi-component solute-drag theory (Odqvist et al. 2003)
which is used to connect the Gibbs energies across the interface is applicable also in
the phase-field method. One can simply calculate the Gibbs energy at any point in the
interface as the weighted average of the Gibbs energies of the phases involved, calculated
for the same composition in all phases and using the amount of the phases as weighting:

Gi, = Lo m*GAT, P, x) (8.3)

8.10 Examples using databases 263

Some of the phases may be ordered and then the Gibbs energies for those phases must
be calculated using the site fractions with the constraint that the mole fractions are the
same as for the other phases.

If any phase has a stoichiometric constraint so it does not have a Gibbs energy value
for all compositions, one can either assess the phase with another model with extended
(metastable) solubility or assume some reasonable value of the missing Gibbs energy.
