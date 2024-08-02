# -*- coding: utf-8 -*-
from pathlib import Path
from textwrap import dedent
from jinja2 import Template

from . import mesh

__all__ = [
    "mesh"
]

FOAM_VERSION = "v2106"
FOAM_UTILS = Path(__file__).resolve().parent / "snippets"

with open(FOAM_UTILS / "foam_banner") as fp:
    FOAM_BANNER = fp.read()
    
with open(FOAM_UTILS / "foam_file") as fp:
    FOAM_FILE = fp.read()
    
with open(FOAM_UTILS / "foam_split") as fp:
    FOAM_SPLIT = fp.read()

with open(FOAM_UTILS / "foam_end") as fp:
    FOAM_END = fp.read()

FIELD_TYPES = {
    "scalar": "volScalarField",
    "vector": "volVectorField",
    "dict": "dictionary"
}

OBJECT_TYPES = {
    # zero
    "p": "volScalarField",
    "U": "volVectorField",
    "T": "volScalarField",

    # constant
    "combustionProperties": "dictionary",
    "chemistryProperties": "dictionary",
    "g": "uniformDimensionedVectorField",
    "initialConditions": "dictionary",
    "thermophysicalProperties": "dictionary",
    "transportProperties": "dictionary",
    "turbulenceProperties": "dictionary",
    
    # system
    "controlDict": "dictionary",
    "decomposeParDict": "dictionary",
    "fvSchemes": "dictionary",
    "fvSolution": "dictionary",

    # system (non-standard)
    "foamDataToFluentDict": "dictionary"
}

DIMENSIONS = {
    "0": "[ 0  0  0  0  0  0  0 ]",
    "p": "[ 1 -1 -2  0  0  0  0 ]",
    "U": "[ 0  1 -1  0  0  0  0 ]",
    "T": "[ 0  0  0  1  0  0  0 ]"
}

BC_ZERO_GRADIENT  = "        type            zeroGradient;"
BC_WEDGE          = "        type            wedge;"
BC_NOSLIP         = "        type            noSlip;"
BC_FIXED_VALUE    = f"""\
        type            fixedValue;
            value           uniform {{value}};\
"""
BC_INLET_OUTLET   = f"""\
        type            inletOutlet;
            inletValue      uniform {{inletValue}};
            value           uniform {{value}};\
"""
BC_TOTAL_PRESSURE = f"""\
        type            totalPressure;
            p0              {{p0}};\
"""

BC_PRESSURE_INLET_OUTLET_VELOCITY = f"""\
        type            pressureInletOutletVelocity;
            value           {{value}};\
"""

def make_header(object_name, class_type, force_type=False):
    """ Compose file header for class type/given object. """
    if force_type:
        class_name = class_type
    elif class_type is not None and class_type in FIELD_TYPES:
        class_name = FIELD_TYPES[class_type]
    else:
        class_name = OBJECT_TYPES[object_name]

    foam_banner = FOAM_BANNER.replace("xxxxx", FOAM_VERSION[:5])
    foam_file = FOAM_FILE.format(class_name=class_name,
                                 object_name=object_name)
    foam_head = f"{foam_banner}\n{foam_file}\n{FOAM_SPLIT}\n"
    return foam_head


def make_file(case, loc, fname, body, class_type=None, force_type=False):
    """ Prepare contents and dump in case at given location. """
    loc = Path(case) / loc
    loc.mkdir(exist_ok=True, parents=True)

    with open(loc / fname, "w") as fp:
        head = make_header(fname, class_type, force_type)
        fp.write(f"{head}\n{body}\n\n{FOAM_END}\n")

        
def boundary_fields_template(boundaries):
    """ Create a template from a set of names. """
    # TODO move this to file.
    baseBoundaryField = Template("""\
    dimensions      {% raw %}{{ {% endraw %}dimensions{% raw %} }}{% endraw %};

    internalField   uniform {% raw %}{{ {% endraw %}uniform{% raw %} }}{% endraw %};

    boundaryField
    {
        {% for patch in boundaries %}
        {{ patch }}
        {
    {% raw %}{{ {% endraw %}{{ patch }}{% raw %} }}{% endraw %}
        }
        {% endfor %}
    }
    """)
    
    return Template(baseBoundaryField.render(boundaries=boundaries))


def gravity_file(axis, g=-9.81):
    """ Generate the body of gravitational acceleration file. """
    if axis.lower() == "x":
        value = "({g} 0.00 0.00)"
    if axis.lower() == "y":
        value = "(0.00 {g} 0.00)"
    if axis.lower() == "z":
        value = "(0.00 0.00 {g})"
    
    body = dedent("""\
    dimensions      [0 1 -2 0 0 0 0];

    value           {value};
    """.format(value=value.format(g=g)))
    
    return body
