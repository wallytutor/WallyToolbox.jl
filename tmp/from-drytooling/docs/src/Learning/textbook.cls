%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% textbook.cls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{textbook}[2022/07/23 v0.1]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass{book}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% OPTIONS
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% GENERAL PACKAGES
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Configuration of font enconding/language.
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[portuguese]{babel}

%% More flexible names for syntax highlighting colors.
\RequirePackage[%
    usenames,%
    dvipsnames%
]{xcolor}

%% Allow for clickable links.
\RequirePackage{hyperref}

%% Configure page geometry.
\RequirePackage{geometry}

%% Environment for code listings.
\RequirePackage{listings}

%% Custom line spacing.
\RequirePackage{setspace}

%% Configure TOC.
\RequirePackage{tocloft}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% MATHS AND ILLUSTRATIONS
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% For math equations, theorems, symbols, etc
\RequirePackage{amsmath}
\RequirePackage{amssymb}

%% Create list of symbols.
\RequirePackage[
    symbols,%
    nogroupskip,%
    sort=none%
]{glossaries-extra}

%% Units (not necessarily) in SI.
\RequirePackage{siunitx}

%% Provide columns background.
\RequirePackage[most]{tcolorbox}

%% Provide plotting utility.
\RequirePackage{tikz}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% COLORS
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\definecolor{linkcolor}{rgb}{0.0, 0.0, 1.0}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% CONFIGURATION
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Change default font.
\renewcommand*\sfdefault{phv}
\renewcommand{\familydefault}{\sfdefault}

%% Set base line spacing with custom value.
\renewcommand{\baselinestretch}{1.2} 

%% Do not display symbols as actual links.
\renewcommand*{\glstextformat}[1]{\textcolor{black}{#1}}

%% Configure aspect of links.
\hypersetup{%
    pdftoolbar        = {true},      % show Acrobat’s toolbar?
    pdfmenubar        = {true},      % show Acrobat’s menu?
    pdffitwindow      = {false},     % window fit to page when opened
    pdfstartview      = {FitH},      % fits the page width to the window
    %
    colorlinks        = {true},      % false: boxed; true: colored
    linktocpage       = {true},      %
    bookmarksopen     = {true},      %
    bookmarksnumbered = {true},      %
    %
    linkcolor         = {linkcolor}, %
    citecolor         = {linkcolor}, %
    filecolor         = {linkcolor}, % color of file links
    urlcolor          = {linkcolor}, % color of external links
}

%% Remove all margins.
\geometry{%
    margin = 25mm%
}

%% Configure siunitx.
\sisetup{%
  locale                   = FR,%
  mode                     = text,%
  separate-uncertainty     = true,%
  multi-part-units         = single,%
  list-final-separator     = { \translate{e} },%
  list-pair-separator      = { \translate{e} },%
  range-phrase             = { \translate{à} },%
}

%% Add dots to TOC.
\renewcommand{\cftpartleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\cftsecleader} {\cftdotfill{\cftdotsep}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% PRIVATE
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% PUBLIC
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% A colored box for emphasis.
\newtcolorbox[%
  auto counter,%
  number within = chapter%
]{notebox}[2]{%
    leftright skip = 0pt,%
    arc            = 0pt,%
    outer arc      = 0pt,%
    boxrule        = 1pt,%
    boxsep         = 3pt,%
    top            = 6pt,%
    bottom         = 6pt,%
    left           = 0pt,%
    right          = 0pt,%
    coltitle       = black,%
    coltext        = black,%
    colback        = white,%
    colbacktitle   = cyan!90,%
    colframe       = cyan!90,%
    title          = {\bfseries\color{white}{Nota~\thetcbcounter\space#1}},%
    phantomlabel   = {#2},
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% JULIA LISTINGS
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\lstset{%
    basicstyle       = \ttfamily,%
    columns          = fullflexible,%
    numbers          = left,%
    numberstyle      = \small\ttfamily\color{Gray},%
    stepnumber       = 1,%
    numbersep        = 10pt,%
    numberfirstline  = true,%
    numberblanklines = true,%
    tabsize          = 4,%
    lineskip         = -1.5pt,%
    extendedchars    = true,%
    breaklines       = true,%
    keywordstyle     = \color{Blue}\bfseries,%
    identifierstyle  =,%
    commentstyle     =\sffamily\color{OliveGreen},%
    stringstyle      = \color{Maroon},%
    showstringspaces = false,%
    showtabs         = false,%
    upquote          = false,%
    texcl            = true,%
}

\lstdefinelanguage{julia}
{
  keywordsprefix = \@,%
  morekeywords   = {%
    exit,%
    whos,%
    edit,%
    load,%
    is,%
    isa,%
    isequal,%
    typeof,%
    tuple,%
    ntuple,%
    uid,%
    hash,%
    finalizer,%
    convert,%
    promote,%
    subtype,%
    typemin,%
    typemax,%
    realmin,%
    realmax,%
    sizeof,%
    eps,%
    promote_type,%
    method_exists,%
    applicable,%
    invoke,%
    dlopen,%
    dlsym,%
    system,%
    error,%
    throw,%
    assert,%
    new,%
    Inf,%
    Nan,%
    pi,%
    im,%
    begin,%
    while,%
    for,%
    in,%
    return,%
    break,%
    continue,%
    macro,%
    quote,%
    let,%
    if,%
    elseif,%
    else,%
    try,%
    catch,%
    end,%
    bitstype,%
    ccall,%
    do,%
    using,%
    module,%
    import,%
    export,%
    importall,%
    baremodule,%
    immutable,%
    local,%
    global,%
    const,%
    Bool,%
    Int,%
    Int8,%
    Int16,%
    Int32,%
    Int64,%
    Uint,%
    Uint8,%
    Uint16,%
    Uint32,%
    Uint64,%
    Float32,%
    Float64,%
    Complex64,%
    Complex128,%
    Any,%
    Nothing,%
    None,%
    function,%
    type,%
    typealias,%
    abstract%
  },
  sensitive   = true,%
  morecomment = [l]{\#},%
  morestring  = [b]',%
  morestring  = [b]",%
  texcl       = true,%
}

\endinput