# -*- coding: utf-8 -*-
from pathlib import Path
import logging
import sys
sys.path.insert(0, "../../../src/py")


from pdf_convert import get_converter

converter = get_converter()

# pdf_path = "sandbox/2007_Lukas_CALPHAD.pdf"
# contents = {
#     "Chapter0": {"first_page": 11,  "last_page": 16},
#     "Chapter0": {"first_page": 17,  "last_page": 55},
#     "Chapter0": {"first_page": 57,  "last_page": 67},
#     "Chapter0": {"first_page": 68,  "last_page": 87},
#     "Chapter0": {"first_page": 89,  "last_page": 170},
#     "Chapter0": {"first_page": 171, "last_page": 212},
#     "Chapter0": {"first_page": 213, "last_page": 252},
#     "Chapter0": {"first_page": 253, "last_page": 273},
#     "Chapter0": {"first_page": 274, "last_page": 305},
#     "Chapter0": {"first_page": 309, "last_page": 316},
# }

# pdf_path = "sandbox/1998_Saunders_CALPHAD.pdf"
# contents = {
#     "Chapter01": {"first_page": 18,  "last_page": 21},
#     "Chapter02": {"first_page": 24,  "last_page": 46},
#     "Chapter03": {"first_page": 50,  "last_page": 74},
#     "Chapter04": {"first_page": 78,  "last_page": 104},
#     "Chapter05": {"first_page": 108, "last_page": 143},
#     "Chapter06": {"first_page": 146, "last_page": 195},
#     "Chapter07": {"first_page": 198, "last_page": 243},
#     "Chapter08": {"first_page": 246, "last_page": 275},
#     "Chapter09": {"first_page": 278, "last_page": 313},
#     "Chapter10": {"first_page": 316, "last_page": 425},
#     "Chapter11": {"first_page": 428, "last_page": 478},
#     "Chapter12": {"first_page": 480, "last_page": 482},
# }


pdf_path = "sandbox/2004_Stolen_Thermodynamics.pdf"
pdf_dir = "2004_Stolen"

contents = {
    "Chapter01": {"first_page": 11,  "last_page": 37},
    "Chapter02": {"first_page": 38,  "last_page": 64},
    "Chapter03": {"first_page": 65,  "last_page": 91},
    "Chapter04": {"first_page": 92,  "last_page": 133},
}

pdf_dir = Path(pdf_dir)
pdf_dir.mkdir(exist_ok=True)

for destination, config in contents.items():
    if (target := pdf_dir / f"{destination}.md").exists():
        logging.info(f"Skipping {target}")
        continue

    with open(target, "w") as fp:
        fp.write(converter(pdf_path, **config))
