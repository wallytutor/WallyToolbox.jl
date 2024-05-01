# Kramers' model

```@meta
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/DryGranular/kramers.md"
```

```@setup kramers
using CairoMakie
using CSV
using DataFrames
using Latexify
using Printf
using DryGranular

"Partial data from Kramers (1952) Table 3"
const DATA_TABLE3 = """\
ρ,γ,tan(β),n,ṁ,prod_dimless,η̄ᵣ,hold_real
1480.0,36.0,0.0094,0.059,5.15e-03,18.3,0.111,8.10
1480.0,36.0,0.0094,0.090,2.68e-03,6.25,0.054,5.00
1480.0,36.0,0.0094,0.195,1.32e-02,14.2,0.088,7.75
1480.0,36.0,0.0094,0.232,7.24e-03,6.55,0.043,3.85
1480.0,36.0,0.0100,0.040,6.38e-03,29.7,0.169,13.3
1480.0,36.0,0.0100,0.040,5.00e-03,23.2,0.144,11.2
1480.0,36.0,0.0100,0.069,9.20e-03,24.8,0.150,10.6
1480.0,36.0,0.0100,0.069,6.53e-03,17.6,0.113,8.50
1480.0,36.0,0.0100,0.106,1.50e-02,27.8,0.162,12.2
1480.0,36.0,0.0100,0.159,1.20e-02,14.0,0.092,7.49
1480.0,36.0,0.0100,0.238,1.55e-02,12.1,0.083,7.48
1480.0,36.0,0.0100,0.238,1.19e-02,9.22,0.068,6.13
"""

"Compares approximate analytical to numerical solution."
function solvekiln(; L, D, Φ, ω, β, γ, d, show = true)
    model = RotaryKilnBedSolution(;
        model = SymbolicLinearKramersModel(),
        L     = L,
        R     = D / 2.0,
        Φ     = Φ / 3600.0,
        ω     = ω / 60.0,
        β     = deg2rad(β),
        γ     = deg2rad(γ),
        d     = d / 1000.0
    )

    optim = kramersnlapprox(;
        z = model.z,
        R = D / 2.0,
        Φ = Φ / 3600.0,
        ω = ω / 60.0,
        β = deg2rad(β),
        γ = deg2rad(γ),
        d = d / 1000.0
    )

    f = nothing
    ax = nothing

    if show
        f = Figure()
        ax = Axis(f[1, 1])

        lines!(ax, 100model.z/L, 100model.h, linewidth = 3, label = "Numerical")
        lines!(ax, 100optim.z/L, 100optim.h, linewidth = 3, label = "Analytical")

        a = @sprintf("%.1f", model.ηₘ)
        b = @sprintf("%.1f", optim.ηₘ)
        title = "Loading: $(a)% (numerical) | $(b)% (analytical)"

        ax.title = title
        ax.xlabel = "Coordinate [%]"
        ax.ylabel = "Bed height [cm]"
        ax.xticks = 0.0:20.0:100.0
        xlims!(ax, extrema(ax.xticks.val))
    end

    return model, optim, f, ax
end

"Reference case for alumina kiln testing."
function aluminakiln(ṁ, ω; show = false)
    # Density of bed [kg/m³]
    ρ = 800.0
    L = 34.0
    D = 1.5
    β = atan(0.025)

    model, optim, f, ax = solvekiln(
        L = L,
        D = D,
        Φ = (1000// 24) * ṁ / ρ,
        ω = ω,
        β = rad2deg(β),
        γ = 33.0,
        d = 0.050,
        show = show
    )

    τₚ = perrayresidence(L, ω, D, β)

    return model, optim, f, ax, τₚ
end

"Run `aluminakiln` against some known conditions."
function scanaluminakiln()
    ṁlist = [33.6, 43.2]
    ωlist = [0.85, 1.20]

    df = DataFrame(
        ṁ = Float64[],
        ω = Float64[],
        η̄ = Float64[],
        τᵢ = Float64[],
        τₚ = Float64[]
    )

    for ṁ ∈ ṁlist, ω ∈ ωlist
        model, _, _, _, τ = aluminakiln(ṁ, ω, show = false)
        η̄ = round(model.ηₘ, digits = 0)
        τᵢ = round(model.τ / 60.0, digits = 0)
        τₚ = round(τ, digits = 0)
        push!(df, [ṁ ω η̄ τᵢ τₚ])
    end

    return df
end

let
    # @info("Solution of reference case")

    in1_to_m1(v) = 0.0254 * v
    ft1_to_m1(v) = in1_to_m1(12.0) * v
    ft3_to_m3(v) = ft1_to_m1(1.0)^3 * v

    # Kiln length [m]
    L = ft1_to_m1(45.0)

    # Kiln diameter [m]
    D = 2 * ft1_to_m1(3.1)

    # Volume flow rate [m³/h]
    Φ = ft3_to_m3(6.1) * 60

    # Rotation rate (+0.0005) [rev/min]
    ω = 0.0505 * 60.0

    # Kiln slope (0.5in/ft) [°]
    β = rad2deg(atan(0.5 / 12))

    # Repose angle [°]
    γ = 45.0

    # Particle size [mm]
    d = 0.050

    # Conversions to match model inputs.
    R = D / 2.0
    Φ = Φ / 3600.0
    ω = ω / 60.0
    β = deg2rad(β)
    γ = deg2rad(γ)
    d = d / 1000.0

    # Create problem container.
    kramers = RotaryKilnBedSolution(;
        model = SymbolicLinearKramersModel(),
        L     = L,
        R     = R,
        Φ     = Φ,
        ω     = ω,
        β     = β,
        γ     = γ,
        d     = d
    )

    optim = kramersnlapprox(;
        z = kramers.z,
        R = R,
        Φ = Φ,
        ω = ω,
        β = β,
        γ = γ,
        d = d
    )

    global kramers_NΦ = dimlessNΦ(R, β, ω, Φ, γ)
    global kramers_Nₖ = dimlessNₖ(L, R, β, γ)
    global kramers_η̄ₛ = sullivansηₘ(R, β, ω, Φ, γ)
    global kramers_ref = kramers
    global optim_ref = optim

    global RESULTS_TABLE = DataFrame(
        Quantity  = [
            "NΦ",
            "Nₖ",
            "η̄ᵣ",
            "η̄ᵢ",
        ],
        Reference = [
            "1.15",
            "1.17",
            "5.65",
            @sprintf("%.2f", optim_ref.ηₘ)
        ],
        Computed  = [
            @sprintf("%.2f", kramers_NΦ),
            @sprintf("%.2f", kramers_Nₖ),
            @sprintf("%.2f", kramers_η̄ₛ),
            @sprintf("%.2f", kramers_ref.ηₘ)
        ]
    )
end

const TABLE3 = let
    # @info("Verification of *Table 3*")

    Dₖ = 0.197
    Lₖ = 1.780
    dₖ = 0.0012

    table3 = DataFrame(CSV.File(IOBuffer(DATA_TABLE3)))
    table3[!, "η̄ᵢ"] = zeros(length(table3[!, "η̄ᵣ"]))
    table3[!, "η̄ᵣ"] *= 100

    model = SymbolicLinearKramersModel()

    for (i, row) in enumerate(eachrow(table3))
        Φ = 3600.0 * row["ṁ"] / row["ρ"]
        ω = row["n"] * 60.0
        β = rad2deg(atan(row["tan(β)"]))
        γ = row["γ"]

        kramers = RotaryKilnBedSolution(;
            model = model,
            L     = Lₖ,
            R     = Dₖ / 2.0,
            Φ     = Φ / 3600.0,
            ω     = ω / 60.0,
            β     = deg2rad(β),
            γ     = deg2rad(γ),
            d     = dₖ / 1000.0
        )

        table3[i, "η̄ᵢ"] = round(kramers.ηₘ, digits = 1)
    end

    exclude = ["ρ", "γ", "prod_dimless", "hold_real"]
    select(table3, Not(exclude))
end

const DIMLESSPLOT = let
    @info("Dimensionless profiles solution")

    ρ = 1480.0
    L = 20.0
    D = 0.197
    Φ = 5.15e-03 / ρ * 3600
    ω = 0.059 * 60
    β = rad2deg(atan(0.0094))
    γ = 36.0

    # Conversions to match model inputs.
    R = D / 2.0
    Φ = Φ / 3600.0
    ω = ω / 60.0
    β = deg2rad(β)
    γ = deg2rad(γ)

    # Things held constant in loop.
    NΦ = dimlessNΦ(R, β, ω, Φ, γ)
    Nₖ = dimlessNₖ(L, R, β, γ)
    model = SymbolicLinearKramersModel()

    f = Figure()
    ax = Axis(f[1, 1])

    for d in [0.05, 0.10, 0.15, 0.193, 0.25]
        kramers = RotaryKilnBedSolution(;
            model = model,
            L     = L,
            R     = R,
            Φ     = Φ,
            ω     = ω,
            β     = β,
            γ     = γ,
            d     = d * R * NΦ
        )

        # Dimensionless axes.
        z = kramers.z
        h = kramers.h / (R * NΦ)
        z = @. (L - z) / L * 1 / (NΦ * Nₖ)
        z = @. z[1] - z

        label = @sprintf("%.3f", d)
        lines!(ax, z, h; linewidth = 2, label = label)
    end

    ax.title = "Dimensionless loading curves"
    ax.xlabel = "Coordinate"
    ax.ylabel = "Bed height"
    ax.xticks.val = 0.0:0.1:0.5
    ax.yticks.val = 0.05:0.05:0.25
    xlims!(ax, extrema(ax.xticks.val))
    ylims!(ax, extrema(ax.yticks.val))
    axislegend(ax; position = :rb)

    f
end
```

