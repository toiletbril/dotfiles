#!/bin/bash

# Makes a 320kpbs .mp3 out of a each .flac file from a directory.
# Output files have the same filename except for extension.
# Example:
#    ./this_script.sh ~/music
if [[ -z "$1" ]]; then
    echo "USAGE: $0 <dir path>"
    echo "Convert a directory of .flac files to 320kbps .mp3"
    exit 1
fi

find "$1" -iname '*.flac' -exec bash -c 'D=$(dirname "{}"); B=$(basename "{}"); mkdir -p "$D/"; ffmpeg -i "{}" -ab 320k -map_metadata 0 -id3v2_version 3 -acodec libmp3lame "$D/${B%.*}.mp3"' \;
