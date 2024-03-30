# -*- coding: utf-8 -*-
module Cantera

using Libdl
using Logging
using Printf

##############################################################################
# CORE LOADING
##############################################################################

# For now do not throw an error because otherwise the documentation build
# will fail. Find a way of getting Cantera working on workflow.
if !haskey(ENV, "CANTERA_SHARED")
    @warn "CANTERA_SHARED environment variable required"
    # error("CANTERA_SHARED environment variable required")
    const CANTERA = nothing
else
    const CANTERA = Libdl.dlopen(ENV["CANTERA_SHARED"])
end

struct FnShared
   ptr::Ptr{Nothing}
   name::String

   function FnShared(name)
       # Handle the missing library for documentation generation.
       if isnothing(CANTERA)
           return new()
       end
       return new(Libdl.dlsym(CANTERA, name), string(name))
   end
end

##############################################################################
# FUNCTION POINTERS
##############################################################################

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

##############################################################################
#
##############################################################################

begin # Helper functions
    function cbuffertostring(buf)
        buf[end] = 0
        return GC.@preserve buf unsafe_string(pointer(buf))
    end

    function string_fn(fn)
        function wrapper(n::Int32; buflen = 128)
            buf = Vector{UInt8}(undef, buflen)
            value = @ccall $(SOLN_NAME.ptr)(
                n::Int32, buflen::Int32, buf::Ptr{UInt8})::Int32
            systemerror("$(fn.name) (code $(value))", value <= 0)
            return cbuffertostring(buf)
        end
        return wrapper
    end

    function setfractions_fn(fn)
        # Keep allocation outside for reuse in this case!
        # Function with interface specific to setting fractions!
        function wrapper(n, buflen, buf, norm)
            value = @ccall $(fn.ptr)(
                n::Int32,
                buflen::Csize_t,
                buf::Ptr{Float64},
                norm::Int32
            )::Int32
            systemerror("$(fn.name) (code $(value))", value < 0)
            return value
        end
        return wrapper
    end
end

begin # Inlined interfaces
    i32 = Int32
    f64 = Float64
    csz = Csize_t
    p64 = Ptr{f64}

    VI_fn(f)   = ()        -> @ccall $(f.ptr)()::i32
    II_fn(f)   = (n)       -> @ccall $(f.ptr)(n::i32)::i32
    IS_fn(f)   = (n)       -> @ccall $(f.ptr)(n::i32)::csz
    IF_fn(f)   = (n)       -> @ccall $(f.ptr)(n::i32)::f64
    III_fn(f)  = (n, i)    -> @ccall $(f.ptr)(n::i32, i::i32)::i32
    IIS_fn(f)  = (n, i)    -> @ccall $(f.ptr)(n::i32, i::i32)::csz
    IIF_fn(f)  = (n, i)    -> @ccall $(f.ptr)(n::i32, i::i32)::f64
    ISS_fn(f)  = (n, i)    -> @ccall $(f.ptr)(n::i32, i::csz)::csz
    IFI_fn(f)  = (n, a)    -> @ccall $(f.ptr)(n::i32, a::f64)::i32
    IFF_fn(f)  = (n, a)    -> @ccall $(f.ptr)(n::i32, a::f64)::f64
    IIII_fn(f) = (n, i, j) -> @ccall $(f.ptr)(n::i32, i::i32, j::i32)::i32
    IIFI_fn(f) = (n, i, a) -> @ccall $(f.ptr)(n::i32, i::i32, a::f64)::i32
    IFII_fn(f) = (n, a, j) -> @ccall $(f.ptr)(n::i32, a::f64, j::i32)::i32
    IFFI_fn(f) = (n, a, b) -> @ccall $(f.ptr)(n::i32, a::f64, b::f64)::i32
    IIIF_fn(f) = (n, i, j) -> @ccall $(f.ptr)(n::i32, i::i32, j::i32)::f64
    ISAI_fn(f) = (n, l, a) -> @ccall $(f.ptr)(n::i32, l::csz, a::p64)::i32
