class PluginPersistDisk
  
  def self.vmCreate(vb, diskControllerName, diskControllerPortCount, persistContPort, persistContDev, workingDirectory, persistDiskPath, persistDiskSizeGb)
    # If the file does not exist we need to create the virtual disk
    unless File.exist?(persistDiskPath)
      
      # Check if VirtualBox thinks it is still managing a non existent file
      vbStillManagingDisk = %x( vboxmanage list hdds )
      if vbStillManagingDisk.include? "#{workingDirectory}/#{persistDiskPath}"
        # Remove managed disk in virtualbox before creating a new files
        print "persistDiskPath: #{workingDirectory}/#{persistDiskPath} (closemedium)\n"
        vmCloseMedium = %x( vboxmanage closemedium disk #{persistDiskPath} )
      end
      
      # Configure creation of disk if it does not already exist
      vb.customize ['createmedium', 'disk', '--filename', persistDiskPath, '--size', (persistDiskSizeGb * 1024).to_s, '--format', 'VMDK']
    end

    # The storage controller will. now need 2 ports so that we can attach the additional disk
    vb.customize ['storagectl', :id, '--name', "#{diskControllerName}", '--portcount', diskControllerPortCount]

    # Attach the new virtual disk to the vm 
    vb.customize ['storageattach', :id, '--storagectl', "#{diskControllerName}", '--port', persistContPort, '--device', persistContDev, '--type', 'hdd', '--medium', persistDiskPath]
  end
  
  def self.vmUp(node, machineName, diskControllerName, persistContPort, persistContDev, persistDiskPath)
    # Re-Attach a persistent disk
    # This does not run on initial machine creation
    node.trigger.before :up do |trigger|
      trigger.name = "Persistent Disk"
      if File.exist?(".vagrant/machines/#{machineName}/virtualbox/id")
        machineId = File.read(".vagrant/machines/#{machineName}/virtualbox/id")
        # Only try to attach if file actually exists
        # If file does not exist it will automatically be created and attached
        if File.exist?(persistDiskPath)
          vmInfoExtraction = %x( vboxmanage showvminfo #{machineId} --machinereadable | grep '"#{diskControllerName}-#{persistContPort}-#{persistContDev}"' )
          contPortDevValue = vmInfoExtraction.split("=")[1].to_s.gsub('"','').chomp()
          trigger.info = "Persistent Disk: #{contPortDevValue}"
          if contPortDevValue == 'none'
            trigger.warn = "Attaching Persistent Disk"
            trigger.run = {inline: "vboxmanage storageattach '#{machineId}' --storagectl '#{diskControllerName}' --port #{persistContPort} --device #{persistContDev} --type hdd --medium #{persistDiskPath}"}
          end
        end
      end
    end
  end
  
  def self.vmHalt(node, machineName, diskControllerName, persistContPort, persistContDev)
    # Detatch persistent disk
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
  end
  
  def self.vmDestroy(node, machineName, diskControllerName, persistContPort, persistContDev)
    # Do not allow vagrant to destroy if halt has not been run to detach the persistent disk
    node.trigger.before :destroy do |trigger|
      trigger.name = "Persistent Disk"
      if File.exist?(".vagrant/machines/#{machineName}/virtualbox/id")
        machineId = File.read(".vagrant/machines/#{machineName}/virtualbox/id")
        vmInfoExtraction = %x( vboxmanage showvminfo #{machineId} --machinereadable | grep '"#{diskControllerName}-#{persistContPort}-#{persistContDev}"' )
        contPortDevValue = vmInfoExtraction.split("=")[1].to_s.gsub('"','').chomp()
        trigger.info = "Persistent Disk: #{contPortDevValue}"
        if contPortDevValue != 'none'
          # Colorize text red ("\e[31m"+"text here"+"\e[0m")
          trigger.warn = "\e[31m"+"Drive still attached "+"\e[33m"+"(#{contPortDevValue}) - machine cannot be destroyed! - "+"\e[31m"+"Please halt the machine first."+"\e[0m"
          trigger.abort = true
        end
      end
    end
  end
  
end