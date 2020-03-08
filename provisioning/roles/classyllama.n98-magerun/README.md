# Ansible Role: n98-magerun

[![Build Status](https://travis-ci.org/davidalger/ansible-role-n98-magerun.svg?branch=master)](https://travis-ci.org/davidalger/ansible-role-n98-magerun)

Installs [n98-magerun](https://magerun.net) CLI tool for use with Magento 1 or Magento 2.

## Requirements

None.

## Role Variables

    n98_magerun_version: 2

Version of n98-magerun to install, should be either 1 or 2.

## Dependencies

None.

## Example Playbook

    - hosts: web-servers
      vars:
        n98_magerun_version: 2
    
      roles:
        - { role: davidalger.n98_magerun, tags: toolchain }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2019 by [David Alger](http://davidalger.com/).
