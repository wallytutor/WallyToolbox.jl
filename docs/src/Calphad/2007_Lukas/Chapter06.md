6

6.1

6.1.1

Assessment methodology

Starting the assessment

In chapter 5, various models were described in order to understand how they can be
fitted to the experimental features that were described in chapter 4. In the present chapter,
we start from experimental evidence and search for the model best able to describe it.
Therefore many topics of chapter 5 will be revisited here.

An assessor working on a system will experience almost all the steps described and
discussed here. Since a system is often reassessed many times, by the same researcher or
by another, it is very important to keep records about the decisions made in order to make
it easy to restart the work, for example, when new experimental evidence requires a new
optimization. The process of assessing a system is made easier if an assessment logbook
is kept. An important function of this logbook is that one should record all mistakes
and failures so that one does not repeat them later. In the final paper only the sucessful
modeling will be reported and there is no information about the difficulties encountered
in obtaining it.

The assessment methodology described here includes a critical assessment of the
available literature in the way in which it is normally done, for example, in the Journal
of Phase Equilibria and Diffusion. By combining this with thermodynamic models, an
analytical description is created and the determination of adjustable model parameters
is often done using the least-squares method to obtain a description that represents best
the complete set of available consistent experimental data. From this point of view
that technique can be called an optimization. However, the least-squares method can
work well only if the scatter of experimental data is completely random. Non-randomly
distributed deviations of some data may completely destroy the utility of the least-squares
method. They must be classified as systematic errors and excluded from the optimization.
Therefore subjective judgments are required and decisions have to be taken on the selec-
tion of data during the optimization. From that point of view, the technique can also be
called an assessment. A schematic picture of an assessment procedure is shown in Fig. 6.1.

 

Literature searching

The first step of the optimization process is the literature search. It is very important to
consider all the data that are able to contribute to the optimization of the description one
wants to carry out. A useful way to organize the literature is to classify it by the types of
the measured quantities.

161

===========
162

Assessment methodology

 

 

 

 

 

 

 

 

 

  

 

 

     

 

 

 

 

 

 

 

 

 

 

 

 

Literature survey:
o Phase-diagram Thermodynamic quantities Crystallographic information
a data (enthalpies, activities, etc.) (symmetry, site occupations, etc.)
5 “ t x
=z experimental & theoretical
z
< |
‘Analysis and assembly of information:
= Preliminary selection of experimental data checking for appropriateness of
4 experimental method, systematic errors, impurities etc.
<z
2 f
é Modelling selection:
oO + Selection of number of independent model parameters for each phase,
consistent with quantity and quality of available information.
Parameter evaluation, New experimental
| least squares fit data
Model-parameter Weighting of
constraints data
|____,[ Comparison between experimental data | —+—!
and model calculations

 

 

 

 

 

 

 

Re-evaluation of Re-evaluation of data selection,
model selection elimination of inconsistent data

 

 

 

 

 

 

OPTIMIZATION

 

 

Analysis of the extrapolation behavior

Re-evaluation of description
to higher-order systems

of lower-order system

 

 

 

 

 

Optimized description

 

 

 

Figure 6.1 A schematic diagram of the Calphad assessment method.

A good start for the literature search is the Journal of Phase Equilibria and Diffusion.
The last issue of each volume contains a cumulative index of alloy systems. It covers
all the evaluations published under the aegis of the Alloy Phase Diagram International
Commission (APDIC). The articles quoted there are a critical analysis of the literature:
they give an overview of the literature and, if there are discrepancies between published
measurements, the authors of the articles amass arguments to decide which values are the
most reliable ones. The Journal of Phase Equilibria and Diffusion deals specifically with
phase diagrams, so most of the literature cited there is relevant for the optimization and
it usually covers much of the literature of interest. A scanning of the literature quoted

 

===========
6.1 Starting the assessment 163

in the JANAF tables (Chase 1998) may be complementarily useful for thermodynamic
data such as H-, S-, and C,-values. Auxiliary information helpful for the modeling of
Gibbs energies, for example types of point defects, carrier mobilities, variation of lattice
parameters with pressure, temperature, and composition, information from spectroscopic
methods such as Raman and Méssbauer spectroscopies, bulk-modulus data, thermal
expansion, vibrational (phonon) spectra, total-energy calculations (from first principles),
and resistivity measurements to determine phase boundaries, may not be mentioned in
the above-mentioned journal.

Calphad, the Zeitschrift fiir Metallkunde (now called the International Journal
of Materials Research), the Journal of Alloys and Compounds, Intermetallics, and
Thermochimica Acta are some of the other journals that often present assessments or
data useful for assessments. The information useful for thermodynamic assessments
is, however, widespread in many other journals, including Physical Review B, the
Philosophical Magazine, Acta Materialia, Metallurgical and Materials Transactions,
Nature Materials, Acta Crystallographica, and Scripta Materialia. These can provide lit-
erature more recent than the critical evaluation of the International Programme for Alloy
Phase Diagram Data. With electronic literature databases used on line, searching for
keywords can provide large lists of references. However, many of them may be irrelevant
for the optimization.

As a rule one should obtain all the original papers. It is very important to check all
the data as they are reported by the original author. Do not use “secondhand” infor-
mation from the author of an assessment, unless it is impossible to order the original
literature.

It may be enlightening to know a story about how important it is to have original data.
In the accepted Fe—Mo phase diagram before 1980 there was a three-phase temperature
for liquid +o + bee at 1813K. This was in several references reported as determined
by Sykes (1926), but the thermodynamic assessment showed that this temperature was
impossible, since the parameters required to get this low three-phase temperature were
absolutely impossible. However, Sykes being a respected experimentalist, it was not
possible just to discard his data and it had been quoted in all references since 1926.
But when the original reference was finally retrieved it was found that he had not really
measured this temperature. He had measured some points on the o + liquid solubility
curve and then extrapolated this to meet the solubility line of o in equilibrium with bec
Mo and put the three-phase temperature where these lines met. The solubility of Fe in o
he had estimated as 50% Mo, but he did not have any experimental data on this solubility;
he had misinterpreted another paper that stated that the solubility limit of the j. phase
was 50% Fe, mistaking q. for the o phase.

Later the solubility limit of the o phase was measured and a much higher solubility of
Mo, almost 60%, was found. However, in the phase diagram drawn the three-phase line
was not changed; instead a very strange curvature of the solubility curve of o was imposed
in order to fit the accepted three-phase temperature of 1813 K. If those who constructed
this diagram had read the Sykes paper and carried out the same construction as he did, they
would have put the three-phase temperature at a much higher value. In the thermodynamic
assessment this was now done. At the same time some new experimental data above

===========
164

Assessment methodology

1813 K were obtained, showing that o is indeed stable at much higher temperatures, and
the new assessment was confirmed.

Information can be lost. Information can be wrong. Information can have been
misinterpreted by the assessor at the time of his assessments. New experimental results
reported in the literature may invalidate the previous arguments and decisions.

In many cases the originally measured quantity is reported after having been
transformed. For example, enthalpies of mixing are often obtained by dropping a cold
sample into a calorimetric bath (section 4.1.1.1). The reported value is the measured
one minus the enthalpy difference between the cold sample and the sample heated up to
the calorimeter temperature. For this enthalpy difference the numerical value which is
actually used is often not given, but only a reference is cited and the reference may be
ambiguous in evaluating this value. In the dataset to be optimized, however, this enthalpy
difference is already defined and may deviate to some extent from that used by the author.
Then the value used by the author should be replaced by the enthalpy difference defined
by the dataset.

Sometimes the original measurements may contain more information than is
reported in tables or curves. The additional information can, however, often still be
extracted from the reported data, if the experimental method is well described in the
publication.

A useful way to organize the literature is to classify it by the types of the measured
quantities (see chapter 4). A first classification may distinguish among the following.

e Experimental thermodynamic data.

Here all kinds of enthalpies appear, plus their variations with temperature and
composition (calorimetric data) together with all the experimental data related to
chemical-potential measurements, obtained by emf or vapor-pressure methods.

e Experimental phase-diagram data.

Phase-diagram data can be obtained by various methods and require careful research.
Thermal analysis, metallography, X-ray diffraction, solidification-path experiments,
microprobe measurements, and use of diffusion couples are the most common
methods.

e Other experimental data, which have a quantitative relation to thermodynamic
functions: bulk moduli, thermal expansions, elastic constants, etc. All these quantities
are related to derivatives of the Gibbs energy.

¢  Crystal-structure data, point defects, densities (vacancies), ordering, resistivity,
vibrations, etc. These data are very important in selecting details of the models to be
used for each phase.

e Theoretical papers for calculations of total energies, at zero and/or at finite
temperature, estimates, trends, thermodynamic properties, and phase diagrams of
similar systems. See section 6.2.1.3.

e Review papers, critical assessments, and previous optimizations.

These papers may contain an optimization that already satisfies all the recommenda-
tions for a good optimization. This means that the work has already been done for
the system in question. If an optimization is not satisfactory, the arguments given in

===========
6.1 Starting the assessment 165

that paper may nevertheless be helpful; and they can be a very useful starting point
for an improved description.

¢ Miscellaneous
Here one can include information that is indirectly connected to Gibbs energies, such
as information on kinetics, microstructure, and solidification. It can be very useful
for checking the use of the assessment in some application.

6.1.2 Analysis of the experimental data

After reading all the literature, one should have a good overview of the system. Already
at this stage some contradictions between different sets of measurements may be detected.
The most obvious contradictions are recognized when different values are reported for
the same quantity, for example contradicting points of a solvus line of a binary system.
In this case at least one of the datasets contains systematic errors and this set must be
excluded from a least-squares fitting unless one can evaluate the error. It is impossible
to give a general rule on how to select the best one of several contradictory sets of
measurements. The descriptions of the experimental procedures must be read carefully
to ascertain where it is more likely that errors could have occurred, like reaction with
the crucible material or with the gas phase, evaporation of a volatile component, or not
reaching equilibrium. Anyway, the arguments deployed to categorize sets of data as more
or less reliable must be clearly specified in the publication of the optimization. It is
possible that later measurements will throw new light on this problem and suggest a new
decision regarding which set of conflicting data should be preferred.

Contradictions between quantities obtained from different experimental methods might
be undetectable before running an optimization, but found after the first trials. Thus the
evaluation of the reliability of the experimental data must be repeated.

For values that are unique to a system, such as temperatures of invariant equilibria
and standard enthalpies of formation of stoichiometric phases, it is recommended that
one select a “best” value for each of these measured or estimated quantities before the
optimization. If several values of the same quantity are used, the least-squares method
can do nothing else but find a mean of the reported values. The selection of the “best”
value can, however, be changed if more information is obtained during the optimization
procedure.

Values depending continuously on a state variable, such as temperature or composition,
should be used for the optimization without prior smoothing or replacement by mean
Every smoothing procedure has associated with it the danger of introducing a
subjective preference, which might not agree well with the “reality.”

Measurements excluded from the optimization due to contradictions should not be
totally erased from the computer, but should be plotted together with the accepted
measurements and compared with the result of the optimization.

Ternary phase-diagram data, especially indications of the temperature at which the
second solid phase appears on cooling, must be interpreted with great care since the
composition of the liquid phase will change while it is precipitating the first solid phase.
One may use a Scheil simulation, see Fig. 8.7(b), to check such experimental data.

value:

 

===========
166

Assessment methodology

Selection of the set of phases to be considered

An important part of the critical assessment is the identification of the phases present in
a system. The liquid phase should always be included, since it is usually stable across
the whole system. The terminal phases are in general not a problem because they are
usually the pure elements themselves, with homogeneity ranges varying from so small
that they can be ignored to extending across the whole system. The identification of the
intermediate phases, however, is not always straightforward. By intermediate phase one
should understand any phase that does not appear as stable for any of the pure elements,
for example intermetallics, oxides, carbides, etc. The early investigations might not have
found all phases or they may have attributed a different composition to a phase. A phase
may be metastable, despite its having been found by all investigators. A well-known
example of a metastable phase is cementite, Fe;C, in the Fe-C system. A metastable phase
such as cementite must be included in the set of phases considered in the optimization of
the Fe-C system.

The existence of a phase is most convincingly confirmed if its crystal structure is
clarified. The most convincing structure determinations are those based on single-crystal
X-ray diffraction. In cases in which the X-ray scattering of different atoms is very similar,
neutron diffraction may give important additional information. If various authors have
assigned different unit cells to the same phase, this is not necessarily a contradiction,
since there may exist a transformation between the two descriptions, although one of
them may have lower symmetry. If just a unit cell is reported, this is less convinc-
ing because it may be due to a misinterpretation of the X-ray pattern of a two-phase
sample. A good fit of X-ray intensities with a proposed crystal structure, however, is
nearly impossible to create artificially from a not-single-phase sample, even though the
crystal structure itself may be refined later. Of course, it must be checked whether the
crystal structure is really proved by X-ray-intensity measurements. Some reported crystal
structures are just concluded from the similarity of the X-ray pattern to that of a known
structure.

 

The ratio of the numbers of positions of the different atoms belonging to the crystal
structure of a stoichiometric phase can be taken as the best definition of its “ideal”
composition. Often, however, more than one component can enter a sublattice or some
positions may be vacant, then the actual composition is able to deviate significantly from
the “ideal” composition.

Phases formed at lower temperatures are often detected only after longer annealing
times and may be missed in most investigations. On the other hand, phases found only
after rapid quenching are more likely to be metastable. Often that is proved definitively
by transforming them into stable phases by annealing later. Taking all that into account,
in most cases a consistent interpretation is possible.

After the first consideration on compatibility of the data, the optimization steps follow:
the selection of the model for each phase and the decision regarding how many and which
coefficients can be adjusted independently for each of the selected models.

At this level of the assessment it is very useful to produce a table indicating which
kinds of experimental data are known for each phase. Table 6.1 presents a hypothetical set

===========
6.2

6.2.1

6.2 Modeling the Gibbs energy 167

Table 6.1 A summary of experimental data on a hypothetical system

 

 

 

Phase Strukturbericht Phase equilibria. gs, a H — -H(T)—H(298K), C,
Liquid 2-phase, 3-phase pa(T), wy(T) H(x)

Phase Al 2-phase a(x)

Phase; Ll, 2-phase BAT), wy(T) (x) H(T), aH/aT
Phase, C14 2-phase Heasion (To)

 

 

