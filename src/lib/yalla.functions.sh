#!/usr/bin/env bash

#
# @authors Mathias Gorenflot (mathias.gorenflot@fabernovel.com)
# @date    2017-08-29 19:18:09
# @version $Id$
#

# Exit immediately on error
set -e
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR


###############################################################################
# _yalla_install_bin()
#
# Usage:
#   _yalla_install_bin
#
# Install yalla command in /usr/local/bin
# @todo download script from remote repository
#
_yalla_install_bin() {
  _info "yalla command is not installed. We install it" >&2
  cp './yalla/src/cmd/yalla' /usr/local/bin/

  if [ ! -f "${HOME}/.yalla.autocomplete" ]; then
    cp './yalla/src/cmd/autocomplete.sh' "${HOME}/.yalla.autocomplete"

    CONTENT="\n#Add yalla autocomplete\nsource \$HOME/.yalla.autocomplete"

    if [ -f "${HOME}/.zshrc" ]; then
      if ! grep -q ".yalla.autocomplete" "${HOME}/.zshrc"; then
        echo "${CONTENT}" >>"${HOME}/.zshrc"
      fi
      source "${HOME}/.yalla.autocomplete"
    fi

    if [ -f "${HOME}/.profile" ]; then
      if ! grep -q ".yalla.autocomplete" "${HOME}/.profile"; then
        echo "${CONTENT}" >>"${HOME}/.profile"
      fi
      source "${HOME}/.yalla.autocomplete"
    fi

    if [ -f "${HOME}/.bashrc" ]; then
      if ! grep -q ".yalla.autocomplete" "${HOME}/.bashrc"; then
        echo "${CONTENT}" >>"${HOME}/.bashrc"
      fi
      source "${HOME}/.yalla.autocomplete"
    fi

  fi
  _success 'Check yalla version'
  _line =
  yalla -v
  _line =
}

###############################################################################
# _yalla_init_project()
#
# Usage:
#   _yalla_init_project
#
# Generate the yalla.settings file
#

