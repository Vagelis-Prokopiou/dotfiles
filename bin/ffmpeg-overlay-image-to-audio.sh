#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

# See: https://superuser.com/questions/1041816/combine-one-image-one-audio-file-to-make-one-video-using-ffmpeg

echo "Recomended lossless codec: m4a"

if [ $# -lt 2 ]; then
  echo "Missing arguments."
  echo "Usage: $0 <image> <audio_file>"
  exit 1
fi

image="${1}"
audio_file="${2}"
output_file=audio_w_image.mp4

ffmpeg -r 1 -loop 1 -i "${image}" -i "${audio_file}" -acodec copy -r 1 -shortest -vf scale=1280:720 ./"${output_file}"

exit 0