of data organized by type. With this information, one can quickly answer some questions
that are important for the model selection; see section 6.2.9. After the answers have been
obtained, some simple decisions about the model can be made.

Modeling the Gibbs energy for each phase

As has already been mentioned, each phase in a system can be modeled independently,
but, when two or more phases have the same or related crystal structure, they may be
modeled as the same phase. Typical examples are when the terminal phases have the
same crystal structure, or when an intermediate phase is an ordered form of a terminal
phase.

General considerations

The appropriate description for the Gibbs energy of each phase should be selected from
the models described in chapter 5. All the descriptions there are supported by physical
models. Some of the polynomial excess terms, however, are only curve-fitting formulae
to be used for description of small deviations from the model. This is necessary, because
no model is able to take into account all possible physical effects. A model is well chosen
if it has a physical background and experimental values fit the corresponding calculated
quantities well using only a few model parameters.

All models contain simplifications, so it may be useful to add some terms with curve-
fitting behavior summarizing the contributions of minor physical effects, which in detail
might not be well known quantitatively. The contribution of this additional curve-fitting
formula should be small compared with the contribution of the model formula itself.
This problem had been addressed by Didier de Fontaine er al. (1995): “Usually, it
is impossible to treat the problem in a rigorous theoretical manner: even if magnetic
effects would be described by an Ising model, a detailed mathematical treatment would
be out of question as it is known that (a) the three-dimensional Ising model cannot
be treated exactly, even in principle, and (b) finding accurate approximate solutions is
one of the hardest problems in theoretical physics. We are forced, therefore, to adopt
a purely phenomenological approach consisting of optimal fits of experimental data to
an empirical analytical expression. The choice of this mathematical expression should

===========
168

6.2.1.1

Assessment methodology

not be completely arbitrary, and indeed its form should reflect as much as possible the
essential physics of the problem. If that can be achieved, (a) at least some of the fitting
parameters will have physical meaning and these derived values can be checked against
known experimental information, (b) values of properties of metastable phases can be
predicted with some chance of success.”

Some kinds of experimental data can give good hints about the selection of the model,
in particular data on enthalpies and chemical potentials (activities) in the single-phase
region.

After selecting the model for each phase, the parameters of the model should be
analyzed. General models contain many parameters, and the ones to be used in the specific
modeling of a given phase should be decided considering their physical meaning. Some
models require parameters that cannot be provided by any experimental value; however,
their use is necessary because they are intrinsically related to the model. Some parameters
can be combined by constraints to give a single parameter or fixed arbitrarily to values
that have no significant influence on G in the stability range of existence of the phase.
Some parameters with curve-fitting behavior may be tolerated, but should be restricted
to small deviations from a description based on physically meaningful parameters only.

Extrapolations provided by physically realistic models usually result in better descrip-
tions of regions not covered by experimental data than do extrapolations done using
purely curve-fitting formulae. Extrapolations deviate from reality only moderately for
models based on sound theoretical physics. The more complicated a description, the more
unpredictable the extrapolation if the model is misused as a purely curve-fitting formula.

The modeling of the phases may have to be compatible with existing multicomponent
databases. That reduces the freedom in the selection of models and parameters. If the
arguments in favor of selecting a better model for the phase are strong enough to motivate
a change in the model used in the existing database, the recommended strategy is to
make two assessments, using the different models. This will simplify a future change of
the database.

For each phase one identifies the prototype crystal structure and other known structural
characteristics. It is also important to find phases with the same prototype in other systems,
in particular for intermediate phases. That will be discussed in more detail in section 6.2.5.
The possibility of the extension of a binary to a ternary or higher-order system should
always be taken into account.

 

Solubility and composition range

The liquid is often stable across the whole composition range. Even if there is a miscibility
gap, the same model should be used on both sides of the miscibility gap for the liquid
phase.

A terminal phase may also extend across the whole composition range if the pure
elements have the same crystal-structure type. If the terminal phases have the same
structure, they must be modeled as the same phase even if there is a miscibility gap
and even if there are stable intermediate phases in between the terminal phases. See
section 6.

 

===========
6.2.1.2

6.2 Modeling the Gibbs energy 169

All phases have some range of solubility, but, if it is small or no experimental data are
available, one may approximate any phase by a stoichiometric compound. However, for
example, in a semiconductor phase it may be important to model a composition range of
mole fraction 107°, whereas for another type of phase even a solubility of mole fraction
10-3 may be insignificant. A stoichiometric compound is much simpler to model than a
phase with a small composition range because in the former case the Gibbs energy is just
a function of temperature and pressure. Fortunately, the phase boundaries of the other
phases in equilibrium with the compound depend very little on the model selected for the
compound, if the model selection is a choice between a stoichiometric phase and a phase
with very small solubility. Thus this modeling can be changed later without significant
influence on parameter values of neighboring phases.

In ternary systems a binary stoichiometric phase may dissolve considerable amounts
of the third component. Then modeling as a line compound is the adequate procedure.
Also terminal phases may be treated as stoichiometric phases, considering the same
criteria. For example, graphite in many systems has no measurable solubility range and
is consequently treated as stoichiometric.

For intermediate phases with small solubility ranges, constituents occupying the same
sublattice are often distinguished as normal (major) constituents or as defects. There are
several models to handle this case, which will be described in section 6.2.5.

Phases with wide solubility ranges may have ordering inside their composition ranges.
This can be inferred from the structure type and determined by measuring the chemical
potential or activity as a function of composition. For example, many intermediate phases
have the B2 structure type and it is very likely that the properties of such a phase will
change rather drastically at the ideal composition even if the phase diagram does not
show any evidence of that. It must be kept in mind that a phase diagram shows only
relations between phases; little can be deduced of the properties of the phases themselves.

In Fig. 6.2 two examples of phase diagrams and their Gibbs-energy curves at a fixed
temperature are shown. In order to become a good assessor, it is important to develop a
feeling for the relations between the Gibbs-energy curves and the phase diagram. Note
that, even if a phase is stable only within a narrow composition range, the model often
defines the Gibbs energy over a much wider range. In Figs. 6.2(c) and (d) these Gibbs
energies are drawn for the whole range of compositions for the model of the phase. The
assessment of the Fe-Mo system is from Fernandez Guillermet (1982) and that of the
Cu-Zn system from Kowalski and Spencer (1993).

 

 

Thermodynamic data

The thermodynamic information for the various phases will be reviewed here mainly
in the context of the type of phase. A few general considerations can be made. If the
enthalpy of mixing versus composition curve deviates from a parabolic shape, for example
by having a sharp “V”-shape for a given composition, then strong LRO or SRO in the
mixture should be expected.

If the enthalpy of formation is measured at several temperatures and no significant
temperature dependence is observed, no excess heat capacity should be modeled, i.e.,

===========
170

Assessment methodology

 

 

 

 

 

 

 

 

 

 

 

  

 

 

 

 

3000 1 1 1 1 4400 1 1 1 1
1300-4
2500 1200-4
g g 11004
@ 2000 ®
2 § 10004
= &
3 3 2004
E 1500 2
etc © 8004
1000 700-4
\ 6004
500 500
Ao 02 04 06 08 10 sy 0 02 04 06 cB +0
Mole fraction Mo Mole fraction Zn
(a) (b)
o 04
Zh
a \
< ea\
5 5
-2
5 5 8
B-3 B 2
2 2
5 5 104
a 2
6 6 124
-5
144
-6 16
A % 02 04 06 08 10 sy 0 02 04 06 8 +0
Mole fraction Mo Mole fraction Zn
(c) (a)

Figure 6.2 Examples of phase diagrams, (a) Fe-Mo and (b) Cu-Zn, and the Gibbs-energy curves
of their stable phases: (c) Fe-Mo at 1673 K and (d) Cu-Zn at 673K. Note that the second-order
transition line between bec and B2 in (c) is not shown.

the Kopp—Neumann rule should be used (section 5.2.3). Note that defects or associates
contribute to the heat capacity because their fractions depend on temperature. In a few
cases there exist enough heat-capacity data to enable evaluation of the heat capacity
independently from those of the pure components for a solution phase.

A drastic change of the chemical potentials and the partial enthalpies over a small
composition range indicates an ordering. Ordering can depend on various types of species
and the most important type of species should be identified; it can be vacancies, anti-site
atoms, interstitials, or some combination of all the foregoing. If the phase may disorder
completely, like a B2 phase to A2 or an L1, phase to A1 structure type, one should use a
model that describes both the ordered and the disordered state with the same description;
see section 5.8.4.

In Fig. 6.3 four cases of integral and partial molar enthalpies versus mole fraction
curves are shown together with the second derivatives of the excess Gibbs energy. The
first three cases are related to the Redlich—Kister (RK) series described in section 5.6.2.1.

===========
6.2 Modeling the Gibbs energy 171

 

 

 

 

 

 

 

— T= Ge2.5R

T= Ge"4/4.0R
£
2
¥
Se
g
=
2
S

 

 

 

 

 

 

 

 

 

Mole fraction B Mole fraction B Mole fraction B Mole fraction B
2nd degree (regular) 3rd degree 6th degree (symmetric) Wagner-Schottky

Figure 6.3 Enthalpies of mixing and d?G,,/dx? calculated for a series of models.

For these figures the excess entropy is set to zero and thus the enthalpy of mixing,
excess enthalpy, and excess Gibbs energy are identical. In the first case the enthalpy
is described by a single RK coefficient; the second derivative is constant. In the sec-
ond case two RK coefficients are used and the second derivative of the excess Gibbs
energy changes linearly with composition. In the third case the first, third, and fifth
RK coefficients are used (sixth degree, symmetrical). The fourth case shows typical
curves of an ordered phase. For comparison with the RK cases also here d’G,,/dx? of
an ideal solution is subtracted from the calculated d?G,,/dx in order to get the second
derivative of the “excess Gibbs energy.” In this case the enthalpy and excess Gibbs
energy are different. The quantities H,,, H,, and Hg in this figure were chosen because
they can be measured experimentally; d?G,,/dx? is the “phase stability” introduced by
Eq. (2.17).

The curves of integral and partial enthalpies related to the RK description in Fig. 6.3 are
modeled as temperature-independent. With linearly temperature-dependent RK parameters
they can also be modeled as being temperature-dependent, but the magnitude and shape
change only moderately with temperature. For the ordered phase, however, magnitudes
and shapes of all three curves in Fig. 6.3 strongly depend on temperature. This is shown
by calculating them for two different temperatures, related to the ordering Gibbs energy

===========
172

6.2.1.3

Assessment methodology

of the phase. This drastic temperature dependence especially of d?G,,/dx* cannot be well
reproduced by a temperature-dependent RK description.

