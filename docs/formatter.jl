# -*- coding: utf-8 -*-

DEBUGMATCHES  = false
TESTFORMATTER = true

# See https://stackoverflow.com/questions/20478823/
macro p_str(s) s end

ANYNAME = p"(?<named>((.|\n)*?))"

OJULIA  = p"(```julia;(\s+)@example(\s+)(.*)\n)"
CJULIA  = p"(\n```)"
SJULIA  = s"```@example notebook\n\g<named>\n```"

ODOLLAR = p"(\$\$((\s+|\n)?))"
CDOLLAR = p"(((\s+|\n)?)\$\$)"
SDOLLAR = s"```math\n\g<named>\n```"

OCITES  = p"\(\[\[@"
CCITES  = p"\]\]\)"
# SCITES  = s"(\g<named>)[\g<named>](@cite)"


function matchdebugger(gr, text)
    if (m = match(gr, text); m !== nothing)
        println(m[:named])
    end
end

function formatnotecells(text)
    oldgroup = Regex(join([OJULIA, ANYNAME, CJULIA]))
    DEBUGMATCHES && matchdebugger(oldgroup, text)
    return replace(text, oldgroup => SJULIA)
end

function formatequations(text)
    oldgroup = Regex(join([ODOLLAR, ANYNAME, CDOLLAR]))
    DEBUGMATCHES && matchdebugger(oldgroup, text)
    return replace(text, oldgroup => SDOLLAR)
end

function formatcitations(text, rhpath)
    oldgroup = Regex(join([OCITES, ANYNAME, CCITES]))
    DEBUGMATCHES && matchdebugger(oldgroup, text)
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

    testequation = """\
    Standard equation:

    \$\$
    \\frac{1}{2} = \\frac{2}{4}
    \$\$

    And something that should not exist

    \$\$ f(x) = x^2 + 1 \$\$
    """

    testcitations = """"\
    For instance, ([[@Masamune1963a]]) studied things, but also did
    ([[@Luikov1968a]]) and many others.
    """

    @info """
    testing documenter code blocks:
    $(formatnotecells(testnote))
    """

    @info """
    testing multiline equations:
    $(formatequations(testequation))
    """

    @info """
    testing multiline equations:
    $(formatcitations(testcitations, "../.."))
    """
end
