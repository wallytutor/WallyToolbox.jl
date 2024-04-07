# -*- coding: utf-8 -*-
module WallyDocuments

using Documenter
using Documenter.DocMeta: setdocmeta!

export get_format, deployrepo

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
    )

    return format
end

"Generate a `repo` argument in the format expected by `deploydocs`."
deployrepo(format) = last(split(format.repolink, "://")) * ".git"

end # (module WallyDocuments)