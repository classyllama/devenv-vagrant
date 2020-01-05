# Starting

    vagrant up
    ssh www-data@dev-m2demo

NOTE:
We are working inside the VM as the `www-data` user NOT the `vagrant` user. Vagrant just helps us provision the resources, otherwise the VM is treated like any other remote machine.

    # From within VM
    ~/initialize-magento.sh

Magento installation will be at `/var/www/html/magento`
Site Root will be at `/var/www/html/project/sitecode/pub` and `/var/www/html/project/sitecode` will be symlinked to `/var/www/html/magento`.

There is a `mutagen.yml` file that can be updated to sync files between the local host and the VM. The initial `mutagen.yml` was setup to work from a repo on the host and sync things into the VM for execution, and running a demo install on the VM where it creates all the files is the oposite of that, so I currently have the mutagen sync disabled to work with the demo install.

Create host entries in `/etc/hosts` file

    10.19.89.32 dev-m2demo
    10.19.89.32 dev-m2demo.demo

https://dev-m2demo.demo/

# TODO
[X] Finish building `app_ssl.yml` for setting up shared root CA from host into VM for issuing SSL certs.
[ ] Determine what changes are needed to run this form Windows
    [ ] VirtualBox
    [ ] Vagrant
    [ ] Ansible
    [ ] Mutagen

[ ] Actually store something and utilize the attached persistent disk /data/ for DB and site files.

[ ] Allow `magento_data` mysql user to create databases
[ ] Either use the same password for magento_data mysql user each time or somehow update env.php files with new password on rebuild
    [ ] Restrict access to mysql to localhost to require SSH tunnel, at least for DO dev envs -- to avoid dev env possibly leaking client data
[ ] Either modify nginx backend template to allow all vhosts to use the same PHP-FPM socket, or ensure that the vhost-specific socket symlinks are recreated on reboot.

[ ] install bypassing varnish and using built-in full page cache
[ ] Get the ability to customize what user is logged into via `vagrant ssh`

  You can change what user is logged in with via the `vagrant ssh` command and it would be ideal to use that instead of `ssh www-data@dev-m2demo`

[ ] portable dev environment for any project

  Need to better define directory structure both in the VM and where these DevEnv files reside in relation to a project's repo and such. I may need to rethink how a demo install would work, and invole syncing up files with Mutagen between the host and VM, that way a demo install is compatible with the expectation of a repo residing on the host and syncing files over into the VM. There may need to be some kind of post install step to get things where they need to be or something, and a place holder on the host where once the demo files are installed the files are synced up to. Maybe we don't symlink after a demo install, and instead perform a copy to the project sitecode directory.

[ ] Look into utilizing Traefik
[ ] Look into using DNSMasq
[ ] Look into some kind of mail catcher to prevent actual sending of emails, but still have ability to review emails
    [ ] Mailtrap
    [ ] MailSlurper
    [ ] MailCatcher
    [ ] MailHog



# Notes on Windows Support

https://www.vagrantup.com/docs/other/wsl.html

# Notes on troubleshooting vagrant/virtualbox

    vboxmanage list
    VM_ID="exp-vagrant-m2_dev-m2demo_1564793526855_3776"
    vboxmanage showvminfo ${VM_ID} --machinereadable | grep '"SATA Controller-1-0"' 

    vagrant up --debug
    vboxmanage list hdds
    vboxmanage showmediuminfo disk /opt/alpacaglue/lab-example/gitman_sources/exp-vagrant-m2/persistent_data_disk.vmdk
    vboxmanage closemedium disk /opt/alpacaglue/lab-example/gitman_sources/exp-vagrant-m2/persistent_data_disk.vmdk --delete

    vboxmanage closemedium disk persistent_data_disk.vmdk --delete

# Notes on file sync with Mutagen

    brew install mutagen-io/mutagen/mutagen
    mutagen daemon start
    
    mutagen sync terminate devm2demo
    mutagen sync create \
      --name=devm2demo \
      --sync-mode=two-way-resolved \
      --symlink-mode=ignore \
      www-data@10.19.89.32:/var/www/html/magento \
      /opt/alpacaglue/lab-example/gitman_sources/exp-vagrant-m2/appcode
    mutagen sync list
    mutagen sync monitor
    
    
    
    https://mutagen.io/documentation/synchronization/permissions/
    
    mutagen sync list
    mutagen sync monitor projectCode
    mutagen sync pause projectCode
    mutagen sync resume projectCode
    
    mutagen sync <command> --help

# Installation

TODO: general installation instructions

## Digital Ocean

The [Digital Ocean Vagrant Provider] must be installed prior to running VMs in the cloud.

TODO: Describe how to populate DO token, etc, and any changes to Vagrantfile loading.

### Tips

* Add `export VAGRANT_DEFAULT_PROVIDER="digital_ocean"` to `~/.bash_profile` if using DO provider as default.

# Usage

## Starting Vagrant

* VirtualBox: `vagrant up <node>`
* Digital Ocean (older versions of vagrant)
    * `vagrant up <node> --provider=digital_ocean --no-provision`
    * Manually attach digital ocean block storage to VM
    * `vagrant provision <node>`


## Updating VM Virtual Host Configuration

When adding new site-specific codebases, run the following to update the VM's nginx SSL and vhost configuration to support the new site.

```
PLAYBOOK=provisioning/devenv_vhosts.yml vagrant provision <node>
```

TOOD: add instructions to create alias for above command.

# SSL

TODO: describe root CA cert signing mechanism.

To use a persistent root CA, after the first VM is provisioned, run a command such as the following to sync to your host machine.

```
mkdir -p local/rootca
rsync -avz root@dev-v72:/etc/nginx/ssl/rootca/certs local/rootca/
rsync -avz root@dev-v72:/etc/nginx/ssl/rootca/private local/rootca/
```














Digital Ocean Vagrant Provider: https://github.com/devopsgroup-io/vagrant-digitalocean