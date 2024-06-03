# -*- coding: utf-8 -*-
using WallyToolbox
using DryUtilities: redirect_to_files

function run_tutorial(; script, wd, force = false)
    !isfile(joinpath(wd, script)) && throw("No $(script) in $(wd)!")

    logname = joinpath(wd, "log.$(basename(script))")

    if isfile(logname) && !force
        @warn("Already run $(script) (see $(logname))")
        return 99
    end

    @info("Running $(script) at $(wd) (see $(logname))")

    return redirect_to_files(logname) do
        run(Cmd(`lmp -in $(script)`, dir=wd))
    end
end

force = true

project = [
    (script = "inputs-1.lammps",  wd = "tutorial-1"),
    (script = "inputs-1.lammps",  wd = "tutorial-2"),
    (script = "inputs-2.lammps",  wd = "tutorial-2"),
    (script = "inputs-1.lammps",  wd = "exercise-1"),
    (script = "reference.lammps", wd = "exercise-1"),
    (script = "inputs-1.lammps",  wd = "exercise-2"),
    (script = "inputs-2.lammps",  wd = "exercise-2"),
    (script = "inputs-3.lammps",  wd = "exercise-2"),
    (script = "reference.lammps", wd = "exercise-2"),
    # (script = "inputs-1.lammps",  wd = "exercise-3"),
    # (script = "reference.lammps", wd = "exercise-3"),
]

for simulation in project
    run_tutorial(; simulation...)
end
