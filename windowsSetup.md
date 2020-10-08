# Requirements

- [Vagrant] Windows / WSL
- [Vagrant-Hostmanager] WSL
- [VirtualBox] Windows
- [Ansible] WSL
- [Git] Windows / WSL
- [Mutagen] Windows
- [Python] + [Gitman] Windows / WSL
- [PHP] + [Composer] + [jq] Windows / WSL
- Ability to sync root CA to local filesystem and trust it
- Ability to create predefined hosts entries for dev VMs.

### Additional Windows Requirements

- [WSL (Windows Subsystem for Linux v1)] Windows
    * Requirement: critical to utilize Ansible with Vagrant
    * Implications: without WSL, Vagrant can not build and configure the VM
- [WSL Distribution Image - CentOS8] Windows
    * Requirement: critical to utilize WSL
    * Implications: without a CentOS8 WSL distribution, the user will need to setup their own distribution and translate commands for that distribution
- [Windows for OpenSSH] Windows
    * Requirement: important for standard operation
    * Implications: without Windows for OpenSSH, Mutagen may not be able to properly connect to the DevEnv to sync files
- [Windows Developer Mode] Windows
    * Requirement: convenient
    * Implications: Allow symbolic link creation in WSL to also work in Windows
- [Carbon Powershell Module] Windows
    * Requirement: convenient
    * Implications: Allow symbolic link creation in WSL to also work in Windows
- [Microsoft Windows Terminal] Windows
    * Requirement: convenient
    * Implications: without Microsoft Windows Terminal, the user will need to use PowerShell or the Command Prompt directly
- [VSCode] Windows
    * Requirement: convenient
    * Implications: without VSCode, the user will need to setup and configure their own IDE
- [Chocolatey] Windows
    * Requirement: convenient
    * Implications: without a Chocolatey, the user will have to install applications manually
- [keychain] WSL
    * Requirement: convenient
    * Implications: without keychain, the user will need to enter private key passwords on each WSL shell that is opened

### Check system requirements (Powershell)

  Tested on WindowsProductName Windows 10 Pro, WindowsVersion 2004

    # System Info
    Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer

  Display list of WSL environments with WSL version

    wsl --list --verbose 

# Installation

### Manual GUI Step

    # ----------------------------
    # Install xDebug helper for Edge Web Browser
    # https://microsoftedge.microsoft.com/addons/detail/xdebug-helper/ggnngifabofaddiejjeagbaebkejomen
    # ----------------------------

    # ----------------------------
    # Disable python and python3 in "Manage App Execution Aliases"
    # ----------------------------

### Chocolatey (Powershell as Administrator)

  Install chocolatey (Windows software package manager)
  https://chocolatey.org/install

    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    
    # Enable use of -y flag to bypass prompt on each installation
    choco feature enable -n allowGlobalConfirmation

    # Make sure Chocolatey is up to date
    choco upgrade chocolatey

  Chocolatey Management Commands

    # List all Chocolatey installed packages
    choco list --localonly

    # List all Chocolatey packages that could be upgraded
    choco upgrade all --noop

    # Upgrade all Chocolatey packages
    choco upgrade all -y

    # List installed PowerShell modules
    Get-InstalledModule

    # List all available PowerShell modules that can be installed
    Get-Module -ListAvailable

