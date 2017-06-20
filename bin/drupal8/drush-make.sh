#!/bin/bash
SRC=$(cd $(dirname "$0"); pwd)

. "${SRC}/lib/include.sh"

    info 'Enable maintenance mode'
    $DRUSH sset system.maintenance_mode 1;

    echo "run drush core make"
    if [ ! -d "$REPOSITORY/htdocs" ]; then
        info "The path ${REPOSITORY} does not exist"
        error 'You need to run create_profile() in first'
        $DRUSH sset system.maintenance_mode 0;
        exit 1;
    fi

    cd $REPOSITORY/htdocs
    $DRUSH make ../core.make.yml -y
    echo "$(tput setaf 2)[ok]$(tput sgr0) Core project updated"

    echo "run drush make"
    PROFILE=$WEBROOT/profiles/fabernovel

    if [ ! -d "$PROFILE" ]; then
        info "The path ${PROFILE} does not exist"
        error 'You need to run create_profile() in first'
        $DRUSH sset system.maintenance_mode 0;
        exit 1;
    fi

    cd $PROFILE
    $DRUSH -y make --cache-duration-releasexml=300 --concurrency=8 --no-core --contrib-destination=. contrib.make.yml . --lock=project.lock
    echo "$(tput setaf 2)[ok]$(tput sgr0) Contrib module updated"

    echo "run drush updb"
    $DRUSH -y updb
    $DRUSH sset system.maintenance_mode 0;
    echo "$(tput setaf 2)[ok]$(tput sgr0) Done !"
