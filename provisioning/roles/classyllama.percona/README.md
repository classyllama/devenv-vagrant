# Ansible Role: Percona

Installs percona service from on RHEL / CentOS 7.

Percona is a MySQL compatible relation database engine. Currently this role installs percona pre-configured with defaults tuned for Magento. Some of these defaults may be different if this role is used to deploy in a non-Magento environment. See `defaults/main.yml` for details.

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details.

## Dependencies

* `classyllama.repo-percona`

## Example Playbook

    - hosts: web-servers
      roles:
        - { role: classyllama.percona }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2017 by [David Alger](https://davidalger.com/) with contributions from [Matt Johnson](https://github.com/mttjohnson/).
