# Reading

Provides reference text exported from PDF files. The engine uses a combination of [tesseract](https://github.com/tesseract-ocr/tesseract) and [PyPDF2](https://github.com/mstamy2/PyPDF2) to perform the data extraction. Nonetheless, human curation of extracted texts is still required if readability is a requirement. If quality of automated extractions is often poor for a specific language, you might want to search the web how to *train tesseract*, that topic is not covered here.

## Installation

- **Ubuntu**

```
# Install tesseract and default EN language.
sudo apt install tesseract-ocr

# Uncomment if all/more languages are required.
# sudo apt install tesseract-ocr-all

# A `convert` command is required by `tesseract`.
sudo apt install imagemagick

# Poppler for pdf conversions.
sudo apt install poppler-utils

# Install Python dependencies.
pip install "Pillow==7.2.0"
pip install "PyPDF2==1.26.0"
pip install "pdf2image==1.14.0"
pip install "pytesseract==0.3.7"
```

- **Windows**

In this case you will need to manually download both `tesseract` and `poppler` for windows and place them somewhere in your computer. The full paths to these libraries/executables is provided by the optional arguments `tesseract_cmd` and `poppler_path` of `Convert.pdf2txt`. Python packages can still be installed with `pip`.

## How to

```python
# -*- coding: utf-8 -*-
from convert import Convert

converter = Convert()

# pdf_path = "sandbox/2007_Lukas_CALPHAD.pdf"
# text = converter.pdf2txt(pdf_path, first_page=11, last_page=16)
# text = converter.pdf2txt(pdf_path, first_page=17, last_page=55)
# text = converter.pdf2txt(pdf_path, first_page=57, last_page=67)
# text = converter.pdf2txt(pdf_path, first_page=68, last_page=87)
# text = converter.pdf2txt(pdf_path, first_page=89, last_page=170)
# text = converter.pdf2txt(pdf_path, first_page=171, last_page=212)
# text = converter.pdf2txt(pdf_path, first_page=213, last_page=252)
# text = converter.pdf2txt(pdf_path, first_page=253, last_page=273)
# text = converter.pdf2txt(pdf_path, first_page=274, last_page=305)
# text = converter.pdf2txt(pdf_path, first_page=309, last_page=316)

# pdf_path = "sandbox/1998_Saunders_CALPHAD.pdf"
# text = converter.pdf2txt(pdf_path, first_page=18,  last_page=21)
# text = converter.pdf2txt(pdf_path, first_page=24,  last_page=46)
# text = converter.pdf2txt(pdf_path, first_page=50,  last_page=74)
# text = converter.pdf2txt(pdf_path, first_page=78,  last_page=104)
# text = converter.pdf2txt(pdf_path, first_page=108, last_page=143)
# text = converter.pdf2txt(pdf_path, first_page=146, last_page=195)
# text = converter.pdf2txt(pdf_path, first_page=198, last_page=243)
# text = converter.pdf2txt(pdf_path, first_page=246, last_page=275)
# text = converter.pdf2txt(pdf_path, first_page=278, last_page=313)
# text = converter.pdf2txt(pdf_path, first_page=316, last_page=425)
# text = converter.pdf2txt(pdf_path, first_page=428, last_page=478)
# text = converter.pdf2txt(pdf_path, first_page=480, last_page=482)

pdf_path = "sandbox/fulltext.pdf"
text = converter.pdf2txt(pdf_path, first_page=405, last_page=419)

with open("sandbox/text.txt", "w") as fp:
    fp.write(text)
```
