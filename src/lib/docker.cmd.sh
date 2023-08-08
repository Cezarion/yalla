# Docker paths
CWD="/shared/httpd"
CURRENT_DIR_NAME=${PWD##*/}
CURRENT_DIR_PATH=${PWD}

# Docker shortcuts
readonly compose_file="${DEVILBOX_LOCAL_PATH}/docker-compose.yml"
readonly docker_cmd="docker-compose -f ${compose_file}"
readonly docker_exec="${docker_cmd} exec --user devilbox php env TERM=xterm /bin/sh -c"
readonly docker_mysql_cmd="${docker_cmd} exec --user devilbox php env mysql -h 127.0.0.1 -u root"
