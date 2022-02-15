# Supported systems

This environment supports CentOS 7, CentOS 8 and RockyLinux 8 operating systems for Vagrant using [Bento images](https://app.vagrantup.com/bento).

To use RockyLinux 8 it will be enough to specify corresponding image in `Vagrantfile.config.rb`:

    $vagrant_base_box = 'bento/rockylinux-8'

and switch to appstream repository for Nginx package:

    use_classyllama_repo_nginx: false
    use_classyllama_repo_nginx_appstream: true

since official Nginx repository currently doesn't support RockyLinux. Apart from this modification everything should work fine with similar configuration for CentOS 8.
Please see reference configuration for RockyLinux 8 in [iac-test-lab](https://github.com/classyllama/iac-test-lab/tree/master/dev-rocky8-latest.lan) repository.

Please note, CentOS Linux 8 reached End Of Life (EOL) on December 31st, 2021 and all official repositories are not available after this date.
It is still possible to use it with https://vault.centos.org repository which is a snapshot of the older trees that have been removed from the main CentOS servers (the repository list will be replaced automatically during provisioning, please see [CentOS8EOL](Centos8EOL.md) for more details.

CentOS 7 will be EOLd June 30, 2024.
