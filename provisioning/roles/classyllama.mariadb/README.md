# Ansible Role: MariaDB

Installs MariaDB service on RHEL/CentOS 8.

MariaDB is a MySQL compatible relation database engine forked from the MySQL code base. Currently this role installs MariaDB pre-configured with defaults tuned for Magento. Some of these defaults may be different if this role is used to deploy in a non-Magento environment. See `defaults/main.yml` for details.

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details.

## Dependencies

This expects the CentOS 8 AppStream to have the MariaDB 10.3 stream enabled by default.

## Example Playbook

    - hosts: all
      vars:
      roles:
        - { role: classyllama.mariadb }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2020 by [Matt Johnson](https://github.com/mttjohnson/).
