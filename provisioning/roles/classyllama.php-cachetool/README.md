# Ansible Role: cachetool

Installs CLI app from https://github.com/gordalina/cachetool to support progromatically resetting the opcache during atomic deployments.

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details.

## Dependencies

None.

## Example Playbook

    - hosts: web-servers
      roles:
        - { role: classyllama.php-cachetool, tags: toolchain }
      tasks:
        - name: Link cachetool config into /var/www/data
          file:
            src: /home/www-data/.cachetool.yml
            dest: /var/www/data/.cachetool.yml
            state: link

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2018 by [David Alger](https://davidalger.com/).