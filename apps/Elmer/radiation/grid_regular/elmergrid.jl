# -*- coding: utf-8 -*-
# Convert all grids to Elmer format.

run(`ElmerGrid 14 2 porous010.msh2 -autoclean -merge 1.0e-07`)
run(`ElmerGrid 14 2 porous020.msh2 -autoclean -merge 1.0e-07`)
run(`ElmerGrid 14 2 porous030.msh2 -autoclean -merge 1.0e-07`)
run(`ElmerGrid 14 2 porous050.msh2 -autoclean -merge 1.0e-07`)
run(`ElmerGrid 14 2 porous080.msh2 -autoclean -merge 1.0e-07`)
run(`ElmerGrid 14 2 porous100.msh2 -autoclean -merge 1.0e-07`)