end

begin # ct.h
    ct_appdelete                     = VI_fn(CT_APPDELETE)
    soln_del                         = II_fn(SOLN_DEL)
    soln_thermo                      = II_fn(SOLN_THERMO)
    soln_kinetics                    = II_fn(SOLN_KINETICS)
    soln_transport                   = II_fn(SOLN_TRANSPORT)
    soln_nAdjacent                   = IS_fn(SOLN_NADJACENT)
    thermo_del                       = II_fn(THERMO_DEL)
    thermo_nSpecies                  = IS_fn(THERMO_NSPECIES)
    thermo_nElements                 = IS_fn(THERMO_NELEMENTS)
    thermo_temperature               = IF_fn(THERMO_TEMPERATURE)
    thermo_setTemperature            = IFI_fn(THERMO_SETTEMPERATURE)
    thermo_density                   = IF_fn(THERMO_DENSITY)
    thermo_setDensity                = IFI_fn(THERMO_SETDENSITY)
    thermo_molarDensity              = IF_fn(THERMO_MOLARDENSITY)
    thermo_setMolarDensity           = IFI_fn(THERMO_SETMOLARDENSITY)
    thermo_meanMolecularWeight       = IF_fn(THERMO_MEANMOLECULARWEIGHT)
    thermo_moleFraction              = IIF_fn(THERMO_MOLEFRACTION)
    thermo_massFraction              = IIF_fn(THERMO_MASSFRACTION)
    thermo_getMoleFractions          = ISAI_fn(THERMO_GETMOLEFRACTIONS)
    thermo_getMassFractions          = ISAI_fn(THERMO_GETMASSFRACTIONS)
    thermo_print                     = IIFI_fn(THERMO_PRINT)
    thermo_refPressure               = IF_fn(THERMO_REFPRESSURE)
    thermo_minTemp                   = IIF_fn(THERMO_MINTEMP)
    thermo_maxTemp                   = IIF_fn(THERMO_MAXTEMP)
    thermo_enthalpy_mole             = IF_fn(THERMO_ENTHALPY_MOLE)
    thermo_intEnergy_mole            = IF_fn(THERMO_INTENERGY_MOLE)
    thermo_entropy_mole              = IF_fn(THERMO_ENTROPY_MOLE)
    thermo_gibbs_mole                = IF_fn(THERMO_GIBBS_MOLE)
    thermo_cp_mole                   = IF_fn(THERMO_CP_MOLE)
    thermo_cv_mole                   = IF_fn(THERMO_CV_MOLE)
    thermo_pressure                  = IF_fn(THERMO_PRESSURE)
    thermo_setPressure               = IFI_fn(THERMO_SETPRESSURE)
    thermo_enthalpy_mass             = IF_fn(THERMO_ENTHALPY_MASS)
    thermo_intEnergy_mass            = IF_fn(THERMO_INTENERGY_MASS)
    thermo_entropy_mass              = IF_fn(THERMO_ENTROPY_MASS)
    thermo_gibbs_mass                = IF_fn(THERMO_GIBBS_MASS)
    thermo_cp_mass                   = IF_fn(THERMO_CP_MASS)
    thermo_cv_mass                   = IF_fn(THERMO_CV_MASS)
    thermo_electricPotential         = IF_fn(THERMO_ELECTRICPOTENTIAL)
    thermo_thermalExpansionCoeff     = IF_fn(THERMO_THERMALEXPANSIONCOEFF)
    thermo_isothermalCompressibility = IF_fn(THERMO_ISOTHERMALCOMPRESSIBILITY)
    thermo_critTemperature           = IF_fn(THERMO_CRITTEMPERATURE)
    thermo_critPressure              = IF_fn(THERMO_CRITPRESSURE)
    thermo_critDensity               = IF_fn(THERMO_CRITDENSITY)
    thermo_vaporFraction             = IF_fn(THERMO_VAPORFRACTION)
    kin_del                          = II_fn(KIN_DEL)
    kin_nSpecies                     = IS_fn(KIN_NSPECIES)
    kin_nReactions                   = IS_fn(KIN_NREACTIONS)
    kin_nPhases                      = IS_fn(KIN_NPHASES)
    # kin_phaseIndex (int n, const char *ph)
    kin_reactionPhaseIndex           = IS_fn(KIN_REACTIONPHASEINDEX)
    kin_multiplier                   = IIF_fn(KIN_MULTIPLIER)
    kin_isReversible                 = III_fn(KIN_ISREVERSIBLE)
    kin_start                        = IIS_fn(KIN_START)
    kin_advanceCoverages             = IFI_fn(KIN_ADVANCECOVERAGES)
    kin_phase                        = ISS_fn(KIN_PHASE)
    trans_newDefault                 = III_fn(TRANS_NEWDEFAULT)
    trans_del                        = II_fn(TRANS_DEL)
    trans_viscosity                  = IF_fn(TRANS_VISCOSITY)
    trans_electricalConductivity     = IF_fn(TRANS_ELECTRICALCONDUCTIVITY)
    trans_thermalConductivity        = IF_fn(TRANS_THERMALCONDUCTIVITY)
    ct_suppress_thermo_warnings      = II_fn(CT_SUPPRESS_THERMO_WARNINGS)
    ct_use_legacy_rate_constants     = II_fn(CT_USE_LEGACY_RATE_CONSTANTS)
    ct_clearStorage                  = VI_fn(CT_CLEARSTORAGE)
    ct_resetStorage                  = VI_fn(CT_RESETSTORAGE)

     soln_name               = string_fn(SOLN_NAME)
     thermo_setMoleFractions = setfractions_fn(THERMO_SETMOLEFRACTIONS)
     thermo_setMassFractions = setfractions_fn(THERMO_SETMASSFRACTIONS)

    function soln_newSolution(infile, name, transport)
        # Returned value is the number of solution.
        value = @ccall $(SOLN_NEWSOLUTION.ptr)(
            infile::Cstring,
            name::Cstring,
            transport::Cstring
        )::Int32
        return value
    end

    function soln_setTransportModel(n, model)
        value = @ccall $(SOLN_SETTRANSPORTMODEL.ptr)(
            n::Int32,
            model::Cstring
        )::Int32
        systemerror("soln_setTransportModel $(value)", value < 0)
        return value
    end

    function thermo_newFromFile(filename, phasename)
        # Returned value is the number of solution.
        value = @ccall $(THERMO_NEWFROMFILE.ptr)(
            filename::Cstring,
            phasename::Cstring,
        )::Int32
        systemerror("thermo_newFromFile $(value)", value < 0)
        return value
    end

    function thermo_equilibrate(n, XY, solver, rtol, maxsteps,
                                maxiter, loglevel)
        return @ccall $(THERMO_EQUILIBRATE.ptr)(
            n::Int32, XY::Cstring, solver::Int32, rtol::Float64,
            maxsteps::Int32, maxiter::Int32, loglevel::Int32)::Int32
    end

    # function ct_addCanteraDirectory(path)
    #     buflen = length(path) + 1;
    #     buf = Vector{UInt8}(undef, buflen);

    #     # FIXME: there are better ways...
    #     for k in 1:buflen-1
    #         buf[k] = path[k];
    #     end

    #     err = @ccall $_ct_addCanteraDirectory(
    #         buflen::Int32,
    #         buf::Ptr{UInt8}
    #     )::Int32;

    #     systemerror("ct_addCanteraDirectory", err != 0);
    #     return err;
    # end

    # function ct_getDataDirectories(;buflen=2^12, sep=";")
    #     buf = Vector{UInt8}(undef, buflen);
    #     err = @ccall $_ct_getDataDirectories(
    #         buflen::Int32,
    #         buf::Ptr{UInt8},
    #         sep::Ptr{UInt8}
    #     )::Int32;

    #     systemerror("ct_getDataDirectories", err != 0);
    #     buf[end] = 0;

    #     path = GC.@preserve buf unsafe_string(pointer(buf));
    #     return split(path, sep);
    # end

    # function ct_getCanteraVersion()
    #     buflen = 16;
    #     buf = Vector{UInt8}(undef, buflen);
    #     err = @ccall $_ct_getCanteraVersion(
    #         buflen::Int32,
    #         buf::Ptr{UInt8}
    #     )::Int32;

    #     systemerror("ct_getCanteraVersion", err != 0);
    #     buf[end] = 0;

    #     return GC.@preserve buf unsafe_string(pointer(buf));
    # end

    # function ct_getGitCommit()
    #     buflen = 32;
    #     buf = Vector{UInt8}(undef, buflen);
    #     err = @ccall $_ct_getGitCommit(
    #         buflen::Int32,
    #         buf::Ptr{UInt8}
    #     )::Int32;

    #     systemerror("ct_getGitCommit", err != 0);
    #     buf[end] = 0;

    #     return GC.@preserve buf unsafe_string(pointer(buf));
    # end
