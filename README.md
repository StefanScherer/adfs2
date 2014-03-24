# Test AD FS 2
Test infrastructure for AD FS 2.

The following boxes could be created:

1. `dc` : The Active Directory Domain controller
2. `adfs2` : The Active Directory Federation Service
3. `web`: The Web Server running IIS
4. `win7`: A Windows 7 end user 

## Installation
### Create Domain Controller
First create the AD domain controller

```bash
./build-dc.sh
```

The guest will reboot twice until all features are up and running. After that
the domain `windomain.local` is up and running at IP address `192.168.33.2`.

### Create AD FS2 Server
This guest will join the domain and install the ADFS2.

```bash
./build-adfs2.sh
```

The guest will reboot twice until all features are up and running.
I don't know if the ADFS2 is set up correctly. I just managed the domain join.

### Create Web Server
This guest will join the domain and set up an IIS Web Server on host `web`.

```bash
./build-web.sh
```

The guest will reboot twice until all features are up and running.
Notice: The auto login of Vagrant logs in with the local user account `vagrant`.
You may log off and switch user to `windomain\vagrant` user which is a domain user.

### Create Windows 7 Client
This guest will join the domain.

```bash
./build-win7.sh
```

The guest will reboot twice until all features are up and running.
Notice: The auto login of Vagrant logs in with the local user account `vagrant`.
You may log off and switch user to `windomain\vagrant` user which is a domain user.

## Normal Use
After setting up all boxes, you simply can start and stop the boxes, but the
Domain Controller should be started first and stopped last.

```bash
vagrant up dc
vagrant up adfs2
vagrant up web
vagrant up win7
vagrant halt win7
vagrant halt web
vagrant halt adfs2
vagrant halt dc
```

## TODO
Rebooting the windows guest while provisioning could be done with [vagrant-provision-reboot](https://github.com/exratione/vagrant-provision-reboot) plugin.
But this plugin does not work with my Vagrant 1.5.1 installation. But with something like that we could get rid
of the build host scripts and customize everything inside the Vagrantfile.

