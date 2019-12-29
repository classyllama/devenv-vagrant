# -*- mode: ruby -*-
# vi: set ft=ruby :

#require './plugin/PluginPersistDisk.rb'
#require './plugin/PluginMutagen.rb'

DIGITAL_OCEAN_BLOCK_VOLUME_ID = 'a6716aad-8424-4bcf-adb8-aedba4fa53b2'
DIGITAL_OCEAN_API_TOKEN = 'ef787ce8523f507fada1da911b09acd169e02418830a8156c1c5b0996bd50fef'

Vagrant.configure('2') do |config|

  config.vm.define "web72" do |config|
      # for all providers, perform basic rysnc sync
      config.vm.synced_folder ".", "/vagrant", type: "rsync",
        rsync__exclude: [".git/", ".vagrant/", "*.dev/"]

      # Digital Ocean provider scenario
      config.vm.provider :digital_ocean do |provider, override|
        override.ssh.private_key_path = '~/.ssh/id_rsa'
        override.vm.box = 'digital_ocean'
        override.vm.box_url = "https://github.com/devopsgroup-io/vagrant-digitalocean/raw/master/box/digital_ocean.box"
        override.nfs.functional = false

        provider.token = DIGITAL_OCEAN_API_TOKEN
        provider.image = 'centos-7-x64'
        provider.region = 'nyc1'
        provider.size = 'c-2' # s-2vcpu-4gb
        provider.volumes = [DIGITAL_OCEAN_BLOCK_VOLUME_ID]

        # first, run DO-specific playbook
        config.vm.provision "digital_ocean", type:'ansible' do |ansible|
          ansible.playbook = "provisioning/digital_ocean.yml"
          ansible.compatibility_mode = "2.0"
          ansible.extra_vars = {
            block_id: DIGITAL_OCEAN_BLOCK_VOLUME_ID
          }
        end

        # then, provider-agnostic app playbook
        config.vm.provision "app", type:'ansible' do |ansible|
          ansible.playbook = ENV['PLAYBOOK'] || "provisioning/build.yml"
          ansible.extra_vars = { host_zoneinfo: File.readlink('/etc/localtime') }
          ansible.compatibility_mode = "2.0"
        end

        # finally, always run vhost playbook on all "ups"
        config.vm.provision "vhost", type:'ansible', run: "always" do |ansible|
          ansible.playbook = "provisioning/devenv_vhosts.yml"
          ansible.compatibility_mode = "2.0"
        end
      end

  end

end

