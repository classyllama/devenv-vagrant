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
  def self.vmUpTrigger(node)
    node.trigger.after :up do |trigger|
      
      trigger.name = "Hostmanager Check"
      trigger.ruby do |env,machine|
        machine_name_resolves = ""
        
        begin
          machine_name_resolves = IPSocket::getaddress("#{DEV_MACHINE_NAME}")
        rescue
        end
        if (machine_name_resolves == "")
          print "\e[31m"+"DevEnv hostname not resolving "+"\e[33m"+"(#{DEV_MACHINE_NAME}) - Try running "+"\e[31m"+"vagrant hostmanager"+"\e[33m"+" and see if that corrects it."+"\e[0m\n"
        else
          #print "machine_name_resolves: #{machine_name_resolves}\n"
        end
      end
      
    end
  end
end