# Ansible Role: PHP CacheTool

[![Build Status](https://travis-ci.org/davidalger/ansible-role-php-cachetool.svg?branch=master)](https://travis-ci.org/davidalger/ansible-role-php-cachetool)

Installs CacheTool for PHP from https://github.com/gordalina/cachetool. CacheTool allows you to work with `apc`, `opcache`, and the file status cache through the cli. It will connect to a fastcgi server (like `php-fpm`) and operate it's cache.

## Requirements

None.

## Role Variables

    cachetool_download_url: http://gordalina.github.io/cachetool/downloads/cachetool.phar

The URL from which to download and install the CacheTool phar file. For PHP versions older than 7.1, this variable must be changed from the default (shown above) to `https://github.com/gordalina/cachetool/blob/gh-pages/downloads/cachetool-3.2.1.phar?raw=true` (as documented in `defaults/main.yml`)

## Dependencies

None.

## Example Playbook

    - hosts: web-servers
      roles:
        - { role: davidalger.php_cachetool, tags: php-cachetool }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2018 by [David Alger](http://davidalger.com/).
