### A Pluto.jl notebook ###
# v0.19.45

using Markdown
using InteractiveUtils

# ╔═╡ 9c925920-a59d-11ef-260d-1f53b08ff458
begin
	@info("Loading toolbox...")
    using Pkg
    Pkg.activate(ENV["WALLYROOT"])
    Pkg.instantiate()

    using WallyToolbox
    using PlutoUI: TableOfContents

	TableOfContents()
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

# ╔═╡ Cell order:
# ╟─ccbf51e6-7b46-432a-b8b8-9878c3625dac
# ╟─f54b9c0b-b13f-4fc9-b1fb-49195e2c0681
# ╟─37399b27-e621-409f-993f-34c5c3ef98f4
# ╟─9c925920-a59d-11ef-260d-1f53b08ff458
