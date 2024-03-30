# -*- coding: utf-8 -*-
using Documenter
using Documenter.DocMeta: setdocmeta!
using DocumenterCitations
using Pkg
using YAML

##############################################################################
# HELPERS
##############################################################################

"Path to *this* file in *this* directory."
this(f) = joinpath(@__DIR__, f)

"Copy backup of `Project.toml` to temporary file."
backuptoml()  = cp(this("Project.toml"), this("TMP.toml"),     force = true)

"Reverse temporary `Project.toml` backup. "
cleanuptoml() = cp(this("TMP.toml"),     this("Project.toml"), force = true)

"Temporarily add packages to development."
function devpkgs()
    backuptoml()
    for name in DRYTOOLING        Pkg.develop(path = this("../src/$(name).jl"))
    end
end

"Construct recursive pages tree."
function getpages(x)
    if isa(x["target"], Vector{Dict{Any, Any}})
        return x["name"] => getpages.(x["target"])
    end
    return x["name"] => x["target"]
end

##############################################################################
# PACKAGES BLOCK
##############################################################################

DRYTOOLING = [
    "DryToolingCore",
    "DryToolingGranular",
    "DryToolingKinetics",
    "DryToolingSimulation",
]

devpkgs()

using DryToolingCore
using DryToolingGranular
using DryToolingKinetics
using DryToolingSimulation

##############################################################################
# WORKFLOW
##############################################################################

modules = map(x->getfield(Main, Symbol(x)), DRYTOOLING)

for m in modules
    setdocmeta!(m, :DocTestSetup, :(using m); warn = false, recursive = true)
end

conf = YAML.load_file(this("make.yaml"))
repo  = "https://github.com/$(conf["user"])/$(conf["site"])"

formats = [
    Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical  = "https://$(conf["user"]).github.io/$(conf["site"])",
        repolink   = repo,
        edit_link  = "main",
        assets     = String[],
    ),
    Documenter.LaTeX(;
        platform = "tectonic",
        tectonic = "$(@__DIR__)/tectonic.exe"
    )
]

makedocs(;
    modules  = modules,
    format   = formats[1],
    clean    = true,
    sitename = conf["site"],
    authors  = "$(conf["name"]) <$(conf["mail"])> and contributors",
    repo     = "$(repo)/blob/{commit}{path}#{line}",
    pages    = map(getpages, conf["pages"]),
    plugins  = [
        CitationBibliography(this("src/references.bib"))
    ],
)

deploydocs(; repo = repo, devbranch = "main")

cleanuptoml()
