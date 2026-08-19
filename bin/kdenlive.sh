#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

# reset; curl https://kdenlive.org/en/download/ | grep '.AppImage' | grep href | awk '{print $6}' | sed 's|href="||; s|"||'
latest_appimage=$(curl -s https://files.kde.org/kdenlive/release/ | grep '<a href="kdenlive-.*appimage"' | sed 's|appimage">kdenlive.*|appimage|g; s|.*href="kdenlive|kdenlive|' | sort | tail -n 1)
latest_appimage=$(curl https://kdenlive.org/en/download/ | grep '.AppImage' | grep href | awk '{print $6}' | sed 's|href="||; s|"||');

directory="/home/$USER/programs"
# Check for the programs directory.
if [ ! -d $directory ]; then
  mkdir -p "$directory"
fi

# Check for the latest version.
# if [ ! -f "$directory/$latest_appimage" ]; then
#   echo "Downloading the latest Kdenlive version..."
#   cd "$directory"
#   rm -rf kdenlive*
#   curl -sLO "https://files.kde.org/kdenlive/release/$latest_appimage"
#   chmod +x "$latest_appimage"

#   # Delete all old config files.
#   find "/home/$USER/" -iname "*kdenlive*" | grep -v programs | grep -v bin | while read -r file; do
#     rm -rf "$file"
#   done
# fi

rm -rf "$directory/kdenlive*";
curl -sLO "$latest_appimage";
chmod +x "kdenlive*";
mv "kdenlive*" $directory;

# Run it.
"$directory/kdenlive*" &
