# -*- coding: utf-8 -*-

# Import Python built-in modules.
from pathlib import Path

data_dir = Path(__file__).resolve().parent

__all__ = [
    "data_dir"
]