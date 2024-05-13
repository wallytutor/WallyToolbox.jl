### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ f4d77b00-c12c-11ee-150b-cb97fa9d2c03
begin
    @info "Loading required external tools"

    import Pkg
    Pkg.activate("../../../../WallyToolbox.jl")

    using WallyToolbox
    using OpenFOAM

    using CairoMakie
    using DelimitedFiles
    using DifferentialEquations
    using Mustache
    using PlutoUI
end

# ╔═╡ 3befec01-5817-445f-bed5-b47909eaf464
md"""
# Case manager

$(TableOfContents())

Study the role of some drag models over falling particle dynamics.

Other than the drag models, particle size and role of parameter `applyGravity` in implicit packing model. The later was added because of unexpected (probably unphysical) results were found when playing with these parameters.
"""

# ╔═╡ c4841bbd-6f1d-451f-911d-f609a6298b2a
md"""
## Mesh generation

$(@bind remesh PlutoUI.Button("Remesh"))
"""

# ╔═╡ 471a7c04-746a-4210-97cf-705c990a7f66
let
    remesh
    run(`gmsh -3 geometry.geo -o geometry.msh`)
end

# ╔═╡ aab9fc6b-c8f0-4b9b-b7dd-138c03058532
md"""
## Parametric study

Drag models:

- `sphereDrag`
- `WenYuDrag`
- `ErgunWenYuDrag`

Apply gravity:

- true
- false

Particle sizes:

- 100 μm
- 500 μm
- 1000 μm

Gas density:

- 0.5 kg/m³
- 1.2 kg/m³

"""

# ╔═╡ 5a933239-04ab-4baf-bce5-51ce0192fc5d
begin
    @info "Reading solution data"
    d000 = readdlm("000-reference/fall.csv", ','; header = true)[1]
    d001 = readdlm("001-drag-model/fall.csv", ','; header = true)[1]
    d002 = readdlm("002-drag-model/fall.csv", ','; header = true)[1]
    d003 = readdlm("003-gravity/fall.csv", ','; header = true)[1]
    d004 = readdlm("004-particlesize/fall.csv", ','; header = true)[1]
    d005 = readdlm("005-particlesize/fall.csv", ','; header = true)[1]
    d006 = readdlm("006-rho-air/fall.csv", ','; header = true)[1]
end;

# ╔═╡ 3eae7bc9-1de9-4b20-b57c-6f332168feb6
md"""
## Reference solution

Computations performed as per [Amsden](https://doi.org/10.2172/6228444) to match the implementation of [`sphereDrag`](https://cpp.openfoam.org/v11/classFoam_1_1SphereDragForce.html#details) in OpenFOAM.

Notice that below the *Constant* solution is the analytical result at high Reynolds limit, while the KIVA-II values are computed for low ``Re``, thus it is expected that the former represents an upper bound of the solution, as demonstrated. For instance, by decreasing fluid kinematic viscosity ``\nu`` both solutions get closely related.
"""

# ╔═╡ fa625b66-bb31-4365-82f7-b0f1191d53c5
let
    reynolds(U, D, ν) = U * D / ν

    function dragcoef(Re)
        (Re > 1000.0) ? 0.424Re : 24.0*(1.0+(1.0/6.0)*Re^(2/3))
    end

    function particleforce(U, ν, ρ, ρₚ, d, mode)
        if mode == :openfoam
            Re = reynolds(U, d, ν)
            Cd = dragcoef(Re)
            μ = ρ * ν

            # TODO: check this `U` in the end. As per Amsden (1989) it should be
            # here in the 1D case, but that is not how it is stated in OpenFOAM.
            Fd = (3/4) * (μ * Cd) / (ρₚ * d^2) * U #^(1/2)
        else
            # Re ~ 10^6, so 0.424Re in the above case!
            Cd = 0.47
            Fd = (3/4) * (ρ / ρₚ) * U^2 / d * Cd
        end

        return -Fd + 9.81
    end

    function freefall!(du, u, p, t)
        du[1] = u[2]
        du[2] = particleforce(u[2], p...)
    end

    # Air properties.
    ρ  = 1.2
    ν  = 1.568e-05

    # Particle properties.
    ρₚ = 2450
    D = 500e-06

    # Expected terminal velocity.
    Uterm = sqrt((4/3) * (ρₚ / ρ) * D * 9.81 / 0.47)

    u0 = [0.0; 0.0]
    tspan = (0.0, 0.5)
    saveat = LinRange(tspan..., 100)

    p = [ν, ρ, ρₚ, D]

    prob = ODEProblem(freefall!, u0, tspan, (p..., :openfoam))
    sol1 = solve(prob; saveat)

    prob = ODEProblem(freefall!, u0, tspan, (p..., :constant))
    sol2 = solve(prob; saveat)

    with_theme() do
        f = Figure(size = (700, 600))

        ax1 = Axis(f[1, 1])
        ax2 = Axis(f[2, 1])

        lines!(ax1, sol1.t, sol1[1, :]; label = "KIVA-II")
        lines!(ax1, sol2.t, sol2[1, :]; label = "Constant")

        lines!(ax2, sol1.t, sol1[2, :]; label = "KIVA-II")
        lines!(ax2, sol2.t, sol2[2, :]; label = "Constant")

        # scatter!(ax2, sol2.t[end], Uterm; color = :red)

        ax1.ylabel = "Position [m]"
        ax2.ylabel = "Velocity [m/s]"
        ax2.xlabel = "Time [s]"

        axislegend(ax1; position = :lt)
        axislegend(ax2; position = :lt)

        f
    end
