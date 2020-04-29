# TODO
[ ] EL8 Support
    [ ] Varnish
    [ ] PHP
    [ ] Redis
    [ ] Nginx
    [ ] ElasticSearch
    [ ] Tools
      [ ] ImageMagick
      [ ] magerun
      [ ] composer
      [ ] cachetool
      [ ] xdebug
    [ ] db creation from ansible python pip MySQL-python

[ ] Evaluate bin/magento deploy:mode:show
    Confirm developer mode when executed through php-fpm
    Confirm developer mode when executed through CLI
      Previously this was enforced in bash profile setting ENV 'export MAGE_MODE=developer'
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
[ ] Mutagen auto start/stop
[ ] Refine VirtualBox Persistent Disk Portability
    [ ] On vagrant up check that both ID and FilePath match in virtualbox media
    [ ] Define instructions in README for moving project files
    [ ] Consider locating persistent disk volume files in separate location from project files
[ ] Ability to disable/enable xdebug
    [ ] built-in info page (special path) for checking devenv details like if xdebug is enabled or not

[ ] Redis 5 (currently installs 3.2)
[ ] Varnish 6.x (currently installs 4.1)
[ ] MariaDB 10.2
[ ] ElasticSearch 6.x
[ ] RabitMQ 3.8.x

[ ] Vagrant bento/centos-8

[ ] Look into better syncing index/serial on root ca usage inside vm
[ ] Store composer cache on persistent storage to improve setup time between VM rebuilds
[ ] Look into utilizing Traefik
[?] Look into using DNSMasq
  Utilizing vagrant-hostmanager may reduce the need for DNSMasq
[ ] Look into some kind of mail catcher to prevent actual sending of emails, but still have ability to review emails
    [ ] Mailtrap
    [ ] MailSlurper
    [ ] MailCatcher
    [ ] MailHog