### Tools (Powershell as Administrator)

  Virtualbox and Vagrant

    # Install VirtualBox and Vagrant
    choco install virtualbox vagrant -y

  Enable WSL

    #Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
    choco install wsl -y

  Microsoft Windows Terminal

    choco install microsoft-windows-terminal -y

  Utilities - Source Control / JSON Parsing

    choco install git jq -y

  Languages - PHP / Python

    # Install PHP 7.3
    # Find latest 7.3.x version https://chocolatey.org/packages/php/#versionhistory
    choco install php --version=7.3.23 -y
    # Installs to C:\tools\php73\
    
    # Install Python 3.x
    choco install python -y

  Editor / IDE - Visual Studio Code

    choco install vscode --params "/NoDesktopIcon" -y

    # Launch VSCode from the command line
    code

    # Disable builtin vscode extensions
    get-content $env:APPDATA\Code\User\settings.json
    # If the file doesn't exist, you can create a new file
    set-Content -Encoding UTF8  $env:APPDATA\Code\User\settings.json ('{"php.suggest.basic": false}')

    # Install VSCode Extensions for Magento (PHP) Development
    # https://code.visualstudio.com/docs/editor/extension-gallery
    code --install-extension felixfbecker.php-intellisense
    code --install-extension felixfbecker.php-debug
    code --install-extension neilbrayfield.php-docblocker
    # code --install-extension ikappas.phpcs
    # code --install-extension junstyle.php-cs-fixer

  Windows with OpenSSH
  https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse

    Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
    Add-WindowsCapability -Name "OpenSSH.Client~~~~0.0.1.0" -Online

    # Configure and Start the ssh-agent service
    Set-Service ssh-agent -StartupType Automatic
    Start-Service ssh-agent
    Get-Service ssh-agent

  Configure Windows hosts file permissions for scripted changes
  This is what allows for automatic domain mapping to variable IP (due to DHCP) of Virtual Machine

    # Update permissions on Windows hosts file to allow for user changes without Admin UAC permissions
    # Granting current user FullControl of file for editing purposes
    $myPath = "$env:windir\System32\drivers\etc\hosts"
    $curUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $myAcl = Get-Acl "$myPath"
    $myAclEntry = "$curUser","FullControl","Allow"
    $myAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($myAclEntry)
    $myAcl.SetAccessRule($myAccessRule)
    $myAcl | Set-Acl "$MyPath"
    Get-Acl "$myPath" | fl

  Mutagen
  https://mutagen.io/documentation/introduction/installation

    # Download Windows Binaries from GitHub Releases
    # https://github.com/mutagen-io/mutagen/releases/latest
    $download = 'https://github.com/mutagen-io/mutagen/releases/download/v0.11.7/mutagen_windows_amd64_v0.11.7.zip'
    $destination = "$Env:USERPROFILE\Downloads\mutagen_windows_amd64_v0.11.7.zip"
    Invoke-WebRequest -Uri $download -OutFile $destination

    # Extract exe binary to program directory
    $mutagenPath = "$Env:PROGRAMFILES\Mutagen"
    If(!(test-path $mutagenPath)) { New-Item -ItemType Directory -Force -Path $mutagenPath }
    Expand-Archive $destination $mutagenPath

    # add exe location to this session's path
    Set-Item -Path Env:Path -Value ($Env:Path + ";$Env:PROGRAMFILES\Mutagen")
    # Set in path permanently
    $oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path 
    $newpath = "$oldpath;$Env:PROGRAMFILES\Mutagen"
    Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
    # Get session's path environment variable
    Get-Content -Path Env:Path
    mutagen version

  Windows Symlink Support
  Configure Windows user to allow symbolic link creation for compatibility with WSL use of symlinks

    # Enable Developer Mode (from Powershell)
    # https://docs.microsoft.com/en-us/windows/uwp/get-started/enable-your-device-for-development
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowAllTrustedApps" /d "1"
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"

    # Providing SeCreateSymbolicLinkPrivilege to normal user
    # List existing privileges
    whoami /priv
    # Install Carbon (from administrator terminal)
    choco install Carbon -y
    refreshenv
    Get-ExecutionPolicy
    # Default execution policy is "Restricted"
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
    Import-Module 'Carbon'
    # Grant SeCreateSymbolicLinkPrivilege Privilegen (from administrator terminal)
    Grant-Privilege -Identity $Env:UserName -Privilege SeCreateSymbolicLinkPrivilege
    # Test SeCreateSymbolicLinkPrivilege Privilege (from administrator terminal)
    Test-Privilege -Identity $Env:UserName -Privilege SeCreateSymbolicLinkPrivilege

  Git Config

    # Set name and email in git config
    git config --global user.name "First Last"
    git config --global user.email name@example.com

    # Make sure git is configured to use the Windows for OpenSSH binaries
    git config --global core.sshCommand (get-command ssh).Source.Replace('\','/')

    # Prevent Windows based git operations from altering file contents which need to work properly on Linux environments
    git config --global core.autocrlf false
    git config --global core.eol lf
    git config --global core.filemode false

### Manual GUI Step

    # ----------------------------
    # Close and Restart Terminal Application
    # This reloads environment variables necessary for the next steps
    # ----------------------------

### Tools (Powershell as Administrator)

  Install Gitman
  https://gitman.readthedocs.io/
  Language-agnostic dependency manager using Git

    # Confirm python version (3.x)
    python --version

    pip install gitman

### Manual GUI Step

    # ----------------------------
    # Reboot Windows
    # ----------------------------

### WSL (Powershell as Administrator)

  Download CentOS8 WSL Distro Launcher and rootfs
  https://github.com/Microsoft/WSL-DistroLauncher
  https://github.com/yuk7/wsldl

    # CentOS8 build based on official CentOS8 image distributions - repackaged with WSL Distribution Launcher
    # See https://github.com/mishamosher/CentOS-WSL/blob/8/build.sh
    $download = 'https://github.com/mishamosher/CentOS-WSL/releases/download/8.2-2004/CentOS8.zip'
    $destination = "$Env:USERPROFILE\Downloads\CentOS8.zip"
    Invoke-WebRequest -Uri $download -OutFile $destination -UseBasicParsing

    # Extract and Install WSL Distro
    $path = "$Env:USERPROFILE\WSL\CentOS8"
    If(!(test-path $path)) { New-Item -ItemType Directory -Force -Path $path }
    Expand-Archive $destination $path
    Start-Process "$path\CentOS8.exe" -Verb runAs -Wait

    # Initialize Distro User
    wsl adduser $Env:UserName
    wsl usermod -a -G wheel $Env:UserName

    wsl echo "echo '$Env:UserName  ALL=(ALL)       NOPASSWD: ALL' > /etc/sudoers.d/wsl_user"
    # Copy the results of the above command, launch wsl and paste the command in to allow passwordless sudo access
    wsl
    # or manually edit sudoers file to allow wheel group sudo access without password
    exit
    # exit WSL to return to PowerShell

    # Change the default login user wsl will use
    Start-Process -FilePath "$path\CentOS8.exe" -ArgumentList "config --default-user $Env:UserName"

### SSH Keys (Powershell)

  Create new ssh keypair (ssh-keygen) or import existing keys into $Env:USERPROFILE\.ssh\

  If generating a new keypair please use a password on your private key
  Consider using a password manager such as 1Password

    ssh-keygen

  Add private key (~/.ssh/id_rsa) to ssh-agent

    ssh-add $Env:USERPROFILE\.ssh\id_rsa

  Test SSH access to confirm if you have a machine you can use to test access

    ssh user@hostname

### WSL Environment Setup (WSL)

    wsl

  Install software needed insdie WSL (as root)

    # ----------------------------
    # Run inside WSL Container - Elevate to root for installs
    # ----------------------------
    sudo -i

    dnf -y install epel-release
    dnf -y update

    dnf -y install ansible python-pip wget dos2unix git php php-json jq

    pip3 install --upgrade pip
    pip3 install gitman
    pip3 install python-vagrant

    # Get latest URLs from https://www.vagrantup.com/downloads
    # https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.msi
    dnf -y install https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.rpm

    # To avoid having to enter your password for your key on each wsl session
    # Install keychain and configure your bash profile to use it to manage the
    # ssh-agent so that it persists between sessions.
    dnf -y install keychain

    vagrant plugin install vagrant-hostmanager
    vagrant plugin install vagrant-digitalocean

    # Install Composer
    # Reference commands at: https://getcomposer.org/download/
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === '795f976fe0ebd8b75f26a6dd68f78fd3453ce79f32ecb33e7fd087d39bfeb978342fb73ac986cd4f54edd0dc902601dc') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    mv composer.phar /usr/bin/composer

  WSL Config - DrvFS Mount Options / Hosts File Generation (as root)

  When using vagrant and ansible within WSL there will be a private key file created, and if this happens on a drvfs mounted volume from the Windows file system, the file permissions that SSH requires will not allow a private key to be set to world writable and consider it usable. We can adjust the mounted volume permissions so that Linux file permissions can be set on files, and the default owners and file permissions are set appropriately for the user we are logging into WSL with.

  https://www.schakko.de/2020/01/10/fixing-unprotected-key-file-when-using-ssh-or-ansible-inside-wsl/
  WSL DrvFs https://devblogs.microsoft.com/commandline/chmod-chown-wsl-improvements/
  https://docs.microsoft.com/en-us/windows/wsl/file-permissions

    # Setting mount options to persist
    # https://docs.microsoft.com/en-us/windows/wsl/wsl-config
    FILE_CONTENTS=$(cat <<'HEREDOC_CONTENTS'
    [automount]
    enabled = true
    mountFsTab = false
    root = /mnt/
    options = "metadata,umask=007,fmask=007"

    [network]
    generateHosts = false
    #generateResolvConf = true
    HEREDOC_CONTENTS
    )
    echo "${FILE_CONTENTS}" >> /etc/wsl.conf

    # ----------------------------
    # Exit as root user inside WSL, but remain as your user in WSL
    # ----------------------------
    exit

  Composer global config for Magento Marketplace credentials (as your user)

    # Add Your Magento Marketplace Credentails to Composer Global Config
    # https://devdocs.magento.com/guides/v2.4/install-gde/prereq/connect-auth.html
    MAGENTO_ACCESS_KEY_USER="xxxxxxxxxxxxxxxxxxxxxxxx"
    MAGENTO_ACCESS_KEY_PASS="xxxxxxxxxxxxxxxxxxxxxxxx"
    composer config -g http-basic.repo.magento.com ${MAGENTO_ACCESS_KEY_USER} ${MAGENTO_ACCESS_KEY_PASS}

  SSH Key Management inside WSL (as your user)

    # Copy the private/public keypair from windows into the WSL environment
    mkdir -p ~/.ssh/
    chmod 700 ~/.ssh/
    cp /mnt/c/Users/$(whoami)/.ssh/id_rsa ~/.ssh/
    cp /mnt/c/Users/$(whoami)/.ssh/id_rsa.pub ~/.ssh/
    chmod 600 ~/.ssh/id_rsa
    chmod 644 ~/.ssh/id_rsa.pub

    # Add private key to ssh-agent (manually)
    # NOTE: This would be needed each time you open a wsl session
    # Using keychain will improve agent management of private keys inside WSL
    # eval $(ssh-agent -s)
    # ssh-add ~/.ssh/id_rsa

  Configure user bash profile insdie WSL (as your user)

    # Include into user bash profile
    ADD_TO_PROFILE=$(cat <<'HEREDOC_CONTENTS'
    
    export GITMAN_CACHE_DISABLE=true
    export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
    export PATH=$PATH:/mnt/c/Windows/System32
    export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"
    export PATH="$PATH:/mnt/c/Program Files/Mutagen"
    alias mutagen="mutagen.exe"
    
    ### START-Keychain ###
    # Let  re-use ssh-agent and/or gpg-agent between logins
    /usr/bin/keychain $HOME/.ssh/id_rsa
    source $HOME/.keychain/$HOSTNAME-sh
    ### End-Keychain ###
    
    HEREDOC_CONTENTS
    )
    echo "${ADD_TO_PROFILE}" >> ~/.bash_profile

    # Reload bash profile
    source ~/.bash_profile

