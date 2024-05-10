# Syntax Highlighters

A collection of simple VS Code syntax highlighters for niche applications missing them.

Basic syntax highlighting created with [Yeoman generator tool](https://yeoman.io/).

## Available syntaxes

### OpenCALPHAD

**Directory:** `ocm`

**NOTE:** this is a work in progress and partial matching *i.e. the interactive way of writing macros*. is not yet supported. For now this solves my needs, so I am in no hurry to add that sort of support simply because shortcuts represent a bad scripting practice. After you spend a few months without using the tool, good luck reading the macros at a fast pace. I strongly recommend any serious macro that is gonna be used in a real world project to be written with full syntax.

### Thermodynamic database (CALPHAD)

**Directory:** `tdb`

**NOTE:** this is minimal version. If you want full support, please consider the official Thermo-Calc equivalent package.

### Kratos Multiphysics MDPA

**Directory:** `mdpa`

## Installation instructions

Simply copy the directory containing the desired highlighter to your VS Code extensions directory.

Under most Linux distributions this can be done by replacing `<name-here>` with the folder name and running:

```bash
cp -avr $(pwd)/<name-here>/ ${HOME}/.vscode/extensions/

# or for development just link symbolically.
ln -s $(pwd)/<name-here>/ ${HOME}/.vscode/extensions/
```

For Windows users, you should have a directory called `.vscode` in your home directory.
