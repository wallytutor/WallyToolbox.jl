#!/bin/env bash

# Run from strictly this directory.
cd ${0%/*} || exit 1

# Log at another folder to keep things clean.
mkdir logging/

if [ -f "../geometry.msh" ]; then
    echo "Copy existing mesh:"
    cp ../geometry.msh tmp.msh
else
    echo "Generate MSH2 file:"
    gmsh -3 ../geometry.geo -o tmp.msh | tee logging/log.gmsh
fi

# Create constant/polyMesh in case
gmshToFoam tmp.msh | tee logging/log.gmshToFoam

# Confirm mesh quality is acceptable.
checkMesh | tee logging/log.checkMesh

# Remove mesh cause non longer required.
rm -rf tmp.msh

# Fix patches for the present case.
chmod u+x patches.sh && ./patches.sh

# Improve parallelization efficiency.
renumberMesh -overwrite | tee logging/log.renumberMesh

# Manage type of execution.
if [ "$(nproc --all)" -gt 10 ]; then
    echo "Running in parallel:"
    decomposePar | tee logging/log.decomposePar
    mpirun -np 10 foamRun -parallel | tee logging/log.foamRun
else
    echo "Running sequential"
    foamRun | tee logging/log.foamRun
fi

#------------------------------------------------------------------------------