### Restart WSL Container (Powershell)

    wsl --list --verbose 
    wsl --terminate CentOS8
    wsl --list --verbose
    wsl
    exit











# Project Setup Example Overview

### Local Project Files (Powershell)

    # Create project directory
    cd ~/projects
    mkdir example_project
    cd example_project

    # Clone project repo (this could optionally be done from within WSL)
    git clone git@bitbucket.org:organization/reponame.git
    cd reponame

    # Enter WSL for DevEnv Initialization
    wsl

### Project DevEnv Initialization (WSL)

  Clone DevEnv Environment Repo for Project

    # You should be in the project repo directory
    # /mnt/c/Users/$(whoami)/projects/example_project/reponame
    # change to the tools/devenv directory
    cd tools/devenv

    # Run gitman to pull down the specific commit/release of the devenv for this project to use
    gitman install

    # ...or... if not using gitman, the checkout can be done manually
    mkdir -p repo_sources
    cd repo_sources
    git clone git@github.com:classyllama/devenv-vagrant.git devenv
    cd devenv
    git checkout master
    bash gitman_init.sh
    cd ../../

    # Launch Vagrant to build Virtual Machine
    vagrant up

  The project's tools/devenv/README.md file is expected to contain more details and specific information on setting up an environment for the specific project.
  
  Mutagen is intended to copy files from your host (Windows/WSL) into the virtual machine's file system, so there will be a copy of all the code files both inside the virtual machine where web requests are executed, and on your host where you edit and make changes to the code files. It is important to be aware of what mutagen is doing, and understanding that it syncs copies of files, and that there is the potential for there to be differences between what you seen in a code editor and what is on the file system where the code is being executed.
  
  Each project is likely to have specific initialization instructions for:
  
  - syncing files with mutagen
  - initializaing any code dependencies
  - setting up environment variables
  - importing a database
  - syncing persistant files related to data in the database
  - configuring the application
  - initializing the application
  - monitoring mutagen
  - terminating mutagen
  - devenv shortcut commands

  To stop the Virtual Machine
  
    vagrant halt

  To destroy the Virtual Machine (and any data it contains)
  
    vagrant destroy -f

