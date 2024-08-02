# -*- coding: utf-8 -*-
from .material import Material


class PP304(Material):
    def __init__(self):
        super().__init__()
        self.load("pp304.json")

    def heat_capacity(self, T):
        return self._heat_capacity(T)

    def thermal_conductivity(self, T):
        return self._thermal_conductivity(T)

    def density(self, _):
        return 2950.0