The conclusion from this figure is thus that, for phases for which the H,, versus x
curve at lower temperatures exhibits a sharp kink leading to step-like curves of the partial
enthalpy versus mole fraction plots, the RK formalism is not a good choice; instead, a
model like the Wagner—Schottky model is needed. The associate-solution model and the
partially ionic-liquid model behave similarly and may be alternatively chosen, if they are
better suited for the phase in question.

Estimation methods

If insufficient data are available experimentally, some estimation methods may be useful.
Theoretical approaches and semi-empirical estimates are important in selecting details of
the models to be used for each phase and for reducing the number of adjustable model
parameters. First-principles methods, total energies, and quantum and non-quantum-
mechanical Monte Carlo and molecular-dynamics atomistic calculations can be used to
compute thermodynamic properties useful for estimating model parameters.

Also trends of thermodynamic properties in series of related systems can successfully
be used for estimates, for example along a sequence in the periodic table. Several such
methods for estimating enthalpies of formation are reviewed by P.J. Spencer in a special
issue of Thermochimica Acta dedicated to computational thermodynamics (Spencer 1998).
Another useful source of data is the book by Bakker (1998).

An important estimate is given by the Kopp-Neumann rule for heat capacities (C,)
of compounds (Kopp 1864, Neumann 1865, Grimvall 1999). If there is not enough
information to evaluate both an enthalpy and an entropy value, it is usually better to
set the entropy value proportional to the enthalpy one, like a, = ay/T), where T) has
been estimated up to 3000 K for excess parameters by Lupis (1967) and Kubaschewski
et al. (1967). This estimation was proposed to depend on the melting temperatures of
the pure components and refined by Tanaka et al. (1996). Estimates for atomic volumes,
the standard entropy, the Lindemann melting rule, and relations between C, and thermal
expansion can be found in the chapter “Estimations and correlations” in Grimvall (1991).

Typical estimates using the position in the periodic table are those of Bakker (1998)
and Miedema et al. (de Boer et al. 1988) for the enthalpy of mixing in the liquid state
and for enthalpies of formation of compounds.

First-principles total-energy calculations, using DFT methods (see chapter 3), even
if done at OK, can also provide values for the formation enthalpies of real compounds
as well as for fictitious end members in the CEF. Formation enthalpies of several
compounds in different structures are available in databases compiled by Sluiter on
the website (http://www.www-lab.imr.edu/~marcel/enthalpy/enthalp.htm) and by Colinet
(2003). The alloy database prepared by the Widom group is available in a website
(http://alloy.phys.cmu.edu/) and provides also auxiliary values. It is important to keep in
mind that the values provided by first-principles calculations must be assessed critically
because the values depend on the methods and approximations used and they scatter
similarly to how experimental values do.

===========
6.2.2

6.2.3

6.2.3.1

6.2 Modeling the Gibbs energy 173

Systematic behavior is very useful information in modeling when no experimental data
are known. A comparison with similar but well-known systems can be a good guide in
certain cases (Shao 2001).

The gas phase

The gas phase is normally assessed by techniques different from those described in
this book. Thermodynamic descriptions of gaseous molecules can often be obtained by
ab initio calculations and from spectroscopic data. Several databases with multicomponent
gas data are available, for example from the SGTE (Landolt-Bérnstein 1999).

Modeling the liquid phase

The liquid phase usually exists across the whole composition range, but it may change
its type of bonding with composition and temperature. This can be observed in measured
enthalpies of mixing, for example. The type of bonding or the shape and magnitude
of the enthalpy of mixing versus mole fraction curve, ™*H' (x), should be considered
in the modeling. For mainly metallic or van der Waals bonding, which is direction-
independent, the regular solution is usually a good model. A variety of composition-
dependent effects, which do not need to be identified individually, may influence the
energies of the bonds and make them composition-dependent. To fit this behavior, usually
a polynomial (RK) series is used as the curve-fitting formula.

In some phase diagrams one may find very deep eutectics between two intermediate
phases, for example for the Mg—Zn system. It is unusual that the shape of the liquidus
curve differs significantly on the two sides of a congruently melting compound. If such
behavior is experimentally well determined to occur, one has to consider a model in
which #G/dx" of the liquid changes rapidly between the two sides, as can be deduced
from the Gibbs—Konovaloy rule, Eq. (2.50). Appropriate models are, for example, the
associate solution (5.7.1) and the partially ionic-liquid model (5.9.4).

Miscibility gaps

Liquid oxides are often treated with a model different from that used for the liquid metal
because many metal—-oxygen systems have wide miscibility gaps, but it is always possible
to find a continuous path from one side of the miscibility gap to the other in a binary
system by adding a third component. For example, the Cu-S system has a miscibility gap
between a Cu-rich liquid and a liquid with the average composition Cu,S. In the ternary
Cu-Fe-S system, however, the miscibility gap closes and thus a single model must be
used to describe the liquid phase already in the binary Cu—S system.

In some binary phase diagrams the liquidus is almost horizontal for a significant
composition range, for example for the Cu—Fe system. That is an indication of a metastable
liquid miscibility gap just below the liquidus.

===========
174

 

5.2,

6.2.3.3

Assessment methodology

Short-range ordering in liquids

A “V”-shaped enthalpy of mixing versus mole fraction curve is experimental evidence for
SRO and the apex of the “V” indicates the stoichiometry of an “entity” (sometimes called
a molecule or associate, but actually an atomic configuration that appears statistically
more frequently than others) or the ratio of the charges of the ions (compare this with
Fig. 6.3).

In the phase diagram the “V”-shaped enthalpy of mixing curve is often matched by
a congruently melting phase at the same composition. For example, see the Mg—Sn and
Pb-Te phase diagrams in Figs. 6.4(a) and (b), respectively.

If the mix F(x) curve is less pronouncedly “V”-shaped, several associates or several
different cations or anions may exist (e.g., Fe?*, Fe**, SiO} ” AI(OH), , and AL(OH);).
However, if these cannot be well characterized, the RK series may still be sufficient as a
curve-fitting formula.

If the bonding is less pronouncedly covalent or ionic, the “V”-shaped enthalpy may
be an indication of SRO, which can be represented by the quasi-chemical description
(section 5.7.2.1) which has a non-random entropy of mixing. Alternatively, the deviation
of the entropy from that of random mixing may be represented by excess-entropy terms
in the RK formalism. The latter method, however, is a curve-fitting method and does not
describe the excess heat capacity connected with the decrease in enthalpy of formation
due to the decrease of short-range ordering on heating. Usually very little is known about
excess heat capacities for liquids, but some may be deduced from enthalpy-of-mixing
measurements performed at various temperatures.

Freezing-point depression

Another useful item of information for modeling that can be extracted from the phase
diagram is related to the “freezing-point depression.”

 

-5

AH'9 (kJ mor)
1
3

 

 

700K,
-15
1300 K
-207 T T T T 1 -305 T T T T 1
oO 02 04 O06 08 1 0 02 04 O06 08 1
Mg Mole fraction Sn Sn Pb Mole fraction Te Te
(a) (b)

Figure 6.4 Calculated and experimental enthalpies of mixing for (a) Mg-Sn and (b) Pb—Te.

===========
6.2.4

6.2.4.1

6.2 Modeling the Gibbs energy 175

The width of the two-phase region close to the pure element is determined by the
“van ’t Hoff law,” i.e., the difference in composition is related to the enthalpy of melting
of the pure element. The depression of the melting temperature 7; of pure A on adding
B when there is no solubility of B in pure A is

AHes!! T,—T
RT. 7;

 

 

B= (6.1)

This can easily be derived from the equilibrium conditions, see for example Hillert
et al. (1998), p. 270. Equation (6.1) indicates that the freezing-point depression per mole
fraction of addition is independent of the alloying element. If experimental information
for the liquidus reveals a strong deviation from the slope given by Eq. (6.1), it is an
indication that one mole of added element corresponds to a different number of moles of
dissolved species (either one atom creates an additional species, e.g., an ion, or several
dissolved atoms aggregate into a single molecule or associate).

Modeling terminal phases

By terminal phases we mean phases that exist with a pure component of the system. The
solubility ranges of these phases may vary from very limited to extending across the whole
composition range. In most cases it is useful to describe the Gibbs energy of the terminal
phase for the whole composition range even if the real phase has limited solubility.
If the two elements in their stable states have different crystal structures, then the Gibbs
energy of a metastable state (lattice stability) of one of the elements must be related to
that of its stable state. These relationships form a unary database. A first version of it
is included in Dinsdale (1991); there is an update in Landolt-Bérnstein (2002). Usually
the unary dataset is provided without charge in the web pages of agencies producing
databases.

Most of the pure elements have an fec, bec, or hep lattice. Gibbs energies for these
structures are collected in Landolt-Bérnstein (2002) for almost all elements. For phases
like graphite and diamond the solubility of other elements is usually very small and often
can be neglected.

Substitutional solutions

Elements that dissolve substitutionally in a terminal phase can often be described with the
RK formalism. If the two elements have the same crystal structure, complete solubility
across the whole composition range may exist (e.g., Cr-V and Ag—Au). In other systems
differences in atomic sizes (Ag—Cu) or in chemical properties create miscibility gaps
or intermediate phases are formed and interrupt the solubility range, as in Cr-Mo and
Fe—Mo. If there are many intermediate phases, one may check the modeling of the
terminal phases during the assessment by calculating the metastable phase diagram with
just the terminal phases (as discussed later in section 6.2.4.4).

In other systems the components may form ordered phases based on the same lattice
as the terminal solution (see section 6.2.4.3).

===========
176 Assessment methodology

6.2.4.2 Interstitial solutions

The typical case of an interstitial solution is carbon in steels. Iron can be ferritic, i.e., has
a bcc lattice, or austenitic, i.e., has an fcc lattice. When carbon is dissolved in steel, it will
not substitute iron on the lattice sites but occupies interstitial sites between the Fe atoms.
In bec there are octahedral interstitial sites in the middle of the edges and additionally
at the centers of the planes of the unit cell and there are three times as many interstitial
sites as matrix atom sites in the bec lattice. Thus the sublattice model (Fe, Cr, ...),
(Va, C, N);, where Va denotes vacancies, is used.

In fcc there are two kinds of interstitial sites, tetrahedral ones surrounded by four
matrix sites and octahedral ones surrounded by six matrix sites. In a unit cell of fec
containing four matrix sites, there are eight tetrahedral and four octahedral sites. Carbon
and nitrogen dissolve in the octahedral sites only, so the model used for austenite is thus
(Fe, Cr,...),(Wa, C, N),.

The hep lattice is also very common for metallic phases. There is also one
octahedral interstitial site per matrix atom. Nevertheless, an old modeling with only half
the interstitial sites is still used. There is no significant difference when it is applied to
dilute interstitial solutions, but it performs worse for the cases in which more-concentrated
interstitial solutions are stable (O in Ti, Zr, and Hf). This old description was deduced
from carbides like W,C and Mo,C that were assumed to be strongly ordered. However, for
these carbides the crystal structure is described as 50% of all octahedral sites statistically
occupied by C (Schubert (1964), p. 267).

There may exist intermediate phases that seem to correspond to “full” occupation
of the interstitial sublattice; however, they may be ordered phases, wherein the sym-
metry is diminished and a single Wyckoff position of empty sites of the pure solvent
phase splits into different sites, only one of which is occupied. In the dilute solu-
tion the symmetry cannot yet be diminished and the number of empty sites is the
full number of sites in the Wyckoff position of the pure solvent structure. For dilute
solutions, therefore, this has to be taken as the number of sites of the interstitial
sublattice.

 

As an example the hexagonal-close-packed (hep, A3, Mg-type) structure shall be
considered. Its crystal structure can be described as
space group: P6,/mmc
2 metal atoms (Me) in 2(c) (424) (243

334) \334

2 octahedral voids (Va,X) in 2(a) (000) (004)

By reducing the symmetry, the two-fold site of the octahedral voids can split into two
independent one-fold sites:

space group: P3m1

2 metal atoms (Me) in 2(d) (42x) (343)
1 octahedral void (Va,X) in I(a) (000)
1 octahedral void (Va,X) in 1(b) (003)

===========
 

6.2 Modeling the Gibbs energy 177

In the Cr,C structure the 2(d) position is occupied by Cr and the 1(a) position by C; the
1(b) remains empty. From the Cr,C structure it was deduced that in hep only half of the
octahedral voids can be occupied by interstitials and a ratio of 2:1 was set for the sites
of the matrix and interstitial sublattice, respectively. In dilute solutions, however, that
cannot be true, since the diminution of symmetry on going from space group P6,/mmc
to P3m1 can take place only if enough interstitials are present to interact and expand the
lattice at the (a) positions, i.e., if chemical ordering can occur.

Fortunately, this difference is mainly theoretical and the two selections of the sublattice
site ratio in dilute solutions give virtually the same Gibbs energy versus mole fraction (G(x))
curve, if the parameters Gy"? , differ just by a term RT In(2) in the two descriptions.

Similarly, in the bec (A2, W-type) structure there are three octahedral voids per matrix
atom. After tetragonal distortion, as happens in martensite, one third of these sites is
enlarged, the other two thirds are shrunk. For dilute solutions (ferrite) the ratio 1: 3 must
be taken for matrix to interstitial sites. At higher solute concentrations, ordering may
occur (martensite), splitting the interstitial sublattice into two, with one and two sites per
matrix site, respectively. There are also tetrahedral interstitial sites in bec and often it can
be difficult to know which sites are occupied.

The CEF needs a parameter Gy,,.y, for the pure solvent and a parameter Gy,,.x for the
very fictitious case of fully occupied interstitial sites. Interaction parameters ’Lyy,.y..x May
be used to adjust the composition dependence of the Gibbs-energy description. Where the
homogeneity range is restricted to dilute solutions, the sum Gyge.vy + Oy "LMeva,x iS the
only independently adjustable parameter. If more than one of the terms of this sum are
used, all except one can be chosen arbitrarily. Nevertheless, it may be necessary to use at
least two parameters, since using Gy... alone may describe the Gibbs energy well in the
range of homogeneity of the phase, but additionally describe another range of stability,
where the phase is not stable in reality. In that case for Gy,.x an arbitrary and large
enough positive value or linear function of T is chosen and °Ly4..v.,x is used to adjust the
Gibbs energy in the range of homogeneity.

 

Ordering phenomena

Adding elements to a terminal phase can change its crystal structure. For example, the
site occupation of Al in an Fe bec lattice can change from random A2 to ordered B2
with addition of Al. This ordering is of “second order” since it appears gradually and
there is no two-phase region between the A2 and B2 phases, as shown in Fig. 6.5. In
the same diagram the ferromagnetic transition is shown; this is also of second order. The
low-temperature DO, phase was not modeled in the dataset used to calculate Fig. 6.5.

For other types of ordering like the y’ phase in the Ni-Al system, where the occupancy
of the fcc lattice changes the structure from the disordered A1 to the ordered L1, type, the
ordered phase appears as a separate intermediate phase in the phase diagram. However,
as described in section 5.8.4, both the ordered and the disordered phase can be described
by the same Gibbs-energy function.

There are many “families” of structures that are connected by reduction of symmetry
and it is important to have that in mind when selecting models.

 

===========
178

6.2.4.4

 

Assessment methodology

 

 
  
   

 

 

 

 

 

 

 

S 1500-)) A2 para L
2
5
3
oS
Ee
© 10004 B2 para | L

