### A Pluto.jl notebook ###
# v0.19.40

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

# ╔═╡ c43baed9-a267-4cdd-9534-bf51274d2d1b
begin
    @info "Loading tools..."
    import Pkg
    Pkg.activate(Base.current_project())
    
    using CairoMakie
    using DifferentialEquations: solve
    using ModelingToolkit
    using NumericalIntegration
    using PlutoUI
    using PrettyPrinting
    using Printf: @sprintf
    using Trapz: trapz
    using WallyToolbox
end

# ╔═╡ ce8f4ea4-013c-4f73-9d0d-7c84cd29285d
md"""
# Modeling DSC / TGA data

Understanding the phase transformations is related energy aspects is key in any development in Materials Science. In what follows we summarize a simple modeling approach to extract detailed information from coupled DSC / TGA analyses. It can also be seen as a primer in [ModelingToolkit.jl](https://docs.sciml.ai/ModelingToolkit/stable/), the framework upon which the model is built.

$(TableOfContents())
"""

# ╔═╡ edd99e16-31e8-449a-b3fd-68a8824bc3d1
md"""
In this tutorial will will discuss the modeling of a chemical reaction such as

!!! note ""

    ```math
    a_{x}X \rightarrow{} a_{y}Y + a_{z}Z\quad(k(T), \Delta{}H)
    ```

where ``X`` and ``Y`` are solid species and product ``Z`` is released to the gas phase. The heat balance of this reaction that takes place with rate constant ``k(T)`` is given by the enthalpy change ``\Delta{}H``.

[Kissinger](https://doi.org/10.1021/ac60131a045) proposed in 1957 a formalism for analysis of coupled DSC/TGA of the above type of reactions. According to his ideas, one can model the untransformed content ``\alpha``  of a solid substance ``X`` as

```math
\frac{d\alpha}{dt}=k(T)(1-\alpha)^n
\quad\text{where}\quad{}
k(T)=A\exp\left[-\frac{E}{RT}\right]
```

Because of the thermally activated nature of the studied processes, an Arrhenius kinetic rate ``k(T)`` was chosen in the above equation. Because the degree of conversion is simply the ratio between the instantaneous mass ``m`` of ``X`` and its initial value ``m_0``, then

```math
1-\alpha = \frac{m}{m_0}\implies\frac{d\alpha}{dt}=-\frac{1}{m_0}\frac{dm}{dt}
```

so we can rewrite the differential equation as

!!! note ""

    ```math
    \frac{dm}{dt} = -m_0^{(1-n)} A\exp\left[-\frac{E}{RT}\right]m^n
    ```
"""

# ╔═╡ 872c6b13-c71f-45bb-9d9d-f1d239550902
md"""
## ODE variables
"""

# ╔═╡ 883b9fe2-992a-4d7f-a51c-24f3c3dc26eb
md"""
This is a time-dependent process, so we start by declaring the independent and dependent variables:
"""

# ╔═╡ 17f20bd0-6e3e-417c-b372-528c087c2c6a
@variables t m(t);

# ╔═╡ 7a9acd48-d338-4fc0-aeb8-b88423655a4a
md"""
To fulfill all the parameters in the model ODE we have:
"""

# ╔═╡ 888a8e11-61e8-47bf-a74f-fa377f7da19e
@parameters ΔH n A E m₀;

# ╔═╡ 2bfd834f-48d3-4475-90b1-481228529706
md"""
## Modeling TGA

Simplifying the chemical equation, we have that one mole of ``X`` releases ``a_z/a_x`` moles of ``Z``. Thus, the fractional mass ``\beta`` trasferred to the gas phase per unit mass of ``X`` is

```math
\beta = \frac{a_z}{a_x}\frac{M_z}{M_x}
```

If the sample is initially composed of pure ``X`` (an hypothesis that we will hold here to keep things simple), then the mass of the solid part system ``M`` at any given moment is

```math
M = (1 - \beta)m_0 + \beta{}m(t)
```

!!! important ""

    Notice that at ``t=0``, then ``M=m_0``. When there is no ``X`` left, then the remaining mass of the system is ``\beta{}m``, clarifying the meaning of beta. Thus, ``M`` at any instant is the sample mass at the DSC/TGS sample holder.

To describe ``\beta`` and ``M(t)`` we add up the following:
"""

