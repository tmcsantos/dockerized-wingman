#!/bin/bash

[[ -n "$(type -t docker-wrap)" ]] && exit 0

alias ls='ls -F'
alias ll='ls -Fhl'
alias la='ls -Fhal'
alias tailf='tail -f'

# Name: docker_wrap() wrapper
# Purpose: replace host volume /wingman/source with created docker volume, so the docker siblings can find the cloned sources
function docker-wrap() {
  echo "running with $(id)" >> $HOME/docker_history
  local _docker=`which docker2`
  # [[ $# -lt 4 ]] && $_docker $@; exit $?
  local src=$(perl -pe 's|.*/wingman/source/(.*?):.*|\1|g' <<< $@)
  local args=$(perl -pe 's|/tmp/m2rep-thread-\d+|wingman_maven-cache|g and s|'"${HOME}"'/wingman/source/(.*?):|wingman_git-sources:|g and s|"(/home/buildguy/project)"|"\1/'"${src}"'"|g' <<< "$@")
  local docker_args=$(perl -pe 's|(.*build-buddy-\d+).*|\1|g' <<< $args)
  local cmd_args=$(perl -pne 's|.*build-buddy-\d+(.*)|\1|g' <<< $args)
  echo -e "$_docker ${docker_args} \"${cmd_args}\"\n" >> $HOME/docker_history
  $_docker ${docker_args} "${cmd_args}"
}