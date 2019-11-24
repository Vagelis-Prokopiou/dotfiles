#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

cd ~/Downloads;

# Get the package.
wget "https://www.torproject.org$(curl -s https://www.torproject.org/download/ | grep downloadLink | grep linux | awk '{ print $3}' | cut -d'"' -f 2)";

# Unzip it.
mkdir tor && tar -xvf tor-browser-linux*tar.xz -C tor;

rm -rf tor-browser-linux*tar.xz;

# Find the executable
bash ~/Downloads/tor/start-tor-browser;
