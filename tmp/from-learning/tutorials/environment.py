import os

HOME = "/home/walter/OpenFOAM/walter-v2106"
FOAM = "/usr/lib/openfoam/openfoam2106"

# https://bugs.openfoam.org/view.php?id=3163
os.environ["OMPI_MCA_btl_vader_single_copy_mechanism"] = "none"

os.environ["WM_PROJECT"] = "OpenFOAM"
os.environ["WM_PROJECT_USER_DIR"] = HOME

os.environ["FOAM_MPI"] = "sys-openmpi"
os.environ["FOAM_API"] = "2106"

os.environ["FOAM_APP"] = f"{FOAM}/applications"
os.environ["FOAM_ETC"] = f"{FOAM}/etc"
os.environ["FOAM_SRC"] = f"{FOAM}/src"
os.environ["FOAM_SOLVERS"] = f"{FOAM}/applications/solvers"
os.environ["FOAM_TUTORIALS"] = f"{FOAM}/tutorials"
os.environ["FOAM_UTILITIES"] = f"{FOAM}/applications/utilities"

os.environ["FOAM_APPBIN"] = f"{FOAM}/platforms/linux64GccDPInt32Opt/bin"
os.environ["FOAM_LIBBIN"] = f"{FOAM}/platforms/linux64GccDPInt32Opt/lib"
os.environ["FOAM_SITE_APPBIN"] = f"{FOAM}/site/2106/platforms/linux64GccDPInt32Opt/bin"
os.environ["FOAM_SITE_LIBBIN"] = f"{FOAM}/site/2106/platforms/linux64GccDPInt32Opt/lib"
os.environ["FOAM_USER_APPBIN"] = f"{HOME}/platforms/linux64GccDPInt32Opt/bin"
os.environ["FOAM_USER_LIBBIN"] = f"{HOME}/platforms/linux64GccDPInt32Opt/lib"

os.environ["FOAM_RUN"] = f"{HOME}/run"
os.environ["LD_LIBRARY_PATH"] = ":".join([
    f"{HOME}/platforms/linux64GccDPInt32Opt/lib",
    f"{FOAM}/site/2106/platforms/linux64GccDPInt32Opt/lib",
    f"{FOAM}/platforms/linux64GccDPInt32Opt/lib",
    f"{FOAM}/platforms/linux64GccDPInt32Opt/lib/dummy",
    f"{FOAM}/platforms/linux64GccDPInt32Opt/lib/sys-openmpi",
    "/usr/lib/x86_64-linux-gnu/openmpi/lib",
    "/opt/SU2/lib"
])

os.environ["PATH"] = ":".join([
    f"{HOME}/platforms/linux64GccDPInt32Opt/bin",
    f"{FOAM}/site/2106/platforms/linux64GccDPInt32Opt/bin",
    f"{FOAM}/platforms/linux64GccDPInt32Opt/bin",
    f"{FOAM}/bin",
    f"{FOAM}/wmake",
    "/opt/SU2/bin",
    "~/.local/bin",
    "/home/walter/.cargo/bin",
    "/usr/local/nvidia/bin",
    "/usr/local/cuda/bin",
    "/usr/local/sbin",
    "/usr/local/bin",
    "/usr/sbin",
    "/usr/bin",
    "/sbin:/bin"
])

os.environ["SU2_HOME"] = "/opt/SU2"
os.environ["SU2_RUN"] = "/opt/SU2/bin"
os.environ["PYTHONPATH"] = "/opt/SU2/bin"
