### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 7529d5a2-f27d-4630-be2e-4c2cfe87ae06
begin
    import Pkg
    Pkg.activate(Base.current_project())
    Pkg.resolve()
    Pkg.instantiate()

    using CairoMakie
    using DifferentialEquations: solve
    using DocStringExtensions: TYPEDFIELDS
    using Interpolations
    using ModelingToolkit
    using Polynomials
    using PlutoUI
    using StatsBase: rmsd

    TableOfContents()
end

# ╔═╡ a876e9c0-5082-11ee-069b-d756666798d2
md"""
# Porous medium plug-flow reactor

In this note we study the behavior of a conceptual counter current plug-flow reactor with a moving porous solid and gas phases. The following goals are

- Solve a basic plug-flow with wall heat exchanges
- Model heat transfer between phases in counter-flow problem
- Consider heat losses through solid refractory walls
- Add side mass flow injections at user supplied locations
- Include the effect of pressure drop over main inlet flow
- Add solid-gas mass exchange model (``\mathrm{H_2O}``, ``\mathrm{CO_2}``,...)
- Compare solids heating kinetics to a 3D CFD model
"""

# ╔═╡ 412b34dd-8189-4dde-8584-482c65b6ebd8
md"""
## Appendix A - Utilities
"""

# ╔═╡ 6438d22f-dbb9-470f-93e2-ef7330aca17a
md"""
### General conditions

In this section we provide those quantities that specify the problem and are intended to be held constant all along this study.

A parameter that is of particular interest here is the porosity level Φ, which is specified below as a function of position (because there might be *a priori* knowledge of its evolution over reactor length).
"""

# ╔═╡ 5888cf92-0a95-4a17-b83d-600b93dbd1ed
"Inlet composition of reference atmosphere"
const Y0 = [0.192, 0.016, 0.076, 0.012, 0.704]

# ╔═╡ 86c926de-ac8c-4df5-8b63-2b93a8ee2e0d
"Molar masses of species ordered as per `Y0`"
const MW = let
    mass = [
        1.008
        12.011
        14.007
        15.999
        39.95
    ]

    compounds = [
        0 1 0 2 0
         0 0 0 2 0
        2 0 0 1 0
        0 0 0 0 1
        0 0 2 0 0
    ]

    compounds * mass
end

# ╔═╡ d09419ba-ae90-4fbe-9b12-661d40662a37
"Mixture mean molecular mass [kg/mol]"
const M̄ = 0.001 ./ sum(@. Y0 / MW)

# ╔═╡ a0387438-cd1b-4c70-b02c-582d568f0813
md"""
### Properties of combustion gases

The properties provided in this section for gas phase were prepared to fit a composition described by the following mass fractions. This approximates certain combustion flue gas composition.

| Species           | Mass fraction | Mass fraction |
| ----------------: | :------------ | :------------ |
| ``\mathrm{CO_2}`` | $(Y0[1])      | $(MW[1])      |
| ``\mathrm{O_2}``  | $(Y0[2])      | $(MW[2])      |
| ``\mathrm{H_2O}`` | $(Y0[3])      | $(MW[3])      |
| ``\mathrm{Ar}``   | $(Y0[4])      | $(MW[4])      |
| ``\mathrm{N_2}``  | $(Y0[5])      | $(MW[5])      |
| Verification      | $(sum(Y0))    | $(1000M̄)      |

In what follows, ideal gas law is assumed valid, limiting the model range to near atmospheric pressures and consideration of *small* molecules in gas phase, without any major interacting forces.
"""

# ╔═╡ d595f1e5-fae1-420c-8163-6a60c121c6a4
"Gas phase specific heat [J/(kg.K)]"
const cₚ_gas = Polynomial([
    959.8458126240355,
    0.3029051601580761,
    3.988896105280984e-05,
    -6.093647929461819e-08,
    1.0991100692950414e-11
], :T)

# ╔═╡ 3462e85a-b14e-4622-ae58-b9ead3b21944
"Gas phase thermal conductivity [W/(m.K)]"
const k_gas = Polynomial([
    0.002951812556801408,
    7.402801713925036e-05,
    -2.5519055137003943e-09,
    -1.4679327713347819e-12,
    2.27325692450161e-16
], :T)

