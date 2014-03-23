echo "starting adfs2 for first time without provision to set hostname"
vagrant destroy adfs2 -f
vagrant up adfs2 --provision
echo "rebooting adfs2 for provisioning, join windomain"
vagrant reload adfs2 --provision
echo "rebooting adfs2 to finalize provisioning"
vagrant reload adfs2 --provision
