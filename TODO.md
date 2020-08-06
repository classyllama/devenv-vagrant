# TODO  
[ ] Ability to disable/enable xdebug
    [ ] built-in info page (special path) for checking devenv details like if xdebug is enabled or not
[ ] Mutagen auto start/stop
[ ] Windows VirtualBox Support
    [ ] WSL (Ubuntu/CentOS)
    [ ] x64/ARM
    [ ] VirtualBox
        [ ] Persistent Disk
    [ ] Vagrant (within WSL)
        [ ] Hostmanager
    [ ] Ansible (within WSL)
        [ ] Trust RootCA
    [ ] Mutagen (within Windows)
[ ] Windows ARM DigitalOcean Support
    [ ] Detatch/Reattach Data Disk
    [ ] Use Data Disk for different VMs?

[ ] Refine VirtualBox Persistent Disk Portability
    [ ] On vagrant up check that both ID and FilePath match in virtualbox media
    [ ] Define instructions in README for moving project files
    [ ] Consider locating persistent disk volume files in separate location from project files

[ ] Redis 5 on CentOS 7 (currently installs 3.2) (Redis 5 is installed on CentOS 8)
[ ] Varnish 6.x on CentOS 7 (currently installs 4.1) (Varnish 6.x is installed on CentOS 8)
[ ] MariaDB 10.4 (MariaDB 10.3 is installed on CentOS 8)
[ ] ElasticSearch 7.x on CentOS 7 (ElasticSearch 7.x is installed on CentOS 8)
[ ] RabitMQ 3.8.x

[ ] Fix RootCA SSL file syncing
  [ ] Look into better syncing index/serial on root ca usage inside vm

[ ] Cache elasticsearch plugins
[ ] Cache downloaded tool install files (composer, magerun, cachetool)
[ ] Cache Magento Sample Data (even if composer packages are cached, the install sample data still tried to download)
[ ] Evaluate bin/magento deploy:mode:show
    Confirm developer mode when executed through php-fpm
    Confirm developer mode when executed through CLI
      Previously this was enforced in bash profile setting ENV 'export MAGE_MODE=developer'
[ ] EL8 Support
    [ ] Tools
      [ ] ImageMagick
[ ] Look into utilizing Traefik
[?] Look into using DNSMasq
  Utilizing vagrant-hostmanager may reduce the need for DNSMasq
[ ] Look into some kind of mail catcher to prevent actual sending of emails, but still have ability to review emails
    [ ] Mailtrap
    [ ] MailSlurper
    [ ] MailCatcher
    [ ] MailHog
