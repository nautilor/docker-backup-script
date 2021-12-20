#!/usr/bin/env bash

# the folder used to store the dump
DOCKER_DUMP="docker_dump"
DOCKER_LOG="/var/log/docker_backup.log"

# backup the created file with any strategy you like
function backup_docker_dump {
    log_message "E: please implement a backup strategy for '$1'" && exit -1
}

# log a message string to a file
function log_message {
    echo "$1" >> "$DOCKER_LOG"
}

# make a backup of every volume in the docker container
function backup_docker_volumes {
    mkdir "$2/volumes/"
    for volume in `docker inspect -f '{{ range .Mounts }}{{.Source}} {{end}}' $1`
    do
        if [[ ! "$volume" =~ "docker.sock" ]]; then
            cp -r "$volume" "$2/volumes/"
        fi
    done
}

# ~---------------------~
# | PROGRAM STARTS HERE |
# ~---------------------~

# remove previously created dumps
log_message "** removing previous dumps"
rm docker_dump*.zip

# Check if the directory is present
[ ! -d "$DOCKER_DUMP" ] && log_message "** creating missing '$DOCKER_DUMP' directory" && mkdir "$DOCKER_DUMP"

# cycle every container in the system that are either up and running or stopped
for container in `docker ps -a --format '{{ .Names }}'`
do
    log_message "** creating docker dump for container '$container'"
    # create a folder with the container name in the dump directory
    mkdir "$DOCKER_DUMP/$container"
    backup_docker_volumes "$container" "$DOCKER_DUMP/$container"
    # exporr the docker in that specific folder
    docker export $container > "$DOCKER_DUMP/$container/$container.tar"
    
done

log_message "** zipping folder '$DOCKER_DUMP'"

dump_date=`date "+%Y%m%d_%H%M%S"`
filename=`log_message "${DOCKER_DUMP}_${dump_date}.zip"`

# create a zip of the dump folder
zip -r "$filename" "$DOCKER_DUMP"
# remove all the previous dumps created
rm -rf "$DOCKER_DUMP/*"

# backup the docker file somewhere else
backup_docker_dump "$filename"

# removing the created zip file
log_message "** removing $filename"
rm "$filename"