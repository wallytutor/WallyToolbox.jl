# Kramers' model

```julia; @example notebook
using WallyToolbox
using DryGranular

using CairoMakie
using CSV
using DataFrames
using Latexify
using Printf
```

## Reference data

Below we provide a set of partial data from Kramers (1952) Table 3.

```julia; @example notebook
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
nothing; #hide
```

```julia; @example notebook
"Compares approximate analytical to numerical solution."#hide
function solvekiln(; L, D, Φ, ω, β, γ, d, show = true)#hide
    model = RotaryKilnBedSolution(;#hide
        model = SymbolicLinearKramersModel(),#hide
        L     = L,#hide
        R     = D / 2.0,#hide
        Φ     = Φ / 3600.0,#hide
        ω     = ω / 60.0,#hide
        β     = deg2rad(β),#hide
        γ     = deg2rad(γ),#hide
        d     = d / 1000.0#hide
    )#hide
#hide
    optim = kramersnlapprox(;#hide
        z = model.z,#hide
        R = D / 2.0,#hide
        Φ = Φ / 3600.0,#hide
        ω = ω / 60.0,#hide
        β = deg2rad(β),#hide
        γ = deg2rad(γ),#hide
        d = d / 1000.0#hide
    )#hide
#hide
    f = nothing#hide
    ax = nothing#hide
#hide
    if show#hide
        f = Figure()#hide
        ax = Axis(f[1, 1])#hide
#hide
        lines!(ax, 100model.z/L, 100model.h, linewidth = 3, label = "Numerical")#hide
        lines!(ax, 100optim.z/L, 100optim.h, linewidth = 3, label = "Analytical")#hide
#hide
        a = @sprintf("%.1f", model.ηₘ)#hide
        b = @sprintf("%.1f", optim.ηₘ)#hide
        title = "Loading: $(a)% (numerical) | $(b)% (analytical)"#hide
#hide
        ax.title = title#hide
        ax.xlabel = "Coordinate [%]"#hide
        ax.ylabel = "Bed height [cm]"#hide
        ax.xticks = 0.0:20.0:100.0#hide
        xlims!(ax, extrema(ax.xticks.val))#hide
    end#hide
#hide
    return model, optim, f, ax#hide
end#hide
nothing; # hide
```

```julia; @example notebook
"Reference case for alumina kiln testing."# hide
function aluminakiln(ṁ, ω; show = false)# hide
    # Density of bed [kg/m³]# hide
    ρ = 800.0# hide
    L = 34.0# hide
    D = 1.5# hide
    β = atan(0.025)# hide
# hide
    model, optim, f, ax = solvekiln(# hide
        L = L,# hide
        D = D,# hide
        Φ = (1000// 24) * ṁ / ρ,# hide
        ω = ω,# hide
        β = rad2deg(β),# hide
        γ = 33.0,# hide
        d = 0.050,# hide
        show = show# hide
    )# hide
# hide
    τₚ = perryresidence(L, ω, D, β)# hide
# hide
    return model, optim, f, ax, τₚ# hide
end# hide
nothing; # hide
```

```julia; @example notebook
"Run `aluminakiln` against some known conditions."# hide
function scanaluminakiln()# hide
    ṁlist = [33.6, 43.2]# hide
    ωlist = [0.85, 1.20]# hide
# hide
    df = DataFrame(# hide
        ṁ = Float64[],# hide
        ω = Float64[],# hide
        η̄ = Float64[],# hide
        τᵢ = Float64[],# hide
        τₚ = Float64[]# hide
    )# hide
# hide
    for ṁ ∈ ṁlist, ω ∈ ωlist# hide
        model, _, _, _, τ = aluminakiln(ṁ, ω, show = false)# hide
        η̄ = round(model.ηₘ, digits = 0)# hide
        τᵢ = round(model.τ / 60.0, digits = 0)# hide
        τₚ = round(τ, digits = 0)# hide
        push!(df, [ṁ ω η̄ τᵢ τₚ])# hide
    end# hide
# hide
    return df# hide
end# hide
nothing; # hide
```

