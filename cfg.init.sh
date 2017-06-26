#!/usr/bin/env bash

# make env variables available for shell sub-scripts
set -a

# The owner of the Magento file system:
#   * Must have full control (read/write/execute) of all files and directories.
#   * Must not be the web server user; it should be a different user.
# Web server:
#   * must be a member of the '${LOCAL_GROUP}' group.
LOCAL_OWNER="owner"
LOCAL_GROUP="www-data"

# Magento installation configuration
# complete list see at https://github.com/bragento/magento-core/blob/1.9/install.php
CFG_URL="http://mage2.host.org:8080/"
CFG_DB_HOST="localhost"
CFG_DB_NAME="mage2"
CFG_DB_USER="www"
CFG_DB_PASS="..."
CFG_ADMIN_EMAIL="admin@store.com"
CFG_ADMIN_USERNAME="admin"
CFG_ADMIN_PASSWORD="..."
