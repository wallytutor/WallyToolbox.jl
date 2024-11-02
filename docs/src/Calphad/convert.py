# -*- coding: utf-8 -*-
""" Provides conversion of PDF to text. """
from pathlib import Path
from pprint import pprint
from typing import Optional
from typing import Union
from typing import Tuple
from PIL import Image
from PyPDF2 import PdfFileReader
from pdf2image import convert_from_path
from pytesseract import pytesseract
from pytesseract import image_to_string
import imghdr
import logging
import warnings


PathType = Union[str, Path]
""" Allowed formats for a path. """


class Convert:
    def __init__(self):
        self._logger = self.make_logger()

    @staticmethod
    def make_logger() -> logging.Logger:
        """ Create logger for application. """
        fmt = logging.Formatter(
            "[%(asctime)s]@[%(filename)s:%(lineno)d] "
            "%(levelname)s: %(message)s")

        fh = logging.FileHandler("convert.log")
        fh.setLevel(logging.DEBUG)
        fh.setFormatter(fmt)

        sh = logging.StreamHandler()
        sh.setLevel(logging.DEBUG)
        sh.setFormatter(fmt)

        logger = logging.getLogger("convert")
        logger.setLevel(logging.DEBUG)
        logger.addHandler(fh)
        logger.addHandler(sh)

        return logger

    def ensure_command(self, tesseract_cmd: PathType,
                       poppler_path: PathType
                       ) -> Tuple[Path, Path]:
        """ Ensure required commands/directories are in path. """
        tesseract_cmd = Path(tesseract_cmd or "/usr/bin/tesseract")
        if not tesseract_cmd.exists():
            raise FileNotFoundError(tesseract_cmd)

        poppler_path = Path(poppler_path or "/usr/bin")
        if not poppler_path.exists():
            raise NotADirectoryError(poppler_path)

        if not (poppler_path / "pdftotext").exists():
            raise FileNotFoundError("pdftotext")
        
        self._logger.info(F"tesseract is {tesseract_cmd}")
        self._logger.info(F"poppler at {poppler_path}")

        return (tesseract_cmd, poppler_path)

    def test_if_pdf(self, pdf_path: PathType):
        """ Check if file is really a PDF. """
        doc = PdfFileReader(pdf_path)

        if doc.getIsEncrypted():
            raise RuntimeError(F"PDF is encrypted: {pdf_path}")

        if doc.getNumPages() > 100:
            n_pages = doc.getNumPages()
            self._logger.warn(F"{pdf_path} is too long ({n_pages})")

        pprint(doc.documentInfo)

    def pdf2txt(self, pdf_path: PathType,
                tesseract_cmd: Optional[PathType] = None,
                poppler_path: Optional[PathType] = None,
                dpi: Optional[int] = 150,
                first_page: Optional[int] = None,
                last_page: Optional[int] = None,
                userpw: Optional[str] = None,
                thread_count: Optional[int] = 8
                ):
        """ In-memory convertion of PDF to text. """
        cmds = self.ensure_command(tesseract_cmd, poppler_path)
        pytesseract.tesseract_cmd, poppler_path = cmds

        try:
            self.test_if_pdf(pdf_path)

            image_list = convert_from_path(
                pdf_path,
                dpi=dpi,
                output_folder=None,
                first_page=first_page,
                last_page=last_page,
                fmt="ppm",
                jpegopt=None,
                thread_count=thread_count,
                userpw=userpw,
                use_cropbox=False,
                strict=False,
                transparent=False,
                single_file=False,
                # output_file=uuid_generator(),
                poppler_path=poppler_path,
                grayscale=False,
                size=None,
                paths_only=False,
            )

            texts = ""
            for idx, image in enumerate(image_list):
                self._logger.info(F"Image {idx+1}/{len(image_list)}")
                texts += image_to_string(image)
                texts += "\n===========\n"
        except Exception as err:
            raise RuntimeError(F"While converting pdf2txt: {err}")

        return texts

    # TODO support direct image conversion.
    # def img2txt(img_path, valid, tesseract_cmd):
    #     """ Extract text from image file. """
    #     # Set path of executable.
    #     pytesseract.tesseract_cmd = tesseract_cmd
    #     base_error = "While converting img2txt"
    #     file_format = imghdr.what(img_path)
    #
    #     if file_format is None:
    #         raise ValueError(f"{base_error}: unable to get file format")
    #
    #     if file_format not in valid:
    #         raise ValueError(f"{base_error}: {file_format} not in {valid}")
    #
    #     try:
    #         with Image.open(img_path, mode="r") as img:
    #             texts_list = image_to_string(img)
    #     except (IOError, Exception) as err:
    #         raise IOError(f"{base_error}: {err}")
    #
    #     return texts_list