end

begin # ctfunc.h
    func_del        = II_fn(FUNC_DEL)
    func_value      = IFF_fn(FUNC_VALUE)
    func_derivative = II_fn(FUNC_DERIVATIVE)
    func_duplicate  = II_fn(FUNC_DUPLICATE)
    ct_clearFunc    = VI_fn(CT_CLEARFUNC)
end

begin # ctmultiphase.h
    mix_new               = VI_fn(MIX_NEW)
    mix_del               = II_fn(MIX_DEL)
    ct_clearMix           = VI_fn(CT_CLEARMIX)
    mix_init              = II_fn(MIX_INIT)
    mix_updatePhases      = II_fn(MIX_UPDATEPHASES)
    mix_nElements         = IS_fn(MIX_NELEMENTS)
    mix_nSpecies          = IS_fn(MIX_NSPECIES)
    mix_setTemperature    = IFI_fn(MIX_SETTEMPERATURE)
    mix_temperature       = IF_fn(MIX_TEMPERATURE)
    mix_minTemp           = IF_fn(MIX_MINTEMP)
    mix_maxTemp           = IF_fn(MIX_MAXTEMP)
    mix_charge            = IF_fn(MIX_CHARGE)
    mix_phaseCharge       = IIF_fn(MIX_PHASECHARGE)
    mix_setPressure       = IFI_fn(MIX_SETPRESSURE)
    mix_pressure          = IF_fn(MIX_PRESSURE)
    mix_nAtoms            = IIIF_fn(MIX_NATOMS)
    mix_nPhases           = IS_fn(MIX_NPHASES)
    mix_phaseMoles        = IIF_fn(MIX_PHASEMOLES)
    mix_speciesMoles      = IIF_fn(MIX_SPECIESMOLES)
    mix_elementMoles      = IIF_fn(MIX_ELEMENTMOLES)
    mix_enthalpy          = IF_fn(MIX_ENTHALPY)
    mix_entropy           = IF_fn(MIX_ENTROPY)
    mix_gibbs             = IF_fn(MIX_GIBBS)
    mix_cp                = IF_fn(MIX_CP)
    mix_volume            = IF_fn(MIX_VOLUME)
    mix_speciesPhaseIndex = IIS_fn(MIX_SPECIESPHASEINDEX)
    mix_moleFraction      = IIF_fn(MIX_MOLEFRACTION)
