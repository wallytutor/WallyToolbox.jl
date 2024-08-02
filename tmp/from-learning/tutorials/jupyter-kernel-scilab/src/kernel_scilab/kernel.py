# -*- coding: utf-8 -*-
from pathlib import Path
from tempfile import TemporaryDirectory
from textwrap import dedent
from majordome import apply
from majordome import classproperty
from metakernel import REPLWrapper
from metakernel import ProcessMetaKernel
from metakernel.pexpect import which
from IPython.display import Image
from IPython.display import SVG
from xml.dom import minidom
import codecs
import json
import os
import subprocess
import sys
import numpy as np

from . import __version__

# TODO move these to a configuration file
NT_EXEC = "WScilex-cli"
OT_EXEC = "scilab-adv-cli"
KERNEL_NAME = "Scilab Kernel"
VAR_NAME = "SCILAB_EXECUTABLE"


class SVGHandler:
    """ A reusable SVG handler for GnuPlot-based kernels. """
    def __init__(self, plot_settings):
        self._settings = plot_settings

    def _fix_svg_size(self, data):
        """ GnuPlot SVGs do not have height/width attributes.
        
        Set these to be the same as the viewBox, so that the browser
        scales the image correctly.
        """
        # Minidom does not support parseUnicode, so it must be decoded
        # to accept unicode characters
        parsed = minidom.parseString(data.encode("utf-8"))
        (svg,) = parsed.getElementsByTagName("svg")

        viewbox = svg.getAttribute("viewBox").split(" ")
        width, height = np.array(viewbox[2:]).astype(int)

        # Handle overrides in case they were not encoded.
        if self._settings["width"] != -1:
            if self._settings["height"] == -1:
                height = height * self._settings["width"] / width
            width = self._settings["width"]

        if self._settings["height"] != -1:
            if self._settings["width"] == -1:
                width = width * self._settings["height"] / height
            height = self._settings["height"]

        svg.setAttribute("width", f"{width:0d}px")
        svg.setAttribute("height", f"{height:0d}px")

        return svg.toxml()

    def process(self, filename):
        """ Handle special considerations for SVG images. """
        # Gnuplot can create invalid characters in SVG files.
        opts = dict(encoding="utf-8", errors="replace")
        with codecs.open(filename, "r", **opts) as fp:
            im = SVG(data=fp.read())

        try:
            im.data = self._fix_svg_size(im.data)
        except Exception:
            pass

        return im


