# -*- coding: utf-8 -*-


class StreamEasy:
    """ Make creating widgets even easier from dictionaries. """
    _state = {}

    def _create(self, f, item, name):
        """ Create element with provided configuration. """
        new_item = dict(item)

        if name is not None:
            new_item["key"] += F"_{name}"

        self._state[new_item["key"]] = f(**new_item)

    def add_slider(self, where, item, name=None):
        """ Modify unique keys in global state dictionary. """
        self._create(where.slider, item, name)

    def add_checkbox(self, where, item, name=None):
        """ Modify unique keys in global state dictionary. """
        self._create(where.checkbox, item, name)

    def add_selectbox(self, where, item, name=None):
        """ Modify unique keys in global state dictionary. """
        self._create(where.selectbox, item, name)

    def add_text_input(self, where, item, name=None):
        """ Modify unique keys in global state dictionary. """
        self._create(where.text_input, item, name)

    def add_file_uploader(self, where, item, name=None):
        """ Modify unique keys in global state dictionary. """
        self._create(where.file_uploader, item, name)

    def get(self, key, default=None):
        """ Access cached values from state. """
        return self._state.get(key, default)

    def add(self, where, item, name=None, add_type=None):
        """ Manage adding any type of item to application. """
        if add_type is None:
            add_type = item.pop("entry_type")

        f = getattr(self, f"add_{add_type}")
        f(where, item, name=name)
