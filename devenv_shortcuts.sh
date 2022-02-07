#!/usr/bin/env bash

set -eu


########################################
## Introduction
########################################
HELP_INFO=$(cat <<'CONTENTS_HEREDOC'
devenv_shortcuts v0.1
Copyright (c) 2020, Matt Johnson (matt.johnson@classyllama.com). All
rights reserved.

Shortcut commands for common devenv actions

Usage: devenv [command] [command_option]
  xdebug [enable|disable]   Enable of disable PHP xDebug extension
  mailhog [enable|disable]  Enable or disable MailHog dev email system
  centos8fix apply          Modify CentOS 8 repositories due to EOL

Example:
  devenv xdebug enable
  devenv xdebug disable
  devenv mailhog enable
  devenv mailhog disable
  devenv centos8fix apply

CONTENTS_HEREDOC
)

if [ ! $# -ge 1 ]; then
  echo "${HELP_INFO}"
  exit;
fi


########################################
## Command Line Options
########################################
declare COMMAND=""
declare COMMAND_OPTION=""
case $1 in
    xdebug)
        COMMAND="xdebug"
        if [ ! $# -ge 2 ] || [[ ! "$2" =~ ^enable|disable|status$ ]]; then
            >&2 echo "Error: Invalid command option given. Valid command options: (enable|disable)"
            echo ""
            echo "${HELP_INFO}"
            exit -1
        fi
        COMMAND_OPTION="$2"
        ;;
    mailhog)
        COMMAND="mailhog"
        if [ ! $# -ge 2 ] || [[ ! "$2" =~ ^enable|disable|status ]]; then
            >&2 echo "Error: Invalid command option given. Valid command options: (enable|disable)"
            echo ""
            echo "${HELP_INFO}"
            exit -1
        fi
        COMMAND_OPTION="$2"
        ;;
    centos8fix)
        COMMAND="centos8fix"
        if [ ! $# -ge 2 ] || [[ ! "$2" =~ ^apply ]]; then
            >&2 echo "Error: Invalid command option given. Valid command option: apply"
            echo ""
            echo "${HELP_INFO}"
            exit -1
        fi
        COMMAND_OPTION="$2"
        ;;
 
    *)
        echo "${HELP_INFO}"
        exit;
        ;;
esac

# Move to realpath of script
cd ./source/

if [[ "${COMMAND}" == "xdebug" ]]; then

  # Change to provisioning directory to run ansible-playbook commands from
  cd ./provisioning/

  if [[ "${COMMAND_OPTION}" == "enable" ]]; then
    ansible-playbook -i ../persistent/inventory/devenv action_xdebug_enable.yml --diff
  elif [[ "${COMMAND_OPTION}" == "disable" ]]; then
    ansible-playbook -i ../persistent/inventory/devenv action_xdebug_disable.yml --diff
  elif [[ "${COMMAND_OPTION}" == "status" ]]; then
    # XDEBUG_STATUS=$(echo "php -m | grep -i xdebug | head -1" | vagrant ssh -c "bash" -- -q)
    INVENTORY_FILE="../persistent/inventory/devenv"
    SSH_HOST=$(cat ${INVENTORY_FILE} | perl -ne 'while(/ansible_host=([^\s]+)/g){print "$1";}')
    SSH_USER=$(cat ${INVENTORY_FILE} | perl -ne 'while(/ansible_user=([^\s]+)/g){print "$1";}')
    XDEBUG_STATUS=$(ssh -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR ${SSH_USER}@${SSH_HOST} "php -m | grep -i xdebug | head -1")
    XDEBUG_STATUS=${XDEBUG_STATUS//[[:space:]]/}
    [[ "${XDEBUG_STATUS}" != "" ]] \
      && echo "xDebug Enabled" \
      || echo "xDebug Disabled"
  fi
elif [[ "${COMMAND}" == "mailhog" ]]; then
  cd ./provisioning/

  if [[ "${COMMAND_OPTION}" == "enable" ]]; then
    ansible-playbook -i ../persistent/inventory/devenv action_mailhog_enable.yml --diff
  elif [[ "${COMMAND_OPTION}" == "disable" ]]; then
    ansible-playbook -i ../persistent/inventory/devenv action_mailhog_disable.yml --diff
  elif [[ "${COMMAND_OPTION}" == "status" ]]; then
    INVENTORY_FILE="../persistent/inventory/devenv"
    SSH_HOST=$(cat ${INVENTORY_FILE} | perl -ne 'while(/ansible_host=([^\s]+)/g){print "$1";}')
    SSH_USER=$(cat ${INVENTORY_FILE} | perl -ne 'while(/ansible_user=([^\s]+)/g){print "$1";}')
    MAILHOG_STATUS=$(ssh -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR ${SSH_USER}@${SSH_HOST} "php -i | grep -i 127.0.0.1:1025 | head -1")
    MAILHOG_STATUS=${XDEBUG_STATUS//[[:space:]]/}
    [[ "${MAILHOG_STATUS}" != "" ]] \
      && echo "MailHog Enabled" \
      || echo "MailHOg Disabled"
  fi
elif [[ "${COMMAND}" == "centos8fix" ]]; then
  cd ./provisioning/

  if [[ "${COMMAND_OPTION}" == "apply" ]]; then
    ansible-playbook -i ../persistent/inventory/devenv centos8eol.yml --diff
  fi
fi
