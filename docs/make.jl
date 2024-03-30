# -*- coding: utf-8 -*-
using Documenter
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
using DryConstants
using DryFlowsheet
using DryMaterials
using DryUtilities
using OpenFOAM

##############################################################################
# THE CONFIGURATION
##############################################################################

name = "Walter Dal'Maz Silva"
mail = "walter.dalmazsilva.manager@gmail.com"
user = "WallyTutor"
sitename = "WallyToolbox.jl"
repo = "https://github.com/$(user)/$(sitename)"
authors = "$(name) <$(mail)> and contributors"

modules = [
    DryConstants,
    # DryFlowsheet,
    # DryMaterials,
    DryUtilities,
    # OpenFOAM,
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
]

##############################################################################
# THE DOCUMENTATION
##############################################################################

makedocs(;
    sitename,
    authors,
    format,
    modules,
    plugins,
    pages,
    clean = true
)

deploydocs(; repo = repo, devbranch = "main")

##############################################################################
# THE END
##############################################################################