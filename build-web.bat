echo starting web for first time without provision to set hostname
call vagrant destroy web -f
call vagrant up web --provision
echo rebooting web for provisioning, join windomain
call vagrant reload web --provision
echo rebooting web to finalize provisioning
call vagrant reload web --provision
