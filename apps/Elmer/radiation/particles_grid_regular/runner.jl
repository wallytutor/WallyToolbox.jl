# -*- coding: utf-8 -*-
using WallyToolbox

function startlog(logs)
    @info "Enforcing logging directory..."
    !isdir(logs) && mkdir(logs)
end

function generatemesh(geom, logs)
    @info "Generating mesh..."
    redirect_to_files("$(logs)/log.gmsh") do
        run(`gmsh -2 $(geom).geo -order 2 -format msh2`)
    end
end

function convertmesh(geom, logs; keepmesh = true, tol = 1.0e-09)
    @info "Converting mesh to Elmer grid format..."
    redirect_to_files("$(logs)/log.grid") do
        run(`ElmerGrid 14 2 $(geom).msh -autoclean -merge $(tol)`)
        (!keepmesh) && rm("$(geom).msh"; force = true)
    end
end

function runsolver(mpi, np, logs)
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
end

function cleanup(geom, logs, results; np = -1)
    opts = (force = true, recursive = true)

    isfile("ELMERSOLVER_STARTINFO") && rm("ELMERSOLVER_STARTINFO")

    rm(logs; opts...)
    rm(results; opts...)
    rm(geom; opts...)

    (np > 0) && rm("partitioning.$(np)/"; opts...)
    
    return nothing
end

function workflow(;
        geom       = "packing",
        np         = -1, 
        mpi        = "mpiexec",
        logs       = "logs",
        results    = "results",
        cleanstart = true
    )
    cleanstart && cleanup(geom, logs, results; np)
    startlog(logs)
    generatemesh(geom, logs)
    convertmesh(geom, logs)
    runsolver(mpi, np, logs)
    @info "DONE!"
end

workflow()
# cleanup("packing", "logs", "results")