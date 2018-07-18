#!/bin/bash

export ANT_OPTS="-XX:MaxPermSize=256m"
java -jar $HOME/docker-agent.jar "$@"