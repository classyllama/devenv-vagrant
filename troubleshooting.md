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

## Magento CLI Proxy

Normally you would SSH into Vagrant using `vagrant ssh` to run `bin/magento` commands. To make things easier there is a Magento CLI proxy in this package. You can run `bin/magento` commands while in the `devenv` directory and the commands will be proxied to the vagrant vm.

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
