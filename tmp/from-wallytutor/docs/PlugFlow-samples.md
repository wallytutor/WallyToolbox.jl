# DryTooling.PlugFlow samples

```@contents
Pages = ["samples.md"]
Depth = 3
```

## Basic plug-flow reactors

### Simplified acetylene pyrolysis

```@setup graf2007
using CairoMakie
using LaTeXStrings
using DryTooling.FiniteVolumes
using DryTooling.Kinetics
using DryTooling.PlugFlow
using DryTooling: convertsccmtomassflow
using DryTooling: meanmolecularmass
using DryTooling: molefraction2massfraction
using DryTooling: massfraction2molefraction

function plotgraf2007(grid, X)
    """ Helper function for standard model results display. """
    f = Figure(resolution = (900, 900))

    f[1, 1] = GridLayout()
    f[2, 1] = GridLayout()
    f[3, 1] = GridLayout()

    ax1 = Axis(f[1, 1])
    ax2 = Axis(f[2, 1])
    ax3 = Axis(f[3, 1])

    linkxaxes!(ax1, ax2, ax3)

    lines!(ax1, 100grid.r, 100X[:, 1], label = L"\mathrm{C_2H_2}")
    lines!(ax2, 100grid.r, 100X[:, 2], label = L"\mathrm{H_2}")
    lines!(ax2, 100grid.r, 100X[:, 3], label = L"\mathrm{C_2H_4}")
    lines!(ax2, 100grid.r, 100X[:, 4], label = L"\mathrm{CH_4}")
    lines!(ax3, 100grid.r, 100X[:, 5], label = L"\mathrm{C_4H_4}")
    lines!(ax3, 100grid.r, 100X[:, 6], label = L"\mathrm{C_6H_6}")
    lines!(ax3, 100grid.r, 100X[:, 7], label = L"\mathrm{C(s)}")

    ax1.ylabel = "Mole percentage [%]"
    ax2.ylabel = "Mole percentage [%]"
    ax3.ylabel = "Mole percentage [%]"
    ax3.xlabel = "Coordinate [cm]"

    ax1.xticks = 0.0:10:100last(grid.r)
    ax2.xticks = 0.0:10:100last(grid.r)
    ax3.xticks = 0.0:10:100last(grid.r)

    xlims!(ax1, extrema(ax1.xticks.val))
    xlims!(ax2, extrema(ax1.xticks.val))
    xlims!(ax3, extrema(ax1.xticks.val))

    axislegend(ax1; position = :rt)
    axislegend(ax2; position = :lt)
    axislegend(ax3; position = :lt)

    return f
end
```

```@example graf2007
# Dimensions of reactor [m].
R = 0.014
L = 0.5

# Create a grid for the reactor.
grid = equidistantcellsgrid1D(L, 20)

# Cross-section of reactor [m²].
A = (π * R^2)

# Get mechanism with rates.
kin = Graf2007AcetyleneKinetics()

# Create reactor model to solve.
pfr = IsothermalSymbolicPlugFlowReactor(kin)

# Initial condition.
T = 1173.15
P = 5000.0
Y = let
    # Mole fraction of acetylene (1) in system.
    x1 = 0.36

    # Add acetylene impurities to initialization.
    # NOTE: in reference thesis it was assumed 98% purity and acetone
    # content of 1.8%, but that species is not available in Graf (2007).
    X = zeros(length(kin.W))
    X[1] = 0.998 * x1
    X[4] = 0.002 * x1
    X[end] = 1 - sum(X[1:end-1])

    # Convert to mass fractions for the model.
    molefraction2massfraction(X, kin.W)
end

# Compute mass flow rate.
M = meanmolecularmass(Y, kin.W)
ṁ = convertsccmtomassflow(222.0, 1000M)

# Integrate problem over domain.
sol = solve(pfr; z = grid.r, Y, T, P, ṁ, A, L)

# Get mole fractions for plotting.
X = map((y)->massfraction2molefraction(y, kin.W), sol.u)
X = mapreduce(permutedims, vcat, X)

fig = plotgraf2007(grid, X)
```
