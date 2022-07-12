# Molecule Framework

## Installation

Please refer to the Confluence documentation on [Molecule Installation](https://confluence.classyllama.com/x/x5DKAg)

## Using

When Molecule and Docker are installed we can use the following steps to test the different environments:

Build Docker containers for available OSes:

    molecule create -s centos7-latest
    molecule create -s rocky8-latest

Run IaC repo provisioning for a particular environment:

    molecule converge -s centos7-latest
    molecule converge -s rocky8-latest

Detroy the Docker containers:

    molecule destroy -s centos7-latest
    molecule destroy -s rocky8-latest

This is only one of the scenarios that can be used, please refer to [Molecule documentation](https://confluence.classyllama.com/x/vJDKAg) to see all possible options.

## Difference between real environment

We use converge.yml playbook for tests, it is basically a copy of devenv.yml with couple of changes:

1. The Ansible task 'change hostname to myserver' is disabled due to Docker limitations.

2. The following Ansible roles are disabled because we can't modify `/etc/hosts` inside the container and we can't modify the timezone in the Docker containers:

    - `local.timezone`
    - `classyllama.hostsfile`

3. Custom playbook is disabled ('import_playbook: ../persistent/devenv_playbook.config.yml').	

All the configuration files (devenv_vars.custom.yml) were copied 'as is' from the appropriate instances of the [Iac-Test-Lab](https://github.com/classyllama/iac-test-lab) repository. 
However, we need to include a custom var file to override some variables (`molecule_vars.config.yml`):

1. Since we don't have /data/ directory inside docker container, we use a default MySQL datadir location

    `mysqld_datadir: /var/lib/mysql`

2. The following fix is needed for Docker containers because /tmp is mounted with noexec flag (similar to Rackspace environments)

    `es_tmp_dir: /var/lib/elasticsearchtmp`

3. We need to override the postfix parameters for `inet_interfaces` and `inet_protocols` options to avoid using IPv6 interface ('localhost' is mapped to 127.0.0.1 and ::1 and it is impossible to modify /etc/hosts inside the container).

4. The package 'coreutils' is removed from the list of 'Common Software Packages' due to conflict with 'coreutils-single' which is installed by default on Docker containers for RockyLinux8.

## Molecule CLI

Please refer to the Confluence documentation on [Molecule CLI](https://confluence.classyllama.com/x/vpDKAg)


## Docker images

Currently we use the following Docker images built by community:

    - centos7-latest - https://github.com/geerlingguy/docker-centos7-ansible
    - rocky8-latest - https://github.com/geerlingguy/docker-rockylinux8-ansible
