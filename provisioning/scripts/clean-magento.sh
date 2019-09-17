#!/usr/bin/env bash

set -eu



# Variables
MAGENTO_ROOT_DIR="/var/www/html/magento"
SITE_ROOT_DIR="/var/www/html/project/sitecode"
ENV_ROOT_DIR="/var/www/html"

DB_NAME=$(echo $(grep "^database " ~/.my.cnf | cut -d= -f2 | perl -p -e 's/^\s*(.*?)\s*$/$1/'))

echo "show databases;" | mysql -D information_schema --default-character-set=utf8
echo "drop database if exists ${DB_NAME};" | mysql -D information_schema --default-character-set=utf8
echo "create database if not exists ${DB_NAME};" | mysql -D information_schema --default-character-set=utf8

rm -rf ${MAGENTO_ROOT_DIR}
rm -f ${SITE_ROOT_DIR}
rm -f ${ENV_ROOT_DIR}/magento_admin_credentials.json

redis-cli -p 6379 flushall
redis-cli -p 6380 flushall

