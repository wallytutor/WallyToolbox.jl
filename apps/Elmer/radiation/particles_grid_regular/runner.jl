# -*- coding: utf-8 -*-
using WallyToolbox
using DryUtilities: redirect_to_files

function cleanup(np, geom)
    opts = (force = true, recursive = true)

    isfile("ELMERSOLVER_STARTINFO") && rm("ELMERSOLVER_STARTINFO")

    rm("logs/"; opts...)
    rm("results/"; opts...)
    rm("$(geom)/"; opts...)
    # rm("partitioning.$(np)/"; opts...)
    
    return nothing
end

function workflow(;
        geom       = "packing",
        np         = -1, 
        mpi        = "mpiexec", 
        cleanstart = true
    )
    cleanstart && cleanup(np, geom)

    @info "Enforcing logging directory..."
    !isdir("logs") && mkdir("logs")
    
    @info "Generating mesh..."
    redirect_to_files("logs/log.gmsh") do
        run(`gmsh -2 $(geom).geo -order 2 -format msh2`)
    end

    @info "Converting mesh to Elmer grid format..."
    redirect_to_files("logs/log.grid") do
        run(`ElmerGrid 14 2 $(geom).msh -autoclean -merge 1.0e-05`)
        rm("sample.msh"; force = true)
    end

    @info "Solving/integrating problem (may take a while)..."
    redirect_to_files("logs/log.solver") do
        open("ELMERSOLVER_STARTINFO", "w") do fp
            write(fp, "case.sif\n1\n")
        end
        
        if (np > 0)
            run(`ElmerGrid 2 2 sample -partdual -metiskway $(np)`)
            run(`$(mpi) -n $(np) ElmerSolver_mpi`)
        else
            run(`ElmerSolver`)
        end

        rm("ELMERSOLVER_STARTINFO"; force = true)
    end

    @info "DONE!"
end

workflow()
