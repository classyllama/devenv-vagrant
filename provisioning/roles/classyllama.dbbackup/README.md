# Ansible Role: DB Backup

Installs a shell script on RHEL / CentOS for backing up a MySQL database using mysqldump.

The script gets a list of all databases and then proceeds to run separate schema and data dumps uisng mysqldump from the database server. The files are piped to gzip so they are stored compressed on disk.

A cronjob is setup to run from root daily at 1:00AM each day.

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details.

## Dependencies

None.

## Example Playbook

    - hosts: all
      roles:
        - { role: classyllama.dbbackup }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2017 by [Matt Johnson](https://github.com/mttjohnson/) and [David Alger](https://davidalger.com/).