# ╔═╡ 92052050-5edd-46c9-bb48-ee61b35c3184
"Gas phase viscosity [Pa.s]"
const μ_gas = Polynomial([
    2.1249668087785053e-06,
    5.423882435038814e-08,
    -2.0189391494480477e-11,
    5.936917557684934e-15,
    -7.058723563087003e-19
], :T)

# ╔═╡ d069eede-afdd-4f88-b3ac-fb8c7e03120d
md"""
### Constants and helper functions
"""

# ╔═╡ f9b0f36f-2427-4a0a-930a-e075b8660040
"Ideal gas constant [J/(mol.K)]"
const GAS_CONSTANT = 8.314_462_618_153_24

# ╔═╡ 4d3c23f9-5549-4a0b-a5d9-2cd8c15051e7
"Reference atmospheric pressure [Pa]"
const P_ATMOSPHERE = 101_325.0

# ╔═╡ 3739ed10-d3b0-4cea-9522-c11eecde7d07
"Ideal gas specific mass of mixture [kg/m³]"
ρ(p, T) = p * M̄ / (GAS_CONSTANT * T)

# ╔═╡ df06b2ae-1157-43e4-a895-be328d788c16
"Perimeter of a rectangle [m]"
perim(s) = 2 * (s.depth + s.width)

# ╔═╡ 16b2896c-d5f5-419c-b728-76fefdc47b50
"Area of a rectangle"
area(s) = s.depth * s.width

# ╔═╡ 2e44d2ee-466b-49e9-acdf-c9e231f7c800
begin
    @info "Already migrated!"
    Φ(z) = 0.65
    const Tg₀ = 2073.0
    const Ts₀ = 313.0
    const ṁ_sol = 470e3/24/3600
    const ṁ_ref = 8.0
    const L = 10.0
    const Tenv = 313.0
    const section = (depth = 2.1, width = 6.7)
    const REACTOR_PERIMETER = perim(section)
    const REACTOR_CROSSAREA = area(section)
    const BLOCK_SIZE = 0.1
    const ρₛ = 3000.0
    const cₚ_sol = Polynomial([900.0,], :T)
    const k_sol = Polynomial([3.0], :T)
    const BLOCK_PERIM_PER_WALL = let
        # Surface area of a single block.
        αᵦ = 6BLOCK_SIZE^2

        # Volume of a single block.
        νᵦ = BLOCK_SIZE^3

        # Vertical cross-section.
        Aᵥ = area(section)

        # Vertical volume.
        Vᵥ = Aᵥ * L

        # Volume of all blocks.
        Vᵦ = (1 - Φ(L/2)) * Vᵥ

        # Number of blocks in vertical.
        Nᵦ = Vᵦ / νᵦ

        # Area of all blocks.
        Aᵦ = Nᵦ * αᵦ

        # Estimator of block perimeter in slice.
        Pᵦ = Aᵦ / L

        # Relative block to wall perimeter.
        σ = round(Pᵦ / perim(section))
    end

    @info "Not used in what follows"
    const zspan = (0.0, L)
    const saveat = range(zspan..., 101)
end;

# ╔═╡ 277bb20b-7e9d-40fe-ae33-457afad338ea
"Plot results of standard PFR solution"
function plotpfr(; gas, sol = nothing)

    xlaba = "Position [m]"
    ylab1 = "Temperature [K]"
    ylab2 = "Velocity [m/s]"
    ylab3 = "Density [kg/m³]"
    ylab4 = "Pressure [Pa]"

    xlims = (0.0, L)
    xticks = range(xlims..., 6)

    fig = Figure(resolution = (1000, 700))
    axes = fig[1, 1] = GridLayout()

    ax1 = Axis(axes[1, 1], ylabel = ylab1, xlabel = xlaba, xticks = xticks)
    ax2 = Axis(axes[2, 1], ylabel = ylab2, xlabel = xlaba, xticks = xticks)
    ax3 = Axis(axes[1, 2], ylabel = ylab3, xlabel = xlaba, xticks = xticks)
    ax4 = Axis(axes[2, 2], ylabel = ylab4, xlabel = xlaba, xticks = xticks)

    xlims!(ax1, xlims)
    xlims!(ax2, xlims)
    xlims!(ax3, xlims)
    xlims!(ax4, xlims)

    linkxaxes!(ax1, ax2, ax3, ax4)

    z = gas[:z]
    T = gas[:T]
    u = gas[:u]
    Ρ = gas[:Ρ]
    p = gas[:p] .- 101_325.0

    lines!(ax1, z, T, label = "Gas")
    lines!(ax2, z, u, label = "Gas")
    lines!(ax3, z, Ρ, label = "Gas")
    lines!(ax4, z, p, label = "Gas")

    if !isnothing(sol)
        z = reverse(sol[:z])
        T = sol[:T]
        u = sol[:u]

        lines!(ax1, z, T, label = "Solid")
        lines!(ax2, z, u, label = "Solid")
    end

    axislegend(ax1)
    axislegend(ax2)
    axislegend(ax3)
    axislegend(ax4)

    return fig
