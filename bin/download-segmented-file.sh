#!/bin/bash

# Script to download and merge m3u8 streams into mp4
# Usage: ./download-segmented-file.sh <m3u8_url> [output_filename]

set -e

# Check if URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <m3u8_url> [output_filename]"
    echo "Example: $0 https://example.com/playlist.m3u8 output.mp4"
    exit 1
fi

M3U8_URL="$1"

# Create unique output filename if not provided
if [ -z "$2" ]; then
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    RANDOM_ID=$(head /dev/urandom | tr -dc a-z0-9 | head -c 6)
    OUTPUT_FILE="video_${TIMESTAMP}_${RANDOM_ID}.mp4"
else
    OUTPUT_FILE="$2"
fi

# Create temporary directory for segments (already unique per mktemp)
TEMP_DIR=$(mktemp -d)
echo "Created temporary directory: $TEMP_DIR"
echo "Output file will be: $OUTPUT_FILE"

# Cleanup function
cleanup() {
    echo "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Download m3u8 file
echo "Downloading m3u8 playlist..."
M3U8_FILE="$TEMP_DIR/playlist.m3u8"
curl -s -L "$M3U8_URL" -o "$M3U8_FILE"

if [ ! -f "$M3U8_FILE" ]; then
    echo "Error: Failed to download m3u8 file"
    exit 1
fi

echo "Playlist downloaded successfully"
echo "----------------------------------------"
cat "$M3U8_FILE"
echo "----------------------------------------"

# Extract base URL from m3u8 URL
BASE_URL=$(dirname "$M3U8_URL")

# Extract segment URLs from m3u8 file
echo "Extracting segment URLs..."
# Create array of segments (only non-empty, non-comment lines)
mapfile -t SEGMENTS < <(grep -v '^#' "$M3U8_FILE" | grep -v '^$')

# Count segments
SEGMENT_COUNT=${#SEGMENTS[@]}
echo "Found $SEGMENT_COUNT segments to download"

# Download all segments
SEGMENT_LIST="$TEMP_DIR/segments.txt"
> "$SEGMENT_LIST"

for i in "${!SEGMENTS[@]}"; do
    SEGMENT_NUM=$((i + 1))
    segment="${SEGMENTS[$i]}"

    # Handle relative and absolute URLs
    if [[ "$segment" =~ ^https?:// ]]; then
        SEGMENT_URL="$segment"
    else
        SEGMENT_URL="$BASE_URL/$segment"
    fi

    # Download segment
    SEGMENT_FILE="$TEMP_DIR/segment_$(printf "%05d" $SEGMENT_NUM).ts"
    echo "[$SEGMENT_NUM/$SEGMENT_COUNT] Downloading segment..."
    curl -s -L "$SEGMENT_URL" -o "$SEGMENT_FILE"

    # Verify download
    if [ ! -s "$SEGMENT_FILE" ]; then
        echo "Warning: Failed to download segment $SEGMENT_NUM"
    fi

    # Add to segment list for concatenation
    echo "file '$SEGMENT_FILE'" >> "$SEGMENT_LIST"
done

echo "All segments downloaded successfully"

# Merge segments using ffmpeg
echo "Merging segments into $OUTPUT_FILE..."
if command -v ffmpeg &> /dev/null; then
    ffmpeg -f concat -safe 0 -i "$SEGMENT_LIST" -c copy -bsf:a aac_adtstoasc "$OUTPUT_FILE" -y
    echo "Success! Output saved to: $OUTPUT_FILE"
else
    echo "Error: ffmpeg is not installed. Installing ffmpeg is required to merge segments."
    echo "Segments are saved in: $TEMP_DIR"
    trap - EXIT  # Don't cleanup so user can access segments
    exit 1
fi

echo "Done!"
