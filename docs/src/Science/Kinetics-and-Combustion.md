# Combustion

The science of combustion is complex by its intrinsic nature; it requires (at least) elements from fluid dynamics, thermodynamics, chemical kinetics, and radiation. An overview on how these fields of knowledge intertwine is presented in the work by ([[@Warnatz2006]]).

Different approaches are possible depending on the level of description required for a given process; the chemist might be interested in detailed kinetics ([[@Kee2017]]) to be able to describe the spatial distribution of species and pathways, which might be sensitive to the operating conditions and initial compositions; to achieve that level of description, an important experimental and *ab initio* calculations workload is often required ([[@Henriksen2008]]) and has been carried over many years for systems of practical interest. These efforts led to the conception of detailed mechanisms such as GRI-Mech ([[@Smith1999]]) and many others of higher level of complexity.

On the other hand, the process engineer often might find a global approach to respond to their needs knowing that probably only energy output will be right in the calculations. Some workers  ([[@Westbrook1981]]) have studied means of keeping the released energy consistent while also representing flame-speeds in relative agreement with those predicted by detailed kinetics. We will come back to that point in practical scenarios. To that end, one might rely in the empirical fuel approaches introduced in Chapter 31 by ([[@Gyftopoulos2005]]), which ensures at least thermodynamic consistency; this allows for further simplifications as *practical* species may be used to represent the fuel composition, reducing the number of equations to be solved in simulations.

In a complex flow scenario, chemical kinetics might alone not be enough to describe combustion; in some cases the rate of turbulent mixing might block the fuel from reaching the oxidizer and thus finite-rate laws can non-longer be followed. To overcome this difficulty in RANS simulations, approaches such as the eddy-dissipation model ([[@Magnussen1977]]) were proposed and later improved to better represent the scales of combustion. When time resolution of scales is important as in LES simulations, other measures might be required when tuning the mechanism, as discussed by ([[@Franzelli2012]]).

Finally, one must keep in mind that in most cases combustion flue gases behave as participating media and strongly influence the results; omitting their contribution (and that of soot) is a serious mistake that is commonplace in CFD practice. This is thoroughly discussed in the work by ([[@Modest2016]]). Again, different levels of representation are possible; not to be exhaustive, one might evaluate fluid properties with a narrow band model such as Radcal ([[@Grosshandler1993]]) or apply global approaches as the weighted-sum-of-gray-gases (WSGG) ([[@Hottel1967]]) or some of its later improvements not treated here.

## Natural gas


## NOx formation

These notes are mostly based on ([[@Warnatz2006]]), except where mentioned otherwise.

Four different possible routes:

1. Thermal route (Zeldovich mechanism) at high temperatures; assumes steady state concentration of atomic nitrogen to simplify the rate law of NO formation. The required atomic oxygen concentration can be estimated from *partial-equilibrium* evaluated from $H_2$,, $O_2$, and $H_2O$ in the flame front. This is valid only above 1700 K, but this is no problem because the limiting rate constant in Zeldovich mechanism is very low at this level of temperatures.

2. Prompt route (Fenimore mechanism), accounts for the role of $CH$ radicals in downstream side of flame front; it is favored in rich flames which accumulate acetylene due to $CH_3$ recombination, a precursor for $CH$ radicals. Its production can be important at temperatures as low as 1000 K.

3. Nitrous oxide route

4. Conversion of fuel nitrogen
