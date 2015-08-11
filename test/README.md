# Development and Testing

Development and testing environment is deployed into this location.

## Installation

    $ git clone git@github.com:praxigento/mage_ext_login_as.git
    $ cd ./mage_ext_login_as/test/
    $ cp templates.json.init templates.json
    $ nano templates.json   # you need update your instance configuration here
    {
      "vars": {
        "LOCAL_ROOT": "/home/alex/work/github/mage_ext_login_as/test",
        "LOCAL_OWNER": "alex",
        "LOCAL_GROUP": "www-data",
        "CFG_DB_HOST": "localhost",
        "CFG_DB_NAME": "mage_loginas",
        "CFG_DB_USER": "mage_loginas",
        "CFG_DB_PASS": "JvZkBKVXEP2gSvSDrGje",
        "CFG_DB_PREFIX": "",
        "CFG_LICENSE_AGREEMENT_ACCEPTED": "yes",
        "CFG_LOCALE": "en_US",
        "CFG_TIMEZONE": "America/Los_Angeles",
        "CFG_DEFAULT_CURRENCY": "USD",
        "CFG_URL": "http://loginas.mage.local.prxgt.com:50080/",
        "CFG_USE_REWRITES": "yes",
        "CFG_USE_SECURE": "no",
        "CFG_SECURE_BASE_URL": "",
        "CFG_ADMIN_FRONTNAME": "admin",
        "CFG_USE_SECURE_ADMIN": "no",
        "CFG_ADMIN_LASTNAME": "Admin",
        "CFG_ADMIN_FIRSTNAME": "Store",
        "CFG_ADMIN_EMAIL": "admin@store.com",
        "CFG_ADMIN_USERNAME": "admin",
        "CFG_ADMIN_PASSWORD": "eENsSX0FfV1v5nmQG5ld",
        "CFG_SKIP_URL_VALIDATION": "yes"
      }
    }
    $ composer install
    $ ./vendor/bin/composerCommandIntegrator.php magento-module-deploy
    $ sh ./bin/deploy/post_install.sh


