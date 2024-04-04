# Archive Databases

Archive of databases for scientific computing and literature.

## License

The ensemble of this directory is submitted to MIT license but individual files might be covered by different licenses. Please refer to the original sources in order to verify which license applies.

## Kinetic mechanisms

Kinetics mechanisms from several sources or authored.

### Oxydation of Methane

- [Lu_2008_CH4_red19](kinetics/Lu_2008_CH4_red19): 19 species CSP reduction of Gri-Mech 2.1 performed by Lu et al., 2008. Notice that mechanism does not implement rate constants and a Fortran file is provided with rates for actual computations. Not tested yet.

- [Lu_2008_CH4_sk30](kinetics/Lu_2008_CH4_sk30): 30 species DRG simplificaiton of Gri-Mech 3.0 performed by Lu et al., 2009. This mechanism provides combustion temperatures close to the base 53 species reference mechanism.

- [Zhukov_2018_sk23](kinetics/Zhukov_2018_sk23): 23 species DRG simplification of Gri-Mech 3.0 performed by Zhukov et al. 2018. This mechanism provides combustion temperatures close to the base 53 species reference mechanism with slight understimation at unity air-to-gas-ratio.

- [Methane_Low_Order](kinetics/Methane_Low_Order): some 1 and 2 reaction files. One reaction mechanism shall not be used in serious applications (illustration purposes only) and 2-reaction-mechanism is known to work properly only on lean combustion conditions.

### Pyrolysis of Acetylene

- [Norinaga_2009](kinetics/Norinaga_2009): reference detailed kinetics of acetylene pyrolysis containing 241 species.

- [Dalmazsi_2017_sk41](kinetics/Dalmazsi_2017_sk41): skeletal mechanisms of 41 species obtained by large sampling of DRG simplifications from [Norinaga_2009](kinetics/Norinaga_2009).

## Thermodynamics

Thermodynamic databases for CALPHAD simulations. Documentation and validation are a work in progress.

## To-Do's

- [ ] Add DOI of reference papers.
- [ ] Standardize mechanism naming convention.
