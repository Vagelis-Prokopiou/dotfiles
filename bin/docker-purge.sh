#!/usr/bin/env bash

docker-remove-containers-and-images.sh
docker system prune -a --volumes -f
