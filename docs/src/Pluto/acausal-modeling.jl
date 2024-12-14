### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ 9c925920-a59d-11ef-260d-1f53b08ff458
begin
    @info("Initializing toolbox...")
    using Pkg
    
    open("pluto_init.log", "w") do logs
        Pkg.activate(ENV["WALLYROOT"]; io=logs)
        Pkg.instantiate(; io=logs)
    end

    push!(LOAD_PATH, @__DIR__)

    using PlutoLinks
    using PlutoUI: TableOfContents
        
    TableOfContents()
end

# ╔═╡ 66c5df79-aa9e-4e3b-aa22-94b85c1328a7
begin
    @info("Local toolbox...")
    @revise using WallyToolbox
end

# ╔═╡ ccbf51e6-7b46-432a-b8b8-9878c3625dac
md"""
# New notebook
"""

# ╔═╡ f54b9c0b-b13f-4fc9-b1fb-49195e2c0681
@warn("DO NOT OVERWRITE THIS TEMPLATE > SAVE TO YOUR WORKING DIRECTORY!")

# ╔═╡ 37399b27-e621-409f-993f-34c5c3ef98f4
md"""
## Toolset
"""

# ╔═╡ a5749da6-9201-47cc-ab00-78474b1aceb3
begin
    @info("External toolbox...")
    # using DataFrames
end

# ╔═╡ Cell order:
# ╟─ccbf51e6-7b46-432a-b8b8-9878c3625dac
# ╟─f54b9c0b-b13f-4fc9-b1fb-49195e2c0681
# ╟─37399b27-e621-409f-993f-34c5c3ef98f4
# ╟─9c925920-a59d-11ef-260d-1f53b08ff458
# ╟─a5749da6-9201-47cc-ab00-78474b1aceb3
# ╟─66c5df79-aa9e-4e3b-aa22-94b85c1328a7
