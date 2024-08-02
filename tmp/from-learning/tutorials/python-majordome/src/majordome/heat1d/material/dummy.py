# -*- coding: utf-8 -*-
import numpy as np
from .material import Material


class Dummy(Material):
    def __init__(self):
        super().__init__()

    def heat_capacity(self, T):
        return 600.0

    def thermal_conductivity(self, T):
        return 50.0

    def density(self, _):
        return 7800.0