## Sample reference case

Here we make use of the current implementation to check if it correctly approximates the last example provided in reference paper from [[@Kramers1952]]. To minimize rounding errors causes by unit conversions, we provide the required functions to convert from imperial to international system in the solution process.

The next table summarizes the results. It is seen that the dimensionless numbers are well approximated. It must be emphasized that the reference estimates η̄ᵣ by a graphical method -- it was 1952 -- and the current value is considered a good enough approximation. Additionally, the equation was not integrated numerically as done here, but engineering relationships were used in the approximation. That said, the proper loading to be considered in our days is η̄ᵢ.

```@example kramers
mdtable(RESULTS_TABLE, latex=false) # hide
```

**Note:** the last value in column `Reference` above is not provided in Kramers' paper but computed from the approximate analytical solution provided by the authors. As we see here, it may get >20% error under some circumstances.

## Verification of *Table 3*

In the next cell we provide the kiln dimensions used by Kramers (1952) to experimentally validate the model. Some data from their Tab. 3 is then loaded and all rows are simulated with current model. Fractional hold-up seems to be well correlated at least to a few percent of the reference value.

```@example kramers
mdtable(TABLE3, latex=false) # hide
```

## Dimensionless profiles

Next step in validation is to check profiles in dimensionless format, as done by Kramers in their Fig. 3. Notice that here we used the numerical integration curves instead of the analytical approximation of profiles, so reproduction and consequences of results are not exactly the same.

