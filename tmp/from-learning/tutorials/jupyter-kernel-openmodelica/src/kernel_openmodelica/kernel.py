# -*- coding: utf-8 -*-
from base64 import b64encode
from io import BytesIO
from pathlib import Path
from textwrap import dedent
from ipykernel.kernelbase import Kernel
from majordome import classproperty
from OMPython import OMCSessionZMQ
import json
import re
import secrets
import subprocess
import sys
import matplotlib.pyplot as plt
import numpy as np

from . import __version__


class OpenModelicaKernel(Kernel):
    """ Implements a Jupyter kernel for OpenModelica language. """
    #########################################################################
    # Class properties
    #########################################################################

    language = "openmodelica"
    implementation = "kernel_openmodelica"
    implementation_version = __version__
    _app_name = None
    _language = None

    #########################################################################
    # Method properties
    #########################################################################

    @classproperty
    def app_name(cls):
        """ Provides access to application name. """
        if cls._app_name is None:
            cls._app_name = Path(__file__).resolve().parent.name
        return cls._app_name
    
    @classproperty
    def language(cls):
        """ Provides access to language name. """
        if cls._language is None:
            cls._language = cls.app_name.split("_")[-1]
        return cls._language

    @property
    def kernel_json(self):
        """ Provides access to kernel JSON data. """
        if self._kernel_json is None:
            here = Path(__file__).resolve().parent
            with open(here / "data/kernel.json") as fp:
                data = json.load(fp)
                data["argv"][0] = sys.executable

            self._kernel_json = data

        return self._kernel_json

    @property
    def banner(self):
        """ Provides access to display banner for application. """
        if self._banner is None:
            call = ["omc", "--version"]
            banner = subprocess.check_output(call, shell=True)
            self._banner = banner.decode("utf-8")
        return self._banner

    @property
    def language_version(self):
        """ Access to language version. """
        if not self._language_version:
            self._language_version = self.banner.split(" ")[1][1:]
        return self._language_version
    
    @property
    def language_info(self):
        """ Access to language information. """
        if not self._language_info:
            self._language_info = {
                "name": "modelica",
                "file_extension": ".mo",
                "mimetype": "text/x-modelica",
                "version": self.language_version,
                "help_links": self.help_links
            }
        return self._language_info

    @property
    def help_links(self):
        if not self._help_links:
            self._help_links = [
                {
                    "text": "OpenModelica Tutorials",
                    "url": "https://openmodelica.org/useresresources/modelica-courses/",
                },
                {
                    "text": "OpenModelica Kernel",
                    "url": ("https://github.com/WallyTutor/"
                            "learning-scientific-computing/tree/main/tools/"
                            "jupyter-kernel-openmodelica"),
                }
            ]
        return self._help_links

    #########################################################################
    # Own methods
    #########################################################################

    def __init__(self, *args, **kwargs):
        Kernel.__init__(self, *args, **kwargs)

        self.omc = OMCSessionZMQ()
        self.matfile = None

        self._kernel_json = None
        self._banner = None
        self._language_version = None
        self._language_info = None
        self._help_links = None

    def do_execute(self,
            code,
            silent,
            store_history=True,
            user_expressions=None,
            allow_stdin=True
        ):
        """ Manage code block execution and plotting. """
        def is_code(x):
            """ Filter for parsing valid code. """
            return not re.match(r"^\s*$", x)
        
        base_code = "".join(filter(is_code, code))

        match self._is_plotting(base_code):
            case True:
                payload = self._handle_plotting(base_code)
            case False:
                payload = self._handle_command(code)

        if not silent and payload is not None:
            self.send_response(self.iopub_socket, "display_data", payload)

        response = {
            "status": "ok",
            "execution_count": self.execution_count,
            "payload": [],
            "user_expressions": {},
        }
        return response

    def do_shutdown(self, restart):
        """ Call kernel shutdown. """
        try:
            self.omc.__del__()
        except BaseException:
            pass

    #########################################################################
    # Private methods
    #########################################################################

    def _handle_command(self, code):
        """ Handle code execution for other thing than plotting. """
        try:
            val = self.omc.sendExpression(code)
            try:
                self.matfile = val["resultFile"]
            except BaseException:
                pass
        except BaseException:
            val = self.omc.sendExpression(code, parsed=False)

        payload = {
            "source": "kernel",
            "data": {"text/plain": str(val)}
        }
        return payload
        
    def _handle_plotting(self, base_code):
        """ Handle code execution for plotting. """
        l1 = base_code.replace(" ", "")
        l = l1[0:-1]
        plotvar = l[5:].replace("{", "").replace("}", "")
        finaldata = self._plot_graph(plotvar)

        # with open("demofile.html", "w") as fp:
        #     fp.write(finaldata)

        payload = {
            "source": "kernel",
            "data": {"image/png": finaldata}
            # "data": {"text/html": finaldata}
        }
        return payload

    def _is_plotting(self, base_code):
        """ Check if this command is a plotting. """
        cmd1 = base_code.replace(" ", "").startswith("plot(")
        cmd2 = base_code.replace(" ", "").endswith(")")
        return cmd1 and cmd2

    def _plot_graph(self, plot_vars):
        """ Manage plotting of figures in notebook. """
        if self.matfile is None:
            return None
        
        data = self._get_plot_data(plot_vars)
        labels = self._get_plot_labels(plot_vars)

        plt.close("all")
        plt.style.use("seaborn-white")
        fig = plt.figure(figsize=(12, 6), dpi=200)

        for c, name in enumerate(labels[1:], 1):
            x, y = data[:, 0], data[:, c]
            plt.plot(x, y, label=name)

        plt.xlabel("Independent variable")
        plt.ylabel("Dependent variable(s)")
        plt.grid(linestyle=":")
        plt.legend(loc="best")

        with BytesIO() as tmpfile:
            fig.savefig(tmpfile, format="png")
            data = tmpfile.getvalue()

        return b64encode(data).decode("utf-8")

    def _plot_html(self, plot_vars):
        """ Manage plotting of figures in notebook. """
        if self.matfile is None:
            return "<p>No result File Generated</p>"

        try:
            here = Path(__file__).resolve().parent.as_posix()
            div_id = secrets.token_hex(8)

            divcontent = dedent(f"""\
            <html>
                <head>
                    <script src="{here}/data/dygraph-combined.js"></script>
                </head>
                <div id="{div_id}"></div>
                <script type=\"text/javascript\">
                    g = new Dygraph(
                        document.getElementById("{div_id}"), 
                        {self._get_plot_data(plot_vars, numerical=False)}, 
                        {{
                            "legend": "always",
                            "labels": {self._get_plot_labels(plot_vars)}
                        }}
                    ); 
                </script>
            </html>
            """)
        except BaseException:
            divcontent = f"<p>{self.omc.sendExpression('getErrorString()')}</p>"

        return divcontent

    def _get_plot_labels(self, plot_vars):
        """ Split list of plot variables into column labels. """
        regex = "(\s?,\s?)(?=[^\[]*\])|(\s?,\s?)(?=[^\(]*\))"
        subexp = re.sub(regex, "$#", plot_vars)

        labels = subexp.split(",")
        labels = [p.replace("$#", ",") for p in labels]
        labels = ["Time", *labels]

        return labels

    def _get_plot_data(self, plot_vars, numerical=True):
        """ Retrieve and process plotting data from names. """
        results = self.omc.sendExpression(
            dedent(f"""
                readSimulationResult(
                    "{self.matfile}",
                    {{time,{plot_vars}}}
                )""")
        )

        self.omc.sendExpression("closeSimulationResultFile()")

        data = np.hstack([[(x,) for x in r] for r in results])

        if numerical:
            return data

        np.set_printoptions(
            threshold=np.inf,
            linewidth=300
        )

        data = repr(data)\
            .replace("array", " ")\
            .replace("(", " ")\
            .replace(")", " ")
        
        return data
