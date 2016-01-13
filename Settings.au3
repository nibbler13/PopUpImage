#NoTrayIcon
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <ColorConstants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Local $filePath = @ScriptDir & "\Settings.ini"
Local $intervalBetweenImages = -1
Local $intervalBetweenImagesUnit = -1
Local $showingTime = -1
Local $showingTimeUnit = -1
Local $bottomGap = -1
Local $moveSpeed = -1
Local $doNotCoverText = -1
Local $minimalDistanceToText = -1
Local $textColor = -1
Local $showNotification = -1
Local $writeToLog = -1
Local $isSettingsWrong = false
Local $fileHandler
Local $fileContent

If FileExists($filePath) Then
   $fileHandler = FileOpen($filePath)
   $fileContent = FileReadToArray($fileHandler)

   If UBound($fileContent) > 0 Then
	  For $line in $fileContent
		 If StringInStr($line, "intervalBetweenImages=") Then
			$intervalBetweenImages = StringStripWS(StringRight($line, StringLen($line) - 22), $STR_STRIPALL)
		 ElseIf  StringInStr($line, "intervalBetweenImagesUnit=") Then
			$intervalBetweenImagesUnit = StringStripWS(StringRight($line, StringLen($line) - 26), $STR_STRIPALL)
		 ElseIf  StringInStr($line, "showingTime=") Then
			$showingTime = StringStripWS(StringRight($line, StringLen($line) - 12), $STR_STRIPALL)
		 ElseIf  StringInStr($line, "showingTimeUnit=") Then
			$showingTimeUnit = StringStripWS(StringRight($line, StringLen($line) - 16), $STR_STRIPALL)
		 ElseIf  StringInStr($line, "bottomGap=") Then
			$bottomGap = StringStripWS(StringRight($line, StringLen($line) - 10), $STR_STRIPALL)
		 ElseIf  StringInStr($line, "moveSpeed=") Then
			$moveSpeed = StringStripWS(StringRight($line, StringLen($line) - 10), $STR_STRIPALL)
		 ElseIf  StringInStr($line, "doNotCoverText=") Then
			$doNotCoverText = StringStripWS(StringRight($line, StringLen($line) - 15), $STR_STRIPALL)
		 ElseIf  StringInStr($line, "minimalDistanceToText=") Then
			$minimalDistanceToText = StringStripWS(StringRight($line, StringLen($line) - 22), $STR_STRIPALL)
		 ElseIf  StringInStr($line, "textColor=") Then
			$textColor = StringStripWS(StringRight($line, StringLen($line) - 10), $STR_STRIPALL)
		 ElseIf  StringInStr($line, "showNotification=") Then
			$showNotification = StringStripWS(StringRight($line, StringLen($line) - 17), $STR_STRIPALL)
		 ElseIf  StringInStr($line, "writeToLog=") Then
			$writeToLog = StringStripWS(StringRight($line, StringLen($line) - 11), $STR_STRIPALL)
		 EndIf
	  Next
   EndIf

   FileClose($fileHandler)
EndIf


If $intervalBetweenImages = -1 Then
   $intervalBetweenImages = 1
   $isSettingsWrong = true
EndIf

If $intervalBetweenImagesUnit = -1 Then
   $intervalBetweenImagesUnit = "минут"
   $isSettingsWrong = true
EndIf

If $showingTime = -1 Then
   $showingTime = 30
   $isSettingsWrong = true
EndIf

If $showingTimeUnit = -1 Then
   $showingTimeUnit = "секунд"
   $isSettingsWrong = true
EndIf

If $bottomGap = -1 Then
   $bottomGap = 70
   $isSettingsWrong = true
EndIf

If $moveSpeed = -1 Then
   $moveSpeed = 17
   $isSettingsWrong = true
EndIf

If $doNotCoverText = -1 Then
   $doNotCoverText = 1
   $isSettingsWrong = true
EndIf

If $minimalDistanceToText = -1 Then
   $minimalDistanceToText = 10
   $isSettingsWrong = true
EndIf

If $textColor = -1 Then
   $textColor = "000000"
   $isSettingsWrong = true
EndIf

If $showNotification = -1 Then
   $showNotification = 1
   $isSettingsWrong = true
EndIf

If $writeToLog = -1 Then
   $writeToLog = 1
   $isSettingsWrong = true
EndIf

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("PopUpImage Settings", 330, 314)