la2

lterro: |

N
~
500 +

A °% 2 04 06 08 10
Mole fraction Al

Figure 6.5 The Al-Fe phase diagram with the second-order transition between disordered A2 and
ordered B2 marked by a dotted line. The second-order transition between paramagnetism and
ferromagnetism is marked by a dot-dashed line. Where the two curves meet, there may be a
change to a first-order transition, but that is not included in the dataset used for this diagram.

Metastable extrapolations of terminal phases

When the terminal phases do not extend across the system, either due to a miscibility
gap or due to intermediate phases, it is still interesting to extrapolate the metastable
two-phase field between the liquid and the terminal phases using the assessed parameters.
There should not be any strange curvatures or both maxima and minima of this two-phase
field. If such behavior shows up in the calculation, it is probably due to there being too
many coefficients in the RK series for one or both phases. In Fig. 6.6 the metastable
extrapolation of the terminal phases is shown as dashed curves for the Al-Cr and Fe-Mo
phase diagrams.

These checks by use of metastable diagrams were proposed and done by J.J. van Laar
as early as 1908 (van Laar 1908a, 1908b). His very pioneering works were reviewed
recently by van Emmerik (2005).

These checks were used as standard procedure in the assessments performed by
Larry Kaufman (2002) and Himo Ansara (2001) and are nowadays largely used by con-
structors of multicomponent databases. Some metastable extrapolations can be checked
by experiments such as those done by Perepezko et al. (Perepezko and Wilde 1998).
These results are especially useful for application in microstructure simulations such as of
phase fields, since metastable regions are very often scanned, and the presence of model
artifacts can be very detrimental to the calculations.

Terminal phases in quasibinary systems

A quasibinary system is a system with three components that behaves exactly like a
binary system of two components. A typical case is the mixing of two oxides like MgO
and CaO. The solid phases in this system have the same B1 structure type and the liquid

===========
6.2 Modeling the Gibbs energy 179

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

