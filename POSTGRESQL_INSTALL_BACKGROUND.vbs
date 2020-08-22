WScript.Sleep 3000
Dim fso, MyFile
Path = WScript.ScriptFullName
Path = Left(Path, InStrRev(Path, "\"))
'Dim oShell : Set oShell = CreateObject("WScript.Shell")
'filename = Path & "POSTGRESQL_INSTALL.xlsm - Excel"
'act = oShell.AppActivate(fileName)
'oShell.SendKeys "% C"
Set fso = CreateObject("Scripting.FileSystemObject")
Set MyFile = fso.CreateTextFile(Path &"background.txt", True)
MyFile.WriteLine("background")
MyFile.Close
Set objExcel = CreateObject("Excel.Application")
objExcel.Application.Run "'" & Path & "POSTGRESQL_INSTALL.xlsm'!Module1.Main"
objExcel.DisplayAlerts = False
Set objExcel = Nothing