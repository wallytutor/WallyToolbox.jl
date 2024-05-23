
## Mount a network drive in WSL

Here we assume we will mount drive `Z:` at `/mnt/z`:

```bash
# Create the mount point (if required):
sudo mkdir /mnt/z

# Mount the network drive in WSL:
sudo mount -t drvfs Z: /mnt/z
```

## $\LaTeX$

### Math typesetting with $\LaTeX$

- For integrals to display the same size as fractions expanded with `\dfrac`, place a `\displaystyle` in front of the `\int` command.

### Code typesetting with $\LaTeX$

- For some reason `minted` blocks `\begin{minted}...\end{minted}` have problems to render in Beamer (something related to multilevel macros). I managed to insert code blocks with `\inputminted` as reported [here](https://tex.stackexchange.com/questions/159667/including-python-code-in-beamer)

### MiKTeX

- [mathkerncmssi source file could not be found](https://tex.stackexchange.com/questions/553716/mathkerncmssi-source-file-could-not-be-found)
- [Installing user packages and classes](https://docs.miktex.org/manual/localadditions.html)
- [Configuring builds in VS Code with LaTeX Workshop](https://tex.stackexchange.com/questions/478865/vs-code-latex-workshop-custom-recipes-file-location)

