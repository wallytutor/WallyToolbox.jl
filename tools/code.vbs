Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c bin\code.bat"
oShell.Run strArgs, 0, false