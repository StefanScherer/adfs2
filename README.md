# Test AD FS 2
Test infrastructure for AD FS 2.

## Installation
First create the domain controller

    ./build-dc.sh

The guest will reboot twice until all features are up and running.
After that call

    vagrant up adfs2


## TODO
Rebooting the windows guest while provisioning is done with https://github.com/exratione/vagrant-provision-reboot

