#include <ScreenCapture.au3>

; Last update: 14.10.2024
; Version 1.9

Global $configFile = "catsVsAlien.ini"


Global $winTitle = IniRead($configFile, "Settings", "winTitle", "TelegramDesktop")
Global $searchText = IniRead($configFile, "Settings", "searchText", "Cat Vs Alien")
Global $restartHour = IniRead($configFile, "Settings", "restartHour", 3) 
Global $loopMins = IniRead($configFile, "Settings", "loopMins", 5)

If Not FileExists($configFile) Then
    MsgBox(0, "Error", "Config file not found: " & $configFile)
Else
	TimeLog("Config file " & $configFile & " successfully read!" & @CRLF)
EndIf

Global $noRestartCounter = 0


; WinWaitActive("TelegramDesktop", $searchText)

; Local $hWnd = WinGetHandle("[TITLE:TelegramDesktop; TEXT:" & $searchText & "]")

; Local $hWnd = WinGetHandle("[TITLE:" & $winTitle & "]")


Func findClickRoutine()
	While True
		TimeLog("Searching: " & $winTitle & " - " & $searchText & @CRLF)
		Local $hWnd = WinGetHandle($winTitle, $searchText)
		if $hWnd Then
			TimeLog($searchText & " Window: " & $hWnd & @CRLF)
			TimeLog($searchText & " Window: " & $hWnd & @CRLF)
			; TimeLog("NoResCounter:" & $noRestartCounter & " Hour: " & @HOUR * 1 & "/" & $restartHour & @CRLF)

			WinActivate($hWnd)
			Sleep(100)
			WinWaitActive($hWnd)

			if $noRestartCounter > 0 Then
				TimeLog("No restart minutes counter: " & $noRestartCounter & @CRLF)
				$noRestartCounter -= $loopMins
			Elseif @HOUR * 1 = $restartHour Then
				TimeLog("Restarting " & $searchText & @CRLF)
				restartGame($hWnd)
				Sleep(1000)
				$noRestartCounter = 60
				Sleep(60000)
			EndIf

			closeAll($hWnd)

			if isPromoted($hWnd) Then
				clickGreenButton($hWnd)
				Sleep(1000)
			EndIf

			if (click400Boost($hWnd)) Then
				Sleep(1000)
				clickYellowButton($hWnd)
				Sleep(1000)
				clickRedCloseButton($hWnd)
				Sleep(1000)
			EndIf

			if (clickGoldBonus($hWnd)) Then
				Sleep(1000)
				clickYellowButton($hWnd)
				Sleep(1000)
				clickRedCloseButton($hWnd)
				Sleep(1000)
			EndIf

			if (claimOnlineBonus($hWnd)) Then
				Sleep(3000)
				clickOrangeButton($hWnd)
				Sleep(1000)
				clickGreenButton($hWnd)
				Sleep(1000)
			EndIf

			click100Boost($hWnd)
			Sleep(1000)
			clickYellowButton($hWnd)
			Sleep(1000)

			clickRedCloseButton($hWnd)
			Sleep(1000)
			clickAutoMerge($hWnd)
			Sleep(1000)
			clickYellowButton($hWnd)
			Sleep(1000)

			closeAll($hWnd)
		Else
			ConsoleWriteError("Window not found!")
		EndIf

		TimeLog("Sleeping " & $loopMins & " min." & @CRLF)
		Sleep($loopMins * 60000)
	WEnd
EndFunc
findClickRoutine()

