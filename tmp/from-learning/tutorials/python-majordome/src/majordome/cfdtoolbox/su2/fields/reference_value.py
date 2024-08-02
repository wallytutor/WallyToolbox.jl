# -*- coding: utf-8 -*-
from textwrap import dedent
from ..su2configfield import SU2ConfigField

REF_ORIGIN_MOMENT_X = SU2ConfigField(
    "REF_ORIGIN_MOMENT_X", 0.25, 
    "Reference origin for moment computation (m or in)")

REF_ORIGIN_MOMENT_Y = SU2ConfigField(
    "REF_ORIGIN_MOMENT_Y", 0.00, 
    "Reference origin for moment computation (m or in)")

REF_ORIGIN_MOMENT_Z = SU2ConfigField(
    "REF_ORIGIN_MOMENT_Z", 0.00, 
    "Reference origin for moment computation (m or in)")

REF_LENGTH = SU2ConfigField(
    "REF_LENGTH", 1.0, 
    "Reference length for moment non-dimensional coefficients (m or in)")

REF_AREA = SU2ConfigField(
    "REF_AREA", 1.0, 
    ("Reference area for non-dimensional force coefficients (0 implies"
     " automatic calculation) (m^2 or in^2)"))

SEMI_SPAN = SU2ConfigField(
    "SEMI_SPAN", 0.0, 
    "Aircraft semi-span (0 implies automatic calculation) (m or in)")
