# Ansible Role: Redis Yum/Dnf Repo (AppStream Modular Configuration)

Configures the Yum/Dnf Stream Module for Redis on RHEL/CentOS 8.

## Requirements

None.

## Role Variables

None.

## Dependencies

None.

## Example Playbook

    - hosts: all
      vars:
        redis_stream_version: "6"
      roles:
        - { role: classyllama.repo-redis-appstream-modular }

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2021 by ClassyLlama.
