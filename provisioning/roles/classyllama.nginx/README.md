# Ansible Role: Nginx 

Installs nginx service from EPEL RPMs on RHEL / CentOS 7.

Currently this role installs nginx pre-configured with defaults tuned for Magento. Some of these defaults may be different if this role is used to deploy in a non-Magento environment. See `defaults/main.yml` for details.

## Requirements

None.

## Dependencies

* `geerlingguy.repo-epel`

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2017 by [David Alger](https://github.com/davidalger/) with contributions from [Matt Johnson](https://github.com/mttjohnson/).