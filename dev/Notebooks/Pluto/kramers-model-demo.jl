### A Pluto.jl notebook ###
# v0.19.40

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

# ╔═╡ c69c7d6f-7b59-4a79-ba8b-04e1759fb280
begin
    @info "Loading tools..."
    import Pkg
    Pkg.activate(Base.current_project())

    using PlutoUI
    using WallyToolbox
    using DryGranular

    @info "Initializing parameters..."
    # Geometry
    Lᵣ = 13.715999999999998  # Kiln length [m]
    Dᵣ = 1.8897599999999999  # Kiln diameter [m]
    βᵣ = 2.3859440303888126  # Kiln slope [°]

    # Material
    γᵣ = 45.0                # Repose angle [°]
    dᵣ = 1.0                 # Particle/dam size [mm]

    # Process
    Φᵣ = 10.363965852671996  # Feed rate [m³/h]
    ωᵣ = 3.0300000000000002  # Rotation rate [rev/min]
end;

# ╔═╡ 36b09c42-8dad-4109-8f1f-0f34cd8041ff
md"""
# Kramers equation

*Interactive demo of Kramers equation solution.*
"""

# ╔═╡ d405e420-3da8-11ee-3729-cf2de54fc36a
md"""
Play with the sliders below to understand process parameters.

|      |      |
| ---: | :--- |
Length [m]         | $(@bind L Slider(5.0:0.5:50.0, default=Lᵣ, show_value=true))
Diameter [m]       | $(@bind D Slider(0.2:0.05:5.0, default=Dᵣ, show_value=true))
Slope [°]          | $(@bind β Slider(0.0:0.05:5.0, default=βᵣ, show_value=true))
Repose angle [°]   | $(@bind γ Slider(1.0:1.0:70.0, default=γᵣ, show_value=true))
Dam [mm]           | $(@bind d Slider(0.1:min(0.01,10D):800D, default=dᵣ, show_value=true))
Feed [m³/h]        | $(@bind Φ Slider(0.1:0.1:20.0, default=Φᵣ, show_value=true))
Rotation [rev/min] | $(@bind ω Slider(0.5:0.1:5.0, default=ωᵣ, show_value=true))
"""

# ╔═╡ 3c3651b2-e001-4338-a1fb-9f7881d2f007
try
    bed = RotaryKilnBedSolution(;
        model = SymbolicLinearKramersModel(),
        L = L,
        R = D / 2.0,
        Φ = Φ / 3600.0,
        ω = ω / 60.0,
        β = deg2rad(β),
        γ = deg2rad(γ),
        d = d / 1000.0,
    )
    plotlinearkramersmodel(bed, normz = true, normh = true)
catch e
    @error("Failed to solve Kramers equation: $(e)")
end

# ╔═╡ Cell order:
# ╟─36b09c42-8dad-4109-8f1f-0f34cd8041ff
# ╟─c69c7d6f-7b59-4a79-ba8b-04e1759fb280
# ╟─d405e420-3da8-11ee-3729-cf2de54fc36a
# ╟─3c3651b2-e001-4338-a1fb-9f7881d2f007
