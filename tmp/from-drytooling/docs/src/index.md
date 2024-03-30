# DryTooling.jl

Documentation for [DryTooling](https://github.com/DryTooling/DryTooling.jl).

## Why?

I am often faced with using the same approach for different engineering and scientific problems, but I don't like repeating the same task again and again. This is where `DryTooling.jl` comes in. By adopting some principles of [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) in Julia, to a larger extent than its definition, it packages together models and workflows that are not available or validated elsewhere - and in some cases adapts existing models. The tools will progressively cover a broad range of numerical applications and data treatment, this package is in its early days from the migration of my old Python scripts and packages.

Also [dry tooling](https://fr.wikipedia.org/wiki/Dry-tooling) is my favorite sport!

## Usage

The base case for using `DryTooling` is calling a pre-built model for solving a specific problem. Several sub-modules handle different Physics and find them in the side-bar. Most models are provided under structures that are already solved during construction or provide a `solve!` method. In an ideal world they should all be documented, but since this package is still in its early days, some experimental features are not yet documented.

For extending existing models and *preferrably* contributing to the package's growth, it is possible to use some functionalities provided in the bare `DryTooling` module, *i.e.* those made available when calling `using DryTooling`. They include physical constants, abstract types used all across the package, and some simple functions of general use.

## Citing

Found it useful? See [`CITATION.bib`](https://github.com/DryTooling/DryTooling.jl/blob/main/CITATION.bib) for the relevant reference.

## Contact

|                         |      |
| ----------------------: | :--- |
  Questions and proposals | [Zulip Chat](https://wallytutor.zulipchat.com)
  Found and error or bug  | [Create and issue](https://github.com/DryTooling/DryTooling.jl/issues/new)
