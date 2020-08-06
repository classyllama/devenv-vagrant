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
  echo "Exampe: uninstall-magento.sh config_stage.json"
  exit;
fi


# Config Files
CONFIG_DEFAULT="config_default.json"
CONFIG_OVERRIDE="${CONFIG_FILE}"
[[ "${CONFIG_OVERRIDE}" != "" && -f ${CONFIG_OVERRIDE} ]] || CONFIG_OVERRIDE=""


# Read merged config JSON files
declare SITE_HOSTNAME=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.SITE_HOSTNAME')

declare ENV_ROOT_DIR=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.ENV_ROOT_DIR')
declare MAGENTO_ROOT_DIR=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.MAGENTO_ROOT_DIR')
declare SITE_ROOT_DIR=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.SITE_ROOT_DIR')

declare REDIS_OBJ_HOST=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.REDIS_OBJ_HOST')
declare REDIS_OBJ_PORT=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.REDIS_OBJ_PORT')
declare REDIS_SES_HOST=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.REDIS_SES_HOST')
declare REDIS_SES_PORT=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.REDIS_SES_PORT')
declare VARNISH_HOST=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.VARNISH_HOST')
declare VARNISH_PORT=$(cat ${CONFIG_DEFAULT} ${CONFIG_OVERRIDE} | jq -s add | jq -r '.VARNISH_PORT')



SITE_ROOT_DIR="${ENV_ROOT_DIR}/${SITE_ROOT_DIR}"

DB_NAME=$(echo $(grep "^database " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))

echo "show databases;" | mysql -D information_schema --default-character-set=utf8
echo "drop database if exists ${DB_NAME};" | mysql -D information_schema --default-character-set=utf8
echo "create database if not exists ${DB_NAME};" | mysql -D information_schema --default-character-set=utf8

rm -rf ${MAGENTO_ROOT_DIR}
rm -f ${SITE_ROOT_DIR}
rm -f ${ENV_ROOT_DIR}/magento_admin_credentials.json

redis-cli -h ${REDIS_OBJ_HOST} -p ${REDIS_OBJ_PORT} flushall
redis-cli -h ${REDIS_SES_HOST} -p ${REDIS_SES_PORT} flushall
