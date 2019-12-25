#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

latest_appimage=$(curl -s https://files.kde.org/kdenlive/release/ | grep '<a href="kdenlive-.*appimage"' | sed 's|appimage">kdenlive.*|appimage|g; s|.*href="kdenlive|kdenlive|' | sort | tail -n 1)

directory="/home/$USER/programs"
# Check for the programs directory.
if [ ! -d $directory ]; then
  mkdir -p "$directory"
fi

# Check for the latest version.
if [ ! -f "$directory/$latest_appimage" ]; then
  cd "$directory"
  rm -rf kdenlive*
  wget "https://files.kde.org/kdenlive/release/$latest_appimage"
  chmod +x "$latest_appimage"
fi

# Delete all old config files.
find ~ -iname "*kdenlive*" | grep -v programs | grep -v bin | while read -r file; do
  rm -rf "$file"
done

# Run it.
"$directory/$latest_appimage"
