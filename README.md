# Test AD FS 2
Test infrastructure for AD FS 2.

The following boxes could be created:

1. `dc` : The Active Directory Domain controller
2. `adfs2` : The Active Directory Federation Service
3. `web`: The Web Server running IIS
4. `ps`: A Windows Print Server on Windows Server 2012 R2
5. `ts`: A Windows Terminal Server

## Installation
To build the boxes, use `vagrant up` with the box name.
Each box will be reboot twice until all features are up and running.

### Create Domain Controller
First create the AD domain controller

```bash
vagrant up dc --provider virtualbox
```

After that the domain `windomain.local` is up and running at IP address `192.168.38.2`.
Some users will be created from the `users.csv` file.
A special service user will be created for JBoss7 integration and its keytab file for SSO.

### Create AD FS2 Server
This guest will join the domain and install the ADFS2.

```bash
vagrant up adfs2 --provider virtualbox
```

I don't know if the ADFS2 is set up correctly. I just managed the domain join.

### Create Web Server
This guest will join the domain and set up an IIS Web Server on host `web`.

```bash
vagrant up web --provider virtualbox
```

After installation, you have an IIS 7 Web Server, but also an [iisnode](https://github.com/tjanczuk/iisnode) with Node.js up and running.

* [http://web.windomain.local/](http://localhost:8080/)
* [http://web.windomain.local/node](http://localhost:8080/node)


### Create Windows 7 Client
This guest will join the domain.

```bash
vagrant up win7 --provider virtualbox
```

The guest will reboot twice until all features are up and running.

### ND Server
This guest will join the domain.

```bash
vagrant up nd --provider virtualbox
```

The guest will reboot once until all features are up and running.

You also may create a file `resources/license.ini` with the following content and the right password.

```
[license.exe]
password = XXXXX
```

#### Post installation
After installing ND 451, you may fill in some printers within the ND shell

```
powershell -file c:\vagrant\scripts\create-queues.ps1
```


### EP Server
This guest will join the domain.

```bash
vagrant up ep --provider virtualbox
```

The guest will reboot once until all features are up and running.

#### Post installation
After installing EP 123, you may fill in some printers within the shell, but there is no automation script at the momen.

```
powershell -file c:\vagrant\scripts\import-ep.ps1
```

#### Test Single Sign On
Single Sign On should work out of the box with the provisioning scripts.
But you can install the JBoss Negotiation Toolkit for further tests

1. Go to the `ep` box and open the Ocon Shell
2. `jb`
3. `install-jboss-negotiation-toolkit.pl`
4. Go to the `win7` box and login as `mike.hammer`
5. Open IE with URL [http://ep:8080/jboss-negotiation-toolkit/](http://ep:8080/jboss-negotiation-toolkit/)


## Normal Use
After setting up all boxes, you simply can start and stop the boxes, but the
Domain Controller should be started first and stopped last.

```bash
vagrant up dc
vagrant up web
vagrant up win7
vagrant halt win7
vagrant halt web
vagrant halt dc
```
