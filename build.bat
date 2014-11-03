@echo off
if "%1x"=="x" (
  echo Usage: %~n0 {boxname}
  goto :EOF 
)
echo Cleaning %1
call vagrant destroy %1 -f
echo first boot of %1 for provisioning, create or join windomain
call vagrant up %1 --provision --provider=virtualbox
echo rebooting %1 to finalize provisioning
call vagrant reload %1 --provision
