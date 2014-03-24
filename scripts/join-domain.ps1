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

