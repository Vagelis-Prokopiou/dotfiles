#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

command -v curl > /dev/null 2>&1 || { echo "curl is required but it's not installed."; exit 1; }
command -v git > /dev/null 2>&1 || { echo "git is required but it's not installed."; exit 1; }

if [[ -n "$1" ]]; then
    curl "${1}" | git apply -v;
    exit 0;    
fi

echo "Usage: git-patch-apply-from-url <url>";
exit 1;
