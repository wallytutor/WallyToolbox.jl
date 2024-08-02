A Jupyter kernel for OpenModelica.

Important
---------
This project is a fork from the original 
`jupyter-openmodelica <https://github.com/OpenModelica/jupyter-openmodelica>`_.
The goal of forking was to perform an important refactor and improve PEP 8 compliance, but also to
fix a few bugs because the original source seems abandonned. If this works I will reach the OM
maintainers and propose to replace the project with the updated code. Plotting is still extremely
fragile and not customizable! Only works properly with Jupyter Notebook and kernel restart is not
working, requires to force shutdown the kernel.
Any help is welcomed!

Prerequisites
-------------
- `Jupyter Notebook <http://jupyter.readthedocs.org/en/latest/install.html>`_
- `OpenModelica <https://openmodelica.org>`_
- `OMPython <https://github.com/OpenModelica/OMPython>`_

Installation
------------
Before proceeding follow the installation instructions in OMPython as given in the prerequisites.
Make sure the environment variable for OpenModelica is set e.g.: 
`OPENMODELICAHOME=C:/OpenModelica1.20.0-64bit/`. Once everything is set, install the package with
`pip` from PyPI or clone and build this repository.

    pip install kernel_openmodelica

