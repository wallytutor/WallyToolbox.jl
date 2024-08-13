##############################################################################
# PACKAGE DOCUMENTATION
##############################################################################

using Revise
using Documenter
using Documenter.DocMeta: setdocmeta!
using DocumenterCitations

##############################################################################
# THE DOCUMENTED *PACKAGES*
#
# XXX: I could not find a way that `dev` installs the dependencies of the
# parent project, as it *LOGICALLY* should be the case. To be able to document
# the following I was forced to add the same dependencies in the project file
# docs/Project.toml, so when adding new dependencies to the parent, do not
# forget to add them here too!
##############################################################################

using WallyToolbox
using WallyToolbox.Documents
using Cantera
using OpenFOAM
using RadCalNet

##############################################################################
# FUNCTIONS
##############################################################################

"Custom formatting of references with links (project-specific)."
function formatcitations(text, rhpath)
    oldgroup = r"\(\[\[@(?<named>((.|\n)*?))\]\]\)"
    link = "[\\g<named>]($(rhpath)/References/@\\g<named>.md)"
    scites = SubstitutionString("$(link) [\\g<named>](@cite)")
    return replace(text, oldgroup => scites)
end

"Formatting workflow for all markdown files in documentation."
function formatter(text, rhpath)
    text = formatnotecells(text)
    text = formatequations(text)
    text = formatembimages(text)
    text = formatembvideos(text)
    text = formatcitations(text, rhpath)
    return text
end

"Managed workflow for Pluto notebooks conversion."
function workflow_pluto(notebooks, root; force = false)
    try
        convert_pluto(map(n->splitext(n)[1], notebooks); root, force)
    catch err
        @error("Failed converting notebooks:\n$(err)")
    end
end

"Managed workflow for Documenter.jl documentation generation."
function workflow_main(modules, pages, source, authors, format, sitename, plugins)
    try
        makedocs(; source, sitename, authors, plugins, modules, format, 
                   clean = true, doctest = true, draft = false, pages)
    
        if haskey(ENV, "DEPLOY_DOCS") && hasproperty(format, :repolink)
            deploydocs(; repo = deployrepo(format))
        end
    catch err
        @error("Failed while generating the docs:\n$(err)")
    end
end

##############################################################################
# THE CONFIGURATION
##############################################################################

modules = [WallyToolbox, OpenFOAM, RadCalNet]

name     = "Walter Dal'Maz Silva"
mail     = "walter.dalmazsilva.manager@gmail.com"

user     = "wallytutor"
sitename =  "WallyToolbox.jl"

bibtex = joinpath(@__DIR__, "..", "data", "bibtex", "references.bib")
authors = "$(name) <$(mail)> and contributors"

##############################################################################
# THE STRUCTURE
##############################################################################

pages = [
    "WallyToolbox" => [
        "Home" => "index.md",

        "WallyToolbox Docs" => [
            "WallyToolbox/setup-guide.md",
            "WallyToolbox/thermochemistry.md",
            "WallyToolbox/transport.md",
            "WallyToolbox/flowsheet.md",
            "WallyToolbox/constants.md",
            "WallyToolbox/utilities.md",
            "WallyToolbox/roadmap.md",

            "Modules/RadCalNet.md",
            "Modules/Cantera.md",
            "Modules/OpenFOAM.md",

            "Internals" => [
                # "WallyToolbox/Internals/abstract.md",
                "WallyToolbox/Internals/Documents.md",
            ],
        ],


        "WallyToolbox Tutorials" => [
            "Tutorials/combustion-flows.md",
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
            "Science/01-Continuum-Mechanics.md",
            "Science/03-Machine-Learning.md",
            # "Science/04-Theoretical-Physics.md",
            # "Science/05-Computational-Physics.md",
            "Science/08-Porous-Solids.md",
        ],

        "Notebooks"         => [
            "Notebooks/01-Composite-Conduction.md",
            "Notebooks/02-Part-Radiation-Heating.md",
            "Notebooks/03-Plug-Flow-Reactor-1.md",
            "Notebooks/08-Kramers-Model-Validation.md",
            "Notebooks/A1-Julia-para-Cientistas.md",
            "Notebooks/A2-Ciencia-Colaborativa-e-Julia.md",
        ],

        "References" => "References/index.md",
    ]
]

notes = [
    "dsc-tga-kaolinite.jl",
    "dsc-tga-model-demo.jl",
    "kramers-model-demo.jl",
    "process-balances.jl",
]

##############################################################################
# THE WORKFLOW
##############################################################################

spath = joinpath(@__DIR__, "src")
wpath = joinpath(@__DIR__, "tmp")
julianizemarkdown(; formatter, spath, wpath)

setdocmetawrapper!(WallyToolbox)
setdocmetawrapper!(OpenFOAM)
setdocmetawrapper!(RadCalNet)

format = get_format(user, sitename; latex = false)
plugins = [CitationBibliography(bibtex)]

workflow_pluto(notes, joinpath(wpath, "Notebooks", "Pluto"))
workflow_main(modules, pages, wpath, authors, format, sitename, plugins)

rm(wpath; force = true, recursive = true)

##############################################################################
# THE END
##############################################################################