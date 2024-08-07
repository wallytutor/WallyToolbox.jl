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

function mesh_rectangle(; Lx, Ly, nx, ny)
    return triangulate_rectangle(0, Lx, 0, Ly, nx, ny;
                                 single_boundary = false)
end

function get_rectangle_bcs(bcd)
    bc_order = [:bottom, :right, :top, :left]
    bc_fncs = Tuple(map(b->bcd[b][1], bc_order))
    bc_type = Tuple(map(b->bcd[b][2], bc_order))
    return bc_fncs, bc_type
end

struct DiffusionProblem
    mesh::FVMGeometry
    prob::FVMProblem
    bcns::BoundaryConditions

    function DiffusionProblem(
            tri,
            bcd,
            diffusion_function, 
            diffusion_parameters,
            final_time,
            init
        )
        initial_condition = map(p->init(p...), each_point(tri))
        
        mesh = FVMGeometry(tri)
    
        bc_fncs, bc_type = get_rectangle_bcs(bcd)
        bcns  = BoundaryConditions(mesh, bc_fncs, bc_type)
        
        prob = FVMProblem(mesh, bcns;
            diffusion_function,
            diffusion_parameters,
            initial_condition,
            final_time,
        )

        return new(mesh, prob, bcns)
    end
end

function solve(model::DiffusionProblem, saveat; kw...)
    autodiff = get(kw, :autodiff, false)
    alg = FBDF(; linsolve = UMFPACKFactorization(), autodiff)
    # alg = TRBDF2(linsolve=KLUFactorization())
    sol = solve(model.prob, alg; saveat)
    return sol
end
```

```julia
function diffusion_coefficient(xc, T)
    A = 4.84e-05exp(-38.0xc) / (1.0 - 5.0xc)
    E = 155_000.0 - 570_000.0xc
    D = A * exp(-E / (GAS_CONSTANT * T))
    return D
end

function masstomolefraction(w)
    return w * (w / 0.012 + (1 - w) / 0.055)^(-1) / 0.012
end

function moletomassfraction(x)
    return 0.012 * x / (0.012*x + (1 - x) * 0.055)
end

function bcs_debug(hm, um)
    bc_cons = (x, y, t, u, p) -> hm(t) * um
    bc_symm = (x, y, t, u, p) -> 0.0
    return Dict(:right  => (bc_cons, Dirichlet),
                :bottom => (bc_cons, Dirichlet),
                :top    => (bc_symm, Neumann),
                :left   => (bc_symm, Neumann))
end

function bcs_treatment(hm, um)
    conc_bc = (x, y, t, u, p) -> hm(t) * (u - um)
    symm_bc = (x, y, t, u, p) -> 0.00
    return Dict(:right  => (conc_bc, Neumann),
                :bottom => (conc_bc, Neumann),
                :top    => (symm_bc, Neumann),
                :left   => (symm_bc, Neumann))
end

function select_alloy(alloy)
    if alloy == :aero
        y0 = 0.0016
        ys = 0.0100
        
        enrich  = 2hour
        diffuse = 3hour
        
        hf = 1.0e-04
    else
        y0 = 0.0023
        ys = 0.0095
        
        enrich  = 2hour
        diffuse = 4hour
        
        hf = 6.0e-05
    end

    return y0, ys, enrich, diffuse, hf
end
```

```julia
Lx = 7
Ly = 2
Lz = 20

nx = 400
ny = convert(Int64, round(nx * Ly / Lx))

hour = 3600.0
saveat = 180.0
T = 1173.15

alloy = :aero
alloy = :auto

y0, ys, enrich, diffuse, hf = select_alloy(alloy)

tri = mesh_rectangle(; Lx, Ly, nx, ny);


model = let
    tend = enrich + diffuse
    u0 = masstomolefraction(y0)
    um = masstomolefraction(ys)
    
    D = (x, y, t, u, p) -> p[2] * diffusion_coefficient(u, p[1])
    p = (T, 1.0e+06)
    
    f = (x, y) -> u0
    h = (t) -> (t < enrich) ? hf : 0.0
    b = bcs_treatment(h, um)

    # XXX: keep this for debug
    # b = debug_dirichlet(hm, um)

    DiffusionProblem(tri, b, D, p, tend, f)
end

sol = solve(model, saveat)

# 8 blocks, mm3->m3, kg->g
fact3d = 8 * 1e-09 * 1000
fact2d = 4 * 1e-06

ρ = 7890.0
yf = moletomassfraction.(sol.u[end])

m0 = sum(model.mesh.cv_volumes .* y0)
mf = sum(model.mesh.cv_volumes .* yf)
dm = ρ * Lz * (mf - m0)

M = fact3d * dm
A = fact2d * (Lx*Ly + Lx*Lz + Ly*Lz)

M / A, M
```

```julia
# plot_trimesh(tri; Lx, Ly)
```

```julia

```

```julia
f1, f2 = if (sol.retcode == ReturnCode.Success)
    levels = 0.0:0.05:1.0
    aspect = Lx/Ly
    
    idx = findfirst(t->t>=enrich, sol.t)
    
    t = sol.t[idx]
    u = 100moletomassfraction.(sol.u[idx])
    f1 = plot_state(tri, t, u; aspect, levels)

    t = sol.t[end]
    u = 100moletomassfraction.(sol.u[end])
    f2 = plot_state(tri, t, u; aspect, levels)

    f1, f2
end;
```

```julia
f1
```

```julia
f2
```

```julia

```
