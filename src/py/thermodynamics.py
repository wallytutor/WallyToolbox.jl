# -*- coding: utf-8 -*-
import numpy as np


class MaierKelleySpecificHeat:
    """ Implements a truncated Maier-Kelley specific heat. """
    @staticmethod
    def specific_heat(T, M, a):
        """ Truncated 3-coefficients specific heat [J/(kg.K)]"""
        return (a[0] + a[1] * T + a[2] * pow(T, -2)) / M

    def mixture_specific_heat(self, T, Y, M, a):
        """ Mixture averaged specific heat [J/(kg.K)]. """
        return np.sum(Y * self.specific_heat(T, M, a.T))
