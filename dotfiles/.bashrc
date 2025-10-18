#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
. "$HOME/.profile"

# If this is not an ssh connection and NO_FISH isn't defined, launsh fish shell.
if [ -z "$NO_FISH" -a -z "$SSH_CONNECTION" ]; then
  echo "Replacing bash with fish..."
  exec fish
fi
