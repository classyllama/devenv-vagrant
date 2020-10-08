class PluginHostmanagerHelper
  
  # Resolve Guest IP by executing command on guest to get assigned IP
  def self.vbIpResolver(vm, cached_addresses)
    # vagrant ssh -c "hostname -I | cut -d ' ' -f 2" -- -q
    
    if vm.id
      host_ip = ""
      begin
        if cached_addresses[vm.name].nil?
          if hostname = (vm.ssh_info && vm.ssh_info[:host] && vm.communicate.ready?)
            # Calling vm.communicate.execute() operates from within the operation
            # but is similar to calling `vagrant ssh` and doesn't have problems with
            # vagrant locking while it's performing the operation the ip is needed to
            # be resolved for.
            vm.communicate.execute("hostname -I | cut -d ' ' -f 2") do |type, contents|
              cached_addresses[vm.name] = contents.split("\n").first[/(\d+\.\d+\.\d+\.\d+)/, 1]
            end
          end
        end
        cached_addresses[vm.name]
        
        host_ip = cached_addresses[vm.name]
        #print "ip_resolver: #{host_ip}\n"
      rescue
        print "\e[31m"+"ip_resolver_error: #{host_ip}"+"\e[0m\n"
      end
      if (host_ip != "")
        host_ip
      end
    end
  end

  # Check to make sure hostname of machine resolves
  def self.vmUpTrigger(node, machineName)
    node.trigger.after :up do |trigger|
      
      trigger.name = "Hostmanager Check"
      trigger.ruby do |env,machine|
        machine_name_resolves = ""
        
        begin
          machine_name_resolves = IPSocket::getaddress("#{machineName}")
        rescue
        end
        if (machine_name_resolves == "")
          print "\e[31m"+"DevEnv hostname not resolving "+"\e[33m"+"(#{machineName}) - Try running "+"\e[31m"+"vagrant hostmanager"+"\e[33m"+" and see if that corrects it."+"\e[0m\n"
        else
          #print "machine_name_resolves: #{machine_name_resolves}\n"
        end

        # Hostmanager Sync on Up
        if ( self.isRunningInWsl() )
          print "vmUpTrigger\n"
          self.syncWindowsHostsFromWsl()
        end
      end
      
    end
  end
  
  # Hostmanager Sync on Destroy
  def self.vmDestroyTrigger(node)
    node.trigger.after :destroy do |trigger|
      trigger.name = "Hostmanager Sync"
      trigger.ruby do |env,machine|
        if ( self.isRunningInWsl() )
          print "vmDestroyTrigger\n"
          self.syncWindowsHostsFromWsl()
        end
      end
    end
  end
  
  # Check to see if vagrant is being executed from WSL
  def self.isRunningInWsl()

    if (RbConfig::CONFIG['host_os'] =~ /linux/)
      print "\e[33m"+"--- Running within Linux --- Checking for WSL"+"\e[0m\n"
      if (%x( uname -r ) =~ /Microsoft/ )
        print "\e[33m"+"--- Running within WSL Detected."+"\e[0m\n"
        return true
      end
    end

  end

  # Update Windows Hosts form WSL environment
  def self.syncWindowsHostsFromWsl()

    # Update Windows hosts file with vagrant-hostmanager entries
    # VAGRANTHOSTS=$(echo -e "\n""$(awk '/^## vagrant-hostmanager-start/,/^## vagrant-hostmanager-end$/' /etc/hosts)""\n")
    # WINHOSTS_NOVAGRANTHOSTS=$(awk '/^## vagrant-hostmanager-start/,/^## vagrant-hostmanager-end$/{next}{print}' /mnt/c/Windows/System32/drivers/etc/hosts)
    # echo -e "${WINHOSTS_NOVAGRANTHOSTS}${VAGRANTHOSTS}" > /mnt/c/Windows/System32/drivers/etc/hosts
    
    linuxHostsFile = "/etc/hosts"
    windowsHostsFile = "/mnt/c/Windows/System32/drivers/etc/hosts"

    print "\e[33m"+"Getting vagrant-hostmanager entries from Linux to rebuild Windows hosts file."+"\e[0m\n"
    vagrantHosts = %x( awk '/^## vagrant-hostmanager-start/,/^## vagrant-hostmanager-end$/' #{linuxHostsFile} )
    winHostsWithoutVagrantHosts = %x( awk '/^## vagrant-hostmanager-start/,/^## vagrant-hostmanager-end$/{next}{print}' #{windowsHostsFile} )
    #print "#{winHostsWithoutVagrantHosts}"
    #print "#{vagrantHosts}"

    print "\e[33m"+"Writing to Windows hosts file with vagrant-hostmanager entries."+"\e[0m\n"
    newWinHosts = "#{winHostsWithoutVagrantHosts}#{vagrantHosts}"
    file = Pathname.new(windowsHostsFile)
    file.open('wb') { |io| io.write(newWinHosts) }

  end

end