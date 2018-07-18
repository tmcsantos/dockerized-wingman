#!/bin/bash
die() {
  echo -e "$1" >&2
  exit 1
}

info() {
  echo -e "$1"
}

export USERID=`id -u`
export USERGRP=`id -g`
export GIT_USER_NAME="Tiago Santos"
export GIT_USER_EMAIL="tiago.dos.santos@hitachivantara.com"

########## prepare build-buddy agents
dockerImage="build-buddy-8"
#docker rmi ${dockerImage} 2> /dev/null
docker build --rm -t ${dockerImage} \
  --build-arg="UID=$USERID" \
  agent

#test java
echo -n "testing $dockerImage for java"
docker run --rm --entrypoint java ${dockerImage} -version &> /dev/null && \
info " [OK] " || die " [FAILED]"

#test ant
echo -n "testing $dockerImage for ant"
docker run --rm --entrypoint ant ${dockerImage} -version &> /dev/null && \
info " [OK] " || die " [FAILED]"

#test maven
echo -n "testing $dockerImage for maven"
docker run --rm --entrypoint mvn ${dockerImage} -version &> /dev/null && \
info " [OK] " || die " [FAILED]"
################


# build everything first
docker-compose build $@
docker-compose up --no-start $@

# we need to add the user to the docker socket group, we cannot do that in the entrypoint script
# since we need to logout/login to make the new changes visible
#docker-compose start wingman
#docker-compose exec wingman post-install.sh
#docker-compose stop wingman

docker-compose up $@