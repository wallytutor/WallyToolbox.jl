# -*- coding: utf-8 -*-
import WallyToolbox
using DualSPHysics

path = "../../../tools/bin/DualSPHysics_v5.2/bin/windows"
case = DualSPHysicsCase(path)


if isdir(case.dump)
    @warn("Results already dumped at $(case.dump), exiting.")
else
    DualSPHysics.gencase(case)
    DualSPHysics.dualsphysics(case)
    DualSPHysics.partvtkfluid(case)
end