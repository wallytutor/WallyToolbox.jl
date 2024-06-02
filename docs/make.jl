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
    "WallyToolbox" => [
        "Home" => "index.md",

        "Julia Modules" => [
            "DryCombustion" => "Modules/DryCombustion.md",
            "DryFlowsheet"  => "Modules/DryFlowsheet.md",
            "DryGranular"   => "Modules/DryGranular.md",
            "DryMaterials"  => "Modules/DryMaterials.md",
            "DryTransport"  => "Modules/DryTransport.md",
            "RadCalNet"     => "Modules/RadCalNet.md",
            "Cantera"       => "Modules/Cantera.md",
            "OpenFOAM"      => "Modules/OpenFOAM.md",
            "Helpers"       => "Modules/helpers.md"
        ],

        "Scientific Computing" => [
            "Scientific Computing/index.md",
            "Scientific Computing/OpenFOAM11.md",
            "Scientific Computing/Elmer-Multiphysics.md",
            "Scientific Computing/Elmer-Documentation.md",
            "Scientific Computing/Basilisk.md",
            "Scientific Computing/LAMMPS.md",
            "Scientific Computing/PINNs.md",
            "Scientific Computing/General-Computing-Skills.md",
        ],

        "Transport Phenomena" => [
            "Transport Phenomena/01-Transport-phenomena-foundations.md",
            "Transport Phenomena/02-Applications-to-mass-and-heat-transfer.md",
            "Transport Phenomena/03-Applications-to-fluid-mechanics.md",
            "Transport Phenomena/A2-Dimensionless-groups.md",
            "Transport Phenomena/A4-Finite-Volume-Diffusion.md",
            # "Transport Phenomena/A1-Mathematical-background.md",
            # "Transport Phenomena/A3-Thermodynamics-Concepts.md",
            # "Transport Phenomena/B1-Conductivity-Porous-Solids.md"
        ],

        "Notebooks"         => [
            "Notebooks/01-Composite-Conduction.md",
            "Notebooks/02-Part-Radiation-Heating.md",
            "Notebooks/A1-Julia-para-Cientistas.md",
        ],

        "References"        => "References/index.md",
        # "Table of Contents" => "toc.md",
    ],

]

##############################################################################
# PREPROCESS ALL
##############################################################################

"Custom formatting of references with links (project-specific)."
function formatcitations(text, rhpath)
    oldgroup = r"\(\[\[@(?<named>((.|\n)*?))\]\]\)"
    link = "[\\g<named>]($(rhpath)/References/@\\g<named>.md)"
    scites = SubstitutionString("$(link) [\\g<named>](@cite)")
    return replace(text, oldgroup => scites)
end

function formatter(text, rhpath)
    text = formatnotecells(text)
    text = formatequations(text)
    text = formatcitations(text, rhpath)
    return text
end

# include("formatter.jl")

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