#!/usr/bin/env bash

command -v convert > /dev/null 2>&1;

if [[ $? -gt 0 ]]; then
	echo 'ImageMagick is needed.'
	echo 'Run "sudo apt install imagemagick" to install it, before continuing';
	exit 1;
fi 

# Check for provided width.
if [[ ! $1 ]]; then
	echo "Usage: web-images <targetWidth>";
	exit 1;
fi

# Create the target directory.
mkdir $1 2> /dev/null;

for image in $(find -maxdepth 1 -type f); do
	full_filename=$(basename -- $image);
	filename="${full_filename%.*}";
	extension="${full_filename##*.}";
	convert $image -resize $1 -strip "${1}/${filename}-${1}.${extension}";
done;
