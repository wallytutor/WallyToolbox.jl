### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ 4c272615-47ee-4889-bf30-2ad43e536cd9
begin
	@info("Loading toolbox...")
    using Pkg
    Pkg.activate(ENV["WALLYROOT"])
    Pkg.instantiate()

    using WallyToolbox
    using PlutoUI: TableOfContents

	TableOfContents()
end

# ╔═╡ 9d15ec6c-04a7-4f5c-908b-310a774ff044
md"""
# Cantera for combustion
"""

# ╔═╡ 4e65f9e1-697d-4fc6-ad68-93391c89a13f


# ╔═╡ Cell order:
# ╟─9d15ec6c-04a7-4f5c-908b-310a774ff044
# ╠═4c272615-47ee-4889-bf30-2ad43e536cd9
# ╠═4e65f9e1-697d-4fc6-ad68-93391c89a13f
