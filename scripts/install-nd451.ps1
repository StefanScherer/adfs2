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


# create a Task Scheduler task which is also able to run in battery mode due
# to host notebooks working in battery mode. This complicates the whole script
# from a one liner to a fat XML - good heaven.

$xml = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2014-03-27T13:53:05</Date>
    <Author>vagrant</Author>
  </RegistrationInfo>
  <Triggers>
    <TimeTrigger>
      <StartBoundary>2014-03-27T00:00:00</StartBoundary>
      <Enabled>true</Enabled>
    </TimeTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>vagrant</UserId>
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>P3D</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>C:\Chocolatey\bin\AutoIt3.bat</Command>
      <Arguments>C:\vagrant\scripts\install-nd451.au3 $SealSetupInstaller</Arguments>
    </Exec>
  </Actions>
</Task>
"@

$XmlFile = $env:Temp + "\SealSetup.xml"
Write-Host "Write Task to $XmlFile"
$xml | Out-File $XmlFile

If (-not (Test-Path c:\seal\customer\server\jboss\conf)) {
  Write-Host "Preinstalling some customer files"
  New-Item -Path c:\seal\customer\server\jboss\conf -ItemType directory

  If (Test-Path c:\vagrant\resources\jb7nd451.keytab) {
    Write-Host -fore green "Copy Keytab file from c:\vagrant\resources\jb7nd451.keytab"
    Copy-Item c:\vagrant\resources\jb7nd451.keytab c:\seal\customer\server\jboss\conf\jb7nd451.keytab -Confirm:$false
  } else {
    Write-Host -fore red "Keytab file missing, expected at c:\vagrant\resources\jb7nd451.keytab"
  }

  If (Test-Path c:\vagrant\configs\nd451\authentication.cfg) {
    Write-Host -fore green "Copy Authentication file from c:\vagrant\configs\nd451\authentication.cfg"
    Copy-Item c:\vagrant\configs\nd451\authentication.cfg c:\seal\customer\server\jboss\conf\authentication.cfg -Confirm:$false
  } else {
    Write-Host -fore red "Authentication file missing, expected at c:\vagrant\configs\nd451\authentication.cfg"
  }
}

Write-Host "Check $SealSetupInstaller"
If (Test-Path $SealSetupInstaller) {
  If (-not (Test-Path c:\vagrant\resources\license.ini)) {
    Write-Host -fore red "No Inifile for PLOSSYS license.exe found at C:\vagrant\resources\license.ini, so you have to enter the password manually."
  }

  & schtasks /Delete /F /TN SealSetup
  & schtasks /Create /TN SealSetup /XML $XmlFile
  & schtasks /Run /TN SealSetup
}

Write-Host "Opening Firewall"
& netsh advfirewall firewall add rule name="JBoss7 Port 8080" dir=in action=allow protocol=TCP localport=8080
& netsh advfirewall firewall add rule name="Apache Port 9125" dir=in action=allow protocol=TCP localport=9125
& netsh advfirewall firewall add rule name="kNet Port 7125" dir=in action=allow protocol=TCP localport=7125
& netsh advfirewall firewall add rule name="Frans3 Port 7126" dir=in action=allow protocol=TCP localport=7126

# Write-Host "Port Forwarding"
# & netsh interface portproxy add v4tov4 listenport=80 listenaddress=192.168.33.6 connectport=8080 connectaddress=192.168.33.6

