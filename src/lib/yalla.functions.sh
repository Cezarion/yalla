#!/usr/bin/env bash

#
# @authors Mathias Gorenflot (mathias.gorenflot@fabernovel.com)
# @date    2017-08-29 19:18:09
# @version $Id$
#

# Exit immediately on error
set -e
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR

# Load common vars and functions
for file in $(pwd)/yalla/src/lib/*
do
    FILENAME=$(basename $file)

    if [ "${FILENAME}" != "yalla.functions.sh" ] && [ "${FILENAME}" != "common.sh" ] && [ "${FILENAME}" != "templater.sh" ]
        then
            . $file
    fi
done

###############################################################################
# _install_yalla_bin()
#
# Usage:
#   _install_yalla_bin
#
# Install yalla command in /usr/local/bin
# @todo download script from remote repository
#
_install_yalla_bin(){
    _info "yalla command is not installed. We install it" >&2
    cp './yalla/src/cmd/yalla' /usr/local/bin/
    if [ !-f "${HOME}/.yalla.autocomplete" ]
        then
            cp './yalla/src/cmd/autocomplete.sh' "${HOME}/.yalla.autocomplete"
    fi
    _success 'Check yalla version'
    echo '---------------------------------------'
    yalla -v
    echo '---------------------------------------'
}

###############################################################################
# _yalla_version()
#
# Usage:
#   __yalla_version <local|remote>
#
# get version of a yalla script
#

_yalla_version(){
    local ARGS="${1}"
    local VERSION=

    case $ARGS in
        local | -l)
            VERSION=$(sed -n -e '/YALLA_VERSION/ s/.*\= *//p' /usr/local/bin/yalla)
            ;;
        remote | -r )
            VERSION=$(sed -n -e '/YALLA_VERSION/ s/.*\= *//p' ./yalla/src/cmd/yalla)
            ;;
        * ) printf "Please answer y or n. \n";;
    esac

    echo $VERSION
}



###############################################################################
# _yalla_version()
#
# Usage:
#   __yalla_version <local|remote>
#
# get version of a yalla script
#
_yalla_check_update(){
    local remote_version=$(_yalla_version -r)
    local local_version=$(_yalla_version -l)
    local NEED_UPDATE=0

    printf "Yalla Local version : $local_version\n"
    printf "Yalla Remote version : $remote_version\n"

    if [ $(_version $local_version) -gt $(_version $remote_version) ]; then
      _warning "Remote version is older than local version"
    elif [ $(_version $local_version) -lt $(_version $remote_version) ]; then
      _notice "Local version need update, do you want to run update ?"
      while true; do
        read -p "yes / no ? " yn
            case $yn in
                [Yy]* )
                    _install_yalla_bin
                    break;;
                [Nn]* )
                    exit;
                    break;;
                * ) printf "Please answer y or n. \n";;
            esac
        done
    else
      _info "Version is up to date"
    fi

    _br
}

###############################################################################
# _yalla_settings()
#
# Usage:
#   _yalla_settings
#
# Generate the yalla.settings file
#

function _yalla_settings() {
    _line
    _br
    clr_green clr_bold "\xE2\x86\x92 " -n;  clr_reset clr_bold "Generate yalla.settings file :"
    _br

    local TEMPLATE="${_SRC_}/src/templates/yalla.settings.tpl"



    ###############################################################################
    ## Check if a yalla settings already exist
    ##

    if [ -f "yalla.settings" ]; then
        _warning "A settings file alreay exists, do you want to overwrite it"

        while true; do
        read -p "yes / no ? " yn
            case $yn in
                [Yy]* )
                    _br
                    printf "Ok, let's go ! \xF0\x9F\x98\x8B\n";
                    break;;
                [Nn]* )
                    _br
                    printf "Ok, bye ! \xF0\x9F\x98\x98 \n";
                    exit;
                    break;;
                * ) printf "Please answer y or n. \n";;
            esac
        done
    fi

    _line
    _br

    ###############################################################################
    ## Define project properties
    ##

    clr_magenta "Project parameters."
    _br
    read -p "Project name (ex: fabernovel) : " PROJECT
    read -p "Channel Slack (ex: random) : " CHANNEL

    _line
    _br

    ###############################################################################
    ## Select app type
    ##

    clr_magenta "Select application type :"
    _br
    select APP_TYPE in Symfony Drupal8 Drupal7 Wordpress
    do
            case $APP_TYPE in
            Symfony|Drupal8|Drupal7|Wordpress)
                    APP_TYPE=$(_tolower $APP_TYPE)
                    break
                    ;;
            *)
                    echo "Invalid choice"
                    ;;
            esac
    done

    _line
    _br

    ###############################################################################
    ## Select docker stack type
    ##

clr_magenta "Now select required docker stack."
    cat <<HEREDOC
    Default: http php mysql
    Available :
    * Php
    * Httpd | Nginx
    * MySql | PgSql | Mongo
    * Redis | Memcd
To define the versions and other configuration elements of the docker environment, edit the file .devil-box-runtime-settings
HEREDOC
    _br

    # customize with your own.
    options=("Php" "Httpd" "Nginx" "MySql" "PgSql" "Mongo" "Redis" "Memcd")

    menu() {
        echo "Avaliable options:"
        for i in ${!options[@]}; do
            printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}"
        done
        [[ "$DOCKER_CHOICES" ]] && echo "$DOCKER_CHOICES"; :
    }

    prompt="Check an option (${BLUE}again to uncheck${NORMAL}, ${GREEN}ENTER when done${NORMAL}): "
    while menu && read -rp "$prompt" num && [[ "$num" ]]; do
        [[ "$num" != *[![:digit:]]* ]] &&
        (( num > 0 && num <= ${#options[@]} )) ||
        { DOCKER_CHOICES="Invalid option: $num"; continue; }
        ((num--)); DOCKER_CHOICES="${options[num]} was ${choices[num]:+un}checked"
        [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"
    done

    DOCKER_STACK=
    printf "\nYou selected"; DOCKER_CHOICES=" nothing"
    for i in ${!options[@]}; do
        [[ "${choices[i]}" ]] && { printf " %s" "${options[i]}"; DOCKER_CHOICES=""; DOCKER_STACK="${DOCKER_STACK} ${options[i]}"; }
    done

    # Convert to lowercase
    DOCKER_STACK=$(_tolower $DOCKER_STACK)

    _br
    _line

    ###############################################################################
    ## Finally write file
    ##

    clr_magenta "Database parameters."
    _br
    read -p "Database name : " DB_DEV_DATABASE_NAME
    read -p "Database user name : " DB_DEV_USER
    read -p "Database user password : " DB_DEV_PASS


    ###############################################################################
    ## Finally write file
    ##

    PROJECT=$PROJECT \
    CHANNEL=$CHANNEL \
    APP_TYPE=$APP_TYPE \
    DOCKER_STACK="${DOCKER_STACK}" \
    DB_DEV_USER="${DB_DEV_USER}" \
    DB_DEV_PASS="${DB_DEV_PASS}" \
    DB_DEV_DATABASE_NAME="${DB_DEV_DATABASE_NAME}" \
    ./yalla/src/lib/templater.sh ./yalla/src/templates/yalla.settings.tpl > yalla.settings

    _br
    _line

    _success "Yalla settings are now completed"
    cat <<HEREDOC
To update the files, edit the yalla.settings file.
To restart the installation re-run the command 'yalla create-project'

If there is a problem, open a ticket https://bitbucket.org/buzzaka/project-skeleton/issues?status=new&status=open
HEREDOC

    _br
    _line
}

declare -x -f _yalla_settings;