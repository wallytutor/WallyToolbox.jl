# -*- coding: utf-8 -*-

const CT_APPDELETE                          = FnShared(
        :ct_appdelete)

const CT_GETCANTERAERROR                    = FnShared(
        :ct_getCanteraError)

const CT_SETLOGWRITER                       = FnShared(
        :ct_setLogWriter)

const CT_SETLOGCALLBACK                     = FnShared(
        :ct_setLogCallback)

const CT_ADDCANTERADIRECTORY                = FnShared(
        :ct_addCanteraDirectory)

const CT_GETDATADIRECTORIES                 = FnShared(
        :ct_getDataDirectories)

const CT_GETCANTERAVERSION                  = FnShared(
        :ct_getCanteraVersion)

const CT_GETGITCOMMIT                       = FnShared(
        :ct_getGitCommit)

const CT_SUPPRESS_THERMO_WARNINGS           = FnShared(
        :ct_suppress_thermo_warnings)

const CT_USE_LEGACY_RATE_CONSTANTS          = FnShared(
        :ct_use_legacy_rate_constants)

const CT_CLEARSTORAGE                       = FnShared(
        :ct_clearStorage)

const CT_RESETSTORAGE                       = FnShared(
        :ct_resetStorage)

const CT_CLEARFUNC                          = FnShared(
        :ct_clearFunc)

const CT_CLEARMIX                           = FnShared(
        :ct_clearMix)

const CT_CLEARONEDIM                        = FnShared(
        :ct_clearOneDim)

const CT_CLEARREACTORS                      = FnShared(
        :ct_clearReactors)

const CT_CLEARREACTIONPATH                  = FnShared(
        :ct_clearReactionPath)

const SOLN_NEWSOLUTION                      = FnShared(
        :soln_newSolution)

const SOLN_NEWINTERFACE                     = FnShared(
        :soln_newInterface)

const SOLN_DEL                              = FnShared(
        :soln_del)

const SOLN_NAME                             = FnShared(
        :soln_name)

const SOLN_THERMO                           = FnShared(
        :soln_thermo)

const SOLN_KINETICS                         = FnShared(
        :soln_kinetics)

const SOLN_TRANSPORT                        = FnShared(
        :soln_transport)

const SOLN_SETTRANSPORTMODEL                = FnShared(
        :soln_setTransportModel)

const SOLN_NADJACENT                        = FnShared(
        :soln_nAdjacent)

const SOLN_ADJACENT                         = FnShared(
        :soln_adjacent)

const THERMO_NEWFROMFILE                    = FnShared(
        :thermo_newFromFile)

const THERMO_DEL                            = FnShared(
        :thermo_del)

const THERMO_NSPECIES                       = FnShared(
        :thermo_nSpecies)

const THERMO_NELEMENTS                      = FnShared(
        :thermo_nElements)

const THERMO_TEMPERATURE                    = FnShared(
        :thermo_temperature)

const THERMO_SETTEMPERATURE                 = FnShared(
        :thermo_setTemperature)

const THERMO_DENSITY                        = FnShared(
        :thermo_density)

const THERMO_SETDENSITY                     = FnShared(
        :thermo_setDensity)

const THERMO_MOLARDENSITY                   = FnShared(
        :thermo_molarDensity)

const THERMO_SETMOLARDENSITY                = FnShared(
        :thermo_setMolarDensity)

const THERMO_MEANMOLECULARWEIGHT            = FnShared(
        :thermo_meanMolecularWeight)

const THERMO_MOLEFRACTION                   = FnShared(
        :thermo_moleFraction)

const THERMO_MASSFRACTION                   = FnShared(
        :thermo_massFraction)

const THERMO_GETMOLEFRACTIONS               = FnShared(
        :thermo_getMoleFractions)

const THERMO_GETMASSFRACTIONS               = FnShared(
        :thermo_getMassFractions)

const THERMO_SETMOLEFRACTIONS               = FnShared(
        :thermo_setMoleFractions)

const THERMO_SETMASSFRACTIONS               = FnShared(
        :thermo_setMassFractions)

