#!/bin/bash

# Load common vars and functions
. "./bin/lib/variables.sh"
. "./bin/lib/helpers.sh"
. "./bin/lib/functions.sh"

# remove first arg (mysql)

INLINE=
DATABASE=""
FILE=""

usage() {
notice "\nBad use or missing arguments."

echo '
Examples :
    ./devilbox mysql -d database_name -f path/to/file.sql : import a database
    ./devilbox mysql -d database_name -i "SHOW TABLES;" : run an inline sql command script
    ./devilbox mysql -i "SHOW DATABASES;" : run an inline sql command script
    ./devilbox mysql -f ./databases/create_user_and_database.sql : import an sql file
'
}

if [ $# -eq 1 ]
then
    usage
    exit
fi

while getopts h:i:d:f: optname; do
    case "$optname" in
        i ) INLINE="$OPTARG";;
        d ) DATABASE="${OPTARG}" ;;
        f ) FILE="${OPTARG}" ;;
        h ) usage;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
        ;;
    esac
done

# Import a sql file
if [[ ! -z $FILE ]]; then
    if [ ! -f "${FILE}" ]; then
        bad_exit "No ${FILE} file was found in the directory";
    fi

    mysql -u root -h 127.0.0.1 ${DATABASE} < ${FILE};
fi

# Run inline mysql command
if [[ ! -z $INLINE ]]; then
    echo $INLINE | mysql -u root -h 127.0.0.1 ${DATABASE};
fi
