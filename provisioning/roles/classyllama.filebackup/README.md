# Ansible Role: File Backup

Installs a shell script on RHEL / CentOS for backing up directories and files using tar.

The script creates a tar compressed archive of the specified directories (filebackup_backup_items) and then remove any previous backup files from 7 (filebackup_keep_days) days prior.

A cronjob is setup for each directory (filebackup_backup_items) to run from root daily at the specified time (cron_hour, cron_minute) each day.

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details.

## Dependencies

None.

## Example Playbook

    - hosts: all
      vars:
        filebackup_data_dir: /var/filebackup
        filebackup_backup_items:
          
          # Backup a single file /etc/hosts in the /etc directory
          - backup_name: etc_hosts
            backup_path: /etc
            backup_file: hosts
            cron_hour: 1
            cron_minute: 10
          
          # Backup the entire /etc directory
          - backup_name: etc
            backup_path: /etc
            cron_hour: 1
            cron_minute: 0
          
          # Backup the /var/www directory
          - backup_name: web
            backup_path: /var/www
            cron_hour: 1
            cron_minute: 0
          
        filebackup_keep_days: "1"
      roles:
        - { role: classyllama.filebackup }

## Notes

    # list contents of archive file
    tar -ztvf <backup_name>_<timestamp>.tar.gz

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2020 by [Matt Johnson](https://github.com/mttjohnson/).
