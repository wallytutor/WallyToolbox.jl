# -*- coding: utf-8 -*-
from abc import ABC
from abc import abstractmethod
from pathlib import Path
from scipy.interpolate import interp1d
import json
import numpy as np


class Material(ABC):
    def __init__(self):
        pass

    def _load_func(self, data):
        """ Manage type of function loading from data. """
        if "P" in data:
            return np.poly1d(data["P"])
    
        if "X" in data and "Y" in data:
            return interp1d(data["X"], data["Y"], fill_value="extrapolate")

        raise NotImplementedError()

    def load(self, fname):
        """ Load properties from data tables. """
        with open(Path(__file__).resolve().parent / fname) as fp:
            data = json.load(fp)

        if (name := "heat_capacity") in data:
            self._heat_capacity = self._load_func(data[name])
        
        if (name := "thermal_conductivity") in data:
            self._thermal_conductivity = self._load_func(data[name])

        if (name := "density") in data:
            self._density = self._load_func(data[name])

    @abstractmethod
    def heat_capacity(self, T):
        pass

    @abstractmethod
    def thermal_conductivity(self, T):
        pass

    @abstractmethod
    def density(self, _):
        pass