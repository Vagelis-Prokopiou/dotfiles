#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

installed_release=$(ffmpeg -version 2>/dev/null | head -n 1 | awk '{print $3}')

# Latest release from html
latest_release=$(curl --silent https://www.ffmpeg.org/download.html | grep 'ffmpeg-.*tar.bz2' | grep small | head -n 1 | sed 's|\s*<small>||; s|</small>||')

echo "installed_release $installed_release"
echo "latest_release $latest_release"

if [ "ffmpeg-${installed_release}.tar.bz2" == "${latest_release}" ]; then
  echo "The installed version (${installed_release}) is the latest."
  # exit 0
fi

# This is needed for building ffmpeg from source
sudo apt install nasm
sudo apt-get install libx264-dev

folder_name=latest.ffmpeg
archive_name="${folder_name}.tar.bz2"
cd /tmp
mkdir "${folder_name}"
wget -O "${archive_name}" "https://ffmpeg.org/releases/${latest_release}"
tar xjf "${archive_name}" --directory "${folder_name}"
cd "${folder_name}" && cd ffmpeg*

./configure --enable-gpl --enable-libx264
make -j8
sudo make install

# Cleanup
cd /tmp
rm -rf "${archive_name}" "${folder_name}"
cd
