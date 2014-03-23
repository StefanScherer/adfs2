# Test AD FS 2
Test infrastructure for AD FS 2.

## Installation
### Create Domain Controller
First create the domain controller

    ./build-dc.sh

The guest will reboot twice until all features are up and running.

### Create AD FS2 Server
This guest will join the domain and install the ADFS2.

    ./build-adfs2.sh

The guest will reboot twice until all features are up and running.

### Create Windows 7 Client
This guest will join the domain.

    ./build-win7.sh

The guest will reboot twice until all features are up and running.

## Normal Use
After setting up all boxes, you simply can start and stop the boxes, but the
Domain Controller should be started first and stopped last.

    vagrant up dc
    vagrant up adfs2
    vagrant up win7
    vagrant halt win7
    vagrant halt adfs2
    vagrant halt dc

## TODO
Rebooting the windows guest while provisioning could be done with https://github.com/exratione/vagrant-provision-reboot
But this plugin does not work with my Vagrant 1.5.1 installation. But with something like that we could get rid
of the build host scripts and customize everything inside the Vagrantfile.

