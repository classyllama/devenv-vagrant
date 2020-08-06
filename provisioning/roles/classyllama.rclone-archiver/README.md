# Ansible Role: Rclone

Installs a script and cronjob to use rclone (https://rclone.org/) to sync files with remote servers / cloud storage on a daily scheduled basis.

The script writes to a log file on execution and log files are setup to be maintained by logrotate weekly for 12 weeks.

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details. 

## Dependencies

None.

## Example Playbook

    - hosts: all
      vars:
        rclone_archiver_items:
          - source_directory: /var/filebackup
            remote: rclone_remote_name
            bucket: s3_bucket_name
            destination_directory: my_hostname/filebackup
            log_file: /var/log/rclone_archiver/filebackup.log
            cron_hour: 2
            cron_minute: 0
          - source_directory: /var/dbbackup
            remote: rclone_remote_name
            bucket: s3_bucket_name
            destination_directory: my_hostname/dbbackup
            log_file: /var/log/rclone_archiver/dbbackup.log
            cron_hour: 2
            cron_minute: 30
        rclone_logrotate_sets:
          - path: /var/log/rclone_archiver/*.log
            owner: root
            group: root
      roles:
        - { role: classyllama.rclone-archiver }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2020 by [Matt Johnson](https://github.com/mttjohnson/).
