#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

docker-stop-containers;
docker rm -f $(docker ps -a -q);