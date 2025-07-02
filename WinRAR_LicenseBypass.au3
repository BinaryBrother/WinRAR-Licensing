#Region ; *** Dynamically added Include files ***
#include <Array.au3>                                         ; added:06/30/25 13:57:23
#include <Misc.au3>                                          ; added:06/30/25 14:18:38
#EndRegion ; *** Dynamically added Include files ***
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region ##### Includes #####
#include <MsgBoxConstants.au3>
#EndRegion ##### Includes

#Region ##### Variables #####
Global Const $gWinRAR_RegistryPath[2] = ["HKLM\Software\WinRAR", "exe64"]
Global Const $gWinRAR_DefaultPath = @ProgramFilesDir & "\WinRAR\WinRAR.exe"
#EndRegion ##### Variables #####

#Region ##### [Main Thread] #####
$gWinRAR_FullPath = _WinRAR_GetFullPath()
FileInstall(".\rarreg.key", _FileGetPath($gWinRAR_FullPath) & "\rarreg.key", 1)

If @error Then
	_Debug("MAIN", "Error installing the license file: " & @error)
	MsgBox($MB_ICONERROR, "Error", "Failed to install the WinRAR license file.")
Else
	_Debug("Main", "License file installed successfully.")
	MsgBox($MB_ICONINFORMATION, "Success", "WinRAR license file installed successfully.")
EndIf
ConsoleWrite("Press ENTER to exit!")
While Not _IsPressed("0D")
	Sleep(50)
WEnd

Exit
#EndRegion ##### [Main Thread] #####

#Region ##### UDFs #####
Func _FileGetPath($sFullPath)
    ; Returns the directory from a full path string.
    Local $iLastSlash = StringInStr($sFullPath, "\", 0, -1)
    If $iLastSlash = 0 Then Return SetError(1,0,False)
    Return StringLeft($sFullPath, $iLastSlash - 1)
EndFunc   ;==>_FileGetPath
Func _Debug($pFunction, $pData)
	ConsoleWrite($pFunction & ": " & $pData & @CRLF)
EndFunc   ;==>_Debug
Func _WinRAR_GetFullPath()
	Local $sWinRAR_RegistryPath = RegRead($WinRAR_RegistryPath[0], $gWinRAR_RegistryPath[1])
	If Not @error And $sWinRAR_RegistryPath <> "" Then
		_Debug("_WinRAR_GetFullPath()", "WinRAR found in Registry: " & $sWinRAR_RegistryPath)
		If FileExists($sWinRAR_RegistryPath) Then
			_Debug("_WinRAR_GetFullPath()", "WinRAR found on FileSystem: " & $sWinRAR_RegistryPath)
			Return $sWinRAR_RegistryPath
		Else
			_Debug("_WinRAR_GetFullPath()", "WinRAR executable not found at the registry path: " & $sWinRAR_RegistryPath)
			Return SetError(1, 0, False)
		EndIf
	Else ; WinRAR not found in registry.
		_Debug("_WinRAR_GetFullPath()", "WinRAR executable NOT found at the registry path: " & $sWinRAR_RegistryPath)
		_Debug("_WinRAR_GetFullPath()", "Checking default installation path...")
		If FileExists($gWinRAR_DefaultPath) Then
			_Debug("_WinRAR_GetFullPath()", "WinRAR found at $WinRAR_DefaultPath = " & $WinRAR_DefaultPath)
			Return $WinRAR_DefaultPath
		Else
			_Debug("_WinRAR_GetFullPath()", "WinRAR executable NOT found.")
			Return SetError(2, 0, False)
		EndIf
	EndIf
EndFunc   ;==>_WinRAR_GetFullPath
#EndRegion ##### UDFs #####