# ╔═╡ 16316e53-3ea7-4034-afc5-be4b4fec0712
@variables M(t);

# ╔═╡ 12c2b5d3-10d1-4969-9060-bcfb09c0c303
@parameters ax az Mx Mz;

# ╔═╡ 6e610982-f1b9-47ee-8435-420fc7e37b6a
md"""
## Modeling DSC

By definition, the goal of a DSC is to provide heat to a sample to keep its temperature increasing at a constant rate ``\dot{\theta}``. If test is started at a temperature ``T_0``, then ``T(t) = T_0 + \dot{\theta}t``.

In the current framework these are added to the model as:
"""

# ╔═╡ 6cf17870-fc26-4e2b-962f-4f47eb22cef9
@variables T(t);

# ╔═╡ d5061c07-1d2d-4e6b-9228-772f3ade6c6f
@parameters θ̇ T₀;

# ╔═╡ a72d47a4-1c05-49d1-9ca7-6c0bb975363a
md"""
For keeping up the heating rate ``\dot{\theta}`` the apparatus needs to provide the following power to the sample

!!! note ""

    ```math
    \dot{q} = M(t)c_P\dot{\theta} + \dot{m}\Delta{}H
    ```

All parameters but ``c_P`` have been provided so far. Notice here that ``c_P`` represents only the condensate phases specific heat, which are supposed to be in a condition of *mechanical mixture*. Under these circumstances the equivalent specific heat is given as a mass-weighted average

```math
c_P = Y_{x}c_{P,x} + Y_{y}c_{P,y}
```

where ``Y_{k}`` is the mass fraction of species ``K``. Because the solid state components are only ``X`` and ``Y`` this expression can be reformulated as

```math
c_P = \frac{m(t)c_{P,x} + \left(M(t) - m(t)\right)c_{P,y}}{M(t)}
```

so only ``c_{P,x}`` and ``c_{P,y}`` are missing as model parameters. This will be provided later through a different mechanism because of their reliance on temperature.
"""

# ╔═╡ fee03514-dfcd-484c-9f5a-fcb2a9bc55dc
md"""
## Assembly of equations
"""

# ╔═╡ 687e7d85-cde4-46c9-b776-eaf7cca4a973
function assemblymodel(cpx, cpy)
    β = (az / ax) * (Mz / Mx);

    D = Differential(t);

    @variables ṁ(t) c(t) k(t) ḣ(t) q̇(t);

    eqs = [
        # Temperature increases at constant rate [K].
        T ~ T₀ + θ̇ * t,

        # Track mass of system for TGA/DSC analysis [kg].
        M ~ (1-β) * m₀ + β * m,

        # Mass weighted specific heat [J/(kg.K)].
        c ~ (m * cpx(T) + (M-m) * cpy(T)) / M,

        # Arrhenius kinetics rate law [1/s].
        k ~ A * exp(-E / (GAS_CONSTANT * T)),

        # Store problem derivative for analysis [kg/s].
        ṁ ~ -k * m₀^(1-n) * m^n,

        # Reaction enthalpy heat rate [W].
        ḣ ~ ΔH * ṁ,

        # Track required heat input to justify θ̇ [W].
        q̇  ~ M * c * θ̇ + ḣ,

        #  Finally stack the derivative to the problem [kg/s].
        D(m) ~ ṁ
    ]
    return eqs
end;

# ╔═╡ 2bff2c9b-29bd-4fc1-8556-c9af051bd721
md"""
## Sample case

For the practical example that follows we will implement the dehydroxylation of kaolinite into metakaolin plus steam, which can be expressed as:

```math
Al_2Si_2O_5(OH)_4 \rightarrow Al_2Si_2O_7 + 2H_2O_{(g)}
```
"""

# ╔═╡ c9196b25-ec02-4c98-b6c3-b794e9550d07
md"""
The model creation function `assemblymodel(cpx, cpy)` requires the specific heats of species ``X`` and ``Y`` to be provided. Below we provide functions for generation of symbolic ``c_P`` functions for kaolinite and metakaolin under the `ModellingToolkit` framework.
"""

