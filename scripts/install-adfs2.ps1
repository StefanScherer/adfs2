Write-Host 'Installing ADFS 2'

# http://www.microsoft.com/en-us/download/details.aspx?id=10909
$DownloadUrl='http://download.microsoft.com/download/F/3/D/F3D66A7E-C974-4A60-B7A5-382A61EB7BC6/RTW/W2K8R2/amd64/AdfsSetup.exe'
$ExeFile = $env:Temp + '\AdfsSetup.exe'

Write-Host "Downloading ADFS 2 Setup"
(New-Object Net.WebClient).DownloadFile($DownloadUrl, $ExeFile)
Write-Host "Installing ADFS 2"
& $ExeFile '/quiet' '/norestart'

Write-Host "Status of AdfsSetup = " $LASTEXITCODE
