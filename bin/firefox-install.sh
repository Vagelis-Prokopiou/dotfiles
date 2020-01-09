#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

command -v wget || (
  echo "Installing wget"
  sudo apt install wget
)

archive_name=firefox.latest.tar.bz2

wget -O "${archive_name}" "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"

if [ ! -d "/opt/firefox" ]; then
  sudo mkdir /opt/firefox
else
  sudo rm -r /opt/firefox/*
fi

tar xjf "${archive_name}" -C /opt/firefox/

if [ ! -f "/usr/lib/firefox-esr/firefox-esr_orig" ]; then
  mv /usr/lib/firefox-esr/firefox-esr /usr/lib/firefox-esr/firefox-esr_orig
else
  sudo rm /usr/lib/firefox-esr/firefox-esr
fi

sudo ln -s /opt/firefox/firefox/firefox /usr/lib/firefox-esr/firefox-esr
rm -rf "${archive_name}"
