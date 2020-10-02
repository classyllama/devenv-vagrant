# Requirements

### MacOS

Install tools needed for DevEnv

    brew cask install virtualbox
    brew cask install vagrant
    vagrant plugin list
    vagrant plugin install vagrant-hostmanager
    vagrant plugin install vagrant-digitalocean
    brew install ansible
    brew install mutagen
    brew install python

Allow vagrant-hostmanager to update hosts file without requiring password prompt

```
HOME_DIR="${HOME}"
USER_GROUP_NAME="$(id -gn $(whoami))"
echo "
HOME_DIR: ${HOME_DIR}
USER_GROUP_NAME: ${USER_GROUP_NAME}
VAGRANT_HOME: ${VAGRANT_HOME}
"
echo "
Cmnd_Alias VAGRANT_HOSTMANAGER_UPDATE = /bin/cp ${VAGRANT_HOME}/tmp/hosts.local /etc/hosts
%${USER_GROUP_NAME} ALL=(root) NOPASSWD: VAGRANT_HOSTMANAGER_UPDATE
" | sudo tee /etc/sudoers.d/vagrant_hostmanager
```

Add this to your bash profile `~/.bash_profile` to make sure python 3.x is default for shell commands.
For zsh you should put this in `~/.zshrc`

    export PATH="/usr/local/opt/python/libexec/bin:$PATH"

Check default python version

    python --version

Install Gitman (v1.7+)

    pip install gitman

# Initialize DevEnv

  Initialize DevEnv repo source files

    gitman install
  
  or
  
    mkdir -p repo_sources
    cd repo_sources
    git clone git@github.com:alpacaglue/exp-vagrant-m2.git devenv
    cd devenv
    git checkout feature/project-attempt
    bash gitman_init.sh
    cd ../../

  Build machine
  
    vagrant up
  
  Start Mutagen

    mutagen project start
    mutagen sync monitor

  Initialize files if needed

    cd /var/www/data/magento

    composer install

  Setup configs for env.php

    cd /var/www/data/magento

    mkdir pub/media
    mkdir pub/static

    bin/magento setup:install \
      --base-url="https://example.lan" \
      --base-url-secure="https://example.lan" \
      --backend-frontname="backend" \
      --use-rewrites=1 \
      --admin-user="devadmin" \
      --admin-firstname="admin" \
      --admin-lastname="admin" \
      --admin-email="admin@example.lan" \
      --admin-password="admin123" \
      --db-host="127.0.0.1" \
      --db-user="root" \
      --db-password="CHANGEME" \
      --db-name="demo_data" \
      --magento-init-params="MAGE_MODE=developer" \
      --use-secure=1 \
      --use-secure-admin=1 \
      --session-save=redis \
      --session-save-redis-host=127.0.0.1 \
      --session-save-redis-port=6380 \
      --session-save-redis-db=0 \
      --cache-backend=redis \
      --cache-backend-redis-server=127.0.0.1 \
      --cache-backend-redis-db=0 \
      --cache-backend-redis-port=6379 \
    ;

  Import Database from stage

  If you want to keep the database dump file from stage in your project directory it may be best to store it in the `tools/devenv` directory so that it doesn't get synced down to the VM as mutagen ignores the `tools/devenv` directory.

    echo "
    mysql -e 'show databases'
    " | ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        www-stage@stage.example.com

    echo "show databases" | vagrant ssh -c "mysql" -- -q

    # About X minute (XX.XMiB)
    echo "
    mysqldump \
        --single-transaction \
        --triggers \
        --routines \
        --events \
        --default-character-set=utf8 \
        example_stage | gzip
    " | ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        www-stage@stage.example.com \
      | pv | gunzip \
      | LC_ALL=C sed 's/\/\*[^*]*DEFINER=[^*]*\*\///g' \
      | vagrant ssh -c \
      "mysql -D demo_data --default-character-set=utf8" -- -q

  Sync Media Files

  Run from within the VM

    rsync -avz --progress \
      -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR" \
      --exclude="catalog/product/cache" \
      --exclude="captcha/*" \
      --exclude="tmp/*" \
      www-stage@stage.example.com:/var/www/stage/shared/pub/media/ \
      /var/www/data/magento/pub/media/

  Setup configs for devenv

    cd /var/www/data/magento

    # Initialize setup
    bin/magento setup:upgrade

    # Configure Magento
    
    # Default
    bin/magento config:set --lock-env web/unsecure/base_url https://example.lan/
    bin/magento config:set --lock-env web/unsecure/base_link_url https://example.lan/
    bin/magento config:set --lock-env web/unsecure/base_static_url https://example.lan/static/
    bin/magento config:set --lock-env web/unsecure/base_media_url https://example.lan/media/
    bin/magento config:set --lock-env web/secure/base_url https://example.lan/
    bin/magento config:set --lock-env web/secure/base_link_url https://example.lan/
    bin/magento config:set --lock-env web/secure/base_static_url https://example.lan/static/
    bin/magento config:set --lock-env web/secure/base_media_url https://example.lan/media/

    # store1 example
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/unsecure/base_url https://store1.example.lan/
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/unsecure/base_link_url https://store1.example.lan/
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/unsecure/base_static_url https://store1.example.lan/static/
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/unsecure/base_media_url https://store1.example.lan/media/
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/secure/base_url https://store1.example.lan/
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/secure/base_link_url https://store1.example.lan/
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/secure/base_static_url https://store1.example.lan/static/
    # bin/magento config:set --scope=store --scope-code=store1 --lock-env web/secure/base_media_url https://store1.example.lan/media/

    bin/magento config:set dev/static/sign 0
    bin/magento config:set system/full_page_cache/caching_application 1

    bin/magento app:config:import
    bin/magento cache:flush
    bin/magento deploy:mode:set developer
    bin/magento cache:flush

    bin/magento cache:disable layout
    bin/magento cache:disable block_html
    bin/magento cache:disable full_page

  Monitor Mutagen

      mutagen sync monitor

  Open in browser

    https://example.lan/
  
  Stop Mutagen
  
    mutagen sync terminate magento
  
  Stop Vagrant
  
    vagrant halt