const THERMO_SETMOLEFRACTIONSBYNAME         = FnShared(
        :thermo_setMoleFractionsByName)

const THERMO_SETMASSFRACTIONSBYNAME         = FnShared(
        :thermo_setMassFractionsByName)

const THERMO_GETATOMICWEIGHTS               = FnShared(
        :thermo_getAtomicWeights)

const THERMO_GETMOLECULARWEIGHTS            = FnShared(
        :thermo_getMolecularWeights)

const THERMO_GETCHARGES                     = FnShared(
        :thermo_getCharges)

const THERMO_GETELEMENTNAME                 = FnShared(
        :thermo_getElementName)

const THERMO_GETSPECIESNAME                 = FnShared(
        :thermo_getSpeciesName)

const THERMO_GETNAME                        = FnShared(
        :thermo_getName)

const THERMO_SETNAME                        = FnShared(
        :thermo_setName)

const THERMO_ELEMENTINDEX                   = FnShared(
        :thermo_elementIndex)

const THERMO_SPECIESINDEX                   = FnShared(
        :thermo_speciesIndex)

const THERMO_REPORT                         = FnShared(
        :thermo_report)

const THERMO_PRINT                          = FnShared(
        :thermo_print)

const THERMO_NATOMS                         = FnShared(
        :thermo_nAtoms)

const THERMO_ADDELEMENT                     = FnShared(
        :thermo_addElement)

const THERMO_GETEOSTYPE                     = FnShared(
        :thermo_getEosType)

const THERMO_REFPRESSURE                    = FnShared(
        :thermo_refPressure)

const THERMO_MINTEMP                        = FnShared(
        :thermo_minTemp)

const THERMO_MAXTEMP                        = FnShared(
        :thermo_maxTemp)

const THERMO_ENTHALPY_MOLE                  = FnShared(
        :thermo_enthalpy_mole)

const THERMO_INTENERGY_MOLE                 = FnShared(
        :thermo_intEnergy_mole)

const THERMO_ENTROPY_MOLE                   = FnShared(
        :thermo_entropy_mole)

const THERMO_GIBBS_MOLE                     = FnShared(
        :thermo_gibbs_mole)

const THERMO_CP_MOLE                        = FnShared(
        :thermo_cp_mole)

const THERMO_CV_MOLE                        = FnShared(
        :thermo_cv_mole)

const THERMO_PRESSURE                       = FnShared(
        :thermo_pressure)

const THERMO_SETPRESSURE                    = FnShared(
        :thermo_setPressure)

const THERMO_ENTHALPY_MASS                  = FnShared(
        :thermo_enthalpy_mass)

const THERMO_INTENERGY_MASS                 = FnShared(
        :thermo_intEnergy_mass)

const THERMO_ENTROPY_MASS                   = FnShared(
        :thermo_entropy_mass)

const THERMO_GIBBS_MASS                     = FnShared(
        :thermo_gibbs_mass)

const THERMO_CP_MASS                        = FnShared(
        :thermo_cp_mass)

const THERMO_CV_MASS                        = FnShared(
        :thermo_cv_mass)

const THERMO_ELECTRICPOTENTIAL              = FnShared(
        :thermo_electricPotential)

const THERMO_THERMALEXPANSIONCOEFF          = FnShared(
        :thermo_thermalExpansionCoeff)

const THERMO_ISOTHERMALCOMPRESSIBILITY      = FnShared(
        :thermo_isothermalCompressibility)

const THERMO_CHEMPOTENTIALS                 = FnShared(
        :thermo_chemPotentials)

const THERMO_GETENTHALPIES_RT               = FnShared(
        :thermo_getEnthalpies_RT)

const THERMO_GETENTROPIES_R                 = FnShared(
        :thermo_getEntropies_R)

const THERMO_GETCP_R                        = FnShared(
        :thermo_getCp_R)

const THERMO_SETELECTRICPOTENTIAL           = FnShared(
        :thermo_setElectricPotential)

const THERMO_SET_TP                         = FnShared(
        :thermo_set_TP)

const THERMO_SET_TD                         = FnShared(
        :thermo_set_TD)

