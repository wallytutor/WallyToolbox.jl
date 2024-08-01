# Thermodynamic properties

```julia
using Revise
using WallyToolbox
using CairoMakie

disable_thermo_warnings()
```

```julia
data = ThermoDatabase(; selected_compounds = "*")
compounds(data)
```

## Comparison of silica properties

```julia
with_theme() do
    f = Figure()
    ax = Axis(f[1, 1])
    
    selected_compounds = ["SIO2_ALPHA"]
    data = ThermoDatabase(; selected_compounds)
    display(compounds(data))

    T = LinRange(300.0, 847.0, 100)
    cp1l(t) = specific_heat(data.compounds[1], t)
    cp2l(t) = specific_heat(data.compounds[2], t)
    lines!(ax, T, cp1l.(T); color = :black)
    lines!(ax, T, cp2l.(T); color = :red)


    selected_compounds = ["SIO2_BETA"]
    data = ThermoDatabase(; selected_compounds)
    display(compounds(data))
    
    T = LinRange(847.0, 1996.0, 100)
    cp1h(t) = specific_heat(data.compounds[1], t)
    cp2h(t) = specific_heat(data.compounds[2], t)
    lines!(ax, T, cp1h.(T); color = :black, label = "Chase (1998)")
    lines!(ax, T, cp2h.(T); color = :red,   label = "Schieltz (1964)")
    axislegend(ax; position = :lt)

    xlims!(ax, 300, 2000)
    ylims!(ax, 700, 1400)
    f
end
```

## Comparison of alumina properties

```julia
with_theme() do
    f = Figure()
    ax = Axis(f[1, 1])
    
    selected_compounds = ["AL2O3_GAMMA"]
    data = ThermoDatabase(; selected_compounds)
    display(compounds(data))
    
    T = LinRange(300.0, 2000.0, 100)
    cp1(t) = specific_heat(data.compounds[1], t)
    cp2(t) = specific_heat(data.compounds[2], t)
    lines!(ax, T, cp1.(T); label = "Chase (1998)")
    lines!(ax, T, cp2.(T); label = "Schieltz (1964)")
    axislegend(ax; position = :lt)
    f
end
```

```julia

```