end

# ╔═╡ c4904d3a-c06c-49fe-9b63-1b370e656a8d
md"""
## Solution analysis

### Compare drag laws

From a qualitative standpoint all laws give the same global results. Fine analysis shows (not depicted, you can inspect the data) show a few millimeters of deviation between results.
"""

# ╔═╡ 974b40e5-0dac-4219-9c05-4ec53d254279
with_theme() do
    f = Figure(size = (700, 600))

    let
        ax = Axis(f[1, 1])

        ax.xlabel = "Time (s)"
        ax.ylabel = "Position (m)"

        ax.xticks = 0.0:0.1:0.5
        ax.yticks = 0.0:0.2:1.4

        xlims!(ax, extrema(ax.xticks.val))
        ylims!(ax, extrema(ax.yticks.val))

        Δy0 = abs.(d000[:, 3] .- d000[1, 3])
        Δy1 = abs.(d001[:, 3] .- d001[1, 3])
        Δy2 = abs.(d002[:, 3] .- d002[1, 3])

        lines!(ax, d000[:, 2], Δy0; label = "Sphere Drag")
        lines!(ax, d001[:, 2], Δy1; label = "Wen Yu Drag")
        lines!(ax, d002[:, 2], Δy2; label = "Ergun Wen Yu Drag")

        axislegend(ax; position = :lt)
    end

    let
        ax = Axis(f[2, 1])

        ax.xlabel = "Time (s)"
        ax.ylabel = "Velocity magnitude (m/s)"

        ax.xticks = 0.0:0.1:0.5
        ax.yticks = 0.0:0.5:4.0

        xlims!(ax, extrema(ax.xticks.val))
        ylims!(ax, extrema(ax.yticks.val))

        Δy0 = abs.(d000[:, 4])
        Δy1 = abs.(d001[:, 4])
        Δy2 = abs.(d002[:, 4])

        lines!(ax, d000[:, 2], Δy0; label = "Sphere Drag")
        lines!(ax, d001[:, 2], Δy1; label = "Wen Yu Drag")
        lines!(ax, d002[:, 2], Δy2; label = "Ergun Wen Yu Drag")

        axislegend(ax; position = :lt)
    end

    f
end

# ╔═╡ 28da4ef8-9543-47fe-9b7b-04e951354cc4
md"""
### Role of particle size

It is clear below the transition from laminar to turbulent: diameters increase, lines approach and should converge to a case where there is weak coupling.
"""

# ╔═╡ 9c36dda1-672f-41f2-8a1a-f9a1c96a6b22
with_theme() do
    f = Figure(size = (700, 600))

    let
        ax = Axis(f[1, 1])

        ax.xlabel = "Time (s)"
        ax.ylabel = "Position (m)"

        ax.xticks = 0.0:0.1:0.5
        ax.yticks = 0.0:0.2:1.6

        xlims!(ax, extrema(ax.xticks.val))
        ylims!(ax, extrema(ax.yticks.val))

        Δy0 = abs.(d004[:, 3] .- d004[1, 3])
        Δy1 = abs.(d000[:, 3] .- d000[1, 3])
        Δy2 = abs.(d005[:, 3] .- d005[1, 3])

        lines!(ax, d004[:, 2], Δy0; label = "0.1 mm")
        lines!(ax, d000[:, 2], Δy1; label = "0.5 mm")
        lines!(ax, d005[:, 2], Δy2; label = "1.0 mm")

        axislegend(ax; position = :lt)
    end

    let
        ax = Axis(f[2, 1])

        ax.xlabel = "Time (s)"
        ax.ylabel = "Velocity magnitude (m/s)"

        ax.xticks = 0.0:0.1:0.5
        ax.yticks = 0.0:1.0:6.0

        xlims!(ax, extrema(ax.xticks.val))
        ylims!(ax, extrema(ax.yticks.val))

        Δy0 = abs.(d004[:, 4])
        Δy1 = abs.(d000[:, 4])
        Δy2 = abs.(d005[:, 4])

        lines!(ax, d004[:, 2], Δy0; label = "0.1 mm")
        lines!(ax, d000[:, 2], Δy1; label = "0.5 mm")
        lines!(ax, d005[:, 2], Δy2; label = "1.0 mm")

        axislegend(ax; position = :lt)
    end

    f
