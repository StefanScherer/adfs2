If (-not (Test-Path "C:\Program Files\Microsoft Visual Studio 11.0\Common7\IDE\Remote Debugger\x64\msvsmon.exe")) {
  Write-Host "Downloading Visual Studio Remote Debugger"
  $ExeFile = $env:Temp + "\rtools_setup_x64.exe"

  (New-Object Net.WebClient).DownloadFile('http://download.microsoft.com/download/4/1/5/41524F91-4CEE-416B-BB70-305756373937/rtools_setup_x64.exe', $ExeFile)

  Write-Host "Installing Visual Studio Remote Debugger"
  $LogFile = $env:Temp + "\rtools_setup.log";
  Start-Process -FilePath $ExeFile -ArgumentList /install, /passive, /quiet, /norestart, /log, $LogFile -Wait

  & netsh advfirewall firewall add rule name="Remote Debugger (x64)" dir=in action=allow program="%SystemDrive%\Program Files\Microsoft Visual Studio 11.0\Common7\IDE\Remote Debugger\x64\msvsmon.exe" enable=yes
  & netsh advfirewall firewall add rule name="Remote Debugger (x86)" dir=in action=allow program="%SystemDrive%\Program Files\Microsoft Visual Studio 11.0\Common7\IDE\Remote Debugger\x86\msvsmon.exe" enable=yes

  Write-Host "Starting Visual Studio Remote Debugger"
}

  & sc.exe config "msvsmon110" start= auto
  & net start msvsmon110
