#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <GUIScrollbars_Ex.au3>
#include <StaticConstants.au3>
#include <ColorConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <DateTimeConstants.au3>
#include <DateTimeConstants.au3>

Opt("GUIOnEventMode", 1)

Local $pathToImage = @ScriptDir & "\Images\"
Local $iniFile = $pathToImage & "Images.ini"

Local $imagesNames = 0

Local $hGUI = GUICreate("Manage", 577, @DesktopHeight - 100, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseGui")

Local $addNew = GUICtrlCreateButton("Добавить изображение", 10, 10)
GUICtrlSetOnEvent(-1, "AddNewButton")
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$previous = ControlGetPos("Manage", "", $addNew)

Local $log = GUICtrlCreateButton("Журнал работы", $previous[0] + $previous[2] + 10, 10)
GUICtrlSetOnEvent(-1, "LogView")
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$previous = ControlGetPos("Manage", "", $log)

Local $settings = GUICtrlCreateButton("Настройки", $previous[0] + $previous[2] + 10, 10)
GUICtrlSetOnEvent(-1, "Settings")
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$previous = ControlGetPos("Manage", "", $settings)

Local $about = GUICtrlCreateButton("О программе", $previous[0] + $previous[2] + 10, 10)
GUICtrlSetOnEvent(-1, "About")
GUICtrlSetResizing(-1, $GUI_DOCKALL)

Local $delete = GUICtrlCreateButton("Удалить выбранные", 439, 10)
GUICtrlSetOnEvent(-1, "Delete")
GUICtrlSetResizing(-1, $GUI_DOCKALL)
GUICtrlSetState(-1, $GUI_DISABLE)

_GDIPlus_Startup()

Local $cGUI
Local $initialY
Local $aCount
Local $elements[5]

CreateChild()

While 1
   Sleep (10)
WEnd

Func CheckboxState()
   Local $checkOn = 0
   For $i = 0 to $aCount - 1
	  If (GUICtrlRead($elements[2][$i]) = $GUI_CHECKED) Then
		 $checkOn += 1
	  EndIf
   Next
   Return $checkOn
EndFunc

Func Settings()
   Run(@ScriptDir & "\Settings.exe")
EndFunc

Func LogView()
   ShellExecute("explorer.exe", @ScriptDir & "\Logs\")
EndFunc

Func Delete()
   Local $whatPressed = MsgBox($MB_YESNO, "", "Вы действительно хотите удалить выбранные изображения?")
   Switch $whatPressed
   Case $IDYES
	  For $i = 0 to $aCount - 1
		 If (GUICtrlRead($elements[2][$i]) = $GUI_CHECKED) Then
			If FileExists($pathToImage & "Deleted\") = 0 Then
			   Local $newDir = $pathToImage & "Deleted\"
			   DirCreate($newDir)
			EndIf
			If FileExists($pathToImage & $elements[3][$i]) Then
			   Local $newFile = $pathToImage & "Deleted\" & $elements[3][$i]
			   If FileExists($newFile) Then
				  $newFile = StringReplace($newFile, ".png", "_" & @YEAR & @MON & @MDAY & "_" & @HOUR & @MIN & @SEC & ".png")
			   EndIf
			   FileMove($pathToImage & $elements[3][$i], $newFile)
			EndIf
			If FileExists($pathToImage & $elements[3][$i] & ".jpg") Then
			   FileDelete($pathToImage & $elements[3][$i] & ".jpg")
			EndIf
		 EndIf
	  Next
	  GUICtrlSetState($delete, $GUI_DISABLE)
	  GUIDelete($cGUI)
	  CreateChild()
   EndSwitch
EndFunc

Func About()
   ShellExecute("notepad.exe", @ScriptDir & "\Readme.txt")
EndFunc

Func CheckboxButton()
   If (CheckboxState() > 0) Then
	  GUICtrlSetState($delete, $GUI_ENABLE)
   Else
	  GUICtrlSetState($delete, $GUI_DISABLE)
   EndIf
EndFunc

Func AddNewButton()
   Local $newFile = 0
   Local $p1, $p2, $p3, $p4
   $newFile = FileOpenDialog("Выберите PNG изображение", @DesktopDir & "\", "Изображения (*.png)", $FD_FILEMUSTEXIST, "", $hGui)
   If Not $newFile = 0 Then
	  _PathSplit($newFile, $p1, $p2, $p3, $p4)
	  Local $name = $p3 & $p4
	  If FileExists($pathToImage & $p3 & $p4) Then
		 $name = $p3 & "_" & @YEAR & @MON & @MDAY & "_" & @HOUR & @MIN & @SEC & $p4
	  EndIf
	  FileCopy($newFile, $pathToImage & $name, $FC_CREATEPATH)
	  ShellExecuteWait($pathToImage & "convert.exe", '"' & $pathToImage & $name & '"' & " -alpha Remove -resize 500 " & '"' & $pathToImage & $name & '"' & ".jpg", $pathToImage, Default, @SW_HIDE)

	  GUISetState(@SW_DISABLE)

	  Local $chooseTime = GUICreate("Добавление нового изображения", 526, 200, -1, -1, $DS_MODALFRAME, $WS_EX_WINDOWEDGE, $hGUI)
	  GUISetFont(10)
	  GUICtrlCreateLabel("Укажите дату прекращения показов:", 10, 7)
	  Local $stopDay = GUICtrlCreateDate("", 238, 5, 90, 20, $DTS_SHORTDATEFORMAT)
	  GUICtrlSetState(-1, $GUI_DISABLE)
	  Local $cRestrict = GUICtrlCreateCheckbox("без ограничения", 338, 3)
	  GUICtrlSetState(-1, $GUI_CHECKED)
	  GUICtrlSetFont(-1, 10)

	  Local $hImage = _GDIPlus_ImageLoadFromFile($pathToImage & $name & ".jpg")
	  Local $imageWidth = _GDIPlus_ImageGetWidth($hImage)
	  Local $imageHeight = _GDIPlus_ImageGetHeight($hImage)
	  _GDIPlus_ImageDispose($hImage)
	  GUICtrlCreatePic($pathToImage & $name & ".jpg", 10, 30, $imageWidth, $imageHeight)

	  Local $bContinue = GUICtrlCreateButton("Продолжить", 265, 40 + $imageHeight, 245, 30, $BS_CENTER)
	  Local $bCancel = GUICtrlCreateButton("Отмена", 10, 40 + $imageHeight, 245, 30, $BS_CENTER)
	  WinMove("Добавление нового изображения", "", @DesktopWidth / 2 - 263, @DesktopHeight / 2 - (108 + $imageHeight) / 2, 526, 108 + $imageHeight)

	  GUISetState();

	  Opt("GUIOnEventMode", 0)

	  Local $msg = 0
	  Local $needToExit = False

	  While $needToExit = False
		 $msg = GUIGetMsg()
		 Switch $msg
		 Case $bContinue
			If GUICtrlRead($cRestrict) = $GUI_CHECKED Then
			   IniWrite($iniFile, "main", $name, 0)
			Else
			   Local $tempDate = StringSplit(GUICtrlRead($stopDay), ".")
			   If $tempDate[0] = 3 Then
				  IniWrite($iniFile, "main", $name, $tempDate[3] & "." & $tempDate[2] & "." & $tempDate[1])
			   EndIf
			EndIf

			$needToExit = True
			GUIDelete($cGUI)
			CreateChild()
		 Case $bCancel
			$needToExit = True
			FileDelete($pathToImage & $name)
			FileDelete($pathToImage & $name & ".jpg")
		 Case $cRestrict
			If GUICtrlRead($cRestrict) = $GUI_CHECKED Then
			   GUICtrlSetState($stopDay, $GUI_DISABLE)
			Else
			   GUICtrlSetState($stopDay, $GUI_ENABLE)
			EndIf
		 EndSwitch
	  WEnd

	  GUIDelete($chooseTime)
	  Opt("GUIOnEventMode", 1)
	  GUISwitch($hGUI)
	  GUISetState(@SW_ENABLE)
	  GUISwitch($cGUI)
	  GUISetState(@SW_ENABLE)
	  WinActivate("Manage")
   EndIf
EndFunc

Func CloseGui()
   If FileExists($iniFile) Then
	  FileDelete($iniFile)
   EndIf

   For $i = 0 to UBound($elements, $UBOUND_COLUMNS) - 1
	  If GuiCtrlRead($elements[0][$i]) = $GUI_UNCHECKED Then
		 IniWrite($iniFile, "main", $elements[3][$i], 0)
	  Else
		 Local $tempDate = StringSplit(GUICtrlRead($elements[1][$i]), ".")
		 If $tempDate[0] = 3 Then
			IniWrite($iniFile, "main", $elements[3][$i], $tempDate[3] & "." & $tempDate[2] & "." & $tempDate[1])
		 EndIf
	  EndIf
   Next

   _GDIPlus_Shutdown()
   GUIDelete($hGUI)
   Exit
EndFunc

Func CreateChild()
   $imagesNames = _FileListToArray(@ScriptDir & "\Images\", "*.png", $FLTA_FILES)
   If IsArray($imagesNames) Then
	  Local $temp
	  For $i=0 To UBound($imagesNames) - 1
		 For $x = 1 To UBound($imagesNames) - 1
			If FileGetTime($pathToImage & $imagesNames[$i], $FT_CREATED, $FT_STRING) > FileGetTime($pathToImage & $imagesNames[$x], $FT_CREATED, $FT_STRING) then
			   $temp = $imagesNames[$i]
			   $imagesNames[$i] = $imagesNames[$x]
			   $imagesNames[$x] = $temp
			EndIf
		 Next
	  Next
   EndIf

   $cGUI = GUICreate("", 577, @DesktopHeight - 145, 0, 45, $WS_CHILD, -1, $hGUI)
   GUISetFont(10)
   GUISetBkColor($COLOR_WHITE)

   $aCount = 0
   $initialY = 10
   Local $newArray[5]
   $elements = $newArray

   If IsArray($imagesNames) Then
	  For $fileName In $imagesNames
		 If StringInStr($fileName, ".png") > 1 Then
			If FileExists($pathToImage & $fileName & ".jpg") = False Then
			   ShellExecuteWait($pathToImage & "convert.exe", '"' & $fileName & '"' & " -alpha Remove -resize 500 " & '"' & $fileName & '"' & ".jpg", $pathToImage, Default, @SW_HIDE)
			EndIf

			Local $hImage = _GDIPlus_ImageLoadFromFile($pathToImage & $fileName & ".jpg")
			Local $imageWidth = _GDIPlus_ImageGetWidth($hImage)
			Local $imageHeight = _GDIPlus_ImageGetHeight($hImage)
			_GDIPlus_ImageDispose($hImage)
			_ArrayColInsert($elements, $aCount)
			Local $tempDate = IniRead($iniFile, "main", $fileName, 0)

			GUICtrlCreateGroup("", 10, $initialY, 540, $imageHeight + 60)

			GUICtrlCreatePic($pathToImage & $fileName & ".jpg", 20, $initialY + 45, $imageWidth, $imageHeight)

			$elements[0][$aCount] = GUICtrlCreateCheckbox("Прекратить показывать:", 21, $initialY + 14)
			GUICtrlSetState(-1, ($tempDate = 0) ? $GUI_UNCHECKED : $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "StopDateCheckbox")

			$elements[1][$aCount] = GUICtrlCreateDate($tempDate, 189, $initialY + 16, 90, 20, $DTS_SHORTDATEFORMAT)
			GUICtrlSetState(-1, ($tempDate = 0) ? $GUI_DISABLE : $GUI_ENABLE)
			GuiCtrlSetOnEvent(-1, "CheckDate")

			$elements[2][$aCount] = GUICtrlCreateCheckbox("Удалить", 476, $initialY + 14)
			GUICtrlSetOnEvent(-1, "CheckboxButton")

			$elements[4][$aCount] = GUICtrlCreateLabel("(прекращено)", 289, $initialY + 16, 90, 20, $SS_CENTER)
			GUICtrlSetBkColor(-1, $COLOR_YELLOW)

			If $tempDate > @YEAR & "." & @MON & "." & @MDAY Or $tempDate = 0 Then
			   GUICtrlSetState(-1, $GUI_HIDE)
			EndIf

			$elements[3][$aCount] = $fileName
			$aCount += 1
			GUICtrlCreateGroup("", -99, -99, 1, 1)
			$initialY += $imageHeight + 80
		 EndIf
	  Next
	  _ArrayColDelete($elements, $aCount)

	  If ($initialY - 20 < @DesktopHeight - 100) then
		 _GuiScrollbars_Generate($cGUI, -1, $initialY - 20)
		 WinMove("Manage", "", @DesktopWidth / 2 - 567 / 2, @DesktopHeight / 2 - ($initialY + 65) / 2, 567, $initialY + 65, 2)
	  Else
		 _GuiScrollbars_Generate($cGUI, -1, $initialY)
		 WinMove("Manage", "", @DesktopWidth / 2 - 583 / 2, @DesktopHeight / 2 - (@DesktopHeight - 70) / 2, 583, @DesktopHeight - 100, 2)
	  EndIf
   Else
	  GUICtrlCreateLabel("Нет изображений", 0, 10, 567, 20, $SS_CENTER)
	  GUICtrlSetFont(-1, 12)
	  GUICtrlCreateLabel("Вы можете добавить изображения воспользовавшись соответствующей кнопкой сверху", 0, 35, 567, 100, $SS_CENTER)
	  GUICtrlSetFont(-1, 10)
	  WinMove("Manage", "", @DesktopWidth / 2 - 567 / 2, @DesktopHeight / 2 - 137 / 2, 567, 137, 2)
   EndIf

   GUISetState(@SW_SHOW)
   GUISwitch($hGUI)
   GUISetState(@SW_SHOW)
EndFunc

Func StopDateCheckbox()
   For $i = 0 to UBound($elements, $UBOUND_COLUMNS) - 1
	  If GuiCtrlRead($elements[0][$i]) = $GUI_CHECKED Then
		 GUICtrlSetState($elements[1][$i], $GUI_ENABLE)
	  Else
		 GUICtrlSetState($elements[1][$i], $GUI_DISABLE)
	  EndIf
   Next
   CheckDate()
EndFunc

Func CheckDate()
   For $i = 0 to UBound($elements, $UBOUND_COLUMNS) - 1
	  Local $tempDate = StringSplit(GUICtrlRead($elements[1][$i]), ".")
	  Local $tempRestrict = GUICtrlRead($elements[0][$i])

	  If $tempDate[0] = 3 And $tempDate[3] & "." & $tempDate[2] & "." & $tempDate[1] <= @YEAR & "." & @MON & "." & @MDAY And $tempRestrict = $GUI_CHECKED Then
		 GUICtrlSetState($elements[4][$i], $GUI_SHOW)
	  Else
		 GUICtrlSetState($elements[4][$i], $GUI_HIDE)
	  EndIf
   Next
EndFunc