#!/usr/bin/env bash

#
#
# @authors Mathias Gorenflot (mathias.gorenflot@fabernovel.com)
# @date    2017-08-30 11:03:26
# @version $Id$
#

# Exit immediately on error
set -e
trap 'echo "Aborting due to errexit on line $LINENO. File $(cd $(dirname "$0"); pwd)/$(basename "$0"). Exit code: $?" >&2' ERR

[[ -d /usr/local/bin ]] || mkdir -p /usr/local/bin

# Download cli script
curl -o /usr/local/bin/yalla  https://yalla-stable.fabernovel.co/src/cli/yalla;

# Set script as executable
chmod +x /usr/local/bin/yalla;

# Download autocomplete
curl -o "${HOME}/.yalla.autocomplete"  https://yalla-stable.fabernovel.co/src/cli/yalla.autocomplete;

chmod +x "${HOME}/.yalla.autocomplete";

CONTENT="\n#Add yalla autocomplete\nsource \$HOME/.yalla.autocomplete"

if [ -f "${HOME}/.zshrc" ]
    then
        if ! grep -q ".yalla.autocomplete" "${HOME}/.zshrc"
        then
            printf  "${CONTENT}" >> "${HOME}/.zshrc"
        fi
        source ${HOME}/.yalla.autocomplete
        exit
fi

if [ -f "${HOME}/.profile" ]
    then
        if ! grep -q ".yalla.autocomplete" "${HOME}/.profile"
        then
            printf "${CONTENT}" >> "${HOME}/.profile"
        fi
        source ${HOME}/.yalla.autocomplete
        exit
fi

if [ -f "${HOME}/.bashrc" ]
    then
        if ! grep -q ".yalla.autocomplete" "${HOME}/.bashrc"
        then
            printf "${CONTENT}" >> "${HOME}/.bashrc"
        fi
        source ${HOME}/.yalla.autocomplete
        exit
fi