2200 ! ! ! ! 3000 ! ! ! !
2000-4 b
18004 b 2500 4 liquid L
| 16004 bee + 6
© 14004 r  & 2000+ r
2 2
® 12004 |
3 3
= 1000-[2 [E1500 r
© 8004 t oF
6004 r 1000 + F
400 4 \ +
200 T i T T 500 T T T T
A o 02 04 06 08 1.0 A o 02 04 06 08 10
Mole fraction Cr Mole fraction Mo
(a) (b)

Figure 6.6 Metastable extrapolations of terminal phases in two systems: (a) Al-Cr and

(b) Fe-Mo. For the Fe-Mo system the bee phase should form a continuous solid solution at high
temperature if there were no intermediate phases and there is a metastable miscibility gap at low
temperatures. The latter is indicated by the shape of the liquid/bec two-phase region.

phase is completely miscible between the oxides, but neither phase has any appreciable
range of solubility in terms of the amount of oxygen. This makes it possible to treat
the MgO-CaO system as a binary one and ignore the phases outside the composition
range defined by the two oxides. For the thermodynamic definition of components, the
condition No = Nyg + Nc, reduces the number of independent components to two.

The essential concept for quasibinary systems is that the endpoints of the tie-lines
between the phases must be inside the section defined by the compounds selected as
quasibinary components. One of the phases of a quasibinary system may exist outside this
section, but, if there exists another one also outside, tie-lines between these two phases
usually are not exactly in the section. Then the system may be only approximately a
quasibinary one.

There are many systems that are treated as quasibinaries although they do not have
the tie-lines exactly in the plane. This is, for example, the case when an element may
have several valencies, like Fe. The mixture of the two oxides CaO and FeO is thus not a
quasibinary system since there are always some Fe** ions present. The CaO-FeO phase
diagram is an isopleth but can be called a “pseudobinary” system since the endpoints of
the tie-lines will be slightly outside the composition plane defined by the compounds.

Since it is not uncommon to assess quasibinary systems and quasiternary systems,
some features of these are discussed below. It is possible that the liquid, or an intermediate
phase, may be stable outside the quasibinary section, but there may be stoichiometry
restrictions such that, in any two-phase equilibrium, only one of the phases can exist
outside the quasibinary section. Such a constraint ensures that there is always one tie-line
between the two phases inside the quasibinary section.

In a calculation using “double-precision” numbers (about 14 significant digits) a
deviation of the mole fraction by 2 x 10~'* from the section is treated as falling outside

===========
180

Assessment methodology

the section. This may give confusing results. To avoid this problem, the quasibinary
system may be calculated not by giving conditions between mole fractions to select the
line of section in the ternary system, but either by defining the quasibinary components
as the two components of a binary system or by selecting another condition in the ternary
system. In many oxide systems defined by three elements, it is sufficient to fix the
chemical potential of O to a moderately negative value. So long as it is not too negative,
no reduction of the oxides will take place and at higher temperatures the calculation will
remain in the quasibinary system until the gas phase appears. In a few cases this method
might be not applicable, but, where it can be used, also systems that are not strictly
quasibinary, but only approximately so, can be calculated.

One may be surprised by how some thermodynamic properties behave in a quasibinary
solution phase. In the Al,O,-Y,O, system the corundum phase is stable throughout the
whole range between the quasibinary components. The physically reasonable modeling
for this solid solution is (AP*,Y3*),(07>)s. If Al,O; and Y,O; are defined as components,
Ho is kept constant (somewhere between —10000 and —100000J mol"), and the activity
of YO, in the corundum phase is calculated as a function of the mole fraction of Y,0;,
one obtains the curve in Fig. 6.7 even if there are no interaction parameters in the model.
For an ideal substitutional model one would expect the activity to be equal to the mole
fraction given by the diagonal, shown as a dashed line, in this figure.

The reason for this is that the activity of YO; in phase ® is defined as

= explo, —"#y20,)/(RT)] (6.2)

 

The p-value of a species is the sum of the p-values of the atoms present in the
species. Consequently the activity of the species is the product of the activities of the
atoms contained in the species. Thus the better choice for the quasibinary components

   

1.0 L L L 1

 

0.94 L
0.8 + . r
074 L
064 L
054 : r
0.44 L

Activity YO

0.34 b
0.24 b
0.14 . b

0 T T T T
A ° 02 04 06 O08 10
Mole fraction YO,

 

 

 

Figure 6.7. The activity of Y,O, as a function of the mole fraction of Y,O, for the sublattice
model (A1,Y),O, without any interaction parameters.

===========
6.2.5

6.2 Modeling the Gibbs energy 181

is AlO,; and YO, ;. The chemical potential of Y,O, is twice that of YO, ; and thus the
activity of Y,O, is the square of the activity of YO, ;. A similar problem would arise if
the species Cu, and Ni, in the Cu-Ni system were defined as components and the activity
of Cu, were plotted against the mole fraction of Cu, for the fec (Cu, Ni) solid solution.
Of course, in the Cu-Ni system there is no reason for such a definition of components,
but it illustrates the problem.

Modeling intermediate phases

The term “intermediate” phases means all phases that do not extend to the pure compo-
nents of a system. It includes phases with no or little solubility and phases having very
wide ranges of composition. Some of these phases may have the same lattice as is found
also for terminal phases; for example, an intermediate phase with the bec lattice appears
in the Al (fec)-Cu (fcc) system. But often the intermediate phases have more complicated
crystal structures. As mentioned several times before, the identification of the structure
type of a phase is the first step in the modeling. Crystallography gives information about
the different sublattices and, by comparing with other phases with the same structure
type, one can obtain important information about the modeling. If a phase with the same
structure type has been modeled already, that is very useful information. However, phases
with the same structure can also have mixing on different sublattices, depending on the
relative sizes of the different atoms.

In some systems many intermetallic phases may have to be considered in the modeling,
for example o, p, and Laves phases. A good review of these can be found in the
proceedings of the 1996 Ringberg workshop (Ansara et al. 1997a).

(Fe, Ni. ..)io(Cr, Mo, . ..)4(Cr, Fe, Ni, Mo, . . -)ig (6.3)

Even with this simplified model there is a large number of end members that must be
determined from the scattered and insufficient experimental data. As an approximation,
it has been proposed that one should consider the coordination number, i.e., the number
of bonds at each site, and treat those in the first sublattice as being part of an fec phase
because the atoms there have 12 bonds, those in the second as a bec phase since they have
14 bonds, and those in the third also as a bec phase since the number of bonds is about
14, although they are of slightly varying length. (In reality a bee structure has just eight
nearest neighbors, but the six next-nearest neighbors are at almost the same distance,
making it 14 bonds.) In fec the six next-nearest neighbors are much further away than
the 12 nearest neighbors. Thus an end member like Fe;y)Mo,Ni;, could be estimated as

Moni = 10°GES +4°GRE + 16°GKe (6.4)

 

One should also consider systems other than the particular one to be modeled, in
order to take into account what will happen when the model is used for higher-order
systems. The same element may dissolve in different sublattices of the same phase when
alloyed with different elements. For example, the o phase can dissolve more V than
considered according to the model above in the Ni-V system. This can be handled by

===========
182

6.2.5.1

Assessment methodology

considering V to dissolve also in the first sublattice, although that increases the number
of end members.

Some intermediate phases with the structure types L1,, L1), and DO,, can all disorder
to the Al structure type; the structure types B2, D0;, L2,, etc. can disorder to A2 and
D0j9; By etc. disorder to A3. When an intermediate phase can transform to a disordered
state, it is important to use the same model both for the ordered and for the disordered state
of this phase. The modeling for such cases is described in more detail in section 5.8.4.
For ordered phases derived from bec, fec, or hep but with a complicated structure and
which never transform directly into a disordered state, it is recommended that one should
model these phases as different from the disordered phase. A typical example is the DO,,
structure.

Phases with order—disorder transitions are commonly described as a sum of two
Gibbs-energy expressions, one describing the disordered state and depending only on the
mole fractions of the constituents, the other depending on the site fractions describing
the ordering. This partitioning is described in section 5.8.4.2 and, in a slightly modified
way, it can be applied also to phases that never undergo disordering.

Crystal-structure information

The structure information is sometimes too complex to be modeled in detail. If a phase
has four or five sublattices, it may be necessary to reduce this to two or three because
there might not be enough experimental information to determine the necessary model
parameters. The number of parameters for the “end members” of the phase is obtained
by multiplying together the numbers of constituents on each sublattice. There are seldom
enough data to fit more than two end members for a binary phase.

In most compounds two (or more) different atoms occupy crystallographically different
positions and this may give an enthalpy curve with a very sharp minimum at the ideal
composition. In other cases the intermediate phases may be considered as substitutional-
solid solutions, which could have a wide composition range if not limited by other phases.
The crystal structure is again the primary information for the modeling.

The crystal-structure data should also be checked for information on whether a range
of homogeneity is created by anti-

Good crystal-structure determinations by X-ray diffraction can even identify some
crystallographic positions to be occupied randomly by different atoms and can even
give values of the site fractions of the different constituents on these positions by
Fourier synthesis from the intensities of the various reflections of the X-ray pattern.
An example of such a determination is the paper of Bonhomme and Yvon (1996) on the
Mg,,(Y.Mg),Y phase. Also partially occupied sites can be detected and modeled as a
random distribution of atoms and vacancies. Interstitial atoms are also a distribution of
vacancies and atoms on the same sublattice, but here vacancies are the major constituent
and in the ideal compound these sites are not counted (Joubert 2002).

Similarly to the distinction between substitutional and interstitial solid solutions, the
site fractions of vacancies can be determined by pycnometric density measurements
connected with X-ray lattice-parameter measurements. The volume of the unit cell times

 

 

  

ite atoms, vacancies, or interstitials.

===========
6.2.5.2

6.2 Modeling the Gibbs energy 183

Avogadro’s number divided by the pycnometrically determined volume of one mole of
atoms gives the number of atoms per unit cell. If, within the experimental error, this
is less than the number of sites, the difference must be interpreted as vacancies. The
presence of more atoms than lattice sites must be interpreted as the existence of interstitial
atoms. Thus, if the range of homogeneity of the phase is not too small, it is possible by
use of density measurements combined with X-ray-diffraction data to distinguish whether
the deviation from ideal stoichiometry is due to the formation of anti-structure atoms,
vacancies, or interstitial atoms.

In some cases, if the atomic volumes are very different, a solid solution may be formed
by pairs of small atoms randomly replacing the large atoms. This happens in the TbCu,
structure type (Buschow and van der Goot 1971), which is the CaCu; type with 85% of
the Ca positions occupied by Tb atoms and 15% by pairs of Cu atoms.

If the composition dependence of density or lattice parameters is not available, the
type of solution to be modeled has to be selected by estimation, considerations involving
atomic volumes, or comparison with similar phases.

In modeling sublattices after the crystal structure has been determined, all sites of a
set of equivalent positions have to be treated equally. This excludes a modeling in which
only one site of a three- or four-fold position can be substituted. The only exception is
when a group of atoms can be considered as a single molecule.

In any other case, when a description treats atoms of equivalent positions to be in
different sublattices, it may facilitate reproduction of the experimentally observed range
of homogeneity, but the crystallographic interpretation of the sublattice is totally lost.
Therefore such a “modeling” would be a misuse of a formalism, using it as a mere
curve-fitting formula with physically meaningless coefficients.

The crystal structure gives the ideal occupancy for a stoichiometric compound and
might not describe the stable composition range, even if the crystallographic information
indicates that there is mixing on several sublattices. If the stable composition range
is wide, one may have to consider constituents in other sublattices rather than ideal
occupation by this constituent. Information from the same phase in other systems may
provide information about the mixing on the sublattices. See for example the modeling
of the j. phase discussed in Ansara et al. (1997a) and Joubert and Feutelais (2002).

Compatibility with models used in databases

The model for the o phase recommended by Ansara et al. (1997a) and adopted in this
book distinguishes the five different Wyckoff positions as three different sublattices with
10 (8 +2), 4, and 16 (8 +8) sites, respectively. See also the case study in section 9.3. This
recommendation is based on the coordinations of the five Wyckoff positions. In order
to describe the whole composition range of o without considering Cr and V on all
sublattices, a model for the o phase with 8, 4, and 18 (8 +8 +2) sites is frequently used
in databases. In new assessments one should use the recommended model, but it may
be necessary to fit also the old model for the sake of backward compatibility. When a
sufficient number of revised assessments is available, it may become possible to remove
the old model of the o phase.

===========
184

 

Assessment methodology

One should always consider how the phase extrapolates into higher-order systems.
This may demand the use of more sublattices or consideration of more constituents in a
sublattice than needed for a particular binary system. For example, the Laves phase C15
can dissolve Cr in the second sublattice in HfCr, and Cr in the first sublattice in CrTa,. In
the ternary Cr-Hf-Ta system one thus has to model Cr on both sublattices and therefore
it should be included in the binary assessments.

Thermodynamic information

The heat capacity of a compound for which there are no measurements can be estimated by
applying the Kopp-Neumann rule, see section 5.2.3, that it is the stoichiometric average
of the heat capacities of the pure elements.

The coefficients a; in Eq. (5.2) describe the heat capacity. They can be adjusted only if
the heat content H(T) — H(298 K) or the heat capacity C,, (section 4.1.1.2) has been mea-
sured. However, heat-content measurements allow maximal adjustment of a, and a3. The
coefficients a4, as, etc. can be only determined by C,, measurements. The only alternative
is to use semi-empirical estimates, for example after Kubaschewski and Unal (1977).
Chase er al. (1995) recently proposed expressing C, by the adjustable linear function
a, —2a;T and the Debye function, characterized by the Debye temperature ©,. Instead
of the Debye function, the Einstein function, characterized by the Einstein temperature
@,, may be used. Equation (5.2) does not enable one to calculate Debye or Einstein
functions, but, since Calphad-type calculations are meaningful only at temperatures at
which reactions toward equilibrium are possible, only the transition from the Debye or
Einstein function to the Dulong—Petit function is of interest. This can be expressed by the
term asT~'. Low-temperature heat-capacity measurements are of interest when integrated
to standard entropies.

In some cases there are peculiar shapes of the heat-capacity data. This can be due
to magnetic transformations, see Fig. 5.3(a), a drastic change of constituent fractions,
see Fig. 9.8(b), later, or some internal order—disorder transformation. Another common
feature is that the heat capacity of a compound increases drastically just before it melts.
This increase of heat capacity is often due to the formation of small amounts of liquid in
the sample, so such data should not be included in the model of the compound.

Further thermodynamic data besides heat capacities are measurements of the enthalpy
of formation at 298.15 K, Hyog, and calculations of standard entropies S39, from low-
temperature heat-capacity data. Entropies can be fitted independently of heat capacities
also to phase-diagram data.

Even if there are no measured values for some thermodynamic quantities, one must
check explicitly that the assessed values are reasonable, since it is possible to have good
fit to all experimental data but still unphysical values of heat capacities, for example. Both
the heat capacity and S,o. of a compound must always be positive. It is possible to obtain
a very good description of all experimental data in a system but still have the wrong
value of Sg. For example, an assessment of all data on the AI-B system (Ansara 1998b)
gave a nice phase diagram, but for the compound AIB, there resulted a negative value of
Sy9g = —1.79 Jmol” 'K~'. This was corrected in a reassessment by Mirkovic et al. (2004).

 

 

===========
6.2.5.4

6.2.5.5

6.2 Modeling the Gibbs energy 185

Further thermodynamic information may be based on chemical potentials determined
by emf or vapor-pressure measurements. This information is more similar to phase-
diagram data. Thus its value as supplement to phase-diagram data is not as great as that
of enthalpy data.

Stoichiometric phases

For stoichiometric phases a Gibbs-energy function like Eq. (5.2) can be adjusted to the
available experimental data. If the phase is magnetic, additional parameters are needed.
If the Gibbs energy of a phase is determined only in a narrow range of temperatures and
no enthalpy values are measured, for the Gibbs energy AG = AH — T- AS only a single
coefficient or a single (linear) combination of coefficients can be adjusted.

One of the two coefficients AH and AS (a) and —a, in Eq. (5.2)) may be estimated,
for example by setting AS proportional to AH, an empirical correlation first proposed by
Lupis (1967) and Kubaschewski et al. (1967) and later refined by Tanaka et al. (1990).
For a stoichiometric phase ® = A,,B,,, partial Gibbs-energy measurements in a special
case are equivalent to a direct measurement of its integral molar Gibbs energy. If the
phase is in equilibrium with one of the elements (A) in nearly pure state, the partial
Gibbs energy 424 = 0 and, from the condition GA»®» = m- ji, +n- tg it follows that
GAn®: = n- wy. The molar Gibbs energy here is defined for one mole of A,,B,,,
moles of atoms of ®.

 

The Wagner-Schottky model

The Wagner-Schottky model (Wagner and Schottky 1930, Wagner 1952) was the first
model using the crystallographic positions of different atoms in sublattices. It was devel-
oped for binary intermediate phases with small homogeneity ranges. The “ideal phase”
is defined to have on each sublattice only one occupant. In the real phase there are
also defects on the sublattices. The Wagner—Schottky model contains the following
simplifications.

1. The defects are always so dilute that interactions between them can be neglected and
the Gibbs energy of formation of the defects inside the stability range can be treated
as independent of composition.

2. On both sides of stoichiometry the defect with lowest Gibbs energy of formation is
the only one considered from among the three types (anti-structure atoms, vacancies,
and interstitials), since the others will exist only in smaller amounts at equilibrium
and thus can be neglected.

3. Random mixing of the constituents, separately on each sublattice, is assumed.

As always, one should consider crystallographic information when using this model,
as described in section 5.8.2.3.

The CEF may be interpreted as a generalization of the Wagner—Schottky model,
dropping the first two of the three conditions above. Libowitz (1971) was the first to use
interaction parameters in the Wagner—Schottky model.

===========
 

6.2.5.7

Assessment methodology

Phases with order—disorder transformations

The structure type of an intermediate phase may be an ordered form of the bec, fec,
or hep lattice. In some cases the disordered phase is also stable in the system, but in
other cases only the ordered form exists as a stable phase. Even if the phase does not
undergo disordering inside the binary system, this may happen in a ternary or higher-order
system, so one should use a model that can describe the order—disorder transition. See
section 5.8.4 for more information.

Carbides and nitrides

Two important kinds of carbides and nitrides were described in section 6.2.4.2, the “MC”
and “M2C” types, which can be modeled in the same way as an interstitial solution of
carbon or nitrogen in fee and hcp, respectively. There are many other phases having
preferred sites for different kinds of atoms. If the atoms are very different, like metal and
non-metal atoms, they usually keep strictly to their respective sublattices, but sometimes
there is more than one type of sites for the metallic elements. For example, in the “M23C6
carbide,” of which Cr>3C, is the prototype, two of the metal sites can accommodate bigger
atoms more easily. These sites are preferred by W and Mo and it is almost impossible to
dissolve more W or Mo than can be accommodated by these two sites. A model for this
phase is thus

(Cr, Fe, ... )y,(Cr, Fe, Mo, W, ... Cg (6.5)

This gives a maximum solubility of W and Mo and the parameter °GY2),.. for the “end
member” Cr,,W,C, can be used to determine the actual solubility of W. In this model

Fe is considered to enter all metallic sublattices. The phase diagram in Fig. 6.8 for the

     

   
    

ZX

IX oO 0.2 04 0.6 08 1.0
Mole fraction C

Figure 6.8 A ternary isothermal section of the Fe-Cr-C system at 1000°C showing the large
solubility of Fe in the M23 and M7 carbides. Note that cementite, which is metastable in the
binary Fe-C system, is stable in the ternary system.

===========
6.2.5.8

6.2 Modeling the Gibbs energy 187

C-Cr-Fe system shows that the M23 carbide can dissolve considerable amounts of Fe,
which makes it easy to determine the parameter °GZ2..c for the metastable “end member”
Fe,;C,. The model contains two additional end members, Cr, Fe,C, and Fe,,Cr,C,, which
represent compositions inside the stability range of the phase and thus behave almost
like interaction parameters in the model. The experimental information is usually not
sufficient to determine individual values for all these parameters, so often their enthalpies
of formation are set equal.

