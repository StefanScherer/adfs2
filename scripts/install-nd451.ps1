. c:\vagrant\scripts\install-dotnet4.ps1
. c:\vagrant\scripts\install-chocolatey.ps1

If (-not (Test-Path c:\chocolatey\bin\7za.bat)) {
  cinst 7zip.commandline
}

If (-not (Test-Path c:\chocolatey\bin\autoit3.bat)) {
  cinst autoit.commandline
  cinst autoit
}

. c:\vagrant\scripts\install-dotnet351.ps1

$Setup = "complete.1.3.1.15_4.5.1a\sealsetup.exe"
$SealSetupInstaller = "\\roettfs1.sealsystems.local\share\fm\frozen\" + $Setup
Write-Host "Check $SealSetupInstaller"
If (-not (Test-Path $SealSetupInstaller)) {
  $SealSetupInstaller = "\\mybooklive\Public\SEAL\roettfs1\share\fm\frozen\" + $Setup
}
Write-Host "Check $SealSetupInstaller"
If (-not (Test-Path $SealSetupInstaller)) {
  $SealSetupInstaller = "c:\vagrant\resources\fm\frozen\" + $Setup
}

Write-Host "Check $SealSetupInstaller"
If (Test-Path $SealSetupInstaller) {
  If (-not (Test-Path c:\vagrant\resources\license.ini)) {
    Write-Host -fore red "No Inifile for PLOSSYS license.exe found at C:\vagrant\resources\license.ini, so you have to enter the password manually."
  }

  & schtasks /Delete /F /TN SealSetup
  & schtasks /Create /SC ONCE /TN SealSetup /TR "C:\Chocolatey\bin\AutoIt3.bat C:\vagrant\scripts\install-nd451.au3 $SealSetupInstaller" /ST 00:00
  & schtasks /Run /TN SealSetup
}

