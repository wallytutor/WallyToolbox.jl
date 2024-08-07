---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.16.2
  kernelspec:
    display_name: WallyTutor Julia 1.10.4
    language: julia
    name: wnote
---

# Modeling of diffusion in solids

This note presents a finite volume method implementation of mass transfer in solids; it is developped under the framework of [FiniteVolumeMethod.jl](https://sciml.github.io/FiniteVolumeMethod.jl/stable/). In order to establish the workflow presented below, the reader is invited to check the tutorials regarding [Diffusion Equation on a Square Plate](https://sciml.github.io/FiniteVolumeMethod.jl/stable/tutorials/diffusion_equation_on_a_square_plate/) and [Porous-Fisher Equation and Travelling Waves](https://sciml.github.io/FiniteVolumeMethod.jl/stable/tutorials/porous_fisher_equation_and_travelling_waves/). These introduce how to implement a diffusion equation under the referred framework, also accounting for nonlinear effects. The way of providing parameters to the model is illustrated in [Porous-Medium Equation](https://sciml.github.io/FiniteVolumeMethod.jl/stable/tutorials/porous_medium_equation/) tutorial.

```julia
using WallyToolbox

import Printf: @sprintf

import DelaunayTriangulation: Triangulation
import DelaunayTriangulation: triangulate_rectangle
import DelaunayTriangulation: each_point

import FiniteVolumeMethod as FVM
import FiniteVolumeMethod: FVMGeometry
import FiniteVolumeMethod: BoundaryConditions, Neumann, Dirichlet
import FiniteVolumeMethod: FVMProblem

import OrdinaryDiffEq: solve, FBDF, ReturnCode
import LinearSolve: UMFPACKFactorization

import CairoMakie: Colorbar
import CairoMakie: with_theme
import CairoMakie: triplot, tricontourf
import CairoMakie: xlims!, ylims!, tightlimits!
```

## Visualization utilities

```julia
function plot_trimesh(tri; kw...)
    Lx = get(kw, :Lx, nothing)
    Ly = get(kw, :Ly, nothing)

    with_theme() do
        f, ax, tr = triplot(tri)
        !isnothing(Lx) && xlims!(ax, 0, Lx)
        !isnothing(Ly) && ylims!(ax, 0, Ly)
        f
    end
end

function plot_state(tri, t, u; kw...)
    aspect = get(kw, :aspect, 1.0)
    levels = get(kw, :levels, 0.0:0.1:1.0)
    colormap = get(kw, :colormap, :jet1)
    mode = :relative
    
    with_theme() do
        f, ax, tr = tricontourf(tri, u; colormap, mode, levels)
    
        ax.aspect = aspect
        ax.titlealign = :left
        ax.title  = "t = $(t)"
        ax.xlabel = "x"
        ax.ylabel = "y"
        
        Colorbar(f[2, 1], tr;  vertical = false, flipaxis = false)
        tightlimits!(ax)
        
        f
    end
end
nothing; # hide
```

## Diffusion problem

```julia
struct DiffusionProblem
    grid::Triangulation
    mesh::FVMGeometry
    prob::FVMProblem
    bcns::BoundaryConditions

    function DiffusionProblem(
            Lx, Ly, nx, ny,
            bcd,
            diffusion_function, 
            diffusion_parameters,
            final_time,
            init
        )
        tri = triangulate_rectangle(0, Lx, 0, Ly, nx, ny;
                                    single_boundary = false)
        
        initial_condition = map(p->init(p...), each_point(tri))
        
        mesh = FVMGeometry(tri)
    
        bc_order = [:bottom, :right, :top, :left]
        bc_fncs = Tuple(map(b->bcd[b][1], bc_order))
        bc_type = Tuple(map(b->bcd[b][2], bc_order))
        bcs  = BoundaryConditions(mesh, bc_fncs, bc_type)
        
        prob = FVMProblem(mesh, bcs;
            diffusion_function,
            diffusion_parameters,
            initial_condition,
            final_time,
        )

        return new(tri, mesh, prob, bcs)
    end
end

function solve(model::DiffusionProblem, saveat; kw...)
    autodiff = get(kw, :autodiff, false)
    alg = FBDF(; linsolve = UMFPACKFactorization(), autodiff)
    # alg = TRBDF2(linsolve=KLUFactorization())
    sol = solve(model.prob, alg; saveat)
    return sol
end
nothing; # hide
```

## Steel carburizing

```julia
function masstomolefraction(w)
    return w * (w / 0.012 + (1 - w) / 0.055)^(-1) / 0.012
end

function moletomassfraction(x)
    return 0.012 * x / (0.012*x + (1 - x) * 0.055)
end
nothing; # hide
```

```julia
function diffusion_coefficient(xc, T)
    A = 4.84e-05exp(-38.0xc) / (1.0 - 5.0xc)
    E = 155_000.0 - 570_000.0xc
    D = A * exp(-E / (GAS_CONSTANT * T))
    return D
end

function bcs_treatment(hm, um)
    conc_bc = (x, y, t, u, p) -> hm(t) * (u - um)
    symm_bc = (x, y, t, u, p) -> 0.00
    return Dict(:bottom => (conc_bc, Neumann),
                :right  => (conc_bc, Neumann),
                :top    => (symm_bc, Neumann),
                :left   => (symm_bc, Neumann))
end
nothing; # hide
```

```julia
function select_alloy(alloy)
    hour = 3600.0
    
    if alloy == :aero
        y0 = 0.0016
        ys = 0.0100
        
        enrich  = 2hour
        diffuse = 3hour
        
        hf = 9.0e-05
    else
        y0 = 0.0023
        ys = 0.0095
        
        enrich  = 2hour
        diffuse = 4hour
        
        hf = 6.0e-05
    end

    return y0, ys, enrich, diffuse, hf
end
nothing; # hide
```

## Simulation workflow

```julia
function create_model(alloy, T, Lx, Ly, nx, ny)
    y0, ys, enrich, diffuse, hf = select_alloy(alloy)
    
    tend = enrich + diffuse
    u0 = masstomolefraction(y0)
    um = masstomolefraction(ys)
    
    D = (x, y, t, u, p) -> 1.0e+06diffusion_coefficient(u, p[1])
    p = (T,)
    
    f = (x, y) -> u0
    h = (t) -> (t < enrich) ? hf : 0.0
    b = bcs_treatment(h, um)

    model = DiffusionProblem(Lx, Ly, nx, ny, b, D, p, tend, f)

    return model, (enrich, tend)
end

function solve_model(model, saveat, Lx, Ly, Lz; ρ = 7890.0)
    saveat = min(model.prob.final_time, saveat) 
    sol = solve(model, saveat)
        
    y0 = moletomassfraction.(sol.u[1])
    yf = moletomassfraction.(sol.u[end])
    
    m0 = sum(model.mesh.cv_volumes .* y0)
    mf = sum(model.mesh.cv_volumes .* yf)
    dm = ρ * Lz * (mf - m0)

    # 8 blocks, mm3->m3, kg->g
    fact3d = 8 * 1e-09 * 1000
    fact2d = 4 * 1e-06
    
    M = fact3d * dm
    A = fact2d * (Lx*Ly + Lx*Lz + Ly*Lz)

    σ = M / A
    Δm = M
    
    return sol, σ, Δm
end

function postprocess(model, sol, tk; aspect = 2, levels = 0.0:0.05:1.0)
    idx = findfirst(t->t>=tk, sol.t)
    
    t = sol.t[idx]
    u = 100moletomassfraction.(sol.u[idx])

    return plot_state(model.grid, t, u; aspect, levels)
end

function simulate(alloy, T, Lx, Ly, Lz, nx, saveat; post = false)
    ny = convert(Int64, round(nx * Ly / Lx))
    
    model, tchange = create_model(alloy, T, Lx, Ly, nx, ny)
    sol, σ, Δm = solve_model(model, saveat, Lx, Ly, Lz)

    Nx  = @sprintf("%05d", nx)
    Δmt = @sprintf("%.1f", 1000Δm)
    σt  = @sprintf("%.1f", σ)
    
    @info("$(Nx) : Mass change $(Δmt) mg ⟹ $(σt) g/m²")

    (!post) && return nothing
    
    f1 = postprocess(model, sol, tchange[1]; aspect = 2)
    f2 = postprocess(model, sol, tchange[2]; aspect = 2)
    return sol, f1, f2
end

function grid_convergence(alloy, T, Lx, Ly, Lz,)
    simulate(alloy, T, Lx, Ly, Lz,  20, 9e+99)
    simulate(alloy, T, Lx, Ly, Lz,  50, 9e+99)
    simulate(alloy, T, Lx, Ly, Lz, 100, 9e+99)
    simulate(alloy, T, Lx, Ly, Lz, 200, 9e+99)
    simulate(alloy, T, Lx, Ly, Lz, 300, 9e+99)
    simulate(alloy, T, Lx, Ly, Lz, 400, 9e+99)
    simulate(alloy, T, Lx, Ly, Lz, 500, 9e+99)
    return nothing
end

nothing; # hide
```

## Problem setup

```julia
Lx = 7
Ly = 2
Lz = 20

saveat = 180.0

T = 1173.15

nothing; # hide
```

```julia
# m, _ = create_model(:aero, T, Lx, Ly, 30, 30)
```

### Grid convergence

```julia
grid_convergence(:aero, T, Lx, Ly, Lz)
```

```julia
grid_convergence(:auto, T, Lx, Ly, Lz)
```

### Simulate 16NiCroMo13

```julia
_, f1, f2 = simulate(:aero, T, Lx, Ly, Lz, 300, saveat; post = true)
nothing; # hide
```

```julia
f1
```

```julia
f2
```

### Simulate 23MnCrMo5

```julia
_, f1, f2 = simulate(:auto, T, Lx, Ly, Lz, 500, saveat; post = true)
nothing; # hide
```

```julia
f1
```

```julia
f2
```

## To-do

- [ ] Improve logic of `saveas` to minimize memory footprint in grid convergence (sometimes it overflows).
- [ ] Add a secondary factor for non-*squarish* meshes for other sensitivity studies.
- [ ] Slice midplane (how?) to retrieve data for comparison with PhD thesis.
