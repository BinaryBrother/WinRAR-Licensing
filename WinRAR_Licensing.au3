#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resources\icons8-winrar-1500.ico
#AutoIt3Wrapper_Outfile_x64=..\WinRAR_Licensing.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region ##### Includes #####
#include <Array.au3>                                         ; added:06/30/25 13:57:23
#include <Misc.au3>                                          ; added:06/30/25 14:18:38
#include <MsgBoxConstants.au3>
#include "./UDFs/WinRAR_Licensing_UDF.au3"
#EndRegion ##### Includes #####

#Region ##### Variables #####
Global Const $gWinRAR_RegistryPath[2] = ["HKLM\Software\WinRAR", "exe64"]
Global Const $gWinRAR_DefaultPath = @ProgramFilesDir & "\WinRAR\WinRAR.exe"
Global $gWinRAR_ActualPath, $gLicenseText, $gAnswer, $gRun
#EndRegion ##### Variables #####

#Region ##### OPTIONS/MISC #####
Opt("MustDeclareVars", 1)
Opt("TrayIconHide", 1)
#EndRegion ##### OPTIONS/MISC #####

; Unpack the WinRAR license generator compiled from https://github.com/bitcookies/winrar-keygen
; We'll use this later.
FileInstall("..\winrar-keygen-x64.exe", @TempDir & "\winrar-keygen-x64.exe", 1)

#Region ##### [Main] #####
; Kill any existing WinRAR processes to avoid conflicts.
_CloseWinRAR()

; Find the WinRAR installation path.
$gWinRAR_ActualPath = _WinRAR_GetPath($gWinRAR_RegistryPath, $gWinRAR_DefaultPath)
If @error Then
	_Debug("MAIN", "Terminal Error.")
	_Exit()
Else
	_Debug("MAIN", "WinRAR path found: " & $gWinRAR_ActualPath)
EndIf

; Now that we've found WinRAR, we can generate the license.
$gLicenseText = _GenerateLicense("True Apps")
If @error Then
	_Debug("MAIN", "Terminal Error.")
	_Exit()
Else
	_Debug("MAIN", "Generated License: " & @CRLF & $gLicenseText & @CRLF)
EndIf

; Prepare the way for the new license file.
FileDelete($gWinRAR_ActualPath & "\rarreg.key")
_Debug("MAIN", "Old license file removed, if it existed.")

; Install the license file in the WinRAR directory.
FileWrite($gWinRAR_ActualPath & "\rarreg.key", $gLicenseText)
_Debug("MAIN", "New license successfully written to: " & $gWinRAR_ActualPath & "\rarreg.key")

_ShowLicenseWindow($gWinRAR_ActualPath & "\WinRAR.exe")

_Exit()

#EndRegion ##### [Main] #####