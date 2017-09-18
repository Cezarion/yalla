#!/usr/bin/env bash

# Exit immediately on error
set -e

# Load common vars and functions
. "./yalla/src/lib/common.sh"

# remove first arg (mysql)

INLINE=
DATABASE=""
FILE=""

[ ! "$(docker ps -a | grep <name>)" ]

_usage() {
notice "\nBad use or missing arguments."

echo '
Examples :
    yalla mysql -d database_name -f path/to/file.sql : import a database
    yalla mysql -d database_name -i "SHOW TABLES;" : run an inline sql command script
    yalla mysql -i "SHOW DATABASES;" : run an inline sql command script
    yalla mysql -f ./databases/create_user_and_database.sql : import an sql file
'
}

if [ $# -eq 1 ]
then
    _usage
    exit
fi

while getopts h:i:d:f: optname; do
    case "$optname" in
        i ) INLINE="$OPTARG";;
        d ) DATABASE="${OPTARG}" ;;
        f ) FILE="${OPTARG}" ;;
        h ) _usage;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
        ;;
    esac
done

# Import a sql file
if [[ ! -z $FILE ]]; then
    if [ ! -f "${FILE}" ]; then
        _bad_exit "No ${FILE} file was found in the directory";
    fi

    mysql -u root -h 127.0.0.1 ${DATABASE} < ${FILE};
fi

# Run inline mysql command
if [[ ! -z $INLINE ]]; then
    echo $INLINE | mysql -u root -h 127.0.0.1 ${DATABASE};
fi
