# -*- coding: utf-8 -*-
from rotary_kiln.units import kelvin_to_celsius
import pandas as pd


class Results:
    """ Standardized simulation results format. """
    x = None
    R = None
    T_int = None
    T_ext = None

    def get_dataframe(self):
        """ Tabulate results for post-processing. """
        return pd.DataFrame({
            "x": self.x,
            "R": self.R,
            "T_int": kelvin_to_celsius(self.T_int),
            "T_ext": kelvin_to_celsius(self.T_ext)
        })