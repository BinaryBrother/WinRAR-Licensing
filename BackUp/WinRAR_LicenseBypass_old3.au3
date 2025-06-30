#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region ##### Includes #####
#include <MsgBoxConstants.au3>
#EndRegion ##### Includes #####

#Region ##### Variables #####
Global Const $WinRAR_RegistryPath[2] = ["HKEY_CURRENT_USER\Software\WinRAR", "exe64"]
Global Const $WinRAR_DefaultPath = @ProgramFilesDir & "\WinRAR\WinRAR.exe"
#EndRegion ##### Variables #####

#Region ##### [Main Thread] #####
$WinRAR_FullPath = _WinRAR_GetFullPath()
FileInstall(".\rarreg.key", _FileGetPath($WinRAR_FullPath) & "\rarreg.key", 1)
_Debug("[MAIN]", _FileGetPath($WinRAR_FullPath))
If @error Then
    _Debug("MAIN", "Error installing the license file: " & @error)
    MsgBox($MB_ICONERROR, "Error", "Failed to install the WinRAR license file.")
Else
    _Debug("Main Thread", "License file installed successfully.")
    MsgBox($MB_ICONINFORMATION, "Success", "WinRAR license file installed successfully.")
EndIf
Sleep(30000)

#EndRegion ##### [Main Thread] #####

#Region ##### UDFs #####
Func _FileGetPath($pPath)
    local $lReturn
    $lReturn = StringRegExp($pPath, "^(.*\\)([^\\]+)$")
	If IsArray($lReturn) Then
    Return $lReturn[1]
	Else
		Return SetError(1,0, False)
EndIf

EndFunc
Func _Debug($pFunction, $pData)
	ConsoleWrite($pFunction & ": " & $pData & @CRLF)
EndFunc   ;==>_Debug
Func _WinRAR_GetFullPath()
    Local $sWinRAR_RegistryPath = RegRead($WinRAR_RegistryPath[0], $WinRAR_RegistryPath[1])
    If Not @error And $sWinRAR_RegistryPath <> "" Then
        _Debug("_WinRAR_GetFullPath()", "WinRAR found in Registry: " & $sWinRAR_RegistryPath)
        If FileExists($sWinRAR_RegistryPath) Then
            _Debug("_WinRAR_GetFullPath()", "WinRAR found on FileSystem: " & $sWinRAR_RegistryPath)
            Return $sWinRAR_RegistryPath
        Else
            _Debug("_WinRAR_GetFullPath()", "WinRAR executable not found at the registry path: " & $sWinRAR_RegistryPath)
            Return SetError(1,0, False)
        EndIf
    Else ; WinRAR not found in registry.
        _Debug("_WinRAR_GetFullPath()", "WinRAR executable NOT found at the registry path: " & $sWinRAR_RegistryPath)
        _Debug("_WinRAR_GetFullPath()", "Checking default installation path...")
        If FileExists($WinRAR_DefaultPath) Then
            _Debug("_WinRAR_GetFullPath()", "WinRAR found at $WinRAR_DefaultPath = " & $WinRAR_DefaultPath)
            Return $WinRAR_DefaultPath
        Else
            _Debug("_WinRAR_GetFullPath()", "WinRAR executable NOT found.")
            Return SetError(2,0, False)
        EndIf
    EndIf
EndFunc
#EndRegion ##### UDFs #####