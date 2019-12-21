#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

# See: http://stackoverflow.com/questions/7333232/concatenate-two-mp4-files-using-ffmpeg
# The "-safe 0" disables the safe mode due to "unsafe files" error.

files_list="list.txt";
output_file="youtube.mp4";

#n Create the list of files.
find . -maxdepth 1 -type f | sort | while read -r file; do
  echo "file '$file'" >> "${files_list}";
done;

ffmpeg -f concat -safe 0 -i "${files_list}" -codec copy "${output_file}";
rm -rf "${files_list}";