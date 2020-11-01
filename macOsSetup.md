# Requirements

- [Vagrant] macOS
- [Vagrant-Hostmanager] macOS
- [VirtualBox] macOS
- [Ansible] macOS
- [Git] macOS
- [Mutagen] macOS
- [Python] + [Gitman] macOS
- [PHP] + [Composer] + [jq] macOS
- Ability to sync root CA to local filesystem and trust it
- Ability to create predefined hosts entries for dev VMs.

## Additional macOS Requirements

- [Homebrew] macOS
    * Requirement: convenient
    * Implications: without a Homebrew, the user will have to install applications manually

## Check system requirements

  Tested on macOS Catalina 10.15

# Initial Setup

## Install Dependencies

### Brew

Install Homebrew using the "Install Homebrew" command on the official website: https://brew.sh/ .

### Tools

After Homebrew is installed, install the host dependencies using the following commands.

    brew cask install virtualbox
    brew cask install vagrant
    brew install ansible
    brew install mutagen-io/mutagen/mutagen
    pip3 install gitman
    vagrant plugin list
    vagrant plugin install vagrant-hostmanager
    vagrant plugin install vagrant-digitalocean


## Allow changes to hosts file

The `vagrant-hostmanager` automates adding and removing hosts file entries for dev VMs, which requires the user's password. Run the following snippet to allow `vagrant-hostmanager` to update hosts file without requiring password prompt

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

## Configure Virtualbox

Prior to provisioning the first dev env VM, Virtualbox (if being used) requires some network configuration changes using the following steps.

1. Open the Virtualbox application, and visit File -> Host Network Manager in the main menu.
2. Using the `Create` and `Remove` buttons at the top left, ensure that there are exactly two network adapters: `vboxnet0` and `vboxnet1`.
	1. If this configuration is done before provisioning any VMs, then there will already be a `vboxnet0` adapter, so all that is requried is to click `Create` to create the `vboxnet1` adapter.
	2. If this configuration was inadvertently skipped prior to provisioning a VM, both `vboxnet0` and `vboxnet1` may already exist, in which case this step can be skipped.
3. For the `vboxnet0` interface, configure the `Adapter` tab settings to match the following values.
	1. Configure Adapter Manually
	2. IPv4 Address: 10.19.89.1
	3. IPv4 Network Mask: 255.255.255.0
	4. IPv6 Address: <blank>
	5. IPv6 Prefix Length: 0
4. For the `vboxnet0` interface, configure the `DHCP Server` tab settings to match the following values.
	1. Enable Server: checked
	2. Server Address: 192.168.56.100
	3. Server Mask: 255.255.255.0
	4. Lower Address Bound: 192.168.56.101
	5. Upper Address Bound: 192.168.56.254
5. For the `vboxnet1` interface, configure the `Adapter` tab settings to match the following values.
	1. Configure Adapter Manually
	2. IPv4 Address: 172.28.128.1
	3. IPv4 Network Mask: 255.255.255.0
	4. IPv6 Address: <blank>
	5. IPv6 Prefix Length: 0
6. For the `vboxnet1` interface, configure the `DHCP Server` tab settings to match the following values.
	1. Enable Server: checked
	2. Server Address: 172.28.128.2
	3. Server Mask: 255.255.255.0
	4. Lower Address Bound: 172.28.128.3
	5. Upper Address Bound: 172.28.128.254
7. Close the Host Network Manager window.

# Host Configuration: Trusting Root CA

When the devenv is provisioned it will either use the root CA certificate/key files in `~/.devenv/rootca/` or if the do not exist when it provisions the VM, it will create new root CA files and copy them to your host's `~/.devenv/rootca/` directory.

This root CA is used to sign certs for all domains used in the devenv. If the root CA is added to the host as a trusted cert, the SSL cert for any host will automatically be valid.

To add the generated root CA to your trusted certs list on the host machine, run this command. **At least one dev env must have been successfully provisioned prior to running this command**.

```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/.devenv/rootca/devenv_ca.crt
```

This will apply to any applications (including browsers) which use the operating system root certificate store. Some applications maintain their own trusted root certificate store, and will need to be configured individually.

## Firefox

For Firefox you will need to add the certificate authority manually through Firefox's interface.
* Export the Vagrant DevEnv certificate authority from your System Keychain (right-click, 'Export "Vagrant DevEnv"')
* Navigate to your Firefox preferences
  * Click "Privacy & Security"
  * Scroll down to "Certificates" and click "View Certificates"
  * Select the "Authorities" section and click "Import..."
  * Select the Vagrant DevEnv cert authority exported in the first step



[Vagrant]: https://www.vagrantup.com/
[Virtualbox]: https://www.virtualbox.org/
[Vagrant-Hostmanager]: https://github.com/devopsgroup-io/vagrant-hostmanager
[Composer]: https://getcomposer.org/
[jq]: https://stedolan.github.io/jq/
[Digital Ocean Vagrant Provider]: https://github.com/devopsgroup-io/vagrant-digitalocean
[Ansible]: https://www.ansible.com/
[Mutagen]: https://mutagen.io/
[Gitman]: https://github.com/jacebrowning/gitman
[Homebrew]: https://brew.sh