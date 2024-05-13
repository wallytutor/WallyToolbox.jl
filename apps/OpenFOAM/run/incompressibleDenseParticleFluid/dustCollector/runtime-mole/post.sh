HERE=$(pwd)
cd 001/case && reconstructPar -newTimes && cd $HERE
cd 002/case && reconstructPar -newTimes && cd $HERE
cd 003/case && reconstructPar -newTimes && cd $HERE
cd 004/case && reconstructPar -newTimes && cd $HERE

# Manually do foamToVTC cause newTimes not supported!
