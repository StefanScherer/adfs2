$user = "vagrant" 
$pass = ConvertTo-SecureString "vagrant" -AsPlainText -Force 
$DomainCred = New-Object System.Management.Automation.PSCredential $user, $pass 
Add-Computer -DomainName "windomain" -credential $DomainCred


# Add-Computer [-DomainName]  [-Credential ] [-OUPath ] [-PassThru] [-Server ] [-Unsecure] [-Confirm] [-WhatIf] []
