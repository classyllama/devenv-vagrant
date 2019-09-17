# -*- mode: ruby -*-
# vi: set ft=ruby :

require './plugin/PluginPersistDisk.rb'
require './plugin/PluginMutagen.rb'

Vagrant.configure("2") do |config|
  
  config.vm.define "dev-m2demo" do |node|
    node.vm.box = "bento/centos-7"
    node.vm.hostname = "dev-m2demo"
    node.vm.network :private_network, ip: '10.19.89.32'
    
    # so we can connect to remote servers from inside the vm
    node.ssh.forward_agent = true
    # node.ssh.host = '10.19.89.33'
    # node.ssh.keys_only = false
    # node.ssh.username = 'www-data'
    node.vm.graceful_halt_timeout = 120
    
    # persistent disk settings
    diskControllerName = "SATA Controller"
    persistDiskPath = 'persistent_data_disk.vmdk'
    persistDiskSizeGb = 50
    persistContPort = 1
    persistContDev = 0
    machineName = node.vm.hostname
    
    # configure default RAM and number of CPUs allocated to vm
    node.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus = 2
      # Adjust vram size to expected min
      vb.customize ["modifyvm", :id, "--vram", "16"]
      # Prevent VirtualBox from interfering with host audio stack
      vb.customize ["modifyvm", :id, "--audio", "none"]
      
      PluginPersistDisk.vmCreate(vb, diskControllerName, persistContPort, persistContDev, persistDiskPath, persistDiskSizeGb)
    end
    
    # Provision
    node.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/build.yml"
      ansible.extra_vars = { host_zoneinfo: File.readlink('/etc/localtime') }
      ansible.compatibility_mode = "2.0"
    end
    
    # Triggers
    PluginPersistDisk.vmUp(node, machineName, diskControllerName, persistContPort, persistContDev, persistDiskPath)
    # PluginMutagen.vmUp(node)
    
    # PluginMutagen.vmHalt(node)
    PluginPersistDisk.vmHalt(node, machineName, diskControllerName, persistContPort, persistContDev)
    
    # PluginMutagen.vmDestroy(node)
    PluginPersistDisk.vmDestroy(node, machineName, diskControllerName, persistContPort, persistContDev)
    
  end
end
