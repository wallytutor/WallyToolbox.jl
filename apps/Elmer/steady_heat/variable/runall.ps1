# Parse and exit to generate mesh.
gmsh - geometry.geo

# Compile extension with material properties.
elmerf90 -o refractory.dll refractory.f90

