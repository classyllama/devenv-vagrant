# Ansible Role: PHP Yum/Dnf Repo (AppStream Configuration)

Configures the Yum/Dnf Stream Module for PHP on RHEL/CentOS 8.

## Requirements

None.

## Role Variables

None.

## Dependencies

None.

## Example Playbook

    - hosts: all
      vars:
        php_stream_version: "7.3"
      roles:
        - { role: classyllama.repo-php-appstream }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2020 by [Matt Johnson](https://github.com/mttjohnson/).