const THERMO_SET_RP                         = FnShared(
        :thermo_set_RP)

const THERMO_SET_DP                         = FnShared(
        :thermo_set_DP)

const THERMO_SET_HP                         = FnShared(
        :thermo_set_HP)

const THERMO_SET_UV                         = FnShared(
        :thermo_set_UV)

const THERMO_SET_SV                         = FnShared(
        :thermo_set_SV)

const THERMO_SET_SP                         = FnShared(
        :thermo_set_SP)

const THERMO_SET_ST                         = FnShared(
        :thermo_set_ST)

const THERMO_SET_TV                         = FnShared(
        :thermo_set_TV)

const THERMO_SET_PV                         = FnShared(
        :thermo_set_PV)

const THERMO_SET_UP                         = FnShared(
        :thermo_set_UP)

const THERMO_SET_VH                         = FnShared(
        :thermo_set_VH)

const THERMO_SET_TH                         = FnShared(
        :thermo_set_TH)

const THERMO_SET_SH                         = FnShared(
        :thermo_set_SH)

const THERMO_EQUILIBRATE                    = FnShared(
        :thermo_equilibrate)

const THERMO_CRITTEMPERATURE                = FnShared(
        :thermo_critTemperature)

const THERMO_CRITPRESSURE                   = FnShared(
        :thermo_critPressure)

const THERMO_CRITDENSITY                    = FnShared(
        :thermo_critDensity)

const THERMO_VAPORFRACTION                  = FnShared(
        :thermo_vaporFraction)

const THERMO_SATTEMPERATURE                 = FnShared(
        :thermo_satTemperature)

const THERMO_SATPRESSURE                    = FnShared(
        :thermo_satPressure)

const THERMO_SETSTATE_PSAT                  = FnShared(
        :thermo_setState_Psat)

const THERMO_SETSTATE_TSAT                  = FnShared(
        :thermo_setState_Tsat)

const KIN_NEWFROMFILE                       = FnShared(
        :kin_newFromFile)

const KIN_DEL                               = FnShared(
        :kin_del)

const KIN_NSPECIES                          = FnShared(
        :kin_nSpecies)

const KIN_NREACTIONS                        = FnShared(
        :kin_nReactions)

const KIN_NPHASES                           = FnShared(
        :kin_nPhases)

const KIN_PHASEINDEX                        = FnShared(
        :kin_phaseIndex)

const KIN_REACTIONPHASEINDEX                = FnShared(
        :kin_reactionPhaseIndex)

const KIN_REACTANTSTOICHCOEFF               = FnShared(
        :kin_reactantStoichCoeff)

const KIN_PRODUCTSTOICHCOEFF                = FnShared(
        :kin_productStoichCoeff)

const KIN_GETREACTIONTYPE                   = FnShared(
        :kin_getReactionType)

const KIN_GETFWDRATESOFPROGRESS             = FnShared(
        :kin_getFwdRatesOfProgress)

const KIN_GETREVRATESOFPROGRESS             = FnShared(
        :kin_getRevRatesOfProgress)

const KIN_GETNETRATESOFPROGRESS             = FnShared(
        :kin_getNetRatesOfProgress)

const KIN_GETEQUILIBRIUMCONSTANTS           = FnShared(
        :kin_getEquilibriumConstants)

const KIN_GETFWDRATECONSTANTS               = FnShared(
        :kin_getFwdRateConstants)

const KIN_GETREVRATECONSTANTS               = FnShared(
        :kin_getRevRateConstants)

const KIN_GETDELTA                          = FnShared(
        :kin_getDelta)

const KIN_GETCREATIONRATES                  = FnShared(
        :kin_getCreationRates)

const KIN_GETDESTRUCTIONRATES               = FnShared(
        :kin_getDestructionRates)

const KIN_GETNETPRODUCTIONRATES             = FnShared(
        :kin_getNetProductionRates)

const KIN_GETSOURCETERMS                    = FnShared(
        :kin_getSourceTerms)

const KIN_MULTIPLIER                        = FnShared(
        :kin_multiplier)