end

# ╔═╡ c8987a75-afac-40f0-80cc-582d1bd2c291
"Relax a new solution update"
relax(vold, vnew, α) = α * vnew + (1 - α) * vold

# ╔═╡ 499eead4-a91a-47c2-aaef-ab3732c36d04
md"""
### Solution interpolation

!!! important

    See this [link](https://github.com/SciML/ModelingToolkit.jl/issues/1354)
    for a partial solution of interpolation function registration. I am still
    unable to register functions in a local scope (using the `let` keyword to
    encapsulate the cell or a function).
"""

# ╔═╡ 7bcc4099-bcad-4ed1-bf11-db24054480c6
"Implements and updatable interpolator"
mutable struct TemperatureInterpolator
    "Coordinates to evaluate field"
    z::Vector{Float64}

    "Current state of solution"
    T::Vector{Float64}

    "Function to interpolate field"
    f::Function

    "Makes this object callable"
    (pint::TemperatureInterpolator)(z) = pint.f(z)

    function TemperatureInterpolator(z, T)
        f = LinearInterpolation(z, T)
        new(z, T, (t) -> f(t))
    end
end

# ╔═╡ 0258b67b-4854-4471-b349-6bfc3dfe9a66
"Update interpolator with new arrays"
function update!(pint::TemperatureInterpolator, z, T)
    pint.z = z
    pint.T = T

    f = LinearInterpolation(z, T)
    pint.f = (t) -> f(t)
end

# ╔═╡ cda59a70-852b-4358-9133-e4344577fcda
md"""
### Solution error tracker
"""

# ╔═╡ 2553b8a8-929b-4420-aa40-17e6878efaf1
"Update error of solution change and relax solution"
struct ErrorUpdater
    "Function to evaluate field"
    f::TemperatureInterpolator

    "Coordinates to evaluate field"
    z::Vector{Float64}

    "Previous state of solution"
    T_old::Vector{Float64}

    "Current state of solution"
    T_new::Vector{Float64}

    "Relaxation factor"
    α::Float64

    "Makes this object callable"
    (u::ErrorUpdater)(T_new) = let
        # Axis is the same, update relaxed state.
        u.T_new[:] = relax(u.T_old, T_new, u.α)
        update!(u.f, u.z, u.T_new)

        ε = maximum(abs, u.T_new - u.T_old)

        u.T_old[:] = u.T_new[:]
        return ε
    end

    function ErrorUpdater(f, z; α = 0.2)
        T_old = f(z)
        T_new = similar(T_old)
        return new(f, z, T_old, T_new, α)
    end
end

# ╔═╡ 11ccbbd8-b631-4377-8623-52f0ca15f0f8
md"""
## Appendix B - Simple models
"""

# ╔═╡ 7fcbe3a3-c6e8-4345-8e90-e6bacedcf54e
md"""
### Basic plug-flow model

Hypotheses:

1. Constant reactor cross-section
1. No reactions in gas phase
1. No mass flow changes (*injections* over length)
1. Constant imposed wall temperature over length

Under these conditions the standard plug-flow energy equation can be written as

```math
\rho{}u{}c_{p}(T)\frac{dT}{dz}=\frac{\hat{h}P}{A_{c}}\left(T_{w}-T\right)
```

Below we solve the problem with help of `BasePlugFlowModel`.
"""

