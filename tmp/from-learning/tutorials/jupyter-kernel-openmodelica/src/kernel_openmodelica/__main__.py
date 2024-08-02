# -*- coding: utf-8 -*-
from ipykernel.kernelapp import IPKernelApp
from kernel_openmodelica.kernel import OpenModelicaKernel

if __name__ == "__main__":
    IPKernelApp.launch_instance(kernel_class=OpenModelicaKernel)
