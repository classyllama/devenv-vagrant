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

### Additional macOS Requirements

- [Homebrew] macOS
    * Requirement: convenient
    * Implications: without a Homebrew, the user will have to install applications manually

### Check system requirements

  Tested on macOS Catalina 10.15

# Installation

### Brew

Install Homebrew
https://brew.sh/

### Tools

    brew cask install virtualbox
    brew cask install vagrant
    vagrant plugin list
    vagrant plugin install vagrant-hostmanager
    vagrant plugin install vagrant-digitalocean
    brew install ansible
    brew install mutagen-io/mutagen/mutagen
    brew install python

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

Add this to your bash profile `~/.bash_profile` to make sure python 3.x is default for shell commands.
For zsh you should put this in `~/.zshrc`

    export PATH="/usr/local/opt/python/libexec/bin:$PATH"

Check default python version

    python --version

Install Gitman (v1.7+)

    pip install gitman

# Setup - Host - Allow changes to hosts file

Allow vagrant-hostmanager to update hosts file without requiring password prompt

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


# Setup - Host - Trusting Root CA

When the devenv is provisioned it will either use the root CA certificate/key files in `~/.devenv/rootca/` or if the do not exist when it provisions the VM, it will create new root CA files and copy them to your host's `~/.devenv/rootca/` directory.

This root CA is used to sign certs for all domains used in the devenv. If the root CA is added to the host as a trusted cert, the SSL cert for any host will automatically be valid.

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
