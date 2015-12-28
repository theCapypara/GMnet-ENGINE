Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "java -jar portmapper.jar -add -description GameMakerStudio -externalPort " & WScript.Arguments.Item(0) & " -internalPort " & WScript.Arguments.Item(0) & " -protocol udp"
oShell.Run strArgs, 0, false