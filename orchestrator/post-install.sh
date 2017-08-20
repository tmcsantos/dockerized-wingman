#!/bin/bash

if [ -S "${DOCKER_SOCKET:=/var/run/docker.sock}" ]; then
  DOCKER_GROUP="dockery"
  echo -n "searching docker.sock for group"
  DOCKER_GID=`stat -c '%g' $(realpath "$DOCKER_SOCKET")`
  echo ": $DOCKER_GID"

  # if gid already exists, find the group name and add the user to the group
  # if not create new group with gid and add user to the new group
  cond=`getent group $DOCKER_GID | cut -d: -f1`
  [[ -n "${cond}" ]] && DOCKER_GROUP=${cond}

  echo "adding $USER to $DOCKER_GROUP"
  [[ -z "${cond}" ]] && sudo addgroup -g ${DOCKER_GID} ${DOCKER_GROUP}
  sudo addgroup ${USER} ${DOCKER_GROUP}
fi
