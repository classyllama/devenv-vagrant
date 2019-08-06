# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.define "dev-m2demo" do |node|
    node.vm.box = "bento/centos-7"
    node.vm.hostname = "dev-m2demo"
    node.vm.network :private_network, ip: '10.19.89.32'
    
    # so we can connect to remote servers from inside the vm
    node.ssh.forward_agent = true    
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
      
      # Persistent Disk Configuration
      unless File.exist?(persistDiskPath)
        vb.customize ['createmedium', 'disk', '--filename', persistDiskPath, '--size', (persistDiskSizeGb * 1024).to_s, '--format', 'VMDK']
      end
      vb.customize ['storagectl', :id, '--name', "#{diskControllerName}", '--portcount', 2]
      vb.customize ['storageattach', :id, '--storagectl', "#{diskControllerName}", '--port', persistContPort, '--device', persistContDev, '--type', 'hdd', '--medium', persistDiskPath]
    end
    
    # Provision
    node.vm.provision :ansible_local do |ansible|
      ansible.playbook = "/vagrant/provisioning/build.yml"
      ansible.extra_vars = { host_zoneinfo: File.readlink('/etc/localtime') }
      ansible.compatibility_mode = "2.0"
    end
    
    
    
    
    
    # Persistent Disk Triggers
    node.trigger.before :up do |trigger|
      trigger.name = "Persistent Disk"
      if File.exist?(".vagrant/machines/#{machineName}/virtualbox/id")
        machineId = File.read(".vagrant/machines/#{machineName}/virtualbox/id")
        vmInfoExtraction = %x( vboxmanage showvminfo #{machineId} --machinereadable | grep '"#{diskControllerName}-#{persistContPort}-#{persistContDev}"' )
        contPortDevValue = vmInfoExtraction.split("=")[1].to_s.gsub('"','').chomp()
        trigger.info = "Persistent Disk: #{contPortDevValue}"
        if contPortDevValue == 'none'
          trigger.warn = "Attaching Persistent Disk"
          trigger.run = {inline: "vboxmanage storageattach '#{machineId}' --storagectl '#{diskControllerName}' --port #{persistContPort} --device #{persistContDev} --type hdd --medium #{persistDiskPath}"}
        end
      end
    end
    
    node.trigger.after :halt do |trigger|
      trigger.name = "Persistent Disk"
      if File.exist?(".vagrant/machines/#{machineName}/virtualbox/id")
        machineId = File.read(".vagrant/machines/#{machineName}/virtualbox/id")
        vmInfoExtraction = %x( vboxmanage showvminfo #{machineId} --machinereadable | grep '"#{diskControllerName}-#{persistContPort}-#{persistContDev}"' )
        contPortDevValue = vmInfoExtraction.split("=")[1].to_s.gsub('"','').chomp()
        trigger.info = "Persistent Disk: #{contPortDevValue}"
        if contPortDevValue != 'none'
          trigger.warn = "Detatching Persistent Disk"
          trigger.run = {inline: "vboxmanage storageattach '#{machineId}' --storagectl '#{diskControllerName}' --port #{persistContPort} --device #{persistContDev} --type hdd --medium none"}
        end
      end
    end
    
    node.trigger.before :destroy do |trigger|
      trigger.name = "Persistent Disk"
      if File.exist?(".vagrant/machines/#{machineName}/virtualbox/id")
        machineId = File.read(".vagrant/machines/#{machineName}/virtualbox/id")
        vmInfoExtraction = %x( vboxmanage showvminfo #{machineId} --machinereadable | grep '"#{diskControllerName}-#{persistContPort}-#{persistContDev}"' )
        contPortDevValue = vmInfoExtraction.split("=")[1].to_s.gsub('"','').chomp()
        trigger.info = "Persistent Disk: #{contPortDevValue}"
        if contPortDevValue != 'none'
          trigger.warn = "Drive still attached (#{contPortDevValue}) - machine cannot be destroyed! - Please halt the machine first."
          trigger.run = {inline: "exit 'drive attached - cannot be destroyed'"}
        end
      end
    end
    
  end
end
