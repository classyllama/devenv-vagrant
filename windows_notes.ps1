
# Requirements
# Virtualbox
# Vagrant
# Ansible (inside WSL)
# Mutagen
# python git gitman
# Windows for OpenSSH



# System Info and WSL (Windows Subsystem for Linux) List
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer

# Check if using WSL v2
# Windows build 18917 or higher only
# This may only work with WSL v1 (WSL v2 may conflict with VirtualBox)
wsl --list --verbose 
#Start-Process -FilePath "wsl" -ArgumentList "--list" -Wait -NoNewWindow | Write-Output

# Disable Hyper-V
#Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All

# Start Terminal Powershell (as administrator)

# Install NuGet
Find-PackageProvider -Name 'Nuget' -ForceBootstrap -IncludeDependencies

# Install chocolatey if it isn't installed yet
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n allowGlobalConfirmation

# Make sure Chocolatey is up to date
choco upgrade chocolatey




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




# Install VirtualBox and Vagrant
choco install virtualbox vagrant -y

#Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
choco install wsl -y

# Install SourceTree for git repo
choco install microsoft-windows-terminal -y

# Install Libraries/Language/CLI Tools, Development Apps, and editors.
choco install git jq -y

# Install VSCode as IDE and editor
choco install vscode --params "/NoDesktopIcon" -y

# ----------------------------
# Manual GUI Step
# ----------------------------
# Disable python and python3 in "Manage App Execution Aliases"
# ----------------------------

# Install Gitman 
choco install python -y

# Refresh env or restart terminal
refreshenv

# Confirm python version (3.x)
python --version

pip install gitman

# Use Built-In Official "Windows for OpenSSH"
# https://github.com/PowerShell/openssh-portable
# https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
Add-WindowsCapability -Name "OpenSSH.Client~~~~0.0.1.0" -Online
# Remove-WindowsCapability -Name "OpenSSH.Client~~~~0.0.1.0" -Online
# Configure and Start the ssh-agent service
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent
Get-Service ssh-agent

# Update permissions on Windows hosts file to allow for user changes without Admin UAC permissions
$myPath = "$env:windir\System32\drivers\etc\hosts"
$curUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$myAcl = Get-Acl "$myPath"
$myAclEntry = "$curUser","FullControl","Allow"
$myAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($myAclEntry)
$myAcl.SetAccessRule($myAccessRule)
$myAcl | Set-Acl "$MyPath"
Get-Acl "$myPath" | fl


# ----------------------------
# Manual GUI Step
# ----------------------------
# Reboot Windows
# ----------------------------

# Download CentOS8 WSL Distro Launcher and rootfs
#https://github.com/Microsoft/WSL-DistroLauncher
#https://github.com/yuk7/wsldl
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
#Start-Process -FilePath "$path\CentOS8.exe" -Verb runAs -ArgumentList "run `"cat /etc/os-release && sleep 5`"" -Wait
#wsl cat /etc/os-release

# Initialize Distro User
wsl adduser $Env:UserName
wsl usermod -a -G wheel $Env:UserName
wsl echo "echo '$Env:UserName  ALL=(ALL)       NOPASSWD: ALL' > /etc/sudoers.d/wsl_user"
# Copy the results, launch wsl and paste the command in to allow passwordless sudo access
wsl
# or manually edit sudoers file to allow wheel group sudo access without password

# Change the default login user wsl will use
Start-Process -FilePath "$path\CentOS8.exe" -ArgumentList "config --default-user $Env:UserName"

# Launch CentOS8 WSL Container
wsl

# Run inside WSL Container
sudo -i
dnf -y install epel-release
dnf -y update
dnf -y install ansible
dnf -y install python-pip wget
dnf -y install dos2unix
dnf -y install git
dnf -y install php php-json
dnf -y install jq
pip3 install --upgrade pip
pip3 install gitman
pip3 install python-vagrant

# Get latest URLs from https://www.vagrantup.com/downloads
# https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.msi
yum -y install https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.rpm

vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-digitalocean

# Install Composer
# Reference commands at: https://getcomposer.org/download/
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '795f976fe0ebd8b75f26a6dd68f78fd3453ce79f32ecb33e7fd087d39bfeb978342fb73ac986cd4f54edd0dc902601dc') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/bin/composer

# Add Magento Marketplace Credentails to Composer Global Config
# https://devdocs.magento.com/guides/v2.4/install-gde/prereq/connect-auth.html
MAGENTO_ACCESS_KEY_USER="xxxxxxxxxxxxxxxxxxxxxxxx"
MAGENTO_ACCESS_KEY_PASS="xxxxxxxxxxxxxxxxxxxxxxxx"
composer config -g http-basic.repo.magento.com ${MAGENTO_ACCESS_KEY_USER} ${MAGENTO_ACCESS_KEY_PASS}