end

begin # ctonedim.h
    ct_clearOneDim                 = VI_fn(CT_CLEARONEDIM)
    domain_del                     = II_fn(DOMAIN_DEL)
    domain_type                    = II_fn(DOMAIN_TYPE)
    domain_index                   = IS_fn(DOMAIN_INDEX)
    domain_nComponents             = IS_fn(DOMAIN_NCOMPONENTS)
    domain_nPoints                 = IS_fn(DOMAIN_NPOINTS)
    domain_lowerBound              = IIF_fn(DOMAIN_LOWERBOUND)
    domain_upperBound              = IIF_fn(DOMAIN_UPPERBOUND)
    domain_rtol                    = IIF_fn(DOMAIN_RTOL)
    domain_atol                    = IIF_fn(DOMAIN_ATOL)
    domain_grid                    = IIF_fn(DOMAIN_GRID)
    bdry_setMdot                   = IFI_fn(BDRY_SETMDOT)
    bdry_setTemperature            = IFI_fn(BDRY_SETTEMPERATURE)
    bdry_setSpreadRate             = IFI_fn(BDRY_SETSPREADRATE)
    bdry_temperature               = IF_fn(BDRY_TEMPERATURE)
    bdry_spreadRate                = IF_fn(BDRY_SPREADRATE)
    bdry_massFraction              = IIF_fn(BDRY_MASSFRACTION)
    bdry_mdot                      = IF_fn(BDRY_MDOT)
    reactingsurf_setkineticsmgr    = III_fn(REACTINGSURF_SETKINETICSMGR)
    reactingsurf_enableCoverageEqs = III_fn(REACTINGSURF_ENABLECOVERAGEEQS)
    inlet_new                      = VI_fn(INLET_NEW)
    outlet_new                     = VI_fn(OUTLET_NEW)
    outletres_new                  = VI_fn(OUTLETRES_NEW)
    symm_new                       = VI_fn(SYMM_NEW)
    surf_new                       = VI_fn(SURF_NEW)
    reactingsurf_new               = VI_fn(REACTINGSURF_NEW)
    inlet_setSpreadRate            = IFI_fn(INLET_SETSPREADRATE)
    stflow_setTransport            = III_fn(STFLOW_SETTRANSPORT)
    stflow_enableSoret             = III_fn(STFLOW_ENABLESORET)
    stflow_setPressure             = IFI_fn(STFLOW_SETPRESSURE)
    stflow_pressure                = IF_fn(STFLOW_PRESSURE)
    stflow_solveEnergyEqn          = III_fn(STFLOW_SOLVEENERGYEQN)
    sim1D_del                      = II_fn(SIM1D_DEL)
    sim1D_getInitialSoln           = II_fn(SIM1D_GETINITIALSOLN)
    sim1D_refine                   = III_fn(SIM1D_REFINE)
    sim1D_writeStats               = III_fn(SIM1D_WRITESTATS)
    sim1D_eval                     = IFII_fn(SIM1D_EVAL)
    sim1D_setMaxJacAge             = IIII_fn(SIM1D_SETMAXJACAGE)
    sim1D_setFixedTemperature      = IFI_fn(SIM1D_SETFIXEDTEMPERATURE)
