#!/usr/bin/env bash

# This script is called by Vagrant via after:up trigger. Please see Vagrantfile.

# Get VM domain from inventory and remove ~/.ssh/known_hosts for this domain
if [ -f inventory/devenv ]; then
  VMDOMAIN=`grep 'ansible_host' inventory/devenv |awk {' print $1 '}`
  VMUSER=`grep 'ansible_user' inventory/devenv |awk {' print $3 '} |awk -F '=' {' print $2 '}`

  if [ ! -z ${VMDOMAIN} ] && [ ! -z ${VMUSER} ]; then
    # Checking if key is changed
    SSHOUT=`ssh ${VMUSER}@${VMDOMAIN} date 2>&1`
    IS_CHANGED=$(expr `echo ${SSHOUT} |grep 'HOST IDENTIFICATION HAS CHANGED' |wc -l`)

    if [[ ${IS_CHANGED} != 0 ]]; then
      ssh-keygen -R ${VMDOMAIN}
    fi

  fi

fi

exit 0;
