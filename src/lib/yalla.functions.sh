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
            VERSION=$(sed -n -e '/YALLA_VERSION/ s/.*\= *//p' ./yalla/src/cli/yalla)
            ;;
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
# _yalla_make_directories()
#
# Usage:
#   _yalla_make_directories
#
# Generate skeleton directories, not necessary for old project
#
_yalla_make_directories(){

  declare -a FOLDERS=(application shared logs tests)

  _line
  _br
  clr_green clr_bold "\xE2\x86\x92 " -n;  clr_reset clr_bold "Generate directories : " -n; echo ${FOLDERS[@]}
  _br

  for folder in "${FOLDERS[@]}"; do
      mkdir -p $folder;
      touch $folder/.gitkeep
  done

  _success "Create directories and add .gitkeep \n"

}


###############################################################################
# _yalla_copy_samples()
#
# Usage:
#   _yalla_make_directories
#
# Generate skeleton directories, not necessary for old project
#
_yalla_copy_samples(){

  _line
  _br
  clr_green clr_bold "\xE2\x86\x92 " -n;  clr_reset clr_bold "Copy files samples : "
  _br

  for file in ./yalla/samples/{*,.*}
  do
      filename=$(basename $file)

      if [ -f "${file}" ] && [ "$filename" != ".devilbox-run-time-settings" ]; then
            if [ -f "$file" ]; then
                if _ask "Do you want to overwrite ${filename} ? "; then
                  cp $file ./
                  _success "Overwrite file ${filename}"
                else
                  _info "Skip"
                fi
            else
                cp $file ./
                _success "Copy sample file ${filename}"
            fi
      fi
  done


}

