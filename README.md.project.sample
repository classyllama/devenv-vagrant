# Requirements

For any system requirements or troubleshooting there are references in the [devenv-vagrant README.md](https://github.com/classyllama/devenv-vagrant/blob/master/README.md).

[macOS Setup](https://github.com/classyllama/devenv-vagrant/blob/master/macOsSetup.md)

[Windows Setup](https://github.com/classyllama/devenv-vagrant/blob/master/windowsSetup.md)

[Project Setup](https://github.com/classyllama/devenv-vagrant/blob/master/projectSetup.md)

[Troubleshooting](https://github.com/classyllama/devenv-vagrant/blob/master/troubleshooting.md)

# Initialize DevEnv (from Host)

  Initialize DevEnv repo source files

    gitman install

  Build machine
  
    vagrant up
  
  Set Environment Variables
  
    DEVENV_HOST="example.lan"
  
  Clear out any old host keys and add the current one
  
    IP_ADDRESS=$(cat /etc/hosts | grep ${DEVENV_HOST} | head -n 1 | grep -Eo -m 1 '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    ssh-keygen -R ${DEVENV_HOST}
    ssh-keygen -R ${IP_ADDRESS}
    ssh-keyscan -H ${DEVENV_HOST} >> ~/.ssh/known_hosts
  
  Start Mutagen

    mutagen project start
    mutagen sync monitor

  Wait for syncing to complete, then terminate
  We prefer not to have mutagen running during the composer install

    mutagen project terminate

# Initialize DevEnv (from within VM)

    vagrant ssh
  
  Set Environment Variables
  
    DEVENV_HOST="example.lan"
    STAGE_USER="www-stage"
    STAGE_HOST="stage.example.com"
    STAGE_MAGE_ROOT="/domains/stage.hdlusa.com/current"
    STAGE_SHARED_ROOT="/domains/stage.hdlusa.com/shared"
    STAGE_DB_NAME="example_stage"

  Make sure correct version of composer is installed
  
    wget https://getcomposer.org/download/1.10.16/composer.phar
    chmod 755 composer.phar
    sudo mv composer.phar /usr/local/bin/composer

  Add stage host key to VM DevEnv
  
    ssh-keyscan -H ${STAGE_HOST} >> ~/.ssh/known_hosts

  Initialize files if needed

    cd /var/www/data/magento
    composer install

  Setup configs for env.php

    cd /var/www/data/magento

    mkdir -p pub/media
    mkdir -p pub/static

    # Get DB Credentials
    DB_HOST=$(echo $(grep "^\s*host " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))
    DB_USER=$(echo $(grep "^\s*user " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))
    DB_PASS=$(echo $(grep "^\s*password " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))
    DB_NAME=$(echo $(grep "^\s*database " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))

    bin/magento setup:install \
      --base-url="https://${DEVENV_HOST}" \
      --base-url-secure="https://${DEVENV_HOST}" \
      --backend-frontname="backend" \
      --use-rewrites=1 \
      --admin-user="devadmin" \
      --admin-firstname="admin" \
      --admin-lastname="admin" \
      --admin-email="admin@${DEVENV_HOST}" \
      --admin-password="admin123" \
      --db-host="${DB_HOST}" \
      --db-user="${DB_USER}" \
      --db-password="${DB_PASS}" \
      --db-name="${DB_NAME}" \
      --magento-init-params="MAGE_MODE=developer" \
      --use-secure=1 \
      --use-secure-admin=1 \
      --session-save=redis \
      --session-save-redis-host=127.0.0.1 \
      --session-save-redis-port=6379 \
      --session-save-redis-db=1 \
      --cache-backend=redis \
      --cache-backend-redis-server=127.0.0.1 \
      --cache-backend-redis-db=0 \
      --cache-backend-redis-port=6379 \
    ;

  Alternatively use template and replace encryption key

    cd /var/www/data/magento
    cp -a app/etc/env.php.dev app/etc/env.php

  Copy the encryption key from stage into app/etc/env.php.
  
    STAGE_CRYPT_KEY=$(\
        ssh -q ${STAGE_USER}@${STAGE_HOST} "\
            php -r \"\
                \\\$env = include '${STAGE_MAGE_ROOT}/app/etc/env.php';
                echo \\\$env['crypt']['key'];
                \"\
            "\
        )

    echo "${STAGE_CRYPT_KEY}"

  Replace the encryption key in the env.php file with the one from stage

```
DB_HOST=$(echo $(grep "^\s*host " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))
DB_USER=$(echo $(grep "^\s*user " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))
DB_PASS=$(echo $(grep "^\s*password " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))
DB_NAME=$(echo $(grep "^\s*database " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))

set +H
PHP_CODE=$(cat <<PHP_CODE_HEREDOC
<?php
\$existing_env = include("app/etc/env.php");
\$crypt_key = ['crypt'=>['key'=>'${STAGE_CRYPT_KEY}']];
\$db_creds = [
      'db' => [
        'connection' => [
            'default' => [
                'username' => '${DB_USER}',
                'host' => '${DB_HOST}',
                'dbname' => '${DB_NAME}',
                'password' => '${DB_PASS}'
            ],
            'indexer' => [
                'username' => '${DB_USER}',
                'host' => '${DB_HOST}',
                'dbname' => '${DB_NAME}',
                'password' => '${DB_PASS}'
            ]
        ]
      ]
  ];
\$combined_env = var_export(array_merge(\$existing_env,\$crypt_key,\$db_creds), true);
\$export_short_array_syntax = join(PHP_EOL, array_filter(["["] + preg_replace(["/\s*array\s\(\$/", "/\)(,)?\$/", "/\s=>\s\$/"], [NULL, ']\$1', ' => ['], preg_split("/\r\n|\n|\r/", preg_replace("/^([ ]*)(.*)/m", '\$1\$1\$2', \$combined_env)))));
echo "<?php
return " . \$export_short_array_syntax . ";
";
PHP_CODE_HEREDOC
)
set -H
NEW_ENV=$(echo "${PHP_CODE}" | php)
echo "${NEW_ENV}" > app/etc/env.php
php -l app/etc/env.php
```

  Display encryption key in DevEnv

    php -r "
        \$env = include '/var/www/data/current/app/etc/env.php';
        echo \$env['crypt']['key'] . \"\n\";
        "

  Import Database from stage
  
    echo "
    mysql -e 'show databases'
    " | ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        ${STAGE_USER}@${STAGE_HOST}

    echo "show databases" | mysql

    # About X minute (XX.XMiB)
    echo "
    mysqldump \
        --single-transaction \
        --triggers \
        --routines \
        --events \
        --default-character-set=utf8 \
        ${STAGE_DB_NAME} | gzip
    " | ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        ${STAGE_USER}@${STAGE_HOST} bash \
      | pv | gunzip \
      | LC_ALL=C sed 's/\/\*[^*]*DEFINER=[^*]*\*\///g' \
      | mysql -D ${DB_NAME} --default-character-set=utf8

  Sync Media Files

    rsync -avz --progress \
      -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR" \
      --exclude="catalog/product/cache" \
      --exclude="captcha/*" \
      --exclude="tmp/*" \
      ${STAGE_USER}@${STAGE_HOST}:${STAGE_SHARED_ROOT}/pub/media/ \
      /var/www/data/magento/pub/media/

  Setup configs for devenv

    cd /var/www/data/magento

    # Initialize setup
    bin/magento setup:upgrade

    # Configure Magento
    
    # Default
    bin/magento config:set --lock-env web/unsecure/base_url https://${DEVENV_HOST}/
    # bin/magento config:set --lock-env web/unsecure/base_link_url https://${DEVENV_HOST}/
    # bin/magento config:set --lock-env web/unsecure/base_static_url https://${DEVENV_HOST}/static/
    # bin/magento config:set --lock-env web/unsecure/base_media_url https://${DEVENV_HOST}/media/
    bin/magento config:set --lock-env web/secure/base_url https://${DEVENV_HOST}/
    # bin/magento config:set --lock-env web/secure/base_link_url https://${DEVENV_HOST}/
    # bin/magento config:set --lock-env web/secure/base_static_url https://${DEVENV_HOST}/static/
    # bin/magento config:set --lock-env web/secure/base_media_url https://${DEVENV_HOST}/media/

    # store1 example
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/unsecure/base_url https://store1.${DEVENV_HOST}/
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/unsecure/base_link_url https://store1.${DEVENV_HOST}/
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/unsecure/base_static_url https://store1.${DEVENV_HOST}/static/
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/unsecure/base_media_url https://store1.${DEVENV_HOST}/media/
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/secure/base_url https://store1.${DEVENV_HOST}/
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/secure/base_link_url https://store1.${DEVENV_HOST}/
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/secure/base_static_url https://store1.${DEVENV_HOST}/static/
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/secure/base_media_url https://store1.${DEVENV_HOST}/media/

    bin/magento config:set dev/static/sign 0
    bin/magento config:set system/full_page_cache/caching_application 1

    bin/magento app:config:import
    bin/magento cache:flush
    bin/magento deploy:mode:set developer
    bin/magento cache:flush

    bin/magento cache:disable layout
    bin/magento cache:disable block_html
    bin/magento cache:disable full_page

# Finish Initialize DevEnv (from Host)

  Monitor Mutagen

    mutagen sync monitor

  Open in browser

    https://example.lan/
  
  Stop Mutagen
  
    mutagen sync terminate magento
  
  Stop Vagrant
  
    vagrant halt
