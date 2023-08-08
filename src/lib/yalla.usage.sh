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
# _yalla_final_help()
#
# Usage:
#   _yalla_final_help
#
# Show end help
#

_yalla_final_help() {

  _br
  _success "Yalla settings are now completed"
  cat <<HEREDOC
  $(_line)

  $(clr_bold "Yalla settings are ok. To Finalize or start using follow instructions below.")
  $(_line)

  $(clr_underscore clr_cyan "Main config files are : ")

  $(clr_bold "yalla.settings : ")
      Set variables for yalla, define slack channel to notify on deploy, ...

  $(clr_bold "hosts.yml : ")
      Set up base config to allow ansible mysql sync

  $(clr_bold "Pull database from remote host :")
      • Populate $(clr_bold "hosts.yml") with remote datas
      • Edit secrets (vault) : run
          $(clr_cyan '<yalla av create>')
      • Edit like that :
          $(clr_bright "vault_staging_db_pass: your-staging-pass")
          $(clr_bright "vault_preprod_db_pass: your-preprod-pass")
          $(clr_bright "vault_live_db_pass:    your-db-pass")
      • Run
          $(clr_cyan '<yalla ap mysql-sync -e "source="staging|preprod|live" --ask-vault-pass>')

      • List of available commands
          $(clr_cyan '<yalla -h>')

  $(_line)

  If there is a problem, open a ticket
  https://bitbucket.org/buzzaka/project-skeleton/issues?status=new&status=open

  If you need help, slack : @mathias

HEREDOC
}
