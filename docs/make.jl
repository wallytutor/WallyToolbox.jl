# -*- coding: utf-8 -*-
using Documenter
using Documenter.DocMeta: setdocmeta!
using DocumenterCitations
import PlutoStaticHTML

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
# DRAFT
##############################################################################

# "Generate documentation for notebooks."
# function docplutonotebooks(example_dir, notebooks;
#                            distributed = true, force = true)
#     notebookmd = [splitext(notebook)[1] * ".md" for notebook in notebooks]
#     output_format = PlutoStaticHTML.documenter_output

#     oopts = PlutoStaticHTML.OutputOptions(; append_build_context = false)
#     bopts = PlutoStaticHTML.BuildOptions(example_dir; output_format)

#     session = PlutoStaticHTML.Pluto.ServerSession()
#     session.options.server.disable_writing_notebook_files = true
#     session.options.server.show_file_system = false
#     session.options.server.launch_browser = false
#     session.options.server.dismiss_update_notification = true
#     session.options.evaluation.workspace_use_distributed = distributed

#     PlutoStaticHTML.build_notebooks(bopts, notebooks, oopts; session)

#     for nb in notebookmd
#         src = joinpath(example_dir, nb)
#         dst = joinpath(@__DIR__, "src/Notebooks", nb);
#         mv(src, dst; force)
#     end
# end

# docplutonotebooks(joinpath(@__DIR__, "..", "script"), [
#     "dsc-tga-kaolinite.jl",
# ])

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

    "RadCalNet"         => "RadCalNet/index.md",
    "Cantera"           => "Cantera/index.md",

    "OpenFOAM"          => [
        "Module Docs" => "OpenFOAM/index.md",
        "OpenFOAM 11" => "OpenFOAM/01-OpenFOAM11.md",
    ],    
    
    "Elmer"               => [
        "Elmer Multiphysics"         => "Elmer/00-Elmer-Multiphysics.md",
        "Preprocessing"              => "Elmer/01-Preprocessing.md"
        "Solution Mode"              => "Elmer/02-Solution-Mode.md",
        "Properties and Extensions"  => "Elmer/03-Properties-and-Extensions.md",
        "Postprocessing"             => "Elmer/04-Postprocessing.md",
        "Standard Input Format"      => "Elmer/A1-SIF-Specification.md",
        "MATC Language"              => "Elmer/A2-MATC-Language.md",
        "Fortran UDFs"               => "Elmer/A3-UDF-Specification.md",
        "Finite Element Method"      => "Elmer/C1-Finite-Element-Method.md",
    ],

    "Scientific Computing" => "Scientific Computing/index.md",
    "Transport Phenomena" => "Transport Phenomena/index.md",

    "Basilisk"            => "Basilisk/index.md",
    "References"        => "References/index.md",
    "Table of Contents" => "toc.md",

    # "Notebooks"         => [
    #     "Simulating DSC/TGA" => "Notebooks/dsc-tga-kaolinite.md"
    # ],
]

##############################################################################
# PREPROCESS ALL
##############################################################################

# TODO increase robustness of solution, especially getting new lines!
# If there are no new lines, then use simple double ticks.
# https://stackoverflow.com/questions/14182879
# https://tex.stackexchange.com/questions/621461

function formatter(text)
    function formatequations(text)
        newgroup = s"```math\n\g<named>\n```"
        oldgroup = r"\$\$(?<named>[^$]*)\$\$"
        return replace(text, oldgroup => newgroup)
    end

    function formatcitations(text)
        # TODO get this working:
        # path = replace("$(@__DIR__)/tmp/References", "\\" => "/", ":" => "")
        # path = "tmp/References"
        # link = "[\\g<named>]($(path)/@\\g<named>.md)"
        # newgroup = SubstitutionString("$(link) [\\g<named>](@cite)")
        newgroup = s"(\g<named>)[\g<named>](@cite)"
        oldgroup = r"\(\[\[@(?<named>[A-Za-z0-9]+)\]\]\)"
        return replace(text, oldgroup => newgroup)
    end

    text = formatequations(text)
    text = formatcitations(text)

    return text
end

spath = joinpath(@__DIR__, "src")
wpath = joinpath(@__DIR__, "tmp")
julianizemarkdown(; formatter, spath, wpath)

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