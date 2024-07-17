# -*- coding: utf-8 -*-
using WallyToolbox

meanmolecularmass(Y, M) = sum(Y ./ M)^(-1)

mass2molefraction(Y, M) = (Y ./ M) * meanmolecularmass(Y, M)

function setupalloy(; xc₀ = 0.0016)
    M = [0.01201, 0.055845]
    Y = [xc₀, NaN]

    Y[end] = 1.0 - sum(Y[1:end-1])
    X = mass2molefraction(Y, M)
end

X₀ = setupalloy(; xc₀ = 0.0016)
Xs = setupalloy(; xc₀ = 0.0100)

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
    run(`ElmerSolver`)
    rm("ELMERSOLVER_STARTINFO"; force = true)
end

@info "Cleaning up logs..."
!isdir("logs") && mkdir("logs")
moov(f) = mv(f, "logs/$f"; force = true)
map(moov, filter(startswith("log."), readdir()))

@info "DONE!"
