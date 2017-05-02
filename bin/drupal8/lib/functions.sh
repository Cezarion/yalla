#!/bin/bash

#
# Install core if it's not
#

install_core () {
    echo "install_core()"
    if [ ! -d "$WEBROOT" ]; then
      # Run drush make for installing site
      $DRUSH make $REPOSITORY/core.make.yml $REPOSITORY/htdocs -y
      echo "$(tput setaf 2)[ok]$(tput sgr0) Install core project"
    fi
}

#
# Create profiles directory
# usage create_profiles profileName
#

create_profile(){
    echo "create_profile()"
    if [ ! -d "$WEBROOT" ]; then
      info "The path ${WEBROOT} does not exist"
      error 'You need to run install_core() in first'
      exit 1;
    fi

    if [ ! -d "$WEBROOT/profiles/${1}" ]; then
        mkdir -p $WEBROOT/profiles/${1}/{modules,themes,libraries}
        cd $WEBROOT/profiles/${1}
        echo "$(tput setaf 2)[ok]$(tput sgr0) Profile directory created"

        # Create symmlink profile file
        ln -s $REPOSITORY/src/${1}/contrib.make.yml
        ln -s $REPOSITORY/src/${1}/${1}.info.yml
        ln -s $REPOSITORY/src/${1}/${1}.install
        ln -s $REPOSITORY/src/${1}/${1}.profile
        ln -s $REPOSITORY/src/${1}/config
        echo "$(tput setaf 2)[ok]$(tput sgr0) Profile's file symlink"
    fi

    # Create symlink to profile folders
    cd $WEBROOT/profiles/${1}
    mkdir includes
    for i in $(ls -d $REPOSITORY/src/${1}/*/); do
        NAME=$(basename $i)
        if [[ -d "$REPOSITORY/src/${1}/$NAME/custom" && ! -d "$WEBROOT/profiles/${1}/$NAME/custom" ]]; then
            cd $WEBROOT/profiles/${1}/$NAME
            ln -s $REPOSITORY/src/${1}/$NAME/custom
            info "Symlink from ${NAME} created to ${WEBROOT}/profiles/${1}/${NAME}/custom"
        else
            if [[ -d "$REPOSITORY/src/$NAME" && ! -d "$WEBROOT/profiles/${1}/$NAME" ]]; then
                ln -s $REPOSITORY/src/$NAME
                info "Symlink from ${NAME} created to ${WEBROOT}/profiles/${1}/${NAME}"
            fi
        fi
        cd $WEBROOT/profiles/${1}
    done

    echo "$(tput setaf 2)[ok]$(tput sgr0) Profile's folders symlinks"

    cd "${WEBROOT}/sites/default/"
    ln -s "${SHARED}/files" files
}

#
# Install contrib module
# usage : install_contrib profileName
#

install_contrib(){
    echo "install_contrib()"
    PROFILE=$WEBROOT/profiles/${1}

    if [ ! -d "$PROFILE" ]; then
        info "The path ${PROFILE} does not exist"
        error 'You need to run create_profile() in first'
        exit 1;
    fi
    cd $PROFILE
    $DRUSH -y make --cache-duration-releasexml=300 --concurrency=8 --no-core --contrib-destination=. contrib.make.yml . --lock=project.lock
    echo "$(tput setaf 2)[ok]$(tput sgr0) Contrib module installed"

    # @todo:
    cd $WEBROOT
    echo "Run composer for address module"
    composer config repositories.drupal composer https://packages.drupal.org/8
    composer require "drupal/address ~1.0"
}

#
# Set settings
#
install_settings(){
    echo "install_settings()"
    cd $ROOT
    mkdir -p $WEBROOT/sites/default/
    if [ ! -f "${WEBROOT}/sites/default/settings.php" ]; then
        ln -s $REPOSITORY/settings.php $WEBROOT/sites/default/settings.php
    else
        info "Main settings are already sets";
    fi

    if [ -f "$SHARED/settings.local.php" ]; then
        info "Settings are already pasted";
    else
        if [ $1 = 'dev' ]; then
            cp $REPOSITORY/dev.settings.local.php $SHARED/settings.local.php;
        else
            if [ $1 = 'staging' ] || [ $1 = 'preprod' ]; then
                cp $REPOSITORY/staging.settings.local.php $SHARED/settings.local.php;
            else
                cp $REPOSITORY/prod.settings.local.php $SHARED/settings.local.php;
            fi
        fi
    fi

    if [ ! -f "${WEBROOT}/sites/default/settings.local.php" ]
        then
            ln -s $SHARED/settings.local.php $WEBROOT/sites/default/settings.local.php

            read -p "Database name: " database_name
            read -p "Database username: " database_username
            read -ers -p "Database password: " database_password
            echo ""

            echo "\$databases['default']['default'] = array (" >> $SHARED/settings.local.php
            echo "    'database' => '${database_name}'," >> $SHARED/settings.local.php
            echo "    'username' => '${database_username}'," >> $SHARED/settings.local.php
            echo "    'password' => '${database_password}'," >> $SHARED/settings.local.php
            echo "    'prefix' => ''," >> $SHARED/settings.local.php
            echo "    'host' => 'localhost'," >> $SHARED/settings.local.php
            echo "    'port' => '3306'," >> $SHARED/settings.local.php
            echo "    'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql'," >> $SHARED/settings.local.php
            echo "    'driver' => 'mysql'," >> $SHARED/settings.local.php
            echo ");" >> $SHARED/settings.local.php
            echo "\$settings['install_profile'] = '${1}';" >> $SHARED/settings.local.php

            echo "$(tput setaf 2)[ok]$(tput sgr0) Settings are sets"
        else
            info "Database is already configure. If you want to udpate edit ${SHARED}/settings.local.php"
            exit;
    fi
}


#
# Run all install tasks
#

install_actions(){
    echo "-- install_actions()"

    ENV=$1
    case $ENV in
        prod) ;;
        preprod) ;;
        staging) ;;
        dev) ;;
        *)  bad_exit "You have to specify an correct environment (dev|staging|prod).";;
    esac

    # Create required repositories (tmp and private)
    info 'Create tmp, private and files directories'
    mkdir -p "${ROOT}/tmp" && chmod 777 $_;
    mkdir -p "${ROOT}/private" && chmod 777 $_;
    mkdir -p "${ROOT}/shared/files" && chmod 777 $_;

    # Depends on drush version (no release for drush 8.x
    # @todo: get a standalone drush version do not use drush_language
    #    DRUSH_LANGUAGE=$(drush help | grep language)
    #    if [[ -z "${DRUSH_LANGUAGE// }" ]]; then
    #            notice 'Download drush language tools'
    #            drush dl -y drush_language;
    #    fi

    PROFILE_NAME=$2
    if [ -z "$PROFILE_NAME" ]; then
        bad_exit "You have to specify a profile.";
    fi

    if [ ! -f "${REPOSITORY}/src/${PROFILE_NAME}/${PROFILE_NAME}.profile" ]; then
        bad_exit "You have to specify a valid profile (${REPOSITORY}/src/${PROFILE_NAME}/${PROFILE_NAME}.profile not found).";
    fi

    install_core

    install_settings $ENV


    create_profile $PROFILE_NAME
    install_contrib $PROFILE_NAME

    cd $ROOT
    echo "$DRUSH --root=$WEBROOT si $PROFILE_NAME --account-mail=$EMAIL --account-name=code --locale=fr --debug"
    $DRUSH --root=$WEBROOT si $PROFILE_NAME --account-mail=$EMAIL --account-name=code --locale=fr --debug

    # l10n-update
    cd $WEBROOT
    $DRUSH cr
    #$DRUSH l10n-update-refresh && $DRUSH l10n-update --languages=fr

    cd $ROOT
}

# Action to run to execute and apply update
# It can be useful to enable specific modules for instance.
# usage : postpostdeploy_actions ENV (dev|staging|preprod|prod) PROFILE_NAME URI
#
deploy_actions(){
    echo "deploy_actions()"

    ENV=$1
    PROFILE_NAME=$2
    URI=$3
    # Make drush a variable to use the one shipped with the repository.
    #DRUSH="drush -y --root=$WEBROOT"

    # Put the site offline for visitors.
    info 'Enable maintenance mode'
    $DRUSH sset system.maintenance_mode 1;

    #Patch
    # @ref : https://www.drupal.org/node/1551132
#    patch -p1 -N --dry-run < patch/1551132-drupal-install-schema-shared-tables-69-D7.patch> /dev/null

    #If the patch has not been applied then the $? which is the exit status
    #for last command would have a success status code = 0
#    if [ $? -eq 0 ];
#    then
#        #apply the patch
#        echo 'Apply patches'
#        patch -p1 < patch/1551132-drupal-install-schema-shared-tables-69-D7.patch
#    else
#        echo 'Already patched'
#    fi


    notice 'Run drush make'
    install_contrib $PROFILE_NAME
    cd $ROOT

    # Rebuild the registry in case some modules have been moved.
    notice 'Rebuild caches'
    $DRUSH cr

    # Run the database updates.
    notice 'Run updb'
    $DRUSH updb -y

    # Revert the features.
    #notice 'Revert features'
    #$DRUSH cr
    #$DRUSH fra -y

    # Import database (should be remove)
    # notice 'Import database'
    # $DRUSH sql-cli < app/conf/_dump_installation.sql

    # Import config
    notice 'Import configuration'
    $DRUSH -y config-import

    # Refresh translations
    #notice 'Refresh translations'
    #$DRUSH language-refresh

    # Run the potential actions to do post deployment.
    notice 'Run post deploy actions'
    postdeploy_actions $ENV $URI

    # Rebuild permission
    notice 'Rebuild drupal permission'
    $DRUSH php-eval 'node_access_rebuild();'

    # Clear the caches.
    notice 'Rebuild caches'
    $DRUSH cr

    # Put robots.txt file
    notice 'Update robots.txt'
    if [ -f "$SHARED/robots.txt" ]; then
        rm $WEBROOT/robots.txt
        cp $SHARED/robots.txt $WEBROOT/robots.txt
    fi

    # Put robots.txt file
    notice 'Update htaccess'
    if [ -f "$SHARED/.htaccess" ]; then
        rm $WEBROOT/.htaccess
        cp $SHARED/.htaccess $WEBROOT/.htaccess
    fi

    # Put the site back online.
    info 'Disable maintenance mode'
    $DRUSH sset system.maintenance_mode 0;

    cd $ROOT

    # Clear the caches.
    notice 'Rebuild caches'
    $DRUSH cr
}

# Action to run after the main and shared deployment actions.
# It can be useful to enable specific modules for instance.
# usage : postpostdeploy_actions ENV (dev|staging|preprod|prod) URI
postdeploy_actions() {
    echo "postdeploy_actions()"
    URI=$2

    case $1 in
        dev)
            # Enable UIs.
            $DRUSH en -y field_ui views_ui devel;
            # Enable proxy files
            $DRUSH en -y stage_file_proxy;
            $DRUSH cset stage_file_proxy.settings origin "$URI"
            # Connect.
            #$DRUSH uli
        ;;
        staging)
            # Enable devtools
            $DRUSH en -y field_ui views_ui uikit;

            # Enable proxy files
            $DRUSH en -y stage_file_proxy;
            $DRUSH cset stage_file_proxy.settings origin "$URI"

            # Enable UIs.
            $DRUSH en -y dblog;
            $DRUSH en -y views_ui;

            $DRUSH pm-uninstall -y syslog;
            $DRUSH pm-uninstall -y devel;
            $DRUSH pm-uninstall -y devel_generate;

            # Disable page caching
            $DRUSH pm-uninstall -y page_cache;
            $DRUSH pm-uninstall -y dynamic_page_cache;

            # Enable proxy files
            $DRUSH en -y stage_file_proxy;
            $DRUSH cset stage_file_proxy.settings origin "$URI"
        ;;
        preprod)
            # Enable UIs.
            $DRUSH pm-uninstall -y dblog;
            $DRUSH pm-uninstall -y devel;
            $DRUSH pm-uninstall -y devel_generate;
            $DRUSH pm-uninstall -y views_ui;

            $DRUSH en -y syslog;

            # Enable page caching
            $DRUSH en -y page_cache;
            $DRUSH en -y dynamic_page_cache;

            # Enable proxy files
            $DRUSH en -y stage_file_proxy;
            $DRUSH cset stage_file_proxy.settings origin "$URI"
        ;;
        prod)
            # Enable UIs.
            $DRUSH pm-uninstall -y dblog;
            $DRUSH pm-uninstall -y devel;
            $DRUSH pm-uninstall -y devel_generate;
            $DRUSH pm-uninstall -y views_ui;
            $DRUSH pm-uninstall -y masquerade;

            $DRUSH en -y syslog;

            # Enable page caching
            $DRUSH en -y page_cache;
            $DRUSH en -y dynamic_page_cache;

            # Disable proxy files
            $DRUSH pm-uninstall -y stage_file_proxy;

            $DRUSH en -y syslog;
        ;;
        *)
            echo "Unknown environment: $2. Please check your name."
            exit 1;
  esac
}

# Action to run after the main and shared deployment actions.
# It can be useful to enable specific modules for instance.
# usage : postpostdeploy_actions ENV (dev|staging|preprod|prod) URI
assets_actions() {
    echo "assets_actions()"
    $DRUSH sset system.maintenance_mode 1;
    # Retrieve path
    cd "${THEME_PATH}"
    notice 'Run assets build actions'
    npm install
    case $1 in
        dev)
            gulp
        ;;
        staging|preprod|prod)
            gulp --production
        ;;
    *)
      echo "Unknown environment: $2. Please check your name."
      exit 1;
  esac
  $DRUSH sset system.maintenance_mode 0;
}
