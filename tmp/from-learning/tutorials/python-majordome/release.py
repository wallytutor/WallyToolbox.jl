# -*- coding: utf-8 -*-
# from importlib import import_module
from pathlib import Path
from subprocess import run
import shutil


def main():
    """ Run packaging workflow. """
    # Clean directory for next build. """
    here = Path(__file__).resolve().parent
    try:
        shutil.rmtree(here / "build")
    except FileNotFoundError:
        pass

    try:
        shutil.rmtree(here / "dist")
    except FileNotFoundError:
        pass

    # Retrieve package version with path-import.
    # version = import_module("src.majordome.version").version

    # Perform git actions.
    # run(["git", "checkout", "main"])
    # run(["git", "pull", "origin", "main"])
    # run(["git", "tag", f"v{version}"])
    # run(["git", "push", "origin", "--all"])
    # run(["git", "push", "origin", "--tags"])

    # Create project wheel.
    run(["pip", "install", "--upgrade", "wheel"])
    run(["python", "setup.py", "bdist_wheel"])

    # Upload project wheel to repository.
    run(["pip", "install", "--upgrade", "twine"])
    run(["twine", "upload", "dist/*", "--repository", "majordome"])


if __name__ == "__main__":
    main()