const KIN_GETREACTIONSTRING                 = FnShared(
        :kin_getReactionString)

const KIN_SETMULTIPLIER                     = FnShared(
        :kin_setMultiplier)

const KIN_ISREVERSIBLE                      = FnShared(
        :kin_isReversible)

const KIN_GETTYPE                           = FnShared(
        :kin_getType)

const KIN_START                             = FnShared(
        :kin_start)

const KIN_SPECIESINDEX                      = FnShared(
        :kin_speciesIndex)

const KIN_ADVANCECOVERAGES                  = FnShared(
        :kin_advanceCoverages)

const KIN_PHASE                             = FnShared(
        :kin_phase)

const TRANS_NEWDEFAULT                      = FnShared(
        :trans_newDefault)

const TRANS_NEW                             = FnShared(
        :trans_new)

const TRANS_DEL                             = FnShared(
        :trans_del)

const TRANS_TRANSPORTMODEL                  = FnShared(
        :trans_transportModel)

const TRANS_VISCOSITY                       = FnShared(
        :trans_viscosity)

const TRANS_ELECTRICALCONDUCTIVITY          = FnShared(
        :trans_electricalConductivity)

const TRANS_THERMALCONDUCTIVITY             = FnShared(
        :trans_thermalConductivity)

const TRANS_GETTHERMALDIFFCOEFFS            = FnShared(
        :trans_getThermalDiffCoeffs)

const TRANS_GETMIXDIFFCOEFFS                = FnShared(
        :trans_getMixDiffCoeffs)

const TRANS_GETBINDIFFCOEFFS                = FnShared(
        :trans_getBinDiffCoeffs)

const TRANS_GETMULTIDIFFCOEFFS              = FnShared(
        :trans_getMultiDiffCoeffs)

const TRANS_SETPARAMETERS                   = FnShared(
        :trans_setParameters)

const TRANS_GETMOLARFLUXES                  = FnShared(
        :trans_getMolarFluxes)

const TRANS_GETMASSFLUXES                   = FnShared(
        :trans_getMassFluxes)

const FUNC_NEW                              = FnShared(
        :func_new)

const FUNC_NEW_BASIC                        = FnShared(
        :func_new_basic)

const FUNC_NEW_ADVANCED                     = FnShared(
        :func_new_advanced)

const FUNC_NEW_COMPOUND                     = FnShared(
        :func_new_compound)

const FUNC_NEW_MODIFIED                     = FnShared(
        :func_new_modified)

const FUNC_DEL                              = FnShared(
        :func_del)

const FUNC_TYPE                             = FnShared(
        :func_type)

const FUNC_VALUE                            = FnShared(
        :func_value)

const FUNC_DERIVATIVE                       = FnShared(
        :func_derivative)

const FUNC_DUPLICATE                        = FnShared(
        :func_duplicate)

const FUNC_WRITE                            = FnShared(
        :func_write)

const MIX_NEW                               = FnShared(
        :mix_new)

const MIX_DEL                               = FnShared(
        :mix_del)

const MIX_ADDPHASE                          = FnShared(
        :mix_addPhase)

const MIX_INIT                              = FnShared(
        :mix_init)

const MIX_UPDATEPHASES                      = FnShared(
        :mix_updatePhases)

const MIX_NELEMENTS                         = FnShared(
        :mix_nElements)

const MIX_ELEMENTINDEX                      = FnShared(
        :mix_elementIndex)

const MIX_SPECIESINDEX                      = FnShared(
        :mix_speciesIndex)

const MIX_NSPECIES                          = FnShared(
        :mix_nSpecies)

const MIX_SETTEMPERATURE                    = FnShared(
        :mix_setTemperature)

const MIX_TEMPERATURE                       = FnShared(
        :mix_temperature)

const MIX_MINTEMP                           = FnShared(
        :mix_minTemp)

const MIX_MAXTEMP                           = FnShared(
        :mix_maxTemp)

const MIX_CHARGE                            = FnShared(
        :mix_charge)

const MIX_PHASECHARGE                       = FnShared(
        :mix_phaseCharge)

