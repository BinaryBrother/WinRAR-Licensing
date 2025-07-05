#include-once
#include <Constants.au3>
#include <Misc.au3>

Func _GenerateLicense($pName, $pType = "Single PC usage license")
	Local $sProgramPath = @TempDir & "\winrar-keygen-x64.exe"
	If Not FileExists($sProgramPath) Then
		_Debug("_GenerateLicense", "WinRAR keygen executable not found at: " & $sProgramPath)
		Return SetError(1, 0, False)
	EndIf

	Local $sCommand = '"' & $sProgramPath & '" "' & $pName & '" "' & $pType & '"'
	Local $sOutput = _ReturnConsole($sCommand)

	If @error Then
		_Debug("_GenerateLicense", "Error running WinRAR keygen: " & @error)
		Return SetError(2, 0, False)
	EndIf

	Return $sOutput

EndFunc   ;==>_GenerateLicense


Func _ReturnConsole($sProgramPath)
	Local $iPID = Run($sProgramPath, "", @SW_HIDE, $STDOUT_CHILD)
	Local $sOutput = "", $sLine
	While 1
		$sLine = StdoutRead($iPID)
		If @error Then ExitLoop
		$sOutput &= $sLine
	WEnd
	Return $sOutput
EndFunc   ;==>_ReturnConsole

Func _FileGetPath($sFullPath)
	; Returns the directory from a full path string.
	Local $iLastSlash = StringInStr($sFullPath, "\", 0, -1)
	If $iLastSlash = 0 Then
		_Debug("_FileGetPath", "No directory found in the path: " & $sFullPath)
		Return SetError(1, 0, False)
	Else
		Return StringLeft($sFullPath, $iLastSlash - 1)
	EndIf
EndFunc   ;==>_FileGetPath

Func _Debug($pFunction, $pData)
	ConsoleWrite("[" & $pFunction & "] " & $pData & @CRLF)
EndFunc   ;==>_Debug

Func _WinRAR_GetPath($pWinRAR_RegistryPath, $pWinRAR_DefaultPath)
	Local $sWinRAR_RegistryPath = RegRead($pWinRAR_RegistryPath[0], $pWinRAR_RegistryPath[1])
	If @error Then
		_Debug("_WinRAR_GetFullPath", "WinRAR executable NOT found at the registry path: " & $pWinRAR_RegistryPath[0] & "\" & $pWinRAR_RegistryPath[1])
		_Debug("_WinRAR_GetFullPath", "Checking default installation path...")
		If FileExists($pWinRAR_DefaultPath) Then
			_Debug("_WinRAR_GetFullPath", "WinRAR found at $WinRAR_DefaultPath = " & $pWinRAR_DefaultPath)
			Return _FileGetPath($pWinRAR_DefaultPath)
		Else
			_Debug("_WinRAR_GetFullPath", "WinRAR executable NOT found. Are you sure WinRAR is installed?")
			Return SetError(2, 0, False)
		EndIf
	Else
		_Debug("_WinRAR_GetFullPath", "WinRAR found in registry path: " & $sWinRAR_RegistryPath)
		If FileExists($sWinRAR_RegistryPath) Then
			_Debug("_WinRAR_GetFullPath", "WinRAR found in filesystem at: " & $sWinRAR_RegistryPath)
			Return _FileGetPath($sWinRAR_RegistryPath)
		EndIf
	EndIf
EndFunc   ;==>_WinRAR_GetPath

Func _CloseWinRAR()
	While ProcessExists("WinRAR.exe")
		ProcessClose("WinRAR.exe")
	WEnd
EndFunc   ;==>_CloseWinRAR

Func _ShowLicenseWindow($pWinRAR_FullPath)
	_Debug("_ShowLicenseWindow", "Showing WinRAR license window...")
	Local $lRun = ShellExecute($pWinRAR_FullPath)
	If @error Then
		_Debug("_ShowLicenseWindow", "WARNING: Failed to launch window.")
	Else
        _Debug("_ShowLicenseWindow", "WinRAR launched successfully.")
		While Not WinActive("[CLASS:WinRarWindow]")
			WinActivate("[CLASS:WinRarWindow]")
			Sleep(100)
		WEnd
		_Debug("_ShowLicenseWindow", "WinRAR window is now active.")
	EndIf
	SendKeepActive("[CLASS:WinRarWindow]")
	Send("{ALT}")
	Sleep(500)
	Send("h")
	Sleep(500)
	Send("a")
	_Debug("_ShowLicenseWindow", "License window should now be active.")
	;Local $hWinRAR = WinGetHandle("[CLASS:WinRAR]")
EndFunc   ;==>_ShowLicenseWindow

Func _Exit()
	ConsoleWrite("Press RETURN/ENTER to exit!")
	While Not _IsPressed("0D")
		Sleep(50)
	WEnd
	Exit
EndFunc   ;==>_Exit
