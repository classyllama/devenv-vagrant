#!/usr/bin/env bash

set -eu

# Move to realpath
cd $(pwd -P)

EXPERIMENT_NAME="${PWD##*/}" # Use the current directory name
GITMAN_ROOT="../../"
PERSIST_DIR="${GITMAN_ROOT}" # Use gitman root
GITMAN_LOCATION=$(cd $(pwd -P)/../;echo ${PWD##*/})
SOURCE_DIR_FROM_PERSIST_DIR="${GITMAN_LOCATION}/${EXPERIMENT_NAME}"

# Initialize lab directory
#[[ -d ../../${EXPERIMENT_NAME} ]] || mkdir ../../${EXPERIMENT_NAME}

# Link from source directory to persistent directory
[[ -L persistent ]] || ln -s ${PERSIST_DIR} persistent

# Link from persistent directory to source
[[ -L persistent/source ]] || ln -s ${SOURCE_DIR_FROM_PERSIST_DIR} persistent/source

# Create symlinks in persistent to source files
[[ -L persistent/Vagrantfile ]] || ln -s source/Vagrantfile persistent/Vagrantfile

# Copy sample files to persistent directory if they do not exist yet.
[[ -f persistent/.gitignore ]] || cp .gitignore.sample persistent/.gitignore
[[ -f persistent/Vagrantfile.config.rb ]] || cp Vagrantfile.config.rb.sample persistent/Vagrantfile.config.rb
[[ -f persistent/Vagrantfile.local.rb ]] || cp Vagrantfile.local.rb.sample persistent/Vagrantfile.local.rb
