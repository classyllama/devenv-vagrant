# Ansible Role: Composer

[![Build Status](https://travis-ci.org/davidalger/ansible-role-composer.svg?branch=master)](https://travis-ci.org/davidalger/ansible-role-composer)

Installs [Composer](https://getcomposer.org), dependency manager for PHP.

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details.

## Dependencies

None.

## Example Playbook

    - hosts: web-servers
      roles:
        - { role: davidalger.composer, tags: composer }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2017 by [David Alger](http://davidalger.com/).
