# Ansible Role: Python

Installs Python on RHEL / CentOS.

There are some default Python libraries installed that Ansible utilizes, and there is support for installing pip packages

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details.

## Dependencies

* `classyllama.repo-python-appstream`

## Example Playbook

    - hosts: all
      vars:
        use_classyllama_repo_python_appstream: true
        python3_stream_version: "3.6"
        python_module_name: python36
        python_package_name: python3
      roles:
        - { role: classyllama.python }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2020 by [Matt Johnson](https://github.com/mttjohnson/).
