module DualSPHysics

using WallyToolbox: defaultvalue
using WallyToolbox: redirect_to_files

export DualSPHysicsCase

##############################################################################
# STRUCTURES
##############################################################################

struct DualSPHysicsPath
    "Path to DualSPHysics directory containing binaries."
    dirbin::String

    "Path to `GenCase` executable for case generation."
    gencase::String

    "Path to `DualSPHysics` CPU executable."
    dualsphysicscpu::String
    
    "Path to `DualSPHysics` GPU executable."
    dualsphysicsgpu::String

    "Path to ."
    boundaryvtk::String

    "Path to `PartVTK` to extract particles from data."
    partvtk::String

    "Path to ."
    partvtkout::String

    "Path to ."
    measuretool::String

    "Path to ."
    computeforces::String

    "Path to ."
    isosurface::String

    "Path to ."
    flowtool::String

    "Path to ."
    floatinginfo::String

    "Path to ."
    tracerparts::String

    function DualSPHysicsPath(dirbin; 
            sph = "DualSPHysics5.2", 
            mod = "_win64"
        )
        dirbin = abspath(dirbin)

        gencase         = joinpath(dirbin, "GenCase$(mod)")
        dualsphysicscpu = joinpath(dirbin, "$(sph)CPU$(mod)")
        dualsphysicsgpu = joinpath(dirbin, "$(sph)$(mod)")
        boundaryvtk     = joinpath(dirbin, "BoundaryVTK$(mod)")
        partvtk         = joinpath(dirbin, "PartVTK$(mod)")
        partvtkout      = joinpath(dirbin, "PartVTKOut$(mod)")
        measuretool     = joinpath(dirbin, "MeasureTool$(mod)")
        computeforces   = joinpath(dirbin, "ComputeForces$(mod)")
        isosurface      = joinpath(dirbin, "IsoSurface$(mod)")
        flowtool        = joinpath(dirbin, "FlowTool$(mod)")
        floatinginfo    = joinpath(dirbin, "FloatingInfo$(mod)")
        tracerparts     = joinpath(dirbin, "TracerParts$(mod)")

        return new(dirbin, gencase, dualsphysicscpu, dualsphysicsgpu,
                   boundaryvtk, partvtk, partvtkout, measuretool,
                   computeforces, isosurface, flowtool, floatinginfo,
                   tracerparts)
    end
end

struct DualSPHysicsCase
    path::DualSPHysicsPath
    name::String
    dump::String
    data::String
    part::String

    function DualSPHysicsCase(path; name = "case")
        dump = "$(name)_out"
        data = joinpath(dump, "data")
        part = joinpath(dump, "part")

        if !isfile("$(name).xml")
            @warn("Case configuration `$(name)` not found!")
        end

        return new(DualSPHysicsPath(path), name, dump, data, part)
    end
end

##############################################################################
# INTERNALS
##############################################################################

function checkstatus(app::String, retcode::Base.Process)::Nothing
    if retcode.exitcode != 0
        throw("$(basename(app)) failed with code ($(retcode.exitcode)).")
    end
    return nothing
end

function sanitizename(path::String)::String
    return replace(path |> basename |> lowercase, "." => "_")
end

function runexe(app::String, cmd::Cmd; name = nothing)::Nothing
    name = defaultvalue(name, sanitizename(app))

    redirect_to_files("log.$(name)") do
        checkstatus(app, run(cmd))
    end

    return nothing
end

##############################################################################
# RUNNERS
##############################################################################

"Executes `GenCase`` to create initial files for simulation."
function gencase(case::DualSPHysicsCase)
    # XXX: also logged to case_out/case.out
    app = case.path.gencase
    outputs = joinpath(case.dump, case.name)
    cmd = `$(app) $(case.name) $(outputs) -save:all`
    runexe(app, cmd; name = nothing)
end

"Executes DualSPHysics to simulate SPH method.."
function dualsphysics(case::DualSPHysicsCase; 
        mode = :gpu,
        opts = "-svres"
    )
    # XXX: also logged to case_out/Run.out
    app = getfield(case.path, Symbol("dualsphysics$(mode)"))
    outputs = joinpath(case.dump, case.name)
    gpu = (mode == :gpu) ? "-gpu" : ""
    cmd = `$(app) $(gpu) $(outputs) $(case.dump) -dirdataout data $(opts)`
    runexe(app, cmd; name = nothing)
end

"Executes PartVTK to create VTK files with particles."
function partvtk(case::DualSPHysicsCase; part, opts)
    app = case.path.partvtk
    part = joinpath(case.part, part)
    cmd = `$(app) -dirin $(case.data) -savevtk $(part) $(opts)`
    runexe(app, cmd; name = nothing)
end

function partvtkfluid(case)
    partvtk(case; part="fluid", opts="-onlytype:-all,+fluid")
end

end # (DualSPHysics)