@echo off
call %~dp0source.bat
Code.exe --extensions-dir=%VSCODEEXTENSIONS% --user-data-dir=%VSCODESETTINGS% -r %HERE%../../../WallyToolbox.jl 