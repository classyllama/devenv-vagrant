# Ansible Role: PHP Yum/Dnf Repo (Remi Modular Configuration)

Configures the Yum/Dnf Stream Module for PHP on RHEL/CentOS 8.

## Requirements

None.

## Role Variables

None.

## Dependencies

* geerlingguy.repo-epel

## Example Playbook

    - hosts: all
      vars:
        php_stream_version: "remi-7.4"
      roles:
        - { role: classyllama.repo-php-remi-modular }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2020 by [Matt Johnson](https://github.com/mttjohnson/).
