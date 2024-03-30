# -*- coding: utf-8 -*-
using DryTooling
using Test

@testset "DryTooling.jl" begin
    for (root, dirs, files) in walkdir("../src/")
        for file in files
            if endswith(lowercase(file), "test.jl")
                include(joinpath(root, file));
            end
        end
    end
end
