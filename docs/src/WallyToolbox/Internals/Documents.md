# Documents

```@meta
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/Modules/WallyToolbox/Documents.md"
CurrentModule = WallyToolbox
DocTestSetup = quote
    using WallyToolbox
end
```

The following functionalities are intended mostly for the own toolbox maintenance and documentation generation. This can also be imported as a replacement for some boilerplate code in other projects. The use of the functions provided in this module is essentially illustrated in [`docs/make.jl`](https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/make.jl).

```@docs
WallyToolbox.Documents.get_format
WallyToolbox.Documents.deployrepo
```

Because most of my work is done with [Obsidian](https://obsidian.md/) and the tool does not support Julia math blocks and a few other features, the functions below were conceived to help documentation conversion without modifications to standard ``\LaTeX`` syntacs in Obsidian.

```@docs
WallyToolbox.Documents.julianizemarkdown
WallyToolbox.Documents.formatequations
WallyToolbox.Documents.formatnotecells
WallyToolbox.Documents.formatembvideos
```

Finally, we wrap up a standard workflow for converting Pluto notebooks.

```@docs
WallyToolbox.Documents.convert_pluto
```
