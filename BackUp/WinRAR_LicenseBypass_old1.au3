const $WinRAR_RegistryPath[2] = ["HKEY_CURRENT_USER\Software\WinRAR", "exe64"]
const $WinRAR_DefaultPath = @ProgramFilesDir & "\WinRAR\WinRAR.exe"

$WinRAR_FullPath = RegRead($WinRAR_RegistryPath[0], $WinRAR_RegistryPath[1])
If @error Then
    ConsoleWrite("[Main] WinRAR is not installed or the registry key is missing.")
Else
    If FileExists($WinRAR_FullPath) Then
        ConsoleWrite("WinRAR is installed at: " & $WinRAR_FullPath & @CRLF)
    elseif FileExists($WinRAR_DefaultPath) Then
        $WinRAR_FullPath = $WinRAR_DefaultPath
        ConsoleWrite("WinRAR is installed at the default path: " & $WinRAR_FullPath & @CRLF)
    Else
        ConsoleWrite("WinRAR executable not found at the expected locations." & @CRLF)
EndIf
EndIf

