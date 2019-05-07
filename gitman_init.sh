#!/usr/bin/env bash

set -eu

# Move to realpath
cd $(pwd -P)

EXPERIMENT_NAME="${PWD##*/}" # Use the current directory name
PERSIST_DIR="../../${EXPERIMENT_NAME}"
SOURCE_DIR_FROM_PERSIST_DIR="../gitman_sources/${EXPERIMENT_NAME}"

# Initialize lab directory
[[ -d ../../${EXPERIMENT_NAME} ]] || mkdir ../../${EXPERIMENT_NAME}

# Link from source directory to persistent directory
[[ -L persistent ]] || ln -s ${PERSIST_DIR} persistent

# Link from persistent directory to source
[[ -L persistent/source ]] || ln -s ${SOURCE_DIR_FROM_PERSIST_DIR} persistent/source

# Symlink in README
[[ -L persistent/README.md ]] || ln -s source/README.md persistent/README.md