end

# ╔═╡ 86447720-9515-4c19-8754-1427147ee239
md"""
### Effect of gravity

This is not the overall gravity, but the key `applyGravity` in packing model. Since we are in the dilute limit, there should be no visible effect here. To be investigated.
"""

# ╔═╡ cca47ca6-f243-45b5-84ea-59b301f571cd
with_theme() do
    f = Figure(size = (700, 600))

    let
        ax = Axis(f[1, 1])

        ax.xlabel = "Time (s)"
        ax.ylabel = "Position (m)"

        ax.xticks = 0.0:0.1:0.5
        ax.yticks = 0.0:0.2:1.4

        xlims!(ax, extrema(ax.xticks.val))
        ylims!(ax, extrema(ax.yticks.val))

        Δy0 = abs.(d000[:, 3] .- d000[1, 3])
        Δy1 = abs.(d003[:, 3] .- d003[1, 3])

        lines!(ax, d000[:, 2], Δy0; label = "Enabled")
        lines!(ax, d003[:, 2], Δy1; label = "Disabled")

        axislegend(ax; position = :lt)
    end

    let
        ax = Axis(f[2, 1])

        ax.xlabel = "Time (s)"
        ax.ylabel = "Velocity magnitude (m/s)"

        ax.xticks = 0.0:0.1:0.5
        ax.yticks = 0.0:0.5:4.0

        xlims!(ax, extrema(ax.xticks.val))
        ylims!(ax, extrema(ax.yticks.val))

        Δy0 = abs.(d000[:, 4])
        Δy1 = abs.(d003[:, 4])

        lines!(ax, d000[:, 2], Δy0; label = "Enabled")
        lines!(ax, d003[:, 2], Δy1; label = "Disabled")

        axislegend(ax; position = :lt)
    end

    f
end

# ╔═╡ e2701944-9e5f-464f-90cb-e80ecc2912c0
md"""
### Role of fluid density

Results match physically expected trends.
"""

# ╔═╡ 1989f9c1-c1d8-4163-8a3f-ecd923a78317
with_theme() do
    f = Figure(size = (700, 600))

    let
        ax = Axis(f[1, 1])

        ax.xlabel = "Time (s)"
        ax.ylabel = "Position (m)"

        ax.xticks = 0.0:0.1:0.5
        ax.yticks = 0.0:0.2:1.8

        xlims!(ax, extrema(ax.xticks.val))
        ylims!(ax, extrema(ax.yticks.val))

        Δy0 = abs.(d000[:, 3] .- d000[1, 3])
        Δy1 = abs.(d006[:, 3] .- d006[1, 3])

        lines!(ax, d000[:, 2], Δy0; label = "1.2 kg/m³")
        lines!(ax, d006[:, 2], Δy1; label = "0.5 kg/m³")

        axislegend(ax; position = :lt)
    end

    let
        ax = Axis(f[2, 1])

        ax.xlabel = "Time (s)"
        ax.ylabel = "Velocity magnitude (m/s)"

        ax.xticks = 0.0:0.1:0.5
        ax.yticks = 0.0:1.0:7.0

        xlims!(ax, extrema(ax.xticks.val))
        ylims!(ax, extrema(ax.yticks.val))

        Δy0 = abs.(d000[:, 4])
        Δy1 = abs.(d006[:, 4])

        lines!(ax, d000[:, 2], Δy0; label = "1.2 kg/m³")
        lines!(ax, d006[:, 2], Δy1; label = "0.5 kg/m³")

        axislegend(ax; position = :lt)
    end

    f
end

# ╔═╡ 6d85a352-e169-4016-aa4d-6e9ae392748a
md"""
## Functions
"""

