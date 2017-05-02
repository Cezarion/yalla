#!/bin/bash
SRC=$(cd $(dirname "$0"); pwd)

. "${SRC}/lib/include.sh"

### APP Profile and theme
PROFILE=$($DRUSH core-status install_profile --pipe --format=list)
THEME=$($DRUSH config-get system.theme default --pipe --format=list)
THEME_PATH=$WEBROOT/profiles/$PROFILE/themes/custom/$THEME

# Slack notifications
PROJECT="Syndex - refonte"
ENV_URL="syndex-staging.fabernovel.co"
CHANNEL="syndex"
SLACK_HOOK="https://hooks.slack.com/services/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"

ENV=$1


if [ -z "$2" ]
  then
    ENV_URL="https://syndex.fr/"
fi

# Slack notification


# Notify end of scripts
if [[ $ENV != "dev" ]]; then
    curl -X POST --data-urlencode 'payload={"channel": "#'$CHANNEL'", "username": "buzzakabot", "text": "'$( date +%F)' Build start on '$ENV'.", "icon_emoji": ":buzzaka:", "thumb_url": "https://cdnjs.cloudflare.com/ajax/libs/emojione/2.1.0/assets/png/2705.png", "attachments":[{"fallback":"Url de '$ENV': <'$ENV_URL'|Voir en '$ENV'>","pretext":"Url de '$ENV': <'$ENV_URL'|Voir en '$ENV'>","color":"#D00000","fields":[{"title":"Notes","value":"Please wait.","short":false}]}]}' $SLACK_HOOK;
fi

# Usage install_actions ENV(prod|dev) PROFILE_NAME STAGING/PROD url
deploy_actions $1 $PROFILE $ENV_URL

# Install and compile assets
assets_actions $1

if [[ $ENV != "dev" ]]; then
    curl -X POST --data-urlencode 'payload={"channel": "#'$CHANNEL'", "username": "buzzakabot", "text": "'$( date +%F)' Build completed on '$ENV'.", "icon_emoji": ":buzzaka:", "thumb_url": "https://cdnjs.cloudflare.com/ajax/libs/emojione/2.1.0/assets/png/2705.png", "attachments":[{"fallback":"Url de '$ENV': <'$ENV_URL'|Voir en '$ENV'>","pretext":"Url de '$ENV': <'$ENV_URL'|Voir en '$ENV'>","color":"#D00000","fields":[{"title":"Notes","value":"Please check.","short":false}]}]}' $SLACK_HOOK;
fi

# Custom Actions per env
case $1 in
    dev|staging)
        # Turn off the aggregation to avoid to turn crazy.
#        $DRUSH en masquerade;
        ;;
    preprod|prod)
        #
        ;;
    *)
    echo "Unknown environment: $2. Please check your name."
    exit 1;
esac
