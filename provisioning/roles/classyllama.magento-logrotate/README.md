# Ansible Role: Magento Logrotate

Log Rotation for Magento logs files

Using a template file, this role sets up a logrotate file in /etc/logrotate.d/magento to be used by the logrotate system tool. The `magento_logrotate_sets` variable accepts an array if multiple directories exist that it needs to manage for Magento log files.

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details.

## Dependencies

None.

## Example Playbook

    - hosts: web-server
      vars:
        magento_logrotate_sets:
          - path: /var/www/prod/current/var/log/*.log
            owner: www-prod
            group: www-prod
            # mode: "640"       # (optional) default of 640 in logrotate template
      roles:
        - { role: classyllama.magento-logrotate }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2017 by [David Alger](https://davidalger.com/) with contributions from [Matt Johnson](https://github.com/mttjohnson/).