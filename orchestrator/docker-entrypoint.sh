#!/bin/bash

# set -eo pipefail

# SIGTERM-handler
term_handler() {
  echo "stopping wingman"
  local karaf_pid=$(cat $WINGMAN_HOME/karaf.pid)
  $WINGMAN_HOME/bin/stop

  while kill -0 ${karaf_pid} > /dev/null 2>&1; do
    wait
  done
}

# setup handlers
trap "term_handler" SIGINT SIGTERM

export KARAF_OPTS="$KARAF_OPTS -Djava.security.egd=file:/dev/./urandom"

exec "$@" &
pid="$!"

# Let's wrap it in a loop that doesn't end before the process is indeed stopped
while kill -0 $pid > /dev/null 2>&1; do
  wait
done