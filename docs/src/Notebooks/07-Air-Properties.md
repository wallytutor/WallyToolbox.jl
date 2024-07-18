# Fitting air properties

In this note we show how to use [Cantera](https://cantera.org/) to retrieve mixture properties for use in external simulations. This approach should be used only when composition dependency may be neglected or real-time evaluation becomes to expensive.

```julia; @example notebook
using WallyToolbox
using DryTransport

using CairoMakie
using CondaPkg
using Polynomials
using PythonCall

CondaPkg.add("cantera")
ct = pyimport("cantera")
nothing; #hide
```

Since Cantera is not yet available from Julia (I am working on that!), we wrap the interfacing with Python code in function `fit_gas_properties` provided below.

```julia; @example notebook
function fit_gas_properties(T, X; orders = Dict(), P = ct.one_atm)
    gas = ct.Solution("gri30.yaml")
    
    sol = ct.SolutionArray(gas, shape=length(T))
    sol.TPX = pylist(T), P, pydict(X)

    mu = pyconvert(Vector{Float64}, sol.viscosity)
    kg = pyconvert(Vector{Float64}, sol.thermal_conductivity)
    cp = pyconvert(Vector{Float64}, sol.cp_mass)
    
    poly_mu = Polynomials.fit(T, mu, get(orders, :mu, 4))
    poly_kg = Polynomials.fit(T, kg, get(orders, :kg, 4))
    poly_cp = Polynomials.fit(T, cp, get(orders, :cp, 4))

    return (mu, kg, cp, poly_mu, poly_kg, poly_cp)
end
nothing; #hide
```

For illustration purposes we make use of a typical composition of air over a broad range of temperatures. Verification is performed against values proposed in the literature by ([[@Mujumdar2006i]]).

```julia; @example notebook
orders = Dict(:mu => 4, :kg => 4, :cp => 4)

T = LinRange(200, 3000, 200)

X = Dict("O2" => 0.21, "H2O" => 0.006, "Ar" => 0.012, "CO2" => 0.04)
X["N2"] = 1.0 - sum(values(X))

rets = fit_gas_properties(T, X; orders)

mu, kg, cp, poly_mu, poly_kg, poly_cp = rets

μmuj = AirViscosityMujumdar2006()
kmuj = AirHeatConductivityMujumdar2006()
nothing; #hide
```

Finally we visualize the results:

```julia; @example notebook
with_theme() do
    f = Figure(size = (700, 800))
    
    ax1 = Axis(f[1, 1])
    ax2 = Axis(f[2, 1])
    ax3 = Axis(f[3, 1])

    lines!(ax1, T, mu; color = :black)
    lines!(ax2, T, kg; color = :black)
    lines!(ax3, T, cp; color = :black)

    lines!(ax1, T, poly_mu.(T); color = :red)
    lines!(ax2, T, poly_kg.(T); color = :red)
    lines!(ax3, T, poly_cp.(T); color = :red)

    lines!(ax1, T, μmuj.(T); color = :blue)
    lines!(ax2, T, kmuj.(T); color = :blue)

    ylims!(ax1, 1.0e-05, 9.0e-05)
    ylims!(ax2, 0.0, 0.2)
    
    ax1.ylabel = "Viscosity [Pa.s]"
    ax2.ylabel = "Conductivity [W/(m.K)]"
    ax3.ylabel = "Specific heat [J/(kg.K)]"
    ax3.xlabel = "Temperature [K]"
    
    f
end
```
