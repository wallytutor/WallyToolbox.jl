# -*- coding: utf-8 -*-
using GLMakie 

ljpotential(R, ϵ)    = 4ϵ * R * (R - 1)
ljpotential(r, ϵ, σ) = ljpotential((σ / r)^6, ϵ)

arithmetic_average(a, b) = (a + b) / 2
geometric_average(a, b) = sqrt(a * b)

function potential_lorentz_berthelot(pa, pb)
    return (geometric_average(pa[1], pb[1]),
            arithmetic_average(pa[2], pb[2]))
end

function potential_geometric(pa, pb)
    return Tuple(geometric_average(va, vb) for (va, vb) in zip(pa, pb))
end

function plot_potential()
    pair11 = (1.0, 1.0)
    pair22 = (0.5, 3.0)
    pair12_a = potential_geometric(pair11, pair22)
    pair12_b = potential_lorentz_berthelot(pair11, pair22)

    r = LinRange(0, 10, 1000)
    E11 = ljpotential.(r, pair11...)
    E22 = ljpotential.(r, pair22...)
    E12_a = ljpotential.(r, pair12_a...)
    E12_b = ljpotential.(r, pair12_b...)

    fig = with_theme() do
        f = Figure()
        ax = Axis(f[1, 1]; xlabel = L"r", ylabel = L"E(r)")
        lines!(ax, r, E11; label = L"E_{11}", color = :red)
        lines!(ax, r, E22; label = L"E_{22}", color = :blue)
        lines!(ax, r, E12_a; label = L"E_{12,a}", color = :black)
        lines!(ax, r, E12_b; label = L"E_{12,b}", color = :green)
        xlims!(ax, 0.0, 10.0)
        ylims!(ax, -1.2, 1.2)
        axislegend(ax; position = :rt)
        f
    end

    return fig
end

run(`lmp -in inputs.lammps`)
