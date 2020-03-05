# Ansible Role: www-user

Create system user accounts, and sets up web directories under /var/www/ on RHEL / CentOS 7.

Currently this role installs nginx pre-configured with defaults tuned for Magento. Some of these defaults may be different if this role is used to deploy in a non-Magento environment. See `defaults/main.yml` for details.

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details.

## Dependencies

None.

## Example Playbook

    - hosts: web-servers
      vars:
        www_user_ssh_keys:
          - files/ssh-keys/my_username    # Location of SSH key to authorize on user
      roles:
        - { role: classyllama.www-user, www_user_name: www-prod }

    - hosts: web-servers
      roles:
        - { role: classyllama.www-user } # Uses the default username www-data


## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2017 by [David Alger](https://davidalger.com/) with contributions from [Matt Johnson](https://github.com/mttjohnson/).
