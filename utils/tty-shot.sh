#!/bin/bash

sudo cat "/dev/vcs`tty | sed 's:.*/::'`" | sed "s:.\{`tput cols`\}:&\n:g"