$Group1 = GUICtrlCreateGroup("Интервал между показами", 8, 8, 153, 49)
$Input1 = GUICtrlCreateInput("0", 18, 28, 49, 21, $ES_NUMBER)
GUICtrlSetLimit(-1, 4)
GUICtrlSetData(-1, $intervalBetweenImages)
$Updown1 = GUICtrlCreateUpdown($Input1)
GUICtrlSetLimit(-1, 9999, 0)
$Combo1 = GUICtrlCreateCombo("секунд", 73, 28, 65, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "минут|часов")
GUICtrlSetData(-1, $intervalBetweenImagesUnit)

$Group2 = GUICtrlCreateGroup("Длительность показа", 168, 8, 153, 49)
$Input2 = GUICtrlCreateInput("0", 178, 28, 49, 21, $ES_NUMBER)
GUICtrlSetLimit(-1, 4)
GUICtrlSetData(-1, $showingTime)
$Updown3 = GUICtrlCreateUpdown($Input2)
GUICtrlSetLimit(-1, 9999, 0)
$Combo2 = GUICtrlCreateCombo("секунд", 233, 28, 65, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "минут|часов")
GUICtrlSetData(-1, $showingTimeUnit)

$Group3 = GUICtrlCreateGroup("Отступ от нижнего края", 8, 64, 153, 49)
$Input3 = GUICtrlCreateInput("0", 18, 84, 49, 21, $ES_NUMBER)
GUICtrlSetLimit(-1, 4)
GUICtrlSetData(-1, $bottomGap)
$Updown2 = GUICtrlCreateUpdown($Input3)
GUICtrlSetLimit(-1, 9999, 0)
$Label1 = GUICtrlCreateLabel("пикселей", 73, 87, 52, 17)

$Group6 = GUICtrlCreateGroup("Скорость движения", 168, 64, 153, 49)
$Slider1 = GUICtrlCreateSlider(178, 84, 134, 21)
GUICtrlSetLimit(-1, 17, 0)
GUICtrlSetData(-1, 18 - $moveSpeed)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Checkbox2 = GUICtrlCreateCheckbox("Не перекрывать текст основной программы", 8, 128, 313, 25, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_MULTILINE))
GUICtrlSetState(-1, ($doNotCoverText = 1) ? $GUI_CHECKED : $GUI_UNCHECKED)

$Group4 = GUICtrlCreateGroup("Отступ до текста", 8, 152, 153, 49)
$Input4 = GUICtrlCreateInput("0", 18, 172, 49, 21, $ES_NUMBER)
GUICtrlSetLimit(-1, 4)
GUICtrlSetData(-1, $minimalDistanceToText)
$Updown4 = GUICtrlCreateUpdown($Input4)
GUICtrlSetLimit(-1, 9999, 0)
$Label2 = GUICtrlCreateLabel("пикселей", 73, 175, 52, 17)

$Group5 = GUICtrlCreateGroup("Цвет текста (hex)", 168, 152, 153, 49)
$Label3 = GUICtrlCreateLabel("0x", 178, 175, 15, 17)
$Input5 = GUICtrlCreateInput("ffffff", 193, 172, 121, 21)
GUICtrlSetLimit(-1, 6)
GUICtrlSetData(-1, $textColor)

$Checkbox1 = GUICtrlCreateCheckbox("Отключить показ изображений", 8, 216, 193, 17)
GUICtrlSetState(-1, ($showNotification = 1) ? $GUI_UNCHECKED : $GUI_CHECKED)
If $showNotification = 0 Then
   GUICtrlSetBkColor(-1, $COLOR_YELLOW)
EndIf

$Checkbox3 = GUICtrlCreateCheckbox("Записывать ошибки в журнал", 8, 240, 177, 17)
GUICtrlSetState(-1, ($writeToLog = 1) ? $GUI_CHECKED : $GUI_UNCHECKED)

$Button1 = GUICtrlCreateButton("Сохранить", 72, 272, 195, 33)
GUICtrlSetState(-1, $GUI_DISABLE)
#EndRegion ### END Koda GUI section ###

GUIRegisterMsg($wm_command, "InputChange")
GUISetState(@SW_SHOW)

If $isSettingsWrong Then
   SaveData()
EndIf

