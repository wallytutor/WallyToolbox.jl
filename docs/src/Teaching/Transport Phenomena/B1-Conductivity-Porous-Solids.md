# Thermal conductivity of porous solids

Porous solids are characterized by the presence of voidance; they may be formed, for instance, through the sintering of particles with a given size distribution or through a foaming process. The former will lead to pores presenting a mostly convex geometry due to particle-particle contacts of  while the latter leads to concave pores, generally due to former gas bubbles during foaming process; these morphologies and the scale of porosity will lead to a broad range of properties in macroscopic behavior of materials. Other features related to the porosity might include the communicating character of pores or the validity of continuum mechanics in a given problem due to pore sizes. This subject has been treated by scholars of many fields because of its relevance to industrial processes, heat transfer in furnaces, biological systems, and more recently in heat storage and recovery devices, not to try to be exhaustive here; specific citations come next.

In what follows we will briefly review some of the afore mentioned applications and historical developments in the field before tackling the problem of modeling heat transfer in arbitrary materials. The goal of our literature review is to determine the limits of applicability and how well accepted are the available methods proposed in the past, but also to identify potential use cases of computational methods in materials design before proposing our own scenarios. The study will comprise situations allowing for analytical solution for solver validation, reproduction of previous published results, and the modeling of arbitrary solids. Unless stated otherwise, numerical studies in two and three dimensions are carried out with Elmer ([[@Malinen2013a]]) finite element method (FEM) solver. Additional simulations with pore filling with inclusions are also included in the study, providing a basis for composite materials. A database of predicted materials properties is composed for future studies.

## Literature survey

- ([[@Masamune1963a]]): studied the role of gas pressure below and up to atmospheric pressure over the effective thermal conductivity of a bed of spherical particles; mechanisms of heat transfer can be classified as transport through (1) conduction and radiation in voids, (2) effective solid-path and gas-path lengths, and (3) solid conduction through contacts. Although the authors acknowledge the role of radiation in heat transfer, it is not included in their expression, but low Knudsen number effects were considered for thermal conductivity when necessary.

- ([[@Luikov1968a]]):

- ([[@Koh1971a]]):

- ([[@Koh1973a]]):

- ([[@Fiedler2006a]]):

- ([[@Fiedler2007a]]):

- ([[@Fiedler2009a]]):

- ([[@Smith2013a]]):

- ([[@Cheilytko2016a]]):

- ([[@Pia2016a]]):

- ([[@Qiu2018a]]):

- ([[@Chikhi2020a]]):

- ([[@Mraz2021a]]):

## Experimental design

| No. | Case                                         | Status | Goal |
| :-: | -------------------------------------------- | :----: | ---- |
|  1  | Analytical solution of dense, $k=k_{ref}$    |        |      |
|  2  | Analytical solution of dense, $k=k_{ref}-bT$ |        |      |
|  3  | Simulation of dense, $k=k_{ref}$             |        |      |
|  4  | Simulation of dense, $k=k_{ref}-bT$          |        |      |
|  5  |                                              |        |      |

## Summary of results