```julia; @example notebook
in1_to_m1(v) = 0.0254 * v# hide
ft1_to_m1(v) = in1_to_m1(12.0) * v# hide
ft3_to_m3(v) = ft1_to_m1(1.0)^3 * v# hide
# hide
# Kiln length [m]# hide
L = ft1_to_m1(45.0)# hide
# hide
# Kiln diameter [m]# hide
D = 2 * ft1_to_m1(3.1)# hide
# hide
# Volume flow rate [m³/h]# hide
Φ = ft3_to_m3(6.1) * 60# hide
# hide
# Rotation rate (+0.0005) [rev/min]# hide
ω = 0.0505 * 60.0# hide
# hide
# Kiln slope (0.5in/ft) [°]# hide
β = rad2deg(atan(0.5 / 12))# hide
# hide
# Repose angle [°]# hide
γ = 45.0# hide
# hide
# Particle size [mm]# hide
d = 0.050# hide
# hide
# Conversions to match model inputs.# hide
R = D / 2.0# hide
Φ = Φ / 3600.0# hide
ω = ω / 60.0# hide
β = deg2rad(β)# hide
γ = deg2rad(γ)# hide
d = d / 1000.0# hide
# hide
# Create problem container.# hide
kramers = RotaryKilnBedSolution(;# hide
    model = SymbolicLinearKramersModel(),# hide
    L     = L,# hide
    R     = R,# hide
    Φ     = Φ,# hide
    ω     = ω,# hide
    β     = β,# hide
    γ     = γ,# hide
    d     = d# hide
)# hide
# hide
optim = kramersnlapprox(;# hide
    z = kramers.z,# hide
    R = R,# hide
    Φ = Φ,# hide
    ω = ω,# hide
    β = β,# hide
    γ = γ,# hide
    d = d# hide
)# hide
# hide
kramers_NΦ = dimlessNΦ(R, β, ω, Φ, γ)# hide
kramers_Nₖ = dimlessNₖ(L, R, β, γ)# hide
kramers_η̄ₛ = sullivansηₘ(R, β, ω, Φ, γ)# hide
kramers_ref = kramers# hide
optim_ref = optim# hide
nothing;# hide
```

## Sample reference case

Here we make use of the current implementation to check if it correctly approximates the last example provided in reference paper from [[@Kramers1952]]. To minimize rounding errors causes by unit conversions, we provide the required functions to convert from imperial to international system in the solution process.

The next table summarizes the results. It is seen that the dimensionless numbers are well approximated. It must be emphasized that the reference estimates η̄ᵣ by a graphical method -- it was 1952 -- and the current value is considered a good enough approximation. Additionally, the equation was not integrated numerically as done here, but engineering relationships were used in the approximation. That said, the proper loading to be considered in our days is η̄ᵢ.

```julia; @example notebook
DataFrame(# hide
    Quantity  = [# hide
        "NΦ",# hide
        "Nₖ",# hide
        "η̄ᵣ",# hide
        "η̄ᵢ",# hide
    ],# hide
    Reference = [# hide
        "1.15",# hide
        "1.17",# hide
        "5.65",# hide
        @sprintf("%.2f", optim_ref.ηₘ)# hide
    ],# hide
    Computed  = [# hide
        @sprintf("%.2f", kramers_NΦ),# hide
        @sprintf("%.2f", kramers_Nₖ),# hide
        @sprintf("%.2f", kramers_η̄ₛ),# hide
        @sprintf("%.2f", kramers_ref.ηₘ)# hide
    ]# hide
)# hide
```

**Note:** the last value in column `Reference` above is not provided in Kramers' paper but computed from the approximate analytical solution provided by the authors. As we see here, it may get >20% error under some circumstances.

## Verification of *Table 3*

In the next cell we provide the kiln dimensions used by Kramers (1952) to experimentally validate the model. Some data from their Tab. 3 is then loaded and all rows are simulated with current model. Fractional hold-up seems to be well correlated at least to a few percent of the reference value.

```julia; @example notebook
let# hide
    Dₖ = 0.197# hide
    Lₖ = 1.780# hide
    dₖ = 0.0012# hide
# hide
    table3 = DataFrame(CSV.File(IOBuffer(DATA_TABLE3)))# hide
    table3[!, "η̄ᵢ"] = zeros(length(table3[!, "η̄ᵣ"]))# hide
    table3[!, "η̄ᵣ"] *= 100# hide
# hide
    model = SymbolicLinearKramersModel()# hide
# hide
    for (i, row) in enumerate(eachrow(table3))# hide
        Φ = 3600.0 * row["ṁ"] / row["ρ"]# hide
        ω = row["n"] * 60.0# hide
        β = rad2deg(atan(row["tan(β)"]))# hide
        γ = row["γ"]# hide
# hide
        kramers = RotaryKilnBedSolution(;# hide
            model = model,# hide
            L     = Lₖ,# hide
            R     = Dₖ / 2.0,# hide
            Φ     = Φ / 3600.0,# hide
            ω     = ω / 60.0,# hide
            β     = deg2rad(β),# hide
            γ     = deg2rad(γ),# hide
            d     = dₖ / 1000.0# hide
        )# hide
# hide
        table3[i, "η̄ᵢ"] = round(kramers.ηₘ, digits = 1)# hide
    end# hide
# hide
    exclude = ["ρ", "γ", "prod_dimless", "hold_real"]# hide
    select(table3, Not(exclude))# hide
end# hide
```

