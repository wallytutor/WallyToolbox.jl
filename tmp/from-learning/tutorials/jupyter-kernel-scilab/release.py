# -*- coding: utf-8 -*-
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

    # Create project wheel.
    run(["pip", "install", "--upgrade", "wheel"])
    run(["python", "setup.py", "bdist_wheel"])

    # Upload project wheel to repository.
    run(["pip", "install", "--upgrade", "twine"])
    run(["twine", "upload", "dist/*", "--repository", "kernel_scilab"])


if __name__ == "__main__":
    main()
