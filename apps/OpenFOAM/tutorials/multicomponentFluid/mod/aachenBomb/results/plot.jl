# -*- coding: utf-8 -*-
using CairoMakie
using DelimitedFiles: readdlm

data = readdlm("efficiency.dat")
proc = data[:, 1]
time = data[:, 2] ./ 3600

fig = let
    f = Figure(size = (600, 400))
    ax = Axis(f[1, 1])
    scatter!(ax, proc, time)
    ax.xlabel = "Number of processors"
    ax.ylabel = "Wall time [h]"
    xlims!(ax, 0, 35)
    ylims!(ax, 0, 6)
    f
end

save("results.png", fig)
