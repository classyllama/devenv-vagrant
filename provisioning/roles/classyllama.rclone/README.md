# Ansible Role: Rclone

Installs the rclone (https://rclone.org/) package from EPEL on RHEL / CentOS for syncing files to remote servers / cloud storage.

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details. 

If no `rclone_configs` variable is defined, there will not be an rclone config file created by this role, and this role will just install the application from the package manager.

If you want to utilize some other repo beside the one installed by the `geerlingguy.repo-epel` role, set the variable `use_geerlingguy_repo_epel` to false.

## Dependencies

geerlingguy.repo-epel

## Example Playbook

    - hosts: all
      vars:
        rclone_configs:
           name: backup_remote_test
           properties:
             type: s3
             provider: AWS
             # WARNING: This is not a good idea to store sensetive details in ansible variable files
             # This is useful for testing only, but it is recommended to use env_auth for rclone configs,
             # or potentially ansible vault for encrypting the variable value
             env_auth: false
             access_key_id: XXXXXXXXXXXXXXXXXXXX
             secret_access_key: YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
             region: us-east-1
             acl: private
             storage_class: INTELLIGENT_TIERING
          - name: backup_remote
            properties:
              type: s3
              provider: AWS
              # This will utilize the default profile in the AWS credentials file ~/.aws/credentials
              env_auth: true
              region: us-east-1
              acl: private
              storage_class: INTELLIGENT_TIERING
      roles:
        - { role: classyllama.rclone }

## Notes

https://rclone.org/s3/

    # Default config file: ~/.config/rclone/rclone.conf

    # Check version installed
    rclone --version

    # List all the remotes configured for this user
    rclone listremotes

    # Lists contents on a remote
    rclone ls <remote_name>:<bucket_name>

    # Sync files to remote dry run example
    rclone sync /var/dbbackup backup_remote:my_backup_bucket/this_server_name/dbbackup \
      --bwlimit 0 --tpslimit 10 --transfers 4 --checkers 8 \
      --checksum --update --create-empty-src-dirs --immutable \
      --log-level INFO --stats-one-line --stats 5s --stats-unit=bits --progress \
      --log-file /var/log/rclone_archiver/dbbackup.log \
      --dry-run

    # Adjusting for time lag
    date -u
    chronyc
    #chronyc> tracking
    #chronyc> makestep
    date -u

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2020 by [Matt Johnson](https://github.com/mttjohnson/).
