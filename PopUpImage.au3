#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <StaticConstants.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>

Global Const $delayIfError = 15000
Global Const $filePath = @ScriptDir & "\Settings.ini"
Global Const $imageIni = @ScriptDir & "\Images\Images.ini"

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

If Not FileExists(@ScriptDir & "\Logs") Then
   DirCreate(@ScriptDir & "\Logs")
EndIf

If FileExists(@ScriptDir & "\Logs\" & @ComputerName & ".log") Then
   FileDelete(@ScriptDir & "\Logs\" & @ComputerName & ".log")
EndIf
_FileCreate(@ScriptDir & "\Logs\" & @ComputerName & ".log")

While 1
   If Not FileExists($filePath) Then
	  WriteToLog("Не удается прочитать настройки, возможно отсутствует файл Settings.ini")
	  Sleep($delayIfError)
	  ContinueLoop
   EndIf

   Local $fileHandler
   Local $fileContent
   $fileHandler = FileOpen($filePath)
   $fileContent = FileReadToArray($fileHandler)
   FileClose($fileHandler)

   If $fileContent = 0 Then
	  WriteToLog("Не удается прочитать настройки, файл Settings.ini не содержит информации")
	  Sleep($delayIfError)
	  ContinueLoop
   EndIf

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

   If($intervalBetweenImagesUnit = "секунд") Then
	  $intervalBetweenImages *= 1000
   ElseIf ($intervalBetweenImagesUnit = "минут") Then
	  $intervalBetweenImages *= 1000 * 60
   ElseIf ($intervalBetweenImagesUnit = "часов") Then
	  $intervalBetweenImages *= 1000 * 60 * 60
   EndIf

   If ($showingTimeUnit = "секунд") Then
	  $showingTime *= 1000
   ElseIf ($showingTimeUnit = "минут") Then
	  $showingTime *= 1000 * 60
   ElseIf ($showingTimeUnit = "часов") Then
	  $showingTime *= 1000 * 60 * 60
   EndIf

   If $showNotification  = 0 Then
	  Sleep($delayIfError)
	  ContinueLoop
   EndIf

   If $intervalBetweenImages < 0 Or _
	  $showingTime < 0 Or _
	  $bottomGap < 0 Or _
	  $moveSpeed < 1 Or _
	  $moveSpeed > 18 Then
	  WriteToLog("Некорректные настройки в файле Settings.ini, невозможно продолжить показ")
	  Sleep($delayIfError)
	  ContinueLoop
   EndIf

   Local $imagesNames = _FileListToArray(@ScriptDir & "\Images\", "*.png", $FLTA_FILES)

   If IsArray($imagesNames) Then
	  Local $newArray[1]
	  For $i = 1 to UBound($imagesNames) - 1
		 Local $tempString = $imagesNames[$i]
		 Local $tempDate = IniRead($imageIni, "main", $tempString, 0)
		 If $tempDate <> 0 And $tempDate > @YEAR & "." & @MON & "." & @MDAY Or $tempDate = 0 Then
			_ArrayAdd($newArray, $imagesNames[$i])
		 EndIf
	  Next

	  If UBound($newArray) > 1 Then
		 $imagesNames = $newArray
	  Else
		 $imagesNames = 0
	  EndIf
   EndIf

   If @error > 0 Or Not IsArray($imagesNames) Or UBound($imagesNames) < 2 Then
	  WriteToLog("В папке с программой отсутсвуют файлы изображений с именем *.png")
	  Sleep($delayIfError)
	  ContinueLoop
   EndIf

   Local $imageFileName = $imagesNames[Random(1, Ubound($imagesNames) - 1, 1)]

   ShowImage(@ScriptDir & "\Images\" & $imageFileName)
   Sleep($intervalBetweenImages)
WEnd

Func WriteToLog($textToLog)
   If $writeToLog = 1 Then
	  Local $logHandler = FileOpen(@ScriptDir & "\Logs\" & @ComputerName & ".log", 1)
	  _FileWriteLog($logHandler, $textToLog)
	  FileClose($logHandler)
   EndIf
EndFunc

Func ShowImage($fullImagePath)
   _GDIPlus_Startup()

   Local $imageWidth = 0
   Local $imageHeight = 0
   Local $hImage = _GDIPlus_ImageLoadFromFile($fullImagePath)
   If Not @error Then
	  $imageWidth = _GDIPlus_ImageGetWidth($hImage)
	  $imageHeight = _GDIPlus_ImageGetHeight($hImage)
   EndIf
   _GDIPlus_ImageDispose ($hImage)

   If $imageWidth = 0 Or $imageHeight = 0 Then
	  WriteToLog("Ошибка загрузки изображения " & $imageFileName)
	  Sleep($delayIfError)
	  Return
   EndIf

   Local $whereToMoveX = @DesktopWidth/2-$imageWidth/2
   Local $whereToMoveY = @DesktopHeight-$imageHeight-$bottomGap
   Local $leftTopX = 10
   Local $leftTopY = $whereToMoveY - $minimalDistanceToText
   Local $rightBottomX = @DesktopWidth - 10
   Local $rightBottomY = $leftTopY + $imageHeight + $minimalDistanceToText * 2

   Local $whereIsBlack = PixelSearch($leftTopX, $leftTopY, $rightBottomX, $rightBottomY, "0x" & $textColor)
   If Not @error And $doNotCoverText = 1 Then
	  WriteToLog("Невозможно отобразить изображение " & $imageFileName & " т.к. в области показа присутствует текст")
	  Sleep($delayIfError)
	  Return
   EndIf

   Local $fileName = @ScriptDir & "\Images\" & $imageFileName

   Local $GUI = _GUICreate_Alpha("PopUpImage", $fileName, -$imageWidth, $whereToMoveY)
   Local $myGuiHandle = WinGetHandle("PopUpImage")
   GUISetState()

   WinMove($myGuiHandle, Default, $whereToMoveX, $whereToMoveY, Default, Default, $moveSpeed)
   Sleep($showingTime)
   WinMove($myGuiHandle, Default, @DesktopWidth + $imageWidth, $whereToMoveY, Default, Default, $moveSpeed)

   GUIDelete($myGuiHandle)
   _GDIPlus_Shutdown()
EndFunc

Func _GUICreate_Alpha($sTitle, $sPath, $iX, $iY, $iOpacity=255)
    Local $hGUI, $hImage, $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend
    $hImage = _GDIPlus_ImageLoadFromFile($sPath)
    $width = _GDIPlus_ImageGetWidth($hImage)
    $height = _GDIPlus_ImageGetHeight($hImage)
    $hGUI = GUICreate($sTitle, $width, $height, $iX, $iY, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
    $hScrDC = _WinAPI_GetDC(0)
    $hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
    $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	_GDIPlus_ImageDispose($hImage)
    $hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
    $tSize = DllStructCreate($tagSIZE)
    $pSize = DllStructGetPtr($tSize)
    DllStructSetData($tSize, "X", $width)
    DllStructSetData($tSize, "Y", $height)
    $tSource = DllStructCreate($tagPOINT)
    $pSource = DllStructGetPtr($tSource)
    $tBlend = DllStructCreate($tagBLENDFUNCTION)
    $pBlend = DllStructGetPtr($tBlend)
    DllStructSetData($tBlend, "Alpha", $iOpacity)
    DllStructSetData($tBlend, "Format", 1)
    _WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, 2)
    _WinAPI_ReleaseDC(0, $hScrDC)
    _WinAPI_SelectObject($hMemDC, $hOld)
    _WinAPI_DeleteObject($hBitmap)
    _WinAPI_DeleteObject($hImage)
    _WinAPI_DeleteDC($hMemDC)
EndFunc