const MIX_SETPRESSURE                       = FnShared(
        :mix_setPressure)

const MIX_PRESSURE                          = FnShared(
        :mix_pressure)

const MIX_NATOMS                            = FnShared(
        :mix_nAtoms)

const MIX_NPHASES                           = FnShared(
        :mix_nPhases)

const MIX_PHASEMOLES                        = FnShared(
        :mix_phaseMoles)

const MIX_SETPHASEMOLES                     = FnShared(
        :mix_setPhaseMoles)

const MIX_SETMOLES                          = FnShared(
        :mix_setMoles)

const MIX_SETMOLESBYNAME                    = FnShared(
        :mix_setMolesByName)

const MIX_SPECIESMOLES                      = FnShared(
        :mix_speciesMoles)

const MIX_ELEMENTMOLES                      = FnShared(
        :mix_elementMoles)

const MIX_EQUILIBRATE                       = FnShared(
        :mix_equilibrate)

const MIX_GETCHEMPOTENTIALS                 = FnShared(
        :mix_getChemPotentials)

const MIX_ENTHALPY                          = FnShared(
        :mix_enthalpy)

const MIX_ENTROPY                           = FnShared(
        :mix_entropy)

const MIX_GIBBS                             = FnShared(
        :mix_gibbs)

const MIX_CP                                = FnShared(
        :mix_cp)

const MIX_VOLUME                            = FnShared(
        :mix_volume)

const MIX_SPECIESPHASEINDEX                 = FnShared(
        :mix_speciesPhaseIndex)

const MIX_MOLEFRACTION                      = FnShared(
        :mix_moleFraction)

const DOMAIN_NEW                            = FnShared(
        :domain_new)

const DOMAIN_DEL                            = FnShared(
        :domain_del)

const DOMAIN_TYPE                           = FnShared(
        :domain_type)

const DOMAIN_TYPE3                          = FnShared(
        :domain_type3)

const DOMAIN_INDEX                          = FnShared(
        :domain_index)

const DOMAIN_NCOMPONENTS                    = FnShared(
        :domain_nComponents)

const DOMAIN_NPOINTS                        = FnShared(
        :domain_nPoints)

const DOMAIN_COMPONENTNAME                  = FnShared(
        :domain_componentName)

const DOMAIN_COMPONENTINDEX                 = FnShared(
        :domain_componentIndex)

const DOMAIN_SETBOUNDS                      = FnShared(
        :domain_setBounds)

const DOMAIN_LOWERBOUND                     = FnShared(
        :domain_lowerBound)

const DOMAIN_UPPERBOUND                     = FnShared(
        :domain_upperBound)

const DOMAIN_SETSTEADYTOLERANCES            = FnShared(
        :domain_setSteadyTolerances)

const DOMAIN_SETTRANSIENTTOLERANCES         = FnShared(
        :domain_setTransientTolerances)

const DOMAIN_RTOL                           = FnShared(
        :domain_rtol)

const DOMAIN_ATOL                           = FnShared(
        :domain_atol)

const DOMAIN_SETUPGRID                      = FnShared(
        :domain_setupGrid)

const DOMAIN_SETID                          = FnShared(
        :domain_setID)

const DOMAIN_GRID                           = FnShared(
        :domain_grid)

const BDRY_SETMDOT                          = FnShared(
        :bdry_setMdot)

const BDRY_SETTEMPERATURE                   = FnShared(
        :bdry_setTemperature)

const BDRY_SETSPREADRATE                    = FnShared(
        :bdry_setSpreadRate)

const BDRY_SETMOLEFRACTIONS                 = FnShared(
        :bdry_setMoleFractions)

const BDRY_TEMPERATURE                      = FnShared(
        :bdry_temperature)

const BDRY_SPREADRATE                       = FnShared(
        :bdry_spreadRate)

const BDRY_MASSFRACTION                     = FnShared(
        :bdry_massFraction)

const BDRY_MDOT                             = FnShared(
        :bdry_mdot)

const REACTINGSURF_SETKINETICSMGR           = FnShared(
        :reactingsurf_setkineticsmgr)

