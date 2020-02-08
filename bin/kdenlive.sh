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
  echo "Downloading the latest Kdenlive version..."
  cd "$directory"
  rm -rf kdenlive*
  curl -sLO "https://files.kde.org/kdenlive/release/$latest_appimage"
  chmod +x "$latest_appimage"

  # Delete all old config files.
  find "/home/$USER/" -iname "*kdenlive*" | grep -v programs | grep -v bin | while read -r file; do
    rm -rf "$file"
  done
fi

# Run it.
"$directory/$latest_appimage" &
