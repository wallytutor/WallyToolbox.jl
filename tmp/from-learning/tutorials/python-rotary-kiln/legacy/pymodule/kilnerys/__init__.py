# -*- coding: utf-8 -*-
from pathlib import Path
import cantera as ct

ct.add_directory(str(Path(__file__).resolve().parent / "data/kinetics"))
