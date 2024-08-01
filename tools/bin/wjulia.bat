@echo off
julia --project=%~dp0../.. -i -e "using WallyToolbox" %*