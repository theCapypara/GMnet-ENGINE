Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "java -jar portmapper.jar -delete -externalPort " & WScript.Arguments.Item(0) & " -protocol udp"
oShell.Run strArgs, 0, false