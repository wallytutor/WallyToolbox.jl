### A Pluto.jl notebook ###
# v0.19.43

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try
            Base.loaded_modules[Base.PkgId(
                Base.UUID("6e696c72-6542-2067-7265-42206c756150"),
                "AbstractPlutoDingetjes",
            )].Bonds.initial_value
        catch
            b -> missing
        end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 276f19f0-9075-11ee-06f3-7d2f8111ed34
begin
    @info "Loading tools..."
    import Pkg
    Pkg.activate(Base.current_project())

    using CairoMakie
    using DifferentialEquations: solve
    using LinearAlgebra
    using ModelingToolkit
    using NumericalIntegration
    using Polynomials
    using PlutoUI
    using PrettyPrinting
    using Printf: @sprintf
    using Symbolics: scalarize
    using Trapz: trapz

    using WallyToolbox
    using DryConstants
    import DryMaterials as DM

    CairoMakie.activate!(; type = "svg", visible = false)
end

# ╔═╡ 062e6786-9518-4420-9ae2-6182508a5fa8
md"""
# Kaolinite process thermal analysis

$(TableOfContents())
"""

# ╔═╡ d54aad4f-5cfe-4ea3-a237-ba0ab8973721
md"""
In this note we investigate the right implementation to reproduce the kinetics of kaolinite calcination reported by [Eskelinen *et al.* (2015)](https://doi.org/10.1002/aic.14903). Neither their model nor their references properly provide the concentration units used in the rate laws, so that becomes an issue when trying to reproduce the results. Here we derive the equations for a complete mass and energy balance to simulate a coupled DSC/TGA analysis of the material in with different concentration units in the rate laws.
"""

# ╔═╡ 8e43ead5-4099-469e-9d74-6aa1b3659988
md"""
## Tools
"""

# ╔═╡ c05012fd-6647-48df-83ec-f7bf26686a87
md"""
### Species properties

In what follows the condensate species will be indexed as the next list, so for simplifying notation species will be referred to solely by their index.

1. Liquid water
1. Kaolinite ``Al_2Si_2O_5(OH)_4``
1. Metakaolin ``Al_2Si_2O_7``
1. *Spinel* ``Al_4Si_3O_{12}``
1. Amorphous silica ``SiO_2``

Final conversion of spinel into mullite and cristobalite is neglected here.

Polynomials for specific heat are those of [Schieltz and Soliman (1964)](https://doi.org/10.1346/CCMN.1964.0130139), except for *spinel* phase for which at the time of the publication was unknown. A rough estimate of its value is provided by [Eskelinen *et al.* (2015)](https://doi.org/10.1002/aic.14903). Since this phase is the least relevant in the present study and the  order of magnitude seems correct, it is employed in the simulations.
"""

# ╔═╡ 241f2150-c134-4951-b87d-d820727b8269
"Materials for considered phases."
const materials = [
    DM.PureWater()
    DM.getkaolinite()
    DM.getmetakaolin()
    DM.getspinel()
    DM.getamorphoussilica()
]

# ╔═╡ 5bc5d31b-9f3a-44e5-a271-12d9e8ffa7de
"Molecular masses of considered phases [``kg\\cdotp{}mol^{-1}``]"
const Mₘ = map(DM.molecularmass, materials)

# ╔═╡ 967579c7-252d-460c-a68d-c39dc9e2e0f0
"""
    specificheat(T)

Retrieve specific heat for all species
"""
specificheat(T) = map(m -> DM.specificheat(m, T, P_REF), materials)

