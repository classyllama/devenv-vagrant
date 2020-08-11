# Change Log

## 0.2 - 2020-08

Notable Changes/Improvements

- Changes to allow non Magento uses for purpose of Laravel development
- Conditional variables for multiple tasks and roles - added to defaults
  use_classyllama_n98_magerun: true
  use_classyllama_magento_demo: true
  use_current_to_app_install_symlink: true
  use_create_www_projects_dir: true
  use_create_www_app_install_dir: true
  load_magento_composer_auth_from_host: true
- New variables defined for database creation
  database_create_user: magento_data
  database_create_db: demo_data

## 0.1 - 2020-08

Notable Changes/Improvements

- Support for CentOS 8
- Changes to default HTML directory on www-data user. Previous default was to use /var/www/html/ and now /var/www/data/ is used instead.
- Added copy of ansible.cfg to persistent directory so that Vargrant provisioning works the same as calling ansible directly from provisioning directory.
- Updates to mysql user password generation for more complex requirements in Percona 5.7 and MariaDB 10.3
- Support for AppStream repo (DNF Module Stream Versions) use on CentOS 8
- Variables to conditionally install various roles or yum repo dependency roles
- Better support for variables to define the version of a service to install
- Caching of yum/dnf rpm packages and PHP composer packages on host for quicker rebuilds
- Some system packages moved out of task in common.yml playbook into boilerplate role
- The common.yml playbook now updates all yum packages to latest and reboots if necessary
- Fixed ansible version check to work more consistently when using host filters
- Option of using MariaDB 10.3 on CentOS 8
- Support for ElasticSearch 7.x
- Support for Varnish (6 from CentOS 8 AppStream) or (6.4 from Varnish yum repo)
- Support for Redis 5
- New Magento Demo install role (supporting Magento 2.2.x, 2.3.x, and 2.4.x installs)
- Move to chronyd instead of ntpd for system time sync
- Default of single redis instances installed
- Default redis databases changed from 2 to 3 for better default single instances use
- Removed default backend from nginx role
- Moved nginx yum repo installation to separate role as an optional dependency
- Added support for CentOS 8 AppStream yum repo installation of nginx
- The ability for the php role to install PECL packages
- PHP package install from remi, remi-modular, or CentOS 8 AppStream repos
- Inclusion of simple backup solution roles (dbbackup/filebackup/rclone/rclone-archiver)
- Addition of repo-nginx role
- Addition of repo-nginx-appstream role
- Addition of repo-php-appstream role
- Addition of repo-php-remi role
- Addition of repo-python-appstream role
- Addition of repo-varnish
- No longer installing ImageMagick by default

Roles Updated

  - classyllama.boilerplate
  - classyllama.dbbackup
  - classyllama.filebackup
  - classyllama.magento-demo
  - classyllama.mariadb
  - classyllama.multi-redis
  - classyllama.nginx
  - classyllama.percona
  - classyllama.php-cachetool
  - classyllama.php_fpm
  - classyllama.python
  - classyllama.rclone
  - classyllama.rclone-archiver
  - classyllama.repo-nginx
  - classyllama.repo-percona
  - classyllama.repo-php-appstream
  - classyllama.repo-remi-modular
  - classyllama.repo-python-appstream
  - classyllama.repo-varnish
  - classyllama.varnish
  - classyllama.www-user
  - elastic.elasticsearch
  - geerlingguy.repo-remi

Breaking Changes

  Anything that previous references `/var/www/html/` should now be updated to reference `/var/www/data/`




