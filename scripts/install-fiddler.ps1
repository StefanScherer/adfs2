if (!(Test-Path 'c:\Program Files (x86)\Fiddler2')) {
  $ExeFile = $env:Temp + '\fiddler2setup.exe'
  Write-Host "Downloading Fiddler2"
  (New-Object Net.WebClient).DownloadFile('http://www.telerik.com/docs/default-source/fiddler/fiddler2setup.exe?sfvrsn=2', $ExeFile)
  Write-Host "Installing Fiddler2"
  & $ExeFile /S
}

