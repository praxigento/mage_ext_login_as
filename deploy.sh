#!/usr/bin/env bash
## *************************************************************************
#   Deploy Magento based application.
## *************************************************************************

# current directory where from script was launched (to return to in the end)
DIR_CUR="$PWD"
# Root directory (relative to the current shell script, not to the execution point)
DIR_ROOT="$( cd "$( dirname "$0" )" && pwd )"

# Available deployment modes
MODE=work

# check configuration file exists and load deployment config (db connection, Magento installation opts, etc.).
FILE_CFG=${DIR_ROOT}/cfg.${MODE}.sh
if [ -f "${FILE_CFG}" ]
then
    echo "There is deployment configuration in '${FILE_CFG}'."
    . ${FILE_CFG}
    echo "Deployment configuration is loaded from '${FILE_CFG}'."
else
    echo "There is no expected deployment configuration in '${FILE_CFG}'. Aborting..."
    cd ${DIR_CUR}
    exit 255
fi
echo "Deployment is started in the '${MODE}' mode."

# Folders shortcuts
DIR_SRC=${DIR_ROOT}/src           # folder with sources
DIR_DEPLOY=${DIR_ROOT}/deploy     # home folder for deployment
DIR_HOME=${DIR_ROOT}/${MODE}      # home folder for deployment
DIR_MAGE=${DIR_HOME}/htdocs       # Magento installation
DIR_BIN=${DIR_HOME}/bin           # shell scripts root

# (re)create root folder for Magento
if [ -d "${DIR_MAGE}" ]
then
    rm -fr ${DIR_HOME}      # remove deployment dir including Magento root dir
    mkdir -p ${DIR_MAGE}    # create Magento dir including deployment dir
else
    mkdir -p ${DIR_MAGE}
fi

echo "Magento will be installed into the '${DIR_MAGE}' folder."

# prepare environment to deploy application using Composer
COMP_DESC=${DIR_HOME}/composer.json
# default sources
COMP_DESC_SRC=${DIR_DEPLOY}/composer/work.json


echo "Prepare deployment environment:"
echo "  ${COMP_DESC_SRC} => ${COMP_DESC}"
cp ${COMP_DESC_SRC} ${COMP_DESC}


echo "Start composer installation based on '${COMP_DESC_SRC}' descriptor."
cd ${DIR_HOME}
composer install    # create magento application using composer description


mysqladmin -f -u"${CFG_DB_USER}" -p"${CFG_DB_PASS}" -h"${CFG_DB_HOST}" drop "${CFG_DB_NAME}"
mysqladmin -f -u"${CFG_DB_USER}" -p"${CFG_DB_PASS}" -h"${CFG_DB_HOST}" create "${CFG_DB_NAME}"

echo "Perform post-installation configuration."
php ${DIR_MAGE}/install.php -- --license_agreement_accepted yes \
--locale en_US \
--timezone UTC \
--default_currency USD \
--db_host ${CFG_DB_HOST} \
--db_name ${CFG_DB_NAME} \
--db_user ${CFG_DB_USER} \
--db_pass ${CFG_DB_PASS} \
--session_save db \
--admin_frontname admin \
--url ${CFG_URL} \
--skip_url_validation yes \
--use_rewrites yes \
--use_secure no \
--secure_base_url ${CFG_URL} \
--use_secure_admin no \
--enable_charts no \
--admin_lastname Store \
--admin_firstname Admin \
--admin_email ${CFG_ADMIN_EMAIL} \
--admin_username ${CFG_ADMIN_USERNAME} \
--admin_password ${CFG_ADMIN_PASSWORD} \


# finalize deployment process
cd ${DIR_CUR}
echo "Deployment is complete."
