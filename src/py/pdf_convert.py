# -*- coding: utf-8 -*-
""" Provides in-memory conversion of PDF to text. """
from logging import (
    Formatter,
    FileHandler,
    StreamHandler,
    getLogger
)
from pathlib import Path
from pdf2image import convert_from_path
from PyPDF2 import PdfReader
from pytesseract import (
    pytesseract,
    image_to_string
)
import logging
import shutil


##############################################################################
# LOGGING
##############################################################################


def init_logger(debug=True):
    """ Initialize logger for the current session. """
    fmt = Formatter("%(asctime)s [%(levelname)-5.5s]  %(message)s")

    logger = getLogger()
    logger.setLevel(logging.INFO)

    if debug:
        console = StreamHandler()
        console.setFormatter(fmt)
        console.setLevel(logging.INFO)
        logger.addHandler(console)

    outputs = FileHandler("frankie.log")
    outputs.setFormatter(fmt)
    outputs.setLevel(logging.INFO)
    logger.addHandler(outputs)


##############################################################################
# CONVERTED
##############################################################################


class PdfToTextConverter:
    """ Performs text extraction from PDF file. """
    def __init__(self,
            tesseract_cmd: Path,
            poppler_path: Path
        ) -> None:
        self._poppler_path = poppler_path
        pytesseract.tesseract_cmd = tesseract_cmd

    def __call__(self,
            pdf_path: Path,
            dpi: int = 150,
            first_page: int = None,
            last_page: int = None,
            userpw: str = None,
            thread_count: int = 8
        ):
        """ In-memory convertion of PDF to text. """
        try:
            ensure_readable_pdf(pdf_path)
        except RuntimeError as err:
            logging.error(f"Skipping {pdf_path}: {err}")
            return

        try:
            image_list = pdf_to_images(pdf_path, dpi, first_page,
                last_page, userpw, thread_count, self._poppler_path)
        except Exception as err:
            logging.error(f"Converting pdf2txt: {err}")
            return

        return image_to_text(image_list)


##############################################################################
# WORKFLOW
##############################################################################


def ensure_program(name, user_path):
    """ Ensure a given program exists or is in reference path. """
    def inner_ensure_program(name):
        if not (cmd := shutil.which(name)):
            raise FileNotFoundError(name)
        return Path(cmd)

    if user_path:
        if not user_path.exists():
            raise FileNotFoundError(f"User {name}: {user_path}")
        else:
            return user_path

    return inner_ensure_program(name)


def ensure_readable_pdf(pdf_path):
    """ Ensure PDF is readable or small enough. """
    doc = PdfReader(pdf_path)

    if doc.is_encrypted:
        raise RuntimeError(f"PDF is encrypted: {pdf_path}")

    if (n_pages := len(doc.pages)) > 100:
        logging.warning(f"{pdf_path} is too long ({n_pages})")

    for key, value in doc.metadata.items():
        logging.info(f"{key}: {value}")


def pdf_to_images(
        pdf_path: Path | str,
        dpi: int,
        first_page: int,
        last_page: int,
        userpw: str,
        thread_count: int,
        poppler_path: str
    ) -> list:
    """ Handles in-memory conversion of PDF to image. """
    image_list = convert_from_path(
        pdf_path,
        dpi          = dpi,
        first_page   = first_page,
        last_page    = last_page,
        thread_count = thread_count,
        userpw       = userpw,
        poppler_path = poppler_path,
        output_folder= None,
        fmt          = "ppm",
        jpegopt      = None,
        use_cropbox  = False,
        strict       = False,
        transparent  = False,
        single_file  = False,
        grayscale    = False,
        size         = None,
        paths_only   = False,
    )
    return image_list


def image_to_text(image_list) -> str:
    """ Extract text from sequence of images. """
    texts = ""

    try:
        for idx, image in enumerate(image_list):
            logging.info(f"Image {idx+1}/{len(image_list)}")
            texts += image_to_string(image)
            texts += "\n---\n"

    except Exception as err:
        logging.error(f"Extracting text from image: {err}")

    return texts


def get_converter(
        tesseract_cmd: Path = None,
        poppler_cmd: Path = None
    ) -> callable:
    """ Generate a converter for the current environment. """
    init_logger()

    # Ensure required executables are found:
    tesseract_cmd = ensure_program("tesseract", tesseract_cmd)
    poppler_cmd = ensure_program("pdftotext", poppler_cmd)
    poppler_path = poppler_cmd.parent

    logging.info(F"tesseract is {tesseract_cmd}")
    logging.info(F"poppler at {poppler_path}")

    return PdfToTextConverter(tesseract_cmd, poppler_path)


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

##############################################################################
# EOF
##############################################################################