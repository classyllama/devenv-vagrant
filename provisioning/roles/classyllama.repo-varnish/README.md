# Ansible Role: Varnish Yum/Dnf Repo

Installs the official Varnish yum/dnf repo on RHEL/CentOS 7/8.

On CentOS 8 this will take care of disabling the default stream module so that nginx can be installed from a different repository.

## Requirements

None.

## Role Variables

None.

## Dependencies

None.

## Example Playbook

    - hosts: all
      vars:
        varnish_version: 64
      roles:
        - { role: classyllama.repo-varnish }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2020 by [Matt Johnson](https://github.com/mttjohnson/).
