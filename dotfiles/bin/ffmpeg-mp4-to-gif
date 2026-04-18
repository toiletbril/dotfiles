#!/bin/bash

# Makes a GIF out of a video.
# Example:
#    ./this_script.sh video.mp4
if ! [ "$1" ]; then
    echo "USAGE: $0 <file> [scale=480] [ffmpeg flags after -i]"
    exit 1
fi

FILE="${1%.*}.gif"
SCALE="${2:-'480'}"
FLAGS="${@:3}"

echo "Converting..."

ffmpeg \
    -hide_banner \
    -loglevel error \
    -i $1 \
    -filter_complex "fps=15,scale=$SCALE:-1:flags=lanczos,split [o1] [o2]; [o1] palettegen [p]; [o2] fifo [o3];[o3] [p] paletteuse" \
    $FLAGS \
    $FILE \
&& \
du -h $FILE
