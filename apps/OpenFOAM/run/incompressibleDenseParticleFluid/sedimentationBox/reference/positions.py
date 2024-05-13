# -*- coding: utf-8 -*-
from pathlib import Path
import pandas as pd
import pyvista as pv
import re


def natsort_key(s, _nsre=re.compile(r"([0-9]+)")):
    """ Using https://stackoverflow.com/a/16090640/11987084 """
    return [int(t) if t.isdigit() else t.lower() for t in _nsre.split(str(s))]


def get_ycoords(clouds):
    """ Get y-coordinates of particle in all time-points. """
    # There is no data in first cloud, manually feed it.
    df = [{"t": 0.0, "y": 1.9, "U": 0.0}]

    # Iterate over all files to get the required inputs.
    for k, file in enumerate(sorted(clouds.glob("*.vtk"), key=natsort_key)):
        if k == 0:
            continue

        data = pv.read(file)

        # XXX: use data.array_names to get all available properties.
        df.append({
            "t": data["age"][0],
            "y": data.points[0, 1],
            "U": data["U"][0, 1]
        })


    # Create a table and dump to file.
    df = pd.DataFrame(df)
    df.to_csv("fall.csv")

    return df


if __name__ == "__main__":
    clouds = Path(__file__).resolve().parent / "VTK/lagrangian/cloud"
    df = get_ycoords(clouds)
