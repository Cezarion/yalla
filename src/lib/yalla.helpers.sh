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
# _yalla_version()
#
# Usage:
#   __yalla_version <local|remote>
#
# get version of a yalla script
#

_yalla_version() {
  local ARGS="${1}"
  local VERSION

  case $ARGS in
  local | -l)
    VERSION=$(sed -n -e '/YALLA_VERSION/ s/.*\= *//p' /usr/local/bin/yalla)
    ;;
  remote | -r)
    VERSION=$(sed -n -e '/YALLA_VERSION/ s/.*\= *//p' ./yalla/src/cli/yalla)
    ;;
  esac

  echo "${VERSION}"
}


###############################################################################
# _yalla_check_requirements()
#
# Usage:
#   _yalla_check_requirements
#
# Verify if devilbox and docker are installed
#

_yalla_check_requirements() {

  # check docker
  if ! _command_exists docker; then
    _error "Docker is required to use yalla."
    echo -e "Please install Docker CE ${DOCKER_VERSION_MIN} \nhttps://www.docker.com/docker-mac"
    exit 1
  fi

  if ! [[ $(docker version | grep "${DOCKER_VERSION_MIN}") ]]; then
    _bad_exit "Minimum docker version requirements: ${DOCKER_VERSION_MIN}"
  fi

  # check devilbox
  if ! [ -f "${HOME}/.devilbox" ]; then
    _error "Devilbox config file is missing"
    echo -e "https://bitbucket.org/buzzaka/devilbox/src#markdown-header-usage-as-a-common-stack-fabernovel-code-stack"
    exit 1
  fi

  if ! [ -d "${DEVILBOX_LOCAL_PATH}" ]; then
    _error "Devilbox is missing"
    echo -e "Please install Devilbox"
    echo -e "https://bitbucket.org/buzzaka/devilbox/src#markdown-header-usage-as-a-common-stack-fabernovel-code-stack"
    exit 1
  fi
}


###############################################################################
# _yalla_version()
#
# Usage:
#   __yalla_version <local|remote>
#
# get version of a yalla script
#
_yalla_check_update() {
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
      [Yy]*)
        _yalla_install_bin
        break
        ;;
      [Nn]*)
        exit
        break
        ;;
      *) printf "Please answer y or n. \n" ;;
      esac
    done
  else
    _info "Version is up to date"
  fi

  _br
}

###############################################################################
# _check_is_yalla_app()
#
# Usage:
#   _check_is_yalla_app
#
# Exit if not args or not a yalla project
#

_check_is_yalla_app() {
  if [ ! -d "./yalla" ] && [ "$1" != "init" ]; then
    echo -e "\n\xE2\x9C\x97 Error ! \n"
    cat <<HEREDOC
The "yalla" directory does not appear to be present.
Run <yalla init> or go to a directory where yall is installed

HEREDOC
    exit 1
  fi
}


###############################################################################
# _yalla_make_directories()
#
# Usage:
#   _yalla_make_directories
#
# Generate skeleton directories, not necessary for old project
#
_yalla_make_directories() {
  _br
  clr_green clr_bold "\xE2\x86\x92 " -n
  clr_reset clr_bold "Generate directories : " -n
  echo ${FOLDERS[@]}
  _br

  for folder in "${FOLDERS[@]}"; do
    mkdir -p $folder
    touch $folder/.gitkeep
  done

  _success "Create directories and add .gitkeep \n"

}

###############################################################################
# _yalla_copy_samples()
#
# Usage:
#   _yalla_copy_samples
#
# Generate skeleton directories, not necessary for old project
#
_yalla_copy_samples() {

  _br
  clr_green clr_bold "\xE2\x86\x92 " -n
  clr_reset clr_bold "Copy files samples : "
  _br

  for file in ./yalla/samples/{*,.*}; do
    filename=$(basename $file)

    if [ -f "${file}" ] && [ "$filename" != ".devilbox-run-time-settings" ]; then
      if ! [ -f "$file" ]; then
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
# _yalla_mysql_create_user_and_db()
#
# Usage:
#   _yalla_mysql_create_user_and_db
#
# Create user and datanse. Add rights and flush privilèges
#

_yalla_mysql_create_user_and_db() {
  _h1_step "Do you want to create local user and database ? "
  while true; do
    read -p "yes / no ? " yn
    case $yn in
    [Yy]*)
      _mysql_create_user_and_database
      break
      ;;
    *)
      break
      ;;
    esac
  done

  _br
  _line
}


