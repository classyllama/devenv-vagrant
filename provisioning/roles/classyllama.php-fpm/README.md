# Ansible Role: PHP-FPM

Installs php-fpm 7.X from [IUS Community Project](http://ius.io) RPMs on RHEL / CentOS 7. For PHP 8.X Remi repository must be enabled since 8.X currently available only via Remi repositories.

Currently this role installs `php-fpm` pre-configured with defaults built around the Magento 2 application. Some of these defaults may be high than required for other applications of the php-fpm service. One of these areas would by the php-opcache defaults, which must be very high for high Magento 2 application performance and may otherwise be reduced. See `defaults/main.yml` and `vars/opcache.yml` for details.

## Requirements

None.

## Role Variables

    php_version: 74

Any php version supported by IUS RPMs may be specified: 71, 72, 73, 74. To install PHP versions 8.0 or 8.1 `use_geerlingguy_repo_remi` must be set to `true`.

See `defaults/main.yml` for complete list of variables available to customize the php-fpm installation.

## Dependencies

* `classyllama.repo_ius`

## Example Playbook

    - hosts: web-servers
      roles:
        - { role: classyllama.php_fpm, tags: php-fpm }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2017 by [David Alger](http://davidalger.com/).
