# -*- coding: utf-8 -*-
""" Create geometry and mesh for a regular grid of pores.

This was based on tutorial `t16.py` provided by `gmsh`. Notice also that in
that tutorial the example is provided in 3D, which can be used to extende
what is done here.
"""
from itertools import product
import gmsh
import random

# Scale to convert to meters.
scale = 1.0 #e-06

# Number of pores over each direction.
N = (6, 4)

# Pore diameter.
D = 100 * scale

# Fraction of diameter covered by *solid*.
f = 0.1

# Distance between pores centers.
d = D * (1 + f)

# Length of box over each direction.
L = [n * (D * (1 + f)) for n in N]

# Characteristic mesh size.
lcar = 0.05 * D

gmsh.initialize()
gmsh.model.add("porous")
gmsh.logger.start()

factory = gmsh.model.occ
bound = factory.add_rectangle(0, 0, 0, L[0], L[1])

x0 = (D/2) * (1 + f)
y0 = (D/2) * (1 + f)

centers = product(range(N[0]), range(N[1]))

holes = []

for (nx, ny) in centers:
    x = x0 + nx * d
    y = y0 + ny * d

    tag = factory.add_circle(x, y, 0, D/2)
    tag = factory.add_curve_loop([tag])
    tag = factory.add_plane_surface([tag])
    holes.append(tag)

obj  = [(2, bound)]
tool = [(2, h) for h in holes]
[(_, vol)], _ = factory.cut(obj, tool)

factory.synchronize()

# TODO use this to automate, or even better, improve it!
# corners = [(0, 0), (L[0], 0), (L[0], L[1]), (0, L[1])]

# Half the gap thickness:
eps = d * (0.999 / 2)

# Locate new lines for bounding box.
lleft   = gmsh.model.getEntitiesInBoundingBox(0.0  - eps, 0.0  - eps, -eps,
                                              0.0  + eps, L[1] + eps, +eps, 1)
lright  = gmsh.model.getEntitiesInBoundingBox(L[0] - eps, 0.0  - eps, -eps,
                                              L[0] + eps, L[1] + eps, +eps, 1)
lbottom = gmsh.model.getEntitiesInBoundingBox(0.0  - eps, 0.0 - eps, -eps,
                                              L[0] + eps, 0.0 + eps, +eps, 1)
ltop    = gmsh.model.getEntitiesInBoundingBox(0.0  - eps, L[1] - eps, -eps,
                                              L[0] + eps, L[1] + eps, +eps, 1)

l1 = [l for (_, l) in lleft]
l2 = [l for (_, l) in lright]
l3 = [l for (_, l) in (*lbottom, *ltop)]

external = [*l1, *l2, *l3]
internal = [c for (_, c) in gmsh.model.getEntities(1) if c not in external]

gmsh.model.addPhysicalGroup(2, [vol], 1)
gmsh.model.addPhysicalGroup(1, l1, 1)
gmsh.model.addPhysicalGroup(1, l2, 2)
gmsh.model.addPhysicalGroup(1, l3, 3)
gmsh.model.addPhysicalGroup(1, internal, 4)

# Assign a mesh size to all the points and lines.
gmsh.model.mesh.setSize(gmsh.model.getEntities(0), lcar)
gmsh.model.mesh.setSize(gmsh.model.getEntities(1), lcar)
gmsh.model.mesh.generate(2)
gmsh.write("porous.msh2")

# # Print execution log.
# log = gmsh.logger.get()
# print("Logger has recorded " + str(len(log)) + " lines")
# gmsh.logger.stop()

# # Launch the GUI to see the results:
# gmsh.fltk.run()
# gmsh.finalize()