# ╔═╡ 3ba75ef3-2385-4c73-a73c-cfd8dab93e11
"""
    BasePlugFlowModel()

Base representation of an ideal gas constant cross-section plug flow
reactor at atmospheric pressure with a fixed wall temperature.

$(TYPEDFIELDS)
"""
struct BasePlugFlowModel
    "Convective heat transfer coefficient [W/(m².K)]"
    ĥ::Num

    "Reactor wall perimeter [m]"
    P::Num

    "Reactor cross-sectional area [m²]"
    A::Num

    "Inlet mass flow rate [kg/s]"
    ṁ::Num

    "Wall temperature [K]"
    Tw::Num

    "Reactor axis coordinate [m]"
    z::Num

    "Gas temperature over axis [K]"
    T::Num

    "System of equations to simulate"
    sys::ODESystem

    function BasePlugFlowModel()
        # Independent variables.
        @variables z

        # Dependent variables.
        @variables T(z)

        # Observables.
        @variables p Ρ u

        # Model parameters.
        pars = @parameters ĥ P A ṁ Tw

        # Space derivative.
        D = Differential(z)

        # System of equations.
        eqs = [
            p ~ P_ATMOSPHERE
            Ρ ~ ρ(p, T)
            u ~ ṁ / (Ρ * A)
            D(T) ~ ĥ * P * (Tw - T) / (Ρ * u * A * cₚ_gas(T))
        ]

        # Assembly and simplify system.
        @named sys = ODESystem(eqs, z, [T], pars)
        sys = structural_simplify(sys)

        return new(ĥ, P, A, ṁ, Tw, z, T, sys)
    end
end

# ╔═╡ ede59bf2-70c2-46fe-affe-7aabfc7112f6
"Integrator with standard parameters for `BasePlugFlowModel`"
function solvebaseplugflow(; model, ĥ, P, A, ṁ)
    T = [model.T => Tg₀]

    p = [
        model.ĥ  => ĥ,
        model.P  => P,
        model.A  => A,
        model.ṁ  => ṁ,
        model.Tw => Tenv
    ]

    prob = ODEProblem(model.sys, T, zspan, p)
    return solve(prob; saveat=saveat)
end

# ╔═╡ d4055357-74e9-412b-af9a-38d9090e1e65
let
    plotpfr(; gas = solvebaseplugflow(;
            model = BasePlugFlowModel(),
            ĥ = 20.0,
            P = perim(section),
            A = area(section),
            ṁ = ṁ_ref
        )
    )
end

# ╔═╡ 757a04f9-acc4-4440-815f-f1ebaf54abc4
md"""
### Counter-flow heat transfer

Hypotheses:

1. Constant reactor cross-section per phase
1. No reactions in gas phase nor in solids
1. No mass flow changes (*injections* over length)
1. Constant imposed wall temperature over length
1. Solids transfer heat only with gas phase

Here we modify the standard plug-flow energy equation to be

```math
\begin{align}
%
\dot{Q}_{g-w} &=
    \left(\frac{\hat{h}P}{A}\right)_{g-w}\left(T_{w}-T_{g}\right)
\\[12pt]
%
\dot{Q}_{g-s} &=
    \left(\frac{\hat{h}P}{A}\right)_{g-s}\left(T_{s}-T_{g}\right)
\\[12pt]
%
\rho_{g}u_{g}c_{p,g}(T_{g})\frac{dT_{g}}{dz} &=
    \dot{Q}_{g-w}^{(z)} + \dot{Q}_{g-s}^{(z)}
\\[12pt]
%
\rho_{s}u_{s}c_{p,s}(T_{s})\frac{dT_{s}}{dz} &=
    -\dot{Q}_{g-s}^{(L-z)}
%
\end{align}
```

Below we solve the problem with help of both `CounterFlowPFRGasModel` and
`CounterFlowPFRSolidModel` in an iterative fashion.
"""

