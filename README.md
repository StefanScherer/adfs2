# Test AD FS 2
Test infrastructure for AD FS 2.

The following boxes could be created:

1. `dc` : The Active Directory Domain controller
2. `adfs2` : The Active Directory Federation Service
3. `web`: The Web Server running IIS
4. `win7`: A Windows 7 end user 

## Installation
To build the boxes, use the `build.sh` or `build.bat` script with the box name.
Each box will be reboot twice until all features are up and running.
If you accidentally called `vagrant up boxname` instead, just watch out for the hint line
and enter the `vagrant reload boxname --provision` command until there is no more hint.

### Create Domain Controller
First create the AD domain controller

```bash
./build.sh dc
```

After that the domain `windomain.local` is up and running at IP address `192.168.33.2`.
Some users will be created from the `users.csv` file.
A special service user will be created for JBoss7 integration and its keytab file for SSO.


### Create AD FS2 Server
This guest will join the domain and install the ADFS2.

```bash
./build.sh adfs2
```

I don't know if the ADFS2 is set up correctly. I just managed the domain join.

### Create Web Server
This guest will join the domain and set up an IIS Web Server on host `web`.

```bash
./build.sh web
```

After installation, you have an IIS 7 Web Server, but also an [iisnode](https://github.com/tjanczuk/iisnode) with Node.js up and running.

* [http://web.windomain.local/](http://localhost:8080/)
* [http://web.windomain.local/node](http://localhost:8080/node)


### Create Windows 7 Client
This guest will join the domain.

```bash
./build.sh win7
```

The guest will reboot twice until all features are up and running.

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

