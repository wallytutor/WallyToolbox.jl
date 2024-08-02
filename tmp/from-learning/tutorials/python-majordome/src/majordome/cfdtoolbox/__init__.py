# -*- coding: utf-8 -*-
from subprocess import Popen


def run_cmd(case, logname, command, mode="w"):
    """ Run command from case directory. """
    with open(f"{case}/{logname}", mode) as output:
        print(f"Running from {case}")
        server = Popen(command, cwd=case, shell=True,
                       stdout=output, stderr=output)
        server.communicate()