### First Project Setup (Powershell as Administrator)

  Trusting Generated Root CA for DevEnv

  When you setup your first project with the DevEnv it will create likely create a persistant Root CA key to use in generating certificates inside any DevEnv. This new key will be used to sign all the SSL certificates on all DevEnv sites. You can avoid any insecure certificate warnings when browsing the DevEnv sites by trusting the Root CA certificate on Windows, or if you end up setting up a proxy for another device to connect a browser to your DevEnv.
  
  The generated Root CA that is unique to your machine/user should be located inside the WSL environment's file system, but you can easily access that from PowerShell as long as the WSL environment is running.
  
    # Check to see if WSL is running
    wsl --list --verbose
  
    # view contents of generated root ca from powershell
    # equivilent in WSL: cat ~/.devenv/rootca/devenv_ca.crt
    get-content \\wsl$\CentOS8\home\$Env:UserName\.devenv\rootca\devenv_ca.crt
    
    # Add generated root ca to trusted certs in Windows (from powershell running as administrator)
    certutil –addstore -enterprise –f "Root" \\wsl$\CentOS8\home\$Env:UserName\.devenv\rootca\devenv_ca.crt





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

[WSL (Windows Subsystem for Linux v1)]: https://docs.microsoft.com/en-us/windows/wsl/
[Chocolatey]: https://chocolatey.org/
[Windows for OpenSSH]: https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview
[Windows Developer Mode]: https://docs.microsoft.com/en-us/windows/uwp/get-started/enable-your-device-for-development
[Carbon Powershell Module]: http://get-carbon.org/
[Microsoft Windows Terminal]: https://docs.microsoft.com/en-us/windows/terminal/
[VSCode]: https://code.visualstudio.com/
[WSL Distribution Image - CentOS8]: https://github.com/yuk7/wsldl
[keychain]: https://www.funtoo.org/Keychain

