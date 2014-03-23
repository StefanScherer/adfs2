if ($env:COMPUTERNAME -imatch 'vagrant') {

  Write-Host 'Hostname is still the original one, skip provisioning for reboot'

} elseif ((gwmi win32_computersystem).partofdomain -eq $false) {

  write-host -fore red "Ooops, workgroup!"

  Write-Host 'Join the domain'

  Start-Sleep -m 5000

  Write-Host "First, set DNS to DC to join the domain"
  & 'netsh' 'interface' 'ipv4' 'add' 'dnsserver' 'Local Area Connection 2' 'address=192.168.33.2' 'index=1'

  Start-Sleep -m 5000

  Write-Host "Now join the domain"
  & 'netdom' 'join' $env:COMPUTERNAME '/domain:windomain' '/userd:windomain\vagrant' '/passwordd:vagrant'

  Write-Host "Status of netdom = " $LASTEXITCODE

  if ($LASTEXITCODE -eq 2691) {
    Write-Host -fore red "We are already in a domain"
  }

} else {

  write-host -fore green "I am domain joined!"

#  if ($env:COMPUTERNAME -eq $env:USERDOMAIN) {
#    write-host -fore red "I am a local user! I will invoke this script with domain user..."
#  
#    $user = "windomain.local\vagrant" 
#    $pass = ConvertTo-SecureString "vagrant" -AsPlainText -Force 
#    $DomainCred = New-Object System.Management.Automation.PSCredential $user, $pass   
#
#    Invoke-Command -FilePath 'c:\vagrant\scripts\install-adfs2.ps1' -ComputerName '.' -Credential $DomainCred
#
#  } else {
#
#    write-host -fore green "I am a domain user!"

    Write-Host 'Provisioning after joining domain'

    # http://www.microsoft.com/en-us/download/details.aspx?id=10909
    $DownloadUrl='http://download.microsoft.com/download/F/3/D/F3D66A7E-C974-4A60-B7A5-382A61EB7BC6/RTW/W2K8R2/amd64/AdfsSetup.exe'
    $ExeFile = $env:Temp + '\AdfsSetup.exe'

    Write-Host "Downloading ADFS 2 Setup"
    (New-Object Net.WebClient).DownloadFile($DownloadUrl, $ExeFile)
    Write-Host "Installing ADFS 2"
    & $ExeFile '/quiet' '/norestart'

    Write-Host "Status of AdfsSetup = " $LASTEXITCODE
#  }

}
