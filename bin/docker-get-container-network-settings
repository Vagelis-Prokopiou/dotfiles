#!/usr/bin/env bash

if [[ "$1" ]]; then
    containerID=$(docker ps | grep -i "$1" | awk '{ print $1 }');
    docker inspect "$containerID" | grep -A50 -i 'networksettings';
else
    echo "Usage: docker-get-container-network-settings <containerName>";
    echo "The avaiable containers are the following:";
    docker ps -a;
fi