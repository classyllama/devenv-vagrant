# Ansible Role: Varnish

Installs varnish service on RHEL/CentOS 7/8.

Supported Varnish Versions:
- 4.1
- 6.0
- 6.4

Currently this role installs varnish pre-configured with defaults tuned for Magento. Some of these defaults may be different if this role is used to deploy in a non-Magento environment. See `defaults/main.yml` for details.

## Requirements

None.

## Role Variables

None.

## Dependencies

* geerlingguy.repo-epel
* classyllama.repo-varnish

## Example Playbook

    - hosts: all
      vars:
      roles:
        - { role: classyllama.varnish }

## Optional Requirements

* Ansible role classyllama.repo-varnish to utilize official Varnish Yum/Dnf repo for installing pacakges from.

* To disable the use of classyllama.repo-varnish set the following variable which will allow you to install from EL8 AppStream

        use_classyllama_repo_varnish: false

## Example Usage

* Set variable to choose version to install and configure

        varnish_version: 41     # 41 or 60lts

* Single `prod` varnish instance setup:

        - varnish

* Double varnish instance setup:

        - { role: varnish, varnish_instance: { name: prod, port: 6081, admin_port: 6082 }}
        - { role: varnish, varnish_instance: { name: stage, port: 6091, admin_port: 6092 }}

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2017 by [David Alger](https://davidalger.com/) with contributions from [Matt Johnson](https://github.com/mttjohnson/).
