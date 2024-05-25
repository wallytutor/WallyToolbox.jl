# -*- coding: utf-8 -*-
""" Create geometry and mesh for a regular grid of pores.

This was based on tutorial `t16.py` provided by `gmsh`. Notice also that in
that tutorial the example is provided in 3D, which can be used to extende
what is done here.
"""
from itertools import product
import gmsh
import pyvista as pv


class StructuredSpongeMedium2D:
    """ Structured domain with an array of pores in a matrix.

    Parameters
    ----------
    name: str
        Name to provide to `gmsh` to create a model.
    Nx: int
        Number of pores over x-axis.
    Ny: int
        Number of pores over y-axis.
    D: float
        Diameter of pores in `scale` units.
    f: float
        Fraction of diameter separating pores.
    scale: float = 1.0e-06
        Unit conversion factor to meters for `D`.
    lcar: float = 0.05
        Characteristic fraction of `D` used as mesh size.
    view_geometry: bool = False
        If true, geometry is displayed in `gmsh` before meshing.
    """
    def __init__(self,
            name: str,
            Nx: int,
            Ny: int,
            D: float,
            f: float,
            scale: float = 1.0e-06,
            lcar: float = 0.05,
            view_geometry: bool = False
        ) -> None:
        # Simply stored values.
        self.name = name
        self.Nx = Nx
        self.Ny = Ny
        self.f = f
        self.view_geometry = view_geometry

        # Convert units of D.
        self.D = D * scale

        # Compute characteristic mesh size.
        self.lcar = lcar * self.D

        # Distance between pores centers.
        self.d = self.D * (1 + self.f)

        # Length of box over each direction.
        self.Lx = self.Nx * (self.D * (1 + self.f))
        self.Ly = self.Ny * (self.D * (1 + self.f))

        # To be allocated.
        self.vol = None

    def _create_array(self):
        """ Create array of pores inside rectangular domain. """
        factory = gmsh.model.occ
        boundary = factory.add_rectangle(0, 0, 0, self.Lx, self.Ly)

        R = self.D / 2
        x0 = R * (1 + self.f)
        y0 = R * (1 + self.f)

        holes = []

        for (nx, ny) in product(range(self.Nx), range(self.Ny)):
            x = x0 + nx * self.d
            y = y0 + ny * self.d

            tag1 = factory.add_circle(x, y, 0, R)
            tag2 = factory.add_curve_loop([tag1])
            tag3 = factory.add_plane_surface([tag2])

            holes.append(tag3)

        # Tuples of dimensionality (2) and tags.
        obj  = [(2, boundary)]
        tool = [(2, h) for h in holes]

        # Extract all `holes` from `boundary`.
        [(_, self.vol)], _ = factory.cut(obj, tool)

        factory.synchronize()

    def _entity_in_bb(self, a, b, eps):
        """ Retrieve entities insize a given bounding box. """
        # Alias for function.
        inbb = gmsh.model.getEntitiesInBoundingBox

        # Get extrema +/- padding.
        xmin = min(a[0], b[0]) - eps
        xmax = max(a[0], b[0]) + eps
        ymin = min(a[1], b[1]) - eps
        ymax = max(a[1], b[1]) + eps

        # Get 1D entities in bounding box.
        return inbb(xmin, ymin, -eps, xmax, ymax, +eps, 1)

    def _get_boundaries(self):
        """ Retrieve renumbered boundary lines. """
        # Less than half the gap thickness.
        eps = self.d * (0.9999 / 2)

        # Sequence of corners to right-hand rectangle scan.
        corners = [
            (0,             0),  # Left-bottom
            (self.Lx,       0),  # Right-bottom
            (self.Lx, self.Ly),  # Right-top
            (0,       self.Ly)   # Left-top
        ]

        # By construction there should be a single entity (0) and we
        # are interested only in its label (1).
        external = [
            self._entity_in_bb(corners[0], corners[1], eps)[0][1],
            self._entity_in_bb(corners[1], corners[2], eps)[0][1],
            self._entity_in_bb(corners[2], corners[3], eps)[0][1],
            self._entity_in_bb(corners[3], corners[0], eps)[0][1]
        ]

        # Everything else are the internal pore boundaries.
        internal = [c for (_, c) in gmsh.model.getEntities(1)
                    if c not in external]

        # Create physical groups for entities.
        gmsh.model.addPhysicalGroup(2, [self.vol], 1)
        gmsh.model.addPhysicalGroup(1, [external[3]], 1)
        gmsh.model.addPhysicalGroup(1, [external[1]], 2)
        gmsh.model.addPhysicalGroup(1, [external[0], external[2]], 3)
        gmsh.model.addPhysicalGroup(1, internal, 4)

        # Launch the GUI to see the results:
        if self.view_geometry:
            gmsh.fltk.run()

    def _mesh_domain(self):
        """ Mesh domain and dump to file. """
        # Assign a mesh size to all the points and lines.
        gmsh.model.mesh.setSize(gmsh.model.getEntities(0), self.lcar)
        gmsh.model.mesh.setSize(gmsh.model.getEntities(1), self.lcar)
        gmsh.model.mesh.generate(2)
        gmsh.write(f"{self.name}.msh2")

    def __enter__(self) -> "StructuredSpongeMedium2D":
        gmsh.initialize()
        gmsh.model.add(self.name)
        gmsh.logger.start()
        self._create_array()
        self._get_boundaries()
        self._mesh_domain()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb) -> None:
        with open(f"{self.name}.log", "w") as fp:
            fp.write("\n".join(gmsh.logger.get()))
            gmsh.logger.stop()

        gmsh.finalize()



with StructuredSpongeMedium2D("porous", Nx=10, Ny=3, D=100, f=0.1) as domain:
    print(f"Creating {domain.name}")
    # XXX: capture I/O here if you need to manipulate it.
