# Change Log

## 0.2.NEXT

- Inclusion of oathtool in common tools installed
- Updating default values in crontab task
- Updated dependent Ansible Roles 
  - Improved support for check mode before install
  - Magento Demo Install defaults to 4GB RAM during install and is now configurable
  - Magento Demo Install defaults to developer deployment mode
  - Magento Demo Install defaults to redis fpc use
  - Improved MariaDB install for logging and tempdir
  - Improved Percona install for logging and tempdir
  - Nginx config improvements for Magento 2.4.2
  - Improved PHP-FPM child count calculation
  - PHP-FPM default changed to v7.3
  - Fixed Varnish 6.0 and 6.4 configs options
  - New option for www-user to support UID GID assignments
- Updated Virtualbox config to use newer default VMSVGA graphics controller
- Updated minimum Ansible version to 2.10
- Install nvm and lts version of node by default
- Install grunt by default

## 0.2.9 - 2020-12

- Support PowerTools repoid changes in CentOS 8.3 release
- automatically try to detect powertools repo name
- provide variable override for powertools repo name
- provide variable conditionals for if all yum packages should be updated

## 0.2.8 - 2020-11

- Documentation Updates
- Sample File Updates
- Improved samples files to demonstrate multi domain setups
- Updated Magento Demo install script to support 2.4.1 and newer 2.4.x installs
- Update of Elasticsearch default install version to latest 7.x (7.10.0)
- Bug - Percona introduced changes requiring updates to the role
- Bug - Composer introduced changes v2.x requireing updates to the role so that selfupdate can be disabled

## 0.2.7 - 2020-10

- Bug - Fixed web-info vhost expecting ssl cert where none exists
- Bug - Fixed MariaDB log file that couldn't be created due to permission issues
- Feature - xdebug status
- Updated Mutagen sample to not exclude /dev/ directory on sync

## 0.2.6 - 2020-10

- Windows Support
- Organization of documentation and references

## 0.2.5 - 2020-10

- Bug - dnf sync error
- Bug - Authorize additional key on vagrant user
- Bug - persist_root_my_cnf not defined

## 0.2.4 - 2020-10

- Updates to ansible roles geerlingguy.repo-epel and geerlingguy.repo-remi
- Updates instructions for installing mutagen on macos
- xdebug - resolve issue of missing zend_extension key in ini file
- xdebug - verify if php module is enabled/disabled correctly
- disable default plugin install
- cleanup todo list
- new ansible role for environment info
- adding exclusion for $ character in mysql generated passwords

## 0.2.3 - 2020-09

- Provide reference variable for persisting root .my.cnf
- Update default elasticsearch version
- Fixing order of variable evaluation in conditional for persisting root mysql credentials
- Defaulting magento-demo install to false since configs are merged not entirely replaced
- Updated minimum Ansible version to 2.9

## 0.2.2 - 2020-08

Magento Demo Install

- Automatic initialization of example TFA during demo install for simplifying quick access to demo install

## 0.2.1 - 2020-08

MariaDB Improvements / Persisting root .my.cnf

- Updates to MariaDB role for more secure db root user
- Persisting root mysql credentials to persistent disk and restoring on rebuild
- Updates to Percona role with some reorganization of files and better .my.cnf file permissions
- Correct magento-demo install when using elasticsearch configs
- Ensure default php-fpm config file does not remain in nginx default.d directory
- Fixes problems with dynamic static file generation in Magento developer mode

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