end

begin # ctreactor.h
    reactor_del                           = II_fn(REACTOR_DEL)
    reactor_setInitialVolume              = IFI_fn(REACTOR_SETINITIALVOLUME)
    reactor_setChemistry                  = III_fn(REACTOR_SETCHEMISTRY)
    reactor_setEnergy                     = III_fn(REACTOR_SETENERGY)
    reactor_setThermoMgr                  = III_fn(REACTOR_SETTHERMOMGR)
    reactor_setKineticsMgr                = III_fn(REACTOR_SETKINETICSMGR)
    reactor_insert                        = III_fn(REACTOR_INSERT)
    reactor_mass                          = IF_fn(REACTOR_MASS)
    reactor_volume                        = IF_fn(REACTOR_VOLUME)
    reactor_density                       = IF_fn(REACTOR_DENSITY)
    reactor_temperature                   = IF_fn(REACTOR_TEMPERATURE)
    reactor_enthalpy_mass                 = IF_fn(REACTOR_ENTHALPY_MASS)
    reactor_intEnergy_mass                = IF_fn(REACTOR_INTENERGY_MASS)
    reactor_pressure                      = IF_fn(REACTOR_PRESSURE)
    reactor_massFraction                  = IIF_fn(REACTOR_MASSFRACTION)
    reactor_nSensParams                   = IS_fn(REACTOR_NSENSPARAMS)
    reactor_addSensitivityReaction        = III_fn(REACTOR_ADDSENSITIVITYREACTION)
    flowReactor_setMassFlowRate           = IFI_fn(FLOWREACTOR_SETMASSFLOWRATE)
    reactornet_new                        = VI_fn(REACTORNET_NEW)
    reactornet_del                        = II_fn(REACTORNET_DEL)
    reactornet_setInitialTime             = IFI_fn(REACTORNET_SETINITIALTIME)
    reactornet_setMaxTimeStep             = IFI_fn(REACTORNET_SETMAXTIMESTEP)
    reactornet_setTolerances              = IFFI_fn(REACTORNET_SETTOLERANCES)
    reactornet_setSensitivityTolerances   = IFFI_fn(REACTORNET_SETSENSITIVITYTOLERANCES)
    reactornet_addreactor                 = III_fn(REACTORNET_ADDREACTOR)
    reactornet_advance                    = IFI_fn(REACTORNET_ADVANCE)
    reactornet_step                       = IF_fn(REACTORNET_STEP)
    reactornet_time                       = IF_fn(REACTORNET_TIME)
    reactornet_rtol                       = IF_fn(REACTORNET_RTOL)
    reactornet_atol                       = IF_fn(REACTORNET_ATOL)
    flowdev_del                           = II_fn(FLOWDEV_DEL)
    flowdev_install                       = IIII_fn(FLOWDEV_INSTALL)
    flowdev_setMaster                     = III_fn(FLOWDEV_SETMASTER)
    flowdev_setPrimary                    = III_fn(FLOWDEV_SETPRIMARY)
    flowdev_massFlowRate                  = IF_fn(FLOWDEV_MASSFLOWRATE)
    flowdev_setMassFlowCoeff              = IFI_fn(FLOWDEV_SETMASSFLOWCOEFF)
    flowdev_setValveCoeff                 = IFI_fn(FLOWDEV_SETVALVECOEFF)
    flowdev_setPressureCoeff              = IFI_fn(FLOWDEV_SETPRESSURECOEFF)
    flowdev_setPressureFunction           = III_fn(FLOWDEV_SETPRESSUREFUNCTION)
    flowdev_setTimeFunction               = III_fn(FLOWDEV_SETTIMEFUNCTION)
    wall_del                              = II_fn(WALL_DEL)
    wall_install                          = IIII_fn(WALL_INSTALL)
    wall_vdot                             = IFF_fn(WALL_VDOT)
    wall_expansionRate                    = IF_fn(WALL_EXPANSIONRATE)
    wall_Q                                = IFF_fn(WALL_Q)
    wall_heatRate                         = IF_fn(WALL_HEATRATE)
    wall_area                             = IF_fn(WALL_AREA)
    wall_setArea                          = IFI_fn(WALL_SETAREA)
    wall_setThermalResistance             = IFI_fn(WALL_SETTHERMALRESISTANCE)
    wall_setHeatTransferCoeff             = IFI_fn(WALL_SETHEATTRANSFERCOEFF)
    wall_setHeatFlux                      = III_fn(WALL_SETHEATFLUX)
    wall_setExpansionRateCoeff            = IFI_fn(WALL_SETEXPANSIONRATECOEFF)
    wall_setVelocity                      = III_fn(WALL_SETVELOCITY)
    wall_setEmissivity                    = IFI_fn(WALL_SETEMISSIVITY)
    wall_ready                            = II_fn(WALL_READY)
    reactorsurface_new                    = II_fn(REACTORSURFACE_NEW)
    reactorsurface_del                    = II_fn(REACTORSURFACE_DEL)
    reactorsurface_install                = III_fn(REACTORSURFACE_INSTALL)
    reactorsurface_setkinetics            = III_fn(REACTORSURFACE_SETKINETICS)
    reactorsurface_area                   = IF_fn(REACTORSURFACE_AREA)
    reactorsurface_setArea                = IFI_fn(REACTORSURFACE_SETAREA)
    reactorsurface_addSensitivityReaction = III_fn(REACTORSURFACE_ADDSENSITIVITYREACTION)
    ct_clearReactors                      = VI_fn(CT_CLEARREACTORS)