# ----------------------------
# Exit as root user inside WSL, but remain as your user in WSL
# ----------------------------
exit

# Include into user bash profile
ADD_TO_PROFILE=$(cat <<'HEREDOC_CONTENTS'
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export PATH=$PATH:/mnt/c/Windows/System32
export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"
HEREDOC_CONTENTS
)
echo "${ADD_TO_PROFILE}" >> ~/.bash_profile

# Reload bash profile
source ~/.bash_profile 











# ----------------------------
# Configure
# ----------------------------

# Setup ssh keys
# Create new ssh keypair (ssh-keygen) or import existing keys in ~/.ssh/

# If generating a new keypair please use a password on your private key
# Consider using a password manager such as 1Password
# ssh-keygen

# Add private key to ssh-agent
# Use tab completion to resolve actual file path
ssh-add ~/.ssh/id_rsa

# Test SSH access to confirm if you have a machine you can use to test access
# ssh user@hostname

# Make sure git is configured to use the Windows for OpenSSH binaries
git config --global core.sshCommand (get-command ssh).Source.Replace('\','/')





# https://www.schakko.de/2020/01/10/fixing-unprotected-key-file-when-using-ssh-or-ansible-inside-wsl/
# WSL DrvFs https://devblogs.microsoft.com/commandline/chmod-chown-wsl-improvements/
# https://docs.microsoft.com/en-us/windows/wsl/file-permissions
#
# To temporarily test running mount options you can unmount and remount drvfs
#mount -l
# C:\ on /mnt/c type drvfs (rw,noatime,uid=1000,gid=1000,case=off)
#cd /
#sudo umount /mnt/c 
#sudo mount -t drvfs C: /mnt/c -o metadata,noatime,uid=1000,gid=1000
#mount -l
# C: on /mnt/c type drvfs (rw,noatime,uid=1000,gid=1000,metadata,case=off)

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

# Copy the private/public keypair from windows into the WSL environment
mkdir -p ~/.ssh/
chmod 700 ~/.ssh/
cp /mnt/c/Users/$(whoami)/.ssh/id_rsa ~/.ssh/
cp /mnt/c/Users/$(whoami)/.ssh/id_rsa.pub ~/.ssh/
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

# Add private key to ssh-agent (manually)
# NOTE: This will be needed each time you open a wsl session
# eval $(ssh-agent -s)
# ssh-add ~/.ssh/id_rsa

# To avoid having to enter your password for your key on each wsl session
# Install keychain and configure your bash profile to use it to manage the
# ssh-agent so that it persists between sessions.
sudo dnf install keychain -y
# Include into user bash profile
ADD_TO_PROFILE=$(cat <<'HEREDOC_CONTENTS'
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


# Exit WSL, Terminate container, Relaunch WSL
exit
wsl --list --verbose 
wsl --terminate CentOS8
wsl --list --verbose 
wsl




# ----------------------------
# test
# ----------------------------
cd ~/projects
git clone git@github.com:classyllama/iac-test-lab.git
cd ~/projects/iac-test-lab/dev-laravel.lan
gitman install

# Run from within WSL
wsl
cd repo_sources/devenv/
# Ensure line endings aren't /r
dos2unix ./gitman_init.sh
./gitman_init.sh

# If you need to remove the symlinks
[[ -L provisioning/devenv_vars.config.yml ]] && rm provisioning/devenv_vars.config.yml
[[ -L persistent/Vagrantfile ]] && rm persistent/Vagrantfile
[[ -L persistent/devenv ]] && rm persistent/devenv
[[ -L persistent/source ]] && rm persistent/source
[[ -L persistent ]] && rm persistent

# From within wsl
vagrant up
vagrant ssh -c "~/laravel-demo/install-laravel.sh config_site.json" -- -q
vagrant ssh -c "~/magento-demo/install-magento.sh config_site.json" -- -q






# Updating hosts files

# Find powershell exe path
(Get-Process powershell | select -First 1).Path
(Get-Command powershell.exe).Definition

# display hosts file details from various environments
# From Cmd Prompt
powershell -nologo "& Get-Content C:\Windows\System32\drivers\etc\hosts"
powershell "Get-Content C:\Windows\System32\drivers\etc\hosts"

# From within powershell
get-content C:\Windows\System32\drivers\etc\hosts
get-content \\wsl$\CentOS8\etc\hosts
Test-Path "C:\Windows\System32\drivers\etc\hosts"
"10.10.10.100 Myhost" | Out-File C:\Windows\System32\drivers\etc\hosts -encoding ASCII -append 

$hostsFilePath = "$($Env:WinDir)\system32\Drivers\etc\hosts"
$hostsFile = Get-Content $hostsFilePath
$DesiredIP = "10.10.10.100"
$Hostname = "Myhost"

$escapedHostname = [Regex]::Escape($Hostname)
$patternToMatch = ".*$DesiredIP\s+$escapedHostname.*"
($hostsFile) -match $patternToMatch

Add-Content -Encoding UTF8  $hostsFilePath ("$DesiredIP".PadRight(20, " ") + "$Hostname")

If ((Get-Content "$($env:windir)\system32\Drivers\etc\hosts" ) -notcontains "127.0.0.1 hostname1")   
 { Add-Content -Encoding UTF8  "$($env:windir)\system32\Drivers\etc\hosts" "127.0.0.1 hostname1" -Force }

(Get-Content C:\Windows\System32\drivers\etc\hosts -Raw) -replace '10.3.4.53','#10.3.4.53' | Set-Content -Path C:\Windows\System32\drivers\etc\hosts

Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated -action "{1}"' -f ($myinvocation.MyCommand.Definition,$action))

function Test-Admin {
   $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
   $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
 }
 
 if ((Test-Admin) -eq $false)  {
   Write-Host " done" 
}

$file = "$env:windir\System32\drivers\etc\hosts"
"192.168.1.1 bob" | Add-Content -PassThru $file
"192.168.1.2 john" | Add-Content -PassThru $file


$passwd = Read-Host "Enter password" -AsSecureString
$encpwd = ConvertFrom-SecureString $passwd
$encpwd > $path\password.bin

# Afterwards always use this to start the script
$curUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$encpwd = Get-Content $path\password.bin
$passwd = ConvertTo-SecureString $encpwd
$cred = new-object System.Management.Automation.PSCredential $curUser, $passwd
Add-Content -Encoding UTF8  $hostsFilePath ("$DesiredIP".PadRight(20, " ") + "$Hostname")

Start-Process -NoNewWindow -Credential $cred -FilePath 'powershell.exe' -ArgumentList 'noprofile','-Command',"Add-Content -Encoding UTF8 C:\Windows\System32\drivers\etc\hosts '192.168.1.99 appleseed'"
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated -action "{1}"' -f ($myinvocation.MyCommand.Definition,$action))
Start-Process PowerShell -NoNewWindow -Cred $cred -ArgumentList "Add-Content -Encoding UTF8 C:\Windows\System32\drivers\etc\hosts '192.168.1.99 appleseed'"
powershell -Cred $cred "Add-Content -Encoding UTF8 C:\Windows\System32\drivers\etc\hosts '192.168.1.99 appleseed'"
Invoke-Expression
Start-Process -Wait -NoNewWindow -Credential $cred -FilePath 'powershell.exe' -ArgumentList 'noprofile','-Command',"Get-Content C:\Windows\System32\drivers\etc\hosts"

.\script.ps1 -action 'activate'


# To avoid the UAC prompt, open %WINDIR%\System32\drivers\etc\ in Explorer, right-click the hosts file, go to 
# Properties > Security > Edit and give your user Modify permission.


# Update permissions on Windows hosts file to allow for user changes without Admin UAC permissions
$myPath = "$env:windir\System32\drivers\etc\hosts"
$curUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$myAcl = Get-Acl "$myPath"
$myAclEntry = "$curUser","FullControl","Allow"
$myAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($myAclEntry)
$myAcl.SetAccessRule($myAccessRule)
$myAcl | Set-Acl "$MyPath"
Get-Acl "$myPath" | fl



wsl
# From within wsl
cat /etc/hosts
cat /mnt/c/Windows/System32/drivers/etc/hosts
/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -nologo "& Get-Content C:\Windows\System32\drivers\etc\hosts"
echo "5.6.7.8 whatever" >> /mnt/c/Windows/System32/drivers/etc/hosts

# Update Windows hosts file with vagrant-hostmanager entries
VAGRANTHOSTS=$(echo -e "\n""$(awk '/^## vagrant-hostmanager-start/,/^## vagrant-hostmanager-end$/' /etc/hosts)""\n")
WINHOSTS_NOVAGRANTHOSTS=$(awk '/^## vagrant-hostmanager-start/,/^## vagrant-hostmanager-end$/{next}{print}' /mnt/c/Windows/System32/drivers/etc/hosts)
echo "${WINHOSTS_NOVAGRANTHOSTS}${VAGRANTHOSTS}" > /mnt/c/Windows/System32/drivers/etc/hosts


vagrant ssh
# From within vagrant machine
cat /etc/hosts




# Trusting Generated Root CA for DevEnv
# view contents of generated root ca from powershell
get-content \\wsl$\CentOS8\home\$Env:UserName\.devenv\rootca\devenv_ca.crt
# view contents of generated root ca from wsl
cat ~/.devenv/rootca/devenv_ca.crt
# Add generated root ca to trusted certs in Windows (from powershell running as administrator)
certutil –addstore -enterprise –f "Root" \\wsl$\CentOS8\home\$Env:UserName\.devenv\rootca\devenv_ca.crt




# TODO:
# [ ] symlinks from wsl usable in Windows
# [ ] simplify project setup
# [ ] test persistent disk use
# [ ] test actual project setup








# Install GUI SourceTree git repo client tool
choco install SourceTree -y

# Extra Packages
choco install powershell-core putty jre8 openvpn terraform nmap rsync SublimeText3 notepadplusplus postman jmeter sqlyog -y
choco install firefox slack 1password curl ruby
choco install filezilla mysql.workbench beyondcompare -y

# Add to path this session
Set-Item -Path Env:Path -Value ($Env:Path + ";C:\Python38")
# Add to path permanently
Add-Path -String 'C:\Python38','bla' -Verbose

# Get session's path environment variable
Get-Content -Path Env:Path
# Get the global path environment variable
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH 





# Install WSL Ubuntu 1804
# This installs Ubuntu for use only as root user
# Install from Microsoft store for using as unprivileged user
#choco install wsl-ubuntu-1804 -y
#choco list --localonly
#choco uninstall wsl-ubuntu-1804 -y

#$download = 'https://aka.ms/wsl-ubuntu-1804'
#$destination = "$Env:USERPROFILE\Downloads\Ubuntu-1804.appx"
#Invoke-WebRequest -Uri $download -OutFile $destination -UseBasicParsing
#Add-AppxPackage -Path $destination
#Rename-Item ./Ubuntu.appx ./Ubuntu.zip
#Expand-Archive ./Ubuntu.zip ./Ubuntu

#Get-AppxPackage *ubuntu*
#Get-AppxPackage CanonicalGroupLimited.Ubuntu18.04onWindows | Remove-AppxPackage

# Unregister WSL Distribution
wsl --list
wsl --unregister CentOS8



# Experimenting with Windows Package Managers (OneGet)
Find-PackageProvider

get-packageprovider
Get-Command -module PackageManagement | sort noun, verb
Get-Command Install-Package
find-package -provider psmodule psreadline -allversions
find-module xjea
# install-package psreadlin -MinimumVersion 1.0.0.13



# Download and install Mutagen
# https://mutagen.io/documentation/introduction/installation
# https://github.com/mutagen-io/mutagen/releases/latest
$download = 'https://github.com/mutagen-io/mutagen/releases/download/v0.11.2/mutagen_windows_amd64_v0.11.2.zip'
$destination = "$Env:USERPROFILE\Downloads\mutagen_windows_amd64_v0.11.2.zip"
$checksum = "D8AC387034F1DC5B2906E2158DAEE55FA2A8B96268D6C955F40D364F65F20CAB"
Invoke-WebRequest -Uri $download -OutFile $destination
if ((Get-FileHash $destination -Algorithm SHA256 | Select-Object -ExpandProperty Hash) -ne $checksum) { throw "Error: Downloaded file does not match known hash." }

# Copy exe binary to program directory
# add exe binary path to profile

#msiexec.exe /package $destination /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1



# Command line and URL for vscode Visual Studio Code
# https://code.visualstudio.com/docs/editor/command-line
# 
# code index.html style.css documentation\readme.md
# 
# vscode://file/{full path to file}:line:column
# vscode://file/c:/myProject/package.json:5:10


# https://github.com/alpacaglue/exp-vagrant-m2
# https://docs.ansible.com/ansible/latest/user_guide/windows_faq.html
# https://www.vagrantup.com/docs/other/wsl.html
# https://bitbucket.org/classyllama/rebaraccelerator-stage/src/1eccd01e45909d805d4b125060cb475e7c8b85d3/?at=feature%2Fdevenv

# https://www.powershellgallery.com/packages?q=mutagen
# https://chocolatey.org/packages?sortOrder=package-download-count&page=42&prerelease=False&moderatorQueue=False&moderationStatus=all-statuses

# https://devblogs.microsoft.com/commandline/sharing-ssh-keys-between-windows-and-wsl-2/
# https://devblogs.microsoft.com/commandline/integrate-linux-commands-into-windows-with-powershell-and-the-windows-subsystem-for-linux/

# https://alchemist.digital/articles/vagrant-ansible-and-virtualbox-on-wsl-windows-subsystem-for-linux/
# https://www.techdrabble.com/ansible/36-install-ansible-molecule-vagrant-on-windows-wsl

