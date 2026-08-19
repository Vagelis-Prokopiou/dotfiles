#!/usr/bin/env bash

docker-stop-containers.sh;
docker rm -f $(docker ps -a -q);
