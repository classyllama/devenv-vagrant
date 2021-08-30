# Ansible Role: Multi-Redis

[![Build Status](https://travis-ci.org/davidalger/ansible-role-multi-redis.svg?branch=master)](https://travis-ci.org/davidalger/ansible-role-multi-redis)

Installs multiple instances of Redis service from on RHEL / CentOS. Where archived verions of redis are required for CentOS 7 (such as Redis 3.0, 3.2), the ius-archive repository may be enabled. For Redis 6 is uses [Remi's repository](https://rpms.remirepo.net/) repository on CentOS 7 (which is disabled by default) and Appstream on CentOS 8 using classyllama.repo-redis-appstream role.

Currently this role installs redis pre-configured with defaults tuned for Magento. Some of these defaults may be different if this role is used to deploy redis in a non-Magento environment. See `defaults/main.yml` for details.

## Requirements

None.

## Role Variables

For RHEL/CentOS 8 IUS is not available, and you will need to enable the remi and appstream dependencies

    # use_classyllama_repo_ius: false
    # use_geerlingguy_repo_remi: false
    use_classyllama_repo_redis_appstream: true

...then set the version, package name, and stream versions.

    redis_version: 60           # Must have two digits in version for proper systemd setup
    redis_package_name: redis   # Spcific package name may have suffix or version number in name
    redis_enablerepo: ""        # Some yum repos may be disabled by default and need to be specified here
    redis_stream_version: "6"   # Used on RHEL/CentOS 8 for defining stream to enable on 

On older operating systems such as RHEL/CentOS 7, older redis version supported by IUS RPMs may be specified: 30, 32, etc. For these older versions, `redis_enablerepo: ius-archive` will also need to be specified. For Redis 6.X on RHEL/CentOS 7 it is only available from the 'remi' repository which only supports the latest Redis version.

See `defaults/main.yml` for complete list of variables available to customize the redis services.

## Dependencies

* `classyllama.repo_ius`
* `classyllama.repo-remi`
* `classyllama.repo-redis-appstream`

## Operating System / Version (Source) - Configurations

### RHEL/CentOS 7

Options for installing Redis on CentOS 7 are limited and can come from either IUS or Remi yum repositories. We prefer the IUS repo over Remi, but Redis 6 is only available from Remi on CentOS 7

CentOS 7 / Redis 3.2 (IUS)

    use_classyllama_repo_ius: true
    # use_geerlingguy_repo_remi: false
    use_classyllama_multi_redis: true
    use_classyllama_repo_redis_appstream: false
    redis_package_name: "redis32u"
    redis_enablerepo: "ius-archive"
    redis_version: 32

CentOS 7 / Redis 5.0 (IUS)

    use_classyllama_repo_ius: true
    # use_geerlingguy_repo_remi: false
    use_classyllama_multi_redis: true
    use_classyllama_repo_redis_appstream: false
    redis_package_name: "redis5"
    redis_enablerepo: "ius"
    redis_version: 50

CentOS 7 / Redis 6.2 (Remi)
Redis 6.2 from [Remi's repository](https://rpms.remirepo.net/)

    # use_classyllama_repo_ius: false
    use_geerlingguy_repo_remi: true
    use_classyllama_multi_redis: true
    use_classyllama_repo_redis_appstream: false
    redis_package_name: "redis"
    redis_enablerepo: "remi"
    redis_version: 62

### RHEL/CentOS 8

With DNF and module streams there are more options available in CentOS 8 either from official RHEL/CentOS repositories or from Remi Modular repos.

CentOS 8 / Redis 5.0 (CentOS AppStream)

    # use_classyllama_repo_ius: false
    # use_geerlingguy_repo_remi: false
    use_classyllama_multi_redis: true
    use_classyllama_repo_redis_appstream: true
    redis_package_name: "redis"
    redis_enablerepo: ""
    redis_stream_version: "5"
    redis_version: 50

CentOS 8 / Redis 6.0 (CentOS AppStream)

    # use_classyllama_repo_ius: false
    # use_geerlingguy_repo_remi: false
    use_classyllama_multi_redis: true
    use_classyllama_repo_redis_appstream: true
    redis_package_name: "redis"
    redis_enablerepo: ""
    redis_stream_version: "6"
    redis_version: 60

CentOS 8 / Redis 5.0 (Remi Modular AppStream)

    # use_classyllama_repo_ius: false
    use_geerlingguy_repo_remi: true
    use_classyllama_multi_redis: true
    use_classyllama_repo_redis_appstream: true
    redis_package_name: "redis"
    redis_enablerepo: ""
    redis_stream_version: "remi-5.0"
    redis_version: 50

CentOS 8 / Redis 6.0 (Remi Modular AppStream)

    # use_classyllama_repo_ius: false
    use_geerlingguy_repo_remi: true
    use_classyllama_multi_redis: true
    use_classyllama_repo_redis_appstream: true
    redis_package_name: "redis"
    redis_enablerepo: ""
    redis_stream_version: "remi-6.0"
    redis_version: 60

CentOS 8 / Redis 6.2 (Remi Modular AppStream)

    # use_classyllama_repo_ius: false
    use_geerlingguy_repo_remi: true
    use_classyllama_multi_redis: true
    use_classyllama_repo_redis_appstream: true
    redis_package_name: "redis"
    redis_enablerepo: ""
    redis_stream_version: "remi-6.2"
    redis_version: 62

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
