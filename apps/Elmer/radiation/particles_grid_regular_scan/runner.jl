# -*- coding: utf-8 -*-
using WallyToolbox
using DryUtilities: redirect_to_files

function startlog(logs)
    @info "Enforcing logging directory..."
    !isdir(logs) && mkdir(logs)
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
    runsolver(mpi, np, logs)
    @info "DONE!"
end

# workflow()
# cleanup("packing", "logs", "results")

# using DelimitedFiles
# using Statistics

# data = readdlm("bflux.dat")

# Th = 1300
# R = 100e-06

# Ly = maximum(data[:, 5])
# Lx = mean(data[:, 4])

# As = 15π*R^2
# At = Lx * Ly

# ϕ = As / At

# qx = mean(data[:, end])
# Tc = mean(data[:, 7])

# k = -1 * qx * Lx / (Th - Tc)