###############################################################################
# _yalla_generate_gitignore()
#
# Usage:
#   _yalla_generate_gitignore
#
# Generate gitignore files for project and application
#
_yalla_generate_gitignore(){

  . $YALLA_SETTINGS_FILE

  _line
  _br
  _info "\xE2\x86\x92 Create base .gitignore in project directory"
  _br

  local create_gitignore=1
  local baseIgnore="linux,osx,windows,PhpStorm,SublimeText,VisualStudio"
  local projectIgnore="node,${APP_TYPE}"

  # Check if a gitignore file exiss and what we do if yes
  if [ -f ".gitignore" ]; then
    _ask "A gitignore file exist in $(pwd)/.gitignore, do you want to overwrite it ?" || create_gitignore=0
  fi

  # Create base gitignore if lines doesn't exists and if user it's ok
  if [ -z "$(grep "End of https://www.gitignore.io" ".gitignore")" ] && [ "${create_gitignore}" -eq 1 ]; then
    _gi "${baseIgnore}" > .gitignore
    _success "Create base .gitignore in application directory with config : ${baseIgnore}"
    _br
  fi


  CONTENT=$(cat <<HEREDOC
# Created by the yalla init script

# Ignore local yalla folder
./yalla/

# Local env files
/shared/*.local
/shared/*.local.*
/shared/local.*

# Ignore local secrets folders
vaults.yml
vault.yml
vaults/
vaults/vault.yml

# End of yalla create-project script

HEREDOC
)

  # Put yalla ignore params if not exists
  if [ -z "$(grep "Created by the yalla init script" ".gitignore")" ]; then
    # Yalla .gitignore
    printf "${CONTENT}" >> .gitignore
    _success "Add yalla .gitignore params"
    _br
  fi

  # Put project ignore settings if not exist or if overwrite = 1
  if [ -f "${APPLICATION_PATH_NAME}/.gitignore" ]; then
    if _ask "A gitignore file exist in ${APPLICATION_PATH_NAME}/.gitignore, do you want to overwrite it ?"; then
      create_gitignore=1
    else
      create_gitignore=0
    fi
  fi

  if [ -z "$(grep "https://www.gitignore.io/api/node,${APP_TYPE}" "${APPLICATION_PATH_NAME}/.gitignore")" ] || [ "${create_gitignore}" -eq 1 ]; then
    _gi "${projectIgnore}" > "${APPLICATION_PATH_NAME}/.gitignore"
    _success ".gitignore was generated with ${projectIgnore}"
  fi

  _line
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
    ## If it's a new project, generate folders
    ##

    if ! [ -f ".gitignore" ]; then
      _yalla_make_directories
      _yalla_copy_samples
    fi


    ###############################################################################
    ## If it's a new project, generate folders
    ##

    if ! [ -f ".gitignore" ]; then
      _yalla_make_directories
      _yalla_copy_samples
    fi


    ###############################################################################
    ## Check if a yalla settings already exist
    ##

    if [ -f ".env" ]; then
        _warning "A .env file alreay exists, do you want to overwrite it"

        while true; do
        read -p "yes / no ? " yn
            case $yn in
                [Yy]* )
                    _br
                    printf "Ok, let's go ! \xF0\x9F\x98\x8B\n";
                    break;;
                [Nn]* )
                    _br
                    printf "Ok, skip it ! 👀";
                    break;;
                * ) printf "Please answer y or n. \n";;
            esac
        done
    else
        cp ./yalla/samples/.devilbox-run-time-settings .env
        _info "Please, now edit file .env and adust your project requirements. (vi/subl .env)"
        read -p "Is it done ?" yn
            case $yn in
                [Yy] | yes | Yes )
                    _br
                    printf "Ok, continue ! \xF0\x9F\x98\x8B\n";
                    break;;
                *)
                    _notice "Ok, you must do it later"
                    break
                    ;;
            esac
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
    select APP_TYPE in Symfony Drupal8 Drupal7 Wordpress Angular Other
    do
            case $APP_TYPE in
            Symfony|Drupal8|Drupal7|Wordpress|Angular)
                    APP_TYPE=$(_tolower $APP_TYPE)
                    break
                    ;;
            Other )
                    read -p "Please specify : " APP_TYPE_OTHER
                    APP_TYPE=$(_tolower $APP_TYPE_OTHER)
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
                [Yy] | yes | Yes )
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

    _info "Write database parameters into $(clr_bold clr_white "yalla.settings")"
    _br
    PROJECT=$PROJECT \
    CHANNEL=$CHANNEL \
    APP_TYPE=$APP_TYPE \
    DOCKER_STACK="${DOCKER_STACK}" \
    DB_DEV_USER="${DB_DEV_USER}" \
    DB_DEV_PASS="${DB_DEV_PASS}" \
    DB_DEV_DATABASE_NAME="${DB_DEV_DATABASE_NAME}" \
    PRODUCTION_URI="${PRODUCTION_URI}" \
    ./yalla/src/lib/templater.sh ./yalla/templates/yalla.settings.tpl > yalla.settings

    _info "Write database parameters into $(clr_bold clr_white "hosts.yml")"
    _br
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

    _yalla_generate_gitignore

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
$(_line)

$(clr_bold "Yalla settings are no completed")
$(_line)

$(clr_underscore clr_cyan "Main config files are : ")

$(clr_bold "yalla.settings : ")
    Set variables for yalla, define slack channel to notify on deploy, ...

$(clr_bold "hosts.yml : ")
    Set up base config to allow ansible mysql sync

$(clr_bold "Pull database from remote host :")
    • Populate $(clr_bold "hosts.yml") with remote datas
    • Edit secrets (vault) : run
        $(clr_cyan 'yalla av create')
    • Edit like that :
        $(clr_bright "vault_staging_db_pass: your-staging-pass")
        $(clr_bright "vault_preprod_db_pass: your-preprod-pass")
        $(clr_bright "vault_live_db_pass:    your-db-pass")
    • Run
        $(clr_cyan 'yalla ap mysql-sync -e "source="staging|preprod|live" --ask-vault-pass')

$(_line)

If there is a problem, open a ticket
https://bitbucket.org/buzzaka/project-skeleton/issues?status=new&status=open


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