# ╔═╡ 7b97bd4c-2928-4c24-a7d7-8332f1a49e12
begin
    cpx(T) = 932.347 + 0.572679 * T - 1.27676e7 / T^2
    cpy(T) = 1034.30 + 0.165941 * T - 6.56221e6 / T^2
end;

# ╔═╡ f7438057-3f77-4155-837c-92d85a90cf88
md"""
With these functions in hand we can go ahead and create the system of equations and create the `ODESystem` model. Notice that all intermediate *observables* created in the equations array are available.
"""

# ╔═╡ ead986d8-bd2a-442c-b581-03c7d46daef6
begin
    eqs = assemblymodel(cpx, cpy)

    @named model = ODESystem(eqs, t)
end

# ╔═╡ af8fd783-7b86-4f66-9817-06bd81cd1517
md"""
All these equations but the time derivative are simple algebraic relationships that need not to be solved. In fact, if we tried to solve them, it would generate a complex DAE problem instead of an ODE system, what could be time-consuming.

Hopefully `ModelingToolkit` handles structural simplification and is able to detect that the system is composed of a single ODE. No need to worry, the *observables* will still be stored with the solution and be accessible for post-processing.
"""

# ╔═╡ 778a56af-09e4-4a8e-9838-9816b0a4b6c5
model_final = structural_simplify(model)

# ╔═╡ de78ad6c-9828-4a74-a579-2adcb8424a66
md"""
Now we are ready to provide the numerical inputs for system solution. Other quantities that are shared between initialization and model parameters are provided below:
"""

# ╔═╡ d0506cba-b5eb-4c72-9f00-c731b7245603
begin
    # Sample mass: 16 mg (1 mg = 10^(-6) kg).
    @show val_m₀ = 16.0e-06

    # Heating rate (θ̇ °C/min) * (1min / 60s).
    @show val_θ̇  = 40.0 / 60.0

    # Initial temperature in K.
    @show val_T₀ = 273.15 + 25.0

    # Final temperature in K.
    @show val_T₁ = 273.15 + 950.0
end;

# ╔═╡ 60e41b3d-4c4d-4a57-9517-8c27d9baf5ec
md"""
The parameters *pairs* array is assembled below.

Values for reaction enthalpy and kinetics rate are taken from the [literature](https://doi.org/10.1002/aic.14903).
"""

# ╔═╡ 9f54bfef-e045-4fca-b696-b00d18825d82
begin
    pars = [
        ΔH  => -891_000.0,
        n   => 1.00,
        A   => 1.00e+07,
        E   => 1.45e+05,
        m₀  => val_m₀,
        ax  => 1.0,
        az  => 2.0,
        Mx  => 0.257902462000,
        Mz  => 0.018010564683,
        θ̇   => val_θ̇,
        T₀  => val_T₀,
    ];
    pprint(pars)
end

# ╔═╡ 81d8b2c7-cb00-4b56-a073-b60713e148f3
md"""
Since the only ODE being solved is the sample mass, this is the provided initial condition.
"""

# ╔═╡ df46e437-51a9-4c49-9d20-50d73aaf5be1
u0 = [m => val_m₀];

# ╔═╡ b88d9170-0352-4e7b-9690-d34757636442
md"""
The next plot depicts the material expected DSC/TGA results:
"""

# ╔═╡ 55b79d52-b88f-4a45-a342-0d8fe7469666
md"""
For higher order simulation, *i.e* CFD/FEA models and related, it is the curve in the bottom that generally matters. With this enthalpy curve we can identify how much *net* heat must be supplied to the material to provide a given temperature increase.
"""

# ╔═╡ e8a8380c-9adb-4ba7-adfd-2224a039c3f3
md"""
## Supporting tools
"""

