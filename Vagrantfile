# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "dc" do |cfg|
    cfg.vm.box = "windows_2012_r2"
    cfg.vm.hostname = "dc"

    cfg.vm.communicator = "winrm"
    cfg.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    cfg.vm.network :private_network, ip: "192.168.38.2", gateway: "192.168.38.1"

    cfg.vm.provision "shell", path: "scripts/provision.ps1", privileged: false
    cfg.vm.provision "reload"
    cfg.vm.provision "shell", path: "scripts/provision.ps1", privileged: false

    cfg.vm.provider "virtualbox" do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 768]
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end


  config.vm.define "adfs2", autostart: false do |cfg|
    cfg.vm.box = "windows_2012_r2"
    cfg.vm.hostname = "adfs2"

    cfg.vm.communicator = "winrm"
    cfg.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    cfg.vm.network :private_network, ip: "192.168.38.3", gateway: "192.168.38.1", dns: "192.168.38.2"

    cfg.vm.provision "shell", path: "scripts/provision.ps1", privileged: false
    cfg.vm.provision "reload"
    cfg.vm.provision "shell", path: "scripts/provision.ps1", privileged: false

    cfg.vm.provider "virtualbox" do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 768]
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end


  config.vm.define "web", autostart: false do |cfg|
    cfg.vm.box = "windows_2012_r2"
    cfg.vm.hostname = "web"

    cfg.vm.communicator = "winrm"
    cfg.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 80, host: 8080, id: "http", auto_correct: true
    cfg.vm.network :private_network, ip: "192.168.38.4", gateway: "192.168.38.1", dns: "192.168.38.2"

    cfg.vm.provision "shell", path: "scripts/provision.ps1", privileged: false
    cfg.vm.provision "shell", path: "scripts/increase-tcp-num-connections.ps1", privileged: false
    cfg.vm.provision "shell", path: "scripts/install-chocolatey.ps1", privileged: false
    cfg.vm.provision "shell", path: "scripts/install-git.ps1", privileged: false
    cfg.vm.provision "reload"
    cfg.vm.provision "shell", path: "scripts/provision.ps1", privileged: false

    cfg.vm.provider "virtualbox" do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 2048]
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end


  config.vm.define "ps", autostart: false do |cfg|
    cfg.vm.box = "windows_2012_r2"
    cfg.vm.hostname = "ps"

    cfg.vm.communicator = "winrm"
    cfg.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    cfg.vm.network :private_network, ip: "192.168.38.9", gateway: "192.168.38.1"

    cfg.vm.provision "shell", path: "scripts/provision.ps1", privileged: false
    cfg.vm.provision "reload"
    cfg.vm.provision "shell", path: "scripts/provision.ps1", privileged: false

    cfg.vm.provider "virtualbox" do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 768]
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end


  config.vm.define "ts", autostart: false do |cfg|
    cfg.vm.box = "windows_2012_r2"
    cfg.vm.hostname = "ts"

    cfg.vm.communicator = "winrm"
    cfg.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    cfg.vm.network :private_network, ip: "192.168.38.15", gateway: "192.168.38.1"

    cfg.vm.provision "shell", path: "scripts/provision.ps1", privileged: false
    cfg.vm.provision "reload"
    cfg.vm.provision "shell", path: "scripts/provision.ps1", privileged: false
    cfg.vm.provision "reload"

    cfg.vm.provider "virtualbox" do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 768]
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end
end