Tonic crystalline phases

For phases with strongly ionic behavior, mainly oxides, sulfides, chlorides, etc., the
compounds often have no compositional variation. The reason for this is that the elements
usually have fixed values of their valencies and the phase must remain electrically neutral.
A variation in composition is usually due to vacancy formation and to the fact that
some elements may have multiple valencies. One example of this is the wustite phase
in the Fe-O system: Fe can have two valencies, +2 or +3. In the wustite phase the
oxygen ions form a cubic-close-packed (fcc) lattice with the iron ions in the octahedral
interstitial sites. The model used for wustite in an assessment by Sundman (1991a)
is (Fe?*, Fe*+, Va),(O7-),. The vacancies are necessary in order to keep the phase
electrically neutral.

Another more complicated case is the spinel phase, see Fig. 6.9(b). In the MgO-
A1,O, system the ideal stoichiometry is Al,MgO,. In this structure the O?~ ions form a
cubic-close-packed (fcc) lattice; the Al®* ions occupy half of the octahedral interstitial
sites and the Mg?* ions occupy one eighth of the available tetrahedral interstitial sites.
However, both Al and Mg can be at the “wrong” sites. If some Al** ions according to the
ideal formula are replaced by Mg”*, the electro-neutrality condition requires additionally

  

(b)