end

begin # ctrpath.h
    rdiag_new                = VI_fn(RDIAG_NEW)
    rdiag_del                = II_fn(RDIAG_DEL)
    rdiag_detailed           = II_fn(RDIAG_DETAILED)
    rdiag_brief              = II_fn(RDIAG_BRIEF)
    rdiag_setThreshold       = IFI_fn(RDIAG_SETTHRESHOLD)
    rdiag_setBoldThreshold   = IFI_fn(RDIAG_SETBOLDTHRESHOLD)
    rdiag_setNormalThreshold = IFI_fn(RDIAG_SETNORMALTHRESHOLD)
    rdiag_setLabelThreshold  = IFI_fn(RDIAG_SETLABELTHRESHOLD)
    rdiag_setScale           = IFI_fn(RDIAG_SETSCALE)
    rdiag_setFlowType        = III_fn(RDIAG_SETFLOWTYPE)
    rdiag_setArrowWidth      = IFI_fn(RDIAG_SETARROWWIDTH)
    rdiag_add                = III_fn(RDIAG_ADD)
    rdiag_displayOnly        = III_fn(RDIAG_DISPLAYONLY)
    rbuild_new               = VI_fn(RBUILD_NEW)
    rbuild_del               = II_fn(RBUILD_DEL)
    ct_clearReactionPath     = VI_fn(CT_CLEARREACTIONPATH)
