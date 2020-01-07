#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

# Instructions from https://wiki.audacityteam.org/wiki/Building_On_Linux (Steve Daulton. Updated 04Dec2019)

installed_release=$(audacity --version 2>/dev/null | awk '{print $2}')

# Latest release from html
# latest_release=$(curl -s 'https://github.com/audacity/audacity/releases' | grep 'tag/Audacity-' | head -n 1 | sed 's|">.*||; s|.*tag/||')

# Latest release from API.
latest_release=$(curl --silent https://api.github.com/repos/audacity/audacity/releases/latest | grep tag_name | awk '{print $2}' | sed 's|"||g; s|,||')

if [ "$(echo ${installed_release} | sed 's|v|Audacity-|')" == "${latest_release}" ]; then
  echo "The installed version (${installed_release}) is the latest."
  exit 0
fi

sudo apt install -y build-essential
sudo apt install -y cmake
sudo apt install -y gcc
sudo apt install -y libsndfile1
sudo apt install -y libasound2-dev
sudo apt install -y libgtk2.0-dev
sudo apt install -y gettext
sudo apt install -y libid3tag0-dev
sudo apt install -y libmad0-dev
sudo apt install -y libsoundtouch-dev
sudo apt install -y libogg-dev
sudo apt install -y libvorbis-dev
sudo apt install -y libflac-dev
sudo apt install -y libmp3lame0
sudo apt install -y libavformat-dev
sudo apt install -y jackd2
sudo apt install -y libjack-jackd2-dev

# Wxwidgets
sudo apt install -y libwxgtk3.0

cd /tmp
git clone https://github.com/audacity/audacity.git
cd audacity
git checkout "$latest_release"
mkdir build && cd build
../configure --with-lib-preference="local system" --with-ffmpeg="system" --disable-dynamic-loading --with-mod-script-pipe
make -j8

# Building Mod Script Pipe
cd lib-src/mod-script-pipe
make -j8

#To install the main application, from the build directory:
cd /tmp/audacity/build
sudo make install

# To install Mod Script Pipe
# Assuming that Audacity has been installed to /usr/local/ (default)
sudo rm -rf /usr/local/share/audacity/modules
sudo mkdir -p /usr/local/share/audacity/modules
sudo cp lib-src/mod-script-pipe/.libs/mod-script-pipe.so /usr/local/share/audacity/modules/mod-script-pipe.so
sudo cp lib-src/mod-script-pipe/.libs/mod-script-pipe.so.0.0.0 /usr/local/share/audacity/modules/mod-script-pipe.so.0.0.0
# The module will now be available for enabling in Preferences (https://manual.audacityteam.org/man/modules_preferences.html)

cd && rm -rf /tmp/audacity
