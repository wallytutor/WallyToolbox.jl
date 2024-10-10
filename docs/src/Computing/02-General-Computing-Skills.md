# General computing skills

---
## Git version control

### Version control in Windows

- [TortoiseGIT](https://tortoisegit.org/): for Windows users, this applications add the possibility of managing version control and other features directly from the file explorer.

### Adding submodules

Generally speaking adding a submodule to a repository should be a simple matter of:

```shell
git submodule add https://<path>/<to>/<repository>
```

Nonetheless this might fail, especially for large sized repositories; I faced [this issue](https://stackoverflow.com/questions/66366582) which I tried to fix by increasing buffer size as reported in the link. This solved the issue but led me to [another problem](https://stackoverflow.com/questions/59282476) which could be solved by degrading HTTP protocol.

---

## Working on Windows

### Creating a portable launcher

A simple way to create a portable launcher requiring to source extra variables is by writing a simple batch script exporting or calling another script with the definitions:

```batch
@echo off

@REM Add variables to be sourced here such as
@REM set PATH="/path/to/some/dir";%PATH%
@REM ... or call another shared script doing so.
@REM call %~dp0\env

MyCode.exe
```

Because a batch script will keep a console window open, create a VB file with the following

```vb
Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c MyCode.bat"
oShell.Run strArgs, 0, false
```

In the example we assume the program is called `MyCode.exe` and the batch script has been named in an analogous way `MyCode.bat`. Some real world examples are provided [here](https://github.com/wallytutor/WallyToolbox.jl/tree/main/tools).

### Mount a network drive in WSL

Here we assume we will mount drive `Z:` at `/mnt/z`:

```bash
# Create the mount point (if required):
sudo mkdir /mnt/z

# Mount the network drive in WSL:
sudo mount -t drvfs Z: /mnt/z
```

### Following writing to a file

This is equivalent to Linux `tail -f <file-path>`:

```bash
Get-Content -Path "<file-path>" -Wait
```

---
## Regular expressions

Regular expressions (or simply *regex*) processing is a must-have skill for anyone doing scientific computing. Most programs produce results or logs in plain text and do not support specific data extraction from those. There *regex* becomes your best friend. Unfortunately during the years many flavors of regex appeared, each claiming to offer advantages or to be more formal than its predecessors. Due to this, learning regex is often language-specific (most of the time you create and process regex from your favorite language) and sometimes even package-specific. Needless to say, regex may be more difficult to master than assembly programming.

- Useful web applications can be found in [regex101](https://regex101.com/) and [regexr](https://regexr.com/).

- Match [all characters between two strings](https://stackoverflow.com/questions/6109882/regex-match-all-characters-between-two-strings) with lookbehind and look ahead patterns. Notice that this will require the enclosing strings to be fixed (at least under PCRE). For processing `WallyTutor.jl` documentation I have used a [more generic approach](https://github.com/wallytutor/WallyToolbox.jl/blob/89603a88d54eed1d15b9f8142640ef942cfa12ca/docs/formatter.jl#L20) but less general than what is proposed [here](https://stackoverflow.com/questions/14182879/regex-to-match-latex-equations).

- Match [any character across multiple lines](https://stackoverflow.com/questions/159118) with `(.|\n)*`.

- Currently joining regexes in Julia might be tricky (because of escaping characters); a solution is proposed [here](https://stackoverflow.com/questions/20478823/joining-regular-expressions-in-julia) and seems to work just fine with minimal extra coding.

---
## $\LaTeX$

### Math typesetting with $\LaTeX$

- For integrals to display the same size as fractions expanded with `\dfrac`, place a `\displaystyle` in front of the `\int` command.

### Code typesetting with $\LaTeX$

- For some reason `minted` blocks `\begin{minted}...\end{minted}` have problems to render in Beamer (something related to multilevel macros). I managed to insert code blocks with `\inputminted` as reported [here](https://tex.stackexchange.com/questions/159667/including-python-code-in-beamer).

- Beamer have some issues with footnotes, especially when use `column` environments; a quick fix for this is through `\footnotemark` and `\footnotetext[<number>]{<text>}` as described [here](https://tex.stackexchange.com/questions/86650/how-to-display-the-footnote-in-the-bottom-of-the-slide-while-using-columns). Notice that `\footnotemark` automatically generates the counter for use as `<number>` in `\footnotetext`.

- For setting a background watermark in Beamer one can use package `background` and display it using a Beamer template as described [here](https://tex.stackexchange.com/questions/244091/watermark-using-background-package-in-beamer).

### MiKTeX

- [mathkerncmssi source file could not be found](https://tex.stackexchange.com/questions/553716/mathkerncmssi-source-file-could-not-be-found)

- [Installing user packages and classes](https://docs.miktex.org/manual/localadditions.html)

### LaTeX Workshop

- [Configuring builds in VS Code with LaTeX Workshop](https://tex.stackexchange.com/questions/478865/vs-code-latex-workshop-custom-recipes-file-location) for building with `pdflatex`. Finally I ended creating my own workflows in this [file](https://github.com/wallytutor/WallyToolbox.jl/blob/main/tools/vscode/user-data/User/settings.json).

---
## Python

### Installing packages behind proxy

To install a package behind a proxy requiring SSL one can enforce trusted hosts to avoid certificate hand-shake and allow installation. This is done with the following options:

```ps1
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org <pkg>
```
