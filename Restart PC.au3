#include <File.au3>

Local $compNames = _FileListToArray(@ScriptDir & "\Logs\", "*.log", $FLTA_FILES)
If IsArray($compNames) And (UBound($compNames) > 0) Then
   For $i = 1 to UBound($compNames) - 1
	  Local $tmp = StringTrimRight($compNames[$i], 4)
	  If $tmp <> @ComputerName Then
		 ShellExecute("cmd.exe", "/c shutdown /r /m " & $tmp, "", Default, @SW_HIDE)
	  EndIf
   Next
EndIf