#!/usr/bin/env bash

set -eu

# Variables
COMPOSER_AUTH_USER=$(composer config -g http-basic.repo.magento.com | jq -r '.username')
COMPOSER_AUTH_PASS=$(composer config -g http-basic.repo.magento.com | jq -r '.password')
MAGENTO_REL_VER="2.3.5-p1"
ENV_ROOT_DIR="/var/www/html"

MAGENTO_COMPOSER_PROJECT="magento/project-community-edition"

MAGENTO_ROOT_DIR="${ENV_ROOT_DIR}/magento"
SITE_ROOT_DIR="${ENV_ROOT_DIR}/current"

DB_HOST=$(echo $(grep "^\s*host " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))
DB_USER=$(echo $(grep "^\s*user " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))
DB_PASS=$(echo $(grep "^\s*password " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))
DB_NAME=$(echo $(grep "^\s*database " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))

SITE_HOSTNAME="centos8.lan"
BASE_URL="https://${SITE_HOSTNAME}"
BACKEND_FRONTNAME="backend"

ADMIN_USER="admin_$(printf "%s%s%s" \
    $(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-z0-9' | fold -w 6 | head -n1))"
ADMIN_EMAIL=demouser@example.com
ADMIN_FIRST=Demo
ADMIN_LAST=User
ADMIN_PASS="$(printf "%s%s%s%s%s" \
    $(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n1) \
    $(cat /dev/urandom | env LC_CTYPE=C tr -dc '0-9' | fold -w 2 | head -n1) \
    $(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 11 | head -n1) \
    $(cat /dev/urandom | env LC_CTYPE=C tr -dc '0-9' | fold -w 2 | head -n1) \
    $(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n1))"
ADMIN_URL="${BASE_URL}/${BACKEND_FRONTNAME}/admin"

# Setup Directories
mkdir -p ${MAGENTO_ROOT_DIR}
cd ${MAGENTO_ROOT_DIR}

# Deploy install files
composer config -g http-basic.repo.magento.com ${COMPOSER_AUTH_USER} ${COMPOSER_AUTH_PASS}
composer create-project \
  --repository-url https://repo.magento.com/ ${MAGENTO_COMPOSER_PROJECT} ${MAGENTO_ROOT_DIR} ${MAGENTO_REL_VER} \
  -s stable \
  --no-interaction \
  --prefer-dist \
  --no-dev
echo
composer config -a http-basic.repo.magento.com ${COMPOSER_AUTH_USER} ${COMPOSER_AUTH_PASS}
chmod +x bin/magento
bin/magento sampledata:deploy

# Run installation
bin/magento setup:install \
  --base-url="${BASE_URL}" \
  --base-url-secure="${BASE_URL}" \
  --backend-frontname="${BACKEND_FRONTNAME}" \
  --use-rewrites=1 \
  --admin-user="${ADMIN_USER}" \
  --admin-firstname="${ADMIN_FIRST}" \
  --admin-lastname="${ADMIN_LAST}" \
  --admin-email="${ADMIN_EMAIL}" \
  --admin-password="${ADMIN_PASS}" \
  --db-host="${DB_HOST}" \
  --db-user="${DB_USER}" \
  --db-password="${DB_PASS}" \
  --db-name="${DB_NAME}" \
  --magento-init-params="MAGE_MODE=production" \
  --use-secure=1 \
  --use-secure-admin=1 \
  --http-cache-hosts=127.0.0.1:6081 \
;

# Configure Magento
bin/magento config:set web/unsecure/base_url ${BASE_URL}/
bin/magento config:set web/secure/base_url ${BASE_URL}/
bin/magento config:set web/unsecure/base_static_url ${BASE_URL}/static/
bin/magento config:set web/secure/base_static_url ${BASE_URL}/static/
bin/magento config:set web/unsecure/base_media_url ${BASE_URL}/media/
bin/magento config:set web/secure/base_media_url ${BASE_URL}/media/

bin/magento config:set dev/static/sign 1

bin/magento config:set system/full_page_cache/caching_application 2
bin/magento config:set system/full_page_cache/ttl 604800

# php -r '
#   echo "<?php\nreturn " . var_export(array_merge(
#     include("'${MAGENTO_ROOT_DIR}'/app/etc/env.php"),
#     ["system" => ["default" => ["design" => ["head" => ["demonotice" => "1"]]]]]
#   ), true) . ";\n";
# ' > ${MAGENTO_ROOT_DIR}/app/etc/env.php

bin/magento app:config:import
bin/magento cache:flush
bin/magento deploy:mode:set production
bin/magento cache:flush

# bin/magento catalog:images:resize
# bin/magento setup:di:compile
# https=off
# bin/magento setup:static-content:deploy en_US
# https=on
# bin/magento setup:static-content:deploy en_US --no-javascript --no-css --no-less --no-images --no-fonts --no-html --no-misc --no-html-minify




# Create SymLink for site root
ln -s ${MAGENTO_ROOT_DIR} ${SITE_ROOT_DIR}

LOADTEST_USER="load_test"
LOADTEST_EMAIL=loadtest@example.com
LOADTEST_FIRST=Load
LOADTEST_LAST=Test
LOADTEST_PASS="$(printf "%s%s%s%s%s" \
    $(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n1) \
    $(cat /dev/urandom | env LC_CTYPE=C tr -dc '0-9' | fold -w 2 | head -n1) \
    $(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 11 | head -n1) \
    $(cat /dev/urandom | env LC_CTYPE=C tr -dc '0-9' | fold -w 2 | head -n1) \
    $(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n1))"

mr admin:user:create \
  --admin-user=${LOADTEST_USER} \
  --admin-password=${LOADTEST_PASS} \
  --admin-email=${LOADTEST_EMAIL} \
  --admin-firstname=${LOADTEST_FIRST} \
  --admin-lastname=${LOADTEST_LAST}

# Save admin credentials as indicator that script completed successfully
ADMIN_CREDENTIALS=$(cat <<CONTENTS_HEREDOC
{
  "base_url": "${BASE_URL}",
  "admin_url": "${BASE_URL}/${BACKEND_FRONTNAME}",
  "admin_user": "${ADMIN_USER}",
  "admin_pass": "${ADMIN_PASS}",
  "loadtest_user": "${LOADTEST_USER}",
  "loadtest_pass": "${LOADTEST_PASS}"
}
CONTENTS_HEREDOC
)
echo "${ADMIN_CREDENTIALS}" > ${ENV_ROOT_DIR}/magento_admin_credentials.json

cat ${ENV_ROOT_DIR}/magento_admin_credentials.json | jq .