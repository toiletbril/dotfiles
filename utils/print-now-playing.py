#!/usr/bin/env python3

# Script to get nice player output for generic monitors, using playerctl.
# Tested with playerctl v2.4.1

import json
import subprocess
import sys

max_len: int = 42

def get_current_music_title():
    # First goes the player, only then any browsers
    query = "playerctl --player=%any,firefox,chromium metadata "
    title = subprocess.getoutput(query + "title")
    # Nothing is playing
    if title == "No players found":
        return ""
    artist = subprocess.getoutput(query + "artist")
    # No artist (watching a video)
    if artist == "":
        return title
    return f"{artist} - {title}"

if __name__ == '__main__':
    data = get_current_music_title()
    length = len(data)
    if length > 0:
        # Cut by maximum width and add an ellipsis
        if length > max_len:
            data = data[:max_len - 3]
            data += "..."
        sys.stdout.write(f"  ♪ {data}  ")
    else:
        # No music is playing
        sys.stdout.write(" 🔇♪ ")
    sys.stdout.flush()
