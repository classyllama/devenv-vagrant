# Summary

This repo provides the necesary pieces needed for setting up a Development Environment for Magento development.

# Setup - Embed in Project

You can embed the devenv repo references and project config files inside a Magento application repo in the `tools/devenv/` directory. You can do this easily with gitman, or follow a few simple commands if you can't or don't want to use gitman. Install devenv files into Magento project

##### Using gitman
```
# Create the tools/devenv directory in your project's magento root
mkdir -p tools/devenv
cd tools/devenv

# Create a gitman.yml file for gitman to initialize the devenv setup
echo "
location: repo_sources
sources:
- name: devenv
  type: git
  repo: git@github.com:classyllama/devenv-vagrant.git
  sparse_paths:
  -
  rev: master
  link:
  scripts:
  - ./gitman_init.sh
" | tee ./gitman.yml

# Have gitman pull down the repo and run the initialization script
gitman install

# Lock the devenv repo at the commit it just checked out.
gitman lock
```

##### Without gitman
```
# Create the tools/devenv directory in your project's magento root
mkdir -p tools/devenv/repo_sources
git clone git@github.com:alpacaglue/exp-vagrant-m2.git tools/devenv/repo_sources/devenv
cd tools/devenv/repo_sources/devenv
./gitman_init.sh
```

##### Adjust the sample config files for your project
Adjust configuration files with domain to use `example.lan` and any other project specific configs that should be different than the defaults
  `Vagrantfile.config.rb`
  `devenv_vars.config.yml`
  `mutagen.yml`

Reference the project README.md sample that was copied into the tools/devenv directory. You can customize the README.md in in the tools/devenv to contain project specific commands for initializing the devenv for your project.

The files directly in the `tools/devenv` will contain the variants you need for your project's customizations, can be commited to your projects source code repo, and the `tools/devenv/repo_sources` directory containing this repo will just be cloned indepdenently on each developer's machine and ignored by your project's git repo.

# Setup - Standalone - Multi-Project Environment

Clone this repo to some general location where you'd like to store multiple projects such as `~/devenv/` then you can store all your project's files in the `projects` directory.

Copy devenv config files from the samples in the repo

    cp Vagrantfile.config.rb.sample Vagrantfile.config.rb
    cp Vagrantfile.local.rb.sample Vagrantfile.local.rb
    cp provisioning/devenv_vars.config.yml.sample provisioning/devenv_vars.config.yml
    cp mutagen.yml.sample mutagen.yml
    cp provisioning/devenv_playbook.config.yml.sample persistent/devenv_playbook.config.yml

Edit and configure your devenv by editing the following files:

- Vagrantfile.config.rb
- provisioning/devenv_vars.config.yml
- mutagen.yml

Start your devenv

    vagrant up
    vagrant ssh

NOTE:
We are working inside the VM as the `www-data` user NOT the `vagrant` user. The VagrantFile is configured to log you in as the `www-data` user once it is provisioned.

    # From within VM
    ~/initialize-magento.sh

Magento installation will be at `/var/www/html/magento`
Site Root will be at `/var/www/html/project/sitecode/pub` and `/var/www/html/project/sitecode` will be symlinked to `/var/www/html/magento`.

There is a `mutagen.yml` file that can be updated to sync files between the local host and the VM. The initial `mutagen.yml` was setup to work from a repo on the host and sync things into the VM for execution, and running a demo install on the VM where it creates all the files is the oposite of that, so I currently have the mutagen sync disabled to work with the demo install.

Whatever domains you have configured in your `Vagrantfile.config.rb` will be automatically added your system's hosts file via the vagrant-hostmanager plugin. The VM that starts up utilizes DHCP for a dynamic IP address allowing more than one devenv to be setup and operating simultaneously and independently of each other. The vagrant-hostmanager will take care of adjusting your machine's hosts file each time vagrant starts up the machine.

Run mutagen to sync files, and monitor it's status/activity

    mutagen project start
    mutagen sync monitor

