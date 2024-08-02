# -*- coding: utf-8 -*-
from pathlib import Path
from subprocess import Popen
import shutil


FILE_HEADER = """\
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
% SU2 configuration file                                                       %
% Case description: _________________________________________________________  %
% Author: ___________________________________________________________________  %
% Institution: ______________________________________________________________  %
% Date: __________                                                             %
% File Version 7.2.1 "Blackbird"                                               %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"""

class SU2StaticCase:
    """ Manage creation of an incremental case. """
    def __init__(self):
        self.fields = []
        
    def add_field(self, field, overwrite=True):
        """ Add field to main case structure. """
        if not overwrite and field._name in self.fields:
            raise KeyError(f"{field._name} already in class")

        if not hasattr(self, field._name):
            self.fields.append(field._name)

        setattr(self, field._name, field)

    def dump_case(self, case_dir):
        """ Dump this case to target case directory. """
        case_dir = Path(case_dir)
        case_dir.mkdir(parents=True, exist_ok=True)

        mesh = getattr(self, "MESH_FILENAME")
        mesh_ori = str(mesh.value)

        shutil.copy(mesh_ori, case_dir / "mesh.msh")
        mesh._value = "mesh.msh"

        with open(case_dir / "config.cfg", "w") as fp:
            fp.write(FILE_HEADER +  "\n")
            for field in self.fields:
                fp.write(str(getattr(self, field)) +  "\n")

        mesh._value = mesh_ori

    @staticmethod
    def run_command(case_dir, command):
        with open(f"{case_dir}/runtime.log", "w") as output:
            server = Popen(command, cwd=case_dir, shell=True,
                           stdout=output, stderr=output)
            server.communicate()
