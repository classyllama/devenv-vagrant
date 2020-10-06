# Ansible Role: Web Info

Installs Nginx configs and PHP files for utility environment information. An nginx server block is created that listens on port 8443 and will reference the {{ app_domain }} ansible variable for the server_name and SSL certificate file name.

https://example.lan:8443/

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details.

## Dependencies

This expects the classyllama.nginx and classyllama.php to have already run in the environment.

## Example Playbook

    - hosts: all
      vars:
      roles:
        - { role: classyllama.web-info }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2020 by [Matt Johnson](https://github.com/mttjohnson/).
