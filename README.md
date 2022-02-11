# Summary

This repo provides the necesary pieces needed for setting up a Development Environment for Magento development.

# Host Assumptions

A goal of this dev env is to avoid as many host assumptions as possible in order to make the environment portable. Documented below are the actual assumptions and implications if the assumption is not correct for a given host.

# Host Requirement Installation

[macOS Setup](macOsSetup.md)

[Windows Setup](windowsSetup.md)

### Hard Requirements

- [Vagrant] installed on host.
    * Requirement: critical to start VMs
    * Implications: without Vagrant, VMs cannot be started.
- [Vagrant-Hostmanager] installed on host.
    * Requirement: important for standard operation
    * Implications: without this plugin, hosts files will not be updated when VM IP changes
- [VirtualBox] installed on host.
    * Requirement: critical if using local provider
    * Implications: without this hypervisor, local VMs cannot be used.
- [Ansible] installed on host.
    * Requirement: critical
    * Implications: without Ansible on the host, the dev env cannot be provisioned.
- [Git] installed on host.
    * Requirement: important for standard operation
    * Implications: without git on the host, the user will need to manage cloning the devenv-vagrant repo themselves.
- [Mutagen] installed on host.
    * Requirement: important for standard operation
    * Implications: without mutagen on the host, the user will need to manage file syncronziation themselves.

### Soft Requirements

- [Python] + [Gitman] installed on host.
    * Requirement: convenient
    * Implications: without gitman on the host, you would need to follow several manual commands to clone, and initialize this dev env template into a project
- Ability to sync root CA to local filesystem and trust it
    * Requirement: convenient
    * Implications: without trusting root CA, SSL certs will not be valid. Without syncing generated root CA to local filesystem, a new one will be generated on each VM (re)creation.
- Ability to create predefined hosts entries for dev VMs.
    * Requirement: convenient
    * Implications: without using predefined hosts entries on host, copy-paste commands may not work as expected.
- [PHP] + [Composer] + [jq] installed on host.
    * Requirement: convenient
    * Implications: allows composer credentials from host to be inserted into VM

# Reference Test Configs

Example reference implementations used for testing variations on environment configurations can be found in the [iac-test-lab] repo.

# Project Setup

[Project Setup](projectSetup.md)

# Troubleshooting

[Troubleshooting](troubleshooting.md)

# CentOS 8 Fix for outdated repositories URLs (EOL)
[CentOS 8 Fix](Centos8EOL.md)

# Supported Systems
[Supported Vagrant Systems (images)](SupportedOS.md)

# Mutagen
[Mutagen](mutagen.md)

# Optional Use

### Digital Ocean Provider

Use of Digital Ocean for running the virtual machine in the cloud rather than on your local machine via VirtualBox.

- [Digital Ocean Vagrant Provider] installed on host.
    * Requirement: critical if using DO provider
    * Implications: without this plugin, cloud VMs cannot be used.
    * https://github.com/devopsgroup-io/vagrant-digitalocean

The [Digital Ocean Vagrant Provider] must be installed prior to running VMs in the cloud.

    # Display details of an existing droplet
    export DO_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxx
    export DO_DROPLET_ID=xxxxxxxx
    curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${DO_TOKEN}" "https://api.digitalocean.com/v2/droplets/${DO_DROPLET_ID}" | jq .

TODO: Describe how to populate DO token, etc, and any changes to Vagrantfile loading.





[Vagrant]: https://www.vagrantup.com/
[Virtualbox]: https://www.virtualbox.org/
[Vagrant-Hostmanager]: https://github.com/devopsgroup-io/vagrant-hostmanager
[Composer]: https://getcomposer.org/
[jq]: https://stedolan.github.io/jq/
[Digital Ocean Vagrant Provider]: https://github.com/devopsgroup-io/vagrant-digitalocean
[Ansible]: https://www.ansible.com/
[Mutagen]: https://mutagen.io/
[Gitman]: https://github.com/jacebrowning/gitman
[iac-test-lab]: https://github.com/classyllama/iac-test-lab
