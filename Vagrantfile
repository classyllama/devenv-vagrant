# -*- mode: ruby -*-
# vi: set ft=ruby :

#require './plugin/PluginPersistDisk.rb'
#require './plugin/PluginMutagen.rb'


# include local variables, if present
require './Vagrantfile.local.rb' if File.file?('./Vagrantfile.local.rb')

Vagrant.configure('2') do |config|

  config.vm.define "v72" do |config|
      # for all providers, perform basic rysnc sync
      config.vm.synced_folder ".", "/vagrant", type: "rsync",
        rsync__exclude: [".git/", ".vagrant/", "*.dev/"]

      # Digital Ocean provider scenario
      config.vm.provider :digital_ocean do |provider, override|
        override.ssh.private_key_path = !DIGITAL_OCEAN_SSH_PRIVATE_KEY_PATH.empty? ? DIGITAL_OCEAN_SSH_PRIVATE_KEY_PATH : '~/.ssh/id_rsa'
        override.vm.box = 'digital_ocean'
        override.vm.box_url = "https://github.com/devopsgroup-io/vagrant-digitalocean/raw/master/box/digital_ocean.box"
        override.nfs.functional = false

        unless DIGITAL_OCEAN_SSH_KEY_NAME.empty?
          provider.ssh_key_name = DIGITAL_OCEAN_SSH_KEY_NAME
        end

        provider.token = DIGITAL_OCEAN_API_TOKEN
        provider.image = 'centos-7-x64'
        provider.region = 'nyc1'
        provider.size = 'c-2' # s-2vcpu-4gb
        #provider.volumes = [DIGITAL_OCEAN_BLOCK_VOLUME_ID] # @TODO: figure out proper value for this

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
          ansible.compatibility_mode = "2.0"
          ansible.extra_vars = {
            host_zoneinfo: File.readlink('/etc/localtime'),
            mysql_root_pw: FIXED_MYSQL_PW
          }
        end

        # penultamently, run DO-specific post-app playbook
        config.vm.provision "digital_ocean_post_app", type:'ansible' do |ansible|
          ansible.playbook = "provisioning/digital_ocean_post_app.yml"
          ansible.compatibility_mode = "2.0"
          ansible.extra_vars = {
            block_id: DIGITAL_OCEAN_BLOCK_VOLUME_ID
          }
        end

        # finally, always run vhost playbook on all "ups"
        config.vm.provision "vhost", type:'ansible', run: "always" do |ansible|
          ansible.playbook = "provisioning/devenv_vhosts.yml"
          ansible.compatibility_mode = "2.0"
        end
      end

  end

end

