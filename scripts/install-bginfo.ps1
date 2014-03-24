
if (!(Test-Path "$env:TEMP\bginfo.exe")) {
  (New-Object Net.WebClient).DownloadFile('http://live.sysinternals.com/bginfo.exe', "$env:TEMP\bginfo.exe")
}
$vbsScript = @'
WScript.Sleep 15000
Dim objShell
Set objShell = WScript.CreateObject( "WScript.Shell" )
objShell.Run("%TEMP%\bginfo.exe /accepteula %TEMP%\bginfo.bgi /silent /timer:0")
'@

$vbsScript | Out-File "$env:TEMP\bginfo.vbs"

Copy-Item "C:\vagrant\scripts\bginfo.bgi" "$env:TEMP\bginfo.bgi"

Set-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name bginfo -Value "wscript $env:TEMP\bginfo.vbs"

