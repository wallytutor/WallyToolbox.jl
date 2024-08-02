# -*- coding: utf-8 -*-
import numpy as np
from .material import Material


class Steel(Material):
    def __init__(self):
        super().__init__()
        self.load("steel.json")

    def heat_capacity(self, T):
        return self._heat_capacity(T)

    def thermal_conductivity(self, T):
        return self._thermal_conductivity(T)

    def density(self, _):
        return 7830.0