const REACTINGSURF_ENABLECOVERAGEEQS        = FnShared(
        :reactingsurf_enableCoverageEqs)

const INLET_NEW                             = FnShared(
        :inlet_new)

const OUTLET_NEW                            = FnShared(
        :outlet_new)

const OUTLETRES_NEW                         = FnShared(
        :outletres_new)

const SYMM_NEW                              = FnShared(
        :symm_new)

const SURF_NEW                              = FnShared(
        :surf_new)

const REACTINGSURF_NEW                      = FnShared(
        :reactingsurf_new)

const INLET_SETSPREADRATE                   = FnShared(
        :inlet_setSpreadRate)

const STFLOW_NEW                            = FnShared(
        :stflow_new)

const STFLOW_SETTRANSPORT                   = FnShared(
        :stflow_setTransport)

const STFLOW_ENABLESORET                    = FnShared(
        :stflow_enableSoret)

const STFLOW_SETPRESSURE                    = FnShared(
        :stflow_setPressure)

const STFLOW_PRESSURE                       = FnShared(
        :stflow_pressure)

const STFLOW_SETFIXEDTEMPPROFILE            = FnShared(
        :stflow_setFixedTempProfile)

const STFLOW_SOLVEENERGYEQN                 = FnShared(
        :stflow_solveEnergyEqn)

const SIM1D_NEW                             = FnShared(
        :sim1D_new)

const SIM1D_DEL                             = FnShared(
        :sim1D_del)

const SIM1D_SETVALUE                        = FnShared(
        :sim1D_setValue)

const SIM1D_SETPROFILE                      = FnShared(
        :sim1D_setProfile)

const SIM1D_SETFLATPROFILE                  = FnShared(
        :sim1D_setFlatProfile)

const SIM1D_SHOW                            = FnShared(
        :sim1D_show)

const SIM1D_SHOWSOLUTION                    = FnShared(
        :sim1D_showSolution)

const SIM1D_SETTIMESTEP                     = FnShared(
        :sim1D_setTimeStep)

const SIM1D_GETINITIALSOLN                  = FnShared(
        :sim1D_getInitialSoln)

const SIM1D_SOLVE                           = FnShared(
        :sim1D_solve)

const SIM1D_REFINE                          = FnShared(
        :sim1D_refine)

const SIM1D_SETREFINECRITERIA               = FnShared(
        :sim1D_setRefineCriteria)

const SIM1D_SETGRIDMIN                      = FnShared(
        :sim1D_setGridMin)

const SIM1D_SAVE                            = FnShared(
        :sim1D_save)

const SIM1D_RESTORE                         = FnShared(
        :sim1D_restore)

const SIM1D_WRITESTATS                      = FnShared(
        :sim1D_writeStats)

const SIM1D_DOMAININDEX                     = FnShared(
        :sim1D_domainIndex)

const SIM1D_VALUE                           = FnShared(
        :sim1D_value)

const SIM1D_WORKVALUE                       = FnShared(
        :sim1D_workValue)

const SIM1D_EVAL                            = FnShared(
        :sim1D_eval)

const SIM1D_SETMAXJACAGE                    = FnShared(
        :sim1D_setMaxJacAge)

const SIM1D_SETFIXEDTEMPERATURE             = FnShared(
        :sim1D_setFixedTemperature)

const REACTOR_NEW                           = FnShared(
        :reactor_new)

const REACTOR_DEL                           = FnShared(
        :reactor_del)

const REACTOR_SETINITIALVOLUME              = FnShared(
        :reactor_setInitialVolume)

const REACTOR_SETCHEMISTRY                  = FnShared(
        :reactor_setChemistry)

const REACTOR_SETENERGY                     = FnShared(
        :reactor_setEnergy)

const REACTOR_SETTHERMOMGR                  = FnShared(
        :reactor_setThermoMgr)

const REACTOR_SETKINETICSMGR                = FnShared(
        :reactor_setKineticsMgr)

const REACTOR_INSERT                        = FnShared(
        :reactor_insert)

const REACTOR_MASS                          = FnShared(
        :reactor_mass)