# ╔═╡ f48957cb-bbd9-494b-a8d3-5dd54ed75db3
"""
    CounterFlowPFRGasModel(Ts_f)

Gas phase PFR model for coupling with a counter-current solid with
established coordinate-dependent temperature function `Ts_f ≡ Ts(z)`.

$(TYPEDFIELDS)
"""
struct CounterFlowPFRGasModel
    "Convective heat transfer coefficient [W/(m².K)]"
    ĥ::Num

    "Reactor cross-sectional area [m²]"
    Ac::Num

    "Inlet mass flow rate [kg/s]"
    ṁ::Num

    "Wall temperature [K]"
    Tw::Num

    "Reactor gas-solid perimeter [m]"
    Pgs::Num

    "Reactor gas-walls perimeter [m]"
    Pgw::Num

    "Reactor axis coordinate [m]"
    z::Num

    "Gas temperature over axis [K]"
    T::Num

    "System of equations to simulate"
    sys::ODESystem

    function CounterFlowPFRGasModel(Ts_f)
        # Independent variables.
        @variables z

        # Dependent variables.
        @variables T(z)

        # External coupling.
        @variables Ts

        # Observables.
        @variables Qgw Qgs u A p Ρ

        # Model parameters.
        pars = @parameters ĥ Ac ṁ Tw Pgs Pgw

        # Space derivative.
        D = Differential(z)

        # System of equations
        eqs = [
            Ts ~ Ts_f(L-z)
            Qgw ~ ĥ * Pgw * (Tw - T)
            Qgs ~ ĥ * Pgs * (Ts - T)
            A ~ Ac * Φ(z)
            u ~ ṁ / (Ρ * A)
            p ~ 101_325.0
            Ρ ~ ρ(p, T)
            D(T) ~ (Qgw + Qgs) / (Ρ * u * A * cₚ_gas(T))
        ]

        # Assembly and simplify system.
        @named model = ODESystem(eqs, z, [T], pars)
        model = structural_simplify(model)

        return new(ĥ, Ac, ṁ, Tw, Pgs, Pgw, z, T, model)
    end
end

# ╔═╡ 36b4aa1e-40b0-4f6b-b060-ffa7223f8ea1
"""
    CounterFlowPFRGasModel(Ts_f)

Solid phase PFR model for coupling with a counter-current gas with
established coordinate-dependent temperature function `Tg_f ≡ Tg(z)`.

$(TYPEDFIELDS)
"""
struct CounterFlowPFRSolidModel
    "Convective heat transfer coefficient [W/(m².K)]"
    ĥ::Num

    "Reactor cross-sectional area [m²]"
    Ac::Num

    "Inlet mass flow rate [kg/s]"
    ṁ::Num

    "Wall temperature [K]"
    Tw::Num

    "Reactor gas-solid perimeter [m]"
    Pgs::Num

    "Reactor axis coordinate [m]"
    z::Num

    "Gas temperature over axis [K]"
    T::Num

    "System of equations to simulate"
    sys::ODESystem

    function CounterFlowPFRSolidModel(Tg_f)
        # Independent variables.
        @variables z

        # Dependent variables.
        @variables T(z)

        # External coupling.
        @variables Tg

        # Observables.
        @variables Qgs u A

        # Model parameters.
        pars = @parameters ĥ Ac ṁ Tw Pgs

        # Space derivative.
        D = Differential(z)

        # System of equations
        eqs = [
            Tg ~ Tg_f(L-z)
            Qgs ~ ĥ * Pgs * (T - Tg)
            A ~ Ac * (1.0 - Φ(L-z))
            u ~ ṁ / (ρₛ * A)
            D(T) ~ -Qgs / (ρₛ * u * A * cₚ_sol(T))
        ]

        # Assembly and simplify system.
        @named sys = ODESystem(eqs, z, [T], pars)
        sys = structural_simplify(sys)

        return new(ĥ, Ac, ṁ, Tw, Pgs, z, T, sys)
    end
end

# ╔═╡ 3e3a597f-2dc3-4714-94bc-156bfb078edb
"Integrator with standard parameters for `CounterFlowPFRGasModel`"
function solvecounterflowpfrgas(model, ĥ_num, P_num, A_num, ṁ_num)
    T = [model.T => Tg₀]

    p = [
        model.ĥ   => ĥ_num,
        model.Ac  => A_num,
        model.ṁ   => ṁ_num,
        model.Tw  => Tenv,
        model.Pgw => P_num,
        model.Pgs => P_num * BLOCK_PERIM_PER_WALL
    ]

    prob = ODEProblem(model.sys, T, zspan, p)
    return solve(prob; saveat=saveat)
