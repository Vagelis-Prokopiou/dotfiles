#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

docker-remove-containers.sh;
docker rmi -f $(docker images --quiet); # -q, --quiet Only show numeric ID