echo starting win7 for first time without provision to set hostname
call vagrant destroy win7 -f
call vagrant up win7 --provision
echo rebooting win7 for provisioning, join windomain
call vagrant reload win7 --provision
echo rebooting win7 to finalize provisioning
call vagrant reload win7 --provision
