# -*- coding: utf-8 -*-
"""
Rotary Kiln Model
=================

This module implements a full-feature 1D rotary kiln model without
implicit use-case specialization. Models are intended to be generic
and comprise a broad range of applications, from cement production,
biomatter pyrolysis, to pharmaceutical applications. For this, base
classes are provided and used-defined implementations required to
solve the specific kiln problem.
"""
from .kiln import RotaryKilnModel
from .kiln import solve_custom_silica_kiln
from .models import RadcalWrapper
from .phases import FreeboardCantera
from .phases import FreeboardMethane1S
from .phases import SilicaBasedBed
from .version import version
from .version import author

__version__ = version
__author__ = author

__all__ = [
    "RotaryKilnModel",
    "RadcalWrapper",
    "FreeboardCantera",
    "FreeboardMethane1S",
    "SilicaBasedBed",
    "solve_custom_silica_kiln"
]