end

begin # ctsurf.h
    surf_setSiteDensity = IFI_fn(SURF_SETSITEDENSITY)
    surf_siteDensity    = IF_fn(SURF_SITEDENSITY)
end

#############################################################################
# ERRORS
#############################################################################

mutable struct CanteraError <: Exception
    name::String
end

showerror(io::IO, e::CanteraError) = print(io, "CanteraError: $(e)")

#############################################################################
# General utilities (public)
#############################################################################

function appdelete()::Bool
    return ct_appdelete() == 0 || throw(CanteraError("appdelete"))
end

function resetstorage()::Bool
    return ct_resetStorage() == 0 || throw(CanteraError("resetstorage"))

end
function clearstorage()::Bool
    return ct_clearStorage() == 0 || throw(CanteraError("clearstorage"))
end

function suppress_thermo_warnings(flag::Bool)::Bool
    return (ct_suppress_thermo_warnings(Int32(flag)) == 0||
            throw(CanteraError("suppress_thermo_warnings")))
end

function use_legacy_rate_constants(flag::Bool)::Bool
    return (ct_use_legacy_rate_constants(Int32(flag)) == 0 ||
            throw(CanteraError("use_legacy_rate_constants")))
end

#############################################################################
# SolutionIndex (private)
#############################################################################

mutable struct SolutionIndex
    solution::Int32
    thermo::Int32
    kinetics::Int32
    transport::Int32

    function SolutionIndex(
            infile::String,
            name::String,
            transport::String
        )
        obj = new()
        obj.solution = soln_newSolution(infile, name, transport)
        if obj.solution < 0
            throw(CanteraError("SolutionIndex cannot create new solution"))
        end

        obj.thermo    = soln_thermo(obj.solution)
        obj.kinetics  = soln_kinetics(obj.solution)
        obj.transport = soln_transport(obj.solution)
        return obj
    end
end

function nelements(obj::SolutionIndex)::UInt32
    value = thermo_nElements(obj.thermo)
    if value == 0
        throw(CanteraError("nelements : no elements in thermo object"))
    end
    return convert(UInt32, value)
end

function nspecies(obj::SolutionIndex)::UInt32
    value = thermo_nSpecies(obj.thermo)
    if value == 0
        throw(CanteraError("nspecies : no species in thermo object"))
    end
    return convert(UInt32, value)
end