While 1
   $nMsg = GUIGetMsg()
   If $nMsg > 0 Then
	  CheckState()
   EndIf

   Switch $nMsg
   Case $GUI_EVENT_CLOSE
	  If CheckState() = 0 Then
		 Exit
	  EndIf

	  $answer = MsgBox($MB_YESNOCANCEL, "", "Сохранить изменения?")
	  Switch $answer
	  Case $IDYES
		 SaveData()
		 Exit
	  Case $IDNO
		 Exit
	  Case $IDCANCEL
	  EndSwitch
   Case $Checkbox1
	  If GUICtrlRead($Checkbox1) = $GUI_UNCHECKED Then
		 GUICtrlSetBkColor($Checkbox1, $CLR_NONE)
	  Else
		 GUICtrlSetBkColor($Checkbox1, $COLOR_YELLOW)
	  EndIf
   Case $Button1
	  SaveData()
   EndSwitch
WEnd

Func CheckState()
   If GUICtrlRead($Input1) <> $intervalBetweenImages Or _
	  GUICtrlRead($Combo1) <> $intervalBetweenImagesUnit Or _
	  GUICtrlRead($Input2) <> $showingTime Or _
	  GUICtrlRead($Combo2) <> $showingTimeUnit Or _
	  GUICtrlRead($Input3) <> $bottomGap Or _
	  GUICtrlRead($Slider1) <> (18 - $moveSpeed) Or _
	  GUICtrlRead($Checkbox2) <> (($doNotCoverText = 1) ? $GUI_CHECKED : $GUI_UNCHECKED) Or _
	  GUICtrlRead($Input4) <> $minimalDistanceToText Or _
	  GUICtrlRead($Input5) <> $textColor Or _
	  GUICtrlRead($Checkbox1) <> (($showNotification = 1) ? $GUI_UNCHECKED : $GUI_CHECKED) Or _
	  GUICtrlRead($Checkbox3) <> (($writeToLog = 1) ? $GUI_CHECKED : $GUI_UNCHECKED) Then
	  GUICtrlSetState($Button1, $GUI_ENABLE)
	  Return 1
   EndIf
   GUICtrlSetState($Button1, $GUI_DISABLE)
   Return 0
EndFunc

Func SaveData()
   $fileHandler = FileOpen($filePath, $FO_OVERWRITE)

   FileWriteLine($fileHandler, "intervalBetweenImages=" & GUICtrlRead($Input1))
   $intervalBetweenImages = GUICtrlRead($Input1)

   FileWriteLine($fileHandler, "intervalBetweenImagesUnit=" & GUICtrlRead($Combo1))
   $intervalBetweenImagesUnit = GUICtrlRead($Combo1)

   FileWriteLine($fileHandler, "showingTime=" & GUICtrlRead($Input2))
   $showingTime = GUICtrlRead($Input2)

   FileWriteLine($fileHandler, "showingTimeUnit=" & GUICtrlRead($Combo2))
   $showingTimeUnit = GUICtrlRead($Combo2)

   FileWriteLine($fileHandler, "bottomGap=" & GUICtrlRead($Input3))
   $bottomGap = GUICtrlRead($Input3)

   FileWriteLine($fileHandler, "moveSpeed=" & 18 - GUICtrlRead($Slider1))
   $moveSpeed = 18 - GUICtrlRead($Slider1)

   Local $tmp = (GUICtrlRead($Checkbox2) = $GUI_CHECKED) ? 1 : 0
   FileWriteLine($fileHandler, "doNotCoverText=" & $tmp)
   $doNotCoverText = $tmp

   FileWriteLine($fileHandler, "minimalDistanceToText=" & GUICtrlRead($Input4))
   $minimalDistanceToText = GUICtrlRead($Input4)

   FileWriteLine($fileHandler, "textColor=" & GUICtrlRead($Input5))
   $textColor = GUICtrlRead($Input5)

   $tmp = (GUICtrlRead($Checkbox1) = $GUI_CHECKED) ? 0 : 1
   FileWriteLine($fileHandler, "showNotification=" & $tmp)
   $showNotification = $tmp

   $tmp = (GUICtrlRead($Checkbox3) = $GUI_CHECKED) ? 1 : 0
   FileWriteLine($fileHandler, "writeToLog=" & $tmp)
   $writeToLog = $tmp

   FileClose($fileHandler)

   GUICtrlSetState($Button1, $GUI_DISABLE)
EndFunc

Func InputChange($hwnd, $msg, $wparam, $lparam)
   Local $nnotifycode = _WinAPI_HiWord($wparam)
   Local $nid = _WinAPI_LoWord($wparam)
   If $nid = $Input1 Or $nid = $Input2 Or $nid = $Input3 Or $nid = $Input4 Or $nid = $Input5 And $nnotifycode = $en_change Then
	  CheckState()
   EndIf
EndFunc