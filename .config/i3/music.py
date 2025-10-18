#!/usr/bin/env python3

# requires playerctl, adds music info to i3 bar
# https://i3wm.org/docs/i3bar-protocol.html

import json
import subprocess
import sys


def get_current_music_title():
    title = subprocess.getoutput("playerctl --player=%any,firefox,chromium metadata title")

    if "No players found" in title:
        return ""

    artist = subprocess.getoutput("playerctl --player=%any,firefox,chromium metadata artist")

    if "Twitch" in title:
        return title
    return f"{artist} - {title}"


def print_line(message):
    sys.stdout.write(message + "\n")
    sys.stdout.flush()


def read_line():
    try:
        line = sys.stdin.readline().strip()
        if not line:
            sys.exit(3)
        return line

    except KeyboardInterrupt:
        sys.exit()


if __name__ == "__main__":
    print_line(read_line())
    print_line(read_line())

    while True:
        line, prefix = read_line(), ""

        if line.startswith(","):
            line, prefix = line[1:], ","

        j = json.loads(line)

        music_title = get_current_music_title()

        j.insert(0, {
            "full_text": "%s" % music_title,
            "color": "#32A14F",
            "name": "music_title",
            "separator_block_width": 25
        })

        print_line(prefix + json.dumps(j))
