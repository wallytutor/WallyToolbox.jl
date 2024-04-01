# -*- coding: utf-8 -*-
using Documenter
using Documenter.DocMeta: setdocmeta!
using DocumenterCitations

##############################################################################
# THE DOCUMENTED *PACKAGES*
##############################################################################

# XXX: I could not find a way that `dev` installs the dependencies of the 
# parent project, as it *LOGICALLY* should be the case. To be able to document
# the following I was forced to add the same dependencies in the project file
# docs/Project.toml, so when adding new dependencies to the parent, do not
# forget to add them here too!

# This comes first because it sources the modules.
using WallyToolbox

# These contain the actual implementation of "package".
using Cantera
using DryAbstract
using DryConstants
using DryFlowsheet
using DryGranular
using DryMaterials
using DryUtilities
using OpenFOAM
using RadCalNet

##############################################################################
# THE CONFIGURATION
##############################################################################

name = "Walter Dal'Maz Silva"
mail = "walter.dalmazsilva.manager@gmail.com"
user = "wallytutor"
sitename = "WallyToolbox.jl"
repo = "https://github.com/$(user)/$(sitename)"
authors = "$(name) <$(mail)> and contributors"

modules = [
    # Cantera,
    DryAbstract,
    DryConstants,
    DryFlowsheet,
    DryGranular,
    DryMaterials,
    DryUtilities,
    OpenFOAM,
    RadCalNet,
]

plugins  = [
    CitationBibliography(joinpath(@__DIR__, "src/references/database.bib"))
]

format = Documenter.HTML(;
    prettyurls = get(ENV, "CI", "false") == "true",
    canonical  = "https://$(user).github.io/$(sitename)",
    repolink   = repo,
    edit_link  = "main",
    assets     = String[],
)

# For local builds, needs to download tectonic.
# format = Documenter.LaTeX(;
#     platform = "tectonic",
#     tectonic = joinpath(@__DIR__, "tectonic.exe")
# )

##############################################################################
# THE PAGES
##############################################################################

pages = [
    "Home" => "index.md",

    "Dry Packages" => [
        "DryFlowsheet" => "DryFlowsheet/index.md",
        "DryGranular"  => "DryGranular/index.md",
        "DryMaterials" => "DryMaterials/index.md",
        "Helpers"      => "helpers.md"
    ],
    
    "Cantera"           => "Cantera/index.md",
    "OpenFOAM"          => "OpenFOAM/index.md",
    "RadCalNet"         => "RadCalNet/index.md",
    "Table of Contents" => "toc.md",
    "References"        => "references/index.md",
    "Teaching"          => [
        "Basilisk" => "Teaching/Basilisk/Basilisk.md",
    ],
]

##############################################################################
# THE DOCUMENTATION
##############################################################################

for m in modules
    setdocmeta!(m, :DocTestSetup, :(using m); warn = false, recursive = true)
end

makedocs(; sitename, authors, format, modules, plugins, pages, clean = true)

deploydocs(; repo = "github.com/$(user)/$(sitename).git")

##############################################################################
# THE END
##############################################################################