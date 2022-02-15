# Ansible Role: MariaDB 10.4+ Yum/Dnf Repo

Installs the official MariaDB (stable) yum/dnf repo on RHEL/CentOS 7/8 using [MariaDB Package Repository Setup Script](https://mariadb.com/kb/en/mariadb-package-repository-setup-and-usage/).

On CentOS 8 this will take care of disabling the default stream module so that MariaDB can be installed from a different repository.

## Requirements

None.

## Role Variables

    mariadb_version: "10.4" # Available versions are "10.3", "10.4"(default), "10.5" and "10.6".

## Dependencies

None.

## Example Playbook

    - hosts: all
      vars:
      roles:
        - { role: classyllama.repo-mariadb }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2021 by ClassyLlama.