###############################################################################
# _yalla_generate_gitignore()
#
# Usage:
#   _yalla_generate_gitignore
#
# Generate gitignore files for project and application
#
_yalla_generate_gitignore() {

  . $YALLA_SETTINGS_FILE

  # _info "\xE2\x86\x92 Create base .gitignore in project directory"
  # _br

  local create_gitignore=1
  local baseIgnore="linux,osx,windows,PhpStorm,SublimeText,VisualStudio"
  local projectIgnore="node,${APP_TYPE}"

  # Check if a gitignore file exiss and what we do if yes
  if [ -f ".gitignore" ]; then
    _ask "A gitignore file exist in $(pwd)/.gitignore, do you want to overwrite it ?" || create_gitignore=0
  else
    touch .gitignore
  fi

  # Create base gitignore if lines doesn't exists and if user it's ok
  if [ -z "$(grep "End of https://www.gitignore.io" ".gitignore")" ] && [ "${create_gitignore}" -eq 1 ]; then
    _gi "${baseIgnore}" >.gitignore
    _success "Create base .gitignore in application directory with config : ${baseIgnore}"
    _br
  fi

  CONTENT=$(
    cat <<HEREDOC
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
    printf "${CONTENT}" >>.gitignore
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
    _gi "${projectIgnore}" >"${APPLICATION_PATH_NAME}/.gitignore"
    _success ".gitignore was generated with ${projectIgnore}"
    _br
  fi

}


###############################################################################
# _yalla_write_hosts_config()
#
# Usage:
#   _yalla_write_hosts_config
#
# Exit if not args or not a yalla project
#


_yalla_write_hosts_config() {

  ###############################################################################
  ## __setup_remote_values
  ## Usage :
  ##    __setup_remote_values [ env name ]
  ##
  ## Setup remote params
  ##
  __setup_remote_values() {
    local env=$1
    local ansible_host ansible_user project_root db_name db_user host_url

    _br
    clr_green "[ ${env} ] Server parameters :"

    read -p "Server Ip / hostname: " ansible_host
    read -p "Ssh user: " ansible_user
    read -p "Project path on server: " project_root

    _br
    clr_green "[ ${env} ] Database parameters :"

    read -p "Database name: " db_name
    read -p "Database user name: " db_user

    read -p "Site url: " host_url

    _line $(clr_bright _)
    clr_blue "Use ansible vault <yalla av create> to store securely secret password : "
    clr_blue "vault_${env}_db_pass: \"your-password\""
    _line $(clr_bright _)

    # Share vars to template,
    # Removing comments for known rows
    # Append to hosts.yml
    ANSIBLE_ENV="${env}" \
    ANSIBLE_HOST="${ansible_host}" \
    ANSIBLE_USER="${ansible_user}" \
    PROJECT_ROOT="${project_root}" \
    DB_NAME="${db_name}" \
    DB_USER="${db_user}" \
    HOST_URL="${host_url}" \
    BECOME_USER="" \
    ./yalla/src/lib/templater.sh ./yalla/templates/hosts-vars.yml.tpl | sed -E '/unknown/! s/(#\s*)//' >> hosts.yml
  }

  _br
  for env in "${REMOTE_ENV_TYPE[@]}"; do
    if _ask "$(clr_magenta "Would you like to setup remote ennvironment ${env} ?")"; then
      if grep -q "${env}:" "hosts.yml"; then
        _warning "${env} is already set. Edit manually, please"
        echo 'Skip; next step'
        continue
      else
        __setup_remote_values $env
      fi
    fi
  done
}
