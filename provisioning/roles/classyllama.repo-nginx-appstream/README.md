# Ansible Role: Nginx Yum/Dnf Repo (AppStream Configuration)

Configures the Yum/Dnf Stream Module for Nginx on RHEL/CentOS 8.

## Requirements

None.

## Role Variables

None.

## Dependencies

* geerlingguy.repo-epel

## Example Playbook

    - hosts: all
      vars:
        nginx_stream_version: "1.16"
      roles:
        - { role: classyllama.repo-nginx-appstream }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2020 by [Matt Johnson](https://github.com/mttjohnson/).
