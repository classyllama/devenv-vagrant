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

Example:
  devenv xdebug enable
  devenv xdebug disable

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
        if [ ! $# -ge 2 ] || [[ ! "$2" =~ ^enable|disable$ ]]; then
            >&2 echo "Error: Invalid command option given. Valid command options: (enable|disable)"
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
  fi
fi
