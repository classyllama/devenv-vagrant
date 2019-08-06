# TODO

    vagrant provision

[ ] composer in /usr/local/bin not in path for www-data

    echo '
    PATH=$PATH:/usr/local/bin/
    export PATH
    ' >> ~/.bash_profile

[ ] Get composer configs on VM (shared?/copied?)

    composer config --list -g
    
    GITHUB_OAUTH=$(composer config -g github-oauth.github.com)
    COMPOSER_USER=$(composer config -g http-basic.repo.magento.com | jq -r '.username')
    COMPOSER_PASS=$(composer config -g http-basic.repo.magento.com | jq -r '.password')
    echo "
    composer config -g github-oauth.github.com ${GITHUB_OAUTH}
    composer config -g http-basic.repo.magento.com ${COMPOSER_USER} ${COMPOSER_PASS}
    "

    composer config -g github-oauth.github.com xxxxxxx
    composer config -g http-basic.repo.magento.com xxxxxxx xxxxxxx

[ ] manual rsync for debugging
[ ] rsync auto files to Mac
[ ] install bypassing varnish and using built-in full page cache

[ ] Get the ability to customize what user (vagrant?) the application is deployed under. 

    vagrant ssh
    sudo -iu www-data
    /home/www-data/initialize-magento.sh

[ ] Ability to SSH directly to internal network IP of VM, avoiding 'vagrant ssh'


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

# Troubleshooting vagrant/virtualbox

    vboxmanage list
    VM_ID="exp-vagrant-m2_dev-m2demo_1564793526855_3776"
    vboxmanage showvminfo ${VM_ID} --machinereadable | grep '"SATA Controller-1-0"' 

    vagrant up --debug
    vboxmanage list hdds
    vboxmanage showmediuminfo disk /opt/alpacaglue/lab-example/gitman_sources/exp-vagrant-m2/persistent_data_disk.vmdk
    vboxmanage closemedium disk /opt/alpacaglue/lab-example/gitman_sources/exp-vagrant-m2/persistent_data_disk.vmdk --delete

    vboxmanage closemedium disk persistent_data_disk.vmdk --delete

# File Sync with Mutagen

    brew install mutagen-io/mutagen/mutagen
