#!/usr/bin/env bash

find . -type f | while read file;
do
    mv "${file}" $(echo "${file}" | sed -e 's/[^A-Za-z0-9._-]/_/g; s/^._//; s/_\+/_/g; s/-\+/-/g; s/_-_/_/g; s/-*[a-zA-Z0-9]*\././g');
done;