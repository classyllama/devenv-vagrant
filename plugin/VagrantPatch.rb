# Patch for Vagrant 2.2.7 with VirtualBox 6.1
# May be resolved in newer versions of Vagrnt
# https://github.com/hashicorp/vagrant/issues/8878
class VagrantPlugins::ProviderVirtualBox::Action::Network
  def dhcp_server_matches_config?(dhcp_server, config)
    true
  end
end