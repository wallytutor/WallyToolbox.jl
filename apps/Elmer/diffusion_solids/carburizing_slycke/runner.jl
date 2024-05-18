# -*- coding: utf-8 -*-
using WallyToolbox
using DryUtilities: redirect_to_files

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

redirect_to_files("log.gmsh") do
    run(`gmsh -2 sample.geo -order 2 -format msh2`)
end
