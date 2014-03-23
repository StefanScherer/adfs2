if ($env:COMPUTERNAME -imatch 'vagrant') {

  Write-Host 'Hostname is still the original one'

  Write-Host 'Disable windows updates'
  # http://support.microsoft.com/kb/328010
  New-Item HKLM:\SOFTWARE\Policies\Microsoft\Windows -Name WindowsUpdate
  New-Item HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name AU
  New-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name NoAutoUpdate -Value 1

  Write-Host -fore red 'Hint: vagrant reload win7 --provision'

} elseif ((gwmi win32_computersystem).partofdomain -eq $false) {

  write-host -fore red "Ooops, workgroup!"

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

  Write-Host -fore red 'Hint: vagrant reload win7 --provision'

} else {

  write-host -fore green "I am domain joined!"

  # ... do another installations after domain join here

}
