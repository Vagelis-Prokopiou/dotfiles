#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

youtube_video="youtube.mp4";
youtube_audio="youtube.mp3";

cd ~/Videos;
find -type f \( -name "*.mp4" -or -name "*.mp3" \) | grep -v $youtube_video | while read file; do
    rm -rf "$file"; 
done;


cp $youtube_video ${youtube_video}.bak.mp4;

ffmpeg-audio-extract.sh $youtube_video $youtube_audio;

audacity youtube.mp3;

ffmpeg-audio-replace.sh $youtube_video youtube-w-nr.mp3 youtube-w-nr.mp4;

exit 0;