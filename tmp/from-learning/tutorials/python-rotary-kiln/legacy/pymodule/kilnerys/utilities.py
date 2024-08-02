# -*- coding: utf-8 -*-
from base64 import b64encode
from io import BytesIO
from numbers import Number
import numpy as np
import pandas as pd


def ensure_1d_array(val, length):
    """ Ensure value is returned as an array with proper length.
    
    Parameters
    ----------
    val : Any
        Value to be enforced the array shape.
    length : int
        Length of 1D array to be returned.

    Raises
    ------
    IndexError
        If value is not at number or if list length does not match
        expected array length.

    Returns
    -------
    np.ndarray
        An array of length equal to requested one.
    """
    if isinstance(val, Number):
        val = val * np.ones(length)
    elif len(val) == length:
        val = np.array(val)
    else:
        raise IndexError("Array and cell centers sizes do not match!")
    return val


def get_table_download_link(df):
    """ Generates a link for dowloading data as Excel file. """
    output = BytesIO()
    writer = pd.ExcelWriter(output, engine="xlsxwriter")
    df.to_excel(writer, sheet_name="Selection")
    writer.save()

    # TODO migrate to st.download_button

    b64 = b64encode(output.getvalue()).decode()
    return (f"<a href=\"data:application/octet-stream;base64,{b64}\""
            " download=\"extract.xlsx\">Download data</a>")
