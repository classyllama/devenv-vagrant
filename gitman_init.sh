#!/usr/bin/env bash

set -eu

# Move to realpath
cd $(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)

EXPERIMENT_NAME="${PWD##*/}" # Use the current directory name
GITMAN_ROOT="../../"
PERSIST_DIR="${GITMAN_ROOT}" # Use gitman root
GITMAN_LOCATION=$(cd $(pwd -P)/../;echo ${PWD##*/})
SOURCE_DIR_FROM_PERSIST_DIR="${GITMAN_LOCATION}/${EXPERIMENT_NAME}"

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
[[ -f persistent/devenv_vars.config.yml ]] || cp provisioning/devenv_vars.config.yml.sample persistent/devenv_vars.config.yml
[[ -f persistent/mutagen.yml ]] || cp mutagen.yml.sample persistent/mutagen.yml
[[ -f persistent/devenv_playbook.config.yml ]] || cp provisioning/devenv_playbook.config.yml.sample persistent/devenv_playbook.config.yml
[[ -f persistent/README.md ]] || cp README.md.project.sample persistent/README.md
[[ -f persistent/ansible.cfg ]] || cp provisioning/ansible.cfg.sample persistent/ansible.cfg

# Create symlinks in source to persistent files
[[ -L provisioning/devenv_vars.config.yml ]] || ln -s ../persistent/devenv_vars.config.yml provisioning/devenv_vars.config.yml
