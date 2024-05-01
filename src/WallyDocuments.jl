# -*- coding: utf-8 -*-
module WallyDocuments

using Documenter
using Documenter.DocMeta: setdocmeta!

export get_format, deployrepo, julianizemarkdown


"Get format specified to generate docs."
function get_format(; latex = false, user, sitename)
    if (latex)
        # TODO add automatic tectonic download here!
        return Documenter.LaTeX(;
            platform = "tectonic",
            tectonic = joinpath(@__DIR__, "tectonic.exe")
        )
    end

    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical  = "https://$(user).github.io/$(sitename)",
        repolink   = "https://github.com/$(user)/$(sitename)",
        edit_link  = "main",
        assets     = String[],
        # size_threshold_ignore = [ TODO ],
    )

    return format
end


"Generate a `repo` argument in the format expected by `deploydocs`."
deployrepo(format) = last(split(format.repolink, "://")) * ".git"


"Convert equations from dollar to Julia ticks notation."
function julianizemarkdown(;
        formatter::Function,
        spath::String,
        wpath::String,
        ignores::Vector{String} = [".gitignore", ".obsidian"]
    )
    # Ensure directory exists.
    !isdir(wpath) && mkpath(wpath)

    for (root, _, files) in walkdir(spath)
        for file in files
            # Absolute path of file in sources.
            apath = joinpath(root, file)

            # Relative path of file from source root.
            rpath = relpath(apath, spath)

            # Directories to ignore in search (in source roots only!).
            # Check if not in list of ignored paths.
            any(p->startswith(rpath, p), ignores) && continue

            # Destination path of processed file.
            dpath = joinpath(wpath, rpath)

            # Directory name of processed file.
            fpath = dirname(dpath)

            # Ensure directory exists.
            !isdir(fpath) && mkpath(fpath)

            # @info("Processing $(apath)")
            if endswith(file, ".md")
                content = open(apath) do io
                    formatter(read(io, String))
                end
                open(dpath, "w") do io
                    write(io, content)
                end
            else
                cp(apath, dpath; force = true)
            end
        end
    end
end

end # (module WallyDocuments)