# Ansible Role: Composer

Installs Composer on RHEL / CentOS for providing PHP package management.

The role installs Composer at the system level owned by root like most other system utilities.

By default the role updates Composer to the latest version rigth after installing the known version, but this feature can be disabled via the "composer_selfupdate" variable if needed. Updated versions to initially install can be overridden in the "_composer_download" and "composer_version" variables if needed.

The installer downloads a specific known version of the phar file from getcomposer.org and verifies the integrity of the download via a sha256 hash listed on the official website's download page https://getcomposer.org/download/ This method works great when you need to install a specific version where the application using composer does not support the latest version or some other dependency such as the installed PHP version can only support up to a specific version of composer is needed. An alternative scripted approach to installing the latest version of composer is listed on their site https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details.

## Dependencies

None.

## Example Playbook

    - hosts: all
      roles:
        - { role: classyllama.composer, tags: toolchain }

## Notes

To check the currently installed version

    composer --version

To have composer download and update itself to the latest version run as root

    composer selfupdate

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2017 by [David Alger](https://davidalger.com/) with contributions from [Matt Johnson](https://github.com/mttjohnson/).
