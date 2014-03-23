echo "starting dc for first time without provision to set hostname"
vagrant destroy dc -f
vagrant up dc --provision
echo "rebooting dc for provisioning"
vagrant reload dc --provision
echo "rebooting dc to turn into domain controller and remount shared folder"
vagrant reload dc --provision
