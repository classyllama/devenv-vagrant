#!/usr/bin/env bash

# This script is called by Vagrant via before:up trigger. Please see Vagrantfile.

REQCOMMIT=`grep 'rev:' gitman.yml |tail -n 1 |awk '{ print $2 }'`
REQTAG=`grep 'rev:' gitman.yml |head -n 1 |awk '{ print $2 }'`
ISLOCKED=`grep 'sources_locked' gitman.yml |wc -l`
RED='\033[0;31m'
NC='\033[0m' # No Color

if [[ ${ISLOCKED} -eq 0 ]]; then
    echo -e "${RED}DevEnv version isn't locked, please run 'gitman lock' to fix the current revision${NC}"
else
    cd source && ACTCOMMIT=`git log -n 1 --pretty=format:"%H"` && cd ..

    if [[ "${ACTCOMMIT}" != "${REQCOMMIT}"  ]]; then
        echo -e "${RED}Requested DevEnv revision is ${REQTAG}, commit ID: ${REQCOMMIT}${NC}"
        echo -e "${RED}Installed DevEnv revision is ${ACTCOMMIT}${NC}"
        echo -e "${RED}Please update the sources by running 'gitman update; gitman lock' or revert gitman.yml to the currently installed version${NC}"
    fi
fi
exit 0;
