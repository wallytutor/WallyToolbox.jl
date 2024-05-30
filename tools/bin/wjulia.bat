@echo off
call %~dp0source.bat
julia --project=%~dp0../.. %*