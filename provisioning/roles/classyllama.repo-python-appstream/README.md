# Ansible Role: Python Yum/Dnf Repo (AppStream Configuration)

Configures the Yum/Dnf Stream Module for Python on RHEL/CentOS 8.

## Requirements

None.

## Role Variables

None.

## Dependencies

None.

## Example Playbook

    - hosts: all
      vars:
        python_stream_version: "3.6"
        python_module_name: python36
      roles:
        - { role: classyllama.repo-python-appstream }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2020 by [Matt Johnson](https://github.com/mttjohnson/).
