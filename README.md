# TODO

    vagrant provision


    vagrant ssh
    sudo -iu www-data
    /home/www-data/initialize-magento.sh
  
    echo "
    PATH=$PATH:/usr/local/bin/
    export PATH
    " >> ~/.bash_profile
    
    composer global config
    

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

