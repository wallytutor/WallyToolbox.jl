# -*- coding: utf-8 -*-
using WallyToolbox
using DryUtilities: redirect_to_files

NP = 4
MPI = "mpiexec"

@info "Generating mesh..."
redirect_to_files("log.gmsh") do
    run(`gmsh -2 sample.geo -order 2 -format msh2`)
end

@info "Converting mesh to Elmer grid format..."
redirect_to_files("log.grid") do
    run(`ElmerGrid 14 2 sample.msh -autoclean -merge 1.0e-05`)
    rm("sample.msh"; force = true)
end

@info "Solving/integrating problem (may take a while)..."
redirect_to_files("log.solver") do
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

@info "Cleaning up logs..."
!isdir("logs") && mkdir("logs")
moov(f) = mv(f, "logs/$(f)"; force = true)
map(moov, filter(startswith("log."), readdir()))

@info "DONE!"