Func clickPixelByColor($hWnd, $expectedColor, $button = "left", $directon = "normal")
	Local $pos = WinGetPos($hWnd)

	Local $x1 = $pos[0]
	Local $y1 = $pos[1]
	Local $x2 = $pos[0] + $pos[2]
	Local $y2 = $pos[1] + $pos[3]

	if $directon = "reverse" Then
		Local $temp

		$temp = $x1
		$x1 = $x2
		$x1 = $temp

		$temp = $y1
		$y1 = $y2
		$y2 = $temp
	EndIf

	ConsoleWrite("Searching: " & Hex($expectedColor) & " in X: " & $x1 & "-" & $x2 & ", Y: " & $y1 & "-" & $y2 & @CRLF)

	$pixelPos = PixelSearch($x1, $y1, $x2, $y2, $expectedColor, 0)

	If @error Then
		ConsoleWrite("Pixel not found" & @CRLF)
		return false
	EndIf

	ConsoleWrite("Clicking: " & $pixelPos[0] & ", " & $pixelPos[1] & " Color: " & Hex($expectedColor) & @CRLF)
	return clickPixelByColorWindow($hWnd, $pixelPos, $expectedColor, $button)
EndFunc

Func clickPixelByColorWindow($hWnd, $pixelPos, $expectedColor, $button = "left")
	MouseClick($button, $pixelPos[0], $pixelPos[1])
	return true
EndFunc

Func clickPixelByColorGlobal($hWnd, $pixelPos, $expectedColor)

	Local $xClick = $pixelPos[0]
	Local $yClick = $pixelPos[1]
	; ConsoleWrite("Window X: " & $pixelPos[0] & " Y: " & $pixelPos[1] & @CRLF)

	; Add desktop coords
	; $xClick += $pos[0]
    ; $yClick += $pos[1]

	; ConsoleWrite("Absolute X: " & $pixelPos[0] & " Y: " & $pixelPos[1] & @CRLF)

    ; WinAPI 
    Local $WM_LBUTTONDOWN = 0x0201
    Local $WM_LBUTTONUP = 0x0202

    DllCall("user32.dll", "long", "SendMessage", "hwnd", $hWnd, "int", $WM_LBUTTONDOWN, "int", 1, "int", BitShift($xClick, 0) + BitShift($yClick, 16))
    ; PostMessage($hWnd, "int", $WM_LBUTTONDOWN, 1, BitShift($xClick, 0) + BitShift($yClick, 16))
    Sleep(10)
    DllCall("user32.dll", "long", "SendMessage", "hwnd", $hWnd, "int", $WM_LBUTTONUP, "int", 0, "int", BitShift($xClick, 0) + BitShift($yClick, 16))
    ; PostMessage($hWnd, "int", $WM_LBUTTONUP, 0, BitShift($xClick, 0) + BitShift($yClick, 16))
    return true
EndFunc

Func clickButtonByColor($hWnd, $xCoord, $yCoord, $expectedColor)
	If $hWnd Then

		Local $windowText = WinGetText($hWnd)

		; ConsoleWrite("Window found. Text:" & @CRLF & $windowText & @CRLF)

		Local $pixelColor = PixelGetColor($xCoord, $yCoord)


        If $pixelColor = $expectedColor Then
			ConsoleWrite("Clicking: " & Hex($pixelColor) & @CRLF)
			MouseClick("left", $xCoord, $yCoord)
			return true
		Else
			ConsoleWrite("Click not done. Color: " & Hex($pixelColor) & @CRLF)
		EndIf
	Else
		ConsoleWriteError("Window not found!")
	EndIf
	return false
EndFunc

Func claimOnlineBonus($hWnd)
	ConsoleWrite("Checking online bonus - ")
	; ConsoleWrite("DISABLED")
	; return false
	; Click on just on red pixelbonus works incorrectly
	; return clickPixelByColor($hWnd, 0xC31508)
	; return clickPixelByColor($hWnd, 0xFFEB4A)
	return clickPixelByColor($hWnd, 0xE14E26)
EndFunc

Func isPromoted($hWnd)
	ConsoleWrite("Checking promotion - ")
	return clickPixelByColor($hWnd, 0x6AF8EF)
EndFunc

Func clickGreenButton($hWnd)
	ConsoleWrite("Clicking green button - ")
	return clickPixelByColor($hWnd, 0x94FF0D)
