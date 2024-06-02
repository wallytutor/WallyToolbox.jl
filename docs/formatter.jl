# -*- coding: utf-8 -*-

# TODO increase robustness of solution, especially getting new lines!
# If there are no new lines, then use simple double ticks.
# https://stackoverflow.com/questions/14182879
# https://tex.stackexchange.com/questions/621461

DEBUGMATCHES = false

TESTFORMATTER = true

# See https://stackoverflow.com/questions/20478823/
macro p_str(s) s end

ANYNAME = p"(?<named>((.|\n)*?))"

OJULIA  = p"(```julia;(\s+)@example(\s+)(.*)\n)"
CJULIA  = p"(\n```)"

ODOLLAR = p"(\$\$((\s+|\n)?))"
CDOLLAR = p"(((\s+|\n)?)\$\$)"

function matchdebugger(gr, text)
    if (m = match(gr, text); m !== nothing)
        println(m[:named])
    end
end

function formatnotecells(text)
    newgroup = s"```@example notebook\n\g<named>\n```"
    oldgroup = oldgroup = Regex(join([OJULIA, ANYNAME, CJULIA]))
    DEBUGMATCHES && matchdebugger(oldgroup, text)
    return replace(text, oldgroup => newgroup)
end

function formatequations(text)
    newgroup = s"```math\n\g<named>\n```"
    oldgroup = Regex(join([ODOLLAR, ANYNAME, CDOLLAR]))
    DEBUGMATCHES && matchdebugger(oldgroup, text)
    return replace(text, oldgroup => newgroup)
end

function formatcitations(text)
    # TODO get this working:
    # path = replace("$(@__DIR__)/tmp/References", "\\" => "/", ":" => "")
    # path = "tmp/References"
    # link = "[\\g<named>]($(path)/@\\g<named>.md)"
    # newgroup = SubstitutionString("$(link) [\\g<named>](@cite)")
    newgroup = s"(\g<named>)[\g<named>](@cite)"
    oldgroup = r"\(\[\[@(?<named>[A-Za-z0-9]+)\]\]\)"
    DEBUGMATCHES && matchdebugger(oldgroup, text)
    return replace(text, oldgroup => newgroup)
end

function formatter(text)
    text = formatnotecells(text)
    text = formatequations(text)
    text = formatcitations(text)
    return text
end

if TESTFORMATTER
    testnote = """\
    ```julia; @example notebook
    using Printf
    using Unitful

    # Stefan-Boltzmann constant.
    const σ = 5.67e-08u"W/(m^2*K^4)"

    nothing; # hide 1
    ```

    Some text for testing multiple captures.

    ```julia; @example notebook
    f(x) = x^2

    nothing; # hide 2
    ```
    """

    testequation = """
    Standard equation:

    \$\$
    \\frac{1}{2} = \\frac{2}{4}
    \$\$

    And something that should not exist

    \$\$ f(x) = x^2 + 1 \$\$
    """

    @info """
    testing documenter code blocks:
    $(formatnotecells(testnote))
    """

    @info """
    testing multiline equations:
    $(formatequations(testequation))
    """
end