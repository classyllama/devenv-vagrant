# Ansible Role: Multi-Redis

[![Build Status](https://travis-ci.org/davidalger/ansible-role-multi-redis.svg?branch=master)](https://travis-ci.org/davidalger/ansible-role-multi-redis)

Installs multiple instances of Redis 3.2 service from [IUS Community Project](http://ius.io) RPMs on RHEL / CentOS 7. Where archived verions of redis are required (such as Redis 3.0), the ius-archive repository may be enabled. For Redis 6 is uses [Remi's repository](https://rpms.remirepo.net/) repository on CentOS 7 (which is disabled by default) and Appstream on CentOS 8 using classyllama.repo-redis-appstream role..

Currently this role installs redis pre-configured with defaults tuned for Magento. Some of these defaults may be different if this role is used to deploy redis in a non-Magento environment. See `defaults/main.yml` for details.

## Requirements

None.

## Role Variables

    redis_version: 32

Any redis version supported by IUS RPMs may be specified: 30, 32, etc. For older versions, `redis_enablerepo: ius-archive` will also need to be specified, for 6.X 'remi' repository must be included and enabled.

See `defaults/main.yml` for complete list of variables available to customize the redis services.

## Dependencies

* `classyllama.repo_ius`
* `classyllama.repo-remi`
* `classyllama.repo-redis-appstream`

## Redis 5.0 Support

This role will, when configured correctly, deploy Redis 5.0 succesfully:

    redis_version: 50               # Must have two digits in version for proper systemd setup
    redis_package_name: redis5      # There is no 'u' suffix on the package name for Redis 5
    redis_enablerepo: "ius"         # Must be set to ius or skipped completely in playbook variables

## Redis 6.0 Support on CentOS 7

This role will, when configured correctly, deploy Redis 6.0 succesfully using [Remi's repository](https://rpms.remirepo.net/):

    redis_version: 60               # Must have two digits in version for proper systemd setup
    redis_package_name: redis       # Package name 'redis' in Remi repository
    redis_enablerepo: "remi"
    use_geerlingguy_repo_remi: true # must be set to true to enable Remi repository which is disabled by default

## Redis 6.0 Support on CentOS 8

This role will, when configured correctly, deploy Redis 6.0 succesfully using AppStream modular repository:

    redis_version: 60                             # Must have two digits in version for proper systemd setup
    use_classyllama_repo_redis_remi_modular: true
    redis_package_name: "redis"

## Example Playbook

* Production triple-redis deployment:

        - { role: redis, tags: redis, redis_instance: { name: obj, port: 6379 }}
        - { role: redis, tags: redis, redis_instance: { name: fpc, port: 6381 }}
        - { role: redis, tags: redis, redis_instance: { name: ses, port: 6380, save: yes }}

* Stage triple-redis deployment:

        - { role: redis, tags: redis, redis_instance: { name: stage-obj, port: 6389 }}
        - { role: redis, tags: redis, redis_instance: { name: stage-fpc, port: 6391 }}
        - { role: redis, tags: redis, redis_instance: { name: stage-ses, port: 6390, save: yes }}

* Customized Instance Configs

    Override defaults and supply `maxmemory-policy` in the instance config instead of the base config:

        # Key/value hash of settings for /etc/redis-{{ redis_instance.name }}.conf
        redis_instance_config:
          - maxmemory-policy: "volatile-lru"

        # Key/value hash of settings for /etc/redis-base.conf
        redis_config:
          - daemonize: "yes"
          - timeout: "0"
          - loglevel: "notice"
          - databases: "2"
          - rdbcompression: "no"
          - dbfilename: "dump.rdb"
          - appendonly: "no"
          - appendfsync: "everysec"
          - no-appendfsync-on-rewrite: "no"
          - slowlog-log-slower-than: "10000"
          - slowlog-max-len: "1024"
          - list-max-ziplist-entries: "512"
          - list-max-ziplist-value: "64"
          - set-max-intset-entries: "512"
          - zset-max-ziplist-entries: "128"
          - zset-max-ziplist-value: "64"
          - activerehashing: "yes"
          - slave-serve-stale-data: "yes"
          - auto-aof-rewrite-percentage: "100"
          - auto-aof-rewrite-min-size: "64mb"
          - tcp-backlog: "511"
          - tcp-keepalive: "0"
          - repl-disable-tcp-nodelay: "no"

    Then when calling the role, specify the instance config value per role where it needs to be different

        - { role: redis, tags: redis, redis_instance: { name: obj, port: 6379 }, redis_maxmemory: 8gb, redis_instance_config: [{maxmemory-policy: allkeys-lru}] }
        - { role: redis, tags: redis, redis_instance: { name: fpc, port: 6381 }, redis_maxmemory: 8gb, redis_instance_config: [{maxmemory-policy: allkeys-lru}] }
        - { role: redis, tags: redis, redis_instance: { name: ses, port: 6380, save: yes }, redis_maxmemory: 8gb}

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2017 by [David Alger](http://davidalger.com/) with contributions from [Matt Johnson](https://github.com/mttjohnson/).
