Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "upnpc-static.exe -e GameMakerStudio -r " & WScript.Arguments.Item(0) & " UDP " & WScript.Arguments.Item(0) & " TCP"
oShell.Run strArgs, 0, false