function _yalla_init_project() {
  _yalla_check_requirements
  _step_counter --init 10

  _line =
  clr_green clr_bold "\xE2\x86\x92 " -n
  clr_reset clr_bold _toupper "Init a new yalla project"
  _line =

  local TEMPLATE="${_SRC_}/templates/yalla.settings.tpl"

  ###############################################################################
  ## Check if a yalla settings already exist
  ##

  if [ -f "yalla.settings" ]; then
    _warning "A settings file alreay exists, do you want to overwrite it"

    while true; do
      read -p "yes / no ? " yn
      case $yn in
      [Yy]*)
        _br
        printf "Ok, let's go ! \xF0\x9F\x98\x8B\n"
        break
        ;;
      [Nn]*)
        _br
        printf "Ok, bye ! \xF0\x9F\x98\x98 \n"
        exit
        break
        ;;
      *) printf "Please answer y or n. \n" ;;
      esac
    done
  fi

  _br

  ###############################################################################
  ## If it's a new project, generate folders
  ## @TODO : Check paths and files not only .gitignore

  _h1 "Create directories and add sample files :"

  if ! [ -f ".gitignore" ]; then
    _yalla_make_directories
    _yalla_copy_samples
    _br
  else
    _notice "Folders and samples seems to be exist"
  fi

  ###############################################################################
  ## 1/10 Check if a yalla settings already exist
  ##
  _h1 "Add Devilbox environment variables :"

  if [ -f ".env" ]; then
    _warning "A .env file alreay exists, do you want to overwrite it"

    while true; do
      read -p "yes / no ? " yn
      case $yn in
      [Yy]*)
        _br
        printf "Ok, let's go ! \xF0\x9F\x98\x8B\n"
        break
        ;;
      [Nn]*)
        _br
        printf "Ok, skip it ! 👀"
        break
        ;;
      *) printf "Please answer y or n. \n" ;;
      esac
    done
  else
    cp ./yalla/samples/.devilbox-run-time-settings .env
    _info "Please, now edit file .env and adust your project requirements. (vi/subl .env)"
    read -p "Is it done ?" yn
    case $yn in
    [Yy] | yes | Yes)
      _br
      printf "Ok, continue ! \xF0\x9F\x98\x8B\n"
      break
      ;;
    *)
      _notice "Ok, you must do it later"
      break
      ;;
    esac
  fi

  ###############################################################################
  ## Define project properties
  ##
  _h1_step "Configure project parameters :"

  read -p "Project name (ex: fabernovel) : " PROJECT
  read -p "Channel Slack (ex: random) : " CHANNEL


  _br

  ###############################################################################
  ## Select app type
  ##

  _h1_step "Select application type :"

  select APP_TYPE in Symfony Drupal8 Drupal7 Wordpress Angular Other; do
    case $APP_TYPE in
    Symfony | Drupal8 | Drupal7 | Wordpress | Angular)
      APP_TYPE=$(_tolower $APP_TYPE)
      break
      ;;
    Other)
      read -p "Please specify : " APP_TYPE_OTHER
      APP_TYPE=$(_tolower $APP_TYPE_OTHER)
      break
      ;;
    *)
      echo "Invalid choice"
      ;;
    esac
  done

  _br

  ###############################################################################
  ## Select docker stack type
  ##

  _h1_step "Now select required docker stack."
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
    echo "Available options:"
    for i in ${!options[@]}; do
      printf "%3d%s) %s\n" $((i + 1)) "${choices[i]:- }" "${options[i]}"
    done
    [[ "$DOCKER_CHOICES" ]] && echo "$DOCKER_CHOICES"
    :
  }

  prompt="Check an option (${BLUE}again to uncheck${NORMAL}, ${GREEN}ENTER when done${NORMAL}): "
  while menu && read -rp "$prompt" num && [[ "$num" ]]; do
    [[ "$num" != *[![:digit:]]* ]] &&
      ((num > 0 && num <= ${#options[@]})) ||
      {
        DOCKER_CHOICES="Invalid option: $num"
        continue
      }
    ((num--))
    DOCKER_CHOICES="${options[num]} was ${choices[num]:+un}checked"
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"
  done

  DOCKER_STACK=
  printf "\nYou selected"
  DOCKER_CHOICES=" nothing"
  for i in ${!options[@]}; do
    [[ "${choices[i]}" ]] && {
      printf " %s" "${options[i]}"
      DOCKER_CHOICES=""
      DOCKER_STACK="${DOCKER_STACK} ${options[i]}"
    }
  done

  # Convert to lowercase
  DOCKER_STACK=$(_tolower $DOCKER_STACK)

  _br

  ###############################################################################
  ## If production environment exist populate files
  ##
  _h1_step "Does the production environment exist? "
  while true; do
    read -p "yes / no ? " yn
    case $yn in
    [Yy] | yes | Yes)
      clr_magenta "Production url."
      _br
      read -p "Production url: " PRODUCTION_URI
      break
      ;;
    *)
      _notice "Ok, continue"
      break
      ;;
    esac
  done

  _br

  ###############################################################################
  ## Setup db params
  ##

  _h1_step "Local database parameters."

  read -p "Database name : " DB_DEV_DATABASE_NAME
  read -p "Database user name : " DB_DEV_USER
  read -p "Database user password : " DB_DEV_PASS

  ###############################################################################
  ## Write project config
  ##

  PROJECT=$PROJECT \
    CHANNEL=$CHANNEL \
    APP_TYPE=$APP_TYPE \
    DOCKER_STACK="${DOCKER_STACK}" \
    DB_DEV_USER="${DB_DEV_USER}" \
    DB_DEV_PASS="${DB_DEV_PASS}" \
    DB_DEV_DATABASE_NAME="${DB_DEV_DATABASE_NAME}" \
    PRODUCTION_URI="${PRODUCTION_URI}" \
    ./yalla/src/lib/templater.sh ./yalla/templates/yalla.settings.tpl >yalla.settings

  _success "Write database parameters into $(clr_bold clr_white "yalla.settings")"

  DB_DEV_USER="${DB_DEV_USER}" \
    DB_DEV_PASS="${DB_DEV_PASS}" \
    DB_DEV_DATABASE_NAME="${DB_DEV_DATABASE_NAME}" \
    PRODUCTION_URI="${PRODUCTION_URI}" \
    ./yalla/src/lib/templater.sh ./yalla/templates/hosts.yml.tpl >hosts.yml

  _success "Write database parameters into $(clr_bold clr_white "hosts.yml")"
  # Load params file
  source yalla.settings

  _br

  ###############################################################################
  ## Configure remote config
  ##
  _h1_step "Setup remote access and database parameters"
  _yalla_write_hosts_config

  ###############################################################################
  ## Set .gitignore
  ##

  _h1_step "Set up .gitignore"
  _yalla_generate_gitignore

  ###############################################################################
  ## end message
  ##

  _br
  _success "Yalla settings are now completed"

  ###############################################################################
  ## Create user and database
  ##

  _yalla_mysql_create_user_and_db

  ###############################################################################
  ## Import an existing database ?
  ##
  _h1_step "Import a database ? "
  _mysql_import_database

  ###############################################################################
  ## end message
  ##
  _line $(clr_bright _)
  _yalla_final_help
}

declare -x -f _yalla_init_project

###############################################################################
# _yalla_install_project()
#
# Usage:
#   _yalla_install_project
#
# Install project from an existing yalla configuration
#

_yalla_install_project() {
  _yalla_check_requirements
  _step_counter --init 3

  _line =
  clr_green clr_bold "\xE2\x86\x92 " -n
  clr_reset clr_bold _toupper "Install yalla project from existing configuration"
  _line =

  # Check if yalla is ready
  if ! [ -f "${YALLA_SETTINGS_FILE}" ] && ! [ -f "hosts.yml " ]; then
    _bad_exit "Yalla files not found. Please run <yalla init> first"
  fi

  _yalla_mysql_create_user_and_db

  _h1_step "Import a database ? "
  _mysql_import_database

  _line $(clr_bright _)
  _yalla_final_help
}
