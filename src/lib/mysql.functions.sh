#!/usr/bin/env bash

# Exit immediately on error
set -e
trap 'echo "Aborting due to errexit on line $LINENO. file $(cd $(dirname "$0"); pwd)/$(basename "$0"). Exit code: $?" >&2' ERR

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
    local mysql_status=$(docker inspect -f {{.State.Running}} devilbox_mysql_1)

    if [ $mysql_status != "true" ]; then
        _notice "Start docker stack"
        yalla dr up
    else
        _success "Docker stack already Running"
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


    _info "Create user, database and add privileges"

    # Generating the sql script that will create the user and the database.
    #if [ ! -f "${LOCAL_BACKUP_PATH}/create_user_and_database.sql" ]; then
        echo -e "\
        CREATE DATABASE IF NOT EXISTS \`$DB_DEV_DATABASE_NAME\`;\n\
        CREATE USER IF NOT EXISTS '$DB_DEV_USER'@'%' IDENTIFIED BY '$DB_DEV_PASS';\n\
        GRANT ALL PRIVILEGES ON \`$DB_DEV_DATABASE_NAME\`. * TO '$DB_DEV_USER'@'%';\n\
        FLUSH PRIVILEGES;" > "${LOCAL_BACKUP_PATH}/create_user_and_database.sql";
    #fi

    # Run script
    yalla mysql -f "${LOCAL_BACKUP_PATH}/create_user_and_database.sql" #./backup/create_user_and_database.sql

    _info "Check databases : "
    yalla mysql -i 'SHOW DATABASES;' | grep $DB_DEV_DATABASE_NAME;

    # Now import an existing database if a file exist
    #_import_database
}


_mysql_import_database() {
    echo "${LOCAL_BACKUP_PATH}/${DB_DEV_DATABASE_NAME}.sql"
    if [ -f "${LOCAL_BACKUP_PATH}/${DB_DEV_DATABASE_NAME}.sql" ]; then
        _info "Import database ${DB_DEV_DATABASE_NAME}"

        # Run script
        yalla mysql -d $DB_DEV_DATABASE_NAME -f "./databases/${DB_DEV_DATABASE_NAME}.sql"
    fi
}
