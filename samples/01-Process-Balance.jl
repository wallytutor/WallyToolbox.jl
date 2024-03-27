### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ aa8086be-ec51-11ee-2ca0-933674507b58
begin
	@info "Loading packages..."
	push!(LOAD_PATH, joinpath(@__DIR__, ".."))
	using WallyToolbox

	using DryConstants: GAS_CONSTANT, P_REF, T_REF
	using DryMaterials: PureWater, PureAir, PureMineral
	using DryFlowsheet: MaterialStream, EnergyStream
end

# ╔═╡ 299a3f06-5893-4b3d-beb8-c9770b0430f1
# methods(Base.:+)

# ╔═╡ e3579a9b-1d01-4959-b03e-de5cbcd2a291
EnergyStream(10) + EnergyStream(30)

# ╔═╡ Cell order:
# ╠═aa8086be-ec51-11ee-2ca0-933674507b58
# ╠═299a3f06-5893-4b3d-beb8-c9770b0430f1
# ╠═e3579a9b-1d01-4959-b03e-de5cbcd2a291