end

# ╔═╡ 54b6a18f-6320-4cbb-917c-dea7a1ec36d6
"Integrator with standard parameters for `CounterFlowPFRSolidModel`"
function solvecounterflowpfrsolid(model, ĥ_num, P_num, A_num, ṁ_num)
    T = [model.T => Ts₀]

    p = [
        model.ĥ   => ĥ_num,
        model.Ac  => A_num,
        model.ṁ   => ṁ_num,
        model.Tw  => Tenv,
        model.Pgs => P_num * BLOCK_PERIM_PER_WALL
    ]

    prob = ODEProblem(model.sys, T, zspan, p)
    return solve(prob; saveat=saveat)
end

# ╔═╡ 4900d90f-15d0-459e-9e42-3c64df394bb0
"Iterativelly solve uncoupled counter-flow gas-solid PFR"
function solvecounterflowpfr(;
        gassolver,
        solsolver,
        maxiter = 20,
        atol = 1.0e-04
    )
    gashist = Float64[]
    solhist = Float64[]

    for _ in 1:maxiter
        push!(gashist, gassolver()[2])
        push!(solhist, solsolver()[2])

        if gashist[end] < atol && solhist[end] < atol
            break
        end
    end

    return gashist, solhist
end

# ╔═╡ dfc1ff2c-7695-41c7-bd0a-fd818eaf5087
counterflowpfr = begin
    println("Solving CounterFlowPFR(Gas|Solid)")

    # Solution controls.
    local α = 0.5
    local maxiter = 1000
    local atol = 1.0e-03

    # Model parameters.
    local ĥ = 50.0
    local P = REACTOR_PERIMETER
    local A = REACTOR_CROSSAREA

    # Allocate memory of interpolation arrays.
    local z_num = collect(saveat)
    local Ts_num = Ts₀ * ones(length(z_num))
    local Tg_num = Tg₀ * ones(length(z_num))

    # Create interpolation objects.
    local Ts_fun = TemperatureInterpolator(z_num, Ts_num)
    local Tg_fun = TemperatureInterpolator(z_num, Tg_num)

    # Wrap interpolation call at global scope.
    interp_linear_Ts(z) = Ts_fun(z)
    interp_linear_Tg(z) = Tg_fun(z)

    # Register global symbolic interfaces.
    @register interp_linear_Ts(z)
    @register interp_linear_Tg(z)

    # Create models with registered interpolators.
    local gas_model = CounterFlowPFRGasModel(interp_linear_Ts)
    local sol_model = CounterFlowPFRSolidModel(interp_linear_Tg)

    # Create error trackers/solution updaters.
    local gaserror = ErrorUpdater(Tg_fun, z_num; α = α)
    local solerror = ErrorUpdater(Ts_fun, z_num; α = α)

    # Wrap models in base interface.
    local gassolver() = let
        gas = solvecounterflowpfrgas(gas_model, ĥ, P, A, ṁ_ref)
        εgas = gaserror(gas[:T])
        gas, εgas
    end

    local solsolver() = let
        sol = solvecounterflowpfrsolid(sol_model, ĥ, P, A, ṁ_sol)
        εsol = solerror(sol[:T])
        sol, εsol
    end

    # Solution loop.
    @time local history = solvecounterflowpfr(;
        gassolver = gassolver,
        solsolver = solsolver,
        maxiter = maxiter,
        atol = atol
    )

    local fig = plotpfr(; gas = gassolver()[1], sol = solsolver()[1])
    (fig, history...)
end;

# ╔═╡ 1f3eee88-eded-452a-825d-5e6ea78399b6
let
    gashist, solhist = counterflowpfr[2:3]

    numiter = length(gashist)
    fig = Figure(resolution = (720, 400))
    ax = Axis(fig[1, 1], yscale = log10,
              ylabel = "Maximum ΔT",
              xlabel = "Iteration")

    lines!(ax, 1:numiter, gashist, label = "Gas")
    lines!(ax, 1:numiter, solhist, label = "Solid")
    xlims!(ax, (0, numiter+1))
    axislegend(ax)

    fig
