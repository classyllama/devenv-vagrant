# TODO

    vagrant provision

[ ] Get composer configs on VM (shared?/copied?)

    composer config --list -g

    composer config -g github-oauth.github.com xxxxx
    composer config -g http-basic.repo.magento.com xxxxx xxxxx

[ ] manual rsync for debugging
[ ] rsync auto files to Mac
[ ] install bypassing varnish and using built-in full page cache

[ ] Get the ability to customize what user (vagrant?) the application is deployed under. 

    vagrant ssh
    sudo -iu www-data
    /home/www-data/initialize-magento.sh

[ ] Ability to SSH directly to internal network IP of VM, avoiding 'vagrant ssh'

    echo "
    PATH=$PATH:/usr/local/bin/
    export PATH
    " >> ~/.bash_profile

[ ] portable dev environment for any project

# Performance Characteristics

    # exp-vagrant-m2 (2vCPU 4GB RAM)
    # PHP 7.2 xDebug - Magento 2.3.1 - Sample Data - Redis - No Varnish - Built-In Full Page Cache - Debug Cookie Set


    rm -rf ./var/cache
    rm -rf ./var/page_cache
    rm -rf ./var/tmp
    rm -rf ./var/view_preprocessed
    rm -rf ./pub/static/adminhtml
    rm -rf ./pub/static/frontend
    rm -rf ./pub/media/catalog/product/cache
    redis-cli -p 6379 flushall
    redis-cli -p 6381 flushall

    Finish Time (TTFB Document Time) in seconds


    # Only enabled config cache
    bin/magento cache:disable
    bin/magento cache:enable config

    Home Page (/) [224 requests]
      25 (6), 10 (0.7), 3 (0.7)

    Admin Configuration (/backend/admin/system_config/index) [ requests]
      21 (8), 3 (0.7)


    # Enable All Caches
    bin/magento cache:enable

    Home [221]: 22 (6), 1.73 (0.1)
    Admin Configuration 1.8 (0.3)


    # Disable All Caches
    Home [221]: 550 (6) 11 (6)

    # classyllama/devenv (2vCPU 4GB RAM)
    # PHP 7.2 xDebug - Magento 2.3.1 - Sample Data - Redis - No Varnish - Built-In Full Page Cache - Debug Cookie Set



    # classyllama/devenv (2vCPU 4GB RAM) NFS code/mysql
    # PHP 7.2 xDebug - Magento 2.3.1 - Sample Data - Redis - No Varnish - Built-In Full Page Cache - Debug Cookie Set

    # Only enabled config cache
    Home Page (/) [214 requests]
      78 (17), 6 (4)

    # Enable All Caches
    Home [214]: 66 (13), 1.7 (0.4)

    # Disable All Caches
    Home [213]: 492 (14) 22 (13)


# Install ansible dependencies with ansible-galaxy

    ansible-galaxy -r ansible_roles.yml install

# Initialize /data disk

    parted /dev/sdb mklabel gpt
    parted -a opt /dev/sdb mkpart primary xfs 0% 100%
    mkfs.xfs -L data /dev/sdb1
    mkdir -p /data
    echo "/dev/sdb1           /data                       xfs     defaults        0 0" >> /etc/fstab
    mount -a

# Initialize Guest Additions
    yum -y --enablerepo=extras install epel-release
    yum -y update kernel*
    yum -y install dkms
    yum -y groupinstall "Development Tools"
    yum -y install kernel-devel
    
    # https://download.virtualbox.org/virtualbox/
    # yum -y install https://download.virtualbox.org/virtualbox/5.2.12/VirtualBox-5.2-5.2.12_122591_el7-1.x86_64.rpm

    vboxmanage list vms
    vboxmanage storageattach vagrant-elastic_dev-elastic_1527716197882_44241 --storagectl IDE --port 0 --device 1 --type dvddrive --medium /Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso
    vboxmanage showvminfo vagrant-elastic_dev-elastic_1527716197882_44241
    
    mkdir /mnt/dvd
    mount -t iso9660 -o ro /dev/cdrom /mnt/dvd
    cd /mnt/dvd
    ./VBoxLinuxAdditions.run
    umount /dev/cdrom
    
    vboxmanage storageattach vagrant-elastic_dev-elastic_1527716197882_44241 --storagectl IDE --port 0 --device 1 --type dvddrive --medium emptydrive --forceunmount

    wget https://download.virtualbox.org/virtualbox/5.2.12/VBoxGuestAdditions_5.2.12.iso
    sudo mkdir /media/VBoxGuestAdditions
    sudo mount -o loop,ro VBoxGuestAdditions_5.2.12.iso /media/VBoxGuestAdditions
    sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
    rm VBoxGuestAdditions_5.2.12.iso
    sudo umount /media/VBoxGuestAdditions
    sudo rmdir /media/VBoxGuestAdditions

