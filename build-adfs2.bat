echo starting adfs2 for first time without provision to set hostname
call vagrant destroy adfs2 -f
call vagrant up adfs2 --provision
echo rebooting adfs2 for provisioning, join windomain
call vagrant reload adfs2 --provision
echo rebooting adfs2 to finalize provisioning
call vagrant reload adfs2 --provision
