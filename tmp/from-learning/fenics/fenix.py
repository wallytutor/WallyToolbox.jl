# -*- coding: utf-8 -*-
""" Helper functions to Pythonize DOLFIN workflow. """
from dolfin import File


class VtkFileWriter:
    """ Context manager for writing VTK files with DOLFIN. """
    def __init__(self, fname):
        self._fname = fname

    def __enter__(self):
        return File(self._fname)
    
    def __exit__(self, type, value, traceback):
        pass

    def write(self, u):
        """ Write trial function solution to file. """
        self._vtkfile << u
