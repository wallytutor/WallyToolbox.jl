# -*- coding: utf-8 -*-
using WallyToolbox

function cleanup()
    opts = (force = true, recursive = true)

    isfile("ELMERSOLVER_STARTINFO") && rm("ELMERSOLVER_STARTINFO")

    rm("partitioning.$(NP)/"; opts...)
    rm("sample/"; opts...)
    rm("logs/"; opts...)
    rm("results/"; opts...)
    
    return nothing
end

cleanup()

NP = 4
MPI = "mpiexec"

@info "Enforcing logging directory..."
!isdir("logs") && mkdir("logs")

@info "Generating mesh..."
redirect_to_files("logs/log.gmsh") do
    run(`gmsh -2 sample.geo -order 2 -format msh2`)
end

@info "Converting mesh to Elmer grid format..."
redirect_to_files("logs/log.grid") do
    run(`ElmerGrid 14 2 sample.msh -autoclean -merge 1.0e-05`)
    rm("sample.msh"; force = true)
end

@info "Solving/integrating problem (may take a while)..."
redirect_to_files("logs/log.solver") do
    open("ELMERSOLVER_STARTINFO", "w") do fp
        write(fp, "case.sif\n1\n")
    end
    
    if (NP > 0)
        run(`ElmerGrid 2 2 sample -partdual -metiskway $(NP)`)
        run(`$(MPI) -n $(NP) ElmerSolver_mpi`)
    else
        run(`ElmerSolver`)
    end

    rm("ELMERSOLVER_STARTINFO"; force = true)
end

@info "DONE!"
