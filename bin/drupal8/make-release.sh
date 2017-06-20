#!/bin/bash
SRC=$(cd $(dirname "$0"); pwd)

. "${SRC}/lib/include.sh"

$DRUSH sset system.maintenance_mode TRUE;

$DRUSH cache-rebuild

ENV=$1

if [ -z "$2" ]
  then
    ENV_URL="https://preprod.syndex.fr"
fi


DATE=$(date +%Y%m%d%H%M)
RELEASE_PATH="${RELEASE_DIR}/${DATE}/"


# Notify start backup
case $ENV in
    preprod|prod|staging)
        # Turn off the aggregation to avoid to turn crazy.
        curl -X POST --data-urlencode 'payload={"channel": "#'$CHANNEL'", "username": "buzzakabot", "text": "'$( date +%F)' Backup started on '$ENV'.", "icon_emoji": ":buzzaka:", "thumb_url": "https://cdnjs.cloudflare.com/ajax/libs/emojione/2.1.0/assets/png/2705.png", "attachments":[{"fallback":"Url de '$ENV': <'$ENV_URL'| Tache en cours sur '$ENV'>","pretext":"Tache en cours sur '$ENV': <'$ENV_URL'| Tache en cours sur '$ENV'>","color":"#D00000","fields":[{"title":"Notes","value":"Please wait.","short":false}]}]}' $SLACK_HOOK;
    ;;
esac


if [ ! -d "$RELEASE_DIR" ]; then
  info "The path ${RELEASE_DIR} does not exist, we create it"
  mkdir $RELEASE_DIR
fi

info "Create release path ${RELEASE_PATH}"
mkdir $RELEASE_PATH

info "Backup code"
rsync -az --stats --exclude=node_modules/ --exclude=.git --exclude=vendor --exclude=cache/* --exclude=logs/* --exclude=sites/default/files/* "${REPOSITORY}" "$RELEASE_PATH"

info "Backup database"
$DRUSH sql-dump --gzip  > "${RELEASE_PATH}/dump-${DATE}.sql.gz"

info "Backups tasks completed"

info "Remove old releases"


# Remove old release
counter=0
for i in $(ls -dr $RELEASE_DIR/*/);
do
    if [ $counter -lt '5' ]
    then
        echo 'Previous releases : ' ${i%%/};
    else
        echo 'Delete old realease : '${i%%/};
        #TODO: check folder before execute this F****** function...

        if [ ! -d "${i%%/}" ]; then
          info "The path ${RELEASE_DIR} does not exist"
          else
            rm -rf ${i%%/}
        fi
    fi

    counter=$((counter + 1))
done

# Notify start backup
case $ENV in
    preprod|prod|staging)
        # Turn off the aggregation to avoid to turn crazy.
        curl -X POST --data-urlencode 'payload={"channel": "#'$CHANNEL'", "username": "buzzakabot", "text": "'$( date +%F)' Backup finished on '$ENV'.", "icon_emoji": ":buzzaka:", "thumb_url": "https://cdnjs.cloudflare.com/ajax/libs/emojione/2.1.0/assets/png/2705.png", "attachments":[{"fallback":"Url de '$ENV': <'$ENV_URL'| Tache en cours sur '$ENV'>","pretext":"Tache en cours sur '$ENV': <'$ENV_URL'| Tache en cours sur '$ENV'>","color":"#D00000","fields":[{"title":"Notes","value":"Please wait.","short":false}]}]}' $SLACK_HOOK;
    ;;
esac
