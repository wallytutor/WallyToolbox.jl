A Jupyter kernel for Scilab

Important
---------
This project is a fork from the original `scilab_kernel <https://github.com/Calysto/scilab_kernel>`_.
The goal of forking was to perform an important refactor and improve PEP 8 compliance, but also to
fix a few bugs related to executable path and figure display. Since the original kernel has not been
updated for a few years and it did not work out-of-the-box with the latest version of Scilab, This
was also a personal opportunity to learn a bit more about kernel implementation. There are still
some open ends, specially in command parsing (Jupyter does not have a mimetype JavaScript file for
Scilab language and here we continue using the one from Octave) and the criteria to display figures.
Any help is welcomed!

Prerequisites
-------------
- `Jupyter Notebook <http://jupyter.readthedocs.org/en/latest/install.html>`_
- `Scilab <http://www.scilab.org/download/latest>`_

Installation
------------

    pip install kernel_scilab

To use it, run one of:

.. code:: shell

    ipython notebook
    # In the notebook interface, select Scilab from the 'New' menu
    ipython qtconsole --kernel scilab
    ipython console --kernel scilab

This kernel is based on `MetaKernel <http://pypi.python.org/pypi/metakernel>`_, which means it 
features a standard set of magics.  For a full list of magics, run ``%lsmagic`` in a cell.

If Scilab is not added to the ``PATH`` environmental variable, then you need to specify the path
to your Scilab executable by creating a ``SCILAB_EXECUTABLE`` environmental variable.  Use the 
``scilab-adv-cli`` executable if using a Posix-like OS, and ``WScilex-cli.exe`` if using Windows.

Configuration
-------------
The kernel can be configured by adding an ``kernel_scilab_config.py`` file to the ``jupyter``
config path.  The ``ScilabKernel`` class offers ``plot_settings`` as a configurable traits.
The available plot settings are shown in the following snippet.

.. code:: bash

    cat ~/.jupyter/kernel_scilab_config.py
    c.ScilabKernel.plot_settings = {
        "format": "svg",
        "backend": "inline",
        "size": "600,500",
    }


Troubleshooting
---------------
If the kernel is not starting, try running the following from a terminal.

.. code:: bash

  python -m kernel_scilab.check

Please include that output if opening an issue.


Advanced Installation Notes
---------------------------
We automatically install a Jupyter kernelspec when installing the python package.
This location can be found using ``jupyter kernelspec list``. If the default location
is not desired, you can remove the directory for the ``kernel_scilab`` kernel, and
install using `python -m kernel_scilab install`. 
See ``python -m kernel_scilab install --help`` for available options.
