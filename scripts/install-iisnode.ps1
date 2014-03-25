
# https://github.com/tjanczuk/iisnode

Write-Host "Downloading iisnode"
$MsiFile = $env:Temp + '\iisnode.msi'
(New-Object Net.WebClient).DownloadFile('http://go.microsoft.com/?linkid=9784331', $MsiFile)
Write-Host "Installing iisnode"
& msiexec '/i' $MsiFile '/quiet' '/norestart'

Write-Host "Downloading URL Rewrite Module"
$MsiFile = $env:Temp + '\urlrewrite.msi'
(New-Object Net.WebClient).DownloadFile('http://download.microsoft.com/download/6/7/D/67D80164-7DD0-48AF-86E3-DE7A182D6815/rewrite_2.0_rtw_x64.msi', $MsiFile)
Write-Host "Installing URL Rewrite Module"
& msiexec '/i' $MsiFile '/quiet' '/norestart'

$NodeVersion = "0.10.26"
Write-Host "Downloading Node.js $NodeVersion"
$MsiFile = $env:Temp + '\nodejs.msi'
(New-Object Net.WebClient).DownloadFile('http://nodejs.org/dist/v0.10.26/x64/node-v0.10.26-x64.msi', $MsiFile)
Write-Host "Installing Node.js"
& msiexec '/i' $MsiFile '/quiet' '/norestart'

& "cmd" "/C" 'c:\Program Files\iisnode\setupsamples.bat' "/s"