When you are done, you will want to stop Mutagen and halt Vagrant

    mutagen sync terminate magento
    vagrant halt

# Setup - Host - Trusting Root CA

When the devenv is provisioned it will either use the root CA certificate/key files in `~/.devenv/rootca/` or if the do not exist when it provisions the VM, it will create new root CA files and copy them to your host's `~/.devenv/rootca/` directory.

This root CA is used to sign certs for all domains used in the devenv. If the root CA is added to the host as a trusted cert, the SSL cert for any host will automatically be valid.

##### Mac
To add the generated root CA to your trusted certs list on the host machine, run this command (after vagrant up has been run):

```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/.devenv/rootca/devenv_ca.crt
```

For Firefox you will need to add the certificate authority manually through Firefox's interface.
* Export the Vagrant DevEnv certificate authority from your System Keychain (right-click, 'Export "Vagrant DevEnv"')
* Navigate to your Firefox preferences
  * Click "Privacy & Security"
  * Scroll down to "Certificates" and click "View Certificates"
  * Select the "Authorities" section and click "Import..."
  * Select the Vagrant DevEnv cert authority exported in the first step


##### Windows
To add the generated root CA to your certificate manager on Windows you will need to copy the `~/.devenv/rootca/devenv_ca.crt` file to a location on your Windows system like `C:\certs\devenv_ca.crt` and then open a Command Prompt window in Administrator mode to execute the following command

```bash
certutil –addstore -enterprise –f "Root" c:\certs\devenv_ca.crt
```


# Host Assumptions

A goal of this dev env is to avoid as many host assumptions as possible in order to make the environment portable. Documented below are the actual assumptions and implications if the assumption is not correct for a given host.

## Hard Requirements

1. [Vagrant] installed on host.
    * Requirement: critical to start VMs
    * Implications: without Vagrant, VMs cannot be started.
2. [Vagrant-Hostmanager] installed on host.
    * Requirement: important for standard operation
    * Implications: without this plugin, hosts files will not be updated when VM IP changes
    * https://github.com/devopsgroup-io/vagrant-hostmanager
3. [VirtualBox] installed on host.
    * Requirement: critical if using local provider
    * Implications: without this plugin, local VMs cannot be used.
3. [Digital Ocean Vagrant Provider] installed on host.
    * Requirement: critical if using DO provider
    * Implications: without this plugin, cloud VMs cannot be used.
    * https://github.com/devopsgroup-io/vagrant-digitalocean
5. [Ansible] installed on host.
    * Requirement: critical
    * Implications: without Ansible on the host, the dev env cannot be provisioned.
    * https://www.ansible.com/
6. [Mutagen] installed on host.
    * Requirement: important for standard operation
    * Implications: without mutagen on the host, the user will need to manage file syncronziation themselves.
    * https://mutagen.io/

## Soft Requirements

1. [Gitman] installed on host.
    * Requirement: convenient
    * Implications: without gitman on the host, you would need to follow several manual commands to clone, and initialize this dev env template into a project
    https://github.com/jacebrowning/gitman
2. Ability to sync root CA to local filesystem and trust it
    * Requirement: convenient
    * Implications: without trusting root CA, SSL certs will not be valid. Without syncing generated root CA to local filesystem, a new one will be generated on each VM (re)creation.
3. Ability to create predefined hosts entries for dev VMs.
    * Requirement: convenient
    * Implications: without using predefined hosts entries on host, copy-paste commands may not work as expected.
4. [Composer] + [jq] installed on host.
    * Requirement: convenient
    * Implications: allows composer credentials from host to be inserted into VM


# Host Requirement Installation

##### MacOS
  
    brew cask install virtualbox
    brew cask install vagrant
    vagrant plugin list
    vagrant plugin install vagrant-hostmanager
    vagrant plugin install vagrant-digitalocean
    brew install ansible
    brew install mutagen
    
    # Allow vagrant-hostmanager to update hosts file without requiring password prompt
