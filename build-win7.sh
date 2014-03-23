echo "starting win7 for first time without provision to set hostname"
vagrant destroy win7 -f
vagrant up win7 --provision # --no-provision
echo "rebooting win7 for provisioning, join windomain"
vagrant reload win7 --provision
echo "rebooting win7 to finalize provisioning"
vagrant reload win7 --provision
