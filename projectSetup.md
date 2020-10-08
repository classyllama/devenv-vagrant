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