# ╔═╡ 0016504a-b623-46c8-ac0e-7800ea33e433
"Standardized plotting of simulation."
function plotanalysis(sol; boundaxes = true, normdsc = false)
    t = sol[:t]
    T = sol[:T] .- 273.15
    m = sol[:m]
    h = sol[:ḣ]
    q = sol[:q̇]
    M = sol[:M]

    DSC = 1000q
    TGA = 100M / val_m₀
    ΔH = 1.0e-06 * cumul_integrate(t, q) / val_m₀
    δH = trapz(t, h) / (val_m₀)

    f = Figure(size = (700, 600))

    ax1 = Axis(f[1, 1], ylabel = "TGA, %")
    ax2 = Axis(f[1, 1], ylabel = "DSC, mW", ylabelcolor = :red)
    ax3 = Axis(f[2, 1], ylabel = "Enthalpy, MJ/kg")

    lines!(ax1, T, TGA; color = :black)

    if normdsc
        lines!(ax2, T, DSC ./ maximum(DSC); color = :red)
        lines!(ax3, T, ΔH ./ maximum(ΔH); color = :black)
        ax2.ylabel = "DSC, normalized"
        ax3.ylabel = "Enthalpy, normalized"
    else
        lines!(ax2, T, DSC; color = :red)
        lines!(ax3, T, ΔH; color = :black)
    end

    ax2.ygridcolor = :transparent
    ax2.yaxisposition = :right

    ax1.title = "Reaction enthalpy $(@sprintf("%.0f", δH)) J/kg"
    ax3.xlabel = "Temperature, °C"

    f, ax1, ax2, ax3
end

# ╔═╡ 761f6651-8a89-48b7-8276-53c4dadc2ad2
fig = let
    # Integration interval to simulate problem.
    τ = (val_T₁ - val_T₀) / val_θ̇

    # Create and solve ODE problem with stiff algorithm.
    prob = ODEProblem(model_final, u0, (0.0, τ), pars);
    sol = solve(prob; alg = :stiff, dtmax = 0.001τ)

    # Standard post-processing of results.
    f, ax1, ax2, ax3 = plotanalysis(sol; normdsc = false)

    ax1.xticks = 200:100:800
    ax2.xticks = 200:100:800
    ax3.xticks = 200:100:800

    ax1.yticks = 85:5:100
    ax3.yticks = 0:0.5:2.5

    xlims!(ax1, extrema(ax1.xticks.val))
    xlims!(ax2, extrema(ax2.xticks.val))
    xlims!(ax3, extrema(ax3.xticks.val))

    ylims!(ax1, (84, 101))
    ylims!(ax3, extrema(ax3.yticks.val))

    f
end

# ╔═╡ c97b4756-509b-493b-b1e0-52d2f9fd80c1
fig

# ╔═╡ e173efa6-1808-47db-a938-4ae33e3db507
begin
    @info "Sliders configurations"
    thetas = [0.001, 0.01, 0.1, 1, 5, 10, 20, 50, 100, 500, 1000, 2000]
    enthalpies = [0.0, 5e4, 5e5, 1e6, 1e7, 1e8]
end;

# ╔═╡ 11c4dec9-fcbe-4849-b2f0-69a53c198665
md"""
## Sensitivity study

Now it is time to play and perform a numerical experiment.

This will insights about the effects of some parameters over the expected results.

Use the sliders below to select the values of:

|  |  |
|--------------------------|:---|
| Heating rate [°C/min]    | $(@bind θ̇slider PlutoUI.Slider(thetas; show_value = true, default=50.0))
| Reaction enthalpy [J/kg] | $(@bind ΔHslider PlutoUI.Slider(enthalpies; show_value = true, default = 1e6))
| Ratio ``a_z/a_x``        | $(@bind rslider PlutoUI.Slider(1:1:10; show_value = true, default = 2))
| ``c_{P,x}`` [J/(kg.K)]   | $(@bind cxslider PlutoUI.Slider(800:100:1500; show_value = true, default = 1100))
| ``c_{P,y}``  [J/(kg.K)]  | $(@bind cyslider PlutoUI.Slider(800:100:1500; show_value = true, default = 900))
"""