class ScilabKernel(ProcessMetaKernel):
    """ Implements a Jupyter kernel for Scilab language. """
    #########################################################################
    # Class properties
    #########################################################################

    language = "scilab"
    implementation = KERNEL_NAME
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
    def executable(self):
        """ Provides access to kernel application executable. """
        if self._executable is None:
            executable = os.environ.get(VAR_NAME, None)

            if not executable or not which(executable):
                executable = NT_EXEC if os.name == "nt" else OT_EXEC

                if not which(executable):
                    msg = (
                        f"{KERNEL_NAME} executable not found, please add to "
                        f"path or set '{self.language.upper()}_EXECUTABLE' "
                        f"environment variable."
                    )
                    raise OSError(msg)
                
            if "cli" not in executable:
                executable += " -nw"

            self._executable = executable

        return self._executable

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
            call = [self.executable, "-version",  "-nwni"]
            banner = subprocess.check_output(call, shell=True)
            self._banner = banner.decode("utf-8")
        return self._banner

    @property
    def language_version(self):
        """ Access to language version. """
        if not self._language_version:
            def get_version(s):
                """ Clean string to recover Scilab version. """
                return s.splitlines()[0].split()[-1].replace("\"", "")
            self._language_version = get_version(self.banner)
        return self._language_version

    @property
    def language_info(self):
        """ Access to language information. """
        if not self._language_info:
            self._language_info = {
                "name": "octave",
                "file_extension": ".sci",
                "mimetype": "text/x-octave",
                "version": self.language_version,
                "help_links": self.help_links
            }
        return self._language_info

    @property
    def help_links(self):
        if not self._help_links:
            self._help_links = [
                {
                    "text": "Scilab Tutorials",
                    "url": "https://www.scilab.org/tutorials",
                },
                {
                    "text": "Scilab Kernel",
                    "url": ("https://github.com/WallyTutor/"
                            "learning-scientific-computing/tree/main/tools/"
                            "jupyter-kernel-scilab"),
                }
            ]
        return self._help_links

    #########################################################################
    # Own methods
    #########################################################################

    def __init__(self, *args, **kwargs):
        super(ScilabKernel, self).__init__(*args, **kwargs)

        self._executable = None
        self._kernel_json = None
        self._banner = None
        self._language_version = None
        self._language_info = None
        self._help_links = None

        self.wrapper = self.makeWrapper()

        setup = dedent(f"""
            try,getd("."),end
            try,getd("{Path(__file__).resolve().parent}/data"),end
            """).strip()
        self.do_execute_direct(setup, silent=True)
        self.handle_plot_settings()
        
    def _make_images(self, handler, filename):
        """ Handle image creation for display. """
        try:
            match filename.suffix.lower():
                case ".svg":
                    im = handler.process(filename)
                case _:
                    im = Image(filename)
        except Exception as err:
            if self.error_handler:
                self.error_handler(err)
            else:
                raise err

        return im

    def _plot_figures(self):
        """ Manage plotting and display of graphics. """
        handler = SVGHandler(self.plot_settings)

        with TemporaryDirectory() as plot_dir:
            plot_format = self._plot_fmt.lower()
            make_figs = f"_make_figures(\"{plot_dir}\", \"{plot_format}\");"
            path = Path(plot_dir)

            super(ScilabKernel, self).do_execute_direct(make_figs, silent=True)

            images = apply(lambda f: self._make_images(handler, path / f), 
                            reversed(os.listdir(plot_dir)))

            if len(images) > 0:
                apply(self.Display, images)

    #########################################################################
    # Methods from Metakernel
    #########################################################################

    def handle_plot_settings(self):
        """ Handle the current plot settings. """
        settings = self.plot_settings
        settings.setdefault("backend", "inline")
        settings.setdefault("format", "svg")
        settings.setdefault("size", "560,420")

        cmds = []

        self._plot_fmt = settings["format"]

        cmds.append("h = gdf();")
        cmds.append("h.figure_position = [0, 0];")

        width, height = 560, 420
        if isinstance(settings["size"], tuple):
            width, height = settings["size"]
        elif settings["size"]:
            try:
                width, height = settings["size"].split(",")
                width, height = int(width), int(height)
            except Exception as err:
                self.Error(f"Error setting plot settings: {err}")

        cmds.append(f"h.figure_size = [{width},{height}];")
        cmds.append(f"h.axes_size = [{width*0.9}, {height*0.9}];")

        if settings["backend"] == "inline":
            cmds.append("h.visible = \"off\";")
        else:
            cmds.append("h.visible = \"on\";")

        super(ScilabKernel, self)\
            .do_execute_direct("\n".join(cmds), silent=True)

    def get_completions(self, info):
        """ Get completions from kernel based on info dict. """
        def process(line):
            """ Remove undesirable spaces and symbols from line. """
            return line.strip().replace("!", "").replace("\"", "")
        
        cmd = f"completion(\"{info['obj']}\")"
        val = self.do_execute_direct(cmd, silent=True)

        return val and apply(process, val.output.splitlines()) or []

    def Print(self, text):
        text = str(text).strip("\x1b[0m").replace("\u0008", "").strip()
        text = [line.strip() for line in text.splitlines()
                if (not line.startswith(chr(27)))]
        text = "\n".join(text)
    
        if text:
            super(ScilabKernel, self).Print(text)

    #########################################################################
    # Methods from ProcessMetakernel
    #########################################################################

    def do_execute_direct(self, code, silent=False):
        """ Manage code block execution and plotting. """
        if code.strip() in ['quit', 'quit()', 'exit', 'exit()']:
            self.do_shutdown(restart=True)
            return

        # XXX: this is a workaround, actually I should provide a proper
        # mimetypes JS file for Jupyter parser.
        code = os.linesep.join([c for c in code.split(os.linesep) 
                                if not c.startswith("%")])
        
        resp = super(ScilabKernel, self).do_execute_direct(code, silent)

        if not silent and self.plot_settings.get("backend", None) == "inline":
            self._plot_figures()

        return resp
        
    def do_shutdown(self, restart):
        """ Call kernel shutdown. """
        self.wrapper.sendline("quit")
        super(ScilabKernel, self).do_shutdown(restart)

    def get_kernel_help_on(self, info, level=0, none_on_fail=False):
        """ Attempt to get help on given object. """
        obj = info.get("help_obj", "")
        
        if not obj or len(obj.split()) > 1:
            return None if none_on_fail else ""
        
        self.do_execute_direct(f"help {obj}", True)

    def makeWrapper(self):
        """ Start a Scilab process and return a :class:`REPLWrapper` object. """
        log_file = Path(f"~/{KERNEL_NAME}.log")
        with open(log_file.expanduser(), "w") as fp:
            fp.write(f"executable: {self.executable}")
        
        echo = os.name != "nt"
        prompt_cmd = None if echo else "printf(\"-->\")"

        wrapper = REPLWrapper(  
            cmd_or_spawn=self.executable,
            prompt_regex="-->",
            prompt_change_cmd=None,
            continuation_prompt_regex="  >",
            prompt_emit_cmd=prompt_cmd,
            echo=echo
        )
        
        wrapper.child.linesep = os.linesep
        return wrapper
