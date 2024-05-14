// t7.geo

// Merge a list-based post-processing view containing the target mesh sizes:
Merge "shared/t7_bgmesh.pos";
// Merge "shared/t7_attractors.geo";

// If the post-processing view was model-based instead of list-based (i.e. if it
// was based on an actual mesh), we would need to create a new model to contain
// the geometry so that meshing it does not destroy the background mesh. It's
// not necessary here since the view is list-based, but it does no harm:
// NewModel;

// Merge the first tutorial geometry:
Merge "shared/t1_mini.geo";

// Apply the view as the current background mesh size field:
Background Mesh View[0];

// In order to compute the mesh sizes from the background mesh only, and
// disregard any other size constraints, one can set:
Mesh.MeshSizeExtendFromBoundary = 0;
Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeFromCurvature = 0;
