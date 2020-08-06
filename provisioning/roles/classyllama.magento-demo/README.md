# Ansible Role: Magento Demo

Installs a shell script on RHEL / CentOS for installing Magento with demo data.

The role sets up a config file for a specific domain/directory/user and saves the config files and scripts in the user's home directory ~/username/magento-demo/.

## Requirements

None.

## Role Variables

See `defaults/main.yml` for details.

## Dependencies

None.

## Example Playbook

    - hosts: all
      vars:
        magento_demo_config_overrides:
          magento_demo_hostname: example.lan
          magento_demo_env_root: /var/www/data
          magento_demo_magento_root: /var/www/data/magento
          magento_demo_user: www-data
          magento_demo_group: www-data
          
          MAGENTO_COMPOSER_PROJECT: magento/project-community-edition
          MAGENTO_REL_VER: 2.4.0
          REDIS_OBJ_HOST: "localhost"
          REDIS_OBJ_PORT: "6379"
          REDIS_OBJ_DB: "0"
          REDIS_SES_HOST: "localhost"
          REDIS_SES_PORT: "6379"
          REDIS_SES_DB: "1"
          REDIS_FPC_HOST: "localhost"
          REDIS_FPC_PORT: "6379"
          REDIS_FPC_DB: "2"
          VARNISH_HOST: "localhost"
          VARNISH_PORT: "6081"
          SEARCH_ENGINE: "elasticsearch7"
          ELASTIC_HOST: "localhost"
          ELASTIC_PORT: "9200"
          ELASTIC_ENABLE_AUTH: "1"
          ELASTIC_USERNAME: "elastic"
          ELASTIC_PASSWORD: "changeme"
      roles:
        - { role: classyllama.magento-demo }

## Notes

    # Once the scripts are on the server
    ~/magento-demo/install-magento.sh config_site.json

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This role was created in 2020 by [Matt Johnson](https://github.com/mttjohnson/).
