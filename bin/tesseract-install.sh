#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

installed_release=$(tesseract --version 2>/dev/null | head -n 1 | awk '{print $2}')

# Latest release from API.
repo="tesseract-ocr/tesseract"
latest_release=$(curl --silent https://api.github.com/repos/${repo}/releases/latest | grep tag_name | awk '{print $2}' | sed 's|"||g; s|,||')

if [ ${installed_release} == ${latest_release} ]; then
  echo "The installed version (${installed_release}) is the latest."
  exit 0
fi

# This is needed for building tesseract from source
sudo apt install libleptonica-dev asciidoc

# Define variables
folder_name="tesseract"
archive_name="${folder_name}.zip"

cd /tmp
url=$(curl --silent https://api.github.com/repos/${repo}/releases/latest | grep zipball_url | cut -d '"' -f 4)
curl -L -o $archive_name $url
unzip $archive_name
cd tesseract-*

./autogen.sh &&
  ./configure &&
  make -j8 &&
  sudo make install &&
  sudo ldconfig &&
  make training &&
  sudo make training-install

#Cleanup
cd /tmp
rm -rf "${archive_name}" "${folder_name}"
cd

# Get languages.
cd /usr/local/share/tessdata
for language in eng heb ell; do
  sudo curl --silent -LO https://github.com/tesseract-ocr/tessdata/raw/master/${language}.traineddata
done
