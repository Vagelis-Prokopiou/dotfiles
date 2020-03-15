#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

if [ ! $1 ]; then
    echo "Usage: $0 '<video_url>'";
    exit 1;
fi

target_file=youtube.subs.txt
echo $(curl -s $1 | grep utf8 | sed 's|.*Music.*||; s|.*: "||g; s|",||; s|^ ||; s|\\n"||') > $target_file;
echo -e "Done. Run \ncat ${target_file}\nto check the result";


