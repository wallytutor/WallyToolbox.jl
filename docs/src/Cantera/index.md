# Cantera

This page documents the wrapper written around the C-API of Cantera. The status
of development is documented here. Its goal is not to mimic the
original API or provide an interface equivalent to the Python package, but
something in line with the functioning of the parent toolbox.

## Status of Cantera wrapper

This is an experimental interface to Cantera library based on its
[C-API](https://cantera.org/documentation/docs-3.0/doxygen/html/dir_690289abfa5e09db35ec6757548a6dfc.html)
version 3.0. This interface is at its early days and has developped for Julia >=
1.9.0 under Windows 10/11. When it is stable enough it will be published as a
package and tested under other platforms.

### Useful links

- [Source files](https://github.com/Cantera/cantera/blob/main/src/clib)
- [Header files](https://testing.cantera.org/documentation/docs-3.0/doxygen/html/dir_690289abfa5e09db35ec6757548a6dfc.html)

### API of `ct.h`

Documentation [here](https://cantera.org/documentation/docs-3.0/doxygen/html/d3/dc1/ct_8h.html).

| Status  | Header         | Function                                 | Module    |
| ------- | -------------: | ---------------------------------------- | :-------: |
| Tested  | ct.h           | ct_appdelete                             | inlined   |
| Struct  | ct.h           | soln_newSolution                         | wrapped   |
|         | ct.h           | soln_newInterface                        | waitlist  |
| Tested  | ct.h           | soln_del                                 | inlined   |
| Tested  | ct.h           | soln_name                                | inlined   |
| Struct  | ct.h           | soln_thermo                              | inlined   |
| Struct  | ct.h           | soln_kinetics                            | inlined   |
| Struct  | ct.h           | soln_transport                           | inlined   |
| Tested  | ct.h           | soln_setTransportModel                   | wrapped   |
| Tested  | ct.h           | soln_nAdjacent                           | inlined   |
|         | ct.h           | soln_adjacent                            | waitlist  |
| Tested  | ct.h           | thermo_newFromFile                       | wrapped   |
| Tested  | ct.h           | thermo_del                               | inlined   |
| Struct  | ct.h           | thermo_nElements                         | inlined   |
| Struct  | ct.h           | thermo_nSpecies                          | inlined   |
| Tested  | ct.h           | thermo_temperature                       | inlined   |
| Struct  | ct.h           | thermo_setTemperature                    | inlined   |
| Tested  | ct.h           | thermo_density                           | inlined   |
| Tested  | ct.h           | thermo_setDensity                        | inlined   |
| Tested  | ct.h           | thermo_molarDensity                      | inlined   |
| Tested  | ct.h           | thermo_setMolarDensity                   | inlined   |
| Tested  | ct.h           | thermo_meanMolecularWeight               | inlined   |
| Tested  | ct.h           | thermo_moleFraction                      | inlined   |
| Tested  | ct.h           | thermo_massFraction                      | inlined   |
| Struct  | ct.h           | thermo_getMoleFractions                  | inlined   |
| Tested  | ct.h           | thermo_getMassFractions                  | inlined   |
| Struct  | ct.h           | thermo_setMoleFractions                  | inlined   |
| Tested  | ct.h           | thermo_setMassFractions                  | inlined   |
|         | ct.h           | thermo_setMoleFractionsByName            |           |
|         | ct.h           | thermo_setMassFractionsByName            |           |
|         | ct.h           | thermo_getAtomicWeights                  |           |
|         | ct.h           | thermo_getMolecularWeights               |           |
|         | ct.h           | thermo_getCharges                        |           |
|         | ct.h           | thermo_getElementName                    |           |
|         | ct.h           | thermo_getSpeciesName                    |           |
|         | ct.h           | thermo_getName                           |           |
|         | ct.h           | thermo_setName                           |           |
|         | ct.h           | thermo_elementIndex                      |           |
|         | ct.h           | thermo_speciesIndex                      |           |
|         | ct.h           | thermo_report                            |           |
| Tested  | ct.h           | thermo_print                             |           |
|         | ct.h           | thermo_nAtoms                            |           |
|         | ct.h           | thermo_addElement                        |           |
|         | ct.h           | thermo_getEosType                        |           |
| To test | ct.h           | thermo_refPressure                       | inlined   |
| To test | ct.h           | thermo_minTemp                           | inlined   |
| To test | ct.h           | thermo_maxTemp                           | inlined   |
| To test | ct.h           | thermo_enthalpy_mole                     | inlined   |
| To test | ct.h           | thermo_intEnergy_mole                    | inlined   |
| To test | ct.h           | thermo_entropy_mole                      | inlined   |
| To test | ct.h           | thermo_gibbs_mole                        | inlined   |
| To test | ct.h           | thermo_cp_mole                           | inlined   |
| To test | ct.h           | thermo_cv_mole                           | inlined   |
| To test | ct.h           | thermo_pressure                          | inlined   |
| Struct  | ct.h           | thermo_setPressure                       | inlined   |
| To test | ct.h           | thermo_enthalpy_mass                     | inlined   |
| To test | ct.h           | thermo_intEnergy_mass                    | inlined   |
| To test | ct.h           | thermo_entropy_mass                      | inlined   |
| To test | ct.h           | thermo_gibbs_mass                        | inlined   |
| To test | ct.h           | thermo_cp_mass                           | inlined   |
| To test | ct.h           | thermo_cv_mass                           | inlined   |
| To test | ct.h           | thermo_electricPotential                 | inlined   |
| To test | ct.h           | thermo_thermalExpansionCoeff             | inlined   |
| To test | ct.h           | thermo_isothermalCompressibility         | inlined   |
|         | ct.h           | thermo_chemPotentials                    |           |
|         | ct.h           | thermo_getEnthalpies_RT                  |           |
|         | ct.h           | thermo_getEntropies_R                    |           |
|         | ct.h           | thermo_getCp_R                           |           |
|         | ct.h           | thermo_setElectricPotential              |           |
|         | ct.h           | thermo_set_TP                            |           |
|         | ct.h           | thermo_set_TD                            |           |
|         | ct.h           | thermo_set_RP                            |           |
|         | ct.h           | thermo_set_DP                            |           |
|         | ct.h           | thermo_set_HP                            |           |
|         | ct.h           | thermo_set_UV                            |           |
|         | ct.h           | thermo_set_SV                            |           |
|         | ct.h           | thermo_set_SP                            |           |
|         | ct.h           | thermo_set_ST                            |           |
|         | ct.h           | thermo_set_TV                            |           |
|         | ct.h           | thermo_set_PV                            |           |
|         | ct.h           | thermo_set_UP                            |           |
|         | ct.h           | thermo_set_VH                            |           |
|         | ct.h           | thermo_set_TH                            |           |
|         | ct.h           | thermo_set_SH                            |           |
| Tested  | ct.h           | thermo_equilibrate                       |           |
| To test | ct.h           | thermo_critTemperature                   | inlined   |
| To test | ct.h           | thermo_critPressure                      | inlined   |
| To test | ct.h           | thermo_critDensity                       | inlined   |
| To test | ct.h           | thermo_vaporFraction                     | inlined   |
|         | ct.h           | thermo_satTemperature                    |           |
|         | ct.h           | thermo_satPressure                       |           |
|         | ct.h           | thermo_setState_Psat                     |           |
|         | ct.h           | thermo_setState_Tsat                     |           |
|         | ct.h           | kin_newFromFile                          |           |
| To test | ct.h           | kin_del                                  | inlined   |
| To test | ct.h           | kin_nSpecies                             | inlined   |
| To test | ct.h           | kin_nReactions                           | inlined   |
| To test | ct.h           | kin_nPhases                              | inlined   |
|         | ct.h           | kin_phaseIndex                           |           |
| To test | ct.h           | kin_reactionPhaseIndex                   | inlined   |
|         | ct.h           | kin_reactantStoichCoeff                  |           |
|         | ct.h           | kin_productStoichCoeff                   |           |
|         | ct.h           | kin_getReactionType                      |           |
|         | ct.h           | kin_getFwdRatesOfProgress                |           |
|         | ct.h           | kin_getRevRatesOfProgress                |           |
|         | ct.h           | kin_getNetRatesOfProgress                |           |
|         | ct.h           | kin_getEquilibriumConstants              |           |
|         | ct.h           | kin_getFwdRateConstants                  |           |
|         | ct.h           | kin_getRevRateConstants                  |           |
|         | ct.h           | kin_getDelta                             |           |
|         | ct.h           | kin_getCreationRates                     |           |
|         | ct.h           | kin_getDestructionRates                  |           |
|         | ct.h           | kin_getNetProductionRates                |           |
|         | ct.h           | kin_getSourceTerms                       |           |
| To test | ct.h           | kin_multiplier                           | inlined   |
|         | ct.h           | kin_getReactionString                    |           |
|         | ct.h           | kin_setMultiplier                        |           |
| To test | ct.h           | kin_isReversible                         | inlined   |
|         | ct.h           | kin_getType                              |           |
| To test | ct.h           | kin_start                                | inlined   |
|         | ct.h           | kin_speciesIndex                         |           |
| To test | ct.h           | kin_advanceCoverages                     | inlined   |
| To test | ct.h           | kin_phase                                | inlined   |
| To test | ct.h           | trans_newDefault                         | inlined   |
|         | ct.h           | trans_new                                |           |
| To test | ct.h           | trans_del                                | inlined   |
| To test | ct.h           | trans_transportModel                     | inlined   |
| To test | ct.h           | trans_viscosity                          | inlined   |
| To test | ct.h           | trans_electricalConductivity             | inlined   |
|         | ct.h           | trans_thermalConductivity                |           |
|         | ct.h           | trans_getThermalDiffCoeffs               |           |
|         | ct.h           | trans_getMixDiffCoeffs                   |           |
|         | ct.h           | trans_getBinDiffCoeffs                   |           |
|         | ct.h           | trans_getMultiDiffCoeffs                 |           |
|         | ct.h           | trans_setParameters                      |           |
|         | ct.h           | trans_getMolarFluxes                     |           |
|         | ct.h           | trans_getMassFluxes                      |           |
|         | ct.h           | ct_getCanteraError                       |           |
|         | ct.h           | ct_setLogWriter                          |           |
|         | ct.h           | ct_setLogCallback                        |           |
|         | ct.h           | ct_addCanteraDirectory                   |           |
|         | ct.h           | ct_getDataDirectories                    |           |
|         | ct.h           | ct_getCanteraVersion                     |           |
|         | ct.h           | ct_getGitCommit                          |           |
| Tested  | ct.h           | ct_suppress_thermo_warnings              | inlined   |
| Tested  | ct.h           | ct_use_legacy_rate_constants             | inlined   |
| Tested  | ct.h           | ct_clearStorage                          | inlined   |
| Tested  | ct.h           | ct_resetStorage                          | inlined   |

### API of `ctfunc.h`

Documentation [here](https://cantera.org/documentation/docs-3.0/doxygen/html/df/dd5/ctfunc_8h.html).

| Status  | Header         | Function                                 | Module    |
| ------- | -------------: | ---------------------------------------- | :-------: |
|         | ctfunc.h       | func_new                                 |           |
|         | ctfunc.h       | func_new_basic                           |           |
|         | ctfunc.h       | func_new_advanced                        |           |
|         | ctfunc.h       | func_new_compound                        |           |
|         | ctfunc.h       | func_new_modified                        |           |
| To test | ctfunc.h       | func_del                                 | inlined   |
|         | ctfunc.h       | func_type                                |           |
| To test | ctfunc.h       | func_value                               | inlined   |
| To test | ctfunc.h       | func_derivative                          | inlined   |
| To test | ctfunc.h       | func_duplicate                           | inlined   |
|         | ctfunc.h       | func_write                               |           |
| To test | ctfunc.h       | ct_clearFunc                             | inlined   |

### API of `ctmultiphase.h`

Documentation [here](https://cantera.org/documentation/docs-3.0/doxygen/html/de/db9/ctmultiphase_8h.html).

| Status  | Header         | Function                                 | Module    |
| ------- | -------------: | ---------------------------------------- | :-------: |
| To test | ctmultiphase.h | mix_new                                  | inlined   |
| To test | ctmultiphase.h | mix_del                                  | inlined   |
| To test | ctmultiphase.h | ct_clearMix                              | inlined   |
|         | ctmultiphase.h | mix_addPhase                             |           |
| To test | ctmultiphase.h | mix_init                                 | inlined   |
| To test | ctmultiphase.h | mix_updatePhases                         | inlined   |
| To test | ctmultiphase.h | mix_nElements                            | inlined   |
|         | ctmultiphase.h | mix_elementIndex                         |           |
|         | ctmultiphase.h | mix_speciesIndex                         |           |
| To test | ctmultiphase.h | mix_nSpecies                             | inlined   |
| To test | ctmultiphase.h | mix_setTemperature                       | inlined   |
| To test | ctmultiphase.h | mix_temperature                          | inlined   |
| To test | ctmultiphase.h | mix_minTemp                              | inlined   |
| To test | ctmultiphase.h | mix_maxTemp                              | inlined   |
| To test | ctmultiphase.h | mix_charge                               | inlined   |
| To test | ctmultiphase.h | mix_phaseCharge                          | inlined   |
| To test | ctmultiphase.h | mix_setPressure                          | inlined   |
| To test | ctmultiphase.h | mix_pressure                             | inlined   |
| To test | ctmultiphase.h | mix_nAtoms                               | inlined   |
| To test | ctmultiphase.h | mix_nPhases                              | inlined   |
| To test | ctmultiphase.h | mix_phaseMoles                           | inlined   |
|         | ctmultiphase.h | mix_setPhaseMoles                        |           |
|         | ctmultiphase.h | mix_setMoles                             |           |
|         | ctmultiphase.h | mix_setMolesByName                       |           |
| To test | ctmultiphase.h | mix_speciesMoles                         | inlined   |
| To test | ctmultiphase.h | mix_elementMoles                         | inlined   |
|         | ctmultiphase.h | mix_equilibrate                          |           |
|         | ctmultiphase.h | mix_getChemPotentials                    |           |
| To test | ctmultiphase.h | mix_enthalpy                             | inlined   |
| To test | ctmultiphase.h | mix_entropy                              | inlined   |
| To test | ctmultiphase.h | mix_gibbs                                | inlined   |
| To test | ctmultiphase.h | mix_cp                                   | inlined   |
| To test | ctmultiphase.h | mix_volume                               | inlined   |
| To test | ctmultiphase.h | mix_speciesPhaseIndex                    | inlined   |
| To test | ctmultiphase.h | mix_moleFraction                         | inlined   |

### API of `ctonedim.h`

Documentation [here](https://cantera.org/documentation/docs-3.0/doxygen/html/d0/db6/ctonedim_8h.html).

| Status  | Header         | Function                                 | Module    |
| ------- | -------------: | ---------------------------------------- | :-------: |
| To test | ctonedim.h     | ct_clearOneDim                           | inlined   |
|         | ctonedim.h     | domain_new                               |           |
| To test | ctonedim.h     | domain_del                               | inlined   |
| To test | ctonedim.h     | domain_type                              | inlined   |
|         | ctonedim.h     | domain_type3                             |           |
| To test | ctonedim.h     | domain_index                             | inlined   |
| To test | ctonedim.h     | domain_nComponents                       | inlined   |
| To test | ctonedim.h     | domain_nPoints                           | inlined   |
|         | ctonedim.h     | domain_componentName                     |           |
|         | ctonedim.h     | domain_componentIndex                    |           |
|         | ctonedim.h     | domain_setBounds                         |           |
| To test | ctonedim.h     | domain_lowerBound                        | inlined   |
| To test | ctonedim.h     | domain_upperBound                        | inlined   |
|         | ctonedim.h     | domain_setSteadyTolerances               |           |
|         | ctonedim.h     | domain_setTransientTolerances            |           |
| To test | ctonedim.h     | domain_rtol                              | inlined   |
| To test | ctonedim.h     | domain_atol                              | inlined   |
|         | ctonedim.h     | domain_setupGrid                         |           |
|         | ctonedim.h     | domain_setID                             |           |
| To test | ctonedim.h     | domain_grid                              | inlined   |
| To test | ctonedim.h     | bdry_setMdot                             | inlined   |
| To test | ctonedim.h     | bdry_setTemperature                      | inlined   |
| To test | ctonedim.h     | bdry_setSpreadRate                       | inlined   |
|         | ctonedim.h     | bdry_setMoleFractions                    |           |
| To test | ctonedim.h     | bdry_temperature                         | inlined   |
| To test | ctonedim.h     | bdry_spreadRate                          | inlined   |
| To test | ctonedim.h     | bdry_massFraction                        | inlined   |
| To test | ctonedim.h     | bdry_mdot                                | inlined   |
| To test | ctonedim.h     | reactingsurf_setkineticsmgr              | inlined   |
| To test | ctonedim.h     | reactingsurf_enableCoverageEqs           | inlined   |
| To test | ctonedim.h     | inlet_new                                | inlined   |
| To test | ctonedim.h     | outlet_new                               | inlined   |
| To test | ctonedim.h     | outletres_new                            | inlined   |
| To test | ctonedim.h     | symm_new                                 | inlined   |
| To test | ctonedim.h     | surf_new                                 | inlined   |
| To test | ctonedim.h     | reactingsurf_new                         | inlined   |
| To test | ctonedim.h     | inlet_setSpreadRate                      | inlined   |
|         | ctonedim.h     | stflow_new                               |           |
| To test | ctonedim.h     | stflow_setTransport                      | inlined   |
| To test | ctonedim.h     | stflow_enableSoret                       | inlined   |
| To test | ctonedim.h     | stflow_setPressure                       | inlined   |
| To test | ctonedim.h     | stflow_pressure                          | inlined   |
|         | ctonedim.h     | stflow_setFixedTempProfile               |           |
| To test | ctonedim.h     | stflow_solveEnergyEqn                    | inlined   |
|         | ctonedim.h     | sim1D_new                                |           |
| To test | ctonedim.h     | sim1D_del                                | inlined   |
|         | ctonedim.h     | sim1D_setValue                           |           |
|         | ctonedim.h     | sim1D_setProfile                         |           |
|         | ctonedim.h     | sim1D_setFlatProfile                     |           |
|         | ctonedim.h     | sim1D_show                               |           |
|         | ctonedim.h     | sim1D_showSolution                       |           |
|         | ctonedim.h     | sim1D_setTimeStep                        |           |
| To test | ctonedim.h     | sim1D_getInitialSoln                     | inlined   |
|         | ctonedim.h     | sim1D_solve                              |           |
| To test | ctonedim.h     | sim1D_refine                             | inlined   |
|         | ctonedim.h     | sim1D_setRefineCriteria                  |           |
|         | ctonedim.h     | sim1D_setGridMin                         |           |
|         | ctonedim.h     | sim1D_save                               |           |
|         | ctonedim.h     | sim1D_restore                            |           |
| To test | ctonedim.h     | sim1D_writeStats                         | inlined   |
|         | ctonedim.h     | sim1D_domainIndex                        |           |
|         | ctonedim.h     | sim1D_value                              |           |
|         | ctonedim.h     | sim1D_workValue                          |           |
| To test | ctonedim.h     | sim1D_eval                               | inlined   |
| To test | ctonedim.h     | sim1D_setMaxJacAge                       | inlined   |
| To test | ctonedim.h     | sim1D_setFixedTemperature                | inlined   |

### API of `ctreactor.h`

Documentation [here](https://cantera.org/documentation/docs-3.0/doxygen/html/df/d63/ctreactor_8h.html).

| Status  | Header         | Function                                 | Module    |
| ------- | -------------: | ---------------------------------------- | :-------: |
|         | ctreactor.h    | reactor_new                              |           |
| To test | ctreactor.h    | reactor_del                              | inlined   |
| To test | ctreactor.h    | reactor_setInitialVolume                 | inlined   |
| To test | ctreactor.h    | reactor_setChemistry                     | inlined   |
| To test | ctreactor.h    | reactor_setEnergy                        | inlined   |
| To test | ctreactor.h    | reactor_setThermoMgr                     | inlined   |
| To test | ctreactor.h    | reactor_setKineticsMgr                   | inlined   |
| To test | ctreactor.h    | reactor_insert                           | inlined   |
| To test | ctreactor.h    | reactor_mass                             | inlined   |
| To test | ctreactor.h    | reactor_volume                           | inlined   |
| To test | ctreactor.h    | reactor_density                          | inlined   |
| To test | ctreactor.h    | reactor_temperature                      | inlined   |
| To test | ctreactor.h    | reactor_enthalpy_mass                    | inlined   |
| To test | ctreactor.h    | reactor_intEnergy_mass                   | inlined   |
| To test | ctreactor.h    | reactor_pressure                         | inlined   |
| To test | ctreactor.h    | reactor_massFraction                     | inlined   |
| To test | ctreactor.h    | reactor_nSensParams                      | inlined   |
| To test | ctreactor.h    | reactor_addSensitivityReaction           | inlined   |
| To test | ctreactor.h    | flowReactor_setMassFlowRate              | inlined   |
| To test | ctreactor.h    | reactornet_new                           | inlined   |
| To test | ctreactor.h    | reactornet_del                           | inlined   |
| To test | ctreactor.h    | reactornet_setInitialTime                | inlined   |
| To test | ctreactor.h    | reactornet_setMaxTimeStep                | inlined   |
| To test | ctreactor.h    | reactornet_setTolerances                 | inlined   |
| To test | ctreactor.h    | reactornet_setSensitivityTolerances      | inlined   |
| To test | ctreactor.h    | reactornet_addreactor                    | inlined   |
| To test | ctreactor.h    | reactornet_advance                       | inlined   |
| To test | ctreactor.h    | reactornet_step                          | inlined   |
| To test | ctreactor.h    | reactornet_time                          | inlined   |
| To test | ctreactor.h    | reactornet_rtol                          | inlined   |
| To test | ctreactor.h    | reactornet_atol                          | inlined   |
|         | ctreactor.h    | reactornet_sensitivity                   |           |
|         | ctreactor.h    | flowdev_new                              |           |
| To test | ctreactor.h    | flowdev_del                              | inlined   |
| To test | ctreactor.h    | flowdev_install                          | inlined   |
| To test | ctreactor.h    | flowdev_setMaster                        | inlined   |
| To test | ctreactor.h    | flowdev_setPrimary                       | inlined   |
| To test | ctreactor.h    | flowdev_massFlowRate                     | inlined   |
| To test | ctreactor.h    | flowdev_setMassFlowCoeff                 | inlined   |
| To test | ctreactor.h    | flowdev_setValveCoeff                    | inlined   |
| To test | ctreactor.h    | flowdev_setPressureCoeff                 | inlined   |
| To test | ctreactor.h    | flowdev_setPressureFunction              | inlined   |
| To test | ctreactor.h    | flowdev_setTimeFunction                  | inlined   |
|         | ctreactor.h    | wall_new                                 |           |
| To test | ctreactor.h    | wall_del                                 | inlined   |
| To test | ctreactor.h    | wall_install                             | inlined   |
| To test | ctreactor.h    | wall_vdot                                | inlined   |
| To test | ctreactor.h    | wall_expansionRate                       | inlined   |
| To test | ctreactor.h    | wall_Q                                   | inlined   |
| To test | ctreactor.h    | wall_heatRate                            | inlined   |
| To test | ctreactor.h    | wall_area                                | inlined   |
| To test | ctreactor.h    | wall_setArea                             | inlined   |
| To test | ctreactor.h    | wall_setThermalResistance                | inlined   |
| To test | ctreactor.h    | wall_setHeatTransferCoeff                | inlined   |
| To test | ctreactor.h    | wall_setHeatFlux                         | inlined   |
| To test | ctreactor.h    | wall_setExpansionRateCoeff               | inlined   |
| To test | ctreactor.h    | wall_setVelocity                         | inlined   |
| To test | ctreactor.h    | wall_setEmissivity                       | inlined   |
| To test | ctreactor.h    | wall_ready                               | inlined   |
| To test | ctreactor.h    | reactorsurface_new                       | inlined   |
| To test | ctreactor.h    | reactorsurface_del                       | inlined   |
| To test | ctreactor.h    | reactorsurface_install                   | inlined   |
| To test | ctreactor.h    | reactorsurface_setkinetics               | inlined   |
| To test | ctreactor.h    | reactorsurface_area                      | inlined   |
| To test | ctreactor.h    | reactorsurface_setArea                   | inlined   |
| To test | ctreactor.h    | reactorsurface_addSensitivityReaction    | inlined   |
| To test | ctreactor.h    | ct_clearReactors                         | inlined   |

### API of `ctrpath.h`

Documentation [here](https://cantera.org/documentation/docs-3.0/doxygen/html/db/dcd/ctrpath_8h.html).

| Status  | Header         | Function                                 | Module    |
| ------- | -------------: | ---------------------------------------- | :-------: |
| To test | ctrpath.h      | rdiag_new                                | inlined   |
| To test | ctrpath.h      | rdiag_del                                | inlined   |
| To test | ctrpath.h      | rdiag_detailed                           | inlined   |
| To test | ctrpath.h      | rdiag_brief                              | inlined   |
| To test | ctrpath.h      | rdiag_setThreshold                       | inlined   |
|         | ctrpath.h      | rdiag_setBoldColor                       |           |
|         | ctrpath.h      | rdiag_setNormalColor                     |           |
|         | ctrpath.h      | rdiag_setDashedColor                     |           |
|         | ctrpath.h      | rdiag_setDotOptions                      |           |
| To test | ctrpath.h      | rdiag_setBoldThreshold                   | inlined   |
| To test | ctrpath.h      | rdiag_setNormalThreshold                 | inlined   |
| To test | ctrpath.h      | rdiag_setLabelThreshold                  | inlined   |
| To test | ctrpath.h      | rdiag_setScale                           | inlined   |
| To test | ctrpath.h      | rdiag_setFlowType                        | inlined   |
| To test | ctrpath.h      | rdiag_setArrowWidth                      | inlined   |
|         | ctrpath.h      | rdiag_setTitle                           |           |
|         | ctrpath.h      | rdiag_write                              |           |
| To test | ctrpath.h      | rdiag_add                                | inlined   |
|         | ctrpath.h      | rdiag_findMajor                          |           |
|         | ctrpath.h      | rdiag_setFont                            |           |
| To test | ctrpath.h      | rdiag_displayOnly                        | inlined   |
| To test | ctrpath.h      | rbuild_new                               | inlined   |
| To test | ctrpath.h      | rbuild_del                               | inlined   |
|         | ctrpath.h      | rbuild_init                              |           |
|         | ctrpath.h      | rbuild_build                             |           |
| To test | ctrpath.h      | ct_clearReactionPath                     | inlined   |

### API of `ctsurf.h`

Documentation [here](https://cantera.org/documentation/docs-3.0/doxygen/html/d6/dd6/ctsurf_8h.html).

| Status  | Header         | Function                                 | Module    |
| ------- | -------------: | ---------------------------------------- | :-------: |
|         | ctsurf.h       | surf_setCoverages                        |           |
|         | ctsurf.h       | surf_getCoverages                        |           |
|         | ctsurf.h       | surf_setConcentrations                   |           |
|         | ctsurf.h       | surf_getConcentrations                   |           |
| To test | ctsurf.h       | surf_setSiteDensity                      | inlined   |
| To test | ctsurf.h       | surf_siteDensity                         | inlined   |
|         | ctsurf.h       | surf_setCoveragesByName                  |           |

