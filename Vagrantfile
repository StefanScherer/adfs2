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

    dc.vm.provision "shell", path: "scripts/provision.ps1"

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
    adfs2.vm.network :private_network, ip: "192.168.33.3", gateway: "192.168.33.1", dns: "192.168.33.2"

    adfs2.vm.provision "shell", path: "scripts/provision.ps1"

    adfs2.vm.provider :virtualbox do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 768]
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end


  config.vm.define :"web" do |web|
    web.vm.box = "windows_2008_r2"
    web.vm.hostname = "web"

    web.windows.set_work_network = true
    web.vm.guest = :windows 
    web.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    web.vm.network :forwarded_port, guest: 80, host: 8080, id: "http", auto_correct: true
    web.vm.network :private_network, ip: "192.168.33.4", gateway: "192.168.33.1", dns: "192.168.33.2"

    web.vm.provision "shell", path: "scripts/provision.ps1"

    web.vm.provider :virtualbox do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 768]
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end


  config.vm.define :"win7" do |win7|
    win7.vm.box = "windows_7"
    win7.vm.hostname = "win7"

    win7.windows.set_work_network = true
    win7.vm.guest = :windows 
    win7.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
#    win7.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    win7.vm.network :private_network, ip: "192.168.33.5", gateway: "192.168.33.1", dns: "192.168.33.2"

    win7.vm.provision "shell", path: "scripts/provision.ps1"

    win7.vm.provider :virtualbox do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 768]
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end

  config.vm.define :"node" do |node|
    node.vm.box = "windows_81"
    node.vm.hostname = "node"

    node.windows.set_work_network = true
    node.vm.guest = :windows 
    node.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
#    node.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    node.vm.network :private_network, ip: "192.168.33.8", gateway: "192.168.33.1", dns: "192.168.33.2"

    node.vm.provision "shell", path: "scripts/provision.ps1"

    node.vm.provider :virtualbox do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 1536]
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end

  config.vm.define :"nd451" do |nd451|
    nd451.vm.box = "windows_2008_r2"
    nd451.vm.hostname = "nd451"

    nd451.windows.set_work_network = true
    nd451.vm.guest = :windows 
    nd451.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    nd451.vm.network :private_network, ip: "192.168.33.6", gateway: "192.168.33.1", dns: "192.168.33.2"

    nd451.vm.provision "shell", path: "scripts/provision.ps1"

    nd451.vm.provider :virtualbox do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 2048]
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end

  config.vm.define :"ep123" do |ep123|
    ep123.vm.box = "windows_2008_r2"
    ep123.vm.hostname = "ep123"

    ep123.windows.set_work_network = true
    ep123.vm.guest = :windows 
    ep123.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    ep123.vm.network :private_network, ip: "192.168.33.7", gateway: "192.168.33.1", dns: "192.168.33.2"

    ep123.vm.provision "shell", path: "scripts/provision.ps1"

    ep123.vm.provider :virtualbox do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 1536]
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end

  config.vm.define "loader", primary: true do |loader|
    loader.vm.box = "precise64"
    loader.vm.network :private_network, ip: "192.168.33.10", gateway: "192.168.33.1"
    loader.vm.provision "shell", path: "scripts/provision-loader.sh"
    loader.vm.hostname = "loader"

     loader.vm.provider :virtualbox do |vb|
       vb.gui = true
       vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "2"]
     end
  end

end
