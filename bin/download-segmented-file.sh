#!/bin/bash

help() {
  echo ""
  echo "Run the script by providing the master.m3u8 url, which has the form:"
  echo "https://s29.wolfstream.tv/hls/aoqo7chc5kr5fwfuh27bk5q3lgo456s5kkuhxkoys,siua76tccwp63ccqhwa,y6ua76tccwoqrffdzka,6vuc76tccwlxnzhynbq,.urlset/master.m3u8"
  echo "The script uses youtube-dl under the hood."
  echo "Example usage:"
  echo "$0 <url>"
  echo ""
}

# if [ ! "$2" ]; then
if [ ! "$1" ]; then
  help
  exit 1
fi

if ! command -v youtube-dl &> /dev/null
then
    echo -e "\nyoutube-dl not found. Please install.\n"
    exit 1
fi

# Create a temp dir
tmpDir=/tmp/movie
echo "Creating tmp dir: $tmpDir"
mkdir -p $tmpDir
cd $tmpDir
rm -rf ./*

# Set the variables.
url="$1"

# See https://stackoverflow.com/questions/22188332/download-ts-files-from-video-stream (youtube-dl)
# Get the best of the available formats
format=$(youtube-dl -F "${url}" | grep best | awk '{print $1}');

# Download
youtube-dl --format ${format} ${url}

ls -1
vlc ./*.mp4
