# Test cases for thermal phase change in OpenFOAM

This folder contains modified code originally available [here](https://bitbucket.org/abouhours/test-cases/src/master/).

Cases are verified here to be compatible with OpenFOAM v22.12 and only those running properly are ported to this repository.

Prior to running the cases, do not forget to activate the proper version with `openfoam2212`.

## icoReactingMultiphaseInterFoam

- [Film boiling 2D (Lee):](icoReactingMultiphaseInterFoam/FilmBoiling_Lee2D/) Bbiling of a vapor film immersed in liquid in 2D. Correlation with the litterature (Berenson, Klimenko). Based on the validation case of [*S. Welch et al. A volume of fluid based method for fluid flows with phase change. Journal of computational physics, 2000*](https://doi.org/10.1006/jcph.2000.6481).

<!--
* Film boiling 2D (Lee & Schrage) - 
* Film boiling 3D (Lee) - Based on the 2D case, transformed in 3D. Fine mesh.
* Stefan case (Lee & Schrage) - S. Welch et al. A volume of fluid based method for fluid flows with phase change. Journal of computational physics, 2000.
* Sucking Interface (Schrage) - S. Welch et al. A volume of fluid based method for fluid flows with phase change. Journal of computational physics, 2000.

## interCondensatingEvaporatingFoam

* Stefan case (Lee) -  S. Welch et al. A volume of fluid based method for fluid flows with phase change. Journal of computational physics, 2000.
* Hysing Benchmark (Lee) - Check for the validity of surface tension in 2D of interCondensatingEvaporatingFoam for a benchmark case. S. Hysing et al. Quantitative benchmark computations of two dimensional bubble dynamics. International Journal for Numerical Methods in Fluids, 2009.

## interFoam

* Bubble generation with a T-junction in a microchannel. D. A. Hoang et al. Benchmark numerical simulations of segmented two-phase flows in microchannels using the Volume of Fluid method. Computers & Fluids, 2012.
Based on the case shared on [CFD Online](https://www.cfd-online.com/Forums/openfoam-verification-validation/124363-interfoam-validation-bubble-droplet-flows-microfluidics.html).

## interTransferFoam

* Dissolution of a 2D droplet. G. Y. Soh et al. A CFD model for the coupling of multiphase, multicomponent and mass transfer physics for micro-scale simulations. International Journal of Heat and Mass Transfer, 2017.

## multiRegionPhaseChangeFlow

* Film boiling 2D (Energy jump condition) - Boiling of a vapor film immersed in liquid in 2D. Correlation with the litterature (Berenson, Klimenko). Based on the validation case of S. Welch et al. A volume of fluid based method for fluid flows with phase change. Journal of computational physics, 2000.
* Film boiling 3D (Energy jump condition) - Based on the 2D case, transformed in 3D.
* Film boiling 3D (FilmBoilingFull3D) - Based on the 3D case, the bubble is simulated entirely (full 3D).

## Acknowledgments

Thanks to Henning Scheufler for his collaboration on the cases in multiRegionPhaseChangeFlow. -->
