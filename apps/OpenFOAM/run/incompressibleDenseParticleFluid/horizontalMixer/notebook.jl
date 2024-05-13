### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ 8273a6d4-bdb3-11ee-045f-5b85676020b6
begin
	@info "Loading required external tools"
	
	# Install locally parent OpenFOAM.jl and local modules.
	push!(LOAD_PATH, joinpath(@__DIR__, "../../.."))

	using OpenFOAM
	using DelimitedFiles
	using LightXML
	using NaturalSort
	using PlutoUI
	using Statistics
end

# ╔═╡ 03271849-3097-42f4-9167-6ef040d162bd
md"""
# Cases horizontalMixer

$(TableOfContents())
"""

# ╔═╡ 4f0d5f0e-a19a-40d4-8534-4446fa0b32e1
md"""
## Cases setup

In the *conceptual* phase of the study we build cases with a single particle per parcel and with multiple particles per cell. A discussion is provided in [this article](https://wallytutor.github.io/medium-articles/notes/OpenFOAM/Particle-Flows/).

Below we compute the entries required to set up the patch injection model.
"""

# ╔═╡ 1959b148-1242-44bd-a8be-92a1664a49ac
md"""
To check the correctness we test the function with conditions from tutorial case `injectionChannel` provided with OpenFOAM 11, retrieving the same number of parcels.
"""

# ╔═╡ a91dd7d3-757a-4210-bcdf-5ba33592a662
md"""
## Processing outlet flow
"""

# ╔═╡ 81ecf46e-dd55-4dd5-9b85-4f08a6985697
md"""
## ParaView state file
"""

# ╔═╡ a98cadf1-380c-4045-917d-75daf65e97ef
md"""
## Shared conditions
"""

# ╔═╡ f7843ef0-9ada-42ba-a185-4174b1961f9b
"Mass flow rate per meter of mixer [kg/s]"
const mdot::Float64 = 0.1

# ╔═╡ 95cf5ceb-e02e-4496-9ed3-ff0caf3f7f45
"Extrusion depth of generated 2D grid [m]"
const depth2d::Float64 = 0.01

# ╔═╡ 84484cd4-6e4c-46bc-a258-65e9c917d4aa
"Particle material specific mass [kg/m³]"
const rhop::Float64 = 2500.

# ╔═╡ 3560cf08-811e-420c-82a2-00109698268c
md"""
## Tools
"""

# ╔═╡ 1157123b-15d2-46bb-852e-5adb76a576cd
"""
    parcelstoinject2d(;
        mdot::Float64,
        rhop::Float64,
        diam::Float64,
        nParticles::Int64 = 1,
        depth2d::Float64 = 0.01
    )

Computes the flow rate of parcels for a given mean particle size and number of
particles per parcels. This is inteded as a helper to create a `patchInjection`
element in the `injectionModels` of `cloudProperties` file.
"""
function parcelstoinject2d(;
        mdot::Float64,
        rhop::Float64,
        diam::Float64,
        nParticles::Int64 = 1,
        depth2d::Float64 = 0.01
    )
    # Total number of particles per second corresponding to `mdot`.
    np = asint(mdot / spheremass(rhop, diam))

    # Number of particles to inject in 2D grid of depth `depth2d`.
    nd = asint(np * depth2d)

    # Group `nd` particles in parcels of size `nParticles`.
    parcelsPerSecond = asint(nd / nParticles)

    @info """

    - 3D values

        Target mass flow rate ................ $(mdot)
        Corresponding particles per second ... $(np)

    - 2D values

        Target mass flow rate ................ $(mdot * depth2d)
        Corresponding particles per second ... $(nd)

    - Values to fill in cloudProperties injection

        Total parcels .................. $(parcelsPerSecond)
        Parcel size .................... $(nParticles)
    """

    return nothing
end

# ╔═╡ 8d75b81d-531e-428d-af9f-643c56f4be5c
parcelstoinject2d(; mdot, rhop, diam = 0.0001, depth2d)

# ╔═╡ 0bf44e98-34bd-4e80-9df1-daece2844d4e
parcelstoinject2d(; mdot, rhop, diam = 0.0001, nParticles = 100, depth2d)

# ╔═╡ 56e6a8fa-39bb-491f-9fa8-36c8213f23c8
parcelstoinject2d(; mdot = 0.2, rhop = 1000.0, diam = 650e-06, depth2d = 1.0)

