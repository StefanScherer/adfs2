if ($env:COMPUTERNAME -imatch 'vagrant') {

  Write-Host 'Hostname is still the original one'

  Write-Host -fore red 'Hint: vagrant reload dc --provision'

} elseif ((gwmi win32_computersystem).partofdomain -eq $false) {

  write-host -fore red "Ooops, workgroup!"

  Write-Host 'Create the domain controller'

  . c:\vagrant\scripts\Install-TAFirst2008R2DomainController-0.8.ps1
  Install-TAFirst2008R2DomainController -domain windomain.local -netbiosdomainname windomain -ADSite winsite

  Write-Host -fore red 'Hint: vagrant reload dc --provision'

} else {

  write-host -fore green "I am domain joined!"

  # ... do another installations after domain join here

}

