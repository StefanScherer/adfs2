$ChocoInstallPath = "$env:SystemDrive\Chocolatey\bin"

# Put chocolatey on the MACHINE path, vagrant does not have access to user environment variables
$envPath = $env:PATH
if (!$envPath.ToLower().Contains($ChocoInstallPath.ToLower())) {

    Write-Host "PATH environment variable does not have `'$ChocoInstallPath`' in it. Adding..."
    $ActualPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
    $StatementTerminator = ";"
    $HasStatementTerminator = $ActualPath -ne $null -and $ActualPath.EndsWith($StatementTerminator)
    If (!$HasStatementTerminator -and $ActualPath -ne $null) {$ChocoInstallPath = $StatementTerminator + $ChocoInstallPath}
    if (!$ChocoInstallPath.EndsWith($StatementTerminator)) {$ChocoInstallPath += $StatementTerminator}

    [Environment]::SetEnvironmentVariable('Path', $ActualPath + $ChocoInstallPath, [System.EnvironmentVariableTarget]::Machine)
}

$env:Path += ";$ChocoInstallPath"

if (!(Test-Path $ChocoInstallPath)) {
    # Install chocolatey
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

#$resourcesPath = 'c:\vagrant\resources'
#$chocoPkgFile = get-childitem $resourcesPath -recurse -include 'chocolatey.*.nupkg' | select -First 1
#
#if ($chocoPkgFile -ne $null) {
#    cinst chocolatey -pre -force -source "$resourcesPath"
#} else {
#    cinst chocolatey -pre
#}
