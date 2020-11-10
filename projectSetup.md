# Setup - Embed in Project

## Initialize application project directory

### Create a new project

```
# Create new project directory
cd ~/projects
mkdir example.lan
cd example.lan
```

### Use an existing project

```
# Clone project repo (expecting application root at root of repo)
cd ~/projects
git clone git@bitbucket.org:classyllama/example-com.git example.lan
cd example.lan
```

## Add DevEnv to project

You can embed the devenv repo references and project config files inside a Magento application repo in the `tools/devenv/` directory. You can do this easily with gitman, or follow a few simple commands if you can't or don't want to use gitman. Install devenv files into Magento project

### Create devenv directory

```
# Create the tools/devenv directory in your project's magento root
mkdir -p tools/devenv
cd tools/devenv
```

### Initialization of DevEnv Source Repo (with gitman)

```
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

### The steps gitman performs (alternatively without gitman)

```
# Installing dependencies...

mkdir -p tools/devenv/repo_sources
cd tools/devenv/repo_sources

git clone git@github.com:classyllama/devenv-vagrant.git devenv
cd devenv
git checkout --force master
  
# Running scripts...

./gitman_init.sh
```

### Adjust the sample config files for your project

Adjust configuration files with domain to use `example.lan` and any other project specific configs that should be different than the defaults
  `Vagrantfile.config.rb`
  `devenv_vars.config.yml`
  `mutagen.yml`

Some example reference implementations used for testing variations on environment configurations can be found in the [iac-test-lab] repo.

### Adjust README.md for existing project

Review the project README.md sample that was copied into the tools/devenv directory. You can customize the README.md in in the tools/devenv to contain project specific commands for initializing the devenv for your project.
  `README.md`

The files directly in the `tools/devenv` will contain the variants you need for your project's customizations, can be commited to your projects source code repo, and the `tools/devenv/repo_sources` directory containing this repo will just be cloned indepdenently on each developer's machine and ignored by your project's git repo.

### Initializing a new application project install

Build VM

    # [run from host]
    vagrant up

If the "Magento Demo Install" existed in the devenv_vars.config.yml file, Ansible would have created a Magento install script based on the variables specified.

Install Magento in VM using install script

    # [run from host]
    # ssh into vm
    vagrant ssh
    # This is equivilent to running "ssh www-data@example.lan"
    
    # [run from vm]
    ~/magento-demo/install-magento.sh config_site.json
    ln -s magento /var/www/data/current
    
    cd /var/www/data/magento
    bin/magento deploy:mode:set developer
    bin/magento config:set --lock-env system/full_page_cache/caching_application 1
    bin/magento cache:flush

Start Mutagen to sync files into your host system so they can be committed to a project repo

    # [run from host]
    mutagen project start
    mutagen sync monitor

Open in browser

Magento Frontend
https://example.lan/

Magento Backend (Admin)
https://example.lan/backend/

    # [run from vm]
    # Get credentials to login to Magento Admin
    cd /var/www/data
    sudo dnf -y install oathtool
    cat magento_admin_credentials.json
    # Generate Two Factor Auth code for admin user
    oathtool --time-step-size=30 --window=0 --totp=sha1 --base32 "$(cat magento_admin_credentials.json | jq -r .admin_tfa_secret)"

Additional notes on Demo Install and Two Factor Auth: https://github.com/classyllama/ansible-role-magento-demo#notes










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

Magento installation will be at `/var/www/data/magento`
Site Root will be at `/var/www/data/project/sitecode/pub` and `/var/www/data/project/sitecode` will be symlinked to `/var/www/data/magento`.

There is a `mutagen.yml` file that can be updated to sync files between the local host and the VM. The initial `mutagen.yml` was setup to work from a repo on the host and sync things into the VM for execution, and running a demo install on the VM where it creates all the files is the oposite of that, so I currently have the mutagen sync disabled to work with the demo install.

Whatever domains you have configured in your `Vagrantfile.config.rb` will be automatically added your system's hosts file via the vagrant-hostmanager plugin. The VM that starts up utilizes DHCP for a dynamic IP address allowing more than one devenv to be setup and operating simultaneously and independently of each other. The vagrant-hostmanager will take care of adjusting your machine's hosts file each time vagrant starts up the machine.

Run mutagen to sync files, and monitor it's status/activity

    mutagen project start
    mutagen sync monitor

When you are done, you will want to stop Mutagen and halt Vagrant

    mutagen sync terminate magento
    vagrant halt

# Updating Environment

To update an environment you can ensure the correct targetted version in the `gitman.yml` file and then run:

    gitman update devenv