end

# ╔═╡ b93ab73a-e9e3-49ea-bf4b-996b845f650d
counterflowpfr[1]

# ╔═╡ 3a193274-f5d0-418c-ad9a-582aca4b3cba
md"""
## Appendix C - Testing
"""

# ╔═╡ b531b71d-f7ee-45bc-b46a-6f6cbff3c7a2
let
    zz = collect(saveat)
    TT = Ts₀ * ones(length(zz))

    pint = TemperatureInterpolator(zz, TT)
    value_st = pint(4.5)

    update!(pint, zz, 2TT)

    @assert pint(4.5) ≈ 2value_st

    println("PASSED: interpolator update works")
end

# ╔═╡ Cell order:
# ╟─a876e9c0-5082-11ee-069b-d756666798d2
# ╟─412b34dd-8189-4dde-8584-482c65b6ebd8
# ╟─6438d22f-dbb9-470f-93e2-ef7330aca17a
# ╟─2e44d2ee-466b-49e9-acdf-c9e231f7c800
# ╟─a0387438-cd1b-4c70-b02c-582d568f0813
# ╟─5888cf92-0a95-4a17-b83d-600b93dbd1ed
# ╟─d09419ba-ae90-4fbe-9b12-661d40662a37
# ╟─86c926de-ac8c-4df5-8b63-2b93a8ee2e0d
# ╟─d595f1e5-fae1-420c-8163-6a60c121c6a4
# ╟─3462e85a-b14e-4622-ae58-b9ead3b21944
# ╟─92052050-5edd-46c9-bb48-ee61b35c3184
# ╟─d069eede-afdd-4f88-b3ac-fb8c7e03120d
# ╟─f9b0f36f-2427-4a0a-930a-e075b8660040
# ╟─4d3c23f9-5549-4a0b-a5d9-2cd8c15051e7
# ╟─3739ed10-d3b0-4cea-9522-c11eecde7d07
# ╟─df06b2ae-1157-43e4-a895-be328d788c16
# ╟─16b2896c-d5f5-419c-b728-76fefdc47b50
# ╟─277bb20b-7e9d-40fe-ae33-457afad338ea
# ╟─c8987a75-afac-40f0-80cc-582d1bd2c291
# ╟─499eead4-a91a-47c2-aaef-ab3732c36d04
# ╟─7bcc4099-bcad-4ed1-bf11-db24054480c6
# ╟─0258b67b-4854-4471-b349-6bfc3dfe9a66
# ╟─cda59a70-852b-4358-9133-e4344577fcda
# ╟─2553b8a8-929b-4420-aa40-17e6878efaf1
# ╟─11ccbbd8-b631-4377-8623-52f0ca15f0f8
# ╟─7fcbe3a3-c6e8-4345-8e90-e6bacedcf54e
# ╟─d4055357-74e9-412b-af9a-38d9090e1e65
# ╟─3ba75ef3-2385-4c73-a73c-cfd8dab93e11
# ╟─ede59bf2-70c2-46fe-affe-7aabfc7112f6
# ╟─757a04f9-acc4-4440-815f-f1ebaf54abc4
# ╟─dfc1ff2c-7695-41c7-bd0a-fd818eaf5087
# ╟─1f3eee88-eded-452a-825d-5e6ea78399b6
# ╟─b93ab73a-e9e3-49ea-bf4b-996b845f650d
# ╟─f48957cb-bbd9-494b-a8d3-5dd54ed75db3
# ╟─36b4aa1e-40b0-4f6b-b060-ffa7223f8ea1
# ╟─3e3a597f-2dc3-4714-94bc-156bfb078edb
# ╟─54b6a18f-6320-4cbb-917c-dea7a1ec36d6
# ╟─4900d90f-15d0-459e-9e42-3c64df394bb0
# ╟─3a193274-f5d0-418c-ad9a-582aca4b3cba
# ╟─b531b71d-f7ee-45bc-b46a-6f6cbff3c7a2
# ╟─7529d5a2-f27d-4630-be2e-4c2cfe87ae06
