#!/usr/bin/env bash

# Exit immediately on error
set -e
trap 'echo "Aborting due to errexit on line $LINENO. File $(cd $(dirname "$0"); pwd)/$(basename "$0"). Exit code: $?" >&2' ERR

_mysql_install_actions(){
    if [[ $DOCKER_STACK == *"sql"* ]]; then
      _mysql_create_user_and_database
    else
        _error "This script does not yet support the import or creation of non sql databases.\\r
        @TODO : Create this scripts for pgsql or mongodb\\r
        Mailto: mathias.gorenflot@fabernovel.com"
    fi
}


_mysql_ensure_service_is_started(){
    if [[ -z $(docker ps | grep "devilbox_mysql_1") ]]; then
      _notice "Mysql is not running, start it"
      yalla dr up mysql
    fi
}

_mysql_create_user_and_database() {
    _mysql_ensure_service_is_started

    if [ ! -d "${LOCAL_BACKUP_PATH}" ]; then
      _info "The path ${LOCAL_BACKUP_PATH} does not exist, we create it";
      mkdir -pv $LOCAL_BACKUP_PATH;
      ls -la $LOCAL_BACKUP_PATH | grep 'databases';
    fi

    # Load params if not set
    if [ -z "$DB_DEV_DATABASE_NAME" ]; then
        . yalla.settings
    fi

    # Generating the sql script that will create the user and the database.
    #if [ ! -f "${LOCAL_BACKUP_PATH}/create_user_and_database.sql" ]; then
    echo -e "\
    CREATE DATABASE IF NOT EXISTS \`$DB_DEV_DATABASE_NAME\`;\n\
    CREATE USER IF NOT EXISTS '$DB_DEV_USER'@'%' IDENTIFIED BY '$DB_DEV_PASS';\n\
    GRANT ALL PRIVILEGES ON \`$DB_DEV_DATABASE_NAME\`. * TO '$DB_DEV_USER'@'%';\n\
    FLUSH PRIVILEGES;" > "${LOCAL_BACKUP_PATH}/create_user_and_database.sql";
    #fi

    _info "Create user, database and add privileges"
    # Run script
    yalla mysql -f "${BACKUP_PATH}/create_user_and_database.sql" #./backup/create_user_and_database.sql

    _br
    _info "Check databases : "
    yalla mysql -i 'SHOW DATABASES;' | grep $DB_DEV_DATABASE_NAME;
}


_mysql_import_database() {
    if _ask $(clr_magenta "Do you want to import ax existing dump ?"); then
      read -p "Please specify the dump path (from current project directory) " DB_FILE
      if [ -f "${DB_FILE}" ]; then
          _info "Import ${DB_FILE} into database ${DB_DEV_DATABASE_NAME}"

          # Run script
          yalla mysql -d $DB_DEV_DATABASE_NAME -f "${DB_FILE}"
      else
        _warning "${DB_FILE} not found."
        if _ask "retry"; then
          _mysql_import_database
        else
          exit 0
        fi
      fi
    fi
}
