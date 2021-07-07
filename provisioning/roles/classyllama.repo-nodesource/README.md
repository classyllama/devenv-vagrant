# Ansible Role: repo-nodesource

Set up the official nodejs repo.

On CentOS, the node version available via yum is woefully out of date. The officially-supported method of installing more recent versions of node is to download and run a bash script, which obviously has security issues, especially if repeated on every playbook execution.

This role, by default, will install the nodesource repo only if it's not already installed. To enforce an install (such as when changing versions of node), add ` -e "nodejs_update=true" ` to your `ansible-playbook` command.

To install nodejs via yum after the repo setup is complete, add "install_nodejs: true" to your variables.

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details.

## Dependencies

None.

## Example Playbook

    - hosts: web-servers
      roles:
        - { role: classyllama.repo-nodesource, tags: nodejs }


## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2020 by Matthew Swinney.