## Dimensionless profiles

Next step in validation is to check profiles in dimensionless format, as done by Kramers in their Fig. 3. Notice that here we used the numerical integration curves instead of the analytical approximation of profiles, so reproduction and consequences of results are not exactly the same.

```julia; @example notebook
let# hide
    ρ = 1480.0# hide
    L = 20.0# hide
    D = 0.197# hide
    Φ = 5.15e-03 / ρ * 3600# hide
    ω = 0.059 * 60# hide
    β = rad2deg(atan(0.0094))# hide
    γ = 36.0# hide
# hide
    # Conversions to match model inputs.# hide
    R = D / 2.0# hide
    Φ = Φ / 3600.0# hide
    ω = ω / 60.0# hide
    β = deg2rad(β)# hide
    γ = deg2rad(γ)# hide
# hide
    # Things held constant in loop.# hide
    NΦ = dimlessNΦ(R, β, ω, Φ, γ)# hide
    Nₖ = dimlessNₖ(L, R, β, γ)# hide
    model = SymbolicLinearKramersModel()# hide
# hide
    f = Figure()# hide
    ax = Axis(f[1, 1])# hide
# hide
    for d in [0.05, 0.10, 0.15, 0.193, 0.25]# hide
        kramers = RotaryKilnBedSolution(;# hide
            model = model,# hide
            L     = L,# hide
            R     = R,# hide
            Φ     = Φ,# hide
            ω     = ω,# hide
            β     = β,# hide
            γ     = γ,# hide
            d     = d * R * NΦ# hide
        )# hide
# hide
        # Dimensionless axes.# hide
        z = kramers.z# hide
        h = kramers.h / (R * NΦ)# hide
        z = @. (L - z) / L * 1 / (NΦ * Nₖ)# hide
        z = @. z[1] - z# hide
# hide
        label = @sprintf("%.3f", d)# hide
        lines!(ax, z, h; linewidth = 2, label = label)# hide
    end# hide
# hide
    ax.title = "Dimensionless loading curves"# hide
    ax.xlabel = "Coordinate"# hide
    ax.ylabel = "Bed height"# hide
    ax.xticks.val = 0.0:0.1:0.5# hide
    ax.yticks.val = 0.05:0.05:0.25# hide
    xlims!(ax, extrema(ax.xticks.val))# hide
    ylims!(ax, extrema(ax.yticks.val))# hide
    axislegend(ax; position = :rb)# hide
# hide
    f# hide
end# hide
```

## Comparison with analytical

The final step in model validation is to compare the approximate analytical solution proposed by Kramers and the results of numerical integration. It is worth mentioning that numerical integration remains the recommended method because one does not need to verify the ranges of validity of analytical approximation for every use case.

```julia; @example notebook
let# hide
    _, _, f, ax = solvekiln(# hide
        L = 10.0,# hide
        D = 1.0,# hide
        Φ = 1.0,# hide
        ω = 1.0,# hide
        β = 3.0,# hide
        γ = 45.0,# hide
        d = 0.001# hide
    )# hide
# hide
    ax.yticks = 0.0:4.0:20.0# hide
    ylims!(ax, extrema(ax.yticks.val))# hide
    f# hide
end# hide
```

## Industrial cases

The following illustrates a practical use case of the model. Next we scan a parameter space to confirm once again the model suitability as an alternative to analytical engineering estimations as per Perry's .

```julia; @example notebook
let# hide
    ṁ = 33.6# hide
    ω = 0.85# hide
    _, _, f, ax, _ = aluminakiln(ṁ, ω, show = true)# hide
    ax.yticks = 0.0:6.0:30.0# hide
    ylims!(ax, extrema(ax.yticks.val))# hide
    f# hide
end# hide
```

The following table confirms the expected values as per Perry's handbook.

```julia; @example notebook
scanaluminakiln() # hide
```
