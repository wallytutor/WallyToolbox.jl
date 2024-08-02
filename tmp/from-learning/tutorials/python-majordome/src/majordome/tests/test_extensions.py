# -*- coding: utf-8 -*-
from majordome.extensions import ExtendedDict
import pytest


def test_dict_get_nested_empty_dict():
    """ Call get_nested with empty dictionary. """
    with pytest.raises(KeyError):
        ExtendedDict({}).get_nested()


def test_dict_get_nested_noarguments():
    """ Call get_nested with no arguments. """
    with pytest.raises(ValueError):
        ExtendedDict({"a": 1}).get_nested()


def test_dict_get_nested_alright():
    """ Call get_nested with functioning arguments. """
    sample = ExtendedDict({"a": {"b": {"c": 2}}})
    assert sample.get_nested("a", "b", "c") == 2

    sample = ExtendedDict({"a": 2})
    assert sample.get_nested("a") == 2

    sample = ExtendedDict({False: 2})
    assert sample.get_nested(False) == 2
