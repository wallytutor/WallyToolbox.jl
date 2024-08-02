# -*- coding: utf-8 -*-
from metakernel import __version__ as mversion
from kernel_scilab import __version__
from kernel_scilab.kernel import ScilabKernel
import sys


def main():
    """ Check connection to Scilab kernel. """
    print(
        f"Scilab kernel ...... v{__version__}\n"
        f"Metakernel ......... v{mversion}\n"
        f"Python ............. v{sys.version}\n"
        f"Python path ........ {sys.executable}\n"
        "\nConnecting to Scilab..."
    )

    try:
        s = ScilabKernel()
        print("Scilab connection established")
        print(s.banner)
    except Exception as err:
        print(err)


if __name__ == "__main__":
    main()
