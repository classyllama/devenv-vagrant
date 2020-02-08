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
[ ] Store composer cache on persistent storage to improve setup time between VM rebuilds

[ ] Actually store something and utilize the attached persistent disk /data/ for DB and site files.

[ ] install bypassing varnish and using built-in full page cache
[ ] Get the ability to customize what user is logged into via `vagrant ssh`

  You can change what user is logged in with via the `vagrant ssh` command and it would be ideal to use that instead of `ssh www-data@dev-m2demo`

[ ] portable dev environment for any project

  Need to better define directory structure both in the VM and where these DevEnv files reside in relation to a project's repo and such. I may need to rethink how a demo install would work, and invole syncing up files with Mutagen between the host and VM, that way a demo install is compatible with the expectation of a repo residing on the host and syncing files over into the VM. There may need to be some kind of post install step to get things where they need to be or something, and a place holder on the host where once the demo files are installed the files are synced up to. Maybe we don't symlink after a demo install, and instead perform a copy to the project sitecode directory.

[ ] Look into utilizing Traefik
[-] Look into using DNSMasq
  Utilizing vagrant-hostmanager may reduce the need for DNSMasq
[ ] Look into some kind of mail catcher to prevent actual sending of emails, but still have ability to review emails
    [ ] Mailtrap
    [ ] MailSlurper
    [ ] MailCatcher
    [ ] MailHog

[ ] Review/Refactor/Refine SSL Implementation for VirtualBox project setup
[ ] Review/Refactor/Refine Windows compatibility with VirtualBox project setup

# Notes on Windows Support

https://www.vagrantup.com/docs/other/wsl.html

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
    
    # to use mutagen.yml
    mutagen project start
    
    https://mutagen.io/documentation/synchronization/permissions/
    
    mutagen sync list
    mutagen sync monitor projectCode
    mutagen sync pause projectCode
    mutagen sync resume projectCode
    
    mutagen sync <command> --help

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
6. [Mutagen] installed on host.
    * Requirement: important for standard operation
    * Implications: without mutagen on the host, the user will need to manage file syncronziation themselves.

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

## Ansible

It is assumed that Ansible is installed on the host.

# Installation

MacOS
  
    brew install virtualbox
    brew install vagrant
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

Windows

TODO: general installation instructions

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

## Project Setup

Install devenv files into Magento project

```
mkdir -p tools/devenv
cd tools/devenv

echo "
location: repo_sources
sources:
- name: devenv
  type: git
  repo: git@github.com:alpacaglue/exp-vagrant-m2.git
  sparse_paths:
  -
  rev: feature/project-attempt
  link:
  scripts:
  - ./gitman_init.sh
" | tee ./gitman.yml

gitman install
```

Adjust configuration files with domain to use `example.lan` and any other project specific configs that should be different than the defaults
  `Vagrantfile.config.rb`
  `devenv_vars.config.yml`
  `devenv_playbook.config.yml`
  `mutagen.yml`

Start Vagrant

    vagrant up

Start Mutagen

    mutagen project start

Initialize files if needed

    cd /var/www/html/magento

    composer install

Setup configs for env.php

    cd /var/www/html/magento

    mkdir pub/media
    mkdir pub/static

    bin/magento setup:install \
      --base-url="https://example.lan" \
      --base-url-secure="https://example.lan" \
      --backend-frontname="backend" \
      --use-rewrites=1 \
      --admin-user="admin" \
      --admin-firstname="admin" \
      --admin-lastname="admin" \
      --admin-email="admin@example.lan" \
      --admin-password="admin123" \
      --db-host="127.0.0.1" \
      --db-user="root" \
      --db-password="qwerty" \
      --db-name="demo_data" \
      --magento-init-params="MAGE_MODE=developer" \
      --use-secure=1 \
      --use-secure-admin=1 \
      --session-save=redis \
      --session-save-redis-host=127.0.0.1 \
      --session-save-redis-port=6380 \
      --session-save-redis-db=0 \
      --cache-backend=redis \
      --cache-backend-redis-server=127.0.0.1 \
      --cache-backend-redis-db=0 \
      --cache-backend-redis-port=6379 \
    ;

Import Database from stage

  If you want to keep the database dump file from stage in your project directory it may be best to store it in the `tools/devenv` directory so that it doesn't get synced down to the VM as mutagen ignores the `tools/devenv` directory.

    echo "
    mysql -e 'show databases'
    " | ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        www-data@example.com

    echo "show databases" | vagrant ssh -c "mysql" -- -q

    echo "
    mysqldump \
        --single-transaction \
        --routines \
        --events \
        --default-character-set=utf8 \
        demo_data | gzip
    " | ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        www-data@example.com \
      | pv | gunzip \
      | vagrant ssh -c \
      "mysql -D demo_data --default-character-set=utf8" -- -q

Sync Media Files

  Run from within the VM

    rsync -avz --progress \
      -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR" \
      --exclude="catalog/product/cache" \
      --exclude="cache/*" \
      --exclude="/captcha/*" \
      --exclude="/tmp/*" \
      --exclude="/productFeed/*" \
      --exclude="/klevu_images/*" \
      www-data@example.com:/var/www/html/shared/pub/media/ \
      /var/www/html/magento/pub/media/

Setup configs for devenv

    cd /var/www/html/magento

    # Configure Magento
    bin/magento config:set web/unsecure/base_url https://example.lan/
    bin/magento config:set web/secure/base_url https://example.lan/
    bin/magento config:set web/unsecure/base_static_url https://example.lan/static/
    bin/magento config:set web/secure/base_static_url https://example.lan/static/
    bin/magento config:set web/unsecure/base_media_url https://example.lan/media/
    bin/magento config:set web/secure/base_media_url https://example.lan/media/

    bin/magento config:set dev/static/sign 0
    bin/magento config:set system/full_page_cache/caching_application 1

    bin/magento app:config:import
    bin/magento cache:flush
    bin/magento deploy:mode:set developer
    bin/magento cache:flush

    mr admin:user:create \
      --admin-user=admin \
      --admin-password=admin123 \
      --admin-email=admin@example.lan \
      --admin-firstname=admin \
      --admin-lastname=admin

    # Save admin credentials as indicator that script completed successfully
```
ADMIN_CREDENTIALS=$(cat <<CONTENTS_HEREDOC
{
  "base_url": "https://example.lan/",
  "admin_url": "$https://example.lan/backend",
  "admin_user": "admin",
  "admin_pass": "admin123"
}
CONTENTS_HEREDOC
)
echo "${ADMIN_CREDENTIALS}" > magento_admin_credentials.json
``` 

Monitor Mutagen

    mutagen sync monitor

Open in browser

  https://espressoservices.lan/

## Updating VM Virtual Host Configuration

When adding new site-specific codebases, run the following to update the VM's nginx SSL and vhost configuration to support the new site.

```
vagrant provision --provision-with vhost <node>
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













Ansible: https://www.ansible.com/
Mutagen: https://www.ansible.com/
Digital Ocean Vagrant Provider: https://github.com/devopsgroup-io/vagrant-digitalocean