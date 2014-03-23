if ($env:COMPUTERNAME -imatch 'vagrant') {

  Write-Host 'Hostname is still the original one, skip provisioning for reboot'

  Write-Host -fore red 'Hint: vagrant reload adfs2 --provision'

} elseif ((gwmi win32_computersystem).partofdomain -eq $false) {

  Write-Host -fore red "Ooops, workgroup!"

  Write-Host 'Join the domain'

  Start-Sleep -m 2000

  Write-Host "First, set DNS to DC to join the domain"
  & 'netsh' 'interface' 'ipv4' 'add' 'dnsserver' 'Local Area Connection 2' 'address=192.168.33.2' 'index=1'

  Start-Sleep -m 2000

  Write-Host "Now join the domain"

  $user = "windomain.local\vagrant" 
  $pass = ConvertTo-SecureString "vagrant" -AsPlainText -Force 
  $DomainCred = New-Object System.Management.Automation.PSCredential $user, $pass 
  Add-Computer -DomainName "windomain.local" -credential $DomainCred -PassThru

  Write-Host -fore red 'Hint: vagrant reload adfs2 --provision'

} else {

  Write-Host -fore green "I am domain joined!"

  Write-Host 'Provisioning after joining domain'

  # http://www.microsoft.com/en-us/download/details.aspx?id=10909
  $DownloadUrl='http://download.microsoft.com/download/F/3/D/F3D66A7E-C974-4A60-B7A5-382A61EB7BC6/RTW/W2K8R2/amd64/AdfsSetup.exe'
  $ExeFile = $env:Temp + '\AdfsSetup.exe'

  Write-Host "Downloading ADFS 2 Setup"
  (New-Object Net.WebClient).DownloadFile($DownloadUrl, $ExeFile)
  Write-Host "Installing ADFS 2"
  & $ExeFile '/quiet' '/norestart'

  Write-Host "Status of AdfsSetup = " $LASTEXITCODE

}