```@example kramers
DIMLESSPLOT # hide
```

## Comparison with analytical

The final step in model validation is to compare the approximate analytical solution proposed by Kramers and the results of numerical integration. It is worth mentioning that numerical integration remains the recommended method because one does not need to verify the ranges of validity of analytical approximation for every use case.

```@example kramers
let                                    # hide
    _, _, f, ax = solvekiln(           # hide
        L = 10.0,                      # hide
        D = 1.0,                       # hide
        Φ = 1.0,                       # hide
        ω = 1.0,                       # hide
        β = 3.0,                       # hide
        γ = 45.0,                      # hide
        d = 0.001                      # hide
    )                                  # hide
                                       # hide
    ax.yticks = 0.0:4.0:20.0           # hide
    ylims!(ax, extrema(ax.yticks.val)) # hide
    f                                  # hide
end                                    # hide
```

## Industrial cases

The following illustrates a practical use case of the model. Next we scan a parameter space to confirm once again the model suitability as an alternative to analytical engineering estimations as per Peray's notebook.

```@example kramers
let                                                 # hide
    ṁ = 33.6                                        # hide
    ω = 0.85                                        # hide
    _, _, f, ax, _ = aluminakiln(ṁ, ω, show = true) # hide
    ax.yticks = 0.0:6.0:30.0                        # hide
    ylims!(ax, extrema(ax.yticks.val))              # hide
    f                                               # hide
end                                                 # hide
```

The following table confirms the expected values as per Peray.

```@example kramers
mdtable(scanaluminakiln(), latex=false) # hide
```
