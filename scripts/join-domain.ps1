$user = "windomain.local\vagrant" 
$pass = ConvertTo-SecureString "vagrant" -AsPlainText -Force 
$DomainCred = New-Object System.Management.Automation.PSCredential $user, $pass 
Add-Computer -DomainName "windomain.local" -credential $DomainCred -PassThru

