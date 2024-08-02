# -*- coding: utf-8 -*-
from .su2staticcase import SU2StaticCase


class SU2ConfigField:
    """ Wrapper for a field in SU2 configuration file. """
    case = SU2StaticCase()

    def __init__(self, name, default_value, description,
                 options=None, detail=None, many_options=False):
        self._name = name
        self._value = default_value
        self._descr = description
        self._detail = detail
        self._options = options
        self._manyopt = many_options

    @property
    def description(self):
        """ Available description for current property. """
        return self._descr
    
    @property
    def options(self):
        """ Available options for current property. """
        return self._options
    
    @property
    def value(self):
        """ Value of this property. """
        return self._value

    @value.setter
    def value(self, value):
        """ Value of this property. """
        if not self._manyopt and self._options and value not in self._options:
            message = f"{self._name}: {value} not in {self._options}"
            raise ValueError(message)
        elif self._manyopt and self._options:
            for this_value in value:
                if this_value not in self._options:
                    message = f"{self._name}: {this_value} not in {self._options}"
                    raise ValueError(message)

        self._value = value
        self.__class__.case.add_field(self)

    def __str__(self):
        if isinstance(self._value, (tuple, list)):
            value = "({})".format(", ".join(map(str, self._value)))
        else:
            value = self._value

        return f"% {self._descr}\n{self._name}= {value}\n"

    def __repr__(self):
        """ String representation of this property. """
        val = self.__str__()
        
        if self._options is not None:
            val =  f"{val}\n Options: {self._options}"
            
        if self._detail is not None:
            val =  f"{val}\n\n{self._detail}"

        return val
