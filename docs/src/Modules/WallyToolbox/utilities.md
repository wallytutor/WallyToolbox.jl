# Utilities

```@meta
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/Modules/WallyToolbox/utilities.md"
CurrentModule = WallyToolbox
DocTestSetup = quote
    using WallyToolbox
end
```

## Haskell-like array slicing

Those who know Haskell probably started learning it by manipulating lists with `head` and `tail`. Those functionalities are not available in Julia *by default* and array slicing - with an ugly syntax - is required. Since this is done often in the fields of application of `WallyToolbox`, both [`head`](@ref) and [`tail`](@ref) together with a [`body`](@ref) functions are available in its core. They are simple wrapers over the `@view` macro and work with both iterable types and arrays. The following snippet illustrates their usage.

```jldoctest
julia> v = collect(1:4);

julia> head(v) == [1; 2; 3]
true

julia> tail(v) == [2; 3; 4]
true

julia> body(v) == [2; 3]
true
```

More examples are provided in the documentation of each of the functions.

```@docs
WallyToolbox.head
WallyToolbox.tail
WallyToolbox.body
```

## General utilities

```@docs
WallyToolbox.defaultvalue
WallyToolbox.redirect_to_files
WallyToolbox.test_exhaustive
```

## Literate programming

Because `WallyToolbox` is intended to be run from a portable Julia environment without footprint in the local system, some particularities arise in setting a Jupyter toolset. The following tools tools provide launchers for starting local Jupyter Notebook and Jupyterlab sessions. 

!!! note

    Notice it is up to the user to define the path [`JUPYTER_DATA_DIR`](https://docs.jupyter.org/en/latest/use/jupyter-directories.html#envvar-JUPYTER_DATA_DIR) as an environment variable; default Jupyter configuration is not accepted because it might break the local system.

```@docs
WallyToolbox.launch_notebook
WallyToolbox.launch_jupyterlab
```
