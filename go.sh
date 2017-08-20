#!/bin/bash

export USERID=`id -u`
export GIT_USER_NAME="Tiago Santos"
export GIT_USER_EMAIL="tsantos@pentaho.com"

realpath() {
  OURPWD=${PWD}
  cd "$(dirname "${1}")"
  LINK=$(readlink "$(basename "${1}")")
  while [ "${LINK}" ]; do
    cd "$(dirname "${LINK}")"
    LINK=$(readlink "$(basename "${LINK}")")
  done
  REALPATH="${PWD}/$(basename "${LINK}")"
  cd "${OURPWD}"
  echo "${REALPATH}"
}

detectOS() {
  darwin=false;
  case "`uname`" in
    Darwin*)
      darwin=true
      ;;
  esac
}

if [ -S "${DOCKER_SOCKET:=/var/run/docker.sock}" ]; then
  echo -n "searching docker socket group"
  if $darwin; then
    export DOCKER_GID=`stat -f '%g' $(realpath "$DOCKER_SOCKET")`
  else
    export DOCKER_GID=`stat -c '%g' $(realpath "$DOCKER_SOCKET")`
  fi
  echo ": $DOCKER_GID"
fi

docker-compose build $@
docker-compose up $@