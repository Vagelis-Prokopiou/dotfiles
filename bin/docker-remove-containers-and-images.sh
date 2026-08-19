#!/usr/bin/env bash

docker-remove-containers.sh;
docker rmi -f $(docker images --quiet); # -q, --quiet Only show numeric ID
