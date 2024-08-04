# Fitting air properties

In this note we show how to use [Cantera](https://cantera.org/) to retrieve mixture properties for use in external simulations. This approach should be used only when composition dependency may be neglected or real-time evaluation becomes to expensive.

```julia; @example notebook
using WallyToolbox

using CairoMakie
using CondaPkg
using Polynomials
using PythonCall

CondaPkg.add("cantera")
# CondaPkg.add("numpy")

ct = pyimport("cantera")
np = pyimport("numpy")
nothing; #hide
```

Since Cantera is not yet available from Julia (I am working on that!), we wrap the interfacing with Python code in function `fit_gas_properties` provided below.

For display of results, we also provide a standardized plotting function `plot_gas_properties`.

```julia; @example notebook
function fit_gas_properties(sol; orders = Dict())
    T = pyconvert(Vector{Float64}, sol.T)

    mu = pyconvert(Vector{Float64}, sol.viscosity)
    kg = pyconvert(Vector{Float64}, sol.thermal_conductivity)
    cp = pyconvert(Vector{Float64}, sol.cp_mass)

    poly_mu = Polynomials.fit(T, mu, get(orders, :mu, 4))
    poly_kg = Polynomials.fit(T, kg, get(orders, :kg, 4))
    poly_cp = Polynomials.fit(T, cp, get(orders, :cp, 4))

    return (mu, kg, cp, poly_mu, poly_kg, poly_cp)
end

function plot_gas_properties(
        T, mu, kg, cp, poly_mu, poly_kg, poly_cp;
        every = 10
    )
    Ts = T[begin:every:end]

    f = Figure(size = (700, 800))

    ax1 = Axis(f[1, 1]; xgridstyle=:dash, ygridstyle=:dash)
    ax2 = Axis(f[2, 1]; xgridstyle=:dash, ygridstyle=:dash)
    ax3 = Axis(f[3, 1]; xgridstyle=:dash, ygridstyle=:dash)

    lines!(ax1, T, mu; color = :red)
    lines!(ax2, T, kg; color = :red)
    lines!(ax3, T, cp; color = :red)

    scatter!(ax1, Ts, poly_mu.(Ts); color = :black)
    scatter!(ax2, Ts, poly_kg.(Ts); color = :black)
    scatter!(ax3, Ts, poly_cp.(Ts); color = :black)

    ax1.ylabel = "Viscosity [Pa.s]"
    ax2.ylabel = "Conductivity [W/(m.K)]"
    ax3.ylabel = "Specific heat [J/(kg.K)]"
    ax3.xlabel = "Temperature [K]"

    return f, (ax1, ax2, ax3)
end

nothing; #hide
```

For illustration purposes we make use of a typical composition of air over a broad range of temperatures.

Finally we visualize the results; verification is performed against values proposed in the literature by ([[@Mujumdar2006i]]).

```julia; @example notebook
let
    orders = Dict(:mu => 4, :kg => 4, :cp => 4)

    T = LinRange(200, 3000, 200)

    X = Dict("O2" => 0.21, "H2O" => 0.006, "Ar" => 0.012, "CO2" => 0.04)
    X["N2"] = 1.0 - sum(values(X))

    gas = ct.Solution("gri30.yaml")
    sol = ct.SolutionArray(gas, shape=length(T))
    sol.TPX = pylist(T), ct.one_atm, pydict(X)

    rets = fit_gas_properties(sol; orders)

    μmuj = AirViscosityMujumdar2006()
    kmuj = AirHeatConductivityMujumdar2006()

    f, ax = plot_gas_properties(T, rets...)

    lines!(ax[1], T, μmuj.(T); color = :blue)
    lines!(ax[2], T, kmuj.(T); color = :blue)

    ax[1].yticks = 1.0e-05:3.0e-05:1.0e-04
    ax[2].yticks = 0.0:0.05:0.2
    ax[3].yticks = 900:100:1400

    xlims!(ax[1], 300, 3000)
    xlims!(ax[2], 300, 3000)
    xlims!(ax[3], 300, 3000)

    ylims!(ax[1], 1.0e-05, 10.0e-05)
    ylims!(ax[2], 0.0, 0.2)
    ylims!(ax[3], 900.0, 1400)

    f
end
```

Another typical application of this approach would be to evaluate the properties of combustion flue gases for a post-combustion simulation, as follows:

```julia; @example notebook
let
    fuel = "C2H2: 1.0"
    oxid = "O2: 1.0"
    nums = 100

    gas = ct.Solution("gri30.yaml")
    gas.set_equivalence_ratio(1.0, fuel=fuel, oxidizer=oxid, basis="mole")
    gas.equilibrate("HP")

    sol = ct.SolutionArray(gas, shape=(nums,))
    sol.TP = np.linspace(200, 3800, nums), ct.one_atm

    rets = fit_gas_properties(sol)

    for p in rets[end-2:end]
        println(repr(p))
    end

    T = pyconvert(Vector{Float64}, sol.T)

    f, ax = plot_gas_properties(T, rets...)
    f
end
```