# ╔═╡ 69a3d832-59a0-46f4-a7ff-9287a9eba5db
"Manages edition of a template with options."
function edittemplate(options, original; filled = nothing, drop = true)
    filled = isnothing(filled) ? splitext(original)[1] : filled

    open(filled, "w") do fp
        template = Mustache.load(original)
        write(fp, Mustache.render(template, options))
    end

    drop &&	rm(original)
end

# ╔═╡ b36f0c7c-5478-4c86-b5c1-51da7f29e29f
"Manages creation of case for numerical experiment."
function createcase(; casename, dragmodel, applygravity, particlesize, rho)
    src = joinpath(@__DIR__, "reference")
    dst = joinpath(@__DIR__, casename)

    if isdir(dst)
        @warn "Not overwritting existing case $(casename)"
        return
    end

    cp(src, dst; force = true)

    data = Dict(
        "OPENFOAMBANNER" => OpenFOAM.OPENFOAMBANNER,
        "dragModel"      => dragmodel,
        "applyGravity"   => applygravity,
        "particleSize"   => particlesize,
        "rho"            => rho
    )

    original = joinpath(dst, "constant/cloudProperties.template")
    edittemplate(data, original; drop = true)

    original = joinpath(dst, "constant/physicalProperties.template")
    edittemplate(data, original; drop = true)

    cmd = Cmd(`./Allrun`, dir=dst)
    run(pipeline(cmd, stdout=tempname()))
end

# ╔═╡ 26910a15-95e2-4ae0-a61f-3ff5521bfc27
let
    @info "Creating planned cases"

    sphereDrag     = "sphereDrag;"
    WenYuDrag      = "WenYuDrag\n{\nalphac alpha.air;\n}"
    ErgunWenYuDrag = "ErgunWenYuDrag\n{\nalphac alpha.air;\n}"

    createcase(;
        casename     = "000-reference",
        dragmodel    = sphereDrag,
        applygravity = "true",
        particlesize = 500e-06,
        rho          = 1.2)

    createcase(;
        casename     = "001-drag-model",
        dragmodel    = WenYuDrag,
        applygravity = "true",
        particlesize = 500e-06,
        rho          = 1.2)

    createcase(;
        casename     = "002-drag-model",
        dragmodel    = ErgunWenYuDrag,
        applygravity = "true",
        particlesize = 500e-06,
        rho          = 1.2)

    createcase(;
        casename     = "003-gravity",
        dragmodel    = sphereDrag,
        applygravity = "false",
        particlesize = 500e-06,
        rho          = 1.2)

    createcase(;
        casename     = "004-particlesize",
        dragmodel    = sphereDrag,
        applygravity = "true",
        particlesize = 100e-06,
        rho          = 1.2)

    createcase(;
        casename     = "005-particlesize",
        dragmodel    = sphereDrag,
        applygravity = "true",
        particlesize = 1000e-06,
        rho          = 1.2)

    createcase(;
        casename     = "006-rho-air",
        dragmodel    = sphereDrag,
        applygravity = "true",
        particlesize = 500e-06,
        rho          = 0.5)

end;

# ╔═╡ Cell order:
# ╟─3befec01-5817-445f-bed5-b47909eaf464
# ╟─f4d77b00-c12c-11ee-150b-cb97fa9d2c03
# ╟─c4841bbd-6f1d-451f-911d-f609a6298b2a
# ╟─471a7c04-746a-4210-97cf-705c990a7f66
# ╟─aab9fc6b-c8f0-4b9b-b7dd-138c03058532
# ╟─26910a15-95e2-4ae0-a61f-3ff5521bfc27
# ╟─5a933239-04ab-4baf-bce5-51ce0192fc5d
# ╟─3eae7bc9-1de9-4b20-b57c-6f332168feb6
# ╟─fa625b66-bb31-4365-82f7-b0f1191d53c5
# ╟─c4904d3a-c06c-49fe-9b63-1b370e656a8d
# ╟─974b40e5-0dac-4219-9c05-4ec53d254279
# ╟─28da4ef8-9543-47fe-9b7b-04e951354cc4
# ╟─9c36dda1-672f-41f2-8a1a-f9a1c96a6b22
# ╟─86447720-9515-4c19-8754-1427147ee239
# ╟─cca47ca6-f243-45b5-84ea-59b301f571cd
# ╟─e2701944-9e5f-464f-90cb-e80ecc2912c0
# ╟─1989f9c1-c1d8-4163-8a3f-ecd923a78317
# ╟─6d85a352-e169-4016-aa4d-6e9ae392748a
# ╟─b36f0c7c-5478-4c86-b5c1-51da7f29e29f
# ╟─69a3d832-59a0-46f4-a7ff-9287a9eba5db
