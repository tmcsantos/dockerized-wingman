#!/bin/bash

export USERID=`id -u`
export GIT_USER_NAME="Tiago Santos"
export GIT_USER_EMAIL="tsantos@pentaho.com"

# build everything first
docker-compose build $@
docker-compose create $@

# we need to add the user to the docker socket group, we cannot do that in the entrypoint script
# since we need to logout/login to make the new changes visible
docker-compose start wingman
docker-compose exec wingman post-install.sh
docker-compose stop wingman

docker-compose up $@