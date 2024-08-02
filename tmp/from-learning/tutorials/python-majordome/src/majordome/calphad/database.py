# -*- coding: utf-8 -*-
from numbers import Number
from pathlib import Path
from casadi import SX
import warnings
import yaml
from .models import StepwiseGHSER

DEFAULT_DATABASE = Path(__file__).resolve().parent / "database.yml"
""" Path to built-in default thermodynamic database file. """


class SymbolicExpression:
    """ Represent a symbolic expression in database. """
    source: str
    base: list[tuple[float, str]]
    parameters: list[dict[str, float]]


def parse_database() -> dict[str, SX]:
    """ Parse whole database in a map of parameters. """
    data = load_data()

    T = SX.sym("T")
    known = {"T": T, "R": 8.31446261815324}

    for name in data["data"]:
        _ = parse_symbol(T, data["data"], name, known)

    return known


def load_data(database=DEFAULT_DATABASE):
    """ Load materials database for CALPHAD calculations. """
    here = Path(database).resolve().parent

    with open(database) as fp:
        print(f"* Parsing data from {database.stem}")
        data = yaml.safe_load(fp)

    if "include" in data["data"]:
        for include in data["data"]["include"]:
            with open(here / include) as fp:
                included = yaml.safe_load(fp)
                _print_meta_and_del("description", included)
                _print_meta_and_del("author", included)
                data["data"] |= included

        del data["data"]["include"]

    return data


def _print_meta_and_del(name, element):
    if name in element:
        print(f"* {element[name]}")
        del element[name]


def parse_symbol(T: SX, data: dict[str, SymbolicExpression],
                 name: str, known: dict[str, SX]) -> SX:
    """ Parse a symbol from data tree. """
    # You already know it, so get it!
    if name in known:
        return known[name]

    # You will *never* know it, let it go.
    if name not in data:
        raise KeyError(f"Unknown expression `{name}`")

    # Start parsing.
    item = data[name]

    # You should keep track of your sources...
    if "source" not in item:
        # TODO also ensure reference is listed in document.
        warnings.warn(f"Missing reference for `{name}`")

    # Without parameters there is not much I can do...
    if "parameters" not in item:
        raise KeyError(f"Missing parameters in `{name}`")

    # We are good to go, get list of parameters.
    plist = item["parameters"]

    # You should also think about data validation...
    for k, p in enumerate(plist):
        if not all([isinstance(v, Number) for v in p.values()]):
            raise ValueError(f"NaN in parameter set {k} of `{name}`")

    # Parse main expression.
    expr = StepwiseGHSER(T, plist).value

    # Have other dependencies? Look them up!
    if "base" in item:
        for other in item["base"]:
            func = parse_symbol(T, data, other["function"], known)
            expr += other["multiplier"] * func

    # Do not repeat yourself!
    known[name] = expr

    # Return assembled expression.
    return expr
