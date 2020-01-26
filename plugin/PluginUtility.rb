class PluginUtility
  
  def self.vmIsProvisioned(machineName)
    provision_file_exists = File.exist?(".vagrant/machines/#{machineName}/virtualbox/action_provision")
    # It's also good to know the machine's hostname is usable
    machine_name_resolves = false
    begin
      machine_name_resolves = IPSocket::getaddress("#{machineName}")
    rescue
    end
    return provision_file_exists && machine_name_resolves
  end
  
end