const REACTOR_VOLUME                        = FnShared(
        :reactor_volume)

const REACTOR_DENSITY                       = FnShared(
        :reactor_density)

const REACTOR_TEMPERATURE                   = FnShared(
        :reactor_temperature)

const REACTOR_ENTHALPY_MASS                 = FnShared(
        :reactor_enthalpy_mass)

const REACTOR_INTENERGY_MASS                = FnShared(
        :reactor_intEnergy_mass)

const REACTOR_PRESSURE                      = FnShared(
        :reactor_pressure)

const REACTOR_MASSFRACTION                  = FnShared(
        :reactor_massFraction)

const REACTOR_NSENSPARAMS                   = FnShared(
        :reactor_nSensParams)

const REACTOR_ADDSENSITIVITYREACTION        = FnShared(
        :reactor_addSensitivityReaction)

const FLOWREACTOR_SETMASSFLOWRATE           = FnShared(
        :flowReactor_setMassFlowRate)

const REACTORNET_NEW                        = FnShared(
        :reactornet_new)

const REACTORNET_DEL                        = FnShared(
        :reactornet_del)

const REACTORNET_SETINITIALTIME             = FnShared(
        :reactornet_setInitialTime)

const REACTORNET_SETMAXTIMESTEP             = FnShared(
        :reactornet_setMaxTimeStep)

const REACTORNET_SETTOLERANCES              = FnShared(
        :reactornet_setTolerances)

const REACTORNET_SETSENSITIVITYTOLERANCES   = FnShared(
        :reactornet_setSensitivityTolerances)

const REACTORNET_ADDREACTOR                 = FnShared(
        :reactornet_addreactor)

const REACTORNET_ADVANCE                    = FnShared(
        :reactornet_advance)

const REACTORNET_STEP                       = FnShared(
        :reactornet_step)

const REACTORNET_TIME                       = FnShared(
        :reactornet_time)

const REACTORNET_RTOL                       = FnShared(
        :reactornet_rtol)

const REACTORNET_ATOL                       = FnShared(
        :reactornet_atol)

const REACTORNET_SENSITIVITY                = FnShared(
        :reactornet_sensitivity)

const FLOWDEV_NEW                           = FnShared(
        :flowdev_new)

const FLOWDEV_DEL                           = FnShared(
        :flowdev_del)

const FLOWDEV_INSTALL                       = FnShared(
        :flowdev_install)

const FLOWDEV_SETMASTER                     = FnShared(
        :flowdev_setMaster)

const FLOWDEV_SETPRIMARY                    = FnShared(
        :flowdev_setPrimary)

const FLOWDEV_MASSFLOWRATE                  = FnShared(
        :flowdev_massFlowRate)

const FLOWDEV_SETMASSFLOWCOEFF              = FnShared(
        :flowdev_setMassFlowCoeff)

const FLOWDEV_SETVALVECOEFF                 = FnShared(
        :flowdev_setValveCoeff)

const FLOWDEV_SETPRESSURECOEFF              = FnShared(
        :flowdev_setPressureCoeff)

const FLOWDEV_SETPRESSUREFUNCTION           = FnShared(
        :flowdev_setPressureFunction)

const FLOWDEV_SETTIMEFUNCTION               = FnShared(
        :flowdev_setTimeFunction)

const WALL_NEW                              = FnShared(
        :wall_new)

const WALL_DEL                              = FnShared(
        :wall_del)

const WALL_INSTALL                          = FnShared(
        :wall_install)

const WALL_VDOT                             = FnShared(
        :wall_vdot)

const WALL_EXPANSIONRATE                    = FnShared(
        :wall_expansionRate)

const WALL_Q                                = FnShared(
        :wall_Q)

const WALL_HEATRATE                         = FnShared(
        :wall_heatRate)

const WALL_AREA                             = FnShared(
        :wall_area)

const WALL_SETAREA                          = FnShared(
        :wall_setArea)

const WALL_SETTHERMALRESISTANCE             = FnShared(
        :wall_setThermalResistance)

const WALL_SETHEATTRANSFERCOEFF             = FnShared(
        :wall_setHeatTransferCoeff)

