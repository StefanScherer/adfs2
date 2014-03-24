echo "starting web for first time without provision to set hostname"
vagrant destroy web -f
vagrant up web --provision
echo "rebooting web for provisioning, join windomain"
vagrant reload web --provision
echo "rebooting web to finalize provisioning"
vagrant reload web --provision
