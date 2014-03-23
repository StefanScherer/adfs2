# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define :"dc" do |dc|
    dc.vm.box = "windows_2008_r2"
    dc.vm.hostname = "dc"

    dc.windows.set_work_network = true
    dc.vm.guest = :windows 
    dc.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    dc.vm.network :private_network, ip: "192.168.33.2", gateway: "192.168.33.1"

    # first reboot due to hostname change
    dc.vm.provision "shell", path: "scripts/install-dc.ps1"

    dc.vm.provider :virtualbox do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 768]
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end


  config.vm.define :"adfs2" do |adfs2|
    adfs2.vm.box = "windows_2008_r2"
    adfs2.vm.hostname = "adfs2"

    adfs2.windows.set_work_network = true
    adfs2.vm.guest = :windows 
    adfs2.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    adfs2.vm.network :private_network, ip: "192.168.33.3", gateway: "192.168.33.1"

    # first reboot due to hostname change
    adfs2.vm.provision "shell", path: "scripts/install-adfs2.ps1"

    adfs2.vm.provider :virtualbox do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 768]
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end

end