# ╔═╡ d99cd011-570a-4719-be00-19c729b50bb3
"Process cloud post-processing file to tabular format."
function cleancloudpost(src; dst = "proc.tmp")
    # All substitutions to make in file.
    subs = ["# " => "", "(" => "", ")" => "", " " => "\t"]

    # Array to store processed rows.
    rows = []

    # Read raw OpenFOAM post-processing file.
    open(src, "r") do fp
        for line in readlines(fp)
            for (k, v) in subs
                line = replace(line, k => v)
            end
            push!(rows, line)
        end
    end

    # Dump results for processing.
    open(dst, "w") do fp
        write(fp, join(rows, "\n"))
    end
end

# ╔═╡ dfc4add0-263d-4e65-ac0f-6208522f508a
begin
	# TODO improve these
	
	function varindex(head, varname)
	    return findfirst(name -> name == varname, head).I[2]
	end
	
	function varname(head, index)
	    return head[index]
	end
end

# ╔═╡ e7894205-cf08-4566-a9d9-f74788fa2962
let
	case  = "004"
	time  = "2.00000000e+00"
	ppost = "patchPostProcessing1"
	patch = "outlet"
	
	src = "$(case)/postProcessing/lagrangian/cloud"
	src = "$(src)/$(ppost)/$(time)/$(patch).post"

	dst = "proc.tmp"
	
	cleancloudpost(src; dst)
	
	data, head = readdlm(dst; header = true)
	
	age = varindex(head, "age")
	dia = varindex(head, "d")
	
	# mean(data[:, dia])
	mean(data[:, age]), std(data[:, age])
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DelimitedFiles = "8bb1440f-4735-579b-a4ab-409b98df4dab"
LightXML = "9c8b4983-aa76-5018-a973-4c85ecc9e179"
NaturalSort = "c020b1a1-e9b0-503a-9c33-f039bfc54a85"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
DelimitedFiles = "~1.9.1"
LightXML = "~0.9.1"
NaturalSort = "~1.0.0"
PlutoUI = "~0.7.55"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
manifest_format = "2.0"
project_hash = "549f2a4e22407239508cabb62956ff0de7c927ed"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "c278dfab760520b8bb7e9511b968bf4ba38b7acc"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "8b72179abc660bfab5e28472e019392b97d0985c"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.LightXML]]
deps = ["Libdl", "XML2_jll"]
git-tree-sha1 = "3a994404d3f6709610701c7dabfc03fed87a81f8"
uuid = "9c8b4983-aa76-5018-a973-4c85ecc9e179"
version = "0.9.1"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaturalSort]]
git-tree-sha1 = "eda490d06b9f7c00752ee81cfa451efe55521e21"
uuid = "c020b1a1-e9b0-503a-9c33-f039bfc54a85"
version = "1.0.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "68723afdb616445c6caaef6255067a8339f91325"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.55"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "801cbe47eae69adc50f36c3caec4758d2650741b"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.2+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─03271849-3097-42f4-9167-6ef040d162bd
# ╟─4f0d5f0e-a19a-40d4-8534-4446fa0b32e1
# ╟─8d75b81d-531e-428d-af9f-643c56f4be5c
# ╟─0bf44e98-34bd-4e80-9df1-daece2844d4e
# ╟─1959b148-1242-44bd-a8be-92a1664a49ac
# ╟─56e6a8fa-39bb-491f-9fa8-36c8213f23c8
# ╟─a91dd7d3-757a-4210-bcdf-5ba33592a662
# ╟─e7894205-cf08-4566-a9d9-f74788fa2962
# ╟─81ecf46e-dd55-4dd5-9b85-4f08a6985697
# ╟─a98cadf1-380c-4045-917d-75daf65e97ef
# ╟─f7843ef0-9ada-42ba-a185-4174b1961f9b
# ╟─95cf5ceb-e02e-4496-9ed3-ff0caf3f7f45
# ╟─84484cd4-6e4c-46bc-a258-65e9c917d4aa
# ╟─3560cf08-811e-420c-82a2-00109698268c
# ╟─8273a6d4-bdb3-11ee-045f-5b85676020b6
# ╟─1157123b-15d2-46bb-852e-5adb76a576cd
# ╟─d99cd011-570a-4719-be00-19c729b50bb3
# ╟─dfc4add0-263d-4e65-ac0f-6208522f508a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
