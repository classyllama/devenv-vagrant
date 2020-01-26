# -*- mode: ruby -*-
# vi: set ft=ruby :

# Determine persistent and source paths
if File.symlink?(__FILE__)
  # Assume we are already in the persistent path
  persistent_path = ""
  source_path = "source/"
else
  # Assume we are in the source path
  persistent_path = "persistent/"
  source_path = ""
end

# include local variables, if present
require_relative "persistent/Vagrantfile.local"

# include plugin files
require_relative 'plugin/PluginUtility'
require_relative 'plugin/PluginPersistDisk'
require_relative 'plugin/PluginMutagen'
require_relative 'plugin/PluginHostmanagerHelper'

# indicate which versions this has been tested with
Vagrant.require_version ">= 2.2.5", "< 2.3.0"

Vagrant.configure('2') do |config|
  
  config.vagrant.plugins = ["vagrant-hostmanager"]
  
  # vagrant-hostmanager configuration
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = false
  #config.hostmanager.include_offline = true
  config.hostmanager.aliases = DEV_ADDITIONAL_HOSTNAMES
  
  config.vm.define "#{DEV_MACHINE_NAME}" do |config|
    
    config.vm.box = "bento/centos-7"
    config.vm.hostname = "#{DEV_MACHINE_NAME}"
    config.vm.network :private_network, type: "dhcp"
    
    config.hostmanager.ignore_private_ip = false
    
    # Resolve guest DHCP assigned IP
    cached_addresses = {}
    config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      PluginHostmanagerHelper.vbIpResolver(vm, cached_addresses)
    end
    PluginHostmanagerHelper.vmUpTrigger(config)
    
    # so we can connect to remote servers from inside the vm
    config.ssh.forward_agent = true
    if PluginUtility.vmIsProvisioned("#{DEV_MACHINE_NAME}")
      config.ssh.private_key_path = "#{SSH_PRIVATE_KEY}"
      config.ssh.insert_key = false
      config.ssh.host = "#{DEV_MACHINE_NAME}"
      config.ssh.port = 22
      config.ssh.username = 'www-data'
    end
    config.vm.graceful_halt_timeout = 120
    
    # Persistent Disk variable settings
    diskControllerName = "SATA Controller"
    persistDiskPath = "#{persistent_path}#{PERSISTENT_DISK_PATH}"
    persistDiskSizeGb = PERSISTENT_DISK_SIZE_GB
    persistContPort = 1
    persistContDev = 0
    machineName = config.vm.hostname
    
    # configure default RAM and number of CPUs allocated to vm
    config.vm.provider "virtualbox" do |vb|
      vb.name = "#{DEV_MACHINE_NAME}"
      vb.memory = DEV_VM_RAM
      vb.cpus = DEV_VM_CPUS
      # Adjust vram size to expected min
      vb.customize ["modifyvm", :id, "--vram", "16"]
      # Prevent VirtualBox from interfering with host audio stack
      vb.customize ["modifyvm", :id, "--audio", "none"]
      # Disable VirtualBox Remote Display
      vb.customize ["modifyvm", :id, "--vrde", "off"]
      
      PluginPersistDisk.vmCreate(vb, diskControllerName, persistContPort, persistContDev, persistDiskPath, persistDiskSizeGb)
    end
    
    # Provision
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "#{source_path}provisioning/build.yml"
      ansible.extra_vars = { host_zoneinfo: File.readlink('/etc/localtime') }
      ansible.compatibility_mode = "2.0"
      ansible.force_remote_user = false
      ansible.extra_vars = {
        host_zoneinfo: File.readlink('/etc/localtime'),
        mysql_root_pw: DEV_MYSQL_ROOT_PW,
        ssh_public_key_paths: SSH_PUBLIC_KEY_PATHS
      }
    end
    
    # Triggers
    PluginPersistDisk.vmUp(config, machineName, diskControllerName, persistContPort, persistContDev, persistDiskPath)
    #PluginMutagen.vmUp(config)
    
    #PluginMutagen.vmHalt(config)
    PluginPersistDisk.vmHalt(config, machineName, diskControllerName, persistContPort, persistContDev)
    
    #PluginMutagen.vmDestroy(config)
    PluginPersistDisk.vmDestroy(config, machineName, diskControllerName, persistContPort, persistContDev)
    
  end
  
end

