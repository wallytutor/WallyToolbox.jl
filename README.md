# WallyToolbox.jl

General tools I use everyday for everything.

## Using Julia modules

```bash
# Launch this directory as a project:
julia --project=.
```

To be able to use module `WallyToolbox.Notebook`, an user-defined value of environment variable `JUPYTER_DATA_DIR` must be provided to avoid conflict with system files. It must be noticed that this utility module is undocumented. For the other modules, please consult the [documentation](https://wallytutor.github.io/WallyToolbox.jl/dev/).

## Using Python modules

```bash
# Install `virtualenv`:
pip install virtualenv

# Alternativelly use built-in `venv`:
# python -m venv venv

# Create a virtual environment:
virtualenv venv

# Activate the environment:
./venv/Scripts/activate

# Install dependencies:
pip install -r requirements.txt
```
