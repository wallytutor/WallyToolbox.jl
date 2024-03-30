# -*- coding: utf-8 -*-
export Solution

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
