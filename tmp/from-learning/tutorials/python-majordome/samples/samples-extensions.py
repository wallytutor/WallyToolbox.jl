# -*- coding: utf-8 -*-
from majordome import ExtendedDict

# Create data with explicit constructor, vanilla `{}` will not work
# because the way Python handles built-in types (here `dict`).
some_data = ExtendedDict({'a': {'b': {'c': 2}}})

# Retrieve and display nested value with `get_nested`.
print('Got', some_data.get_nested('a', 'b', 'c'))
