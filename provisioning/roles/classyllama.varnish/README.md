# Ansible Varnish

* For multiple varnish instance setups
* Installs varnish 4.1 or 6.0 LTS from public RPM or from EL8 AppStream
* Supports RHEL 6 / 7 / 8

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
