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
using WallyToolbox.Documents

# These contain the actual implementation of "package".
using Cantera
using DryCombustion
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
    WallyToolbox,
    DryCombustion,
    DryFlowsheet,
    DryGranular,
    DryMaterials,
    DryTransport,
    DryUtilities,
    OpenFOAM,
    RadCalNet,
]

bibtex = joinpath(@__DIR__, "..", "data", "bibtex", "references.bib")

format = get_format(; latex, user, sitename)

##############################################################################
# THE PAGES
##############################################################################

pages = [
    "WallyToolbox" => [
        "Home" => "index.md",

        "WallyToolbox" => [
            "Modules/WallyToolbox/constants.md",
            "Modules/WallyToolbox/elements.md",
            "Modules/WallyToolbox/utilities.md",
            "Modules/WallyToolbox/Documentation.md",
        ],
        
        "Julia Modules" => [
            "DryCombustion" => "Modules/DryCombustion.md",
            "DryFlowsheet"  => "Modules/DryFlowsheet.md",
            "DryGranular"   => "Modules/DryGranular.md",
            "DryMaterials"  => "Modules/DryMaterials.md",
            "DryTransport"  => "Modules/DryTransport.md",
            "RadCalNet"     => "Modules/RadCalNet.md",
            "Cantera"       => "Modules/Cantera.md",
            "OpenFOAM"      => "Modules/OpenFOAM.md",
        ],

        "Software" =>[
            "Software/Elmer.md",
            "Software/OpenFOAM11.md",
            "Software/Basilisk.md",
            "Software/LAMMPS.md",
        ],

        "Computing" => [
            "Computing/01-Scientific-Computing.md",
            "Computing/02-General-Computing-Skills.md",
            "Computing/03-Programming-Languages.md",
            "Computing/04-Geometry-and-Preprocessing.md",
            "Computing/05-Postprocessing.md",
            "Computing/06-Domain-Specific-Software.md",
        ],

        "Science" => [
            "Theoretical Physics"   => "Science/01-Theoretical-Physics.md",
            "Computational Physics" => "Science/02-Computational-Physics.md",
            "Continuum Mechanics"   => "Science/04-Continuum-Mechanics.md",
            "Machine Learning"      => "Science/05-Machine-Learning.md",
            "Porous Solids"         => "Science/08-Conductivity-Porous-Solids.md",
        ],

        "Notebooks"         => [
            "Notebooks/01-Composite-Conduction.md",
            "Notebooks/02-Part-Radiation-Heating.md",
            "Notebooks/03-Plug-Flow-Reactor-1.md",
            "Notebooks/07-Air-Properties.md",
            "Notebooks/08-Kramers-Model-Validation.md",
            "Notebooks/A1-Julia-para-Cientistas.md",
            "Notebooks/A2-Ciencia-Colaborativa-e-Julia.md",
        ],

        "References" => "References/index.md",
        # "Table of Contents" => "toc.md",
    ],

]

# XXX: only files that properly execute in the current environment are
# added here: some error handling is still required in converter.
nblist = map(n->splitext(n)[1], [
    "dsc-tga-kaolinite.jl",
    "dsc-tga-model-demo.jl",
    "kramers-model-demo.jl",
    "process-balances.jl",
])

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

ppath = joinpath(wpath, "Notebooks", "Pluto")
convert_pluto(nblist; root = ppath, force = false)

##############################################################################
# THE DOCUMENTATION
##############################################################################

for m in modules
    mod = Symbol(m)
    setdocmeta!(m, :DocTestSetup, :(using $mod); warn = true, recursive = true)
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