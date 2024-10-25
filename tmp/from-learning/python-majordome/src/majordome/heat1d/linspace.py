# -*- coding: utf-8 -*-
from ast import Num
from typing import Type
from enum import Enum
import numpy as np
from .material import Material

Layer: Type = tuple[float, Material]
""" Type descriptor for a material layer in 1D. """


class NumericalMethod(Enum):
    """ Supported numerical methods. """
    FINITE_DIFFERENCE = 1
    FINITE_VOLUME = 2


class Linspace:
    """ Manage create of linear space for all layers in domain. """
    def __init__(self, layers: list[Layer], cell: float, min_cells: int = 5,
                 method: NumericalMethod = NumericalMethod.FINITE_DIFFERENCE,
                 T: list[float] = None):
        # Get total material thickness.
        thick = sum([0.5 * t for (t, _) in layers])

        # Check feasibility of mesh.
        if cell >= thick / min_cells:
            raise ValueError(f"Cell/thickness {cell}/{thick} incompatible")

        # Compute even number of nodes in system.
        size = int(thick / cell)
        size = size + 1 if not size % 2 == 0 else size

        # Compute discretization size for FV mesh.
        # TODO remove FD method once FV is ready.
        if method == NumericalMethod.FINITE_VOLUME:
            dx = thick / size
            x = np.arange(dx / 2, thick - dx / 2 + 1.0e-06, dx)
        else:
            x, dx = np.linspace(0, thick, size, retstep=True)
    
        # Store discretization.
        self._x, self._dx = x, dx

        # Attribute materials to cells.
        self._set_materials(layers, method)
        
        # Allocate temperature and materials properties arrays.
        self._T = np.zeros(size, dtype=float)
        self._R = np.zeros(size, dtype=float)
        self._C = np.zeros(size, dtype=float)
        self._K = np.zeros(size, dtype=float)

        if T is not None:
            self.update_properties(T)

    def _set_materials(self, layers, method):
        """ Use coordinates to create an array of materials. """
        # Get array of materials indices.
        self._materials = np.ndarray((self.no_cells,), dtype=Material)

        # Get array of interfaces indices.
        self._interfaces = np.zeros(len(layers), dtype=int)

        # Initialize cummulative thickness.
        total = 0.0

        # Counter of interface position.
        last = 0

        for i, (thickness, material) in enumerate(layers):
            # Accumulate half-thickness (mirror domain).
            total += 0.5 * thickness

            # Find first occurence of a value above.
            dx = self.delta if method == NumericalMethod.FINITE_VOLUME else 0
            index = np.argmax(self.linspace >= total - dx)

            # Attribute nth index for interface.
            self._interfaces[i] = index

            # Set slice up to this index to material
            self._materials[last:index + 1] = material

            # Swap last to avoid overwrite.
            last = index

    def update_properties(self, T: list[float]) -> None:
        """ Update properties array at given temperature. """
        self._T[:] = T

        for k, Tk in enumerate(T):
            mat = self._materials[k]
            self._R[k] = mat.density(Tk)
            self._K[k] = mat.thermal_conductivity(Tk)
            self._C[k] = mat.heat_capacity(Tk)

    @property
    def no_cells(self) -> int:
        """ Returns number of cells in linear space. """
        return self._x.shape[0]

    @property
    def linspace(self) -> list[float]:
        """ Returns coordinates of nodes in space. """
        return self._x

    @property
    def delta(self) -> float:
        """ Returns length of cells over domain. """
        return self._dx

    @property
    def materials(self) -> list[Material]:
        """ Provide access to materials array. """
        return self._materials

    @property
    def interfaces(self)  -> list[int]:
        """ Provide access to interfaces index array. """
        return self._interfaces

    @property
    def density(self) -> list[float]:
        """ Returns array of materials density."""
        return self._R

    @property
    def thermal_conductivity(self) -> list[float]:
        """ Returns array of materials thermal conductivity."""
        return self._K

    @property
    def heat_capacity(self) -> list[float]:
        """ Returns array of materials heat capacity."""
        return self._C

    @property
    def heat_density(self) -> list[float]:
        """ Returns product of density and heat capacity. """
        return self._R * self._C

    @property
    def temperature(self) -> list[float]:
        """ Returns array of cell or node temperatures. """
        return self._T

    @property
    def enthalpy_total(self) -> list[float]:
        """ Returns enthalpy of cells or nodes. """
        return self._R * self._C * self._T * self._dx
