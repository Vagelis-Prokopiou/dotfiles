#!/usr/bin/env bash

docker stop --timeout 0 $(docker ps -a -q);