Figure 6.9 The C15 Laves phase (a) and H1, spinel (b) structures. From the Crystal Lattice
Structures web page (http://cst-www.nrl.navy.mil/lattice).

===========
188

Assessment methodology

AlVa

  

A MgMg MgAl

Figure 6.10 A prism representing the end members of the spinel phase. The small triangle,
shaded gray, inside the prism represents all possible neutral combinations of constituents.

the occupation of some of the remaining octahedral interstitial sites. A model used by
Hallstedt (1992) is

(Mg**, AP*),(AP*, Mg**, Va),(Va, Mg**),(O-), (6.6)

The model for the spinel, without the third interstitial sublattice, can be visualized as
the prism in Fig. 6.10. The front triangle represents all combinations of Mg?* in the first
sublattice with all three constituents of the second sublattice; the rear triangle represents
all combinations of Al’* in the first sublattice with all three constituents in the second.
The small triangle inside the prism marked with symbols at the endpoints represents the
neutral combination of the constituents. The front corner of this triangle is the “normal”
spinel. The point on the bottom line of the rear triangle represents the “inverse” spinel,
which is found e.g., in magnetite (Fe;O,). The point on the sloping side of the rear
triangle represents the structure known as ‘y-alumina.

The vacancies on the second sublattice are necessary in order to maintain
electro-neutrality when the spinel is off stoichiometry by virtue of the presence of excess
AP*. The third sublattice is mainly vacant. In principle both Mg** and Al** ions should
be considered on this sublattice. Since their site fractions remain very small, a valid sim-
plification is to consider only one kind of ions. There are 12 end members in this model,
most of which are charged. Only six electro-neutral combinations of these end members
can be assessed. Thus six of the charged end members can be chosen arbitrarily and the
six others used to define the six independent electro-neutral combinations. The number
of independent parameters shall be further reduced to enable their evaluation from the
available experimental information. If the third sublattice is ignored, three independent
reciprocal relations can be written as below:

Al’: Al +Mg’: Mg” = Mg’: Al’ + Al: Mg”
Al’: Mg” +Mg’ : Va" = Mg’: Mg” +All’: Va"

Al’: Va" +Mg!: Al” = Mg’: Va" +Al': Al”

===========
6.2.6

6.2 Modeling the Gibbs energy 189

A reasonable estimate is to assume that the reciprocal reactions should have zero
AG because the mean occupation on each sublattice remains unchanged during these
reactions. This reduces the number of parameters to be optimized by three. The reciprocal
reactions are represented by the square surfaces of the prism in Fig. 6.10. There are
three such surfaces characterized by the triangle sides Al’-Mg”, Mg’—Va", and Va"—Al".
The remaining three parameters can now be attributed to the normal spinel (Mg’ : Al’),
the inverse spinel (Al’ : Mg” + Al’: Al")/2 and the y-alumina (5 Al’ : Al” + Al’: Va’)/6.
The y-alumina parameter serves also as end member for deviations from stoichiometry
caused by excess Al,O.

If the third sublattice is assumed to be occupied by Mg”*, one can draw a similar prism.
A reasonable estimate for simplification may be to relate all six end members of this prism
to the corresponding ones of the prism for Va" (vacancies on the third sublattice) by
adding the same value, which must be large and positive in order to model the difficulty
of occupation of this sublattice due to the narrowing caused by the atoms of the first
sublattice. This prism itself does not contain any electro-neutral combination of end
members, but the combination (Mg’ : Mg” : Mg’” +Mg’ : Mg” : Va"”)/2 is electro-neutral
and independent of the already-defined three electro-neutral end-member combinations.
It serves well as end member for deviations from stoichiometry caused by excess Mg**.
There are many papers on modeling ionic phases, for example Liang et al. (2001),
Gueneau et al. (2002), and Grundy et al. (2006).

Semiconductor compounds

There is no doubt that a thermodynamic database for semiconductor materials will be
very useful for the future development of electronic devices. Simulating the combination
of different elements to optimize the properties on the computer is much simpler than the
normal trial-and-error method.

The most commonly used semiconducting phases have the diamond (A4) or the
zincblende (B3) structure type. These have the same atomic positions, but A4 belongs to
the higher-symmetry space group Fd3m, for which all sites belong to the same Wyckoff
position, (8a), whereas in B3, space group F43m, these sites form two different Wyckoff
positions, (4a) and (4c). The B3 compounds consist of nearly perfectly ordered compounds
from the third and fifth groups of the periodic table or from the second and sixth groups.
Deviations from the ordering of magnitude 10-7 to 107° can be treated as defects by
the Wagner-Schottky model. If the number of electrons of the defect species deviates
from that of the matrix atom, the defect works as doping. To compensate for its electric
charge either a nearly free electron or an electron hole (a missing electron in an ideally
completely filled electron band) is formed. These electrons or holes obey the Fermi-Dirac
statistics and do not contribute to a mixing enthalpy as in Eq. (2.11). Thus, in the CEF,
they must not be treated with extra sublattices; see section 5.10.2.

To find the best routes for the production of B3-phase semiconductors, phase-diagram
calculations regarding solid solutions of group-3 elements on one sublattice or of group-5
atoms on the other one are very important. Owing to the strongly directed bonding of these
phases, the diffusion rate is extremely slow and it is nearly impossible to homogenize the

 

 

===========
190

6.2.7

6.2.8

Assessment methodology

material by annealing once it has crystallized. Thus, for growing single crystals or epitaxial
films from liquid, the composition of the liquid has to be chosen to be in equilibrium with
the desired composition of the material to be grown. Several databases for the group-3
and group-5 semiconductors have been published, of which the most complete is that of
Ansara et al. (1994). A model for treating the variation in stoichiometry as well as the
holes and electrons has been used by Chen et al. (1998).

Phases with miscibility gaps

The simplest kind of miscibility gap is when a phase appears on both sides of a two-
phase region in a binary system. Normally the miscibility gap closes at a high enough
temperature, where the configurational entropy will dominate, but that may be higher than
the temperature at which one can obtain any measurements. The term “composition set”
with a number will be used to identify the two different instances of the same phase. The
concept of a composition set can be extended to cases that normally are not considered
as miscibility gaps, but still have the same phase appearing with different compositions
at the same equilibrium. This happens in many cases of ordering if the disordered and
ordered forms are described as a single phase. For example, the structure types Al, L1,,
and LI, can be described with a single Gibbs-energy function and treated as a single
phase. The different ordered forms can be treated as “composition sets” and can appear
in equilibrium with each other, and this is a kind of miscibility gap.

In many cases one may have the same terminal phases in a system, but no continuous
solution because there are stable compounds in between. However, if the compounds are
excluded from the calculation, the terminal phase may have a metastable miscibility gap.

A miscibility gap can be described with the parameters of a single phase. At the
beginning of an assessment it may be useful to try to fit the parameters that describe
this gap together with the thermodynamic information before involving parameters from
more phases.

A miscibility gap results from a positive interaction between the components, but can
also occur in an ideal reciprocal system; see section 5.8.1.2.

During an optimization it may happen that miscibility gaps appear where there should
not be any; a common feature is that there are “inverted” miscibility gaps at high
temperature in the liquid. This may sometimes be difficult to detect, but, at the end of
an assessment, one should calculate across the whole compositon range at a sufficiently
high temperature, at least 4000 K, to ensure that no solid phases reappear and that there
are no miscibility gaps.

It is possible to include a check on miscibility gaps during the assessment in the
PARROT software; see section 7.3.10. The stability function for a phase, called QF, can
be checked after calculating an equilibrium at some temperatures and compositions. If QF
returns a negative value, the equilibrium is inside the spinodal.

 

 

Hume-Rothery phases

There is a class of phases with which the Calphad method still has some difficulties,
namely the Hume-Rothery phases. For such a phase, the Gibbs energy has a significant

===========
6.2 Modeling the Gibbs energy 191

contribution from the energy of the electron gas, which is part of the metallic bonding.
The interpretation of this contribution by Hume-Rothery (Hume-Rothery et al. 1969) is
described here, following a model proposed by Mott and Jones, but it should be remem-
bered that this work was done before the establishment of the DFT and can be reinterpreted
after systematic calculations of the density of states using the quantum-mechanical meth-
ods available nowadays. For a recent discussion on Hume-Rothery phases, see Paxton
et al. (1997) and Mizutani er al. (2006).

Following Hume-Rothery, this electron gas is modeled as nearly free electrons, obeying
Fermi-—Dirac statistics, so that two electrons can never have identical quantum numbers
simultaneously for all states. The electrons form stationary waves in the metal, for which
the quantum numbers can be represented by a lattice in reciprocal space. The energy
of the electrons increases with the quantum numbers. The lattice in reciprocal space is
filled starting from the states with lowest energies. The highest energy of occupied states
is called the Fermi energy. The corresponding quantum states in reciprocal space form
the Fermi surface. The wavelength of the stationary waves belonging to states near the
Fermi energy is of the same magnitude as the period of the crystal-structure lattice. This
is visualized in reciprocal space by the “Brillouin zones.” The number of quantum states
versus the energy of the electrons, called the density of states, exhibits discontinuities
where the Fermi surface touches Brillouin zones.

If in a phase for example a Cu atom is replaced by a Zn atom, one additional electron
is added to the electron gas, which contributes proportionally to the Fermi energy to the
derivative 0H/dx. The change of the Fermi energy versus number of electrons added is the
reciprocal of the density of states. Thus the contribution of electrons added to the enthalpy
H is proportional to {f DOS~'dx*, where DOS is the density of states and x is the
valence-electron concentration (VEC), the number of electrons per atom in the electron
gas. The VEC is a linear combination of the mole fractions of the elements constituting
the phase.

The simplest model, called the rigid-band model, assumes the density of states to be
independent of composition. This simplification is too crude, but it may be taken as a
first approximation. The most important feature of this model is that the discontinuities
of the DOS versus VEC prevent this contribution to H being represented well by a
polynomial. Thus the RK formalism necessarily has limited accuracy for this class of
phases. Furthermore, for the extrapolation to ternary and higher-order systems one has
to use the VEC as a single composition variable rather than Muggianu’s formalism.
This statement is valid only for the electron-gas contribution to the enthalpy H. Con-
tributions from other sources may be described well by the Redlich—Kister—-Muggianu
formalism.

For successful use of this consideration in modeling G, first-principles calculations of
the density of states are desirable and some ideas regarding how to simplify the results
into a formalism that can be handled by the Calphad method without significant loss of
accuracy have been proposed. The contribution of the electron gas to G may be identified
with that to H since, due to the Fermi—Dirac statistics, the contribution of —TS is very
small. A manageable simplified description is needed in order to describe how the density
of states depends on the phase composition (Mizutani et al. 2006).

===========
192

6.2.9

6.3

6.3.1

Assessment methodology

A summary of phase-model selection

For Table 6.1, even without knowing details of the shape of the measured quantities, one
can already make some decisions about the modeling, for example the following.

¢ Phase, and Phase, should be modeled by a single Gibbs energy.

¢ = There are no enthalpy-of-formation data for Phase,; therefore, a measurement, an
estimate, or a first-principles calculation for that quantity should be sought.

e For Phase, a constraint relating H and S should be imposed because there are not
enough data for modeling H and S independently for a solution phase.

e Phase, is well studied and C, can be modeled; however, since the heat content was
also measured, one can test for conflicts between these two sets of data.

To restrict the kind of model and the number of independent coefficients allowed by
the amount of experimental data further, one should consider Table 6.2.
More details of the parameter selection follow in the next section.

Determining adjustable parameters

The CEF formalism described in chapter 5 is very versatile and contains many adjustable
parameters, but only some of them can be used in an assessment, depending on the
available experimental data. Certain considerations and estimates should be used in order
to decrease the number of independently adjusted parameters either by fixing some
parameters to constant values or by setting constraints relating two or more parameters,
thus expressing them all by a single parameter.

Selecting parameters

In adjusting a thermodynamic description to experimental values, the final value of
each adjustable coefficient depends on many of the diverse measurements and each
measured value contributes to many of the coefficients. The advantage of the least-
squares method is that these influences need not be known quantitatively, since the
strategy of the method is to select the best possible agreement of all the coefficients
and all the experimental values as described in section 2.4. Many of the coefficients of
the descriptions, however, are not able to improve the fit between measurements and
descriptions significantly. Using them may lead the calculation to follow just the scatter of
the experimental values, creating maxima and minima where a smooth line is physically
more plausible.

To judge whether a certain coefficient is well defined by the available set of measured
values, the effect of each coefficient on the shapes of calculated curves should be known at
least qualitatively. It must be discussed for each coefficient, if its influence on the shapes
of calculated functions really is necessary to improve the fit between calculation results
and the experimental dataset. In the following paragraphs some general considerations for
this check are given. Among the examples given in chapter 9, this check is described in
detail for some systems.

===========
 

 

id uoMn]os soy sfapour noge KI[YaIes proxy «gE.
“['T'9'S UONDAS das ‘sao UDAa pu ppo
Og ATPULIOU *JUAIYJOOS YY Ppo suo sea] ye asq] {eduapuadop uoTsoduros oy Ul [wOLNAUTUASE sp —_T'T"E
“EPTO UONDES JO ¢°7'9 UONSes das ‘UOPULOJUT aIMjONNS-[eISK19 ay) UO Supusdap:
SooMe|gns asn ‘sprfos Jog °Z'¢°Z-9 UONDIS 90s ‘oseyd pmnby aup 40.4 ¢syUry Sunuasasd so padeys-.A,U ST UTE
{uontsoduos Jo uoNOUNy v se UMOUY SuNXTUT Jo KdjeyUS OM sp ZE
(zs) ‘ba ut '» pur %) aouspuadap amprsoduiay seaury & AyuO asn ‘saseo Joyo [eR wow UE TTS
‘uoneztundo ay Suunp [Jom APUatLNs sadsdauos I JOYJOYMA Ydoy9 1nq
“Jojoutered ssaoxe Je[NBar ys oy) UL pasn oq AvUt yUOTOTJJo09 (FUT LB ‘UMoUY st Kyoedes yoy oT TE
Zampyeraduray Jo uoMouny v se uMoUY Adjeyyue oyp st Te
aBuvs oJoyM amp ssose ApLesso99U JOU YSnoUTE ‘oseyd UONN]os v se pafopout aq Pinoys aseyd oy], «g
‘sigjourered 7, k[uo asp) ‘siuaUta[a a[quIs au Jo aso URI sanjeA 5 aAnisod aiour samnyerodurar
Tee ony o1 KEENE (sjUoWIO[9 aind) sraquIOU! pus oY) aooYD ‘sas YIOg UO s}oaJop aUIs-HUE sn
“quorayJIpP ATOWIAI]Xa JOU oe saZIs STOW op JT ‘SOOMEIQNS Om) YIM Jopour KyOYDE-JoOUTEAA OM AIL TTT
*[ 01 drys pue ‘uontsodwios oy) Suronpordar
PINOY B JOoTaS “OLOWOTYySIOs sve aseyd oy japou ‘ou Jy LUMOUY [eM ATfear AypIqnjos ap sp VT
“UMOUY JOU ST aIMONNS [eISKIO UL TZ
-syoajop Bursn inoge osye -'¢°7'9 uoNoes
908 ‘papsou oq eu suonwoyrdung “soomelgns uo eproep 0} uoMeUOJUL oIYdesZO[eISK1d V8 TTT
“p'g'¢ WONDas dag “doy pasapso se y1 Japoul ‘61 g Jo “OG
SE JE S00} parapso sv yt Japour “TT Jo [PT sty Jt !09q pasapso sv yr japow *'7T Jo “fog ‘Zq stu TT
“UMOUY ST aINjoNIs [eyshI9 BYL. TT
€ 0) drys ‘ou gy (MoueU oSueI UoMsoduIos om SEZ
reaysuod v PIM épqissod ‘!7 pue %
squd1oyyooo K[uo pur ani uUeUMEN—ddoy ay) aq] “UMOUY STUDIOS Ray OP JOU AyOedeD JOY OY JOON fT
“['7'g uonsas ur
(ZS) ‘by Jo *P 0} %D syuatoyJa09 ULY) aJOU asn JOU OG “UMOUY SI JUA}UOS Joy oy Ing “Ayordes yoy ION = E"T
“parsn{pe aq urea
Sp 01 & squatoryyooo ap Jo AueUE MOY YooYD pur [°7'¢ UONDes ut (z's) “by sq guMOUY Aoedeo oy am ST ZT
“ulas As
JoJo TY) Wo, wep Os|e JopIsUOD pue Z O1 drys ‘sak J] {WOISKS JOMPOUR UF oLNEWOTYDIONS-UoU aseyd ON S| ET
7 0} drys ‘ou Jy {o1LNowWoryo1oys aseyd oy sy I

 

 
 

 

 

aspyd v 20f uoysajas japou of apm8 yomb y 79 M14eL

===========
194

6.3.2

6.3.3

Assessment methodology

Reducing the number of parameters

The analysis of experimental data does not always make evident whether a certain
parameter is related to the available experimental data. This can be found out by applying
a least-squares method twice, with and without the coefficient. Comparison of the two
results makes a decision possible in most cases. It is recommended that one start the
assessment with as few coefficients as possible and then include additional coefficients
as necessary. A systematic misfit between some series of experimental points and the
corresponding calculated curve usually gives enough hints to clarify which coefficients
should be added. If a coefficient is not defined well enough, it usually does not show up
in the comparison of measured values and calculated curves. It may, however, have a bad
influence on the behavior of the extrapolation of the calculation into areas not covered
by experiments.

Constraining parameters

For phases with several sublattices and several constituents on each, there are many
reciprocal relations, as described in section 5.8.1. If there is not enough information,
taking into account also crystallographic symmetries, to determine each end member of
a reciprocal relation independently, a possible method is to assume that the reciprocal
energy is zero. If three end members of a reciprocal relation are known, this assumption
makes it possible to fix the fourth from Eq. (5.100). For cases in which there are several
possible reciprocal relations, the order in which one should select these has been suggested
by Hillert (1997b).

For intermediate phases with a homogeneity range, there often exists an “ideal” com-
position for which each sublattice is occupied by a single constituent only, equivalent
to an “end member.” In order to model the homogeneity range, one needs information
about the kind of defects causing the deviation from ideality. Possible types of defects
‘ancies, and several kinds of defects simultaneously.
When optimizing the properties of the phase, one should first optimize the parameter
that describes the ideal composition, i.e., a single end member. If the homogeneity range
is small, modeling this end member first as a stoichiometric phase often facilitates the
optimization. If this description converges, it is fixed and the parameters that determine
the deviation from the ideal stoichiometry are added and assessed. Finally, all parameters
are made adjustable again and assessed simultaneously in the final calculation step. This
procedure in most cases prevents large jumps of the parameters in the first calculation
steps, which may lead to a parameter set in which the opposite occupation of sublattices
appears to be the more stable one. When a reasonable fit has been obtained with the
available data, but more than one independent defect structure is defined for the phase in
question, one may start varying also the parameters that determine the relative fractions
of these defects.

When there are many end members of a phase, little or no thermodynamic information,
and no data on the actual occupancy, one may reduce the number of optimizing variables
by assuming the same entropy and heat capacity for all the end members. In some cases,

 

are anti-site atoms, interstitials, va

  

 

  

===========
6.3.4

6.4

6.4.1

6.4 Decisions during the assessment 195

it may suffice to set an end-member parameter equal to its “Kopp-Neumann” value like
in Eq. (5.39).

Setting an end-member parameter equal to zero is a very bad estimate.

Coefficients in the Redlich—Kister series

In solutions for which the RK formalism gives a good description of the Gibbs energy
(sections 6.2.3 and 6.2.4), the question of how many coefficients "L of Eq. (5.65) can
be independently adjusted arises, or, what is the maximal power v of the series? The
composition variations of G,, due to the various coefficients are shown in Fig. 5.10.

The simplest case is a dilute solution starting from one of the pure components. Here
Henry’s law describing an ideal solution (Eq. (5.42)) between the pure solvent and a
fictive state of the solute expressed by °Gy — H3"* may be applied. However, °Gy — H3®
is formally a unary parameter, which must be the same in several binary systems and
cannot be fitted to a particular binary system. Then the Henrian solution is described
as a regular or quasiregular solution with a single coefficient °L, , in Eq. (5.65). If the
solution is dilute, only the sum °G, — Hp"® +°L, » is significant. If the coefficient "Ly 5
has to be adjusted then whether it should be treated as a constant (regular solution)
or as a linear function of temperature (quasiregular) depends on the experimental
information.

Measured solubilities in an extended temperature range or independent measurements
of a solubility at one temperature and an enthalpy of solution allow the independent
adjustment of two coefficients, ap, and a,, of "Ly 3 = ay +a, -T. If, however, the solubility
is known in a narrow temperature range only and no enthalpy of solution (mixing) is
available, only one coefficient should be adjusted independently. Then either a, is set
zero or it is set proportional to do: a, = a)/T), where T, is estimated to be 3000 K by
Lupis (1967) and Kubaschewski et al. (1967). This estimation was proposed to depend
on the melting temperatures of the pure components and refined by Tanaka et al. (1996).

For some systems there may be enough experimental information to adjust two or
three RK coefficients for one of the solution phases in a system, for example the liquid.
Even if there is little or no information except phase-diagram data on the other solution
phases in the system, one may find it necessary to use the same number of coefficients
for the other solution phases as for the liquid in order to obtain a good description.

Decisions to be made during the assessment

The use of software to optimize the system can be divided into two steps. The first is
to get a set of parameters that can roughly reproduce the main features of the data. The
second step is fine-tuning the parameters to the selected data.

Steps to obtain a first set of parameters

An experienced assessor may be able to guess parameter values for the models that
can be used to calculate a phase diagram in reasonable agreement with the critical

===========
196

6.4.2
6.4.2.1

6.4.2.2

Assessment methodology

dataset. For beginners, however, guessing the first set of parameters is usually a very
big problem.

Most types of software require that one can calculate the experimental equilibrium in
order to compare the measured quantity with the corresponding quantity calculated from
the model. If all parameters are initially zero, that is usually not possible (the reason for
this is explained in section 7.1.1).

In the BINGSS software there is an option IVERS=3 that does not require a full
equilibrium calculation to compare the model value with the experimental one; see
section 7.2.4. In the PARROT software the same feature is called ALTERNATE mode
and is described in section 7.3.7.3.

Contradiction between experiments
Experimental data of the same kind

When one has several measurements of the same quantity by various authors, one may
sometimes find that their results are so scattered that one cannot fit them all. If all
possibilities of systematic errors, impure samples, bad calibration, etc. have been checked
but the differences remain, the assessor must decide which data are not to be used.
It is not advisable to include several contradicting values of the same quantity, since the
least-squares method will just fit the mean value. This initial selection may have to be
reconsidered later during the assessment when the fit to other kinds of data may have
clarified that the originally selected value is less compatible with these other data than
the rejected one.

Experimental data of different kinds

After the selection of the models and obtaining a first set of parameters by running
the optimizing program, it may be found that some sets of experimental data cannot be
fitted simultaneously. This can be detected by excluding the suspected datasets one by
one and checking whether the fit of the non-excluded datasets improves. Which dataset
finally should be excluded is up to the judgment of the assessor, who should consider the
estimated accuracy of the datasets and the overall fit to other data.

Before excluding a set of data, one should analyze carefully the original paper and look
for a possible reason why the experimental result does not describe the physical reality.
The reason behind the contradiction between different types of data is seldom evident. In
order to understand the problem, one can use some rules like the Gibbs—Konovalov rule,
Eq. (2.50).

There are cases in which different kinds of data provide the same information, for
example when the liquidus, chemical potentials, and enthalpy of mixing of the liquid
phase are known. A conflict may be found in that the value of the entropy obtained
by combining the enthalpy and the liquidus data and that obtained by combining the
chemical potential and enthapy data may be contradictory. In this case, the entropy is
overdefined. Some action should be taken to use the combinations separately, observing
the results obtained.

===========
6.4.3

6.4.4

6.4 Decisions during the assessment 197

To determine that datasets are really in contradiction one should question the assumed
model. The main question is the following: is there a model that will cope with the
different sets of data? This question is usually difficult to answer.

Weighting of experiments

The least-squares minimization in Eq. (2.53) can be affected by selecting different
weightings for the experimental data. The uncertainty assigned to each piece of experi-
mental data is the first level of weighting, since an experimental result with a very small
uncertainty will force the optimizer to try to fit this result well. The uncertainty should
never be adjusted during an optimization; one should use the value provided by the
experimentalist, with a reasonable amount of skepticism.

If some important data are not fitted well during the optimization, one must first
reconsider the model and the parameters selected for it. For example, an asymmetrical
miscibility gap requires at least two RK coefficients. Increasing the weighting of the
experimental data will not improve the fit if only a regular parameter is used.

It is also possible that the parameter set has become stuck in a local minimum, such
that it may help to change the parameters drastically, even change signs, in order to try
to reach a global mimimum. This may make it difficult to calculate some, or all, of the
experimental points and one may have to use again the technique provided for bad initial
values; see section 7.1.1.

However, if the model and model parameters are reasonable, one may increase the
weighting of data from the most important experiments. That will necessarily make the fit
to data from other experiments less good and it is not reasonable to increase all weightings.
In the PARROT software, see section 7.3.10, one may also adjust the weightings to give
equal importance to a few phase-diagram points if one has much thermochemical data.

Phases appearing where they should not or missing from where
they should appear

Terminal phases with small composition ranges or intermediate phases may sometimes
appear to be stable in parts of the phase diagram where they are not stable. This can
be checked only by calculating the whole diagram with all phases for the current set of
parameters. Such calculations should be done regularly during the assessment in order to
discover such problems as early as possible.

Some such cases can easily be avoided. If the artificial appearance of a phase is at
temperatures far above its real stability range, it may be sufficient to set a breakpoint
in the description of the temperature dependence of one or more of the end members of
the phase and continue with constant Cc, ie., without terms containing 77, 77, or even
higher powers of 7. Outside the stability range of the phase, high powers of T may lead
to extremely unphysical C,, descriptions. In a few cases it has also been found that a
constant C,, is not sufficient to suppress the reappearance of the phase; one should then,
after the breakpoint, allow C,, to decrease to the Kopp—Neumann value.

===========
198

6.4.5

6.5

Assessment methodology

It is normally not possible to relate the appearance of a phase at the wrong place in
a phase diagram to a particular optimizing parameter. Sometimes it can be the Gibbs
energy of a particular end member becoming too negative or the coefficients in the RK
series adding up to too negative a value where the phase should not appear to be stable.
This problem can be solved by finding an expression stating that the phase should be less
stable than the stable equilibrium in the region, which means that the phase appearing at
the wrong place must have a negative driving force at the stable equilibrium at this place.
The driving force of a phase is explained in section 2.3.6.

In the PARROT software, see section 7.3.10, this difference can be prescribed as a
negative driving force, and the problem is easily solved. This is done by prescribing that
the driving force of the phase should be smaller than some prescribed negative number.
This information can usually be added to an existing experimental tie-line or similar data
that have already been optimized. This is described in section 7.3.7.9.

It is possible to use the same feature of PARROT to force a phase to become
stable in a region where it is missing for the current set of optimizing parameters. One
can then require that the phase has zero driving force at the desired composition and
temperature.

Reasonable values of parameters

There are certain limits of the model parameters that should be considered. In most cases
the coefficients ay of temperature-independent and a, of linearly temperature-dependent
terms are the only ones to be optimized and these can be related to enthalpies and
entropies, respectively. If heat-capacity data have been assessed, the enthalpy and entropy
parts must be calculated from the full Gibbs-energy expression and one cannot look at
just the ay and a, coefficients, for example. This check must be performed before the
assessment is finished, but, now and again during the assessment, one may decide to
reset or discard parameter values that are unreasonable for the reasons discussed below.
For a sensible discussion of parameter values, one should have a reasonable fit to all
experimental thermochemical data.

There are limits of enthalpies and entropies that can be checked even when experimen-
tal data are lacking, as described in section 6.2.5.3, for example that the total entropy for
a given composition must always be positive. For enthalpy values one should expect that
their absolute value is less than a few times 100kJ mol~' (moles of atoms). For entropies
they should be less than 100J mol~' K~!. This should apply to each coefficient in the RK
series, even if the sum of all coefficients gives a reasonable enthalpy.

Checking results of an optimization

It is not easy to know when the best possible set of parameters has been reached. The
answer will depend on the use for which one wants the description obtained. Supposing
that one wants to have the best possible descriptions using the full potentiality of the
method, for which this book is intended, the following procedures should be implemented.

===========
6.5 Checking results of an optimization 199

A well-optimized set of parameters for the Gibbs energies of the system should be
able to reproduce the available experimental set in the best possible way.

New experimental evidence may indicate that the description should be modified.
What are the criteria for deciding that a description is well established for the known
experimental evidence?

1. The visual check of the agreement between experimental data and calculated values
is an important tool. Tendencies shown by the experimental data but not reproduced
by the calculated curves should be carefully analyzed. They can express physical
behavior and may require a change of the modeling. This fact is illustrated by the

sment of the Mg-Zn system (Agarwal er al. 1992). There, the steep slope of the
liquidus line found experimentally was reproduced only after the introduction of a
temperature-dependent enthalpy of mixing into the modeling. Further experimental
enthalpy results specially provided for the optimization confirmed the existence of a
large excess C,, in the liquid phase. The background of this problem can be explained
by the Gibbs—Konovalov rule, Eq. (2.50).

2. The sum of squares of errors obtained from the least-squares fit is another important
tool, although one should not take it as the unique criterion.

3. Extrapolate to higher-order systems. Sometimes it can happen that a binary system is
quite well described, but the extrapolation of the description to a ternary system does
not succeed in reproducing the ternary experimental information. In this case the
ternary information is used for improving the binary description.

4. Analyze the plausibility of the values of the parameter found by the least-squares
fit. For example, for a stoichiometric phase for which no C, is known and the
Kopp—Neumann rule is used to estimate C,, just two coefficients are left to be
optimized. With such considerations of the selection of the number of coefficients to
be adjusted and with a reasonable set of experimental data used for the optimization
without contradicting data, the values found by the fitting also should be reasonable.
Nonetheless, one should check whether the signs and values of the coefficients are
plausible. Usually, if the value of the coefficient of the a,T-term is very large, that
should be taken as an indication that ay and a, cannot be optimized independently
and the constraint proposed by Tanaka et al. (1990) should be considered an adequate
estimate.

5. Removing non-significant digits. Parameters with many digits may give the impres-
sion that they are very well determined, although actually only the first few digits
are significant. However, one cannot arbitrarily round off parameters without the
danger of losing agreement with some experimental data. Even if an enthalpy and an
entropy of melting are known with at most two significant digits, their quotient, the
melting temperature, may be known to within four digits. A method of safe rounding
might be to select the parameter with the highest relative standard deviation, set it to
a rounded value, and reoptimize the remaining parameters. This can be repeated until
all parameters have been rounded to the appropriate number of significant digits; see
section 7.4.4.

6. Check that S53 and C,, of all phases are within reasonable limits.

 

 

===========
200

6.6

6.7

6.7.1

Assessment methodology

Publishing an assessed system

Before your paper is ready to be published, you should check that the following items
are reported. These checks may also be used by reviewers.

e A list of experimental data used and of those that were not used.

e Acomplete report of the model parameters. If that is not possible, state explicitly the
reason. If the parameters are just partially reported, indicate which parameters are
missing and where to find them (for example a commercial database). Provide param-
eters in a well-documented format on a computer file for the reviewer. This facilitates
the work of the reviewer, who will wish to check that parameters and text agree.

A table of the invariant equilibria, including azeotropic maxima or minima.
Crystal-structure information and lattice parameters.

Standard enthalpies of formation (units)

A report about metastable phases.

Diagrams with calculated and experimental data together. All experimental data,
even datasets excluded from the assessment, should be plotted, maybe in separate
diagrams if it would otherwise be confusing.

e = The range of validity of the description.

 

These reports can be done systematically. It would be interesting to create a format as
for reporting crystal structures. Such a standard format would facilitate further improve-
ments of the modeling of the system in question. Instead of a completely new publication,
just a short note providing an update would be sufficient.

How the experts do assessment

During the preparation of this book and after so many years of cooperation, it was found
that each author had his or her own way of doing assessments. For further opinions on
assessments, read also Kumar and Wollants (2001) and Schmid-Fetzer et al. (2007), and
read several published assessments.

When modeling the Gibbs energy for phases in a binary system, one must take into
account that they will extend into multicomponent systems when added to a database.
This means that one should look at least at some ternary systems including this binary
in order to find out which phases are important. Phases stable within a small range in a
binary system may extend far into higher-order systems and the parameters assessed for
the binary system will affect the stability of the phase in the multicomponent system. The
experience with the Calphad technique is that phases assessed in binary systems taking
ternary information into account can be extrapolated to higher-order systems with a high
degree of confidence.

Expert type 1

This kind of expert will look at the general outline of a system and, if there are compounds,
he will estimate metastable extrapolations of the terminal phases and possible metastable

===========
6.7.2

6.7.3

6.7.4

6.7 How the experts do assessment 201

three-phase equilibria with the liquid. After obtaining a preliminary fit to this, he will add
the intermetallic phases one by one and, if necessary, estimate congruent melting points
or metastable invariant equilibria with the already-assessed phases. When all phases have
finally been incorporated, he will optimize with just the experimental data, but often it
may be necessary to include some estimated equilibria in order to avoid the appearance
of phases at “wrong” compositions or temperatures. This technique facilitates the use of
ab initio data and comparisons with other systems. It emphasizes the use of the assess-
ment in higher-order systems but it requires long experience in estimating metastable
extrapolations. Often such extrapolations should be smoothed without any maxima
or minima of the liquid—solid two-phase equilibria. It is called the Kaufman—Ansara
method.

Expert type 2

This expert may be more interested in the thermodynamic models of the system than in
the specific system being assessed. He will try models and test model parameters that
generate prototype diagrams similar to the system and try to find relations between the
parameters and the various features of the system. He will also estimate or even invent
experimental data that should be representative of the system and try to determine which
model parameter can be used to describe them. Like expert type 1, he will usually work
with one phase at a time and pay great attention to the metastable extrapolations of the
system. This is a very powerful feature of the “Stockholm” school.

Expert type 3

This expert starts by analyzing all the experimental data available in order to avoid dis-
crepancies between the assessment and any experimentally determined phase diagram as
well as thermodynamic data. He will use all experimental data from the beginning and
may be less focused on metastable extrapolations insofar as they are not meaningful for
higher-order descriptions in experimentally accessible ranges. His objective is to model
the present system as well as possible, without limitations demanded by merely formal
problems of the existing database. He may prefer to simplify, if there are not enough
experimental data really enabling him to determine parameters of a more-sophisticated
model. For example, intermediate phases will be treated as stoichiometric, if the solu-
bilities are not well defined by experimental data. This is a method mainly envisaging
an academic use of the final description. That procedure reflects the “Stuttgart-PML”
(Pulvermetallurgisches Laboratorium) school.

The ultimate expert

It is more or less easy to identify the ways to do assessments by searching the literature.
The experts of type 2 will start their publications by describing the models; experiments
come later, when the discussion has been completed. Experts of type 3 start with the
experimental data, followed by a discussion of the selection of the model using arguments

===========
202

Assessment methodology

based on the existing experimental data. One does not find many papers with the first
approach, but this is the approach of people thinking in terms of multicomponent databases
for real materials.

Which is really the best method for an assessment? There are good features in all
methods and, if you can make a combination of them with a lot of “good sense,” you
will certainly obtain a reasonable result.
