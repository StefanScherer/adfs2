Write-Host 'Install IIS'

# from http://stackoverflow.com/questions/10522240/powershell-script-to-auto-install-of-iis-7-and-above
# --------------------------------------------------------------------
# Define the variables.
# --------------------------------------------------------------------
$InetPubRoot = "C:\Inetpub"
$InetPubLog = "C:\Inetpub\Log"
$InetPubWWWRoot = "C:\Inetpub\WWWRoot"

# --------------------------------------------------------------------
# Loading Feature Installation Modules
# --------------------------------------------------------------------
Import-Module ServerManager

# --------------------------------------------------------------------
# Installing IIS
# --------------------------------------------------------------------
Add-WindowsFeature -Name Web-Common-Http,Web-Asp-Net,Web-Net-Ext,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-Http-Logging,Web-Request-Monitor,Web-Basic-Auth,Web-Windows-Auth,Web-Filtering,Web-Performance,Web-Mgmt-Console,Web-Mgmt-Compat,WAS -IncludeAllSubFeature

# --------------------------------------------------------------------
# Loading IIS Modules
# --------------------------------------------------------------------
Import-Module WebAdministration

# --------------------------------------------------------------------
# Creating IIS Folder Structure
# --------------------------------------------------------------------
New-Item -Path $InetPubRoot -type directory -Force -ErrorAction SilentlyContinue
New-Item -Path $InetPubLog -type directory -Force -ErrorAction SilentlyContinue
New-Item -Path $InetPubWWWRoot -type directory -Force -ErrorAction SilentlyContinue

# --------------------------------------------------------------------
# Copying old WWW Root data to new folder
# --------------------------------------------------------------------
$InetPubOldLocation = @(get-website)[0].physicalPath.ToString()
$InetPubOldLocation =  $InetPubOldLocation.Replace("%SystemDrive%",$env:SystemDrive)
# Copy-Item -Path $InetPubOldLocation -Destination $InetPubRoot -Force -Recurse

# --------------------------------------------------------------------
# Setting directory access
# --------------------------------------------------------------------
$Command = "icacls $InetPubWWWRoot /grant BUILTIN\IIS_IUSRS:(OI)(CI)(RX) BUILTIN\Users:(OI)(CI)(RX)"
cmd.exe /c $Command
$Command = "icacls $InetPubLog /grant ""NT SERVICE\TrustedInstaller"":(OI)(CI)(F)"
cmd.exe /c $Command

# --------------------------------------------------------------------
# Setting IIS Variables
# --------------------------------------------------------------------
#Changing Log Location
$Command = "%windir%\system32\inetsrv\appcmd set config -section:system.applicationHost/sites -siteDefaults.logfile.directory:$InetPubLog"
cmd.exe /c $Command
$Command = "%windir%\system32\inetsrv\appcmd set config -section:system.applicationHost/log -centralBinaryLogFile.directory:$InetPubLog"
cmd.exe /c $Command
$Command = "%windir%\system32\inetsrv\appcmd set config -section:system.applicationHost/log -centralW3CLogFile.directory:$InetPubLog"
cmd.exe /c $Command

#Changing the Default Website location
Set-ItemProperty 'IIS:\Sites\Default Web Site' -name physicalPath -value $InetPubWWWRoot

# --------------------------------------------------------------------
# Checking to prevent common errors
# --------------------------------------------------------------------
If (!(Test-Path "C:\inetpub\temp\apppools")) {
  New-Item -Path "C:\inetpub\temp\apppools" -type directory -Force -ErrorAction SilentlyContinue
}

# --------------------------------------------------------------------
# Deleting Old WWWRoot
# --------------------------------------------------------------------
# Remove-Item $InetPubOldLocation -Recurse -Force

# --------------------------------------------------------------------
# Resetting IIS
# --------------------------------------------------------------------
$Command = "IISRESET"
Invoke-Expression -Command $Command
