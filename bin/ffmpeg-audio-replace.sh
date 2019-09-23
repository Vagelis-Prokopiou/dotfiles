#!/usr/bin/env bash

# See: http://stackoverflow.com/questions/9913032/ffmpeg-to-extract-audio-from-video
if [ $# -lt 3 ]; then
    echo "Missing arguments.";
    echo "Usage: ffmpeg-audio-replace <videoFile> <audioFile> <outputFile>";
    exit 1;
fi

videoFile="${1}";
audioFile="${2}";
outputFile="${3}";
ffmpeg -i ${videoFile} -i ${audioFile} -c:v copy -map 0:v:0 -map 1:a:0 "${outputFile}";

exit 0;