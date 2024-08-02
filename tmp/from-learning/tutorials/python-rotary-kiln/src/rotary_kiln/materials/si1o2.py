# -*- coding: utf-8 -*-

# Own imports.
from ..models import ShomateEquation


class ThermoSi1O2(ShomateEquation):
    """ Thermodynamic properties of SiO2.
    
    Data extracted from:
    https://webbook.nist.gov/cgi/cbook.cgi?ID=C14808607&Type=JANAFS
    """
    def __init__(self) -> None:
        super().__init__(
            [-6.076591e+00, +2.516755e+02, -3.247964e+02, +1.685604e+02,
             +2.548000e-03, -9.176893e+02, -2.796962e+01, -9.108568e+02],
            [+5.875340e+01, +1.027925e+01, -1.313840e-01, +2.521000e-02,
             +2.560100e-02, -9.293292e+02, +1.058092e+02, -9.108568e+02], 
            847.0, 0.0600843)
