# -*- coding: utf-8 -*-
from io import StringIO
from pathlib import Path
from pyparsing import OneOrMore
from pyparsing import Word
from pyparsing import Suppress
import numpy as np
import pandas as pd
import pyparsing as pp


#######################################################################
# TSV INPUT FILES
#######################################################################


class FluentInputRow:
    """ Fluent TSV file data entry for automated parameter generation.

    TODO
    ====
    - Clarify the meaning of `parameterid` in Ansys Fluent.
    - Allow operations between input variables (overloads).
    
    Parameters
    ==========
    name: str
        Name of parameter, no spaces allowed.
    value: str
        String representation of the value, if required with units.
    unit: str = ""
        Unit family of parameter.
    inpar: bool = False
        Whether to use parameter as a design input parameter.
    outpar: bool = False
        Whether to use parameter as a design output parameter.
    descr: str = ""
        A short description of the parameter.
    """
    def __init__(self,
            name: str,
            value: str,
            unit: str = "",
            inpar: bool = False,
            outpar: bool = False,
            descr: str = ""
        ):
        self._name   = name
        self._value  = value
        self._unit   = unit
        self._inpar  = self._parflag(inpar)
        self._outpar = self._parflag(outpar)
        self._descr  = descr

    def _parflag(self, test):
        return "#t" if test else "#f"

    def __repr__(self):
        return "\t".join((
            f'"{self._name}"',   # name
            f'"{self._value}"',  # definition
            f'"{self._descr}"',  # description
            f'""',               # parameterid
            f'"{self._name}"',   # parametername
            f'"{self._unit}"',   # unit
            f'{self._inpar}',    # input-parameter
            f'{self._outpar}',   # output-parameter
        ))

    @property
    def name(self):
        """ Provides access to entry name. """
        return self._name


class FluentInputFile:
    """ Representation of an Ansys Fluent expressions input file.

    Attributes
    ==========
    HEAD : tuple[str]
        Tuple containing TSV file headers.
    """
    HEAD = ("name", "definition", "description", "parameterid",
            "parametername", "unit", "input-parameter",
            "output-parameter")

    def __init__(self,
            rows: list[FluentInputRow],
            sort_list: bool = False
        ) -> None:
        if sort_list:
            rows = sorted(rows, key=lambda x: x.name)

        self._data = ["\t".join(self.HEAD), *(map(repr, rows))]
        
    def append(self, row: FluentInputRow):
        """ Append a single row to the inputs file. """
        self._data.append(repr(row))

    def to_file(self, saveas: str, overwrite: bool = False):
        """ Generate Fluent input file. """
        if Path(saveas).exists() and not overwrite:
            print(f"File {saveas} exists, use `overwrite=True`.")
            return
                  
        with open(saveas, "w") as fp:
            fp.write("\t\n".join((*self._data, "")))


#######################################################################
# SCHEME FILES
#######################################################################


class FluentSchemePatch:
    """ Parse patch name from a Scheme file. """
    def __init__(self, row: str) -> None:
        parsed = self._parse_row(row)
        self._name = parsed["name"]
        self._index = int(parsed["index"])

    def _parse_row(self, row: str) -> str:
        patch = (
            Suppress("(") +
            Word(pp.printables).set_results_name("name") +
            Word(pp.nums).set_results_name("index") +
            Suppress(")")
        )
        return patch.parse_string(row).as_dict()

    def __repr__(self) -> str:
        return f"<Patch name=\"{self._name}\" index=\"{self._index}\" />"

    @property
    def name(self) -> str:
        """ Provides access to patch name. """
        return self._name

    @property
    def index(self) -> int:
        """ Provides access to patch index. """
        return self._index


class FluentSchemeHeader:
    """ Parse header row from a Scheme table file. """
    def __init__(self, row: str) -> None:
        self._names = self._parse_row(row)

    def _parse_row(self, row: str) -> list[str]:
        name = Word(pp.printables, exclude_chars="()") 
        return np.ravel(name.search_string(row)).tolist()
        
    def __repr__(self) -> str:
        return f"<Header names=\"{' '.join(self._names)}\" />"

    @property
    def names(self) -> list[str]:
        """ Provides access to column names. """
        return self._names


class FluentSchemeTableRow:
    """ Parse data row from a Scheme table file. """
    def __init__(self, row: str) -> None:
        self._values = self._parse_row(row)
        
    def _parse_row(self, row: str) -> list[float]:
        values = OneOrMore(pp.common.sci_real)
        return np.ravel(values.search_string(row)).tolist()

    def __repr__(self) -> str:
        return f"<Data values=\"{' '.join(map(str, self._values))}\" />"

    @property
    def values(self) -> list[float]:
        """ Provides access to row data. """
        return self._values


class FluentDpmFile:
    """ Parse a sampled Scheme DPM file generated by Fluent. """
    def __init__(self, fname: str) -> None:
        self._patch = None
        self._header = None
        self._ncols = None
        self._data = []

        with open(fname) as fp:
            for k, row in enumerate(fp.readlines()):
                self._parse_row(k, row)

    def _parse_row(self, k: int, row: str) -> None:
        match k:
            case 0:
                self._patch = FluentSchemePatch(row)
                return
            case 1:
                self._header = FluentSchemeHeader(row)
                self._ncols = len(self._header.names)
                return

        data = FluentSchemeTableRow(row)

        if len(data.values) != self._ncols:
            raise ValueError(f"Malformed file at row {k}")
            
        self._data.append(data.values)

    def to_dataframe(self):
        """ Convert parsed data to a data frame for analysis. """
        return pd.DataFrame(self._data, columns=self._header.names)


#######################################################################
# OTHERS
#######################################################################


def convert_xy_to_dict(
        fname: str | Path
        ) -> dict[int, dict[str, list[float]]]:
    """ Convert Ansys XY format to a dictionary structure.
    
    Parameters
    ----------
    fname: str | Path
        Path to ".xy" file to be converted by function.

    Returns
    -------
    dict[int, dict[str, list[float]]]
        A dictionary with each particle from pathlines transformed
        into a dictionary of coordinates X and Y.
    """
    with open(fname, "r") as fp:
        text = fp.read()

    start_index = 0
    block_index = 1
    all_blocks = {}

    while True:
        print(f"Extracting block {block_index}")
        
        # Markers for block start and end.
        start = f"((xy/key/label \"particle-{block_index}\")"
        end = ")"

        # Find index of next block start.
        start_index = text.find(start, start_index)

        # If none was found, then leave the loop.
        if start_index < 0:
            print(f"Block {block_index} not found, leaving now.")
            break

        # Start search after the end of start marker.
        start_index += len(start)

        # Find index of next block end.
        end_index = text.find(end, start_index)

        # If none was found, file is corrupted.
        if end_index < 0:
            raise Exception("No end index found, file is corrupted")

        # Parse the interval as a data frame for post-processing.
        block = StringIO(text[start_index:end_index])
        df = pd.read_csv(block, sep="\t", header=None)

        # Add data to main dictionary.
        all_blocks[block_index] = {}
        all_blocks[block_index]["X"] = df[0].to_list()
        all_blocks[block_index]["Y"] = df[1].to_list()

        # Set start indexes for next block lookup.
        start_index = end_index + len(end)
        block_index += 1

    return all_blocks


def load_dpm_table(fname: str) -> pd.DataFrame:
    """ Wrapper for simple loading of data table. """
    return FluentDpmFile(fname).to_dataframe()


#######################################################################
# EOF
#######################################################################