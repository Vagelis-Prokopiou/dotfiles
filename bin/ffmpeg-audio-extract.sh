#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

# See: http://stackoverflow.com/questions/9913032/ffmpeg-to-extract-audio-from-video

echo "Recomended lossless codec: m4a";

if [ $# -lt 2 ]; then
    echo "Missing arguments.";
    echo "Usage: ffmpeg-audio-extract <videoFile> <outputFile>";
    exit 1;
fi

videoFile="${1}";
outputFile="${2}";
ffmpeg -i "${videoFile}" -vn -acodec copy "${outputFile}";

exit 0;