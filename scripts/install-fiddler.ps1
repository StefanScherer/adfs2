if ( [System.Environment]::OSVersion.Version.Build -lt 9600 ) {

  if (!(Test-Path 'c:\Program Files (x86)\Fiddler2')) {
    $ExeFile = $env:Temp + '\fiddler2setup.exe'
    Write-Host "Downloading Fiddler2"
    (New-Object Net.WebClient).DownloadFile('http://www.telerik.com/docs/default-source/fiddler/fiddler2setup.exe?sfvrsn=2', $ExeFile)
    Write-Host "Installing Fiddler2"
    & $ExeFile /S
  }
} else {
  if (!(Test-Path 'c:\Program Files (x86)\Fiddler4')) {
    $ExeFile = $env:Temp + '\fiddler4setup.exe'
    Write-Host "Downloading Fiddler4"
    (New-Object Net.WebClient).DownloadFile('http://www.telerik.com/docs/default-source/fiddler/fiddler4setup.exe?sfvrsn=2', $ExeFile)
    Write-Host "Installing Fiddler4"
    & $ExeFile /S
  }
}

