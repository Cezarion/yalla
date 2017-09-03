#!/usr/bin/env bash

# Exit immediately on error
set -e

_dv_install_actions(){
    if [[ $DOCKER_STACK == *"sql"* ]]; then
      _create_user_and_database
    else
        _error "This script does not yet support the import or creation of non sql databases.\\r
        @TODO : Create this scripts for pgsql or mongodb\\r
        Mailto: mathias.gorenflot@fabernovel.com"
    fi
}

_dv_create_user_and_database() {

    if [ ! -d "${LOCAL_DATABASE_PATH}" ]; then
      _info "The path ${LOCAL_DATABASE_PATH} does not exist, we create it";
      mkdir -pv $LOCAL_DATABASE_PATH;
      ls -la $LOCAL_DATABASE_PATH | grep 'databases';
    fi

    _info "\nCreate user, database and add privileges"

    # Generating the sql script that will create the user and the database.
    #if [ ! -f "${LOCAL_DATABASE_PATH}/create_user_and_database.sql" ]; then
        echo -e "\
        CREATE DATABASE IF NOT EXISTS \`$DB_DEV_NAME\`;\n\
        CREATE USER IF NOT EXISTS '$DB_DEV_USER'@'127.0.0.1' IDENTIFIED BY '$DB_DEV_PASS';\n\
        GRANT ALL PRIVILEGES ON \`$DB_DEV_NAME\`. * TO '$DB_DEV_USER'@'127.0.0.1';\n\
        FLUSH PRIVILEGES;" > "${LOCAL_DATABASE_PATH}/create_user_and_database.sql";
    #fi

    # Run script
    ./devilbox mysql -f ./databases/create_user_and_database.sql

    _info "\nCheck databases : "
    ./devilbox mysql -i 'SHOW DATABASES;' | grep $DB_DEV_NAME;

    # Now import an existing database if a file exist
    _import_database
}


_dv_import_database() {
    echo "${LOCAL_DATABASE_PATH}/${DB_DEV_NAME}.sql"
    if [ -f "${LOCAL_DATABASE_PATH}/${DB_DEV_NAME}.sql" ]; then
        _info "\nImport database ${DB_DEV_NAME}"

        # Run script
        ./devilbox mysql -d $DB_DEV_NAME -f "./databases/${DB_DEV_NAME}.sql"
    fi
}
