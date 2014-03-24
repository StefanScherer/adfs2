@echo off
if "%1x"=="x" (
  echo Usage: %~n0 {boxname}
  goto :EOF 
)
echo starting %1 for first time without provision to set hostname
call vagrant destroy %1 -f
call vagrant up %1 --provision
echo rebooting %1 for provisioning, join windomain
call vagrant reload %1 --provision
echo rebooting %1 to finalize provisioning
call vagrant reload %1 --provision
