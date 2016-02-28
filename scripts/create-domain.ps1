Write-Host 'Create the domain controller'

$PlainPassword = "P@ssw0rd"
$SecurePassword = $PlainPassword | ConvertTo-SecureString -AsPlainText -Force

# Windows Server 2012 R2
Install-WindowsFeature AD-domain-services
Import-Module ADDSDeployment
Install-ADDSForest `
  -SafeModeAdministratorPassword $SecurePassword `
  -CreateDnsDelegation:$false `
  -DatabasePath "C:\Windows\NTDS" `
  -DomainMode "Win2012" `
  -DomainName "windomain.local" `
  -DomainNetbiosName "WINDOMAIN" `
  -ForestMode "Win2012" `
  -InstallDns:$true `
  -LogPath "C:\Windows\NTDS" `
  -NoRebootOnCompletion:$true `
  -SysvolPath "C:\Windows\SYSVOL" `
  -Force:$true
  
