#!/usr/bin/env bash

set -eu

# Move execution to realpath of script
cd $(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)

########################################
## Command Line Options
########################################
declare CONFIG_FILE=""
for switch in $@; do
    case $switch in
        *)
            CONFIG_FILE="${switch}"
            if [[ "${CONFIG_FILE}" =~ ^.+$ ]]; then
              if [[ ! -f "${CONFIG_FILE}" ]]; then
                >&2 echo "Error: Invalid config file given"
                exit -1
              fi
            fi
            ;;
    esac
done
if [[ $# < 1 ]]; then
  echo "An argument was not specified:"
  echo " <config_filename>    Specify config file to use to override default configs."
  echo ""
  echo "Exampe: install-magento.sh config_stage.json"
  exit;
fi






# Config Files
CONFIG_DEFAULT="config_default.json"
CONFIG_OVERRIDE="${CONFIG_FILE}"
[[ "${CONFIG_OVERRIDE}" != "" && -f ${CONFIG_OVERRIDE} ]] || CONFIG_OVERRIDE=""


# Read merged config JSON files
declare CONFIG_NAME=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.CONFIG_NAME')
declare SITE_HOSTNAME=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.SITE_HOSTNAME')

declare ENV_ROOT_DIR=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.ENV_ROOT_DIR')
declare MAGENTO_ROOT_DIR=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.MAGENTO_ROOT_DIR')
declare SITE_ROOT_DIR=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.SITE_ROOT_DIR')

declare MAGENTO_COMPOSER_PROJECT=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.MAGENTO_COMPOSER_PROJECT')
declare MAGENTO_REL_VER=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.MAGENTO_REL_VER')

declare REDIS_OBJ_HOST=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.REDIS_OBJ_HOST')
declare REDIS_OBJ_PORT=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.REDIS_OBJ_PORT')
declare REDIS_OBJ_DB=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.REDIS_OBJ_DB')
declare REDIS_SES_HOST=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.REDIS_SES_HOST')
declare REDIS_SES_PORT=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.REDIS_SES_PORT')
declare REDIS_SES_DB=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.REDIS_SES_DB')
declare REDIS_FPC_HOST=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.REDIS_FPC_HOST')
declare REDIS_FPC_PORT=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.REDIS_FPC_PORT')
declare REDIS_FPC_DB=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.REDIS_FPC_DB')

declare VARNISH_HOST=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.VARNISH_HOST')
declare VARNISH_PORT=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.VARNISH_PORT')

declare SEARCH_ENGINE=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.SEARCH_ENGINE')
declare ELASTIC_HOST=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.ELASTIC_HOST')
declare ELASTIC_PORT=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.ELASTIC_PORT')
declare ELASTIC_ENABLE_AUTH=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.ELASTIC_ENABLE_AUTH')
declare ELASTIC_USERNAME=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.ELASTIC_USERNAME')
declare ELASTIC_PASSWORD=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.ELASTIC_PASSWORD')

declare SHOULD_SETUP_SAMPLE_DATA=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.SHOULD_SETUP_SAMPLE_DATA')
declare SHOULD_RUN_CUSTOM_SCRIPT=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.SHOULD_RUN_CUSTOM_SCRIPT')


# Dynamic Variables
COMPOSER_AUTH_USER=$(composer config -g http-basic.repo.magento.com | jq -r '.username')
COMPOSER_AUTH_PASS=$(composer config -g http-basic.repo.magento.com | jq -r '.password')

DB_HOST=$(echo $(grep "^\s*host " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))
DB_USER=$(echo $(grep "^\s*user " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))
DB_PASS=$(echo $(grep "^\s*password " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))
DB_NAME=$(echo $(grep "^\s*database " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))

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
# Moving to Magento Install Directory
echo "----: Move to Magento Install Directory ${MAGENTO_ROOT_DIR}"
cd ${MAGENTO_ROOT_DIR}

# Deploy install files
composer config -g http-basic.repo.magento.com ${COMPOSER_AUTH_USER} ${COMPOSER_AUTH_PASS}
echo "----: Creating composer project"
composer create-project \
  --repository-url https://repo.magento.com/ ${MAGENTO_COMPOSER_PROJECT} ${MAGENTO_ROOT_DIR} ${MAGENTO_REL_VER} \
  -s stable \
  --no-interaction \
  --prefer-dist \
  --no-dev
echo
composer config -a http-basic.repo.magento.com ${COMPOSER_AUTH_USER} ${COMPOSER_AUTH_PASS}
chmod +x bin/magento

# Conditionally install sample data
if [[ "$SHOULD_SETUP_SAMPLE_DATA" == "true" ]]; then
  echo "----: Including Magento Sample Data"
  php -dmemory_limit=2048M bin/magento sampledata:deploy
fi


# Run installation
echo "----: Magento setup:install"
MAGENTO_INSTALL_OPTIONS=$(cat <<SHELL_COMMAND
  --backend-frontname=${BACKEND_FRONTNAME} \
  --admin-user=${ADMIN_USER} \
  --admin-firstname=${ADMIN_FIRST} \
  --admin-lastname=${ADMIN_LAST} \
  --admin-email=${ADMIN_EMAIL} \
  --admin-password=${ADMIN_PASS} \
  --db-host=${DB_HOST} \
  --db-user=${DB_USER} \
  --db-password=${DB_PASS} \
  --db-name=${DB_NAME} 
SHELL_COMMAND
)

if [[ "${MAGENTO_REL_VER}" == "2.4.0" && "${SEARCH_ENGINE}" != "mysql" ]]; then
  echo "----: Magento setup:install (with elasticsearch)"
MAGENTO_INSTALL_OPTIONS=$(cat <<SHELL_COMMAND
${MAGENTO_INSTALL_OPTIONS} \
  --search-engine=${SEARCH_ENGINE} \
  --elasticsearch-host=${ELASTIC_HOST} \
  --elasticsearch-port=${ELASTIC_PORT} \
  --elasticsearch-enable-auth=${ELASTIC_ENABLE_AUTH} \
  --elasticsearch-username=${ELASTIC_USERNAME} \
  --elasticsearch-password=${ELASTIC_PASSWORD} 
SHELL_COMMAND
)
fi

MAGENTO_INSTALL_OPTIONS=$(cat <<SHELL_COMMAND
${MAGENTO_INSTALL_OPTIONS} \
  --session-save=redis \
  --session-save-redis-host=${REDIS_SES_HOST} \
  --session-save-redis-port=${REDIS_SES_PORT} \
  --session-save-redis-db=${REDIS_SES_DB} \
  --cache-backend=redis \
  --cache-backend-redis-server=${REDIS_OBJ_HOST} \
  --cache-backend-redis-port=${REDIS_OBJ_PORT} \
  --cache-backend-redis-db=${REDIS_OBJ_DB} \
  --page-cache=redis \
  --page-cache-redis-server=${REDIS_FPC_HOST} \
  --page-cache-redis-port=${REDIS_FPC_PORT} \
  --page-cache-redis-db=${REDIS_FPC_DB} \
  --http-cache-hosts=${VARNISH_HOST}:${VARNISH_PORT} \
  --magento-init-params=MAGE_MODE=production
SHELL_COMMAND
)

# Display command
echo "bin/magento setup:install ${MAGENTO_INSTALL_OPTIONS}"
# Execute bin/magento setup:install
bin/magento setup:install ${MAGENTO_INSTALL_OPTIONS}

# Configure Magento
echo "----: Magento Configuration Settings"
bin/magento config:set --lock-env web/seo/use_rewrites 1
bin/magento config:set --lock-env web/secure/use_in_frontend 1
bin/magento config:set --lock-env web/secure/use_in_adminhtml 1

bin/magento config:set --lock-env web/unsecure/base_url ${BASE_URL}/
bin/magento config:set --lock-env web/secure/base_url ${BASE_URL}/
# bin/magento config:set --lock-env web/unsecure/base_static_url ${BASE_URL}/static/
# bin/magento config:set --lock-env web/secure/base_static_url ${BASE_URL}/static/
# bin/magento config:set --lock-env web/unsecure/base_media_url ${BASE_URL}/media/
# bin/magento config:set --lock-env web/secure/base_media_url ${BASE_URL}/media/

bin/magento config:set --lock-env system/full_page_cache/caching_application 2
bin/magento config:set --lock-env system/full_page_cache/ttl 604800

if [[ "${MAGENTO_REL_VER}" != "2.4.0" && "${SEARCH_ENGINE}" != "mysql" ]]; then
  echo "----: Magento Configuration Settings (elasticsearch)"
  bin/magento config:set --lock-env catalog/search/engine ${SEARCH_ENGINE}
  bin/magento config:set --lock-env catalog/search/${SEARCH_ENGINE}_server_hostname {ELASTIC_HOST}
  bin/magento config:set --lock-env catalog/search/${SEARCH_ENGINE}_server_port ${ELASTIC_PORT}
  bin/magento config:set --lock-env catalog/search/${SEARCH_ENGINE}_enable_auth ${ELASTIC_ENABLE_AUTH}
  bin/magento config:set --lock-env catalog/search/${SEARCH_ENGINE}_username ${ELASTIC_USERNAME}
  bin/magento config:set --lock-env catalog/search/${SEARCH_ENGINE}_password ${ELASTIC_PASSWORD}
fi

bin/magento config:set --lock-env dev/front_end_development_workflow/type server_side_compilation
bin/magento config:set --lock-env dev/template/allow_symlink 0
bin/magento config:set --lock-env dev/template/minify_html 0
bin/magento config:set --lock-env dev/js/merge_files 0
bin/magento config:set --lock-env dev/js/minify_files 0
bin/magento config:set --lock-env dev/js/enable_js_bundling 0
bin/magento config:set --lock-env dev/css/merge_css_files 0
bin/magento config:set --lock-env dev/css/minify_files 0
bin/magento config:set --lock-env dev/static/sign 1
bin/magento config:set --lock-env admin/security/session_lifetime 28800

bin/magento indexer:set-mode schedule

bin/magento app:config:import
bin/magento cache:enable
bin/magento cache:flush
echo "----: Magento Deployment Mode"
bin/magento deploy:mode:set production
bin/magento cache:flush



# Create SymLink for site root
echo "----: Creating Site Root Symlink to Magento Root"
ln -s ${MAGENTO_ROOT_DIR} ${SITE_ROOT_DIR}

# Save admin credentials as indicator that script completed successfully
echo "----: Saving Magento Credentials"
ADMIN_CREDENTIALS=$(cat <<CONTENTS_HEREDOC
{
  "base_url": "${BASE_URL}",
  "admin_url": "${BASE_URL}/${BACKEND_FRONTNAME}",
  "admin_user": "${ADMIN_USER}",
  "admin_pass": "${ADMIN_PASS}"
}
CONTENTS_HEREDOC
)
echo "${ADMIN_CREDENTIALS}" > ${ENV_ROOT_DIR}/magento_admin_credentials.json

cat ${ENV_ROOT_DIR}/magento_admin_credentials.json | jq .

# Custom script
if [[ "${SHOULD_RUN_CUSTOM_SCRIPT}" == "true" ]]; then
  # CONFIG_NAME
  # SHOULD_RUN_CUSTOM_SCRIPT
  echo "----: Execute custom config script (custom_script_${CONFIG_NAME}.sh)"
  # Move execution to realpath of script
  cd $(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
  custom_script_${CONFIG_NAME}.sh
fi

echo "----: Magento Install Finished"
