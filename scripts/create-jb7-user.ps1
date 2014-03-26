
Import-Module ActiveDirectory
Try {
  NEW-ADOrganizationalUnit -name "IT-Services"
} Catch {}
Try {
  NEW-ADOrganizationalUnit -name "ServiceAccounts" -path "OU=IT-Services,DC=windomain,DC=local"
} Catch {}

#Try {
  Remove-ADUser -Identity "jb7" -Confirm 
#} Catch {}

New-ADUser -SamAccountName "jb7" -GivenName "jb7" -Surname "jb7" -Name "JBoss 7 SSO" `
  -CannotChangePassword $true -PasswordNeverExpires $true -Enabled $true `
  -Path "OU=ServiceAccounts,OU=IT-Services,DC=windomain,DC=local" `
  -AccountPassword (ConvertTo-SecureString -AsPlainText 'MyPa$sw0rd' -Force)

# http://www.jeffgeiger.com/wiki/index.php/PowerShell/ADUnixImport
Get-ADUser -Identity "jb7" | Set-ADAccountControl -DoesNotRequirePreAuth:$true

# create keytab

New-Item -Path c:\vagrant\resources -type directory -Force -ErrorAction SilentlyContinue
If (Test-Path c:\vagrant\resources\jb7.keytab) {
  Remove-Item c:\vagrant\resources\jb7.keytab
}

& "ktpass" "-out" 'c:\vagrant\resources\jb7.keytab' "-princ" 'HTTP/WEB.windomain.local@WINDOMAIN.LOCAL' "-mapUser" 'WINDOMAIN\jb7' "-mapOp" "set" "-pass" 'MyPa$sw0rd' "-crypto" "RC4-HMAC-NT"

If (Test-Path c:\vagrant\resources\jb7.keytab) {
  Write-Host -fore green "Keytab created at c:\vagrant\resources\jb7.keytab"
} else {
  Write-Host -fore red "Keytab not created"
}