```
HOME_DIR="${HOME}"
USER_GROUP_NAME="$(id -gn $(whoami))"
echo "
HOME_DIR: ${HOME_DIR}
USER_GROUP_NAME: ${USER_GROUP_NAME}
VAGRANT_HOME: ${VAGRANT_HOME}
"
echo "
Cmnd_Alias VAGRANT_HOSTMANAGER_UPDATE = /bin/cp ${VAGRANT_HOME}/tmp/hosts.local /etc/hosts
%${USER_GROUP_NAME} ALL=(root) NOPASSWD: VAGRANT_HOSTMANAGER_UPDATE
" | sudo tee /etc/sudoers.d/vagrant_hostmanager
```

##### Windows

TODO: general installation instructions

Vagrant WSL Details:
https://www.vagrantup.com/docs/other/wsl.html

## Digital Ocean

The [Digital Ocean Vagrant Provider] must be installed prior to running VMs in the cloud.

    # Display details of an existing droplet
    export DO_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxx
    export DO_DROPLET_ID=xxxxxxxx
    curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${DO_TOKEN}" "https://api.digitalocean.com/v2/droplets/${DO_DROPLET_ID}" | jq .

TODO: Describe how to populate DO token, etc, and any changes to Vagrantfile loading.





### Tips

* Add `export VAGRANT_DEFAULT_PROVIDER="digital_ocean"` to `~/.bash_profile` if using DO provider as default.
* To debug vagrant execution run `VAGRANT_LOG=debug` to get verbos debug output during execution of `vagrant` commands.
* Remove keys from your system's known hosts file `ssh-keygen -R hostname`
* If `vagrant ssh` doesn't do anything, your /etc/hosts file may be corrupt.
    The entry may be in the hosts file, but running `ssh www-data@example.lan` results in an error `ssh: Could not resolve hostname`. It could also be line endings in the file.
    Check that file is of type `charset=us-ascii`
    
        file -I /etc/hosts

# Usage

## Starting Vagrant

* VirtualBox: `vagrant up <node>`
* Digital Ocean (older versions of vagrant)
    * `vagrant up <node> --provider=digital_ocean --no-provision`
    * Manually attach digital ocean block storage to VM
    * `vagrant provision <node>`

## Importing Database

  List the databases on the DevEnv
  
    echo "show databases;" | vagrant ssh -c "mysql" -- -q
  
    pv database_dump_file.sql | vagrant ssh -c "mysql" -- -q

## Additional Dev Tools

https://atom.io/

## Updating VM Virtual Host Configuration

When adding new site-specific codebases, run the following to update the VM's nginx SSL and vhost configuration to support the new site.

```
vagrant provision --provision-with vhost <node>
```

TOOD: add instructions to create alias for above command.

# Notes on troubleshooting vagrant/virtualbox

If you see a VERR_ALREADY_EXISTS error, you might need to purge an old value out of VirtualBox disk management inventory.

    vboxmanage list
    VM_ID="exp-vagrant-m2_dev-m2demo_1564793526855_3776"
    vboxmanage showvminfo ${VM_ID} --machinereadable | grep '"SATA Controller-1-0"' 

    vagrant up --debug
    vboxmanage list hdds
    DISK_PATH="data_disk.vmdk"
    vboxmanage showmediuminfo disk ${DISK_PATH}
    vboxmanage closemedium disk ${DISK_PATH} --delete

[Virtualbox]: https://www.virtualbox.org/
[Vagrant-Hostmanager]: https://github.com/devopsgroup-io/vagrant-hostmanager
[Composer]: https://getcomposer.org/
[jq]: https://stedolan.github.io/jq/
[Digital Ocean Vagrant Provider]: https://github.com/devopsgroup-io/vagrant-digitalocean
[Ansible]: https://www.ansible.com/
[Mutagen]: https://mutagen.io/
[Gitman]: https://github.com/jacebrowning/gitman