const WALL_SETHEATFLUX                      = FnShared(
        :wall_setHeatFlux)

const WALL_SETEXPANSIONRATECOEFF            = FnShared(
        :wall_setExpansionRateCoeff)

const WALL_SETVELOCITY                      = FnShared(
        :wall_setVelocity)

const WALL_SETEMISSIVITY                    = FnShared(
        :wall_setEmissivity)

const WALL_READY                            = FnShared(
        :wall_ready)

const REACTORSURFACE_NEW                    = FnShared(
        :reactorsurface_new)

const REACTORSURFACE_DEL                    = FnShared(
        :reactorsurface_del)

const REACTORSURFACE_INSTALL                = FnShared(
        :reactorsurface_install)

const REACTORSURFACE_SETKINETICS            = FnShared(
        :reactorsurface_setkinetics)

const REACTORSURFACE_AREA                   = FnShared(
        :reactorsurface_area)

const REACTORSURFACE_SETAREA                = FnShared(
        :reactorsurface_setArea)

const REACTORSURFACE_ADDSENSITIVITYREACTION = FnShared(
        :reactorsurface_addSensitivityReaction)

const RDIAG_NEW                             = FnShared(
        :rdiag_new)

const RDIAG_DEL                             = FnShared(
        :rdiag_del)

const RDIAG_DETAILED                        = FnShared(
        :rdiag_detailed)

const RDIAG_BRIEF                           = FnShared(
        :rdiag_brief)

const RDIAG_SETTHRESHOLD                    = FnShared(
        :rdiag_setThreshold)

const RDIAG_SETBOLDCOLOR                    = FnShared(
        :rdiag_setBoldColor)

const RDIAG_SETNORMALCOLOR                  = FnShared(
        :rdiag_setNormalColor)

const RDIAG_SETDASHEDCOLOR                  = FnShared(
        :rdiag_setDashedColor)

const RDIAG_SETDOTOPTIONS                   = FnShared(
        :rdiag_setDotOptions)

const RDIAG_SETBOLDTHRESHOLD                = FnShared(
        :rdiag_setBoldThreshold)

const RDIAG_SETNORMALTHRESHOLD              = FnShared(
        :rdiag_setNormalThreshold)

const RDIAG_SETLABELTHRESHOLD               = FnShared(
        :rdiag_setLabelThreshold)

const RDIAG_SETSCALE                        = FnShared(
        :rdiag_setScale)

const RDIAG_SETFLOWTYPE                     = FnShared(
        :rdiag_setFlowType)

const RDIAG_SETARROWWIDTH                   = FnShared(
        :rdiag_setArrowWidth)

const RDIAG_SETTITLE                        = FnShared(
        :rdiag_setTitle)

const RDIAG_WRITE                           = FnShared(
        :rdiag_write)

const RDIAG_ADD                             = FnShared(
        :rdiag_add)

const RDIAG_FINDMAJOR                       = FnShared(
        :rdiag_findMajor)

const RDIAG_SETFONT                         = FnShared(
        :rdiag_setFont)

const RDIAG_DISPLAYONLY                     = FnShared(
        :rdiag_displayOnly)

const RBUILD_NEW                            = FnShared(
        :rbuild_new)

const RBUILD_DEL                            = FnShared(
        :rbuild_del)

const RBUILD_INIT                           = FnShared(
        :rbuild_init)

const RBUILD_BUILD                          = FnShared(
        :rbuild_build)

const SURF_SETCOVERAGES                     = FnShared(
        :surf_setCoverages)

const SURF_GETCOVERAGES                     = FnShared(
        :surf_getCoverages)

const SURF_SETCONCENTRATIONS                = FnShared(
        :surf_setConcentrations)

const SURF_GETCONCENTRATIONS                = FnShared(
        :surf_getConcentrations)

const SURF_SETSITEDENSITY                   = FnShared(
        :surf_setSiteDensity)

const SURF_SITEDENSITY                      = FnShared(
        :surf_siteDensity)

const SURF_SETCOVERAGESBYNAME               = FnShared(
        :surf_setCoveragesByName)
