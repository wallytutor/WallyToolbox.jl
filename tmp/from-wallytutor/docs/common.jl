# -*- coding: utf-8 -*-
using Documenter
using DocumenterCitations
using DryTooling

bib_filepath = joinpath(@__DIR__, "src/references.bib")
bib = CitationBibliography(bib_filepath)

DocMeta.setdocmeta!(DryTooling, :DocTestSetup, :(using DryTooling); recursive=true)

# format = Documenter.LaTeX()

format = Documenter.HTML(;
    prettyurls = get(ENV, "CI", "false") == "true",
    canonical  = "https://wallytutor.github.io/DryTooling.jl",
    repolink   = "https://github.com/wallytutor/DryTooling.jl",
    edit_link  = "main",
    assets     = String[],
)

pages  = [
    "Home"                  => "index.md",

    ################################################################
    
    "Module Finite Volumes" => [
        "Documentation" => "FiniteVolumes/index.md",
        "Examples"      => "FiniteVolumes/samples.md",
    ],
        
    ################################################################

    "Module Granular"       => [
        "Documentation" => "Granular/index.md",
        "Examples"      => "Granular/samples.md",
    ],
        
    ################################################################

    "Module Fluid Models"   => [
        "Documentation" => "FluidModels/index.md",
        "Examples"      => "FluidModels/samples.md",
    ],
        
    ################################################################

    "Module Cantera"        => [
        "Documentation" => "Cantera/index.md",
        "Examples"      => "Cantera/samples.md",
        "Status"        => "Cantera/status.md",
    ],
        
    ################################################################

    "Module Thermodynamics" => [
        "Documentation" => "Thermodynamics/index.md",
        "Examples"      => "Thermodynamics/samples.md",
    ],
        
    ################################################################

    "Module Kinetics"       => [
        "Documentation" => "Kinetics/index.md",
        "Examples"      => "Kinetics/samples.md",
    ],
        
    ################################################################

    "Module Plug Flow"      => [
        "Documentation" => "PlugFlow/index.md",
        "Examples"      => "PlugFlow/samples.md",
    ],
        
    ################################################################

    "Module Simulation"     => "Simulation/index.md",
    "DryTooling Core"       => "DryTooling/index.md",

    ################################################################

    "Theory Guide"      => [
        "Finite volumes"   => "FiniteVolumes/theory.md",
        "Fluid models"     => "FluidModels/theory.md",
        "Thermodynamics"   => "Thermodynamics/theory.md",
        "Kinetics"         => "Kinetics/theory.md",
        "Plug Flow models" => "PlugFlow/theory.md",
        "References"       => "references.md",
    ],

    ################################################################

    "Reference API"         => "api.md",
    "Table of contents"     => "toc.md",
]

makedocs(;
    modules  = [DryTooling],
    format   = format,
    clean    = false,
    sitename = "DryTooling.jl",
    authors  = "Walter Dal'Maz Silva <walter.dalmazsilva.manager@gmail.com> & contributors",
    repo     = "https://github.com/wallytutor/DryTooling.jl/blob/{commit}{path}#{line}",
    plugins  = [bib],
    pages    = pages
)
