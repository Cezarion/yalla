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

# for file in $(pwd)/yalla/src/lib/*
# do
#     FILENAME=$(basename $file)

#     if [ "${FILENAME}" != "yalla.functions.sh" ] && [ "${FILENAME}" != "common.sh" ] && [ "${FILENAME}" != "templater.sh" ]
#         then
#             . $file
#     fi
# done

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

    if [ ! -f "${HOME}/.yalla.autocomplete" ]
        then
            cp './yalla/src/cmd/autocomplete.sh' "${HOME}/.yalla.autocomplete"

            CONTENT="\n#Add yalla autocomplete\nsource \$HOME/.yalla.autocomplete"

            if [ -f "${HOME}/.zshrc" ]
                then
                    if ! grep -q ".yalla.autocomplete" "${HOME}/.zshrc"
                    then
                        echo  "${CONTENT}" >> "${HOME}/.zshrc"
                    fi
                    source "${HOME}/.yalla.autocomplete"
            fi

            if [ -f "${HOME}/.profile" ]
                then
                    if ! grep -q ".yalla.autocomplete" "${HOME}/.profile"
                    then
                        echo "${CONTENT}" >> "${HOME}/.profile"
                    fi
                    source "${HOME}/.yalla.autocomplete"
            fi

            if [ -f "${HOME}/.bashrc" ]
                then
                    if ! grep -q ".yalla.autocomplete" "${HOME}/.bashrc"
                    then
                        echo "${CONTENT}" >> "${HOME}/.bashrc"
                    fi
                    source "${HOME}/.yalla.autocomplete"
            fi

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

    echo "${VERSION}"
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

    echo "Yalla Local version : ${local_version}\n"
    echo "Yalla Remote version : ${remote_version}\n"

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
    clr_green clr_bold "\xE2\x86\x92 " -n;  clr_reset clr_bold "Generate yalla.settings and hosts.yml files :"
    _br

    local TEMPLATE="${_SRC_}/templates/yalla.settings.tpl"


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
    ## If production environment exist populate files
    ##
    clr_magenta "does the production environment exist? "
    while true; do
        read -p "yes / no ? " yn
            case $yn in
                [Yy] )
                    clr_magenta "Production url."
                    _br
                    read -p "Production url: " PRODUCTION_URI
                    break;;
                 *)
                    _notice "Ok, continue"
                    break
                    ;;
            esac
    done

    _br
    _line

    ###############################################################################
    ## Setup db params
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
    PRODUCTION_URI="${PRODUCTION_URI}" \
    ./yalla/src/lib/templater.sh ./yalla/templates/yalla.settings.tpl > yalla.settings

    DB_DEV_USER="${DB_DEV_USER}" \
    DB_DEV_PASS="${DB_DEV_PASS}" \
    DB_DEV_DATABASE_NAME="${DB_DEV_DATABASE_NAME}" \
    PRODUCTION_URI="${PRODUCTION_URI}" \
    ./yalla/src/lib/templater.sh ./yalla/templates/hosts.yml.tpl > hosts.yml

    _br

    # Load params file
    source yalla.settings

    _br
    _line

    ###############################################################################
    ## Set .gitignore
    ##

    CONTENT=$(cat <<HEREDOC
    # Created by the yalla_settings script

    # Local secrets folders
    /vaults.yml
    /vault.yml
    /vaults/
    /vaults/vault.yml

    # End of yalla yalla_settings script

HEREDOC)

    printf "${CONTENT}" >> .gitignore

    ###############################################################################
    ## end message
    ##

    _br
    _success "Yalla settings are now completed"


    ###############################################################################
    ## Create user and database
    ##

    _br
    clr_magenta "Do you want create user database ? "
    while true; do
        read -p "yes / no ? " yn
            case $yn in
                [Yy]* )
                    yalla dr up;
                    _mysql_create_user_and_database
                    break;;
                *)
                    break
                    ;;
            esac
    done

    _br
    _line

    ###############################################################################
    ## end message
    ##

    _br
    _success "Yalla settings are now completed"
    cat <<HEREDOC

To update the files, edit the yalla.settings file and/or hosts.yml.
To restart the installation re-run the command 'yalla create-project'

If there is a problem, open a ticket https://bitbucket.org/buzzaka/project-skeleton/issues?status=new&status=open
HEREDOC

    _br
    _line
}

declare -x -f _yalla_settings;


###############################################################################
# _check_is_yalla_app()
#
# Usage:
#   _check_is_yalla_app
#
# Exit if not args or not a yalla project
#

_check_is_yalla_app() {
  if [ ! -d "./yalla" ] && [ "$1" != "create-project" ]; then
      echo -e "\n\xE2\x9C\x97 Error ! \n"
      cat <<HEREDOC
The "yalla" directory does not appear to be present.
Run <yalla create-project> or go to a directory where yall is installed

HEREDOC
      exit 1;
  fi
}
