# Ansible Role: Percona Repo

Installs a Yum/Dnf repo (percona-release) on RHEL / CentOS for installing software releases directly from Percona

There is a step involved in setting up the repo that configures it to target a specific version of Percona to install, and this is done using the percona-release copmmand utility installed as part of the percona-release package.

https://www.percona.com/doc/percona-repo-config/percona-release.html

## Requirements

None.

## Role Variables

Default repo version targets installing Percona for MySQL 5.7

See `defaults/main.yml` for details.

## Dependencies

None.

## Example Playbook

    - hosts: all
      vars:
        percona_version: 57 # Example 56, 57, 80
      roles:
        - { role: classyllama.percona, tags: mysql, when: use_classyllama_percona | default(false) }

## Notes

To show the enabled repositories in your system:

    percona-release show

The percona-release command is used to setup the repos for specific software packages. This is where the ansible percona_version variable is used to target a specific version.

    percona-release setup -y ps57

After the repo is configured you can list all packages

    yum list percona\*

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2017 by [David Alger](https://davidalger.com/) with contributions from [Matt Johnson](https://github.com/mttjohnson/).
