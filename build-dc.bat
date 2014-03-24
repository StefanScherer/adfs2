echo starting dc for first time without provision to set hostname
call vagrant destroy dc -f
call vagrant up dc --provision
echo rebooting dc for provisioning
call vagrant reload dc --provision
echo rebooting dc to turn into domain controller and remount shared folder
call vagrant reload dc --provision
