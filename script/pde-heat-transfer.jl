# -*- coding: utf-8 -*-
using CairoMakie
using DelaunayTriangulation
using DifferentialEquations
using FiniteVolumeMethod

# Values at boundaries:
Txl = 813.15
Txr = 298.15

# Domain physical dimensions:
Lx = (0.0, 0.15)
Ly = (0.0, 0.05)

# Number of cells over each direction:
nx = 150
ny = 10

# Position dependent initial condition:
f_ic = (x, y) -> 298.15

# Diffusion coefficient:
diffusion_function = (x, y, t, u, p) -> begin
    (x < 0.05) ? 1.0 : 10.0
end

# Integration time:
final_time = 20.0

# XXX: documentation of single_boundary is wrong!
tri = triangulate_rectangle(Lx..., Ly..., nx, ny, single_boundary = false)

# Create finite volume mesh:
mesh = FVMGeometry(tri)

# Display grid
let
    fig, ax, sc = triplot(tri)
    fig
end

# Set boundary conditions: bottom, right, top, left
BCs = let
    functions = (
        (x, y, t, u, p) -> zero(u),
        (x, y, t, u, p) -> Txr * one(u),
        (x, y, t, u, p) -> zero(u),
        (x, y, t, u, p) -> Txl * one(u),
    )

    conditions = (
        Neumann,
        Dirichlet,
        Neumann,
        Dirichlet,
    )

    BoundaryConditions(mesh, functions, conditions)
end

initial_condition = [f_ic(x, y) for (x, y) in each_point(tri)]

prob = FVMProblem(mesh, BCs;
                  diffusion_function,
                  initial_condition,
                  final_time)


sol = solve(prob, saveat=1.0)

let
    levels = 250:50.0:850
    limits = extrema(levels)
    colormap = :turbo
    flipaxis = true

    width = 450
    height = 150
    xlabel = "x [m]"
    ylabel = "y [m]"

    n_sol = size(sol.u)[1]
    m_sol = div(n_sol, 2)

    fig = Figure(fontsize = 24, figure_padding = 35)

    for (i, j) in zip(1:3, (1, m_sol, n_sol))
        ax = Axis(fig[i, 1]; width, height, xlabel, ylabel,
                  title = "t = $(sol.t[j])", titlealign = :left)

        tricontourf!(ax, tri, sol.u[j]; levels, colormap,)
        tightlimits!(ax)

        hideydecorations!(ax)
    end
    
    Colorbar(fig[:, end+3]; limits, colormap, flipaxis,
             ticks=(300:100:900, string.(300:100:900)))

    resize_to_layout!(fig)
    fig
end