#############################################################################
# Solution (public)
#############################################################################

mutable struct Solution
    nelements::UInt32
    nspecies::UInt32

    _index::SolutionIndex
    _X::Vector{Float64}
    _Y::Vector{Float64}

    function Solution()
        return nothing
    end

    function Solution(
            infile::String,
            name::String,
            transport::String
        )
        obj = new()

        # Create index of internals.
        obj._index = SolutionIndex(infile, name, transport)

        # Get counters of elements/species.
        obj.nelements = nelements(obj._index)
        obj.nspecies  = nspecies(obj._index)

        # Initialize memory for mass/mole fractions.
        obj._X = zeros(obj.nspecies)
        obj._Y = zeros(obj.nspecies)

        return obj
    end
end

#############################################################################
# Solution (public - main)
#############################################################################

function set_TPX!(
        obj::Solution,
        T::Float64,
        P::Float64,
        X::Vector{Float64};
        norm::Bool = true
    )::Nothing
    settemperature(obj, T)
    setpressure(obj, P)
    setmolefractions(obj, X, norm=norm)
end

function equilibrate!(
        obj::Solution,
        XY::String;
        solver::String      = "auto",
        rtol::Float64       = 1.0e-09,
        maxsteps::Int32     = Int32(1000),
        maxiter::Int32      = Int32(100),
        loglevel::Int32     = Int32(0),
        print_results::Bool = false,
        show_thermo::Bool   = true,
        threshold::Float64  = 1.0e-14
    )::Nothing

    solver_code = Dict(
        "auto"              => -1,
        "element_potential" => 0,
        "gibbs"             => 1,
        "vcs"               => 2,
    )[solver]

    status = thermo_equilibrate(obj._index.thermo, XY, solver_code,
                                rtol, maxsteps, maxiter, loglevel)

    if status < 0
        throw(CanteraError("equilibrate! : failed ($(status))"))
    end

    if print_results
        status = thermo_print(obj._index.thermo, Int32(show_thermo), threshold)
        if status < 0
            throw(CanteraError("equilibrate! thermo_print : ($(status))"))
        end
    end
end

function delete!(obj::Solution)::Nothing
    # TODO: this is doing nothing!
    if soln_del(obj._index.solution) != 0
        throw(CanteraError("delete(obj::Solution)"))
    end
    obj = nothing
end

#############################################################################
# Solution (public - setters)
#############################################################################

function settemperature(obj::Solution, T::Float64)::Nothing
    if thermo_setTemperature(obj._index.thermo, T) < 0
        throw(CanteraError("settemperature"))
    end
end

function setpressure(obj::Solution, P::Float64)::Nothing
    if thermo_setPressure(obj._index.thermo, P) < 0
        throw(CanteraError("setpressure"))
    end
end

function setmolefractions(obj::Solution, X::Vector{Float64};
                          norm::Bool)::Nothing
    n = obj._index.thermo
    if thermo_setMoleFractions(n, obj.nspecies, X, Int(norm)) < 0
        throw(CanteraError("setmolefractions"))
    end
end

#############################################################################
# Solution (public - getters)
#############################################################################

function gettemperature(obj::Solution)::Float64
    T = thermo_temperature(obj._index.thermo)
    if T < 0.0
        throw(CanteraError("""
        gettemperature : get a negative temperature
        The parent solution object has been freed elsewhere!
        """))
    end
    return T
end

function getpressure(obj::Solution)::Float64
    P = thermo_pressure(obj._index.thermo)
    if P < 0.0
        throw(CanteraError("""
        getpressure : get a negative pressure
        The parent solution object has been freed elsewhere!
        """))
    end
    return P
end

function getmolefractions(obj::Solution)::Vector{Float64}
    status = thermo_getMoleFractions(
        obj._index.thermo, obj.nspecies, obj._X)
    if status < 0
        throw(CanteraError("""
        getmolefractions : get a negative status
        The parent solution object has been freed elsewhere!
        """))
    end
    return obj._X
end

end # module Cantera