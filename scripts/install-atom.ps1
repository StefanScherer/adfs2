choco install -y atom --version=1.25.1
Write-Host $env:LOCALAPPDATA
$env:PATH="$env:PATH;$env:LOCALAPPDATA\atom\app-1.25.1\resources\app\apm\bin"
apm install language-powershell
apm install language-batch
apm install language-docker
