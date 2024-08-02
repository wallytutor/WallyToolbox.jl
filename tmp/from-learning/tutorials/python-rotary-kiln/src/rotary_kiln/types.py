# -*- coding: utf-8 -*-
from pathlib import Path

Vector = list[float]

Matrix = list[Vector]

NumberOrVector = float | Vector

Tensor = float | Vector | Matrix

PathLike = str | Path
