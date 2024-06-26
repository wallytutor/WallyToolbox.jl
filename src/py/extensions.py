# -*- coding: utf-8 -*-


class ExtendedDict(dict):
    def get_nested(self, *args):
        """ Recursive access of nested dictionary. """
        if not self:
            raise KeyError("Dictionary is empty")

        if not args or len(args) < 1:
            raise ValueError("No arguments were provided")

        value = self.get(args[0])

        return value if len(args) == 1 else \
            ExtendedDict(value).get_nested(*args[1:])


class ClassPropertyDescriptor:
    """ Implements a basic class property descriptor.
    
    Based on https://stackoverflow.com/a/5191224.
    """
    def __init__(self, fget, fset=None):
        self.fget = fget
        self.fset = fset

    def __get__(self, obj, klass=None):
        if klass is None:
            klass = type(obj)
        return self.fget.__get__(obj, klass)()

    def __set__(self, obj, value):
        if not self.fset:
            raise AttributeError("can't set attribute")
        type_ = type(obj)
        return self.fset.__get__(obj, type_)(value)

    def setter(self, func):
        if not isinstance(func, (classmethod, staticmethod)):
            func = classmethod(func)

        self.fset = func
        return self


def classproperty(func):
    """ Decorator for creation of a class property. """
    if not isinstance(func, (classmethod, staticmethod)):
        func = classmethod(func)

    return ClassPropertyDescriptor(func)


def apply(f, iterable):
    """ Apply unit operation over iterable items. """
    return list(map(f, iterable))
