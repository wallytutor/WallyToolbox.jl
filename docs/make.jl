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

# This is not documented, but the helpers here.
using WallyDocuments

# These contain the actual implementation of "package".
using Cantera
using DryAbstract
using DryCombustion
using DryConstants
using DryElements
using DryFlowsheet
using DryGranular
using DryMaterials
using DryTransport
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
authors = "$(name) <$(mail)> and contributors"
clean = true
draft = false
latex = false

modules = [
    # Cantera,
    DryAbstract,
    DryCombustion,
    DryConstants,
    DryElements,
    DryFlowsheet,
    DryGranular,
    DryMaterials,
    DryTransport,
    DryUtilities,
    OpenFOAM,
    RadCalNet,
]

bibtex = joinpath(@__DIR__, "../data/bibtex/references.bib")

format = get_format(; latex, user, sitename)

##############################################################################
# THE PAGES
##############################################################################

pages = [
    "Home" => "index.md",

    "Dry Packages" => [
        "DryCombustion" => "DryCombustion/index.md",
        "DryFlowsheet"  => "DryFlowsheet/index.md",
        "DryGranular"   => "DryGranular/index.md",
        "DryMaterials"  => "DryMaterials/index.md",
        "DryTransport"  => "DryTransport/index.md",
        "Helpers"       => "helpers.md"
    ],
    
    "Cantera"           => "Cantera/index.md",
    "OpenFOAM"          => "OpenFOAM/index.md",
    "RadCalNet"         => "RadCalNet/index.md",
    "Table of Contents" => "toc.md",
    "References"        => "References/index.md",

    "Teaching"          => [
        "Machine Learning"    => "Teaching/Machine Learning/index.md",
        "Transport Phenomena" => "Teaching/Transport Phenomena/index.md",
        "Basilisk"            => "Teaching/Basilisk/Basilisk.md",
        "OpenFOAM"            => "Teaching/OpenFOAM/index.md",
    ],
]

##############################################################################
# PREPROCESS ALL
##############################################################################

spath = joinpath(@__DIR__, "src")
wpath = joinpath(@__DIR__, "tmp")
julianizeequations(; spath, wpath)

##############################################################################
# THE DOCUMENTATION
##############################################################################

for m in modules
    setdocmeta!(m, :DocTestSetup, :(using m); warn = false, recursive = true)
end

plugins  = [
    CitationBibliography(bibtex)
]

makedocs(; source = wpath,
           sitename, authors, format, modules, plugins, pages, clean, draft)

if "DEPLOY_DOCS" in keys(ENV) && hasproperty(format, :repolink)
    deploydocs(; repo = deployrepo(format))
end

##############################################################################
# THE END
##############################################################################