# ╔═╡ 9d98242a-7487-447b-89a4-5b5acb957ff6
"""
    mixturespecificheat(T, Y)

Mass weighted mixture specific heat [``J\\cdotp{}kg^{-1}\\cdotp{}K^{-1}``]
"""
mixturespecificheat(T, Y) = scalarize(Y' * specificheat(T))

# ╔═╡ e7f229d8-f3d6-46d8-ac75-77b29d1138b8
md"""
### Global mechanism

Here we provide the mechanism discussed by [Eskelinen *et al.* (2015)](https://doi.org/10.1002/aic.14903). Individual reaction steps are better described by [Holm (2001)](https://doi.org/10.1039/b010031p), especially beyond our scope at high temperatures.

```math
\begin{aligned}
H_2O_{(l)} &\rightarrow H_2O_{(g)} & \Delta{}H>0\\
Al_2Si_2O_5(OH)_4 &\rightarrow Al_2Si_2O_7 + 2H_2O_{(g)} & \Delta{}H>0\\
2Al_2Si_2O_7 &\rightarrow Al_4Si_3O_{12} + {SiO_2}_{(a)} & \Delta{}H<0
\end{aligned}
```

Be ``r_{i}`` the rate of the above reactions in molar units, *i.e.* ``mol\cdotp{}s^{-1}``, then the rate of production of each of the considered species in solid state is given as:

```math
\begin{pmatrix}
\dot{\omega}_1\\
\dot{\omega}_2\\
\dot{\omega}_3\\
\dot{\omega}_4\\
\dot{\omega}_5\\
\end{pmatrix}
=
\begin{pmatrix}
 -1 &  0 &  0\\
  0 & -1 &  0\\
  0 &  1 & -2\\
  0 &  0 &  1\\
  0 &  0 &  1\\
\end{pmatrix}
\begin{pmatrix}
r_1\\
r_2\\
r_3\\
\end{pmatrix}
```

In matrix notation one can write ``\dot{\omega}=\nu\cdotp{}r``, as it will be implemented. By multiplying each element of the resulting array by its molecular mass we get the net production rates in mass units. Constant ``ν`` provides the required coefficients matrix.
"""

# ╔═╡ 19196b8d-566d-4598-acdf-363ffac7a49f
"Solid state stoichiometric coefficients"
const ν = [-1 0 0; 0 -1 0; 0 1 -2; 0 0 1; 0 0 1]

# ╔═╡ a35454c1-4641-48b2-8038-7dbc2a0da6ec
"""
    netproductionrates(r)

Species net production rate [``kg\\cdotp{}s^{-1}``]
"""
netproductionrates(r) = diagm(Mₘ) * (ν * r)

# ╔═╡ 54e51d24-0c32-46db-93fb-a63afaaf4604
md"""
Mass loss through evaporation and dehydroxylation is handled separately because it becomes simpler to evaluate the condensate phases specific heat in a later stage. The first two reactions release water to the gas phase, so ``\eta`` below provides the stoichiometry for this processes.

Sample mass loss is then simply ``\dot{m}=\eta\cdotp{}rM_1``, where ``M_1`` is water molecular mass so that the expression is given in ``kg\cdotp{}s^{-1}``.
"""

# ╔═╡ fd39ffac-32ef-4024-a82c-deeef802c228
"Gas phase stoichiometric coefficients"
const η = [1 2 0]

# ╔═╡ af9adbaa-1c81-484a-ba26-e68a6fb6f801
"""
    masslossrate(r)

Sample mass loss rate [``kg\\cdotp{}s^{-1}``]
"""
masslossrate(r) = -1 * scalarize(η * r) * Mₘ[1]

# ╔═╡ 0cd50f40-42e3-4d89-ae8f-a25205dc4270
md"""
### Balance equations

The modeled system - the solid material - is open in the sense it looses water to the environment. Thus, it is necessary to add this contribution to the balance equations so that evaluated mass fractions remain right. From the definitions below

```math
\frac{dm}{dt} = \dot{m}\qquad
\frac{dm_k}{dt} = \dot{\omega}\qquad
Y_k = \frac{m_k}{m}
```

and using the quotient rule of differentiation we can write

```math
\frac{dY_k}{dt}=\frac{m\dot{\omega}-\dot{m}m_k}{m^2}
```

that can be simplified to

```math
\frac{dY_k}{dt}=\frac{1}{m}\left(\dot{\omega}-\dot{m}Y_k\right)
```

which is the form we will implement here. Notice that the computation of ``\dot{m}`` is already provided by `masslossrate` and ``\dot{\omega}`` by `netproductionrates` so we can use the results of those evaluations in the following balance equation:
"""

# ╔═╡ 355c25a3-d199-47ee-85a2-82a00280fc01
"""
    speciesbalance(ṁ, ω̇, m, Y)

Compute balance equation for species with varying system mass.
"""
speciesbalance(ṁ, ω̇, m, Y) = (1 / m) * (ω̇ - Y .* ṁ)

# ╔═╡ 1d66b415-a683-4415-9911-0c3fbbbeb084
md"""
### Reaction kinetics

[Eskelinen *et al.* (2015)](https://doi.org/10.1002/aic.14903) compiles a set of pre-exponential factors and activation energies for *Arrhenius* rate constants for the above reactions, which are provided in `A` and `Eₐ` below. Their reported reaction enthalpies are given in ``ΔH``.
"""

# ╔═╡ 0f43e76f-57d9-4ddd-b8d5-41a6f66267d2
"Rate constant pre-exponential factor [``s^{-1}``]"
const A = [5.0000e+07; 1.0000e+07; 5.0000e+33]

# ╔═╡ 608ff25f-3671-4245-9a39-9c84d7537aa2
"Reaction rate activtation energies [``J\\cdotp{}mol^{-1}\\cdotp{}K^{-1}``]"
const Eₐ = [6.1000e+04; 1.4500e+05; 8.5600e+05]

# ╔═╡ d6b4e846-4890-4935-a58e-3f12961805db
"Reaction enthalpies per unit mass of reactant [``J\\cdotp{}kg^{-1}``]"
const ΔH = [2.2582e+06; 8.9100e+05; -2.1290e+05]

# ╔═╡ 9ee13330-4a2e-4879-83a9-58e7d14e67e2
"""
    rateconstants(T)

Evaluate rate constants [``s^{-1}``]
"""
rateconstants(T) = A .* exp.(-Eₐ ./ (GAS_CONSTANT * T))

# ╔═╡ 56a96fb0-a483-42cf-a4e4-2bd46d228e32
md"""
For such a global approach we do not have the privilege of working with actual concentrations because the mass distribution in the system is unknown and it would be meaningless to work with specific masses. Thus, assume the reaction rates are proportional to the number of moles of the reacting species ``n_r`` so we get the required units as exposed above. Then the ``r_i`` can be expressed as

```math
r_{i} = k_i(T)n_r=k_i(T)\frac{m_r}{M_r}=k_i(T)\frac{Y_r}{M_r}m
```
"""

# ╔═╡ 712db418-5d0e-4332-a88c-c71fbfd98663
"""
    reactionrates(m, T, Y)

Compute reaction rates [``mol\\cdotp{}s^{-1}``]
"""
function reactionrates(m, T, Y)
    k = rateconstants(T)
    r = m * k .* Y[1:3] ./ Mₘ[1:3]
    return scalarize(r)
end

# ╔═╡ 528e9b5d-8e01-4a35-9b48-3ed431a62369
"""
    heatrelease(r)

Total heat release rate for reactions [``J\\cdotp{}kg^{-1}``].
"""
heatrelease(r) = (r .* Mₘ[1:3])' * ΔH

# ╔═╡ 328def50-cd71-483a-bede-ac22f384ea10
md"""
### Experimental controls

To wrap-up we provide the programmed thermal cycle and the computation of required heat input to produce a perfect heating curve. It must be emphasized that actual DSC machines use some sort of controllers to reach this, what introduces one source of stochastic behavior to the measurement.
"""

# ╔═╡ c198f325-1bf5-4060-b26d-fa373297e7b9
"""
    temperature(t, θ̇; T₀ = 298.15)

Thermal cycle to apply to sample.
"""
temperature(t, θ̇; T₀ = 298.15) = T₀ + θ̇ * t

# ╔═╡ 5c21c362-caaa-41c2-8bf6-5bb9e85c1412
"""
    heatinput(m, c, θ̇, ḣ)

Required heat input rate to maintain heating rate `θ̇`.
"""
heatinput(m, c, θ̇, ḣ) = m * c * θ̇ + ḣ

# ╔═╡ b13ce972-3015-4d20-92ce-5289711f7605
md"""
## Model assembly

### Model statement

Below we put together everything that has been developed above.

There are a few different types of quantities here:

- Independent variables, here only ```t``
- Dependent variables, ``m`` and ``Y``
- Observable derivatives ``ṁ`` and ``Ẏ``
- Other observables (partial calculations)

Because of how a DSC analysis is conducted, it was chosen that the only model parameter should be the heating rate ``θ̇``. Furthermore, all other quantities were encoded in the developed functions.
"""

# ╔═╡ aedbd5b9-deb3-468c-a82e-5507d0ab8f51
begin
    @variables t
    D = Differential(t)

    @mtkmodel ThermalAnalysis begin
        @variables begin
            m(t)
            ṁ(t)

            Y(t)[1:5]
            Ẏ(t)[1:5]

            r(t)[1:3]
            ω̇(t)[1:5]

            T(t)
            c(t)
            ḣ(t)
            q̇(t)
        end
        @parameters begin
            θ̇
        end
        @equations begin
            scalarize(r .~ reactionrates(m, T, Y))...
            scalarize(ω̇ .~ netproductionrates(r))...

            scalarize(ṁ .~ masslossrate(r))...
            scalarize(Ẏ .~ speciesbalance(ṁ, ω̇, m, Y))...

            T ~ temperature(t, θ̇)
            c ~ mixturespecificheat(T, Y)
            ḣ ~ scalarize(heatrelease(r))
            q̇ ~ heatinput(m, c, θ̇, ḣ)

            D(m) ~ ṁ
            scalarize(D.(Y) .~ Ẏ)...
        end
    end
end;

# ╔═╡ a5b1e781-a756-46e7-80ae-a2e4c8172cea
md"""
Below we instantiate the `ThemalAnalysis` model.

We observed the expanded form with all variables and observables:
"""

# ╔═╡ e241fb89-ca3d-4777-8b64-cda11d4a1419
begin
    @named analysis = ThermalAnalysis()
    analysis
end

# ╔═╡ 6d474aa1-4dfa-47c7-83d3-b6ab51f3a164
md"""
For solution is is necessary to simplify this system to the equations that really are integrated. Using `structural_simplify` we reach this goal.
"""

# ╔═╡ 370f83eb-301b-4ae9-bfbc-91798e3e114b
begin
    model = structural_simplify(analysis)
    model
end

# ╔═╡ 22faaca8-6355-41e1-84c4-c883e9fcb981
md"""
Now we can get the actual `equations`:
"""

# ╔═╡ 4ca8b0fc-6506-401d-82d6-779ca0396bbf
equations(model)

# ╔═╡ d8db21d3-7f81-4251-a569-666ee262c030
md"""
... and the `observed` quantities.
"""

# ╔═╡ 3e5d5bfd-2d98-409c-8cf6-c26c8815574e
observed(model)

# ╔═╡ 734e656f-98b6-4167-b594-4a7b8800d28b
md"""
### Solution utilities

To make problem solution and visualization simple we provide the following utilities.
"""

# ╔═╡ e2679379-774a-498f-af8e-28da123d85d7
"""
    plotmodel(model, sol)

Standardized plotting of DSC/TGA analyses simulation.
"""
function plotmodel(model, sol)
    tk = sol[:t]
    Tk = sol[model.T] .- 273.15
    mk = sol[model.m]
    Y1 = sol[model.Y[1]]
    Y2 = sol[model.Y[2]] * 100
    Y3 = sol[model.Y[3]] * 100
    Y4 = sol[model.Y[4]] * 100
    Y5 = sol[model.Y[5]] * 100
    q = sol[model.q̇]

    Y1max = maximum(Y1)
    y1 = 100Y1 / Y1max
    label_water = "Water ($(@sprintf("%.2f", 100Y1max))%wt)"

    DSC = 1.0e-03 * (q ./ mk[1])
    TGA = 100mk ./ maximum(mk)

    δH = 1e-06cumul_integrate(tk, 1000DSC)

    f = Figure(size = (700, 700))

    ax1 = Axis(f[1, 1])
    ax2 = Axis(f[2, 1])
    ax3 = Axis(f[3, 1])
    ax4 = Axis(f[3, 1])

    lines!(ax1, Tk, y1; color = :blue, label = label_water)
    lines!(ax1, Tk, Y2; color = :black, label = "Kaolinite")
    lines!(ax1, Tk, Y3; color = :green, label = "Metakaolin")
    lines!(ax1, Tk, Y4; color = :red, label = "Spinel")
    lines!(ax1, Tk, Y5; color = :cyan, label = "Silica (A)")
    lines!(ax2, Tk, TGA; color = :black, label = "TGA")
    l3 = lines!(ax3, Tk, DSC; color = :black)
    l4 = lines!(ax4, Tk, δH; color = :red)

    axislegend(ax1; position = :ct, orientation = :horizontal)
    axislegend(ax2; position = :rt, orientation = :horizontal)
    axislegend(ax3, [l3, l4], ["DSC", "ΔH"], position = :lt, orientation = :horizontal)

    ax1.ylabel = "Mass content [%]"
    ax2.ylabel = "Residual mass [%]"
    ax3.ylabel = "Power input [mW/mg]"
    ax4.ylabel = "Enthalpy change [MJ/kg]"
    ax4.xlabel = "Temperature [°C]"

    xticks = 0:100:1200
    ax1.xticks = xticks
    ax2.xticks = xticks
    ax3.xticks = xticks
    ax4.xticks = xticks

    ax1.yticks = 0:25:100
    ax2.yticks = 80:4:100
    ax4.yticks = 0:0.5:2.5

    xlims!(ax1, (0, 1200))
    xlims!(ax2, (0, 1200))
    xlims!(ax3, (0, 1200))
    xlims!(ax4, (0, 1200))

    ylims!(ax1, (-1, 135))
    ylims!(ax2, (84, 100))
    ylims!(ax4, (0, 2.5))

    ax4.ygridcolor = :transparent
    ax4.yaxisposition = :right
    ax4.ylabelcolor = :red

    return f
end

# ╔═╡ dba9d916-e8c4-4e52-ad8e-55d77c188eb5
"""
    solvemodel(model, τ, Θ̇, m₀, Y₀)

Standard interface for solving the `ThermalAnalysis` model.
"""
function solvemodel(model, τ, Θ̇, m₀, Y₀)
    u0 = [
        model.m => m₀,
        model.Y[1] => Y₀[1],
        model.Y[2] => Y₀[2],
        model.Y[3] => Y₀[3],
        model.Y[4] => Y₀[4],
        model.Y[5] => Y₀[5],
    ]

    pars = [model.θ̇ => Θ̇]

    # Solver parameters
    abstol = 1.0e-15
    reltol = 1.0e-10
    dtmax = 0.001τ

    # Create and solve ODE problem with stiff algorithm.
    prob = ODEProblem(model, u0, (0.0, τ), pars)
    return solve(prob; alg = :stiff, abstol, reltol, dtmax)
end

# ╔═╡ 3f8f86bb-8890-47cf-9b56-8f5fd65e10ae
md"""
## Sensitivity study

Now it is time to play and perform a numerical experiment.

This will insights about the effects of some parameters over the expected results.

Use the slider below to select the value of:

|  |  |
|--------------------------|:---|
| Heating rate [°C/min]    | $(@bind θ̇slider PlutoUI.Slider([1,5,10,20,40,100]; show_value = true, default=20.0))
| Residual water [%wt]     | $(@bind hslider PlutoUI.Slider([0, 0.1, 0.5, 1, 2, 5]; show_value = true, default=0.5))
"""

# ╔═╡ 12ea7ab4-9f08-4483-8bf3-e4542d234d3b
sol, fig = let
    @info "Computation running here..."

    # Analysis heating rate.
    Θ̇ = θ̇slider / 60.0

    # Kaolin humidity level.
    h = hslider / 100.0

    # Initial mass (same as Meinhold, 2001).
    m₀ = 16.0e-06

    # Integration interval to simulate problem.
    τ = 1175.0 / Θ̇

    # Assembly array of initial states.
    Y₀ = [h, 1.0 - h, 0.0, 0.0, 0.0]

    # Call model solution routine.
    sol = solvemodel(model, τ, Θ̇, m₀, Y₀)

    # ... and plot results.
    fig = plotmodel(model, sol)

    sol, fig
end;

# ╔═╡ 1a9d4f7b-dfdd-4202-87d2-77a6c8a1e7b9
fig

# ╔═╡ 6069017a-6f01-4347-9a26-e3abcddf0fe9
md"""
An advantage of using observables in the model is the post-processing capactities it offers. All observables are stored in memory together with problem solution. If expected solution is too large, it is important to really think about what should be included as an observable for memory reasons.

Below we illustrate the mixture specific heat extracted from the observables.
"""

# ╔═╡ 15fc86de-2052-4767-af4d-608852059185
let
    T = sol[model.T] .- 273.15
    c = sol[model.c] ./ 1000

    f = Figure(size = (700, 250))
    ax = Axis(f[1, 1])
    lines!(ax, T, c; color = :black)

    ax.ylabel = "Specific heat [kJ/(kg.K)]"
    ax.xlabel = "Temperature [°C]"

    ax.xticks = 0:100:1200
    ax.yticks = 0.9:0.1:1.4
    xlims!(ax, (0, 1200))
    ylims!(ax, (0.9, 1.4))

    f
end

# ╔═╡ aa2bf440-fa66-4271-b21f-9d5f61dfa17b
md"""
Hope these notes provided you insights on DSC/TGA methods!
"""

# ╔═╡ Cell order:
# ╟─062e6786-9518-4420-9ae2-6182508a5fa8
# ╟─d54aad4f-5cfe-4ea3-a237-ba0ab8973721
# ╟─8e43ead5-4099-469e-9d74-6aa1b3659988
# ╟─276f19f0-9075-11ee-06f3-7d2f8111ed34
# ╟─c05012fd-6647-48df-83ec-f7bf26686a87
# ╟─241f2150-c134-4951-b87d-d820727b8269
# ╟─5bc5d31b-9f3a-44e5-a271-12d9e8ffa7de
# ╟─967579c7-252d-460c-a68d-c39dc9e2e0f0
# ╟─9d98242a-7487-447b-89a4-5b5acb957ff6
# ╟─e7f229d8-f3d6-46d8-ac75-77b29d1138b8
# ╟─19196b8d-566d-4598-acdf-363ffac7a49f
# ╟─a35454c1-4641-48b2-8038-7dbc2a0da6ec
# ╟─54e51d24-0c32-46db-93fb-a63afaaf4604
# ╟─fd39ffac-32ef-4024-a82c-deeef802c228
# ╟─af9adbaa-1c81-484a-ba26-e68a6fb6f801
# ╟─0cd50f40-42e3-4d89-ae8f-a25205dc4270
# ╟─355c25a3-d199-47ee-85a2-82a00280fc01
# ╟─1d66b415-a683-4415-9911-0c3fbbbeb084
# ╟─0f43e76f-57d9-4ddd-b8d5-41a6f66267d2
# ╟─608ff25f-3671-4245-9a39-9c84d7537aa2
# ╟─d6b4e846-4890-4935-a58e-3f12961805db
# ╟─9ee13330-4a2e-4879-83a9-58e7d14e67e2
# ╟─56a96fb0-a483-42cf-a4e4-2bd46d228e32
# ╟─712db418-5d0e-4332-a88c-c71fbfd98663
# ╟─528e9b5d-8e01-4a35-9b48-3ed431a62369
# ╟─328def50-cd71-483a-bede-ac22f384ea10
# ╟─c198f325-1bf5-4060-b26d-fa373297e7b9
# ╟─5c21c362-caaa-41c2-8bf6-5bb9e85c1412
# ╟─b13ce972-3015-4d20-92ce-5289711f7605
# ╠═aedbd5b9-deb3-468c-a82e-5507d0ab8f51
# ╟─a5b1e781-a756-46e7-80ae-a2e4c8172cea
# ╟─e241fb89-ca3d-4777-8b64-cda11d4a1419
# ╟─6d474aa1-4dfa-47c7-83d3-b6ab51f3a164
# ╟─370f83eb-301b-4ae9-bfbc-91798e3e114b
# ╟─22faaca8-6355-41e1-84c4-c883e9fcb981
# ╟─4ca8b0fc-6506-401d-82d6-779ca0396bbf
# ╟─d8db21d3-7f81-4251-a569-666ee262c030
# ╟─3e5d5bfd-2d98-409c-8cf6-c26c8815574e
# ╟─734e656f-98b6-4167-b594-4a7b8800d28b
# ╟─e2679379-774a-498f-af8e-28da123d85d7
# ╟─dba9d916-e8c4-4e52-ad8e-55d77c188eb5
# ╟─3f8f86bb-8890-47cf-9b56-8f5fd65e10ae
# ╟─12ea7ab4-9f08-4483-8bf3-e4542d234d3b
# ╟─1a9d4f7b-dfdd-4202-87d2-77a6c8a1e7b9
# ╟─6069017a-6f01-4347-9a26-e3abcddf0fe9
# ╟─15fc86de-2052-4767-af4d-608852059185
# ╟─aa2bf440-fa66-4271-b21f-9d5f61dfa17b