EndFunc

Func clickYellowButton($hWnd)
	; ConsoleWrite("Checking window" & @CRLF)
	; Local $xCoord = 117 ; X
	; Local $yCoord = 457 ; Y

	; Local $expectedColor = 0xFFEC0C
	ConsoleWrite("Clicking yellow button - ")
	; return clickButtonByColor($hWnd, 117, 457, 0xFFEC0C)
	return clickPixelByColor($hWnd, 0xFFEC0C)
EndFunc

Func clickOrangeButton($hWnd)
	ConsoleWrite("Clicking orange button - ")
	return clickPixelByColor($hWnd, 0xFFC001)
EndFunc

Func closeAll($hWnd)
	while clickRedCloseButton($hWnd)
		Sleep(1000)
	WEnd
	while clickRed2CloseButton($hWnd)
		Sleep(1000)
	WEnd
	while clickRed3CloseButton($hWnd)
		Sleep(1000)
	WEnd
EndFunc


Func clickRedCloseButton($hWnd)
	ConsoleWrite("Clicking red close button - ")
	return clickPixelByColor($hWnd, 0xDC295D)
EndFunc

Func clickRed2CloseButton($hWnd)
	ConsoleWrite("Clicking red-2 close button - ")
	return clickPixelByColor($hWnd, 0xDB3E37)
EndFunc

Func clickRed3CloseButton($hWnd)
	ConsoleWrite("Clicking red-3 close button - ")
	return clickPixelByColor($hWnd, 0xE44139)
EndFunc

Func clickAutoMerge($hWnd)
	TimeLog("Clicking auto merge button - ")
	; return clickButtonByColor($hWnd, 294, 581, 0xE9FCFF)
	return clickPixelByColor($hWnd, 0xE9FCFF, "left", "reverse")
EndFunc

Func clickGoldBonus($hWnd)
	TimeLog("Clicking gold bonus button - ")
	; return clickPixelByColor($hWnd, 0xFDEA66)
	; return clickPixelByColor($hWnd, 0xFFEA21)
	; return clickPixelByColor($hWnd, 0x893608)
	return clickPixelByColor($hWnd, 0x9C3C08)
EndFunc

Func click100Boost($hWnd)
	TimeLog("Clicking 100% boost button - ")
	; return clickButtonByColor($hWnd, 99, 583, 0xADE0EE)
	return clickPixelByColor($hWnd, 0xADE0EE)
EndFunc

Func click400Boost($hWnd)
	TimeLog("Clicking 400% boost button - ")
	; return clickButtonByColor($hWnd, 321, 472, 0x1E201E)
	; return clickPixelByColor($hWnd, 0x1E201E)
	; return clickPixelByColor($hWnd, 0xDB5521)
	; return clickPixelByColor($hWnd, 0x101008)
	return clickPixelByColor($hWnd, 0xEC7133)
EndFunc


Func findWindow()
	Local $aList = WinList($winTitle, $searchText)

	; Loop through the array displaying only visable windows with a title.
	For $i = 1 To $aList[0][0]
		If $aList[$i][0] <> "" And BitAND(WinGetState($aList[$i][1]), 2) Then
			ConsoleWrite("Title: " & $aList[$i][0] & @CRLF & "Handle: " & $aList[$i][1] & @CRLF)
			clickYellowButton($aList[$i][1])
		EndIf
	Next
EndFunc


; Common
Func restartGame($hWnd)
	send("^R")
	; Sleep(500)
	; makeScreenShot($hWnd)
EndFunc

Func TimeLog($text)
	ConsoleWrite(addTime() & $text)
EndFunc

Func addTime()
	return "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] "
EndFunc

; Func BitShifter($x, $y)
;    Return BitOR($y << 16, $x) ; Объединяем Y в старший байт и X в младший байт
; EndFunc