# ╔═╡ 61301359-1998-4555-b8e4-7c0321b44682
let
    val_θ̇ = θ̇slider / 60.0

    pars = [
        ΔH  => -ΔHslider,
        n   => 1.00,
        A   => 1.00e+07,
        E   => 1.45e+05,
        m₀  => val_m₀,
        ax  => 1.0,
        az  => rslider,
        Mx  => 0.250,
        Mz  => 0.025,
        θ̇   => val_θ̇,
        T₀  => val_T₀,
    ];

    T₁ = 1400

    cpx(_) = cxslider
    cpy(_) = cyslider

    eqs = assemblymodel(cpx, cpy)
    @named model = ODESystem(eqs, t)
    model_final = structural_simplify(model)

    # Integration interval to simulate problem.
    τ = (T₁ - val_T₀) / val_θ̇

    # Create and solve ODE problem with stiff algorithm.
    prob = ODEProblem(model_final, u0, (0.0, τ), pars);
    sol = solve(prob; alg = :stiff, dtmax = 0.001τ)

    # Standard post-processing of results.
    f, ax1, ax2, ax3 = plotanalysis(sol; normdsc = true)

    ax1.xticks = 200:100:1000
    ax2.xticks = 200:100:1000
    ax3.xticks = 200:100:1000

    ax1.yticks = 0:10:100
    ax3.yticks = 0:0.2:1.0

    xlims!(ax1, extrema(ax1.xticks.val))
    xlims!(ax2, extrema(ax2.xticks.val))
    xlims!(ax3, extrema(ax3.xticks.val))

    ylims!(ax1, (-1, 101))
    ylims!(ax3, (-0.01, 1.01))

    f
end

# ╔═╡ Cell order:
# ╟─ce8f4ea4-013c-4f73-9d0d-7c84cd29285d
# ╟─c97b4756-509b-493b-b1e0-52d2f9fd80c1
# ╟─c43baed9-a267-4cdd-9534-bf51274d2d1b
# ╟─edd99e16-31e8-449a-b3fd-68a8824bc3d1
# ╟─872c6b13-c71f-45bb-9d9d-f1d239550902
# ╟─883b9fe2-992a-4d7f-a51c-24f3c3dc26eb
# ╠═17f20bd0-6e3e-417c-b372-528c087c2c6a
# ╟─7a9acd48-d338-4fc0-aeb8-b88423655a4a
# ╠═888a8e11-61e8-47bf-a74f-fa377f7da19e
# ╟─2bfd834f-48d3-4475-90b1-481228529706
# ╠═16316e53-3ea7-4034-afc5-be4b4fec0712
# ╠═12c2b5d3-10d1-4969-9060-bcfb09c0c303
# ╟─6e610982-f1b9-47ee-8435-420fc7e37b6a
# ╠═6cf17870-fc26-4e2b-962f-4f47eb22cef9
# ╠═d5061c07-1d2d-4e6b-9228-772f3ade6c6f
# ╟─a72d47a4-1c05-49d1-9ca7-6c0bb975363a
# ╟─fee03514-dfcd-484c-9f5a-fcb2a9bc55dc
# ╠═687e7d85-cde4-46c9-b776-eaf7cca4a973
# ╟─2bff2c9b-29bd-4fc1-8556-c9af051bd721
# ╟─c9196b25-ec02-4c98-b6c3-b794e9550d07
# ╠═7b97bd4c-2928-4c24-a7d7-8332f1a49e12
# ╟─f7438057-3f77-4155-837c-92d85a90cf88
# ╟─ead986d8-bd2a-442c-b581-03c7d46daef6
# ╟─af8fd783-7b86-4f66-9817-06bd81cd1517
# ╟─778a56af-09e4-4a8e-9838-9816b0a4b6c5
# ╟─de78ad6c-9828-4a74-a579-2adcb8424a66
# ╟─d0506cba-b5eb-4c72-9f00-c731b7245603
# ╟─60e41b3d-4c4d-4a57-9517-8c27d9baf5ec
# ╟─9f54bfef-e045-4fca-b696-b00d18825d82
# ╟─81d8b2c7-cb00-4b56-a073-b60713e148f3
# ╠═df46e437-51a9-4c49-9d20-50d73aaf5be1
# ╟─b88d9170-0352-4e7b-9690-d34757636442
# ╟─761f6651-8a89-48b7-8276-53c4dadc2ad2
# ╟─55b79d52-b88f-4a45-a342-0d8fe7469666
# ╟─11c4dec9-fcbe-4849-b2f0-69a53c198665
# ╟─61301359-1998-4555-b8e4-7c0321b44682
# ╟─e8a8380c-9adb-4ba7-adfd-2224a039c3f3
# ╟─0016504a-b623-46c8-ac0e-7800ea33e433
# ╟─e173efa6-1808-47db-a938-4ae33e3db507
