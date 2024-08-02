# -*- coding: utf-8 -*-
""" exer_003.py: densidade normal de probabilidade. """
import math
import statistics


def pdf(x, mu=0, sigma=1):
    """ Avalia densidade normal de probabilidade. """
    scale = 1 / (sigma * math.sqrt(2 * math.pi))
    breadth = math.exp(-(1/2) * ((x - mu) / sigma)**2)
    return scale * breadth


if __name__ == "__main__":
    norm = statistics.NormalDist()
    print(F'pdf(0) = {pdf(0):.6f} {norm.pdf(0):.6f}')
    print(F'pdf(1) = {pdf(1):.6f} {norm.pdf(1):.6f}')
    print(F'pdf(2) = {pdf(2):.6f} {norm.pdf(2):.6f}')
    print(F'pdf(3) = {pdf(3):.6f} {norm.pdf(3):.6f}')
