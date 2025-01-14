# WallyToolbox

*General tools I use everyday for everything.*

## About the toolbox

The core package of `WallyToolbox` ecosystem provides shared functionalities and types that are used in more specialized packages. It is an unpublished rolling release package composed of several sub-modules not making part of the main one and currently not following any versioning semantics. That means that new features are added and only the commits track differences. Its main goal is to provide a portable working environment that runs smoothly (at least) under Windows; anyone working in the numerical world knows the struggle with IT to have a proper Linux working system, especially in a portable device.

This unification over a central package allows for standardization of interfaces, employed quantities, and avoid boilerplate code. This page organizes everything (or tries to) to facilitate the understanding of the end-user.

!!! info

    Over the time it is expected that many functionalities from other modules will integrate `WallyToolbox` as they become stable. In some cases, entire modules may become sub-modules on integrated directly under `WallyToolbox`, so you might need to check where to import some utilities as this package is rolling release. This is temporary and will be modified when all the old code base that is giving origing to the package is migrated here, what will take me a few years. Nonetheless, the package will probably not be published to Julia registries because of the way its governance works. `WallyToolbox.jl` tries to be self-contained in several aspects because of the needs of perfect integration between functionalities of several of its foreseen end applications. That is currently incompatible with using some of the state-of-the-art packages from Julia ecosystem.

## Using the modules

The simplest way to use `WallyToolbox` is by launching Julia the root directory of `WallyToolbox.jl` as a project from command line, such as `julia --project=.`[^1]; this way one has access to most Julia modules packaged within the toolbox. Notice that for a full availability one needs to consider the extra steps provided in the [setup guide](WallyToolbox/setup-guide.md), which is the preferred way to deploy a working system with `WallyToolbox`.

[^1]: You might need to enter `pkg` mode and instantiate the project to get all dependencies installed. You can find more about this [here](https://docs.julialang.org/en/v1/stdlib/Pkg/).

## Contact and citing

For quick questions and proposals, please prefer [Zulip Chat](https://wallytutor.zulipchat.com). If you found and error or bug, please [create an issue](https://github.com/wallytutor/WallyToolbox.jl/issues). That will make me more efficient at handling everything. If none of those work for you, you can contact me by [mail](mailto:walter.dalmazsilva.manager@gmail.com). 

Found it useful? See [`CITATION.bib`](https://github.com/wallytutor/WallyToolbox.jl/blob/main/CITATION.bib) for the relevant reference.
